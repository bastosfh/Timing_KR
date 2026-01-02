cd '~/Timing_CR';
% Timing_cr_mouse


% q
% Screen('CloseAll');

% Notas da versão no final do arquivo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% configuracoes %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nome do experimento. Incluir o nome do grupo no codigo
experimento = 'old_self_cr_cog_desemp';
% 'old_self_cr_cog_desemp'

% Numero do sujeito
sjnum = '27';
% Número entre aspas simples

% Número de tentativas no baseline
ntt_baseline = 20;

% Número de tentativas de pratica
ntt = 90;
% Aquisição = 90
% Retenção e Transferência = 20 (será definido automaticamente pelo número de linhas em 'transfer_vels_2.txt' ou 'transfer_vels_3.txt')

% Determina se o sj vai escolher ou se sera externamente determinado
pratica = 'det';
% 'det' = organizacao da pratica determinada pelo arquivo arquivo_org_pratica.txt

% 'trf' = teste de transferencia (sem feedback apos cada tentativa). Organizacao determinada pelo arquivo nomeado abaixo.
% 'rtc' = teste de retenção. Similar à condição trf, porém, exibe o questionário antes da primeira tentativa (não ocorre ao rodar 'trf')1111

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1111111111111111111111111111111111111111111111111111

% Determina como será fornecido o feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feedback_fixo = '6';

%%%%%%%%%% Grupos auto e determinados externamente
% []; = pergunta ao sujeito sobre qual tentativa gostaria de receber feedback (melhor ou pior)
% '1' = feedback sobre a melhor tentativa
% '2' = feedback sobre a pior tentativa
% '3' = feedback fornecido na frequência definida em arquivo externo. Ver a opção 'arquivo_frq_feedback' abaixo.
% '4' = feedback autocontrolado a partir da 4 tentativa (3 tentativas de pre-teste)

%%%%%%%%%% Yoked
% '5' = faz o yoked do "feedback_fixo = [];" (inserir acima 'experimento' e 'sjnum' iguais aos do participante auto)
% '6' = faz o yoked do "feedback_fixo = '4';" (inserir acima 'experimento' e 'sjnum' iguais aos do participante auto)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

questionario = '1';
% '1' = apresenta o questionario de autoeficácia na tentativa 3, 15, 30...
% '2' = sem questionario
% Ao rodar a fase de aquisição com questionário = '1', rode o teste (trf ou rtc) com a mesma opção
% Para que o arquivo final tenha o mesmo tamanho. O questionário não será apresentado na trf.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









% Nome do arquivo contendo a frequência de feedback a ser exibida (caso ela seja determinada externamente: feedback_fixo = '3';)
arquivo_frq_feedback = 'arquivo_frq_feedback_100.txt';
% 'arquivo_frq_feedback_100.txt'
% 'arquivo_frq_feedback_33.txt'

% Nome do arquivo contendo as velocidades que serão utilizadas no teste (trf ou rtc)
arquivo_velocidades_transfer = 'transfer_vels_2.txt';
% 'transfer_vels_2.txt' = velocidade 2 (média) para o teste
% 'transfer_vels_3.txt' = velocidade 3 (rápida) para o teste

% Nome do arquivo contendo a organização da prática (caso ela seja determinada externamente: pratica = 'det';)
arquivo_org_pratica = 'arquivo_org_pratica.txt';

% Habilita a informação de comparação social
comparacao_social = [];
% 'pos' = mostra o erro absoluto médio do participante e o "erro do grupo" acima do dele em 20%
% 'neg' = mostra o erro absoluto médio do participante e o "erro do grupo" abaixo do dele em 20%
% []; = não apresenta a informação de comparação social

% Determina a instrução apresentada na tela
instrucao = 'tar';
% 'tar' = meta da tarefa
% 'apr' = meta de aprendizagem

instr_feedback = '2';
% '1' = mostra a frase sobre o feedback ser após 'boas' ou 'más'
% '2' = mostra apenas o feedback


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% enderecos fisicos %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
script_path = '/home/coleta/Timing_CR';
interval_to_target_mov_path = '/home/coleta/Timing_CR/interval_to_target_mov.txt';
line_positions_path = '/home/coleta/Timing_CR/line_positions.txt';
myu3_path = '/home/coleta/LabJackPython/labjack-LJFuse/root-ljfuse/MyU3/connection/AIN0'; %define o caminho para ler a resposta do switch

txt_name = sprintf('%s_suj%s.txt', experimento, sjnum); %nome do arquivo txt para salvar todas as tentativas do sujeito
arquivo_sj_path = sprintf('/home/coleta/Timing_CR/%s/%s_suj%s.txt', experimento, experimento, sjnum);

practice_schedule_path = sprintf('/home/coleta/Timing_CR/%s', arquivo_org_pratica);

frq_feedback_path = sprintf('/home/coleta/Timing_CR/%s', arquivo_frq_feedback);


% Carrega os dados do sujeito autocontrolado se for um experimento yoked
if feedback_fixo == '5' || feedback_fixo == '6'
	practice_schedule_path = arquivo_sj_path;
	txt_name = sprintf('%s_yoked_suj%s.txt', experimento, sjnum); % Nome do arquivo txt para sujeitos Yoked
	
	yok_feedback = dlmread(practice_schedule_path, '\t', [0 4 133 4]); % [linha_inicial coluna_inicial linha_final coluna_final] % O primeiro índice é igual a 0 (ex.: coluna 1 = 0)
	arquivo_sj_path = sprintf('/home/coleta/Timing_CR/%s/%s_yoked_suj%s.txt', experimento, experimento, sjnum);
end


%%%%%%%%%%%%%%%%%%%%%
% Determina a oclusão 
%%%%%%%%%%%%%%%%%%%%%
% Determina o ponto horizontal na tela (em pixels) em que a oclusão do alvo ocorrerá (ou não)
% ponto_para_oclusao = 1;
% Para que não haja oclusão do alvo: ponto_para_oclusao = 0;
% Para a oclusão no centro da tela: ponto_para_oclusao = 1;
% Para oclusão na transferência (1/3 da tela): ponto_para_oclusao = 2;



transfer_vels_path = sprintf('/home/coleta/Timing_CR/%s', arquivo_velocidades_transfer);
%transfer_vels_path = '/home/coleta/Timing_CR/transfer_vels.txt';

mkdir(experimento); % Criar uma pasta para armazenar os arquivos deste experimento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% carrega valores de arquivos externos %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carrega os tempos 'aleatorios' para o movimento do alvo apos o sinal de atencao
interval_to_target_mov = load(interval_to_target_mov_path);
% Carrega as posicoes 'aleatorias' para a linha
line_positions = load(line_positions_path);
% Carrega as velocidades do alvo para o teste de transferencia
transfer_vels = load(transfer_vels_path);
% Carrega as velocidades do alvo para a pratica determinada pelo experimentador
% Além disso, evita erro ao determinar o ntt da transferencia


if pratica == 'det'
    practice_schedule = load(practice_schedule_path);
elseif pratica == 'trf' || pratica == 'rtc'
    ntt = length(transfer_vels);
end

% Carrega o arquivo externo contendo a frequência de feedback a ser exibida (caso feedback_fixo = '3')
frq_feedback = load(frq_feedback_path);

% Confere se o Labjack esta habilitado
%try
%    dlmread(myu3_path);
%catch
%    error('***** O Labjack não está ativado! *****')
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% preparar a tela e as cores %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opens the active window
screenNum = 1;

% Modifica a resolução e a frequência do monitor (refresh rate)
% Antes de abrir a janela em que serão gerados os estímulos
%oldResolution = Screen('Resolution', screenNum, 1366, 768, 60);

% A solução comentada acima não dá conta da configuração com dois monitores. Esta abaixo, sim.
oldResolution = Screen('ConfigureDisplay', setting = 'Scanout', screenNumber = screenNum, outputId = 0, newwidth = 1680, newheight = 1050, newHz = 120);
[wPtr,rect] = Screen('OpenWindow', screenNum); % Using screen number only, the whole screen is used as default

% Color parameters MUST came after openning the window
black = BlackIndex(wPtr);
white = WhiteIndex(wPtr);
red = [255 0 0];
green = [0 255 0];
yellow = [255 255 0];
proj_color = [0 255 0];

% Fills the open window with black
Screen('FillRect', wPtr, black);
Screen('Flip', wPtr); % Flip
HideCursor(wPtr);
WaitSecs(0.1); % Waits a specified time (in seconds)

