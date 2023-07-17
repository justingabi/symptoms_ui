import pandas as pd
import numpy as np
import pickle
from sklearn import svm
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import RandomForestClassifier
from scipy.stats import mode

# Load the training and testing datasets
train_data = pd.read_csv("Training.csv").dropna(axis = 1)
test_data = pd.read_csv("Testing.csv").dropna(axis = 1)

# Encode the target value into numerical value using LabelEncoder
encoder = LabelEncoder()
train_data["prognosis"] = encoder.fit_transform(train_data["prognosis"])
test_data["prognosis"] = encoder.transform(test_data["prognosis"])  # Use the same encoder to transform test data

# Split the data
X_train = train_data.iloc[:, :-1]
y_train = train_data.iloc[:, -1]

X_test = test_data.iloc[:, :-1]
y_test = test_data.iloc[:, -1]

# Train the models
final_svm_model = SVC()
final_svm_model = svm.SVC(probability=True)
final_nb_model = GaussianNB()
final_rf_model = RandomForestClassifier(random_state=18)

final_svm_model.fit(X_train, y_train)
final_nb_model.fit(X_train, y_train)
final_rf_model.fit(X_train, y_train)

# Evaluate the models
print("SVM Accuracy: ", final_svm_model.score(X_test, y_test))
print("Naive Bayes Accuracy: ", final_nb_model.score(X_test, y_test))
print("Random Forest Accuracy: ", final_rf_model.score(X_test, y_test))

# Save the models to disk
pickle.dump(final_svm_model, open('final_svm_model.pkl', 'wb'))
pickle.dump(final_nb_model, open('final_nb_model.pkl', 'wb'))
pickle.dump(final_rf_model, open('final_rf_model.pkl', 'wb'))
pickle.dump(encoder, open('encoder.pkl', 'wb'))