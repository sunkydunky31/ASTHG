@{
	# General
	Done            = 'Feito.'
	Finished        = 'Terminado.'
	PausePrompt     = 'Pressione qualquer tecla para continuar. . .' # Command prompt style message

	Options         = @{
		Yes = 's' # 'Yes' option.
		No  = 'n' # 'No' option.
	}

	Dependencies    = @{
		InstallingDependencies = @{
			Default = 'Instalando dependencias...'
			SubText = 'Isso pode levar mais tempo dependendo da sua conexão à internet.'
		}

		RemoveSetup            = @{
			Removing     = 'Removendo dependências...'
			FailedRemove = 'Falha ao remover dependências: {0}'
		}

		Redundant              = @{
			RemoveWarn          = 'Removendo dependências redundantes...'
			FolderNotFound      = 'A pasta de dependências não foi encontrada, você fez a configuração inicial?'

			VersionRemoved      = "Versão '{0}' removida de '{1}'!"
			VersionRemoveFailed = "Falha ao remover versão '{0}' de '{1}': {2}"
		}
	}

	RemoveFullSetup = @{
		Confirm           = 'Tem certeza que deseja remover completamente a configuração? Isso também irá remover os builds do jogo! ({0}/{1})'
		Aborted           = 'Remoção abortada.'
		AbortedWithReason = 'Remoção abortada ({0}).'

		PlatformWarn      = @{
			Windows = 'Removendo compilações do Windows...'
			Android = 'Removendo compilações do Android...'
		}

		ErrorReasons      = @{
			NotHaxelib = 'O usuário não possuí o Haxelib.'
		}
	}

	HaxelibNotFound = 'Comando ''haxelib'' não encontrado! Você tem o Haxe instalado?'

	HXCPP           = @{
		Building    = 'Compilando HXCPP Dev'
		FailedBuild = 'Falha ao compilar o HXCPP: {0}'
	}

	InstallingMSVC  = @{
		Prompt        = 'Instalando Microsoft Visual Studio BuildTools (Dependência)'
		ErrorDownload = 'O download do VS BuildTools falhou: {0}'
		ErrorPath     = "'{0}' não foi encontrado. Retornando..."
	}

	Menu            = @{
		Title        = 'ASTHE Setup'
		Options      = @(
			'Instalar dependências padrão',
			'Configurar para Windows',
			'Configurar para MacOS',
			'Configurar para Android',
			'Remover arquivos de setup',
			'Remover arquivos de setup completo',
			'Remover dependências redundantes',
			'Sair'
		)
		Prompt       = 'Escolha uma opção ({0}/{1})'
		Error        = 'Opção inválida, tente de novo.'
		ErrorOS      = 'Essa opção está indisponível em seu sistema.'
		NotAvailable = 'Essa opção foi desativada pois Haxelib não foi encontrado.'
	}
	NotAvailable    = 'Sinto muito, essa opção não está disponível agora.'

	Config          = @{
		FailedSave = 'Falha ao salvar configuração: {0}'
	}
}