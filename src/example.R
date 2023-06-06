# Ejemplo sacado de https://rpubs.com/danilofreire/synth

#La prochaine librairie permet la mise en place de la methode de control synthètique

library("synth")
library("gsynth")

#Maintenant les paquets sont près pour être ustilisés et simuler

set.seed(1)
year <- rep(1:30, 10)
state <- rep(LETTERS[1:10], each = 30)
X1 <- round(rnorm(300, mean = 2, sd = 1), 2)
X2 <- round(rbinom(300, 1, 0.5) + rnorm(300), 2)
Y <- round(1 + 2*X1 + rnorm(300), 2)
df <- as.data.frame(cbind(Y, X1, X2, state, year))
df$Y <- as.numeric(as.character(df$Y))
df$X1 <- as.numeric(as.character(df$X1))
df$X2 <- as.numeric(as.character(df$X2))
df$year <- as.numeric(as.character(df$year))
df$state.num <- as.numeric(df$state)
df$state <- as.character(df$state)
df$T <- ifelse(df$state == "A" & df$year >= 15, 1, 0)
df$Y <- ifelse(df$state == "A" & df$year >= 15, df$Y + 20, df$Y)

#Allons voir à quoi resamble notre base de donnés
str(df)
head(df)
#Maintenant on peut estimer les models, d'abord nous allons utiliser Synth. En suite, on peut observer les poids des variables indépendants(v.weights) et des groupes de control (w.weights)
ataprep.out <-
        dataprep(df,
                 predictors = c("X1", "X2"),
                 dependent     = "Y",
                 unit.variable = "state.num",
                 time.variable = "year",
                 unit.names.variable = "state",
                 treatment.identifier  = 1,
                 controls.identifier   = c(2:10),
                 time.predictors.prior = c(1:14),
                 time.optimize.ssr     = c(1:14),
                 time.plot             = c(1:30)
                 )

# Run synth
synth.out <- synth(dataprep.out)

#Obtinir grille des résultats
print(synth.tables   <- synth.tab(
        dataprep.res = dataprep.out,
        synth.res    = synth.out)
#Plot:
path.plot(synth.res    = synth.out,
          dataprep.res = dataprep.out,
          Ylab         = c("Y"),
          Xlab         = c("Year"),
          Legend       = c("State A","Synthetic State A"),
          Legend.position = c("topleft")
)

abline(v   = 15,
       lty = 2)
#Gaps plot:
gaps.plot(synth.res    = synth.out,
          dataprep.res = dataprep.out,
          Ylab         = c("Gap"),
          Xlab         = c("Year"),
          Ylim         = c(-30, 30),
          Main         = ""
)
abline(v   = 15,
       lty = 2)

#En dernier, il faut executer the same procedure en utilisant gsynth, u paquet très récent, ce code pérmet estimer les effets fixes interactif et peut gérer plusieurs unités traitées à la fois:

gsynth.out <- gsynth(Y ~ T + X1 + X2, data = df,
                     index = c("state","year"), force = "two-way",
                     CV = TRUE, r = c(0, 5), se = TRUE,
                     inference = "parametric", nboots = 1000,
                     parallel = TRUE)

#Plots:
plot(gsynth.out)
plot(gsynth.out, type = "counterfactual")
## ce plot montre les estimations pour les cas de control
plot(gsynth.out, type = "counterfactual", raw = "all")

