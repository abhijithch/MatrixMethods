
#read the data and initialize sparse matrix and return SVD factorized matrices
function findsvd()

    training,test = readData()    #Method is in InitializeData.jl
    (training_sparse,test_sparse)=initialize(training,test)  #Method is in InitializeData.jl      

    #svd method -Compute the SVD of A, returning "U", vector "S", and "V" such
    #that "A == U*diagm(S)*V'". If "thin" is "true", an economy
    #mode decomposition is returned.
    #full method- Convert a sparse matrix "S" into a dense matrix.
    (U,S,V)=svd(full(training_sparse))    
    return (U,S,V,test_sparse)
end


#calculate root mean square error
function rootMeanSquareError(known_value_test, predicted, len_known_values_test)
    sqrt( sum( (float(known_value_test[:]) - predicted[:]).^2) / len_known_values_test )
end

function  writeActualVsPredictedToFile(predicted , known_value_test,l)

    println("size of predicted ",size(predicted)[1])
    println("typeof ",typeof(known_value_test))
    #compare actual vs predicted by writing to a file
    compare = Array(String,size(predicted)[1])
    for k=1:size(predicted)[1]
     compare[k]=string(known_value_test[k],"-------",round(predicted[k],2))         
    end
    writedlm(string("compare",l), compare, ",")
end

function RecommendSys()

    (U,S,V,test_sparse)=findsvd()

    println("size of U ",size(U))
    println("size of S ",size(S))
    println("size of V ",size(V))
    #findnz method - Return a tuple "(I, J, V)" where "I" and "J" are the row and
    #column indexes of the non-zero values in matrix "A", and "V" is
    #a vector of the non-zero values.
    (row_test,column_test,known_value_test)=findnz(test_sparse)

    #length method- Returns the number of elements in known_value_test vector
    #tpyeof(known_value_test) - Array{Int32,1}
    len_known_values_test =length(known_value_test)
    println("len_known_values_test : ",len_known_values_test)
    #zeros method- Create an array of all zeros of specified type
    predicted = zeros(len_known_values_test)
    
    i=1
    
    V_transpose=V'
    
    #diagm method- Construct a diagonal matrix and place "v" on the "k"-th diagonal.
    S=diagm(S)
    
    #l=50
    rootmeansquareError_Array=zeros(5)

    for l=10:20:100
        #get all the rows for first 'l' columns
        row_feature=U[:,1:l]

        #S * V' for l row, columns
        col_feature=S[1:l,1:l]*V_transpose[1:l,:]
        
        #predict using the dot product 
        for j=1:len_known_values_test  
           
           row_feature_temp=row_feature[row_test[j],:]
           P=row_feature_temp[:]
           Q=col_feature[:,column_test[j]]
           
           #dot - Compute the dot product. For complex vectors the first vector is conjugated.
           predicted[j]=dot(P,Q)	
        end

        #find - Return a vector of the linear indexes of the non-zeros in "A".
        # replace predicted values with less than 1 with 1        
        predicted[find(predicted.<1)]=1

        ## replace predicted values with more than 5 with 5        
        predicted[find(predicted.>5)]=5
        
        writeActualVsPredictedToFile(predicted,known_value_test,l)
        
        temp =  rootMeanSquareError(known_value_test, predicted, len_known_values_test)

        rootmeansquareError_Array[i]=temp        
        i=i+1
    end
    
    rootmeansquareError_Array
end