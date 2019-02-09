# FallBall

#### Algumas considerações sobre a organiação atual do projeto:
* O jogo visa aprendizado do framework Spritekit
* Quaisquer alterações são bem vindas
* bla


#### Pastas

Dentro da pasta **Models** existem alguns modelos criados na tentativa de organizar melhor o código. Alguns deles:

| Pasta        | Descrição           | Cool  |
| ------------- |:-------------:| -----:|
| States        | Tem o objetivo de retirar o condicionamento das mudanças de estado de dentro da classe SKScene. Contém uma **maquina de estados** que controla os estados do jogo, mais informação logo em baixo.  | $1600 |
| Node Queue      | Contém uma **fila** de nodes criada com a intenção de **reaproveitar nodes** ao invés de criar novos, assim economizando processamendo do devide.       |   $12 |
| Behaviour | Criado com a intenção de organizar **conjuntos de actions que são muito utilizados**. Exemplo:  muitos obstaculos tem o comportamento de "queda" e existe um Behaviour responsável por fazer esse movimento, e ele é reaproveitado em todos esses obstáculos.      |    $1 |
| Barrier Creator | Criado na intenção de **dividir a responsabilidade de criar novos obstáculos do jogo** e retira-la da class SKScene. Cada **BarrierCreator** é responsável por criar um tipo de obstaculo, descrevendo seu comportamento e movimentação, bem como posições de aparição e etc. O uso desses creators pode ser feito por meio da **BarrierFactory** que facilita o uso por meio de um acesso padrão. |    $1 |

##### Estados do Game
Por enquanto, o jogo contém basicamente três estados:
* inicial: o usuário não fez nenhuma ação
* playing: durante o tempo em que o usuário está jogando
* dead: o usuário morreu

![GitHub Logo](https://i.imgur.com/OivXW1j.png)


