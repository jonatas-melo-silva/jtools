# 🗺 Roadmap Técnico — jtools

## Estado Atual — v0.1

Base funcional:

* Engine genérica para GitHub Releases
* Lock concorrente global
* Checksum quando disponível
* Idempotência real
* Flags: `--force`, `--dry-run`, `--local`
* Persistência via `state.json`
* Modularização por pacote
* MIT + Git versionado

Objetivo da próxima fase: **robustez estrutural antes de expansão.**

---

## 🔹 Fase 1 — Robustez Operacional (v0.2)

Foco: tornar o sistema previsível e resiliente.

## 1️⃣ Multi-arch detection automática

Problema atual:

```bash
ARCH="Linux_x86_64"
```

Hardcoded.

Evolução:

* Detectar `uname -m`
* Mapear para padrão GitHub
* Permitir override por pacote

Impacto:

* Remove fragilidade
* Permite ARM no futuro

---

## 2️⃣ Version pinning opcional

Permitir:

```bash
jtools install lazydocker 0.24.3
```

Requisitos:

* Resolver versão específica via API
* Manter version no state
* update respeita versão fixa

Valor:

* Reprodutibilidade real
* Uso em bootstrap/dotfiles

---

## 3️⃣ Melhorias no upgrade-all

Atualmente:

* Loop simples

Evolução:

* Não interromper em falha
* Reportar resumo final:

  * sucesso
  * falhas
  * já atualizados

---

## 4️⃣ Melhoria do Doctor

Adicionar:

* Verificação de lock preso
* Verificação de symlinks quebrados
* Verificação de binários inexistentes

---

## 🔹 Fase 2 — Confiabilidade Avançada (v0.3)

Foco: maturidade técnica.

---

## 1️⃣ Cache inteligente

Problema atual:

* Sempre baixa novamente

Evolução:

```bash
~/.jtools/cache/
```

* Reutilizar tarballs se versão igual
* Invalidar automaticamente se mudar versão

---

## 2️⃣ Rollback automático

Antes de update:

* Backup do binário atual

Se falhar:

* Restaurar versão anterior

Valor:

* Segurança operacional

---

## 3️⃣ GPG opcional (enterprise mode)

Não padrão.
Ativado via flag:

```bash
--verify-signature
```

Somente para pacotes que publicam assinatura.

---

## 🔹 Fase 3 — Evolução Estrutural (v0.4)

Foco: transformar em ferramenta realmente extensível.

---

## 1️⃣ Registry desacoplado

Hoje:

* `packages/*.sh`

Evolução:

* registry.sh central
* Metadata declarativa

Exemplo:

```bash
register_package "lazydocker" \
  repo="jesseduffield/lazydocker" \
  binary="lazydocker"
```

---

## 2️⃣ Plugin system leve

Permitir:

```bash
~/.jtools/plugins/
```

Cada plugin pode:

* adicionar comandos
* adicionar pacotes
* customizar hooks

---

## 3️⃣ Hooks

Permitir:

* pre-install
* post-install
* pre-remove
* post-remove

Útil para ferramentas que precisam configuração extra.

---

## 🔹 Fase 4 — Estabilidade v1.0

Critério para 1.0:

* API CLI estável
* Versionamento semântico respeitado
* Arquitetura modular consolidada
* Documentação completa
* Sem breaking changes frequentes

---

## 🚧 Riscos Evolutivos

1. Escopo crescer demais
2. Tentar virar um “brew em bash”
3. Complexidade > benefício
4. Dependência excessiva da API GitHub
5. Acoplamento excessivo ao formato de release

---

## 📈 Estratégia de Crescimento

Ordem recomendada:

1. Multi-arch
2. Version pinning
3. Upgrade-all robusto
4. Cache
5. Rollback
6. Registry declarativo
7. GPG opcional

Não inverter essa ordem.

---

## 🎯 Direção Estratégica

jtools deve continuar sendo:

* Pequeno
* Previsível
* Local-first
* Bash puro
* GitHub Release focused

Se virar:

* multi-source
* suporte a apt
* suporte a npm
* cross-platform Windows

Você perde identidade e foco.

---
