//
//  RedesDePetri.m
//  RedesDePetri
//
//  Created by Roniel Soares De Sousa on 15/06/14.
//  Copyright (c) 2014 Roniel Soares De Sousa. All rights reserved.
//

#import "RedesDePetri.h"


@implementation No

-(id) init {
    if (self = [super init]) {
        _filhos = [NSMutableArray new];
        _pai = nil;
        _estado = 0;
    }
    return self;
}

@end




@interface Arco : NSObject

@property (strong, nonatomic) NSString *lugar;
@property (strong, nonatomic) NSString *transicao;
@property (strong, nonatomic) NSNumber *peso;

@end

@implementation Arco

@end



@interface RedesDePetri ()

@property (strong, nonatomic) NSMutableSet *lugares;
@property (strong, nonatomic) NSMutableSet *transicoes;
@property (strong, nonatomic) NSMutableArray *arcosDeEntrada;
@property (strong, nonatomic) NSMutableArray *arcosDeSaida;
@property (strong, nonatomic) NSMutableDictionary *marcacao;
@property (strong, nonatomic) NSMutableArray *historicoDeMarcacoes;

@end

@implementation RedesDePetri

-(id)init {
    if (self = [super init]) {
        _lugares = [NSMutableSet new];
        _transicoes = [NSMutableSet new];
        _arcosDeEntrada = [NSMutableArray new];
        _arcosDeSaida = [NSMutableArray new];
        _historicoDeMarcacoes = [NSMutableArray new];
        _marcacao = [NSMutableDictionary new];
    }
    return self;
}

-(BOOL)adicionarLugar:(NSString *)lugar {
    if (![_lugares containsObject:lugar]) {
        [_marcacao setValue:@(0) forKey:lugar];
        [_lugares addObject:lugar];
        return YES;
    }
    return NO;
}

-(BOOL) adicionarTransicao:(NSString *)transicao {
    if (![_transicoes containsObject:transicao]) {
        [_transicoes addObject:transicao];
        return YES;
    }
    return NO;
}

-(BOOL) adicionarArcoDeLugar:(NSString *)lugar paraTransicao:(NSString *)transicao comPeso:(NSInteger)peso {
    if (![_lugares containsObject:lugar] || ![_transicoes containsObject:transicao]) {
        return NO;
    }
    
    for (Arco *a in _arcosDeEntrada) {
        if ([a.lugar isEqualToString:lugar] && [a.transicao isEqualToString:transicao]) {
            [a setPeso:@(peso)];
            return YES;
        }
    }
    
    Arco *novoArco = [Arco new];
    novoArco.lugar = lugar;
    novoArco.transicao = transicao;
    novoArco.peso = @(peso);
    [_arcosDeEntrada addObject:novoArco];
    
    return YES;
}

-(BOOL) adicionarArcoDeTransicao:(NSString *)transicao paraLugar:(NSString *)lugar comPeso:(NSInteger)peso {
    if (![_lugares containsObject:lugar] || ![_transicoes containsObject:transicao]) {
        return NO;
    }
    
    for (Arco *a in _arcosDeSaida) {
        if ([a.lugar isEqualToString:lugar] && [a.transicao isEqualToString:transicao]) {
            [a setPeso:@(peso)];
            return YES;
        }
    }
    
    Arco *novoArco = [Arco new];
    novoArco.lugar = lugar;
    novoArco.transicao = transicao;
    novoArco.peso = @(peso);
    [_arcosDeSaida addObject:novoArco];
    
    return YES;
}

-(NSArray*)entradasDeTransicao:(NSString *)transicao {
    if (![_transicoes containsObject:transicao]) {
        return nil;
    }
    NSMutableArray *retorno = [NSMutableArray new];
    
    for (Arco *a in _arcosDeEntrada) {
        if ([a.transicao isEqualToString:transicao]) {
            [retorno addObject:a.lugar];
        }
    }
    
    return retorno;
}

-(NSArray*)saidasDeTransicao:(NSString *)transicao {
    if (![_transicoes containsObject:transicao]) {
        return nil;
    }
    
    NSMutableArray *retorno = [NSMutableArray new];
    
    for (Arco *a in _arcosDeSaida) {
        if ([a.transicao isEqualToString:transicao]) {
            [retorno addObject:a.lugar];
        }
    }
    
    return retorno;
}


