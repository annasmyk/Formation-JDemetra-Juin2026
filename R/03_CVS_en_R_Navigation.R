# Navigation dans les objets ---------------------------------------------------


# X13 en version 3

# sa_x13_v3$result$preadjust
# sa_x13_v3$result$decomposition
sa_x13_v3$result$final$d11final
sa_x13_v3$result$mstats
sa_x13_v3$result$diagnostics

plot(y_raw, col = "red")
lines(sa_x13_v3$result$final$d11final, col = "blue")

sa_x13_v3$estimation_spec$x11
sa_x13_v3$estimation_spec$benchmarking

sa_x13_v3$result_spec
sa_x13_v3$user_defined


# final seasonally adjusted series
sa_x13_v3$result$final$d11final

### Pre adjustment series


# Version 3: "x11 names" : preadjustement effets as stored in the A table
# see doc chap x11 for names

sa_x13_v3$result$preadjust


print(sa_x13_v2)
sa_x13_v3$result$diagnostics$td.ftest.i






## Plots in v3

library("ggdemetra3")

# Plot of the final decomposition
plot(sa_x13_v3)
# avec le format autoplot
autoplot(sa_x13_v3)

# Plot SI ratios
siratioplot(sa_x13_v3)
# avec le format autoplot
ggsiratioplot(sa_x13_v3)
