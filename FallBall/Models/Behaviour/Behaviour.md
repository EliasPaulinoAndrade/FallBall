# Behaviour

#### Descrição
Criado com a intenção de organizar conjuntos de actions que são muito utilizados. Exemplo: muitos obstaculos tem o comportamento de "queda" e existe um Behaviour responsável por fazer esse movimento, e ele é reaproveitado em todos esses obstáculos.


#### Forma de Uso
Existem alguns behaviours já feitos. O exemplo a seguir mostra como criar um novo e usa-lo. O protocolo FBBehaviourProtocol é implementado por todos os behaviours.

Implementando o protocolo behaviour:
```swift
//esse behaviour vai fazer o movimento de vai-e-vem em um node: em que um node vai de uma parede a outra de um container e volta de forma continua.

struct FBBackAndForth: FBBehaviourProtocol {

    //os atributos de um behaviour dependem do tipo de behavior, no caso somente são necessários uma duração e distancia do movimento. Em outros tipos de behaviour, com animações mais complexas, pode ser necessário colocar mais atributos.

    var duration: TimeInterval
    var distance: CGFloat

    func run(inNode node: SKNode) {
        //esse metodo basicamente coloca o conjunto de SKActions necessarias para fazer o movimento
        //nesse caso existe uma sequencia sendo repetida para sempre de mudanças de posição parametrizada pela distancia e duração dadas ao behaviour. O movimento ocorre somente no eixo X.

        node.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(
                        x: distance,
                        y: 0, duration: duration
                    ),
                    SKAction.moveBy(
                        x: -distance,
                        y: 0, duration: duration
                    )
                ])
            )
        )
    }
}

```
Agora, esse comportamento pode ser utilizado em vários nodes diferentes sem a necessidade de reescrever codigo:

```swift
//exemplo de uso do behaviour

//instancia o behaviour, o movimento vai ocorrer na distancia de 50 a cada 2 segundos
let behaviour = FBBackAndForth.init(
    duration: 2,
    distance: 50
)

//o node que vai receber o comportamento, no caso um quadrado
let node = SKShapeNode.init(rect:
    CGRect.init(
        x: 0,
        y: 0,
        width: 50,
        height: 50
    )
)

//aplicacao do comportamento
node.applyBehaviour(behaviour)

```