% Adquire a frequencia do monitor para calcular o tempo entre tentativas
[monitorFlipInterval nrValidSamples stddev] = Screen('GetFlipInterval', wPtr);
% Put functions into memory for speed
GetSecs;
WaitSecs(0.1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% preparar coordenadas para exibir o feedback %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_mouse_ini = round(rect(RectRight)/35);
y_mouse_ini = rect(RectBottom)/2; %- round((rect(RectRight)/35)/2);
vertical_increment = 0;

% Target size
size_horiz = rect(RectRight)/11;
size_vert = rect(RectRight)/45;

% Cursor size
cursor_horiz = rect(RectRight)/35;
cursor_vert = cursor_horiz;

% Distance between cursors
cursor_dist_h = rect(RectRight)/6; %+ (cursor_horiz/2);
cursor_dist_v = ((y_mouse_ini - rect(RectBottom)/3)*2) + size_vert;

% Cursor case size
case_h = cursor_horiz*0.7;
case_v = case_h;

% Target 1 coordinates
x_esq1 = rect(RectRight)/5 - (cursor_horiz/2);
x_dir1 = x_esq1 + size_horiz;
y_esq1 = rect(RectBottom)/3 - vertical_increment;
y_dir1 = y_esq1 + size_vert;

% Target 2 coordinates
x_esq2 = rect(RectRight)/5 - (cursor_horiz/2) + cursor_dist_h;
x_dir2 = x_esq2 + size_horiz;
y_esq2 = rect(RectBottom)/3 - vertical_increment;
y_dir2 = y_esq2 + size_vert;

% Target 3 coordinates
x_esq3 = rect(RectRight)/5 - (cursor_horiz/2) + cursor_dist_h*2;
x_dir3 = x_esq3 + size_horiz;
y_esq3 = rect(RectBottom)/3 - vertical_increment;
y_dir3 = y_esq3 + size_vert;

% Target 4 coordinates
x_esq4 = rect(RectRight)/5 - (cursor_horiz/2) + cursor_dist_h*3;
x_dir4 = x_esq4 + size_horiz;
y_esq4 = rect(RectBottom)/3 - vertical_increment;
y_dir4 = y_esq4 + size_vert;

% Target 5 coordinates
x_esq5 = rect(RectRight)/5 - (cursor_horiz/2) + cursor_dist_h*4;
x_dir5 = x_esq5 + size_horiz;
y_esq5 = rect(RectBottom)/3 - vertical_increment;
y_dir5 = y_esq5 + size_vert;

% Target 6 coordinates
x_esq6 = rect(RectRight)/5 - (cursor_horiz/2) + cursor_dist_h*5;
x_dir6 = x_esq6 + size_horiz;
y_esq6 = rect(RectBottom)/3 - vertical_increment;
y_dir6 = y_esq6 + size_vert;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Coordenadas para exibir o feedback
x_feed1 = x_esq1;
y_feed1 = y_esq1;

x_feed2 = x_esq2;
y_feed2 = y_esq2;

x_feed3 = x_esq3;
y_feed3 = y_esq3;

x_feed4 = x_esq4;
y_feed4 = y_esq4;

x_feed5 = x_esq5;
y_feed5 = y_esq5;

x_feed6 = x_esq6;
y_feed6 = y_esq6;

% Pool with all positions for feedback drawing
x_feed_all = [x_feed1 x_feed2 x_feed3 x_feed4 x_feed5 x_feed6];
y_feed_all = [y_feed1 y_feed2 y_feed3 y_feed4 y_feed5 y_feed6];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% loop de tentativas %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Caso o número de tentativas seja diferente do número de linhas do arquivo
% (número de tentativas já realizado)
% É realizada uma correção no número de tentativas
% Esta correção não é realizada no caso de um teste de transferência
if pratica != 'trf' && pratica != 'rtc'
    
    try
        dlmread(arquivo_sj_path);
        arquivo_sj = dlmread(arquivo_sj_path);       
        trial = size(arquivo_sj, 1);
    catch
        trial = 0;
    end
    
    ponto_para_oclusao = 1;
    
elseif pratica == 'trf'
    
    ponto_para_oclusao = 2;
    trial = 0;

elseif pratica == 'rtc'
	
	ponto_para_oclusao = 1;
    trial = 0;

end


while trial < ntt
    
    trial = trial + 1;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%% Questionario rtc %%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    if (questionario == '1') && (pratica == 'rtc' || pratica == 'trf') && trial == 1
    
    
		% Determina as coordenadas iniciais do referencia
		referencia_left = rect(RectLeft);
		referencia_top = (rect(RectBottom)/2) - (rect(RectBottom)/32); % Determina a distancia entre o referencia e o topo da tela
		referencia_larg = rect(RectRight)/18;
		referencia_alt = rect(RectBottom)/32;
		
		y_cursor_dir = referencia_top/2;
		
		% Para colocar os números no lugar certo na referencia
		referencia_larg_total = ((rect(RectRight) - (referencia_larg*4)) - (rect(RectLeft) + (referencia_larg*4)));
		referencia_larg_partes = referencia_larg_total / 10;	
		
		
		% Primeira tela para garantir que o tempo para a primeira resposta
		% Não varie em razão do tempo até que o participante chegue até o mouse
		response_primeira_tela_quest = 0;
		response_segunda_tela_quest = 0; % Esta variável se refere à segunda tela (participante deixa o mouse e volta ao switch)
		
		while response_primeira_tela_quest == 0
			
			[x_mouse, y_mouse, response_primeira_tela_quest] = GetMouse(wPtr);
			
			Screen('TextFont',wPtr, 'Ubuntu');
			Screen('TextSize',wPtr, 30);
			Screen('DrawText', wPtr, 'Clique com o mouse para iniciar o questionário', (rect(RectLeft) + (referencia_larg*4)), 300, [255, 255, 255]);
			
			Screen('Flip', wPtr); % Flip
		
		end
		
		
		
		
		
		% Sets cursor starting position
		x_mouse_ini = round(referencia_larg*2);
		y_mouse_ini = round(referencia_top - (referencia_alt/2));
		SetMouse(x_mouse_ini, y_mouse_ini);
		
		% Variáveis do próximo loop
		response = 0;
		quest_trial = 1;
		
			texto_quest_1 = ['250 ms?'];
			texto_quest_2 = ['200 ms?'];
			texto_quest_3 = ['100 ms?'];
			texto_quest_4 = ['80 ms?'];
			texto_quest_5 = ['50 ms?'];
			texto_quest_6 = ['30 ms?'];
			texto_quest_7 = ['10 ms?'];
			
			texto_quest_all = [texto_quest_1; texto_quest_2; texto_quest_3; texto_quest_4; texto_quest_5; texto_quest_6; texto_quest_7];
			
			
			% Faz a perguntar ficar na tela até que uma opção seja escolhida
			time_quest_ini = GetSecs; % Inicia o cronometro do tempo para o questionario
			time_quest_all = []; % Armazena os tempo das respostas
			pos_selecionada_all = []; % Armazena a posicao do mouse no momento do click (resposta)
			WaitSecs(0.1);
			
			% Determinar a resposta as questoes
			while quest_trial <= 7
				
				[x_mouse, y_mouse, response] = GetMouse(wPtr);
				
				% Para que não valha o click, caso o cursor não esteja na região demarcada
				if x_mouse < (rect(RectLeft) + (referencia_larg*4))
					response = 0;
					
				elseif x_mouse > (rect(RectRight) - (referencia_larg*4))
					x_mouse = (rect(RectRight) - (referencia_larg*4));
					
				end
				
				
				
				% Desenha a referência para a resposta (retângulo)
				Screen('FillRect', wPtr, yellow, [(rect(RectLeft) + (referencia_larg*4)) referencia_top (rect(RectRight) - (referencia_larg*4)) (referencia_top + referencia_alt)]);
				
				% Desenha o cursor para determinar a resposta
				Screen('DrawLine', wPtr, white, x_mouse, y_mouse_ini, x_mouse, (y_mouse_ini + y_cursor_dir), 1);
				
				% Texto explicativo dentro da animação de escolha
				Screen('TextFont',wPtr, 'Ubuntu');
				
				Screen('TextSize',wPtr, 30);
				Screen('DrawText', wPtr, 'Agora, você está confiante de que alcançará um erro, em média, menor do que', (rect(RectLeft) + (referencia_larg*4)), (rect(RectBottom)/4), [255, 255, 255]);
				
				Screen('TextSize',wPtr, 50);
				Screen('DrawText', wPtr, texto_quest_all(quest_trial, :), (rect(RectLeft) + (referencia_larg*15)), (rect(RectBottom)/3), [255, 255, 255]);				
							
				Screen('TextSize',wPtr, 20);	
				Screen('DrawText', wPtr, 'Utilize a escala de 0 a 10 como o guia', x_mouse_ini, (y_mouse_ini + (y_cursor_dir*1.2)), [255, 255, 255]);
			
			% Desenha os valores de referencia (0 a 10)
			Screen('TextSize',wPtr, 30);	
			Screen('DrawText', wPtr, '0', (rect(RectLeft) + (referencia_larg*4)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '1', (rect(RectLeft) + (referencia_larg*4) + referencia_larg_partes), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '2', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*2)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '3', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*3)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '4', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*4)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '5', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*5)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '6', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*6)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '7', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*7)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '8', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*8)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '9', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*9)), (referencia_top + referencia_larg), [255, 255, 255]);
			Screen('DrawText', wPtr, '10', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*10)), (referencia_top + referencia_larg), [255, 255, 255]);
		
			
			
		
			% Para que o tempo seja armazenado quando uma resposta valida for dada
			if  response(1) == 1
				quest_trial = quest_trial + 1;
				time_quest_all = [time_quest_all GetSecs]; % Armazena o tempo apos cada resposta
				pos_selecionada_all = [pos_selecionada_all x_mouse];
				WaitSecs(0.2);
			end
			

			
			Screen('Flip', wPtr); % Flip
			
		end
		
		
		% Converte as posicoes do mouse, selecionadas nas respostas, em valores de 0 a 10
		likert = round(((pos_selecionada_all - (rect(RectLeft) + (referencia_larg*4))) / ((rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*10)) - (rect(RectLeft) + (referencia_larg*4)))) * 10);
		
		% Calcula o tempo para cada resposta
		time_ref = [time_quest_ini time_quest_all(1) time_quest_all(2) time_quest_all(3) time_quest_all(4) time_quest_all(5) time_quest_all(6)];
		time_quest_diferencas = time_quest_all - time_ref;
		
		% Como será necessário armazenar esse dado, é preciso gerá-lo aqui
		time_comparacao_social = 0;
		
		% Tela para evitar que o participante tenha que voltar para o switch apressadamente e prejudique o desempenho
		% Na primeira tentativa após o questionário
		% Caso seja a última tentativa, esta tela não é apresentada
		if trial < ntt
			
			while response_segunda_tela_quest(1) == 0
				
				[x_mouse, y_mouse, response_segunda_tela_quest] = GetMouse(wPtr); % Lê o mouse
				
				Screen('TextFont',wPtr, 'Ubuntu');
				Screen('TextSize',wPtr, 30);
				Screen('DrawText', wPtr, 'Pressione o botão do mouse para iniciar a prática', (rect(RectLeft) + (referencia_larg*4)), 300, [255, 255, 255]);
				
				Screen('Flip', wPtr); % Flip
			
			end
			
		end
	

	elseif questionario == '1' && (pratica == 'rtc' || pratica == 'trf') && trial != 1
	
		likert = [0 0 0 0 0 0 0];
		time_quest_diferencas = [0 0 0 0 0 0 0];
		% Como será necessário armazenar esse dado, é preciso gerá-lo aqui
		time_comparacao_social = 0;
		
	end
  
    
    
    % Conta o ntt que faltam para cada tentativa
    if trial == 1
        ntt_v1 = ntt/3; % Numero maximo de tt por velocidade
        ntt_v2 = ntt/3;
        ntt_v3 = ntt/3;
        arquivo_sj = []; % Para o acesso ao número de tentativas (feedback)
    else
        arquivo_sj = dlmread(arquivo_sj_path); % Le o arquivo do sj atual
        
        %WaitSecs(0.1);
        
        ntt_v1 = (ntt/3) - (length(arquivo_sj(arquivo_sj(:,1) == 1)));
        ntt_v2 = (ntt/3) - (length(arquivo_sj(arquivo_sj(:,1) == 2)));
        ntt_v3 = (ntt/3) - (length(arquivo_sj(arquivo_sj(:,1) == 3)));
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% interacao com o participante %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Coloca o mouse na tela em que a tarefa será executada para evitar que o script seja clicado
	SetMouse(x_mouse_ini, y_mouse_ini, wPtr);
            
    if pratica == 'trf' && trial == 1 % Exibe o dialogo somente na tt 1 da transferencia
        Screen('TextFont',wPtr, 'Ubuntu');
        Screen('TextSize',wPtr, 40);
        Screen('DrawText', wPtr, 'Pressione qualquer tecla para iniciar', rect(RectRight)/4.6, rect(RectBottom)/2.5, [255, 255, 255]);
        Screen('Flip', wPtr); %flip
        keyIsDown = 0;
        while keyIsDown == 0
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        end
        
        escolha = num2str(transfer_vels(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;
        
    elseif pratica == 'trf' && trial > 1
        escolha = num2str(transfer_vels(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;



    elseif pratica == 'rtc' && trial == 1 % Exibe o dialogo somente na tt 1 da transferencia
        Screen('TextFont',wPtr, 'Ubuntu');
        Screen('TextSize',wPtr, 40);
        Screen('DrawText', wPtr, 'Pressione qualquer tecla para iniciar', rect(RectRight)/4.6, rect(RectBottom)/2.5, [255, 255, 255]);
        Screen('Flip', wPtr); %flip
        keyIsDown = 0;
        while keyIsDown == 0
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        end        
        
        escolha = num2str(transfer_vels(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;
        
    elseif pratica == 'rtc' && trial > 1
        escolha = num2str(transfer_vels(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;

        
    elseif pratica == 'det' && trial == 1 % Exibe o dialogo somente na tt 1
        Screen('TextFont',wPtr, 'Ubuntu');
        Screen('TextSize',wPtr, 40);
        Screen('DrawText', wPtr, 'Pressione qualquer tecla para iniciar', rect(RectRight)/4.6, rect(RectBottom)/2.5, [255, 255, 255]);
        Screen('Flip', wPtr); % Flip
        keyIsDown = 0;
        while keyIsDown == 0
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        end
        
        escolha = num2str(practice_schedule(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;
        
    elseif pratica == 'det' && trial > 1
        escolha = num2str(practice_schedule(trial)); % Determina a escolha pelo arquivo transfer_vels.txt
        time_escolha_ini = 0; % Anula os tempos relacionados a escolha de velocidade
        time_escolha_end = 0;
        
        
    end
    time_escolha = time_escolha_end - time_escolha_ini; % Calcula o tempo da tela de escolha
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% adjustments %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    distancia_alvo_proj = 1.5;
    largura_linha_alvo = 1; %largura da linha final(alvo)
    proj_vel_on = 12; %velocidade do projetil(lancamento) apos o switch ser pressionado
    pos_horiz_linha = rect(RectRight)/line_positions(trial);
    
    %variaveis iniciais do projetil
    proj_vel = 0;
    proj_left = rect(RectLeft);
    proj_top = rect(RectBottom)/distancia_alvo_proj;
    proj_larg = rect(RectBottom)/8; %largura do projetil
    proj_alt = rect(RectBottom)/16; %altura do projetil
    
    %loop variables and time boost
    [x_mouse, y_mouse, buttons] = GetMouse(wPtr);
    time_alvo = [];
    time_proj = [];
    time_response = [];
    end_animation_on = 0;
    end_animation = 0;
    
    % Gravação da posição do alvo no momento da interceptação
    pos_alvo_intercept = [];
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Determina as coordenadas iniciais do alvo
    alvo_left = rect(RectLeft);
    alvo_top = (rect(RectBottom)/2) - (rect(RectBottom)/32); % Determina a distancia entre o alvo e o topo da tela
    alvo_larg = rect(RectBottom)/16;
    alvo_alt = rect(RectBottom)/32;
    alvo_vel = 0; % Velocidade inicial do alvo antes de entrar no loop de animacao
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Determina a velocidade do alvo %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
	if escolha == '1'
		alvo_vel_increment = 9; % Define a velocidade de deslocamento do alvo
	elseif escolha == '2'
		alvo_vel_increment = 12;
	elseif escolha == '3'
		alvo_vel_increment = 15;
	else % Para nao 'travar' caso alguma tecla seja pressionada involuntariamente
		alvo_vel_increment = 18;
		escolha = '4';
	end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Oclusão %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
	% Para que não haja oclusão do alvo:   
	if ponto_para_oclusao == 0
    	ponto_para_oclusao = (rect(RectRight) + rect(RectRight));

	% Para a oclusão no centro da tela:
	elseif ponto_para_oclusao == 1
		ponto_para_oclusao = rect(RectRight)/2;
	
	% Para oclusão na transferência (1/3 da tela):
	elseif ponto_para_oclusao == 2	
		ponto_para_oclusao = rect(RectRight)/3;
		
	end
		

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% desenha o que sera visto antes %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('FillRect', wPtr, red, [(alvo_left + alvo_vel) alvo_top (alvo_left + alvo_larg + alvo_vel) (alvo_top + alvo_alt)]); %alvo
    Screen('DrawLine', wPtr, white, pos_horiz_linha, rect(RectBottom), pos_horiz_linha, rect(RectTop), largura_linha_alvo);
    %Screen('FillRect', wPtr, proj_color, [(proj_left + proj_vel) proj_top (proj_left + proj_larg + proj_vel) (proj_top + proj_alt)]); %lancamento
    Screen('Flip', wPtr); %flip
    
    WaitSecs(2); %tempo entre a escolha e o alerta (mudanca de cor do alvo)
    
    %muda o alvo para amarelo e conta segundos antes de iniciar o movimento do alvo
    Screen('FillRect', wPtr, yellow, [(alvo_left + alvo_vel) alvo_top (alvo_left + alvo_larg + alvo_vel) (alvo_top + alvo_alt)]);
    Screen('DrawLine', wPtr, white, pos_horiz_linha, rect(RectBottom), pos_horiz_linha, rect(RectTop), largura_linha_alvo);
    %Screen('FillRect', wPtr, proj_color, [(proj_left + proj_vel) proj_top (proj_left + proj_larg + proj_vel) (proj_top + proj_alt)]); %lancamento
    Screen('Flip', wPtr); %flip
    
    WaitSecs(interval_to_target_mov(trial)); %valor lido do arquivo txt com mesmo nome armazenado na pasta do script
    %valores estao dentro do intervalo entre 1.5 e 3 segundos (em passos de 0.1)
    
    
    time1 = GetSecs; % Tempo antes de entrar no loop
    tempo_oclusao = 0;
    proj_color = green;
    atrito = 0;
    atrito_coef = 0.04; % Quantidade de "atrito" gerada no alvo móvel
    
    % Variáveis para medidas de verificação
    pos_horiz_inicial = (alvo_left + alvo_larg + alvo_vel);
    tempo_entre_inicio_e_oclusao = [];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%% animacao %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while end_animation < 1; %o ajuste de tempo pode ser feito no valor de animatio_on, abaixo
        
        end_animation = end_animation + end_animation_on;
        
        
        % Desaceleração do estímulo
        atrito = atrito + atrito_coef;
        
        
        % Conta o tempo até a oclusão do estímulo visual
        %tempo_oclusao = tempo_oclusao + monitorFlipInterval;
        
        %if tempo_oclusao > 0.61 % 0.61, em 120 Hz, oclusão = 200, na velocidade 3
            %proj_color = black;
                 
            %% Medidas de verificação           
            %if isempty (tempo_entre_inicio_e_oclusao)
				%tempo_para_oclusao_tmp = GetSecs;
				%%pos_horiz_oclusao = (alvo_left + alvo_larg + alvo_vel);
				%tempo_entre_inicio_e_oclusao = tempo_para_oclusao_tmp - time1;
            %end        
            
        %end        
        
    
        % Ao invés de utilizar o tempo para determinar a oclusão
        % Utilizar a posição horizontal do cursor na tela
		pos_horiz_oclusao = (alvo_left + alvo_larg + alvo_vel);
		
		
        if pos_horiz_oclusao > ponto_para_oclusao
            proj_color = black;
                 
            % Medidas de verificação           
            if isempty (tempo_entre_inicio_e_oclusao)
				tempo_para_oclusao_tmp = GetSecs;
				%pos_horiz_oclusao = (alvo_left + alvo_larg + alvo_vel);
				tempo_entre_inicio_e_oclusao = tempo_para_oclusao_tmp - time1;
            end        
            
        end  		
		
		
		
        

        
        
        %response = dlmread(myu3_path); %le o switch
        %if response(1) > 3
        %    time_response_tmp = GetSecs;
        %    time_response = [time_response time_response_tmp];
        %    
        %    % Grava a posição do alvo no momento da interceptação
        %    if isempty(pos_alvo_intercept)
        %        pos_alvo_intercept = [(alvo_left + alvo_vel) alvo_top (alvo_left + alvo_larg + alvo_vel) (alvo_top + alvo_alt)];
        %    end
        %    
        %end
        
        
        [x_mouse, y_mouse, response] = GetMouse(wPtr);
        %%lancamento
        if response(1) == 1
          time_response_tmp = GetSecs;
          time_response = [time_response time_response_tmp];
          
        % Grava a posição do alvo no momento da interceptação
            if isempty(pos_alvo_intercept)
                pos_alvo_intercept = [(alvo_left + alvo_vel) alvo_top (alvo_left + alvo_larg + alvo_vel) (alvo_top + alvo_alt)];
            end
          
        end
        
        
        %proj_left = proj_left + proj_vel;
        %Screen('FillRect', wPtr, proj_color, [(proj_left + proj_vel) proj_top (proj_left + proj_larg + proj_vel) (proj_top + proj_alt)]); %lancamento
        
        
        
        %%%%%%%%%%%%%%%%
        % Desenha o alvo
        % Para que o deslocamento do alvo não fique negativo (ou seja, não volte)
        if alvo_vel_increment > atrito
			alvo_vel = (alvo_vel + alvo_vel_increment) - atrito; % Atualiza o deslocamento do alvo
		elseif alvo_vel_increment < atrito
			alvo_vel = (alvo_vel + alvo_vel_increment); % Para evitar de travar o alvo na tela
        end


        
        
        
        Screen('FillRect', wPtr, proj_color, [(alvo_left + alvo_vel) alvo_top (alvo_left + alvo_larg + alvo_vel) (alvo_top + alvo_alt)]);
        %%%%%%%%%%%%%%%%%%%%%%
        % Desenha a linha alvo
        %Screen('DrawLine', windowPtr [,color], fromH, fromV, toH, toV [,penWidth]);
        Screen('DrawLine', wPtr, white, pos_horiz_linha, rect(RectBottom), pos_horiz_linha, rect(RectTop), largura_linha_alvo);
        
        %%%%%%%%%%%%%%%%%%%%%%%
        % Timestamping do momento em que o alvo toca a linha
        if (alvo_left + alvo_larg + alvo_vel) > pos_horiz_linha
            time_alvo_tmp = GetSecs;
            time_alvo = [time_alvo time_alvo_tmp];
            
            end_animation_on = (monitorFlipInterval)/2; %com o valor de monitorFlipInterval, o tempo entre a chegada do projetil e o feedback e de 1s
        end
        
        
        %timestamping do momento em que o projetil toca a linha
        %if (proj_left + proj_larg + proj_vel) > pos_horiz_linha
        %time_proj_tmp = GetSecs;
        %time_proj = [time_proj time_proj_tmp];
        %end
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        Screen('Flip', wPtr); %flip
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% feedback %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Caso o sujeito não pressione o switch no tempo adequado
    if length(time_response) == 0
        
        Screen('TextSize',wPtr, 40);
        Screen('DrawText', wPtr, 'Tentativa inválida', rect(RectRight)/2.3, rect(RectBottom)/2.2, [255, 255, 255]);
        Screen('TextSize',wPtr, 30);
        Screen('DrawText', wPtr, 'Pressione enter para reiniciar', rect(RectRight)/2, rect(RectBottom)/1.5, [255, 255, 255]);
        Screen('Flip', wPtr);
        [end_experiment_time, keyCode, deltaSecs] = KbWait; % Aguarda o enter para encerrar o experimento
        
        trial = trial - 1;
        
        continue % O loop passará à próxima iteração. Os dados a tentativa atual não serão salvos
        % Pois os comandos a partir deste ponto não serão executados
    end
    

    
    
    % Diferenca entre o alvo e o pressionamento do switch
    time_diff = time_response(1) - time_alvo(1);
    
    % Tempo de visualização do estímulo em movimento
    time_stim = time_alvo(1) - time1;
        
    % Tempo entre o início do movimento do alvo e o pressionamento do botão
    time_until_response = time_response(1) - time1;
    
    
    
    
    
    
    
    
    
    
    
    time_feedback = 0;
    fb_choice = '0';
    
    % Exibir feeback aumentado somente após blocos de 6 tentativas
    if pratica == 'trf' || pratica == 'rtc'
        time_feedback = 0; % Anula o tempo exibindo o feedback
    
    
    elseif (pratica == 'det') && (feedback_fixo == '4') && (trial > ntt_baseline) % Três primeiras tentativas são de pre-teste
                
                
		Screen('TextFont',wPtr, 'Ubuntu');
		Screen('TextSize',wPtr, 30);
		Screen('DrawText', wPtr, 'Pressione 1 para ver o feedback', rect(RectRight)/4.6, rect(RectBottom)/3, [255, 255, 255]);
		Screen('DrawText', wPtr, 'Pressione 2 para iniciar a próxima tentativa', rect(RectRight)/4.6, rect(RectBottom)/2, [255, 255, 255]);
		
		Screen('Flip', wPtr); % Flip
		
		% Faz a perguntar ficar na tela até que uma opção seja escolhida
		time_escolha_ini = GetSecs;
		keyIsDown = 0;
		while keyIsDown == 0
			[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
			fb_choice = KbName(keyCode); % Armazena a opção escolhida
			
			if length(fb_choice) != 1
				keyIsDown = 0;
				fb_choice = [];
			end
			
			if (fb_choice != '1') && (fb_choice != '2') % Just in case...
				keyIsDown = 0;
			end
			
		end
		
		time_escolha_end = GetSecs;
		
		time_escolha = time_escolha_end - time_escolha_ini; % Calcula o tempo da tela de escolha
		
		
		% Participante quer ver o feedback dessa tentativa
		
		if fb_choice == '1'
				
		
			if time_diff <= 0
				feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms antes'];
			elseif time_diff == 0
				feedback_as_text = [num2str(abs(round(time_diff*1000)))];
			elseif time_diff >= 0
				feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms depois'];
			end
			
			Screen('TextSize',wPtr, 40);
			Screen('DrawText', wPtr, feedback_as_text, rect(RectRight)/2.3, rect(RectBottom)/2.2, [255, 255, 255]);
			
			Screen('Flip', wPtr);
			
			
			
			
			% Mede o tempo em que o sujeito passou olhando o feedback
			time_feedback_ini = GetSecs;
			
			response = 0;
			while response(1) == 0
				[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
				time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
			end
			
			time_feedback = time_feedback_end - time_feedback_ini(1);
		
		% Participante não quer ver o feedback	
		elseif fb_choice == '2'
			
		    %Screen('TextFont',wPtr, 'Ubuntu');
			%Screen('TextSize',wPtr, 30);
			%Screen('DrawText', wPtr, 'Pressione o botão para iniciar a próxima tentativa', rect(RectRight)/4.6, rect(RectBottom)/2.5, [255, 255, 255]);
			%Screen('Flip', wPtr); % Flip
			
			%response = 0;
			%while response < 3
				%response = dlmread(myu3_path); % Lê o switch
			%end
			
			time_feedback = 0;
			
		end
	
		
    % Na tentativa 3 o participante yoked (feedback_fixo == '5') deve receber feedback sobre o seu desempenho nas 3 primeiras tentativas
    % Assim como ocorre para o participante autocontrolado / sumário
    elseif (pratica == 'det') && (feedback_fixo == '5') && (trial == ntt_baseline) % Três primeiras tentativas são de pre-teste
    
    
		% Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
		% Com o da tentativa atual num mesmo dataframe
		feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
		
		% Ordena com base nos valores absolutos para ter a magnitude do erro
		[sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
		
		
		
		if (feedback_values(sorted_array_index(1)) <= 0)
			feedback_text_1 = [' ms antes'];
		elseif (feedback_values(sorted_array_index(1)) >= 0)
			feedback_text_1 = [' ms depois'];
		end
		
		if (feedback_values(sorted_array_index(2)) <= 0)
			feedback_text_2 = [' ms antes'];
		elseif (feedback_values(sorted_array_index(2)) >= 0)
			feedback_text_2 = [' ms depois'];
		end
		
		
		if (feedback_values(sorted_array_index(3)) <= 0)
			feedback_text_3 = [' ms antes'];
		elseif (feedback_values(sorted_array_index(3)) >= 0)
			feedback_text_3 = [' ms depois'];
		end
		
	   
	    Screen('TextFont',wPtr, 'Ubuntu');
        Screen('TextSize',wPtr, 30);
	   
	   
		Screen('DrawText', wPtr, 'Desempenho nas 3 tentativas', rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
		Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(1)*1000))), feedback_text_1], x_feed_all(sorted_array_index(1)), y_feed_all(sorted_array_index(1)), white);
		Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(2)*1000))), feedback_text_2], x_feed_all(sorted_array_index(2)), y_feed_all(sorted_array_index(2)), white);
		Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), feedback_text_3], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
		
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(4)*1000))), ' ms'], x_feed_all(sorted_array_index(4)), y_feed_all(sorted_array_index(4)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(5)*1000))), ' ms'], x_feed_all(sorted_array_index(5)), y_feed_all(sorted_array_index(5)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(6)*1000))), ' ms'], x_feed_all(sorted_array_index(6)), y_feed_all(sorted_array_index(6)), white);
	   
		
		% Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
		Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
		Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
		Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
		%Screen('DrawText', wPtr, '4', x_feed_all(4), [y_feed_all(4) - size_vert], green);
		%Screen('DrawText', wPtr, '5', x_feed_all(5), [y_feed_all(5) - size_vert], green);
		%Screen('DrawText', wPtr, '6', x_feed_all(6), [y_feed_all(6) - size_vert], green);
		
		Screen('Flip', wPtr);
		
		
		% Mede o tempo em que o sujeito passou olhando o feedback
		time_feedback_ini = GetSecs;
		
		response = 0;
		while response(1) == 0
			[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
			time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
		end
		
		time_feedback = time_feedback_end - time_feedback_ini(1);    
    
    
   
    
    
    
    
        
    elseif (pratica == 'det') && (isempty(feedback_fixo) || feedback_fixo == '1' || feedback_fixo == '2') && (trial > ntt_baseline)
        
          
        if trial == 24 || trial == 27 || trial == 30 || trial == 33 || trial == 36 || trial == 39 ||...
                trial == 42 || trial == 45 || trial == 48 || trial == 51 || trial == 54 || trial == 57 || trial == 60 || trial == 63 || trial == 66 ||...
                trial == 69 || trial == 72 || trial == 75 || trial == 78 || trial == 81 || trial == 84 || trial == 87 || trial == 90 || trial == 93 ||...
                trial == 96 || trial == 99 || trial == 102 || trial == 105 || trial == 108 || trial == 111 || trial == 114
            
            
            % Se feedback_fixo for definido como vazio, o sj é questionado se quer receber a melhor
            % Tentativa ou a pior.
            % Caso seja definido como '1' (boa) ou '2' (ruim), o feedback respectivo é apresentado
            % Sem que haja escolha
            if isempty(feedback_fixo)
                
                
                
                Screen('TextFont',wPtr, 'Ubuntu');
                Screen('TextSize',wPtr, 30);
                Screen('DrawText', wPtr, 'Pressione 1 para ver seu melhor desempenho', rect(RectRight)/4.6, rect(RectBottom)/3, [255, 255, 255]);
                Screen('DrawText', wPtr, 'Pressione 2 para ver seu pior desempenho', rect(RectRight)/4.6, rect(RectBottom)/2, [255, 255, 255]);
                
                Screen('Flip', wPtr); % Flip
                
                % Faz a perguntar ficar na tela até que uma opção seja escolhida
                keyIsDown = 0;
                while keyIsDown == 0
                    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
                    fb_choice = KbName(keyCode); % Armazena a opção escolhida
                    
					if ~isequal(fb_choice, 'KP_End') && ~isequal(fb_choice, 'KP_Down')
						keyIsDown = 0;
						fb_choice = 0;
					end

					% To obtain key names: KbName('KeyNamesLinux')
					% KP_End = 1; KP_Down = 2
                    
                end
                
                
                % Converter código da tecla pressionada em '1' ou '2' para facilitar processamento e registro.
                if fb_choice(1:4) == 'KP_E'
					fb_choice = '1';
				elseif fb_choice(1:4) == 'KP_D'
					fb_choice = '2';
				end
                


				% Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
				% Com o da tentativa atual num mesmo dataframe
				feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
				
				% Ordena com base nos valores absolutos para ter a magnitude do erro
				[sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
				
				
				if fb_choice == '1'
					
					Screen('DrawText', wPtr, 'Desempenho na melhor tentativa', rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
					% Texto do feedback para os 3 melhores desempenhos
					
					
					
					if (feedback_values(sorted_array_index(1)) <= 0)
						feedback_text = [' ms antes'];
					elseif (feedback_values(sorted_array_index(1)) >= 0)
						feedback_text = [' ms depois'];
					end
					
					
					
					Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(1)*1000))), feedback_text], x_feed_all(sorted_array_index(1)), y_feed_all(sorted_array_index(1)), white);
					%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(2)*1000))), ' ms'], x_feed_all(sorted_array_index(2)), y_feed_all(sorted_array_index(2)), white);
					%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), ' ms'], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
					
					
					%find(abs(feedback_values) == (sorted_array(1)))
				   
					
				elseif fb_choice == '2'
					
					Screen('DrawText', wPtr, 'Desempenho na pior tentativa', rect(RectRight)/5 - (cursor_horiz/2), white);
					% Texto do feedback para os 3 piores desempenhos
					
					
					
					
					if (feedback_values(sorted_array_index(3)) <= 0)
						feedback_text = [' ms antes'];
					elseif (feedback_values(sorted_array_index(3)) >= 0)
						feedback_text = [' ms depois'];
					end
					
					
					
					
					Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), feedback_text], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
					%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(5)*1000))), ' ms'], x_feed_all(sorted_array_index(5)), y_feed_all(sorted_array_index(5)), white);
					%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(6)*1000))), ' ms'], x_feed_all(sorted_array_index(6)), y_feed_all(sorted_array_index(6)), white);
				end
				
				% Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
				Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
				Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
				Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
				%Screen('DrawText', wPtr, '4', x_feed_all(4), [y_feed_all(4) - size_vert], green);
				%Screen('DrawText', wPtr, '5', x_feed_all(5), [y_feed_all(5) - size_vert], green);
				%Screen('DrawText', wPtr, '6', x_feed_all(6), [y_feed_all(6) - size_vert], green);
                    
                    
                    
                Screen('Flip', wPtr);
                
               
                
            elseif feedback_fixo == '1'
                
                fb_choice = '1';
                
                % Se a função instr_feedback for definida (no menu de configurações) como '1',
                % É apresentada na tela que o desempenho sendo exibido é o correspondente à melhor
                % Tentativa do sujeito. Caso contrário (instr_feedback = '2') a instrução sobre o feedback é
                % Vazia (não apresentada).
                if instr_feedback == '1'
                	instr_feedback_text = 'Desempenho na melhor tentativa';
                elseif instr_feedback == '2'
					instr_feedback_text = '';
				end
                
                
                % Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
                % Com o da tentativa atual num mesmo dataframe
                feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
                
                % Ordena com base nos valores absolutos para ter a magnitude do erro
                [sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
                
                
                Screen('DrawText', wPtr, instr_feedback_text, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
               
                
                if (feedback_values(sorted_array_index(1)) <= 0)
                    feedback_text = [' ms antes'];
                elseif (feedback_values(sorted_array_index(1)) >= 0)
                    feedback_text = [' ms depois'];
                end
              
                
                % Texto do feedback para os 3 melhores desempenhos
                Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(1)*1000))), feedback_text], x_feed_all(sorted_array_index(1)), y_feed_all(sorted_array_index(1)), white);
                %Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(2)*1000))), ' ms'], x_feed_all(sorted_array_index(2)), y_feed_all(sorted_array_index(2)), white);
                %Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), ' ms'], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
                
                
                % Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
                Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
                Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
                Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
                
                Screen('Flip', wPtr);
                
                
            elseif feedback_fixo == '2'
                
                fb_choice = '2';
                
                
                % Se a função instr_feedback for definida (no menu de configurações) como '1',
                % É apresentada na tela que o desempenho sendo exibido é o correspondente à pior
                % Tentativa do sujeito. Caso contrário (instr_feedback = '2') a instrução sobre o feedback é
                % Vazia (não apresentada).
                if instr_feedback == '1'
                	instr_feedback_text = 'Desempenho na pior tentativa';
                elseif instr_feedback == '2'
					instr_feedback_text = '';
				end
                
                
                % Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
                % Com o da tentativa atual num mesmo dataframe
                feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
                
                % Ordena com base nos valores absolutos para ter a magnitude do erro
                [sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
                
                Screen('DrawText', wPtr, instr_feedback_text, rect(RectRight)/5 - (cursor_horiz/2), white);
                
                
                if (feedback_values(sorted_array_index(3)) <= 0)
                    feedback_text = [' ms antes'];
                elseif (feedback_values(sorted_array_index(3)) >= 0)
                    feedback_text = [' ms depois'];
                end
                
                
                
                % Texto do feedback para os 3 piores desempenhos
                Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), feedback_text], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
                %Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(5)*1000))), ' ms'], x_feed_all(sorted_array_index(5)), y_feed_all(sorted_array_index(5)), white);
                %Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(6)*1000))), ' ms'], x_feed_all(sorted_array_index(6)), y_feed_all(sorted_array_index(6)), white);
                
                
                % Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
                Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
                Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
                Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
                
                Screen('Flip', wPtr);
                
            end
            
          
            
            % Mede o tempo em que o sujeito passou olhando o feedback
            time_feedback_ini = GetSecs;
            
            response = 0;
            while response(1) == 0
                [x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
                time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
            end
            
            time_feedback = time_feedback_end - time_feedback_ini(1);
            
            
            
        elseif trial == 3
  
                
			% Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
			% Com o da tentativa atual num mesmo dataframe
			feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
			
			% Ordena com base nos valores absolutos para ter a magnitude do erro
			[sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
			
			
			
			if (feedback_values(sorted_array_index(1)) <= 0)
				feedback_text_1 = [' ms antes'];
			elseif (feedback_values(sorted_array_index(1)) >= 0)
				feedback_text_1 = [' ms depois'];
			end
			
			if (feedback_values(sorted_array_index(2)) <= 0)
				feedback_text_2 = [' ms antes'];
			elseif (feedback_values(sorted_array_index(2)) >= 0)
				feedback_text_2 = [' ms depois'];
			end
			
			
			if (feedback_values(sorted_array_index(3)) <= 0)
				feedback_text_3 = [' ms antes'];
			elseif (feedback_values(sorted_array_index(3)) >= 0)
				feedback_text_3 = [' ms depois'];
			end
			
		   
		    Screen('TextFont',wPtr, 'Ubuntu');
            Screen('TextSize',wPtr, 30);
		   
			Screen('DrawText', wPtr, 'Desempenho nas 3 tentativas', rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
			Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(1)*1000))), feedback_text_1], x_feed_all(sorted_array_index(1)), y_feed_all(sorted_array_index(1)), white);
			Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(2)*1000))), feedback_text_2], x_feed_all(sorted_array_index(2)), y_feed_all(sorted_array_index(2)), white);
			Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), feedback_text_3], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
			
			%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(4)*1000))), ' ms'], x_feed_all(sorted_array_index(4)), y_feed_all(sorted_array_index(4)), white);
			%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(5)*1000))), ' ms'], x_feed_all(sorted_array_index(5)), y_feed_all(sorted_array_index(5)), white);
			%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(6)*1000))), ' ms'], x_feed_all(sorted_array_index(6)), y_feed_all(sorted_array_index(6)), white);
		   
			
			% Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
			Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
			Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
			Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
			%Screen('DrawText', wPtr, '4', x_feed_all(4), [y_feed_all(4) - size_vert], green);
			%Screen('DrawText', wPtr, '5', x_feed_all(5), [y_feed_all(5) - size_vert], green);
			%Screen('DrawText', wPtr, '6', x_feed_all(6), [y_feed_all(6) - size_vert], green);
			
			Screen('Flip', wPtr);
			
			
			% Mede o tempo em que o sujeito passou olhando o feedback
			time_feedback_ini = GetSecs;
			
			response = 0;
			while response == 0
				[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
				time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
			end
			
			time_feedback = time_feedback_end - time_feedback_ini(1);

            
            
        else % Se for qualquer outra tentativa que não as de feedback sumário
            
            
            Screen('TextFont',wPtr, 'Ubuntu');
            Screen('TextSize',wPtr, 30);
            Screen('DrawText', wPtr, 'Pressione o botão para iniciar a próxima tentativa', rect(RectRight)/4.6, rect(RectBottom)/2.5, [255, 255, 255]);
            Screen('Flip', wPtr); % Flip
            
            
            % Mede o tempo em que o sujeito passou olhando o feedback
            time_feedback_ini = GetSecs;
            
            response = 0;
            while response(1) == 0
                [x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
                time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
            end
            
            time_feedback = time_feedback_end - time_feedback_ini(1);
            
            
            
        end % Fecha o if para verificar se na tentativa de prática atual há feedback sumário
        
       
    % Para trabalhar com frequencia de feedback ao invés de feedback sumário       
    elseif (pratica == 'det') && (feedback_fixo == '3') && (frq_feedback(trial) == 1)
	
		if time_diff <= 0
			feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms antes'];
		elseif time_diff == 0
			feedback_as_text = [num2str(abs(round(time_diff*1000)))];
		elseif time_diff >= 0
			feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms depois'];
		end
		
		Screen('TextSize',wPtr, 40);
		Screen('DrawText', wPtr, feedback_as_text, rect(RectRight)/2.3, rect(RectBottom)/2.2, [255, 255, 255]);
		
		Screen('Flip', wPtr);
		
		
        % Mede o tempo em que o sujeito passou olhando o feedback
		time_feedback_ini = GetSecs;
		
		response = 0;
		while response(1) == 0
			[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
			time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
		end
		
		time_feedback = time_feedback_end - time_feedback_ini(1);
		
	elseif (pratica == 'det') && (feedback_fixo == '3') && (frq_feedback(trial) != 1)
		
		time_feedback = 0;
	
	
	
	
	











	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% feedback_fixo = '5' faz o yoked das condições 'após boas e más tentativas'
	% Verifica se o sujeito autocontrolado solicitou feedback (1) na tentativa atual
	% E exibe o feedback (se esse for o caso)
	elseif (pratica == 'det') && (feedback_fixo == '5') && (yok_feedback(trial) == 1)
	
		
		% Se a função instr_feedback for definida (no menu de configurações) como '1',
		% É apresentada na tela que o desempenho sendo exibido é o correspondente à melhor
		% Tentativa do sujeito. Caso contrário (instr_feedback = '2') a instrução sobre o feedback é
		% Vazia (não apresentada).
		if instr_feedback == '1'
			instr_feedback_text = 'Desempenho na melhor tentativa';
		elseif instr_feedback == '2'
			instr_feedback_text = '';
		end
		
		
		% Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
		% Com o da tentativa atual num mesmo dataframe
		feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
		
		% Ordena com base nos valores absolutos para ter a magnitude do erro
		[sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
		
		
		Screen('DrawText', wPtr, instr_feedback_text, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
	   
		
		if (feedback_values(sorted_array_index(1)) <= 0)
			feedback_text = [' ms antes'];
		elseif (feedback_values(sorted_array_index(1)) >= 0)
			feedback_text = [' ms depois'];
		end
	  
		
		% Texto do feedback para os 3 melhores desempenhos
		Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(1)*1000))), feedback_text], x_feed_all(sorted_array_index(1)), y_feed_all(sorted_array_index(1)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(2)*1000))), ' ms'], x_feed_all(sorted_array_index(2)), y_feed_all(sorted_array_index(2)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), ' ms'], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
		
		
		% Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
		Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
		Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
		Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
		
		Screen('Flip', wPtr);
		
		
        % Mede o tempo em que o sujeito passou olhando o feedback
		time_feedback_ini = GetSecs;
		
		response = 0;
		while response(1) == 0
			[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
			time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
		end
		
		time_feedback = time_feedback_end - time_feedback_ini(1);	
	
		% Transforma o número em string por que quando for armazenar os dados
		% O processo inverso é necessário (para que haja compatibilidade com outras condições de prática)
		fb_choice = num2str(yok_feedback(trial));
	
	
	% Se não for para mostrar o feedback para o participante yoked
	% fb_choice é igual a 2
	elseif (pratica == 'det') && (feedback_fixo == '5') && (yok_feedback(trial) == 2)
		
		
		% Se a função instr_feedback for definida (no menu de configurações) como '1',
		% É apresentada na tela que o desempenho sendo exibido é o correspondente à pior
		% Tentativa do sujeito. Caso contrário (instr_feedback = '2') a instrução sobre o feedback é
		% Vazia (não apresentada).
		if instr_feedback == '1'
			instr_feedback_text = 'Desempenho na pior tentativa';
		elseif instr_feedback == '2'
			instr_feedback_text = '';
		end
		
		
		% Combina o desempenho das últimas 2 tentativas salvas no arquivo do sj
		% Com o da tentativa atual num mesmo dataframe
		feedback_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
		
		% Ordena com base nos valores absolutos para ter a magnitude do erro
		[sorted_array, sorted_array_index] = sort(abs(feedback_values), mode = 'ascend');
		
		Screen('DrawText', wPtr, instr_feedback_text, rect(RectRight)/5 - (cursor_horiz/2), white);
		
		
		if (feedback_values(sorted_array_index(3)) <= 0)
			feedback_text = [' ms antes'];
		elseif (feedback_values(sorted_array_index(3)) >= 0)
			feedback_text = [' ms depois'];
		end
		
		
		
		% Texto do feedback para os 3 piores desempenhos
		Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(3)*1000))), feedback_text], x_feed_all(sorted_array_index(3)), y_feed_all(sorted_array_index(3)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(5)*1000))), ' ms'], x_feed_all(sorted_array_index(5)), y_feed_all(sorted_array_index(5)), white);
		%Screen('DrawText', wPtr, [num2str(abs(round(sorted_array(6)*1000))), ' ms'], x_feed_all(sorted_array_index(6)), y_feed_all(sorted_array_index(6)), white);
		
		
		% Texto com o número da tentativa para ser mostrado sobre os desempenhos, identificando-os para o participante
		Screen('DrawText', wPtr, '1', x_feed_all(1), [y_feed_all(1) - size_vert], green);
		Screen('DrawText', wPtr, '2', x_feed_all(2), [y_feed_all(2) - size_vert], green);
		Screen('DrawText', wPtr, '3', x_feed_all(3), [y_feed_all(3) - size_vert], green);
		
		Screen('Flip', wPtr);		
		
		
        % Mede o tempo em que o sujeito passou olhando o feedback
		time_feedback_ini = GetSecs;
		
		response = 0;
		while response(1) == 0
			[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
			time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
		end
		
		time_feedback = time_feedback_end - time_feedback_ini(1);	
	
		% Transforma o número em string por que quando for armazenar os dados
		% O processo inverso é necessário (para que haja compatibilidade com outras condições de prática)
		fb_choice = num2str(yok_feedback(trial));
	

	elseif (pratica == 'det') && (feedback_fixo == '5') && (yok_feedback(trial) == 0)
		
		fb_choice = num2str(yok_feedback(trial));











	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% feedback_fixo = '6' faz o yoked dos experimentos com frequência autocontrolada de feedback
	% (por exemplo, faz o yoked de um participante feedback_fixo = '4')
	% Essa separação é importante pois o significado dos números armazenados em fb_choice mudam
	% De um experimento para o outro.
	% Para os experimentos de boas e más: 0 = sem feedback; 1 = desempenho na melhor tt; 2 = desempenho na pior tentativa
	% Para os experimentos sobre frequência autocontrolada: 0 = sem feedback; 1 = com feedback
	elseif (pratica == 'det') && (feedback_fixo == '6') && (yok_feedback(trial) == 1)
		
		
		
		if time_diff <= 0
			feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms antes'];
		elseif time_diff == 0
			feedback_as_text = [num2str(abs(round(time_diff*1000)))];
		elseif time_diff >= 0
			feedback_as_text = [num2str(abs(round(time_diff*1000))), ' ms depois'];
		end
		
		Screen('TextSize',wPtr, 40);
		Screen('DrawText', wPtr, feedback_as_text, rect(RectRight)/2.3, rect(RectBottom)/2.2, [255, 255, 255]);
		
		Screen('Flip', wPtr);
		
		
        % Mede o tempo em que o sujeito passou olhando o feedback
		time_feedback_ini = GetSecs;
		
		response = 0;
		while response(1) == 0
			[x_mouse, y_mouse, response] = GetMouse(wPtr); % Lê o mouse
			time_feedback_end = GetSecs; % Valores sao sobrescritos e o ultimo tempo registrado corresponde ao acionamento do switch
		end
		
		time_feedback = time_feedback_end - time_feedback_ini(1);		
		
		
		fb_choice = num2str(yok_feedback(trial));

		
		
	elseif (pratica == 'det') && (feedback_fixo == '6') && (yok_feedback(trial) == 2)
		
		
		fb_choice = num2str(yok_feedback(trial));
		

	end


    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%% Questionario AQ e informação de comparação social %%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

 	if questionario == '1' && pratica != 'trf' && pratica != 'rtc'
 	    
	    time_comparacao_social = 0; % Caso não passe em nenhuma condição abaixo, haverá um valor a ser salvo no arquivo de resultados
	    
	    
        if trial == ntt_baseline || trial == (ntt_baseline + 15) || trial == (ntt_baseline + 30) || trial == (ntt_baseline + 45) || trial == (ntt_baseline + 60) || trial == (ntt_baseline + 75) || trial == (ntt_baseline + 90)
            
            WaitSecs(0.3) % Para o sujeito não passar o feedback de comparação social involuntariamente
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Mostrar as informações sobre comparação social %%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Combina o desempenho das últimas 14 tentativas salvas no arquivo do sj
            % Com o da tentativa atual num mesmo dataframe
            %erro_medio_15tt_values = [arquivo_sj(trial-14:trial-1, 3); time_diff];
            erro_medio_15tt_values = [arquivo_sj(trial-2:trial-1, 3); time_diff];
            
            % Calcula o EA
            erro_medio_15tt = round((mean(abs(erro_medio_15tt_values)))*1000);
            
            % Calcula o EA com acréscimo de 20% e subtraídos 20% para as condições experimentais
            erro_medio_15tt_mais_20 = round(erro_medio_15tt + (erro_medio_15tt * 0.2));
            erro_medio_15tt_menos_20 = round(erro_medio_15tt - (erro_medio_15tt * 0.2));
            
            texto_erro_medio_15tt = 'Seu erro médio nas últimas tentativas:';
            texto_erro_medio_15tt_valor = sprintf('%s ms', num2str(erro_medio_15tt));
            
            
            if isempty(comparacao_social)
            
                time_comparacao_social = 0;
            
            elseif comparacao_social == 'pos' && trial != 3 % Não mostrar após o pré-teste
 
                texto_erro_medio_15tt_mais_20 = 'Erro médio do seu grupo nessas tentativas:';
                texto_erro_medio_15tt_mais_20_valor = sprintf('%s ms', num2str(erro_medio_15tt_mais_20));
                
                
                Screen('TextFont',wPtr, 'Ubuntu');
				Screen('TextSize',wPtr, 30);
                Screen('DrawText', wPtr, texto_erro_medio_15tt, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
                Screen('TextSize',wPtr, 50);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_valor, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/4, yellow);
                
                
                Screen('TextSize',wPtr, 30);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_mais_20, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/2, white);            
                Screen('TextSize',wPtr, 50);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_mais_20_valor, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/1.8, yellow);
                
                
				Screen('TextSize',wPtr, 20);	
				Screen('DrawText', wPtr, 'Pressione o botão para continuar', rect(RectRight)/1.5, rect(RectBottom)/1.3, [255, 255, 255]);
				
				Screen('Flip', wPtr); % Flip
				
				% Faz a informação parar na tela e mede o tempo de visualização da mesma
				time_comparacao_social_ini = GetSecs;
				
				response_comparacao_social = 0;
				while response_comparacao_social(1) == 0
					[x_mouse, y_mouse, response_comparacao_social] = GetMouse(wPtr); % Lê o mouse
				end
				
				time_comparacao_social_end = GetSecs;
				
				time_comparacao_social = time_comparacao_social_end - time_comparacao_social_ini;

            elseif comparacao_social == 'neg' && trial != 3 % Não mostrar após o pré-teste

                texto_erro_medio_15tt_menos_20 = 'Erro médio do seu grupo nessas tentativas:';
                texto_erro_medio_15tt_menos_20_valor = sprintf('%s ms', num2str(erro_medio_15tt_menos_20));
                
                
                Screen('TextFont',wPtr, 'Ubuntu');
				Screen('TextSize',wPtr, 30);
                Screen('DrawText', wPtr, texto_erro_medio_15tt, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/5, white);
                Screen('TextSize',wPtr, 50);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_valor, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/4, yellow);
                
                
                
                Screen('TextSize',wPtr, 30);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_menos_20, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/2, white);            
                Screen('TextSize',wPtr, 50);
                Screen('DrawText', wPtr, texto_erro_medio_15tt_menos_20_valor, rect(RectRight)/5 - (cursor_horiz/2), rect(RectBottom)/1.8, yellow);



				Screen('TextSize',wPtr, 20);	
				Screen('DrawText', wPtr, 'Pressione o botão para continuar', rect(RectRight)/1.5, rect(RectBottom)/1.3, [255, 255, 255]);
				
				Screen('Flip', wPtr); % Flip
				
				% Faz a informação parar na tela e mede o tempo de visualização da mesma
				time_comparacao_social_ini = GetSecs;
				
				response_comparacao_social = 0;
				while response_comparacao_social(1) == 0
				  [x_mouse, y_mouse, response_comparacao_social] = GetMouse(wPtr); % Lê o mouse
				end

				time_comparacao_social_end = GetSecs;
				
				time_comparacao_social = time_comparacao_social_end - time_comparacao_social_ini;    
                
            
            end
 


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Variáveis para mostrar o questionário
	
			% Determina as coordenadas iniciais do referencia
			referencia_left = rect(RectLeft);
			referencia_top = (rect(RectBottom)/2) - (rect(RectBottom)/32); % Determina a distancia entre o referencia e o topo da tela
			referencia_larg = rect(RectRight)/18;
			referencia_alt = rect(RectBottom)/32;
			
			y_cursor_dir = referencia_top/2;
			
			% Para colocar os números no lugar certo na referencia
			referencia_larg_total = ((rect(RectRight) - (referencia_larg*4)) - (rect(RectLeft) + (referencia_larg*4)));
			referencia_larg_partes = referencia_larg_total / 10;	
			
			
			% Primeira tela para garantir que o tempo para a primeira resposta
			% Não varie em razão do tempo até que o participante chegue até o mouse
			response_primeira_tela_quest = 0;
			response_segunda_tela_quest = 0; % Esta variável se refere à segunda tela (participante deixa o mouse e volta ao switch)
			
			while response_primeira_tela_quest == 0
				
				[x_mouse, y_mouse, response_primeira_tela_quest] = GetMouse(wPtr);
				
				Screen('TextFont',wPtr, 'Ubuntu');
				Screen('TextSize',wPtr, 30);
				Screen('DrawText', wPtr, 'Clique com o mouse para iniciar o questionário', (rect(RectLeft) + (referencia_larg*4)), 300, [255, 255, 255]);
				
				Screen('Flip', wPtr); % Flip
			
			end
			
			
			
			% Sets cursor starting position
			x_mouse_ini = round(referencia_larg*2);
			y_mouse_ini = round(referencia_top - (referencia_alt/2));
			SetMouse(x_mouse_ini, y_mouse_ini);
			
			% Variáveis do próximo loop
			response = 0;
			quest_trial = 1;
			
			texto_quest_1 = ['250 ms?'];
			texto_quest_2 = ['200 ms?'];
			texto_quest_3 = ['100 ms?'];
			texto_quest_4 = ['80 ms?'];
			texto_quest_5 = ['50 ms?'];
			texto_quest_6 = ['30 ms?'];
			texto_quest_7 = ['10 ms?'];
			
			texto_quest_all = [texto_quest_1; texto_quest_2; texto_quest_3; texto_quest_4; texto_quest_5; texto_quest_6; texto_quest_7];
			
			
			% Faz a perguntar ficar na tela até que uma opção seja escolhida
			time_quest_ini = GetSecs; % Inicia o cronometro do tempo para o questionario
			time_quest_all = []; % Armazena os tempo das respostas
			pos_selecionada_all = []; % Armazena a posicao do mouse no momento do click (resposta)
			WaitSecs(0.1);
			
			% Determinar a resposta as questoes
			while quest_trial <= 7
				
				[x_mouse, y_mouse, response] = GetMouse(wPtr);
				
				% Para que não valha o click, caso o cursor não esteja na região demarcada
				if x_mouse < (rect(RectLeft) + (referencia_larg*4))
					response = 0;
					
				elseif x_mouse > (rect(RectRight) - (referencia_larg*4))
					x_mouse = (rect(RectRight) - (referencia_larg*4));
					
				end
				
				
				
				% Desenha a referência para a resposta (retângulo)
				Screen('FillRect', wPtr, yellow, [(rect(RectLeft) + (referencia_larg*4)) referencia_top (rect(RectRight) - (referencia_larg*4)) (referencia_top + referencia_alt)]);
				
				% Desenha o cursor para determinar a resposta
				Screen('DrawLine', wPtr, white, x_mouse, y_mouse_ini, x_mouse, (y_mouse_ini + y_cursor_dir), 1);
				
				% Texto explicativo dentro da animação de escolha
				Screen('TextFont',wPtr, 'Ubuntu');
				
				Screen('TextSize',wPtr, 30);
				Screen('DrawText', wPtr, 'Agora, você está confiante de que alcançará um erro, em média, menor do que', (rect(RectLeft) + (referencia_larg*4)), (rect(RectBottom)/4), [255, 255, 255]);
				
				Screen('TextSize',wPtr, 50);
				Screen('DrawText', wPtr, texto_quest_all(quest_trial, :), (rect(RectLeft) + (referencia_larg*15)), (rect(RectBottom)/3), [255, 255, 255]);				
							
				Screen('TextSize',wPtr, 20);	
				Screen('DrawText', wPtr, 'Utilize a escala de 0 a 10 como o guia', x_mouse_ini, (y_mouse_ini + (y_cursor_dir*1.2)), [255, 255, 255]);
				
				% Desenha os valores de referencia (0 a 10)
				Screen('TextSize',wPtr, 30);	
				Screen('DrawText', wPtr, '0', (rect(RectLeft) + (referencia_larg*4)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '1', (rect(RectLeft) + (referencia_larg*4) + referencia_larg_partes), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '2', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*2)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '3', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*3)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '4', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*4)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '5', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*5)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '6', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*6)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '7', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*7)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '8', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*8)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '9', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*9)), (referencia_top + referencia_larg), [255, 255, 255]);
				Screen('DrawText', wPtr, '10', (rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*10)), (referencia_top + referencia_larg), [255, 255, 255]);
			
				
				
			
				% Para que o tempo seja armazenado quando uma resposta valida for dada
				if  response(1) == 1
					quest_trial = quest_trial + 1;
					time_quest_all = [time_quest_all GetSecs]; % Armazena o tempo apos cada resposta
					pos_selecionada_all = [pos_selecionada_all x_mouse];
					WaitSecs(0.2);
					
					
					% Avisa quando o participante segura o botão após uma resposta, prevenindo múltiplas respostas.
					while response(1) == 1
						[x_mouse, y_mouse, response] = GetMouse(wPtr);
						Screen('TextSize',wPtr, 30);
						Screen('DrawText', wPtr, 'Solte o botão do mouse para continuar', (rect(RectLeft) + (referencia_larg*4)), (rect(RectBottom)/4), [255, 255, 255]);
						Screen('Flip', wPtr); % Flip
					end
					
					
					
				end
				
			
				
				Screen('Flip', wPtr); % Flip
				
			end
			
			
			% Converte as posicoes do mouse, selecionadas nas respostas, em valores de 0 a 10
			likert = round(((pos_selecionada_all - (rect(RectLeft) + (referencia_larg*4))) / ((rect(RectLeft) + (referencia_larg*4) + (referencia_larg_partes*10)) - (rect(RectLeft) + (referencia_larg*4)))) * 10);
			
			% Calcula o tempo para cada resposta
			time_ref = [time_quest_ini time_quest_all(1) time_quest_all(2) time_quest_all(3) time_quest_all(4) time_quest_all(5) time_quest_all(6)];
			time_quest_diferencas = time_quest_all - time_ref;
			
			
			
			% Tela para evitar que o participante tenha que voltar para o switch apressadamente e prejudique o desempenho
			% Na primeira tentativa após o questionário
            
			
			while response_segunda_tela_quest(1) == 0
				
				[x_mouse, y_mouse, response_segunda_tela_quest] = GetMouse(wPtr); % Lê o mouse
				
				Screen('TextFont',wPtr, 'Ubuntu');
				Screen('TextSize',wPtr, 30);
				Screen('DrawText', wPtr, 'Pressione o botão do mouse para reiniciar a prática', (rect(RectLeft) + (referencia_larg*4)), 300, [255, 255, 255]);
				
				Screen('Flip', wPtr); % Flip
			
			end

			
			
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			%%%%%%%%%%%%% Fim do questionario %%%%%%%%%%%%%%
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		else
		
			likert = [0 0 0 0 0 0 0];
			time_quest_diferencas = [0 0 0 0 0 0 0];
			
		end
	
	elseif (questionario == '1') && (pratica == 'trf' || pratica == 'rtc') && (trial != 1)
	
		likert = [0 0 0 0 0 0 0];
		time_quest_diferencas = [0 0 0 0 0 0 0];

	
	end
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%% salva os dados da tentativa %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if questionario == '1'
        dados_tentativa = [str2num(escolha) time_escolha time_diff time_feedback str2num(fb_choice) likert time_quest_diferencas time_comparacao_social time_stim tempo_entre_inicio_e_oclusao];
    elseif questionario == '2'
		dados_tentativa = [str2num(escolha) time_escolha time_diff time_feedback str2num(fb_choice) time_stim tempo_entre_inicio_e_oclusao];
    end
	
    
    cd(experimento); % Muda para a pasta do experimento sendo conduzido
    
    dlmwrite(txt_name, dados_tentativa, 'delimiter', '\t', '-append');
    
    cd(script_path); % Retorna para a pasta onde esta o script
    
    WaitSecs(0.2); % Evita que a tecla esteja pressionada no incio da proxima tentativa
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%% agradecimento %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (trial - ntt) == 0
        Screen('TextSize',wPtr, 40);
        Screen('DrawText', wPtr, 'OBRIGADO!', 300, 300, [255, 255, 255]);
        Screen('Flip', wPtr);
        [end_experiment_time, keyCode, deltaSecs] = KbWait; % Aguarda o enter para encerrar o experimento
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% fecha o loop de tentativas %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

