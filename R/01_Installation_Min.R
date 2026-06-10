# Installation des packages R

install.packages(c(
    "rjd3toolkit",
    "rjd3x13",
    "rjd3tramoseats",
    "rjd3workspace",
    "rjwsacruncher",
    "JDCruncheR",
    "rjd3prodcution",
    "dplyr"

), repos = "https://nexus.insee.fr/repository/r-cran")

# Etape JAVA_HOME
Sys.setenv(JAVA_HOME = "Y:\\Logiciels\\JDemetraplus\\jdemetra-3.7.1\\nbdemetra\\jdk-21.0.7+6-jre")