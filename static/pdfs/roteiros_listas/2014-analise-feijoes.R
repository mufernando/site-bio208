if(!require(RCurl)){install.packages('RCurl'); library(RCurl)}
if(!require(ggplot2)){install.packages('ggplot2'); library(ggplot2)}
if(!require(reshape2)){install.packages('reshape2'); library(reshape2)}
if(!require(plyr)){install.packages('plyr'); library(plyr)}
if(!require(dplyr)){install.packages('dplyr'); library(dplyr)}

d_c1=getURL("https://docs.google.com/spreadsheets/d/1jZbxJzstOdgaNADw6n1ov4pKo0l0dAD1uEcefAlFplI/export?gid=0&format=csv", ssl.verifypeer=FALSE)
d_c2=getURL("https://docs.google.com/spreadsheets/d/1jZbxJzstOdgaNADw6n1ov4pKo0l0dAD1uEcefAlFplI/export?gid=1488503095&format=csv", ssl.verifypeer=FALSE)
d_c3=getURL("https://docs.google.com/spreadsheets/d/1jZbxJzstOdgaNADw6n1ov4pKo0l0dAD1uEcefAlFplI/export?gid=1830499974&format=csv", ssl.verifypeer=FALSE)
d_c4=getURL("https://docs.google.com/spreadsheets/d/1jZbxJzstOdgaNADw6n1ov4pKo0l0dAD1uEcefAlFplI/export?gid=1573305252&format=csv", ssl.verifypeer=FALSE)
n_c1=getURL("https://docs.google.com/spreadsheets/d/1Ohp7eJ9RQnDUsMamCgX_hvuPLSlQLAGrktFVR-p8VyI/export?gid=0&format=csv", ssl.verifypeer=FALSE)
n_c2=getURL("https://docs.google.com/spreadsheets/d/1Ohp7eJ9RQnDUsMamCgX_hvuPLSlQLAGrktFVR-p8VyI/export?gid=316756507&format=csv", ssl.verifypeer=FALSE)
n_c3=getURL("https://docs.google.com/spreadsheets/d/1Ohp7eJ9RQnDUsMamCgX_hvuPLSlQLAGrktFVR-p8VyI/export?gid=574934489&format=csv", ssl.verifypeer=FALSE)
n_c4=getURL("https://docs.google.com/spreadsheets/d/1Ohp7eJ9RQnDUsMamCgX_hvuPLSlQLAGrktFVR-p8VyI/export?gid=12088454&format=csv", ssl.verifypeer=FALSE)

cenarios <- list()
cenarios[[1]] <- rbind(data.frame(read.csv(textConnection(d_c1))[-1], periodo = "diurno"), data.frame(read.csv(textConnection(n_c1))[-1], periodo = "noturno"))
cenarios[[2]] <- rbind(data.frame(read.csv(textConnection(d_c2))[-1], periodo = "diurno"), data.frame(read.csv(textConnection(n_c2))[-1], periodo = "noturno"))
cenarios[[3]] <- rbind(data.frame(read.csv(textConnection(d_c3))[-1], periodo = "diurno"), data.frame(read.csv(textConnection(n_c3))[-1], periodo = "noturno"))
cenarios[[4]] <- rbind(data.frame(read.csv(textConnection(d_c4))[-1], periodo = "diurno"), data.frame(read.csv(textConnection(n_c4))[-1], periodo = "noturno"))

TransitionMatrix <- function(n){
    t.mat <- matrix(NA, n+1, n+1)
    for(i in 1:(n+1)){
        t.mat[,i] <- pbinom(0:n, n, (i-1)/n) - c(0, pbinom(0:(n-1), n, (i-1)/n))
    }
    t.mat
}

ExpectedPops <- function(m, n, p, gen){
    pops = numeric(n+1)
    pops[(p*n)+1] <- m
    t.mat <- TransitionMatrix(n)
    for(i in 1:gen){
        pops <- t.mat %*% pops
    }
    data.frame(n.pretos = 0:n, pops)
}

