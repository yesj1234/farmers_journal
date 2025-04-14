const { Firestore } = require('@google-cloud/firestore');

// Replace with your actual project ID
const projectId = 'farmers-journal-7f2cc';

const firestore = new Firestore({ projectId });

async function updateJournalsToPublic() {
  const journalsRef = firestore.collection('journals');
  const snapshot = await journalsRef.get();

  if (snapshot.empty) {
    console.log('No journal documents found.');
    return;
  }

  console.log(`Updating ${snapshot.size} journals...`);

  const batchSize = 500; // Firestore max writes per batch
  let batch = firestore.batch();
  let count = 0;

  for (const doc of snapshot.docs) {
    batch.update(doc.ref, { isPublic: true });
    count++;

    if (count % batchSize === 0) {
      await batch.commit();
      console.log(`Committed ${count} updates...`);
      batch = firestore.batch(); // Start a new batch
    }
  }

  if (count % batchSize !== 0) {
    await batch.commit();
    console.log(`Committed remaining ${count % batchSize} updates.`);
  }

  console.log('All journal documents updated with isPublic: true.');
}

updateJournalsToPublic().catch(console.error);
