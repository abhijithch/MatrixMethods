# Reduced_row_echelon_form
# http://rosettacode.org/wiki/Reduced_row_echelon_form

function ToReducedRowEchelonForm(matrix)
    lead = 1
    rowCount,columnCount = size(matrix)

    for row = 1:rowCount
        if lead > columnCount
            return
        end

        i = row
        while matrix[i,lead] == 0
            i += 1
            if i == rowCount
                i = row
                lead += 1
                if columnCount == lead
                    return
                end
            end
        end

        matrix[i,:],matrix[row,:] =matrix[row,:],matrix[i,:]
        leadValue = matrix[row,lead]
        matrix[row,:] = [ val / leadValue for val in matrix[row,:]]

        for i=1:rowCount
            if i != row
                leadValue = matrix[i,lead]
                matrix[i,:] = [ (ivalue - leadValue*rowvalue) for (rowvalue,ivalue) in zip(matrix[row,:],matrix[i,:])]
            end
        end
        lead += 1
    end
end


#Output:
#julia> matrix = [1 2 -1 -4 ; 2 3 -1 -11 ; -2 0 -3 22]
#3x4 Int32 Array:
#  1  2  -1   -4
#  2  3  -1  -11
# -2  0  -3   22
#
#julia> ToReducedRowEchelonForm(matrix)
#
#
#julia> matrix
#3x4 Int32 Array:
# 1  0  0  -8
# 0  1  0   1
# 0  0  1  -2


#modified code 

function ToReducedRowEchelonForm_new(matrix)
    lead = 1
    rowCount,columnCount = size(matrix)

    for row = 1:rowCount
        if lead > columnCount
            return
        end

        i = row
        while matrix[i,lead] == 0
            i += 1
            if i == rowCount
                i = row
                lead += 1
                if columnCount == lead
                    return
                end
            end
        end

	for j = 1:columnCount
	        matrix[i,j],matrix[row,j] =matrix[row,j],matrix[i,j]
	end

        leadValue = matrix[row,lead]
	
	for j = 1:columnCount
		matrix[row,j] = matrix[row,j] / leadValue 
	end

        for i=1:rowCount
            if i != row
                leadValue = matrix[i,lead]
		for j = 1:columnCount
			matrix[i,j] = matrix[i,j] - (leadValue * matrix[row,j])
		end
            end
        end

        lead += 1
    end
end


#Time captured for Modified code
julia> @time ToReducedRowEchelonForm_new(matrix1)
elapsed time: 0.388078318 seconds (32 bytes allocated)

#Time captured for  code Without Modifications
julia> @time ToReducedRowEchelonForm(matrix2)
elapsed time: 282.441964184 seconds (1529548164 bytes allocated)
