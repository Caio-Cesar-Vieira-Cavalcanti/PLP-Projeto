# ByteFront - A Guerra dos Paradigmas

![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)

## Pré-requisitos

Antes de rodar o jogo, você necessita ter o Haskell e o `cabal` instalados no seu sistema.

### Instalando o Haskell

Você pode instalar o GHC (Glasgow Haskell Compiler) e o `cabal` (ferramenta de construção do Haskell) através do [Haskell Platform](https://www.haskell.org/platform/) ou usando o [ghcup](https://www.haskell.org/ghcup/), que é a maneira mais recomendada e simples.

### Instalando as dependências

Para instalar as dependências e configurar o jogo, siga os seguintes passos:

1. Clone o repositório:

    ```bash
    git clone https://github.com/Caio-Cesar-Vieira-Cavalcanti/PLP-Projeto.git
    cd PLP-Projeto
    ```

2. Instale as dependências usando o `cabal`:

    ```bash
    cabal update
    cabal install --only-dependencies
    ```

    Isso vai garante as dependências do projeto sejam instaladas corretamente e o jogo rode sem problemas.

## Compilando o Jogo

Para compilar o jogo, execute (Certifique-se que está no diretório `\Haskell`):

```bash
cabal build
```

## Rodando o Jogo

```bash
cabal run
```