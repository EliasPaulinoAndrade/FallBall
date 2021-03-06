# FallBall

#### Algumas considerações sobre a organiação atual do projeto:
* O jogo visa aprendizado do framework Spritekit
* Quaisquer alterações são bem vindas
* bla


#### Pastas

Dentro da pasta **Models** existem alguns modelos criados na tentativa de organizar melhor o código. Alguns deles:

| Pasta        | Descrição           |
| ------------- |:-------------:|
| States        | Tem o objetivo de retirar o condicionamento das mudanças de estado de dentro da classe SKScene. Contém uma **maquina de estados** que controla os estados do jogo, mais informação logo em baixo.|
| [Node Queue](https://github.com/EliasPaulinoAndrade/FallBall/blob/master/FallBall/Models/Node%20Queue/NodeQueue.md)      | Contém uma **fila** de nodes criada com a intenção de **reaproveitar nodes** ao invés de criar novos, assim economizando processamendo do device.|
| [Behaviour](https://github.com/EliasPaulinoAndrade/FallBall/blob/master/FallBall/Models/Behaviour/Behaviour.md) | Criado com a intenção de organizar **conjuntos de actions que são muito utilizados**. Exemplo:  muitos obstaculos tem o comportamento de "queda" e existe um Behaviour responsável por fazer esse movimento, e ele é reaproveitado em todos esses obstáculos. |
| [Barrier Creator](https://github.com/EliasPaulinoAndrade/FallBall/blob/master/FallBall/Models/Barrier%20Creator/BarrierCreator.md) | Criado na intenção de **dividir a responsabilidade de criar novos obstáculos do jogo** e retira-la da class SKScene. Cada **BarrierCreator** é responsável por criar um tipo de obstaculo, descrevendo seu comportamento e movimentação, bem como posições de aparição e etc. O uso desses creators pode ser feito por meio da **BarrierFactory** que facilita o uso por meio de um acesso padrão.|

##### Estados do Game
Por enquanto, o jogo contém basicamente três estados:
* inicial: o usuário não fez nenhuma ação
* playing: durante o tempo em que o usuário está jogando
* dead: o usuário morreu

![States](https://i.imgur.com/OivXW1j.png)
