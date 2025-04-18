const { Firestore } = require('@google-cloud/firestore');
const { Client } = require("@googlemaps/google-maps-services-js");

const firestore = new Firestore({ projectId: 'farmers-journal-7f2cc' });
const client = new Client({});

async function batchUpdateLatLng() {
    const usersRef = firestore.collection('users');
    const querySnapshot = await usersRef.get();

    if (querySnapshot.empty) {
        console.log('No user documents found.');
        return;
    }

    for (const docSnapshot of querySnapshot.docs) {
        const userId = docSnapshot.id;
        const plants = docSnapshot.get('plants') || [];

        const updatedPlants = await Promise.all(plants.map(async (plant) => {
            if (plant.place && (!plant.lat || !plant.lng)) {
                try {
                    const response = await client.geocode({
                        params: {
                            address: plant.place,
                            key: 'APIKEY',
                        },
                    });

                    const location = response.data.results[0]?.geometry?.location;
                    if (location) {
                        return {
                            ...plant,
                            lat: location.lat,
                            lng: location.lng,
                        };
                    }
                } catch (error) {
                    console.error(`Geocoding failed for plant ${plant.id}:`, error.message);
                }
            }
            return plant; // return unchanged if already has lat/lng or geocoding fails
        }));

        await firestore.collection('users').doc(userId).update({
            plants: updatedPlants,
        });

        console.log(`Updated user ${userId} with lat/lng info.`);
    }
}

batchUpdateLatLng();
