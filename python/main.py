from venv import logger
import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
from datetime import date, datetime

cred = credentials.Certificate("loga-parameshwari-firebase-adminsdk.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
COLLECTION_NAME = 'SpecialDates'
data = {
    'date':[],
    'pooja':[],
}

# Backup
source = db.collection(COLLECTION_NAME)
for doc in source.stream():
    logger.debug("Reading :::", doc.id)
    doc_data = doc.to_dict()
    try:
        data['date'].append(date.fromtimestamp(doc_data['date'].timestamp()))
        data['pooja'].append(doc_data['pooja'])
    except Exception as e:
        db.collection(COLLECTION_NAME).document(doc.id).delete()

df = pd.DataFrame(data=data)
csv_file=r"csv\SpecialDates.csv"
logger.debug("Generating CSV under",csv_file)
df.to_csv(csv_file, index=False)

# Delete Entry
for doc in source.stream():
    logger.debug("Deleting :::", doc.id)
    db.collection(COLLECTION_NAME).document(doc.id).delete()

# Write
target = db.collection(COLLECTION_NAME)
csv_file=r"csv\SpecialDatesWrite.csv"
df = pd.read_csv(csv_file)
col = []
for c in df:
    col.append(str(c))

for rid in range(df.shape[0]):
    w = {}
    for cid in range(df.shape[1]):
        if col[cid] != 'date':
            w[col[cid]] = df.iloc[rid, cid]
        else:
            w[col[cid]] = datetime.strptime(df.iloc[rid, cid], '%d-%m-%Y')
    id = str(datetime.now().strftime('%Y%m%d%H%M%S%f') )
    logger.debug("Writeing :::", id)
    target.document(id).set(w)