Screen('CloseAll');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Log

% 19/09/2025
% Modifiquei o código que faz o teste de percepção de competência.
% A modificação incluiu não permitir a passagem para a próxima questão enquanto o botão do mouse permanecer pressionado.
% Após cada resposta, ocorre um flick na tela, o que favorece a percepção de qu


% 21/10/2022
% Corrigi 

% 27/08/2019
% Utilizando KeyPad para registrar a escolha do participante (no feedback sobre boas e más).


% 26/08/2019
% Removi das configurações o ponto de oclusão (que passa a ser determinado de acordo com a fase experimental).
% Baseline agora é uma variável que pode ser ajustada (ntt_baseline).
% No entanto o código ainda não faz ajustes automáticos para as tentativas (múltiplas de 3) nas quais o CR é fornecido
% Devendo ser ajustadas manualmente no script em caso de mudança no protocolo de coleta.


% 17/02/2016
% O script permite a realização da tarefa com o experimentador escolhendo o ponto de oclusão
% Nas configurações.
% O ponto de oclusão agora é determinado pela posição horizontal do alvo na tela
% E não mais pelo tempo de visualização do alvo.
% Entretanto, são armazenados no arquivo de resultados tanto a duração total do deslocamento
% Do alvo (entre o início do movimento e a chegada do alvo até a linha) quanto o tempo de
% Visualização até a oclusão.


