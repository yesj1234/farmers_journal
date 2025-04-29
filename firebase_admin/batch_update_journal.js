const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();
const db = admin.firestore();

// Delay helper
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Convert Firestore Timestamp to 'yyyy-mm-dd'
function timestampToDateString(timestamp) {
  const date = new Date(timestamp._seconds * 1000);
  const year = date.getFullYear();
  const month = `${date.getMonth() + 1}`.padStart(2, '0');
  const day = `${date.getDate()}`.padStart(2, '0');
  return `${year}-${month}-${day}`;
}

// Retry wrapper for API call with exponential backoff
async function fetchWeatherWithRetry(url, retries = 3, delayMs = 1000) {
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      const status = error.response?.status;
      if ((status === 429 || status === 504) && attempt < retries - 1) {
        console.warn(`API limit or timeout. Retrying attempt ${attempt + 1} after ${delayMs}ms...`);
        await sleep(delayMs);
        delayMs *= 2; // Exponential backoff
      } else {
        throw error;
      }
    }
  }
}

async function updateWeatherForUsers() {
  const usersSnapshot = await db.collection('users').get();

  for (const userDoc of usersSnapshot.docs) {
    const userData = userDoc.data();
    const { journals, plants } = userData;

    if (!journals || !plants || plants.length === 0) continue;

    const plant = plants[0]; // Only use the first plant for now

    for (let i = 0; i < journals.length; i++) {
      const journalId = journals[i];

      try {
        const journalRef = db.collection('journals').doc(journalId);
        const journalSnap = await journalRef.get();

        if (!journalSnap.exists) continue;

        const journalData = journalSnap.data();
        const { date, temperature, weatherCode } = journalData;

        if (!date || !plant.lat || !plant.lng) continue;
        if (temperature || weatherCode) continue;

        const formattedDate = timestampToDateString(date);

        const url = `https:\/\/archive-api.open-meteo.com/v1/archive?latitude=${plant.lat}&longitude=${plant.lng}&start_date=${formattedDate}&end_date=${formattedDate}&daily=weather_code&hourly=temperature_2m,weather_code`;

        const weatherData = await fetchWeatherWithRetry(url);

        const temperature_2m = weatherData?.hourly?.temperature_2m?.[0] ?? null;
        const weather_code = weatherData?.daily?.weather_code?.[0] ?? null;

        await journalRef.update({
          weatherCode: weather_code,
          temperature: temperature_2m,
        });

        console.log(`✅ Updated weather for journal ${journalId}`);
      } catch (error) {
        console.error(`❌ Error updating journal ${journalId}:`, error.message);
      }

      await sleep(500); // Rate limit: 2 requests per second
    }
  }
}

updateWeatherForUsers()
  .then(() => console.log('🎉 Weather update complete.'))
  .catch(console.error);
