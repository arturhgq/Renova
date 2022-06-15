/* RELATÓRIO DE MONITORAMENTO - FLUXO ÁGIL /*

/* Novas manifestações */
SELECT
    datareg, protocolo, statusManifestacao, datainsercao, unidadeinseriu, operadorinseriu, nomeoperadorinseriu, operadoralteracaofinal, manifestacaoAssuntoTema,
    requerAcaoFutura, statusdemanda 
FROM filtro_327
WHERE operadorinseriu IN (604830,725977,13685,310678,608036,726018,725690,725963,605437,725972,723822,611898,725970,580393,
                            723824,615772,615773,615776,99466,725965,604792,619217,13707,516494,608041,615780,611903,619220,
                            608271,725696,493213,619226,725975,611909,615784,725698,619228,309474,725955,604802,725671,599698,
                            615786,566783,615787,723825,611910,604834,611912,619223,619221,571989,725958,615795,24016,308866,
                            604898,283447,25979,619216,725680,615797,311090) AND datainsercao >= '2022-02-24';

/* Encaminhamentos */                            
SELECT data_en, protocolo, statusManifestacao, decod_en, de_en, manifestacaoAssuntoTema, manifencaminhamentotipo_en, formapreferidaretorno
FROM filtro_1509
WHERE de_en IN ('Amanda Evelin da Silveira Carneiro','Ana Caroline de Jesus Santiago','Ana Luíza Macedo Ribeiro',
                                                'ANA PAULA FERREIRA','André Somma Cosso','Beatriz Kuster Degasperi','Bianca Borges Ferreira',
                                                'Bianca Veríssimo Ferreira','Bibiana Stohler S de Almeida','Bryan Robson dos Santos Campos',
                                                'Carlos Augusto da Silva Júnior','Carolina Rocha Vieira','Caroline Vieira','Clarissa Alves Silva',
                                                'Cyrana Borges Veloso','DAVID DIAS GUIMARAES','DEBORA AGATHA GUIMARAES SANTOS','DÉBORA RECOLIANO',
                                                'Denise Amaral Soares','Diana de Jesus Costa','ELAINE PATRICIA DE ASSIS','Fabiana Figueiredo Gonçalves',
                                                'Fabrícia Celina de Lima Brant Campos','Fernanda Cristina Silveira Castro','Fernanda Emilia Vital de Oliveira Duarte',
                                                'Gabriel de Souza Oliveira e Silva','GISELE CRISTINA DE SOUZA RIBEIRO DIAS','Helga Kress Meirelles',
                                                'Isamara Dias Santa Barbara','Jayene Calombe','João Felipe Duarte Pessoa Figueiredo','Joao Lucas Ottoni Santiago Costa',
                                                'Juliana Moraes Araújo','LORENA DELDUCA HEREDIAS','Lorraine Araujo Inacio','Lucas Alves Silva','Luciana Baraviera Magalhães',
                                                'LUCIMARY GOMES BARBOSA','Luiz Eduardo Araujo Carvalho','Maria Paula de Oliveira Tomasi','Miriam Marcia Menezes',
                                                'Naryeli Dadalto Confalonieri','NATALIA ROBERTA DA CRUZ RIBEIRO','Nicole Rodrigues Duarte','OSCAR LAUZID LIMA MORAES',
                                                'Patricio Ferreira','Rafael dos Reis Ribeiro','Rafael dos Santos Pereira','Rafael Quadros Amaral',
                                                'Rayane Pereira Dos Santos Brito','Rejane Alves','Robson Rangel Gonçalves','Rodrigo Augusto Cunha Apostolo',
                                                'ROSIENNI REIS VIANELLO','Sarah Angélica Salomão Bruck','Simone Cristina de Brito','Stéfany Sidô Ventura','Tairon Junior Martins',
                                                'Tatiana Martins Mendes Silvestrow','Vanessa Alves Dias Silveira','Vera Lúcia de Sousa Golini','Walter Osvaldo Perez Vega',
                                                'YURI ALVES DOS SANTOS') AND data_en >= '2022-02-24';

/* Conclusões */                    
SELECT
    dataconclusao, protocolo, statusManifestacao, responsavelconclusao, manifestacaoAssuntoTema, requerAcaoFutura, statusdemanda 
FROM filtro_327
WHERE responsavelconclusao IN ('Amanda Evelin da Silveira Carneiro','Ana Caroline de Jesus Santiago','Ana Luíza Macedo Ribeiro',
                                                'ANA PAULA FERREIRA','André Somma Cosso','Beatriz Kuster Degasperi','Bianca Borges Ferreira',
                                                'Bianca Veríssimo Ferreira','Bibiana Stohler S de Almeida','Bryan Robson dos Santos Campos',
                                                'Carlos Augusto da Silva Júnior','Carolina Rocha Vieira','Caroline Vieira','Clarissa Alves Silva',
                                                'Cyrana Borges Veloso','DAVID DIAS GUIMARAES','DEBORA AGATHA GUIMARAES SANTOS','DÉBORA RECOLIANO',
                                                'Denise Amaral Soares','Diana de Jesus Costa','ELAINE PATRICIA DE ASSIS','Fabiana Figueiredo Gonçalves',
                                                'Fabrícia Celina de Lima Brant Campos','Fernanda Cristina Silveira Castro','Fernanda Emilia Vital de Oliveira Duarte',
                                                'Gabriel de Souza Oliveira e Silva','GISELE CRISTINA DE SOUZA RIBEIRO DIAS','Helga Kress Meirelles',
                                                'Isamara Dias Santa Barbara','Jayene Calombe','João Felipe Duarte Pessoa Figueiredo','Joao Lucas Ottoni Santiago Costa',
                                                'Juliana Moraes Araújo','LORENA DELDUCA HEREDIAS','Lorraine Araujo Inacio','Lucas Alves Silva','Luciana Baraviera Magalhães',
                                                'LUCIMARY GOMES BARBOSA','Luiz Eduardo Araujo Carvalho','Maria Paula de Oliveira Tomasi','Miriam Marcia Menezes',
                                                'Naryeli Dadalto Confalonieri','NATALIA ROBERTA DA CRUZ RIBEIRO','Nicole Rodrigues Duarte','OSCAR LAUZID LIMA MORAES',
                                                'Patricio Ferreira','Rafael dos Reis Ribeiro','Rafael dos Santos Pereira','Rafael Quadros Amaral',
                                                'Rayane Pereira Dos Santos Brito','Rejane Alves','Robson Rangel Gonçalves','Rodrigo Augusto Cunha Apostolo',
                                                'ROSIENNI REIS VIANELLO','Sarah Angélica Salomão Bruck','Simone Cristina de Brito','Stéfany Sidô Ventura','Tairon Junior Martins',
                                                'Tatiana Martins Mendes Silvestrow','Vanessa Alves Dias Silveira','Vera Lúcia de Sousa Golini','Walter Osvaldo Perez Vega',
                                                'YURI ALVES DOS SANTOS') AND dataconclusao >= '2022-02-24';