% 12/02/2016
% Foram corrigidos dois problemas:
% Ao fazer a retenção não havia necessidade de clique do participante para iniciar a prática;
% O grupo yoked (boas-más) não recebia o feedback sobre suas 3 primeiras tentativas (assim como o grupo autocontrolado)


% 11/02/2016
% O script não roda mais experimentos que envolvam estrutura de prática autocontrolada.
% Foram retiradas as condições relacionadas a isso para permitir mais condições
% Relacionadas ao feedback autocontrolado (ou externamente controlado).
% As velocidades continuam sendo determinadas por um arquivo externo.
% No entanto, enquanto estiver sendo utilizado o atrito (redução na velocidade do estímulo)
% Não é possível utilizar a velocidade 1 (o alvo para antes de completar o comprimento da tela).

% É possível coletar dados de um participante escolhendo se quer receber feedback sobre sua melhor ou pior tentativa, a cada 3 tentativas
% E fazer um yoked dessa condição (feedback_fixo = '5')

% É possível coletar dados de um participante escolhendo se quer ou não receber feedback a cada tentativa
% E fazer um yoked dessa condição (feedback_fixo = '6')


% 14/10/2014
% O script agora mostra informações de comparação social.
% Especificamente, mostra o erro absoluto médio do participante a cada 15 tentativas
% E também a informação de comparação social, positiva (grupo teria um erro maior em 20% em relação
% Ao do participante) ou negativa (grupo teria um erro menor em 20%), na mesma tela.
% Essa informação é mostrada ao participante antes de ser apresentado a ele o questionário.
% O cálculo do desempenho médio do participante é feito por meio da leitura do arquivo
% Externo, no qual são armazenadas as informações dele.
% O cálculo do erro do grupo é realizado com base nesse mesmo valor do participante,
% Adicionando-se ou subtraíndo-se 20%, conforme a condição experimental.
% A condição experimental (indução positiva ou negativa) é selecionada por meio da opção
% 'comparacao_social'.
% comparacao_social = 'neg'; mostra o erro absoluto médio do participante e o "erro do grupo" abaixo do dele em 20%
% comparacao_social = 'pos'; mostra o erro absoluto médio do participante e o "erro do grupo" acima do dele em 20%
% comparacao_social = []; não apresenta a informação de comparação social


