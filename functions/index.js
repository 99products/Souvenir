const path = require('path');
const os = require('os');
const fs = require('fs');
const crypto = require('crypto');
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const Busboy = require('busboy');
const { NFTStorage, File } = require('nft.storage');
const { info: log } = functions.logger;
admin.initializeApp();
const bucket = admin.storage().bucket('explorer-1aca6.appspot.com');
const db = admin.firestore();
const collectionItemRef = db.collection('collection_items');
const collectionRegionRef = db.collection('collection_regions');
const NFT_STORAGE_API_KEY = functions.config().souvenir.nft_storage_api_key;
const client = new NFTStorage({ token: NFT_STORAGE_API_KEY })


exports.createCollectionItem = functions.https.onRequest((request, response) => {

	try {
		if (request.method !== 'POST') {
			return response.status(405).end();
		}

		const busboy = new Busboy({ headers: request.headers });
		const tmpdir = os.tmpdir();
		const fields = {};
		const uploads = {};
		const fileWrites = [];

		busboy.on('field', (fieldname, val) => {
			log(`Processed field ${fieldname}: ${val}.`, { structuredData: true });
			fields[fieldname] = val;
		});

		busboy.on('file', (fieldname, file, filename) => {
			log(`Processed file ${filename}`, { structuredData: true });
			const filepath = path.join(tmpdir, filename);
			uploads[fieldname] = filepath;

			const writeStream = fs.createWriteStream(filepath);
			file.pipe(writeStream);

			const promise = new Promise((resolve, reject) => {
				file.on('end', () => {
					writeStream.end();
				});
				writeStream.on('finish', resolve);
				writeStream.on('error', reject);
			});
			fileWrites.push(promise);
		});

		busboy.on('finish', async () => {
			await Promise.all(fileWrites);
			let fileLink = {};
			for (const file in uploads) {
				const uploadResponse = await bucket.upload(uploads[file]);
				log(`Uploaded file ${file}`, { structuredData: true });
				fileLink[file] = uploadResponse[0].metadata.mediaLink;
				if (file === 'image') {
					const { url } = await getMetaDataURL(uploads[file], fields);
					fileLink['metaURL'] = url;
				}
				fs.unlinkSync(uploads[file]);
			}

			const { id, description, title, latitude, longitude } = fields;
			const collectionItem = {
				id,
				description,
				title,
				imageURL: fileLink['image'],
				thumbnailImageURL: fileLink['thumbnailImage'],
				metaURL: fileLink['metaURL'],
				latitude,
				longitude,
				dateCreated: new Date().toISOString()
			};
			collectionItemRef.add(collectionItem)
			response.send(collectionItem);
		});

		busboy.end(request.rawBody);
	} catch (error) {
		log(`Error adding collection item ${error}`, { structuredData: true });
	}

});

exports.createCollectionRegion = functions.https.onRequest((request, response) => {

	try {
		if (request.method !== 'POST') {
			return response.status(405).end();
		}

		const busboy = new Busboy({ headers: request.headers });
		const tmpdir = os.tmpdir();
		const fields = {};
		const uploads = {};
		const fileWrites = [];

		busboy.on('field', (fieldname, val) => {
			log(`Processed field ${fieldname}: ${val}.`, { structuredData: true });
			fields[fieldname] = val;
		});

		busboy.on('file', (fieldname, file, filename) => {
			log(`Processed file ${filename}`, { structuredData: true });
			const filepath = path.join(tmpdir, filename);
			uploads[fieldname] = filepath;

			const writeStream = fs.createWriteStream(filepath);
			file.pipe(writeStream);

			const promise = new Promise((resolve, reject) => {
				file.on('end', () => {
					writeStream.end();
				});
				writeStream.on('finish', resolve);
				writeStream.on('error', reject);
			});
			fileWrites.push(promise);
		});

		busboy.on('finish', async () => {
			await Promise.all(fileWrites);
			const uploadResponse = await bucket.upload(uploads['image'])
			log(`Uploaded file ${uploads['image']}`, { structuredData: true });
			const { description, id, itemsCount, shortDescription, title } = fields;
			const collectionRegion = {
				description,
				id,
				itemsCount,
				shortDescription,
				title,
				imageURL: uploadResponse[0].metadata.mediaLink,
				dateCreated: new Date().toISOString()
			};
			collectionRegionRef.add(collectionRegion)
			log(`Added collection region ${id}`, { structuredData: true });
			for (const file in uploads) {
				fs.unlinkSync(uploads[file]);
			}
			response.send(collectionRegion);
		});

		busboy.end(request.rawBody);
	} catch (error) {
		log(`Error adding collection region ${error}`, { structuredData: true });
	}
});


const getMetaDataURL = async (imageFilePath, fields) => {
	const { title, description, latitude, longitude, id } = fields;
	try {
		return await client.store({
			name: title,
			description,
			image: new File([await fs.promises.readFile(imageFilePath)], 'sov.jpg', { type: 'image/jpg' }),
			attributes: {
				latitude: {
					type: 'string',
					value: latitude
				},
				longitude: {
					type: 'string',
					value: longitude
				},
				souvenirId: {
					type: 'string',
					value: id
				}
			}
		})
	} catch (error) {
		console.log('NFT.Storage error', error)
	}
}
