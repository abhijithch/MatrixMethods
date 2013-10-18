    using Winston

    function matmul(val)
        
        #initializing variables for plotting
        x = convert(Array{Float64,1}, [1:10])
        y1 = zeros(Float64,10)
        y2 = zeros(Float64,10)
        y3 = zeros(Float64,10)
        y4 = zeros(Float64,10)
        
        for i = 1 : 10        
            #size of the matrix
            m = n = k = i * val  
            
            #initialize the matrix A, B
            A = rand(m,k)
            B = rand(k,n)
                        

            #column wise and vectorized access
            CWVA = zeros(m,n)
    	    b = time()
            for r = 1:k
                CWVA = CWVA + A[:,r] * B[r,:]
            end
            a = time()
            y1[i] = a-b
                 
            #column wise and non-vectorized access
            CWNVA = zeros(m,n)
    	    b = time()
            for r = 1:k
    	     for p = 1:m
    	      	for q = 1:n
    	            CWNVA[p,q] = CWNVA[p,q] + A[p,r] * B[r,q]
    	        end
    	     end
            end
            a = time()
    	    y2[i] = a-b            
            
            #row wise and vectorized access
            RWVA = zeros(m,n)
    	    b = time()
            for p = 1:m
    	      for q = 1:n
    	            RWVA[p,q] = (A[p,:] * B[:,q])[1]
    	      end        
    	    end
            a = time()
            y3[i] = a-b

            
            #row wise and non-vectorized access
        	RWNVA = zeros(m,n)
            b = time()    
    	    for p = 1:m
    	      for q = 1:n
    		      for r = 1:k
    		            RWNVA[p,q] = RWNVA[p,q] + A[p,r] * B[r,q]
    		      end
    	      end
            end
            a = time()
    	    y4[i] = a-b

                    
        end
        
        #Plot the observastions
        p = FramedPlot()        
        setattr(p, "xlabel", string("Input size = x * ",val))
        setattr(p, "ylabel", "Timetaken in seconds")
        
        
        y1curve = Curve(x, y1,"color", "red")
        setattr(y1curve, "label", "column wise and vectorized access")

        y2curve = Curve(x, y2,"color", "blue")
        setattr(y2curve, "label", "column wise and non-vectorized access")

        y3curve = Curve(x, y3,"color", "green")
        setattr(y3curve, "label", "row wise and vectorized access")

        y4curve = Curve(x, y4,"color", "brown")
        setattr(y4curve, "label", "row wise and non-vectorized access")

        l = Legend( .1, .9, {y1curve, y2curve, y3curve, y4curve} )
        add(p, y1curve, y2curve, y3curve, y4curve, l)          
        
        Winston.display(p)
        file(p, "matrix_multiplication.png")
    end
