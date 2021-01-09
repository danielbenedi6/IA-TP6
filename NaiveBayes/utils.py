import numpy as np
import json
from glob import glob
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import time
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import BernoulliNB
from sklearn import metrics
from sklearn.model_selection import KFold, learning_curve
from sklearn.base import clone
import multiprocessing as mp

def Entrenamiento(X_train, Y, K, clf, extractor,lock, res, best_model, best_f1V):
    print("Start training...")
    f1_T = 0
    f1_V = 0
    kf = KFold(n_splits=K)
    for Xindex, Vindex in kf.split(X_train, Y):
        Xtrain, Xvalidation = X_train[Xindex], X_train[Vindex]
        Ytrain, Yvalidation = Y[Xindex], Y[Vindex]
        clf.fit(Xtrain, Ytrain)
        f1_T += metrics.f1_score(Ytrain, clf.predict(Xtrain))
        f1_V += metrics.f1_score(Yvalidation, clf.predict(Xvalidation))
    f1_T = f1_T/K
    f1_V = f1_V/K
    print(clf, "has ended")
    with lock:
        print(clf, "has acquiered lock")
        if f1_V > best_f1V:
            print("Old best: ", best_model, best_f1V)
            print("New best: ", extractor, clf, f1_V)
            best_model = (extractor, clf)
            best_f1V = f1_V
        res.append( (extractor, clf, f1_T, f1_V) )
        print(clf, "has released lock")
    
def KfoldCrossValidationMultiprocess(X, Y, stopwords, K):
    Y = np.array(Y)
    extractors = [CountVectorizer(ngram_range=(1,1)),
                  CountVectorizer(ngram_range=(1,2)),
                  CountVectorizer(ngram_range=(1,1), stop_words=stopwords),
                  CountVectorizer(ngram_range=(1,2), stop_words=stopwords),
                  CountVectorizer(ngram_range=(1,1), stop_words='english'),
                  CountVectorizer(ngram_range=(1,2), stop_words='english')]
    types = ['Multinomial', 'Bernoulli']
    alphas = [0.01,0.05,0.1,0.25,0.5,0.75,1,2,5,10,25,50,100]
    
    print("Generating classifiers...")
    classifiers = []
    for t in types:
        for alpha in alphas:
            if t == 'Multinomial':
                classifiers.append(MultinomialNB(alpha=alpha))
            elif t == 'Bernoulli':
                classifiers.append(BernoulliNB(alpha=alpha))
    
    print("Starting looping...")
    res = []
    best_f1V = 0
    best_model = (extractors[0],classifiers[0])
    lock = mp.Lock()
    for extractor in extractors:
        p = []
        X_train = extractor.fit_transform(X)
        print("Data ready with ", extractor)
        for clf in classifiers:
            pr = mp.Process(target=Entrenamiento, args=(X_train, Y, K, clf, extractor, lock, res, best_model, best_f1V))
            pr.start()
            p.append(pr)
        print("Processes started")
        for i in p:
            i.join()
        print("Classifiers for extractor ", extractor, " have ended")
    
    
    print(" · · · End of tries")
    print("\n\n\n\nBEST MODEL: ")
    print(best_model)
    extractor = best_model[0]
    classifier = clone(best_model[1])
    X_train = extractor.fit_transform(X)
    classifier.fit(X_train, Y)
    
            
    return res, (extractor, classifier)