
function initialize(training,test)

	#training data
	userCol = int(training[:,1])
	movieCol = int(training[:,2])
	ratingsCol = int(training[:,3])
	training_sparse =sparse(userCol,movieCol,ratingsCol)

	#test data
	QuserCol = int(test[:,1])
	QmovieCol = int(test[:,2])
	QratingsCol = int(test[:,3])

	#sparse method - Convert a dense matrix "A" into a sparse matrix.
	test_sparse=sparse(QuserCol,QmovieCol,QratingsCol)

	return (training_sparse,test_sparse)
end

function readData()
	
	#readdlm method- Read a matrix from the source where each line (separated by "eol") 
    #gives one row, with elements separated by the given delimeter. The 
    #source can be a text file, stream or byte array. Memory mapped files 
    #can be used by passing the byte array representation of the mapped 
    #segment as source.
	training = readdlm("../data/train.txt",'\t';has_header=false)
	test = readdlm("../data/test.txt",'\t';has_header=false)
	println("size of training data", size(training))
	println("size of test data", size(test))
	return (training,test)
end