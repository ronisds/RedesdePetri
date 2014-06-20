//
//  AppDelegate.m
//  RedesDePetri
//
//  Created by Roniel Soares De Sousa on 15/06/14.
//  Copyright (c) 2014 Roniel Soares De Sousa. All rights reserved.
//

#import "AppDelegate.h"
#import "RedesDePetri.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    RedesDePetri *rdp = [[RedesDePetri alloc] init];
    [rdp adicionarTransicao:@"t1"];
    [rdp adicionarTransicao:@"t2"];
    [rdp adicionarTransicao:@"t3"];
    
    [rdp adicionarLugar:@"p1"];
    [rdp adicionarLugar:@"p2"];
    [rdp adicionarLugar:@"p3"];
    [rdp adicionarLugar:@"p4"];
    
    [rdp adicionarArcoDeLugar:@"p1" paraTransicao:@"t1" comPeso:1];
    [rdp adicionarArcoDeLugar:@"p2" paraTransicao:@"t2" comPeso:1];
    [rdp adicionarArcoDeLugar:@"p2" paraTransicao:@"t3" comPeso:1];
    [rdp adicionarArcoDeLugar:@"p3" paraTransicao:@"t3" comPeso:1];
    
    [rdp adicionarArcoDeTransicao:@"t1" paraLugar:@"p2" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"t1" paraLugar:@"p3" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"t2" paraLugar:@"p1" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"t3" paraLugar:@"p3" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"t3" paraLugar:@"p4" comPeso:1];
    
    
    
    
    [rdp setarMarcacao:@{@"p1" : @(1), @"p2" : @(0),@"p3" : @(0),@"p4" : @(0)}];
    
    
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    

    
    

    
    No *arvore = [rdp arvoreDeCobertura];
    
    NSMutableArray *nos = [NSMutableArray new];
    [nos addObject:arvore];
    NSLog(@"\n\nÁrvore de Cobertura\n");
    while ([nos count]) {
        No *atual = [nos firstObject];
        
        NSLog(@"\nMarcação com transição %@:\n%@\n",atual.transicao ,atual.marcacao);
        [nos addObjectsFromArray:atual.filhos];
        [nos removeObject:atual];
    }

}

@end
