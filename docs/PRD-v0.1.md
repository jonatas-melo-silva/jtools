# 📄 PRD — jtools

## 1. Identificação do Produto

**Nome:** jtools
**Tipo:** Mini package manager CLI baseado em GitHub Releases
**Licença:** MIT
**Stack:** Bash
**Plataforma alvo:** Linux (zsh/bash)

---

## 2. Problema

Ferramentas distribuídas via GitHub Releases normalmente exigem:

* Download manual
* Scripts isolados por projeto
* Instalação inconsistente
* Falta de verificação de integridade
* Ausência de idempotência
* Conflitos entre ambientes
* Uso desnecessário de sudo

Isso gera:

* Ambientes não reprodutíveis
* Atualizações descontroladas
* Scripts duplicados
* Manutenção difícil

---

## 3. Objetivo do Produto

Criar um gerenciador leve, modular e previsível para instalar e manter ferramentas CLI distribuídas via GitHub Releases, com foco em:

* Instalação local-first
* Idempotência real
* Integridade verificável
* Controle explícito
* Simplicidade operacional
* Modularidade por pacote

---

## 4. Escopo Atual (v0.1)

## 4.1 Comandos Implementados

| Comando     | Responsabilidade            |
| ----------- | --------------------------- |
| install     | instalar pacote             |
| remove      | remover pacote              |
| list        | listar pacotes instalados   |
| update      | atualizar pacote específico |
| upgrade-all | atualizar todos os pacotes  |
| doctor      | validar ambiente            |
| --version   | exibir versão do jtools     |

---

## 4.2 Flags Suportadas

| Flag      | Função                  |
| --------- | ----------------------- |
| --force   | força reinstalação      |
| --dry-run | simula execução         |
| --local   | instala em ~/.local/bin |

---

## 4.3 Comportamento de Instalação

### Padrão

```id="x8lso9"
~/.jtools/bin
```

### Opcional

```id="h2kp0s"
~/.local/bin
```

Sem suporte a `/usr/local/bin`.

---

## 5. Requisitos Funcionais

## RF-01 — Instalação

* Deve buscar última versão via GitHub API
* Deve baixar asset correto
* Deve validar checksum quando disponível
* Deve falhar em caso de erro crítico
* Deve atualizar state.json após sucesso

## RF-02 — Idempotência

* Não reinstalar se versão já for a mais recente
* A menos que `--force` seja usado

## RF-03 — Lock Concorrente

* Deve impedir múltiplas execuções simultâneas
* Lock global em:

```id="42m3b8"
~/.jtools/install.lock
```

## RF-04 — Persistência

* Manter registro de versões instaladas
* Arquivo:

```id="lcm0ho"
~/.jtools/state.json
```

## RF-05 — Modularidade

* Cada pacote definido em:

```id="kj20j9"
packages/<tool>.sh
```

## RF-06 — Doctor

Validar:

* curl
* tar
* jq
* sha256sum
* flock
* PATH

---

## 6. Requisitos Não Funcionais

## RNF-01 — Zero sudo por padrão

## RNF-02 — Compatível com bash e zsh

## RNF-03 — Código modular

## RNF-04 — Falhas devem ser explícitas

## RNF-05 — Não modificar automaticamente dotfiles

---

## 7. Arquitetura Técnica Atual

```id="s4b9pw"
CLI (bin/jtools)
  ↓
Core
  ↓
Installer Engine
  ↓
Package Definition
```

Estrutura:

```id="c9ow5k"
jtools/
├── bin/jtools
├── lib/
├── packages/
├── VERSION
├── LICENSE
└── README.md
```

---

## 8. Estado Atual do Projeto

* Engine genérica funcional
* LazyDocker como pacote piloto
* Checksum validado quando disponível
* Lock implementado
* Idempotência implementada
* Projeto versionado via Git
* Licença MIT definida

---

## 9. Limitações Conhecidas

* Sem suporte a version pinning
* Sem rollback
* Sem cache offline
* Sem multi-arch automático
* Sem suporte Windows
* Sem GPG

---

## 10. Riscos Técnicos

1. Dependência da API pública do GitHub
2. Mudança no formato de releases
3. Nem todos projetos publicam checksums
4. Uso obrigatório de jq
5. Rate limit da API

---

## 11. Critérios de Conclusão da v0.1

A versão 0.1 será considerada estável quando:

* install funciona corretamente
* update não reinstala desnecessariamente
* upgrade-all percorre todos
* doctor detecta ambiente inválido
* state.json permanece consistente
* lock impede concorrência

---
