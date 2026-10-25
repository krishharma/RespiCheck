# AI placeholders

These folders are empty on purpose. RespiCheck does not ship a trained cough or pneumonia model. After a recording, the app still returns the simulated moderate result in `AudioAnalyzerViewModel`.

Put a real model here later. Until `CoughRiskModel.predict` returns a value and the view model calls it, nothing in this directory changes the app.

| Folder | What belongs here |
|---|---|
| `models/` | One Core ML file, `CoughRiskClassifier.mlmodel` |
| `features/` | Code that turns a cough recording into model inputs |
| `training/` | The script that produces the Core ML file |
| `evaluation/` | Held-out metrics for that model |
| `inference/` | The Swift type the app should call |
| `data/` | Notes about training data. Do not commit recordings or the chest X-ray archive |
