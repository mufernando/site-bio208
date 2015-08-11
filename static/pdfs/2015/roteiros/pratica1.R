###########################################
###Pratica 1 - Processos Evolutivos 2015###
###########################################

if(!require(RCurl)){install.packages('RCurl'); library(RCurl)}
if(!require(ggplot2)){install.packages('ggplot2'); library(ggplot2)}
if(!require(reshape2)){install.packages('reshape2'); library(reshape2)}

PlotHistograms = function(file_url, cor){
    cenario_df = read.csv(textConnection(file_url))
    m_cenario = melt(cenario_df[,-1], id.vars = "Grupo")
    ggplot(m_cenario, aes(value, group = variable)) + geom_histogram(fill=cor, binwidth = 0.5)+ facet_wrap(~variable) + theme_bw()+ xlab("Numero de Pretos")+ ylab("Contagem")+ labs(title=names(cenario_df)[1])
}

PlotTimeSeries = function(file_url){
    cenario_df = read.csv(textConnection(file_url))
    m_cenario = melt(cenario_df[,-1], id.vars = "Grupo")
    m_cenario$variable = as.numeric(gsub('geracao.', '', m_cenario$variable))
    m_cenario$Grupo = as.factor(m_cenario$Grupo)
    ggplot(m_cenario, aes(variable, value, group = Grupo, color = Grupo)) + geom_line() + theme_bw() + xlab("GeraÃ§Ã£o") + ylab("Contagem") + labs(title=names(cenario_df)[1])
}

##################
####  Diurno  ####
##################

c1=getURL("https://docs.google.com/spreadsheets/d/1GHVJbxSlOjDOkDDckmQNGsYG-E4A77CcSCRTMiChr-8/edit#gid=0&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c1, 'lightskyblue2')
PlotTimeSeries(c1)

c2=getURL("https://docs.google.com/spreadsheets/d/1GHVJbxSlOjDOkDDckmQNGsYG-E4A77CcSCRTMiChr-8/edit#gid=635194257&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c2, 'lightgoldenrod1')
PlotTimeSeries(c2)

c3=getURL("https://docs.google.com/spreadsheets/d/1GHVJbxSlOjDOkDDckmQNGsYG-E4A77CcSCRTMiChr-8/edit#gid=535569192&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c3, 'lightpink3')
PlotTimeSeries(c3)

c4=getURL("https://docs.google.com/spreadsheets/d/1GHVJbxSlOjDOkDDckmQNGsYG-E4A77CcSCRTMiChr-8/edit#gid=1620829486&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c4, 'palegreen3')
PlotTimeSeries(c4)

###################
####  Noturno  ####
###################

c1=getURL("https://docs.google.com/spreadsheets/d/1z3pJGTEwVpkkzL51oZeSZpygWFbnap8inxPL8w8lm-c/edit#gid=0&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c1, 'lightskyblue2')
PlotTimeSeries(c1)

c2=getURL("https://docs.google.com/spreadsheets/d/1z3pJGTEwVpkkzL51oZeSZpygWFbnap8inxPL8w8lm-c/edit#gid=1988935162&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c2, 'lightgoldenrod1')
PlotTimeSeries(c2)

c3=getURL("https://docs.google.com/spreadsheets/d/1z3pJGTEwVpkkzL51oZeSZpygWFbnap8inxPL8w8lm-c/edit#gid=235272939&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c3, 'lightpink3')
PlotTimeSeries(c3)

c4=getURL("https://docs.google.com/spreadsheets/d/1z3pJGTEwVpkkzL51oZeSZpygWFbnap8inxPL8w8lm-c/edit#gid=1273230419&format=csv", ssl.verifypeer=FALSE)
PlotHistograms(c4, 'palegreen3')
PlotTimeSeries(c4)

