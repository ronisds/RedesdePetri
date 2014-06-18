//
//  RedesDePetri.m
//  RedesDePetri
//
//  Created by Roniel Soares De Sousa on 15/06/14.
//  Copyright (c) 2014 Roniel Soares De Sousa. All rights reserved.
//

#import "RedesDePetri.h"


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
    NSMutableArray *retorno = [NSMutableArray new];
    BOOL habilitada;
    for (NSString *t in _transicoes) {
        habilitada = YES;
        NSDictionary *entradas = [self entradasEPesosDeTransicao:t];
        NSArray *keys = [entradas allKeys];
        for (NSString *k in keys) {
            NSNumber *v = [entradas valueForKey:k];
            if (v > [_marcacao valueForKey:k]) {
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


-(BOOL) aplicarTransicao:(NSString *)transicao {
    BOOL retorno = YES;
    
    if (![_transicoes containsObject:transicao] || ![[self transicoesHabilitadas] containsObject:transicao]) {
        return NO;
    }
    
    [_historicoDeMarcacoes addObject:_marcacao];
    
    NSDictionary *entradasEPesos = [self entradasEPesosDeTransicao:transicao];
    NSArray *keys = [entradasEPesos allKeys];
    for (NSString *k in keys) {
        NSNumber *p = [entradasEPesos valueForKey:k];
        [_marcacao setValue:@([[_marcacao valueForKey:k] integerValue] - [p integerValue]) forKey:k];
    }
    
    NSDictionary *saidasEPesos = [self saidasEPesosDeTransicao:transicao];
    keys = [saidasEPesos allKeys];
    for (NSString *k in keys) {
        NSNumber *p = [saidasEPesos valueForKey:k];
        [_marcacao setValue:@([[_marcacao valueForKey:k] integerValue] + [p integerValue]) forKey:k];
    }
    
    return retorno;
}

@end
