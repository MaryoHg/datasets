# ---------------------------------- #
# ---- OPERACIONES BÁSICAS EN R ---- #
# ---------------------------------- #

# 1. Operaciones básicas en R ----

        # a. creo un objeto llamado "x", que almacena el valor de 5, y lo imprimo
        x <- 5
        x

        # b. creo un objeto llamado "y", que almacena el valor de 3, y lo imprimo
        y <- 3
        y
        
        # c. puedo hacer las operaciones que guste con los objetos:
        
                # a. suma
                x+y
                
                # b. resta
                x-y
                
                # c. multiplicación
                x * y
                
                # d. división
                y/x
                
                # e. potencia
                x ^ y
                y ^ x
        
                # f. operaciones unidas:
                r = 120
                a = pi*r^2
                
                # g. vectores
                a = c(3, 2, 1)
                b = c(0, 1, 5)
                a-b # resta de vectores
                a+b # suma de vectores
                a*b
                a/b
                b/a
                a^b
                b^a
                
        # los objetos pueden tener cualquier nombres
                mario <- seq(from = 0, to = 1e6, by = 0.1)

# 2. Funciones en R ----
                
        # Raíz cuadrada
        qrt(z)
        
        # Logarítmos
        log10(z) # base 10
        log(z) # natural
        log2(2) # base
        log(x = z, base = 5) # cualquier "base" (ejemplo es 5)
        
        #Operador de relación: TRUE/FALSE
        x==y

        
# 3. Funciones básicas ----
        # secuencias 
        base::seq(from = 0, to = 30, by = 5)
        
        # factorial
        base::factorial(3)
        base::factorial(x)
        
        # promedio y desviación estándar
        mean(a)
        sd(a)
        
        mean(mario)
        sd(mario)

        
# 4. Tipos de objetos en R ----
        
        ##Numeric
        class(a)
        
        b <- c(1, 2, 3, 4, 5)
        class(b)
        
        # Character
        c <- c("mateo", "pablo", "cesar", "hugo", "pedro", "santiago")
        c
        class(c)
        
        # Logical
        is.numeric(c)
        is.character(c)
        
# 5. Objetos compuestos: data.frame()

        ?data.frame()
        
        this_is_a_dataframe <- base::data.frame(
                graduation = c("Economy", "ADE", "Sociology", "Master"),
                age = c(25, 27, 25, 24)
                )
        
        this_is_a_dataframe
        class(this_is_a_dataframe)
        dim(this_is_a_dataframe)
        
        
        