# Barrier Creator

#### Descrição
Criado na intenção de dividir a responsabilidade de criar novos obstáculos do jogo e retira-la da class SKScene. Cada BarrierCreator é responsável por criar um tipo de obstaculo, descrevendo seu comportamento e movimentação, bem como posições de aparição e etc. O uso desses creators pode ser feito por meio da BarrierFactory que facilita o uso por meio de um acesso padrão.


#### Forma de Uso
Cada creator deve implementar o protocolo FBBarrierCreatorProtocol. Cada creator deve setar todos os atributos necessários para que a barreira funcione, como: posição inicial, comportamentos, tamanho, cor e etc. 


Criando um tipo de barreira:
```swift
/// cria um obstaculo retangular que cai em direcao ao chão e faz um movimento de "vai-e-vem"
class FBRectBarrierCreator: FBBarrierCreatorProtocol {

/*parametros da animcacao da barreira*/
static private let HORIZONTAL_DISTANCE_PER_UNIT: CGFloat = 5
static private let HORIZONTAL_DURATION: TimeInterval = 2
static private let VERTICAL_DISTANCE: CGFloat = -300
static private let VERTICAL_DURATION: TimeInterval = 1
static private let BARRIER_COLOR: SKColor = SKColor.white

/*retorna a barreira criada*/
func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode {

//um frame que inicia no canto superior direito da tela, de largura igual a da tela menos 5 unidades
let barrierRect = CGRect.init(
x: -parentRect.width/2,
y: parentRect.height/2,
width: parentRect.width - 5 * SKScene.unit(forSceneFrame: parentRect),
height: 20
)

/// o corpo fisico da barreira
let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)

/// o node da barreira
let barrierNode = SKShapeNode.init(rect: barrierRect)

/// seta atributos do node
barrierNode.fillColor = SKColor.white
barrierNode.name = "barrier"
barrierNode.physicsBody = barrierBody
barrierNode.physicsBody?.categoryBitMask = 0010
barrierNode.physicsBody?.collisionBitMask = 0000
barrierNode.physicsBody?.contactTestBitMask = 0011

//reseta o comprotamento do node para o padrao
self.resetBehaviour(inBarrier: barrierNode, inParentWithFrame: parentRect)

return barrierNode
}

/*reseta o comportamento da barreira, deve ser usado quando é necessario que o node volte a ter os atributos que tinha no momento da criação. */
func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect) {
//esse metodo deve conter o 'reset' de atributos que necessitam voltar a valores padrão em algum tempo.
//normalmente é chamado quando a barreira vai ser reutilizada

//uma unidade de medida
let unit = SKScene.unit(forSceneFrame: parentRect)

//reseta atributos
barrier.removeAllActions()
barrier.position = CGPoint.zero

//ver documentacao sobre behaviours
barrier.applyBehaviour(FBFallBehaviour.init(
duration: FBRectBarrierCreator.VERTICAL_DURATION,
distance: FBRectBarrierCreator.VERTICAL_DISTANCE
))

barrier.applyBehaviour(FBBackAndForth.init(
duration: FBRectBarrierCreator.HORIZONTAL_DURATION,
distance: FBRectBarrierCreator.HORIZONTAL_DISTANCE_PER_UNIT * unit
))
}
}

```
Agora, essa barreira pode ser usada em outras classes sem a preocupação de como essa barreira vai ser comportar ou aparecer visualmente. A classe **FBRectBarrierCreator** pode ser usada diretamente para criar a barreira ou por meio da **FBBarrierFactory**, que centraliza o acesso aos creators.

Utilizando o creator diretamente:
```swift

//codigo dentro de uma cena

let rectBarrierCreator = FBRectBarrierCreator.init()

//adiciona a barreira criada como filho
//a partir daqui ela ja deve começar a se comportar como descrito no creator
let barrier = rectBarrierCreator.barrierNode(withParentRect: self.frame)

self.addChild(barrier)

```

Utilizado o creator por meio da factory:

```swift

//codigo dentro de uma cena

//instancia uma fabrica de barreiras
let barrierFactory = FBBarrierFactory.init()

//cria uma barreira
let barrier = barrierFactory.barrier(ofType: .rect, toParentWithRect: self.frame)


self.addChild(barrier)

```
Essa forma de criar tem sua vantagem, pois conforme o número de barreiras for crescendo, fica mais dificil lembrar o nome de cada uma. E a facotry padroniza o acesso aos creators por meio do mesmo metodo

É importante que o creator descreva como a barreira deve ser resetada se for necessário reutiliza-la, pois ficaria dificil para outras classes entender como a barreira funciona por dentro. Por isso a existencia do método **resetBehaviour**. Exemplo de uso a seguir.

```swift
barrierFactory.creator(ofType: .rect)
.resetBehaviour(inBarrier: node, inParentWithFrame: self.frame)

```
