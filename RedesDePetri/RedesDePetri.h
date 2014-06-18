//
//  RedesDePetri.h
//  RedesDePetri
//
//  Created by Roniel Soares De Sousa on 15/06/14.
//  Copyright (c) 2014 Roniel Soares De Sousa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedesDePetri : NSObject


-(id) init;

//Retorna NO se já existir um lugar com o mesmo nome
-(BOOL)adicionarLugar:(NSString *) lugar;

//Retorna NO se já existir uma transição com o mesmo nome
-(BOOL)adicionarTransicao:(NSString *) transicao;

//Se já existir, altera o peso da anterior e retorna YES
//Retorna NO se não existir um lugar com o nome passado ou se não existir uma transição com o nome passado
-(BOOL)adicionarArcoDeLugar:(NSString *) lugar paraTransicao:(NSString*) transicao comPeso:(NSInteger) peso;

//Se já existir, altera o peso da anterior e retorna YES
//Retorna NO se não existir um lugar com o nome passado ou se não existir uma transição com o nome passado
-(BOOL)adicionarArcoDeTransicao:(NSString *) transicao paraLugar:(NSString*) lugar comPeso:(NSInteger) peso;

//Retorna os lugares de entrada da transição
//Retorna nil se a transição não existir
-(NSArray*)entradasDeTransicao:(NSString *) transicao;

//Retorna os lugares de saida da transicao
//Retorna nil se a transição não existir
-(NSArray*)saidasDeTransicao:(NSString *) transicao;

//Recebe um dicionario onde as chaves sao os lugares e os valores sao as marcacoes
//Reseta o historico de marcações da rede, tendo apenas a marcação recebida como marcação inicial
//Retorna NO se o dicionário não possuir todos os lugares existentes na rede e apenas estes lugares, neste caso não reseta o histórico
-(BOOL) setarMarcacao:(NSDictionary*) marcacao;

//Retorna a marcação atual
-(NSDictionary *) marcacaoAtual;

//Retorna um array de marcações (Cada marcação é um NSDictionary)
-(NSArray *) historicoDeMarcacoes;

//Retorna as transições habilitadas
-(NSArray *) transicoesHabilitadas;

//Retorna NO se não existir uma transição com o nome passado ou se ela não estiver habilitada
-(BOOL) aplicarTransicao:(NSString *) transicao;

@end
