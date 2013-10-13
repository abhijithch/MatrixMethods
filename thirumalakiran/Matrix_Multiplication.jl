using Winston

function matmul()
    
    x = [1:10]
    y = [1:10]
    x = convert(Array{Float64,1}, x)
    y1 = convert(Array{Float64,1}, y)
    y2 = convert(Array{Float64,1}, y)
    y3 = convert(Array{Float64,1}, y)
    y4 = convert(Array{Float64,1}, y)
    
    for i = 1: 10        
        m = i * 200
        n = i * 200
        k = i * 200
        A = rand(m,k)
        B = rand(k,n)
        C = zeros(m,n)

        #column wise and vectorized access
	b = time()
        for r = 1:k
            C = C + A[:,k] * B[k,:]
        end
        a = time()
        y1[i] = a-b

 	C = zeros(m,n)
        #column wise and non-vectorized access
	b = time()
        for r = 1:k
	     for p = 1:m
	      	for q = 1:n
	            C[p,q] = C[p,q] + A[p,k] * B[k,q]
	        end
	     end
        end
        a = time()
	y2[i] = a-b

        C = zeros(m,n)
        #row wise and vectorized access
	b = time()
        for p = 1:m
	      for q = 1:n
	            C[p,q] = (A[p,:] * B[:,q])[1]
	      end        
	end
        a = time()
        y3[i] = a-b

        C = zeros(m,n)
        #row wise and non-vectorized access
    	b = time()    
	for p = 1:m
	      for q = 1:n
		      for r = 1:k
		            C[p,q] = C[p,q] + A[p,k] * B[k,q]
		      end
	      end
        end
        a = time()
	y4[i] = a-b

    end
    
    #Plot the observastions
    p = FramedPlot()
    setattr(p, "title", "col vec in red vs col in blue vs row vec in green vs row in brown")
    setattr(p, "xlabel", "exp no. (input size = exp no * 100)")
    setattr(p, "ylabel", "timetaken in seconds")
    add(p, Curve(x, y1,"color", "red"))  #column wise and vectorized access
    add(p, Curve(x, y2,"color", "blue")) #column wise and non-vectorized access
    add(p, Curve(x, y3,"color", "green")) #row wise and vectorized access
    add(p, Curve(x, y4,"color", "brown")) #row wise and non-vectorized access
    Winston.display(p)
    file(p, "matrix_multiplication.png")
end

#Find the plot here - https://docs.google.com/file/d/0B3nPBIEtlfPGdTlIM1c3WHFZS1k/edit?usp=sharing
#row wise and non-vectorized access took less time to complete the operation
