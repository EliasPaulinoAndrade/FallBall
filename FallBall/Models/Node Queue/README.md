# Node Queue

#### Descrição
Contém uma fila de nodes criada com a intenção de reaproveitar nodes ao invés de criar novos, assim economizando processamendo do devide.


#### Forma de Uso

```swift

//cria a fila
var queue = FBNodeQueue.init()

//seta o delegate da fila
queue.delegate = self

//implementa o delegate da fila, no caso ele está sendo implementado na propria GameScene
extension GameScene: FBNodeQueueDelegate {

func createNode(_ nodeQueue: FBNodeQueue) -> SKNode {
// esse metodo é chamado sempre que a fila precisa criar um node novo

let node = SKNode.init()

return node
}

func setupNode(_ nodeQueue: FBNodeQueue, node: SKNode) {
// esse metodo é chamado sempre é chamado antes da reutilização de um node
// nele, voce deve resetar seu no. Isso pode significar mover ele para uma posição  
// inicial, ou resetar outros atributos, remove-lo da view ou etc.

node.removeFromParent()
node.removeAllActions()
node.position = CGPoint.zero
}

func resuseStrategy(_ nodeQueue: FBNodeQueue) -> FBNodeQueueReuseStrategy {
// esse metodo é chamado para que a fila identifique a estratégia de reutilização que voce quer usar.
// a estrategia de reuso padrão é: quando um node sair da tela visivel ele pode ser reutilizado. 
// é possivel criar outras estrategias por meio da implementação do FBNodeQueueReuseStrategy.

return FBNodeQueueOutOfSightStrategy.init(withViewPortNode: self)
}
}


// agora, sempre que o metodo queue.dequeueNode() for chamado, a fila tentará reutilizar nodes, e se não houverem nodes para serem reutilizados, ela criará um novo.

// adiciona um novo node a cena
if let newNode = queue.dequeueNode() {
self.addChild(newNode)
}

```