-(NSDictionary*)entradasEPesosDeTransicao:(NSString *)transicao {
    if (![_transicoes containsObject:transicao]) {
        return nil;
    }
    NSMutableDictionary *retorno = [NSMutableDictionary new];
    
    for (Arco *a in _arcosDeEntrada) {
        if ([a.transicao isEqualToString:transicao]) {
            [retorno setValue:a.peso forKey:a.lugar];
        }
    }
    
    return retorno;
}

-(NSDictionary*)saidasEPesosDeTransicao:(NSString *)transicao {
    if (![_transicoes containsObject:transicao]) {
        return nil;
    }
    NSMutableDictionary *retorno = [NSMutableDictionary new];
    
    for (Arco *a in _arcosDeSaida) {
        if ([a.transicao isEqualToString:transicao]) {
            [retorno setValue:a.peso forKey:a.lugar];
        }
    }
    
    return retorno;
}

-(BOOL) setarMarcacao:(NSDictionary *)marcacao {
    NSArray *keys = [marcacao allKeys];
    if ([keys count] != [_lugares count]) {
        return NO;
    }
    for (NSString *lugar in _lugares) {
        if (![keys containsObject:lugar]) {
            return NO;
        }
    }
    
    _marcacao = [NSMutableDictionary dictionaryWithDictionary:marcacao];
    [_historicoDeMarcacoes removeAllObjects];
    
    return YES;
}

-(NSDictionary *) marcacaoAtual {
    return _marcacao;
}

-(NSArray *) historicoDeMarcacoes {
    return _historicoDeMarcacoes;
}

-(NSArray*) transicoesHabilitadas {
    return [self transicoesHabilitadasComMarcacao:_marcacao];
}


-(BOOL) aplicarTransicao:(NSString *)transicao {
    NSDictionary *r = [self aplicarTransicao:transicao comMarcacao:_marcacao];
    if (r) {
        _marcacao = [NSMutableDictionary dictionaryWithDictionary:r];
        return YES;
    } else {
        return NO;
    }
}

-(NSArray*) transicoesHabilitadasComMarcacao:(NSDictionary*)marcacao {
    NSMutableArray *retorno = [NSMutableArray new];
    BOOL habilitada;
    for (NSString *t in _transicoes) {
        habilitada = YES;
        
        NSDictionary *entradas = [self entradasEPesosDeTransicao:t];
        NSArray *keys = [entradas allKeys];
        for (NSString *k in keys) {
            if ([[marcacao valueForKey:k] isEqualToNumber:@(-1)]) {
                continue;
            }
            NSNumber *v = [entradas valueForKey:k];
            if ([v isGreaterThan:[marcacao valueForKey:k]]) {
                habilitada = NO;
                break;
            }
        }
        if (habilitada) {
            [retorno addObject:t];
        }
    }
    return retorno;
}

-(NSDictionary *) aplicarTransicao:(NSString *) transicao comMarcacao:(NSDictionary *) marcacao {
    if (![_transicoes containsObject:transicao] || ![[self transicoesHabilitadasComMarcacao:marcacao] containsObject:transicao]) {
        return nil;
    }
    
    
    NSMutableDictionary *marcacaoFinal = [[NSMutableDictionary alloc] initWithDictionary:marcacao];
    
    NSDictionary *entradasEPesos = [self entradasEPesosDeTransicao:transicao];
    NSArray *keys = [entradasEPesos allKeys];
    for (NSString *k in keys) {
        NSNumber *p = [entradasEPesos valueForKey:k];
        [marcacaoFinal setValue:@([[marcacaoFinal valueForKey:k] integerValue] - [p integerValue]) forKey:k];
    }
    
    
    NSDictionary *saidasEPesos = [self saidasEPesosDeTransicao:transicao];
    keys = [saidasEPesos allKeys];
    for (NSString *k in keys) {
        NSNumber *p = [saidasEPesos valueForKey:k];
        [marcacaoFinal setValue:@([[marcacaoFinal valueForKey:k] integerValue] + [p integerValue]) forKey:k];
    }
    
    return marcacaoFinal;
}