PlotHistograms_withExpected <- function(cenario_df, n, p, gen, main = '', cor, m = dim(cenario_df)[1]){
    esperado = adply(1:gen, 1, function(x) ExpectedPops(m, n, p, x))
    esperado$geracao <- as.factor(esperado$X1)
    esperado$X1 <- NULL
    m_cenario = melt(cenario_df, id.vars = c('Grupo', 'periodo'))
    names(m_cenario) <- c('Grupo', 'periodo', 'geracao', 'n.pretos')
    m_cenario$geracao <- as.factor(as.numeric(gsub('geracao.', '', m_cenario$geracao)))
    ggplot(m_cenario, aes(n.pretos, group = geracao)) + geom_histogram(fill=cor, binwidth = 0.5) + theme_bw()+ xlab("Número de Pretos")+ ylab("Contagem")+
    geom_line(data = esperado, aes(n.pretos, pops)) + geom_point(data = esperado, aes(n.pretos, pops)) + facet_wrap(~geracao, scales = "free_y")+ labs(title=main)
}

PlotHistograms_withExpected(cenarios[[1]], 4, 0.50, 12, 'Cenário 1', 'lightskyblue2')
PlotHistograms_withExpected(cenarios[[2]], 4, 0.25, 12, 'Cenário 2', 'lightgoldenrod1')
PlotHistograms_withExpected(cenarios[[3]], 8, 0.50, 12, 'Cenário 3', 'lightpink3')
PlotHistograms_withExpected(cenarios[[4]],16, 0.25, 12, 'Cenário 4', 'palegreen3')

##############
# Testes estatísticos
##############

# Desvio esperado ao final do processo:

ChiSqTest <- function(cenario_df, n, p, gen){
    m_cenario = melt(cenario_df, id.vars = c('Grupo', 'periodo'))
    M <- as.table(rbind(table(m_cenario$value, m_cenario$variable)[,gen], ExpectedPops(dim(cenario_df)[1], n, p, gen)$pops))
    rownames(M) <- c('observado', 'esperado')
    print(M)
    chisq.test(M)
}

ChiSqTest(cenarios[[1]], 4, 0.5, 12)
ChiSqTest(cenarios[[2]], 4,0.25, 12)
ChiSqTest(cenarios[[3]], 8, 0.5, 12)
ChiSqTest(cenarios[[4]],16,0.25, 12)

##################
# Evolução de frequencias, heterozigoze and all that
##################

PlotStats <- function(cenario_df, n, p, gen, main = '', m = dim(cenario_df)[1]){
    m_cenario = melt(cenario_df, id.vars = c('Grupo', 'periodo'))
    names(m_cenario) <- c('Grupo', 'periodo', 'geracao', 'n.pretos')
    m_cenario$geracao <- as.factor(as.numeric(gsub('geracao.', '', m_cenario$geracao)))
    m_cenario <- mutate(m_cenario,
                        freq = n.pretos/n,
                        heter = 2 * freq * (1-freq))
    m_cenario <- melt(m_cenario, id.vars = c('Grupo', 'periodo', 'geracao'))
    var_freq <- data.frame(geracao = as.factor(0:gen),
                           var_freq = tapply(filter(m_cenario, variable == 'freq')$value,
                                             filter(m_cenario, variable == 'freq')$geracao,
                                             var),
                           variable = 'var freq')

    esperado = adply(1:gen, 1, function(x) ExpectedPops(m, n, p, x))
    esperado$geracao <- as.factor(esperado$X1)
    esperado$X1 <- NULL
    freq_esp <- tapply(esperado$n.pretos/n * esperado$pops,
                       esperado$geracao,
                       function(x) sum(x) / m)
    heter_esp <- tapply(2 * esperado$n.pretos/n * (1 - esperado$n.pretos/n) * esperado$pops,
                        esperado$geracao,
                        function(x) sum(x) / m)
    var_esp <- tapply((esperado$n.pretos/n - p)**2 * esperado$pops,
                      esperado$geracao,
                      function(x) sum(x) / m)
    stat_esperado <- data.frame(cbind(freq_esp, heter_esp, var_esp), geracao = as.factor(1:gen))
    m_esperado <- melt(stat_esperado, id.vars = 'geracao')

    ggplot(filter(m_cenario, variable != 'n.pretos'), aes(geracao, value, group = variable, color = variable)) +
    geom_smooth() + theme_bw() + geom_line(data = var_freq, aes(geracao, var_freq, group = 1)) + geom_line(data = m_esperado, aes(geracao, value, group = variable))+ labs(title=main)
}

PlotStats(cenarios[[1]], 4, 0.50, 12, 'Cenário 1')
PlotStats(cenarios[[2]], 4, 0.25, 12, 'Cenário 2')
PlotStats(cenarios[[3]], 8, 0.50, 12, 'Cenário 3')
PlotStats(cenarios[[4]],16, 0.25, 12, 'Cenário 4')
