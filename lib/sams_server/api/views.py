from django.http import JsonResponse
from django.http import JsonResponse
from rest_framework.views import APIView
import pickle
import numpy as np
from statistics import mode
import os
from collections import Counter

class PredictDisease(APIView):
    def post(self, request):
        symptoms = request.data["symptoms"]

        base_dir = os.path.dirname(__file__)

        svm_model_path = os.path.join(base_dir, "final_svm_model.pkl")
        final_svm_model = pickle.load(open(svm_model_path, "rb"))

        nb_model_path = os.path.join(base_dir, "final_nb_model.pkl")
        final_nb_model = pickle.load(open(nb_model_path, "rb"))

        rf_model_path = os.path.join(base_dir, "final_rf_model.pkl")
        final_rf_model = pickle.load(open(rf_model_path, "rb"))

        encoder_path = os.path.join(base_dir, "encoder.pkl")
        encoder = pickle.load(open(encoder_path, "rb"))

        symptomslist = [
            "itching",
            "skin rash",
            "nodal skin eruptions",
            "continuous sneezing",
            "shivering",
            "chills",
            "joint pain",
            "stomach pain",
            "acidity",
            "ulcers on tongue",
            "muscle wasting",
            "vomiting",
            "burning micturition",
            "spotting urination",
            "fatigue",
            "weight gain",
            "anxiety",
            "cold hands and feets",
            "mood swings",
            "weight loss",
            "restlessness",
            "lethargy",
            "patches in throat",
            "irregular sugar level",
            "cough",
            "high fever",
            "sunken eyes",
            "breathlessness",
            "sweating",
            "dehydration",
            "indigestion",
            "headache",
            "yellowish skin",
            "dark urine",
            "nausea",
            "loss of appetite",
            "pain behind the eyes",
            "back pain",
            "constipation",
            "abdominal pain",
            "diarrhoea",
            "mild fever",
            "yellow urine",
            "yellowing of eyes",
            "acute liver failure",
            "fluid overload",
            "swelling of stomach",
            "swelled lymph nodes",
            "malaise",
            "blurred and distorted vision",
            "phlegm",
            "throat irritation",
            "redness of eyes",
            "sinus pressure",
            "runny nose",
            "congestion",
            "chest pain",
            "weakness in limbs",
            "fast heart rate",
            "pain during bowel movements",
            "pain in anal region",
            "bloody stool",
            "irritation in anus",
            "neck pain",
            "dizziness",
            "cramps",
            "bruising",
            "obesity",
            "swollen legs",
            "swollen blood vessels",
            "puffy face and eyes",
            "enlarged thyroid",
            "brittle nails",
            "swollen extremeties",
            "excessive hunger",
            "extra-marital contacts",
            "drying and tingling lips",
            "slurred speech",
            "knee pain",
            "hip joint pain",
            "muscle weakness",
            "stiff neck",
            "swelling joints",
            "movement stiffness",
            "spinning movements",
            "loss of balance",
            "unsteadiness",
            "weakness of one body side",
            "loss of smell",
            "bladder discomfort",
            "foul smell of urine",
            "continuous feel of urine",
            "passage of gases",
            "internal itching",
            "toxic look (typhos)",
            "depression",
            "irritability",
            "muscle pain",
            "altered sensorium",
            "red spots over body",
            "belly pain",
            "abnormal menstruation",
            "dischromic patches",
            "watering from eyes",
            "increased appetite",
            "polyuria",
            "family history",
            "mucoid sputum",
            "rusty sputum",
            "lack of concentration",
            "visual disturbances",
            "receiving blood transfusion",
            "receiving unsterile injections",
            "coma",
            "stomach bleeding",
            "distention of abdomen",
            "history of alcohol consumption",
            "fluid overload",
            "blood in sputum",
            "prominent veins on calf",
            "palpitations",
            "painful walking",
            "pus-filled pimples",
            "blackheads",
            "scurring",
            "skin peeling",
            "silver-like dusting",
            "small dents in nails",
            "inflammatory nails",
            "blister",
            "red sore around nose",
            "yellow crust ooze",
        ]
        # Prepare the input data
        input_data = [0] * len(symptomslist)
        for symptom in symptoms:
            index = symptomslist.index(symptom)
            input_data[index] = 1
        input_data = np.array(input_data).reshape(1, -1)
        # Make the predictions
        svm_prediction = encoder.classes_[final_svm_model.predict(input_data)[0]]
        nb_prediction = encoder.classes_[final_nb_model.predict(input_data)[0]]
        rf_prediction = encoder.classes_[final_rf_model.predict(input_data)[0]]

        # Get prediction probabilities
        svm_prob = max(final_svm_model.predict_proba(input_data)[0])
        nb_prob = max(final_nb_model.predict_proba(input_data)[0])
        rf_prob = max(final_rf_model.predict_proba(input_data)[0])

        # Combine predictions and probabilities
        predictions_with_confidence = {svm_prediction: svm_prob, nb_prediction: nb_prob, rf_prediction: rf_prob}

        # Sort by confidence
        sorted_predictions = sorted(predictions_with_confidence.items(), key=lambda item: item[1], reverse=True)
        
        # The final prediction is the one with the highest confidence score
        final_prediction, final_confidence = sorted_predictions[0]

        # Return the predictions
        return JsonResponse(
            {
                "svm_prediction": svm_prediction,
                "svm_confidence": svm_prob,
                "nb_prediction": nb_prediction,
                "nb_confidence": nb_prob,
                "rf_prediction": rf_prediction,
                "rf_confidence": rf_prob,
                "final_prediction": final_prediction,
                "final_confidence": final_confidence,
            }
        )