-(No*) arvoreDeCobertura {
    No *raiz = [[No alloc] init];
    [raiz setMarcacao:_marcacao];
    
    NSMutableArray *fila = [[NSMutableArray alloc] initWithObjects:raiz, nil]; //Fila com folhas que precisam ser expandidas
    
    while ([fila count] != 0) {
        No *atual = [fila firstObject];
        NSArray *transicoesHabilitadas = [self transicoesHabilitadasComMarcacao:atual.marcacao];
        if ([transicoesHabilitadas count] != 0) { // Não terminal
            NSMutableDictionary *ws = [NSMutableDictionary new];
            NSArray *keys = [atual.marcacao allKeys];
            for (NSString *k in keys) {
                NSNumber *p = [atual.marcacao valueForKey:k];
                if ([p isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                    [ws setValue:p forKey:k];
                }
            }
            for (NSString *t in transicoesHabilitadas) {
                
                No *novoNo = [[No alloc] init];
                [novoNo setTransicao:t];
           //     NSLog(@"<<Aplicando marcacao %@>>",atual.marcacao);
                [novoNo setMarcacao:[NSMutableDictionary dictionaryWithDictionary:[self aplicarTransicao:t comMarcacao:atual.marcacao]]];
                novoNo.pai = atual;
           //     NSLog(@"<<Adicionando No \nmarcacao %@\n filhos %@\npai %@\n transicao %@\nestado %ld \nfilhodetransicao %@\n",novoNo.marcacao,novoNo.filhos,novoNo.pai,novoNo.transicao,(long)novoNo.estado,novoNo.pai.transicao);
                if ([ws count] > 0) {
           //         NSLog(@"<Marcacao antiga1 %@>",novoNo.marcacao);
                    [novoNo.marcacao addEntriesFromDictionary:ws];
            //        NSLog(@"<Marcacao nova1 %@>",novoNo.marcacao);
                }
                
           //     NSLog(@"<Marcacao antiga2 %@>",novoNo.marcacao);
                [self procurarLoopECorrigir:atual marcacao:novoNo.marcacao];
            //    NSLog(@"<Marcacao nova2 %@>",novoNo.marcacao);
                
                
                if ([self verificarSePossuiMarcacaoIgualA:novoNo.marcacao emArvore:raiz]) { // Duplicado
                    novoNo.estado = 2;
                } else {
                    [fila addObject:novoNo];
                }
                
                [atual.filhos addObject:novoNo];
                
            }
        } else { // Terminal
            atual.estado = 1;
        }
        [fila removeObjectAtIndex:0];
    }
    
    return raiz;
}

-(BOOL) procurarLoopECorrigir:(No *) no marcacao:(NSMutableDictionary *) marcacao {
    if (no == nil) {
        return NO;
    } else {
        NSArray *keys = [marcacao allKeys];
        NSMutableArray *chavesMaiores = [NSMutableArray new];
        BOOL possuiMenor = NO;
        for (NSString *k in keys) {
            NSNumber *p = [marcacao valueForKey:k];
            NSNumber *p2 = [no.marcacao valueForKey:k];
            if ([p isGreaterThan:p2]) {
                [chavesMaiores addObject:k];
            } else if ([p isLessThan:p2]) {
                possuiMenor = YES;
                break;
            }
        }
        
        if (!possuiMenor && [chavesMaiores count] > 0) { // Domina
            for (NSString *k in chavesMaiores) {
                [marcacao setValue:[NSNumber numberWithInt:-1] forKey:k];
            }
            return YES;
        } else {
            return [self procurarLoopECorrigir:no.pai marcacao:marcacao];
        }
    }
    
    return NO;
}

-(BOOL) verificarSePossuiMarcacaoIgualA:(NSDictionary*) marcacao emArvore:(No*) raiz {
    if (raiz == nil) {
        return NO;
    }
    
    if ([raiz.marcacao isEqualToDictionary:marcacao]) {
        return YES;
    }
    
    BOOL retorno = NO;
    
    for (No *f in raiz.filhos) {
        if ([self verificarSePossuiMarcacaoIgualA:marcacao emArvore:f]) {
            retorno = YES;
            break;
        }
    }
    
    return retorno;
}


@end
