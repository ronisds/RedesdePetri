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
    [rdp adicionarTransicao:@"T1"];
    [rdp adicionarTransicao:@"T2"];
    [rdp adicionarTransicao:@"T3"];
    [rdp adicionarTransicao:@"T4"];
    
    [rdp adicionarLugar:@"A"];
    [rdp adicionarLugar:@"B"];
    [rdp adicionarLugar:@"C"];
    
    [rdp adicionarArcoDeTransicao:@"T1" paraLugar:@"A" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"T2" paraLugar:@"B" comPeso:1];
    [rdp adicionarArcoDeTransicao:@"T3" paraLugar:@"C" comPeso:2];
    [rdp adicionarArcoDeLugar:@"A" paraTransicao:@"T3" comPeso:2];
    [rdp adicionarArcoDeLugar:@"B" paraTransicao:@"T3" comPeso:1];
    [rdp adicionarArcoDeLugar:@"C" paraTransicao:@"T4" comPeso:2];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    
    [rdp aplicarTransicao:@"T1"];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    
    [rdp aplicarTransicao:@"T1"];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    
    [rdp aplicarTransicao:@"T2"];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    
    [rdp aplicarTransicao:@"T3"];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);
    
    [rdp aplicarTransicao:@"T4"];
    
    NSLog(@"Marcação Atual: \n%@\n\n",[rdp marcacaoAtual]);
    NSLog(@"Transições Habilitadas: \n%@\n\n",[rdp transicoesHabilitadas]);

}

@end
