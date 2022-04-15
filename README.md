## Padrão de branchs e pull requests

### Nomes de branchs

{tipo-atividade}_{identificador-gestao}

* feature
* fix
* hotfix

ex: **feature_redmine12**


### Pull requests

1. Ao iniciar uma tarefa, se recomenda mudar para a branch de desenvolvimento:
```
git checkout desenvolvimento
```
2. Após isso garanta que a branch local esteja atualizada com a branch remota:
```
git pull origin desenvolvimento
```
3. Crie a branch na qual resolverá a atividade seguindo os padrões de nomes de branchs
```
git checkout -b {branch-tarefa}
```
4. Ao finalizar a tarefa, faça o commit localmente
```
git add .
git commit -m "{mensagem-commit}"
```
5. Atualize sua branch de sprint local com a branch de sprint remota
```
git checkout desenvolvimento
git pull origin desenvolvimento
```
6. Retorne a sua branch da tarefa e faça o rebase com a branch da sprint
```
git checkout {branch-tarefa}
git rebase desenvolvimento
```
7. Faça o push para a branch remota
```
git push origin {branch-tarefa}
```
8. Abra o pull request contendo a branch da tarefa como origem e a branch de desenvolvimento, o destino
9. Atualize o status da tarefa na plataforma de gestão, incluindo o link do pull request
10. Notifique os membros sobre o pull request para que iniciem o code review
