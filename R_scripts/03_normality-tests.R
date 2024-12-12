# --------------------------------------------------------------------- #
# ----------------------- Pruebas de normalidad ----------------------- #
# --------------------------------------------------------------------- #


# Base de datos: Pérez-Hernández et al. 2020 (https://doi.org/10.28940/terra.v38i4.603)
# study title: "The potential of Mimosa pigra to restore contaminated soil with anthracene and phenanthrene"

# Fuente 1: https://fhernanb.github.io/Manual-de-R/normalidad.html 
# Fuente 2: https://torres.epv.uniovi.es/centon/contraste-normalidad.html


# 1. Environment settings: loading packages ----

# "Let's set the random seed using set.seed(123999) in R 
  # to ensure that our analysis is replicable."
set.seed(123999)

# 1.1. Loading package to employ during analyses

library(tidyverse) # install.packages("tidyverse", dep = T)
library(openxlsx)  # install.packages("openxlsx", dep = T)
library(skimr)     # install.packages("skimr", dep = T)
library(car)       # install.packages("car", dep = T)
library(nortest)   # install.packages("nortest", dep = T)

theme_set(theme_bw() + theme(axis.text = element_text(color = "black", size = 11)))


# 2. Loading dataframe: physicochemical data ----

  # data <- read.csv("C:/Users/Vale/Desktop/fisicoquimicos_mimosa.csv")
  data <- openxlsx::read.xlsx(xlsxFile = "/Users/mario/Documents/GitHub/upgm_diapos/physicochemical_data_mimosa.xlsx", sheet = 1, startRow = 2)

  # 2.1. Let's take a look of a summary of the data
  summary(data)
  skimr::skim(data)

# 3. Gráfico de densidad ----

  data %>%
    ggplot(mapping = aes(x = nitrogen, fill = treatment)) +
    geom_density(alpha = 0.4) +
    scale_colour_brewer(palette = "Accent") +
    labs(colour = "Treatment") +
    scale_x_continuous(name="Nitrogen (%)", expand = c(0, 0)) +
    scale_y_continuous(name = "Density function f(x)", expand=c(0,0), limits=c(0,NA))

# 4. Histograma

  data %>% 
    dplyr::select(nitrogen) %>% 
    hist()

# 5. Determining the basic statistics 

base::tapply (X = data$nitrogen, INDEX = data$treatment, FUN = summary)

# 6. QQ-plot: Visualización de gráficos QQ-PLOT

#### El gráfico cuantil-cuantil muestra puntos alienados cuando los datos siguen una distribución normal.
### Los gráficos cuantil cuantil (QQ-plot) son una herramienta gráfica para explorar si un conjunto de 
### datos o muestra proviene de una población con cierta distribuciónn


 # 6.1. qq-plot for treatments ----

  car::qqPlot(nitrogen ~ treatment, data = data, layout=c(1,3))
  car::qqPlot(pH ~ treatment, data = data, layout=c(1,3))
  car::qqPlot(CE ~ treatment, data = data, layout=c(1,3))
  car::qqPlot(CRA ~ treatment, data = data, layout=c(1,3))
  car::qqPlot(COT ~ treatment, data = data, layout=c(1,3))

## 
## Si se tuviese una muestra distribu?da perfectamente normal, se esperar?a que los puntos estuviesen 
## perfectamente alineados con la l?nea de referencia, sin embargo, las muestran con las que 
## se trabajan en la pr?ctica casi nunca presentan este comportamiento a?n si fueron obtenidas de una poblaci?n normal.

  
# 7. Normality tests: 
  
    # 7.1. Test de Shapiro-Wilk

    ## Una vez procesados y examinados los gr?ficos, empleamos el test de Shapiro-Wilk para contrastar 
    ## la hip?tesis nula de normalidad: los datos no son normales 
    ## Lo aplicamos a cada TRATAMIENTO por separado. 
    
    ### Nivel de Significancia: 0.05 (alpha = 0.05)
    ## Criterio de Decisi?n 
    # Si P < 0.05 - se rechaza Ho
    # Si p >= 0.05 - No se tiene suficiente evidencia para rechazar Ho


    base::tapply(data$nitrogen, data$treatment, FUN = stats::shapiro.test)
    base::tapply(data$CE, data$treatment, FUN = stats::shapiro.test)
    base::tapply(data$pH, data$treatment, FUN = stats::shapiro.test)
    base::tapply(data$COT, data$treatment, FUN = stats::shapiro.test)
    base::tapply(data$CRA, data$treatment, FUN = stats::shapiro.test)


  ## 7.2. Prueba de Anderson-Darling
    
    # Pregunta: qué vemos en la prueba de Anderson-Darling?

    base::tapply(data$nitrogen, data$treatment, FUN = nortest::ad.test)
    base::tapply(data$CE, data$treatment, FUN = nortest::ad.test)
    base::tapply(data$pH, data$treatment, FUN = nortest::ad.test)
    base::tapply(data$COT, data$treatment, FUN = nortest::ad.test)
    base::tapply(data$CRA, data$treatment, FUN = nortest::ad.test)



## NOTA: El hecho de no poder asumir la normalidad influye principalmente en los test de 
## hipótesis paramétricos (t-test, anova,.) y en los modelos de regresión.



## 8. Análisis de la homogeneidad de varianza (homocedasticidad) ----

    # Fuente: https://rpubs.com/Joaquin_AR/218466

    ##El supuesto de homogeneidad de varianzas, también conocido como supuesto de homocedasticidad, 
    ## entre diferentes grupos.
    ## considera que la varianza es constante (no varía) en los diferentes niveles de un factor, es decir...

    ## Existen diferentes test que permiten evaluar la distribuci?n de la varianza. Todos ellos 
    ## consideran como hip?tesis nula que la varianza es igual entre los grupos y como hip?tesis
    ## alternativa que no lo es.


# 9. La grafica de cajas y bigotes nos da informaci?n util de nuestros datos ---
  
    data %>% 
      ggplot(mapping = aes(x = treatment, y = nitrogen, colour = treatment, fill = treatment)) +
      geom_boxplot(alpha = 0.4) +
      geom_point(size = 3) +
      theme_bw() #+ theme(legend.position = "none")

#################F-test (razón de varianzas)

###El F-test, tambi?n conocido como contraste de la raz?n de varianzas, contrasta la hip?tesis nula de que dos
###poblaciones normales tienen la misma varianza.

var.test(x = data[data$Tratamiento == "C0", "Nitrogen"],
         y = data[data$Tratamiento == "C1", "Nitrogen"] )



########### Test de Levene ################
###  Se caracteriza, adem?s de por poder comparar 2 o m?s poblaciones, por permitir elegir entre diferentes 
###estad?sticos de centralidad :mediana (por defecto), media, media truncada

leveneTest(y = data$Nitrogen, group = data$Tratamiento, center = "median")