% 13/10/2014
% Foi adicionada a possibilidade de rodar um teste de retenção (condição rtc).
% Ao utilizar essa opção, um questionário é mostrado antes da realização da primeira
% Tentativa do teste.
% Foi adicionada a opção para que o arquivo contendo as velocidades possa ser determinado
% Nas configurações. Basta editar a função 'arquivo_velocidades_transfer', colocando o nome do
% Arquivo externo a ser lido.


% 15/10/2014
% Foi adicionada uma pausa após o questionário para que o participante tenha tempo
% De retomar o switch sem prejudicar o desempenho na próxima tentativa.
% Além disso, acrescentada uma função que permite utilizar o script para fornecer
% Feedback em determinadas frequências.
% A frequência é determinada por um arquivo externo (.txt) contendo 1 ou 0 em cada linha.
% 1 indica ao script para fornecer feedback naquela dada tentativa (correspondente à linha) e
% 0 faz com que não seja fornecido feedback após aquela tentativa.
% O nome do arquivo externo deve ser indicado na opção 'arquivo_frq_feedback' (ex.: arquivo_frq_feedback = 'arquivo_frq_feedback_33.txt';)

% 10/10/2014
% Acréscimo da função 'questionário'.
% Aplica um questionário (na tentativa 3, 15, 30, 45, 60, 75 e 90) sobre autoeficácia.
% O questionário funciona com um slide. O participante deve clicar com o mouse sobre o valor que
% Acredita ser o mais adequado para descrever sua confiança de que será capaz de realizar a tarefa
% Abaixo de um erro X naquele momento.
% São 7 questões que aparecem em sequência, após cada clique do mouse.
% Há um intervalo de 200 ms separando cada questão para evitar que o mouse continue pressionado
% E as questões sejam respondidas involuntáriamente. Pode ser interessante compensar esse valor ao analisar os resultados.
% No momento, penso que 200 ms são irrelevantes para o tipo de dado.
% A resposta selecionada pelo sujeito, bem como o tempo para cada resposta, são armazenados no mesmo arquivo do sujeito 
% No qual são registrados os demais resultados.


