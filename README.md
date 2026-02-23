# jtools

> Minimal personal tool manager for Unix-like systems  
> Created by Jonatas Melo Silva  
> License: MIT

jtools é um mini gerenciador de ferramentas CLI focado em simplicidade, previsibilidade e controle total do ambiente.

Ele não substitui apt, brew ou pacman.  
Ele resolve outro problema:

✔ Instalar binários específicos  
✔ Padronizar instalação entre máquinas  
✔ Versionar sua stack pessoal  
✔ Ter controle total do processo

---

## ✨ Filosofia

- Local-first (instala em ~/.jtools)
- Sem dependência externa
- Bash puro
- Arquitetura modular
- Registro simples por pacote
- Estado explícito
- Open-source e hackável

---

## 📦 Estrutura

```bash

~/.jtools/
bin/jtools          # CLI principal
lib/core.sh         # engine
lib/registry.sh     # catálogo de pacotes
lib/state.sh        # controle de estado
packages/
lazydocker.sh   # definição do pacote
state.db            # banco simples

```

---

## 🚀 Instalação

Clone o repositório:

```bash
git clone https://github.com/jonatas-melo-silva/jtools.git ~/.jtools
```

Adicione ao PATH (zsh):

```bash
echo 'export PATH="$HOME/.jtools/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Teste:

```bash
jtools
```

---

## 📜 Comandos Disponíveis

| Comando     | Função                   |
| ----------- | ------------------------ |
| install     | Instala um pacote        |
| remove      | Remove um pacote         |
| list        | Lista pacotes instalados |
| update      | Atualiza um pacote       |
| upgrade-all | Atualiza todos           |
| doctor      | Valida integridade       |

---

## 🔧 Exemplos

Instalar lazydocker:

```bash
jtools install lazydocker
```

Listar instalados:

```bash
jtools list
```

Atualizar:

```bash
jtools update lazydocker
```

Atualizar todos:

```bash
jtools upgrade-all
```

Remover:

```bash
jtools remove lazydocker
```

Verificar integridade:

```bash
jtools doctor
```

---

## 📁 Como funciona um pacote

Cada ferramenta é definida em:

```bash
~/.jtools/packages/<nome>.sh
```

Exemplo simplificado:

```bash
PACKAGE_NAME="lazydocker"
PACKAGE_DESCRIPTION="Terminal UI for Docker"

install_package() {
    echo "Instalando lazydocker..."
}

remove_package() {
    echo "Removendo lazydocker..."
}

update_package() {
    install_package
}
```

---

## 🔍 Estado

O arquivo `state.db` armazena:

```bash
lazydocker|0.24.4|installed
```

Sem banco complexo.
Sem dependência JSON.
Somente controle explícito.

---

## 🧠 Roadmap

- [ ] Versionamento real por pacote
- [ ] Suporte a releases do GitHub
- [ ] Verificação de hash
- [ ] Modo dry-run
- [ ] Modo force
- [ ] Export/Import state
- [ ] Integração com dotfiles
- [ ] Plugin system
- [ ] Cache de downloads
- [ ] GPG verification (enterprise mode)

---

## 🛡 Segurança

Versão 0.1:

- Sem GPG
- Sem verificação automática de assinatura
- Confiança explícita no registry local

Evolução futura:

- Verificação SHA256
- GPG opcional
- Release signature validation

---

## 🎯 Objetivo do Projeto

Criar um gerenciador pessoal:

- Reprodutível
- Portável
- Versionável
- Hackável
- Simples o suficiente para manter sozinho

---

## 📄 Licença

MIT

Você pode usar, modificar e distribuir livremente.
