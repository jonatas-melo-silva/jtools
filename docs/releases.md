# Processo de Release

## Visão Geral

O `jtools` utiliza versionamento semântico (SemVer) e um fluxo automatizado de release baseado no arquivo `VERSION`.

Toda release deve ser criada exclusivamente através do script:

```bash
./scripts/release.sh
```

Releases manuais via `git tag` não são permitidas.

---

## Estratégia de Versionamento

O projeto segue o padrão:

```bash
MAJOR.MINOR.PATCH
```

### Tipos de Incremento

| Tipo  | Quando usar                    |
| ----- | ------------------------------ |
| major | Breaking changes               |
| minor | Nova funcionalidade compatível |
| patch | Correções e ajustes internos   |

O arquivo `VERSION` contém apenas:

```bash
X.Y.Z
```

Sem o prefixo `v`.

As tags criadas no Git usam o formato:

```bash
vX.Y.Z
```

---

## Como o Script de Release Funciona

O script executa automaticamente:

1. Valida se está na branch `main`
2. Verifica se a working tree está limpa
3. Lê a versão atual do arquivo `VERSION`
4. Incrementa `major`, `minor` ou `patch`
5. Atualiza o arquivo `VERSION`
6. Cria commit de bump de versão
7. Cria tag anotada
8. Faz push da branch e da tag
9. Cria release no GitHub usando `gh`

---

## Como Usar

### Patch (default)

```bash
./scripts/release.sh
```

ou

```bash
./scripts/release.sh patch
```

### Minor

```bash
./scripts/release.sh minor
```

### Major

```bash
./scripts/release.sh major
```

---

## Pré-condições

Antes de executar o release:

* Estar autenticado no GitHub CLI (`gh auth status`)
* Estar na branch `main`
* Não possuir alterações não commitadas
* Ter commits relevantes desde a última versão

---

## O que NÃO fazer

❌ Não criar tags manualmente  
❌ Não alterar o arquivo `VERSION` manualmente  
❌ Não forçar push de tags  
❌ Não editar releases diretamente no GitHub  

Todo processo deve passar pelo script.

---

## Example Release Flow

```bash
git checkout main
git pull origin main
./scripts/release.sh minor
```

Resultado esperado:

```bash
VERSION updated
Commit created
Tag created
Release created on GitHub
```

---

## Solução de problemas

### "Árvore de trabalho não limpa"

Commit ou descarte alterações antes de rodar o script.

### "A etiqueta já existe."

Verifique a última versão com:

```bash
git tag --sort=-v:refname | head
```

---