% 30/09/2014
% Acréscimo da função instr_feedback no menu de configurações.
% Esta função permite que, na condição de feedback fixo (sempre mostrar feedback sobre a melhor ou a pior de 3),
% Seja ou não exibida a instrução (frase) sobre a qualidade do feedback (se é referente ao melhor ou pior desempenho 
% Na sequência de três tentativas.


% 24/09/2014
% Script modificado para exibir a informação sobre a direção do erro (antes / depois) no momento do feedback


% 04/09/2014
% Script modificado para exibir escolha pela visualização do melhor ou pior desempenho a cada 3 tentativas
% Essa modificação foi realizada após a constatação de que após 6 tentativas o participante já não
% É capaz de recuperar informações da memória, dificultando a aprendizagem.
% Após as 3 primeiras tentativas o script apresenta o feedback de todas as 6 tentativas,
% Sem possibilidade de escolha entre melhores e piores.
% A partir da 3 tentativa, há sempre escolha do sujeito com relação a visualizar melhores ou piores


% 12/05/2014
% O script realiza oclusão do alvo móvel 500 ms antes da chegada à linha para induzir um aumento na demanda de prática
% Para facilitar a aplicação de um questionário de motivação após a apresentação da tarefa / pre-teste
% Após as 6 primeiras tentativas o script apresenta o feedback de todas as 6 tentativas,
% Sem possibilidade de escolha entre melhores e piores.
% A partir da 6 tentativa, há sempre escolha do sujeito com relação a visualizar melhores ou piores

% 09/05/2014
% O script se autorregula com relação ao número de tentativas, caso ocorra um crash
% No meio do experimento
% Já são mostrados os feedbacks de cada tentativa, a cada 6 tentativas, identificados para o participante

% 07/05/2014
% O script foi modificado para que o participante só receba fb após blocos de 6 tentativas de prática

% 25/04/2014
% O for loop de tentativas foi substituído por um while loop
% Para poder controlar o número de tentativas quando o participante deixa de responder
% Uma modificação foi inserida na condição escrita logo após o loop de animação
% O comando break foi substituído por continue (ver o manual do octave/matlab)

% 23/04/2014
% Foi corrigido o bug que travava o script após 30 tentativas (arquivo externo line_positions.txt tinha somente 30 linhas)
% Foi acrescentada segurança contra pressionamentos acidentais durante a escolha

% 04/2014
% Este script está adaptado para realizar a tarefa de timing simples com as seguintes manipulações:
% Número de tentativas entre velocidades definido pelo aprendiz (livre ou em múltiplos de 3) ou determinado por um arquivo externo
% Feedback visual 'real' ou 'numérico'
% Organização da prática definida externamente (por arquivo) - yoked não está 'automatizado'
% Instrução sobre a meta de aprendizagem (reminder) ou meta da tarefa (sem reminder)





