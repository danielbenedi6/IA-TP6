import numpy as np
import json
from glob import glob
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import time
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB, BernoulliNB, GaussianNB
from sklearn import metrics
from sklearn.model_selection import KFold, learning_curve
from sklearn.base import clone
from sklearn.utils import shuffle
import multiprocessing as mp

#ef Entrenamiento(X_train, Y, K, classif, extractor,lock, res, best_model, best_f1V):
def Entrenamiento(X_train, Y, K, classif, extractor,lock, best_f1V):
    #print("Start training...")
    f1ScoresV = np.array([])
    f1ScoresT = np.array([])
    for i in range(10):
        f1_T = 0
        f1_V = 0
        kf = KFold(n_splits=K, shuffle=True, random_state=int(time.time()))
        clf = clone(classif)
        for Xindex, Vindex in kf.split(X_train, Y):
            Xtrain, Xvalidation = X_train[Xindex], X_train[Vindex]
            Ytrain, Yvalidation = Y[Xindex], Y[Vindex]
            clf.fit(Xtrain, Ytrain)
            f1_T += metrics.f1_score(Ytrain, clf.predict(Xtrain))
            f1_V += metrics.f1_score(Yvalidation, clf.predict(Xvalidation))
        f1_T = f1_T/K
        f1_V = f1_V/K
        f1ScoresV = np.append(f1ScoresV, f1_V)
        f1ScoresT = np.append(f1ScoresT, f1_T)
    #print(clf, "has ended")
    f1MeanV = np.mean(f1ScoresV)
    f1StdV  = np.std(f1ScoresV)
    f1MeanT = np.mean(f1ScoresT)
    f1StdT  = np.std(f1ScoresT)
    print("@@@@@@@@@@@@@ ", f1ScoresV)
    print("$$$$$$$$$$$$$ ", f1ScoresT)
    with lock:
        print(extractor, "\t" , classif, "\t", f1MeanV, "\t", f1StdV)
        #print(clf, "has acquiered lock")
        if f1MeanV > best_f1V.value:
            #print("Old best: ", best_model, best_f1V)
            print("========= New best: ", extractor, clf, f1MeanV)
            #best_model.value = (extractor, clf)
            best_f1V.value = f1MeanV
        #res.value.append( (extractor, clf, f1MeanT, f1_V) )
        #print(clf, "has released lock")
    
def KfoldCrossValidationMultiprocess(X, Y, stopwords, K):
    Y = np.array(Y)
    extractors = [CountVectorizer(ngram_range=(1,1)),
                  CountVectorizer(ngram_range=(1,2)),
                  CountVectorizer(ngram_range=(1,1), stop_words=stopwords),
                  CountVectorizer(ngram_range=(1,2), stop_words=stopwords),
                  CountVectorizer(ngram_range=(1,1), stop_words='english'),
                  CountVectorizer(ngram_range=(1,2), stop_words='english')]
    types = ['Multinomial', 'Bernoulli', 'Gaussian']
    alphas = [0, 0.001, 0.01,0.05,0.1,0.25,0.5,0.75,1,2,5,10,25,50,100]
    
    print("Generating classifiers...")
    classifiers = []
    for t in types:
        for alpha in alphas:
            if t == 'Multinomial':
                classifiers.append(MultinomialNB(alpha=alpha))
            elif t == 'Bernoulli':
                classifiers.append(BernoulliNB(alpha=alpha))
            elif t == 'Gaussian':
                classifiers.append(GaussianNB(var_smoothing=alpha))
    
    print("Starting looping...")
    
  #  res = []
  #  best_f1V = 0
  #  best_model = (extractors[0],classifiers[0])
    lock = mp.Lock()
    
  #  res = mp.Value(type([]),[])
    best_f1V = mp.Value('d',0)
    #best_model = mp.Value(type((extractors[0],classifiers[0])),(extractors[0],classifiers[0]))
    
    for extractor in extractors:
        p = []
        X_train = extractor.fit_transform(X)
        print("Data ready with ", extractor)
        for clf in classifiers:
            #pr = mp.Process(target=Entrenamiento, args=(X_train, Y, K, clf, extractor, lock, res, best_model, best_f1V))
            pr = mp.Process(target=Entrenamiento, args=(X_train, Y, K, clf, extractor, lock, best_f1V))
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