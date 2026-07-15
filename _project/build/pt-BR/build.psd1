@{
	Title = "Contruindo o ASTHE"
	PausePrompt = "Pressione qualquer tecla para continuar. . ." # Command prompt style message
	BuildTexts = @{
		"build" = "Construindo..."
		"test"  = "Testando..."
		"run"   = "Executando... (quem? que horrível!)" # HUMOR!!!!
		"clean" = "Limpando..."
	}
	Finished = "Terminado."

	InsertHaxelib = @(
		"Parece que seu PATH foi corrompido, Haxe não está instalado, ou Haxe não foi encontrado no devido PATH.",
		"Se seu Haxe não está instalado, por favor, instale-o em 'https://haxe.org/download/'",
		"Se seu PATH foi corrompido, troque as variáveis 'HAXEPATH' e 'NEKO_INSTPATH' do PATH por seu caminho absoluto, adicionalmente, remova todos os binários das pastas do Haxe e Neko substituindo-os por uma versão ZIP.",
		"Insira sua pasta HaxeToolkit onde o Haxelib está localizado, sem 'haxelib' no final",
		"OBS: Se você está usando o Haxe no modo portátil em um Pen-Drive, por favor, remova-o e reinsira o pen-drive, então rode esse script novamente"
	)

	Config = @{
		"Platform"   = "Plataforma: ........ {0}"
		"BuildFlags" = "Definições de Build: {0}"
		"Is32Bits"   = "32 Bits: ........... {0}"
		"Action"     = "Ação: .............. {0}"
		"BuildType"  = "Tipo de Build: ..... {0}"
	}

	Cleaning = "Limpando resquícios de builds antigos..."
	CleaningError = "Falha ao limpar: {0}"
}