import Foundation

// Add PhraseCategory enum
enum PhraseCategory {
    case normal, warning, game, never, timedChallenge
}

// Add PhraseData struct
struct PhraseData {
    let text: String
    let category: PhraseCategory
    let duration: Double?

    // Convenience initializer for phrases without duration
    init(text: String, category: PhraseCategory) {
        self.text = text
        self.category = category
        self.duration = nil
    }

    // Initializer for timed challenges
    init(text: String, category: PhraseCategory, duration: Double) {
        self.text = text
        self.category = category
        self.duration = duration
    }
}

class GameModel {
    private(set) var players: [String] = []
    private let maxPlayers = 15
    
    // Update phrases array to use PhraseData
    private var phrases: [PhraseData] = [
        
        PhraseData(text: "[Name] e [Name], leiam a primeira SMS que aparece ao introduzir \"buraco\" na barra de pesquisa. Podem recusar por 5 penalidades.", category: .normal),
        PhraseData(text: "[Name], se sabes o que é um glory hole, apanha 2 penalidades. Caso contrário, distribui-as e vai espreitar na Internet.", category: .normal),
        PhraseData(text: "[Name] não é obrigado(a) a acabar as suas frases com \"no meu cu\"..", category: .normal),
        PhraseData(text: "Apanha 1 penalidade se és solteiro(a), 2 se és comprometido(a), 3 se for mais complicado....", category: .normal),
        PhraseData(text: "A partir de agora e até ao final do jogo, é proibido fumar! Quem não respeitar esta regra, apanha uma penalidade máxima.", category: .normal),
        PhraseData(text: "Os que estão a favor do restabelecimento da pena de morte apanham 2 penalidades.", category: .normal),
        PhraseData(text: "Aqueles cuja idade é par enviam uma fotografia a alguém ou apanham 2 penalidades!.", category: .normal),
        PhraseData(text: "[Name], se vês a Casa dos Segredos, ou outros programas do mesmo género, na TVI, apanha 5 penalidades.", category: .normal),
        PhraseData(text: "[Name], se o teu copo contém uma bebida alcoólica, apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Apanha 2 penalidades se, para ti, TODOS os outros jogadores são simpáticos.", category: .normal),
        PhraseData(text: "[Name], apanha tantas penalidades quantos copos não vazios em cima da mesa.", category: .normal),
        PhraseData(text: "Os que vão deitar-se numa cama de casal esta noite apanham 4 penalidades.", category: .normal),
        PhraseData(text: "Apanha 3 penalidades se já viste um dos jogadores nu.", category: .normal),
        PhraseData(text: "[Name], distribui tantas penalidades quantos irmãos e irmãs tiveres!.", category: .normal),
        PhraseData(text: "Os que já engataram numa discoteca distribuem 5 penalidades.", category: .normal),
        PhraseData(text: "[Name], tens 5 minutos para realizares uma penalidade máxima", category: .normal),
        PhraseData(text: "Os que têm um O no nome apanham 3 penalidades!", category: .normal),
        PhraseData(text: "A pessoa que mais diluiu a sua bebida é penalizada", category: .normal),
        PhraseData(text: "As raparigas são penalizadas tantas vezes quanto rapazes bonitos a jogar", category: .normal),
        PhraseData(text: "Os idiotas pedantes que trabalham ou estudam na área do comércio ou das vendas apanham 2 penalidades", category: .normal),
        PhraseData(text: "Cada um apanha tantas penalidades quantos anos de estudo após o 12.º ano!", category: .normal),
        PhraseData(text: "[Name], se estás comprometido(a) e vieste sem o teu/a tua namorado(a), distribui 5 penalidades. Caso contrário, apanha-as tu", category: .normal),
        PhraseData(text: "[Name], atribui um defeito a cada um dos jogadores e apanha uma penalidade por cada um!", category: .normal),
        PhraseData(text: "Sem telemóveis! O primeiro que consultar o seu smartphone apanha 10 penalidades.", category: .normal),
        PhraseData(text: "Os que já apanharam uma DST distribuem 3 penalidades.", category: .normal),
        PhraseData(text: "O último jogador que mijou apanha 3 penalidades.", category: .normal),
        PhraseData(text: "Os que acreditam nos espíritos apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], por amor, dá 5 penalidades ao jogador de quem gostas mais.", category: .normal),
        PhraseData(text: "[Name], distribui 2 penalidades a um jogador mais alto do que tu, se isso for possível... Caso contrário, apanha-as tu.", category: .normal),
        PhraseData(text: "Os que nunca fizeram nenhum striptease apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], distribui tantas penalidades quantas peças de roupa preta tens vestidas.", category: .normal),
        PhraseData(text: "[Name], dá 4 penalidades ao jogador que conheces menos.", category: .normal),
        PhraseData(text: "Os que têm o telemóvel em cima da mesa apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se te lembras de 3 músicas do David Carreira distribui 5 penalidades. Caso contrário, apanha-as tu.", category: .normal),
        PhraseData(text: "[Name], se já disseste 'é só mais um copo' e não cumpriste, apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já foi ao São João ou Santo António este ano distribui 3 penalidades.", category: .normal),
        PhraseData(text: "Os que têm mais de 3 apps de comida no telemóvel apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se alguma vez pediste 'imperial' fora de Lisboa, distribui 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já ficou sem saldo no passe este mês apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Os que já disseram 'a culpa é do governo' distribuem 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se sabes o que é um 'pão com chouriço' às 6 da manhã, distribui 2 penalidades.", category: .normal),
        PhraseData(text: "Quem nunca foi ao Algarve no verão apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Os que têm o nome começado por vogal apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já disseste 'ai que seca!' hoje, apanha 1 penalidade.", category: .normal),
        PhraseData(text: "Quem já adormeceu no metro ou autocarro distribui 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], se tens mais de 3 fotos com copos na mão no Instagram, apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já foi confundido com turista em Portugal distribui 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já disseste 'tás a ver?' mais de 3 vezes hoje, apanha 1 penalidade.", category: .normal),
        PhraseData(text: "Quem já foi multado por estacionamento distribui 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], diz em voz alta o nome da última pessoa com quem tiveste um sonho molhado. Se não disseres, apanha 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], lê a última mensagem enviada no Tinder. Se não tiveres Tinder, distribui 4 penalidades.", category: .normal),
        PhraseData(text: "Os que já fizeram sexo num sítio público distribuem 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já enviaste uma nude, apanha 2 penalidades. Se nunca enviaste, distribui 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já beijou mais de uma pessoa na mesma noite distribui 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], se tens um crush entre os jogadores, olha para ele/ela durante 10 segundos ou apanha 3 penalidades.", category: .normal),
        PhraseData(text: "Os que já tiveram um one night stand apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], diz qual é a tua posição favorita na cama ou apanha 3 penalidades.", category: .normal),
        PhraseData(text: "Quem nunca fez sexo oral apanha 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], conta a tua história de engate mais embaraçosa ou distribui 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], faz um elogio picante ao jogador à tua esquerda. Se recusares, apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já teve um ménage distribui 4 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já tiveste sexo numa casa de banho, apanha 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já disseste 'amo-te' sem sentir, distribui 2 penalidades.", category: .normal),
        PhraseData(text: "Os que já foram apanhados em flagrante apanham 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já tiveste um date desastroso, conta ou apanha 2 penalidades.", category: .normal),
        PhraseData(text: "Quem já fez sexting distribui 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], lê a última mensagem enviada no WhatsApp sem censura. Se recusares, apanha 3 penalidades.", category: .normal),
        PhraseData(text: "Os que já ficaram com alguém só pelo desafio apanham 2 penalidades.", category: .normal),
        PhraseData(text: "[Name], imita um orgasmo durante 10 segundos ou apanha 3 penalidades.", category: .normal),
        PhraseData(text: "[Name], se já tiveste um sonho erótico com alguém do grupo, bebe 2 penalidades.", category: .normal),

        PhraseData(text: "Bacalhau com natas ou entrecosto no forno? Votem todos ao mesmo tempo, a minoria apanha 3 penalidades.", category: .game),
        PhraseData(text: "Fazer chichi sentado(a) ou de pé? Votem todos ao mesmo tempo, a minoria apanha 4 penalidades.", category: .game),
        PhraseData(text: "Francesinha ou bacalhau à Brás? Votem todos ao mesmo tempo, a minoria apanha 3 penalidades.", category: .game),
        PhraseData(text: "Pastel de nata com ou sem canela? Votem já, a minoria apanha 2 penalidades.", category: .game),
        PhraseData(text: "Quem conseguir dizer 'três pratos de trigo para três tigres tristes' sem se enganar distribui 3 penalidades.", category: .game),
        PhraseData(text: "O último a dizer 'Saúde!' apanha 2 penalidades.", category: .game),
        PhraseData(text: "'Pastel de nata com ou sem canela?' Votem já, a minoria apanha 2 penalidades.", category: .game),
        PhraseData(text: "[Name], troca de t-shirt com o jogador à tua direita. Se recusares, apanha 3 penalidades.", category: .game),
        PhraseData(text: "O último a dizer 'bota abaixo' apanha 2 penalidades.", category: .game),
        PhraseData(text: "[Name], faz um brinde original e atrevido. Se ninguém rir, apanha 2 penalidades.", category: .game),
        PhraseData(text: "[Name], dança twerk durante 30 segundos ou apanha 3 penalidades.", category: .game),
        PhraseData(text: "[Name], tens de dar um beijo (bochecha ou boca, à escolha) ao jogador à tua esquerda ou apanha 2 penalidades.", category: .game),

        PhraseData(text: "[Name], podem fazer-te perguntas a qualquer momento. Se não souberes a resposta, apanhas uma penalidade.", category: .warning),
        PhraseData(text: "[Name] é agora obrigado(a) a aguardar 2 segundos entre cada palavra pronunciada! 2 penalidades por cada esquecimento.", category: .warning),
        PhraseData(text: "[Name] deve agora dizer \"no meu cu\" no final de cada frase. Fica penalizado(a) sempre que falhar.", category: .warning),
        PhraseData(text: "Penalidade máxima para [Name] e [Name]!", category: .warning),
        PhraseData(text: "[Name], a partir de agora só podes falar em rimas. Cada erro, 2 penalidades.", category: .warning),
        PhraseData(text: "Proibido usar palavras em inglês até ao fim do jogo! Quem falhar, apanha 2 penalidades.", category: .warning),
        PhraseData(text: "[Name], tens de falar com sotaque do Porto até ao teu próximo turno. Cada erro, 1 penalidade.", category: .warning),
        PhraseData(text: "O próximo a pegar no telemóvel apanha 5 penalidades.", category: .warning),
        PhraseData(text: "A partir de agora, cada vez que alguém disser uma palavra inglesa, apanha 1 penalidade.", category: .warning),
        PhraseData(text: "[Name], só podes falar usando frases de engate até à tua próxima vez. Cada erro, 2 penalidades.", category: .warning),
        PhraseData(text: "Proibido dizer 'tipo' até ao fim do jogo. Quem disser, apanha 2 penalidades.", category: .warning),
        PhraseData(text: "[Name], tens de terminar cada frase com 'no meu quarto'. Cada vez que te esqueceres, apanha 1 penalidade.", category: .warning),
        
        PhraseData(text: "Eu nunca disse que li um livro clássico só para parecer culto.", category: .never),
        PhraseData(text: "Eu nunca fiquei obcecado em stalkear alguém nas redes sociais.", category: .never),
        PhraseData(text: "Eu nunca fingi gostar de uma comida só para agradar alguém.", category: .never),
        PhraseData(text: "Eu nunca fingi estar dormindo no transporte público para não ceder o meu lugar a alguém.", category: .never),
        PhraseData(text: "Eu nunca postei dancinha no TikTok querendo que uma pessoa específica visse.", category: .never),
        PhraseData(text: "Eu nunca fui expulso da sala de aula.", category: .never),
        PhraseData(text: "Eu nunca desmaiei na rua.", category: .never),
        PhraseData(text: "Nunca peguei carona com estranhos.", category: .never),
        PhraseData(text: "Eu nunca fui parado por policiais.", category: .never),
        PhraseData(text: "Nunca andei a cavalo.", category: .never),
        PhraseData(text: "Eu nunca quebrei um osso.", category: .never),
        PhraseData(text: "Eu nunca quebrei um dente.", category: .never),
        PhraseData(text: "Eu nunca criei uma conta falsa nas redes sociais.", category: .never),
        PhraseData(text: "Eu nunca tive uma experiência paranormal.", category: .never),
        PhraseData(text: "Eu nunca tive algum perfil de rede social hackeado.", category: .never),
        PhraseData(text: "Nunca roubei algo em uma loja.", category: .never),
        PhraseData(text: "Eu nunca tive paralisia do sono.", category: .never),
        PhraseData(text: "Eu nunca fiquei preso no elevador.", category: .never),
        PhraseData(text: "Eu nunca tentei cortar meu próprio cabelo.", category: .never),
        PhraseData(text: "Eu nunca pintei o cabelo de alguma cor estranha.", category: .never),
        PhraseData(text: "Nunca cantei em um karaokê na frente de várias pessoas.", category: .never),
        PhraseData(text: "Eu nunca apareci na TV.", category: .never),
        PhraseData(text: "Eu nunca passei mal em um parque de diversões.", category: .never),
        PhraseData(text: "Eu nunca corri da polícia.", category: .never),
        PhraseData(text: "Eu nunca pedi dinheiro no sinal.", category: .never),
        PhraseData(text: "Eu nunca me arrependi imediatamente após enviar uma mensagem.", category: .never),
        PhraseData(text: "Eu nunca levei um tapa no rosto.", category: .never),
        PhraseData(text: "Eu nunca dei um tapa no rosto de alguém.", category: .never),
        PhraseData(text: "Eu nunca participei de uma briga.", category: .never),
        PhraseData(text: "Eu nunca chorei no transporte público.", category: .never),
        PhraseData(text: "Eu nunca passei mais de dois dias sem tomar banho.", category: .never),
        PhraseData(text: "Eu nunca olhei o celular de alguém sem que a pessoa soubesse.", category: .never),
        PhraseData(text: "Eu nunca fui demitido.", category: .never),
        PhraseData(text: "Eu nunca dormi na rua.", category: .never),
        PhraseData(text: "Nunca peguei comida do lixo e comi.", category: .never),
        PhraseData(text: "Eu nunca consegui algo de graça dando em cima de alguém.", category: .never),
        PhraseData(text: "Nunca caí na rua porque estava olhando o celular.", category: .never),
        PhraseData(text: "Eu nunca tive um vídeo constrangedor postado na internet.", category: .never),
        PhraseData(text: "Eu nunca quebrei algo na casa de alguém e escondi.", category: .never),
        PhraseData(text: "Eu nunca saí de uma festa ou bar sem pagar.", category: .never),
        PhraseData(text: "Eu nunca me gabei por algo que não fiz.", category: .never),
        PhraseData(text: "Eu nunca menti tanto sobre algo que acreditei que fosse verdade.", category: .never),
        PhraseData(text: "Eu nunca sofri bullying na escola.", category: .never),
        PhraseData(text: "Eu nunca segurei a mão da pessoa errada na rua.", category: .never),
        PhraseData(text: "Eu nunca fui expulso de uma festa.", category: .never),
        PhraseData(text: "Eu nunca postei algo e me arrependi.", category: .never),
        PhraseData(text: "Eu nunca roubei dinheiro da carteira dos meus pais.", category: .never),
        PhraseData(text: "Eu nunca comi comida que caiu no chão.", category: .never),
        PhraseData(text: "Eu nunca comi comida que alguém largou na área de alimentação do shopping.", category: .never),
        PhraseData(text: "Nunca fiquei com mais de 5 pessoas em uma festa.", category: .never),
        PhraseData(text: "Nunca beijei alguém que eu não conhecia.", category: .never),
        PhraseData(text: "Eu nunca fiquei com o irmão/irmã de um amigo.", category: .never),
        PhraseData(text: "Eu nunca dormi no ônibus e perdi o meu ponto.", category: .never),
        PhraseData(text: "Eu nunca fiquei apaixonado por algum professor.", category: .never),
        PhraseData(text: "Eu nunca fui assaltado.", category: .never),
        PhraseData(text: "Eu nunca recebi flores.", category: .never),
        PhraseData(text: "Eu nunca menti para meus pais sobre aonde estava indo.", category: .never),
        PhraseData(text: "Eu nunca fiz xixi em uma piscina do lado dos meus amigos.", category: .never),
        PhraseData(text: "Eu nunca usei Crocs.", category: .never),
        PhraseData(text: "Eu nunca vomitei na frente de outras pessoas.", category: .never),
        PhraseData(text: "Eu nunca soltei pum em um elevador e fingi que não fui eu.", category: .never),
        PhraseData(text: "Eu nunca segui a pessoa errada na rua.", category: .never),
        PhraseData(text: "Eu nunca deixei meu celular cair na privada.", category: .never),
        PhraseData(text: "Eu nunca fui em uma festa sem ser chamado.", category: .never),
        PhraseData(text: "Eu nunca beijei alguém famoso.", category: .never),
        PhraseData(text: "Eu nunca fiquei com gêmeos.", category: .never),
        PhraseData(text: "Eu nunca vomitei e tive que engolir.", category: .never),
        PhraseData(text: "Eu nunca gostei mais de um filme do que do seu livro.", category: .never),
        PhraseData(text: "Eu nunca entrei em casa pela janela.", category: .never),
        PhraseData(text: "Eu nunca ri tanto que fiz um pouco de xixi.", category: .never),
        PhraseData(text: "Nunca passei o número errado para alguém.", category: .never),
        PhraseData(text: "Eu nunca menti para alguém sobre qual era meu nome.", category: .never),
        PhraseData(text: "Eu nunca tive o meu nome no SPC.", category: .never),
        PhraseData(text: "Eu nunca precisei ir ao médico devido a um objeto estranho preso em meu nariz ou ouvido.", category: .never),
        PhraseData(text: "Eu nunca usei identidade falsa para entrar em uma festa.", category: .never),
        PhraseData(text: "Eu nunca pesquisei meu nome no Google.", category: .never),
        PhraseData(text: "Eu nunca dei de presente algo que ganhei e não gostei.", category: .never),
        PhraseData(text: "Eu nunca convenci um amigo a largar a namorada.", category: .never),
        PhraseData(text: "Eu nunca apaguei um post porque teve poucas curtidas.", category: .never),
        PhraseData(text: "Eu nunca usei a escova de dentes de outra pessoa.", category: .never),
        PhraseData(text: "Eu nunca me inscrevi em um reality show.", category: .never),
        PhraseData(text: "Eu nunca culpei outra pessoa por um erro meu.", category: .never),
        PhraseData(text: "Eu nunca menti sobre um candidato em que votei.", category: .never),
        PhraseData(text: "Eu nunca dei um conselho ruim para alguém de propósito.", category: .never),
        PhraseData(text: "Eu nunca andei de avião.", category: .never),
        PhraseData(text: "Eu nunca tive cárie.", category: .never),
        PhraseData(text: "Eu nunca viralizei na internet.", category: .never),
        PhraseData(text: "Eu nunca menti para ninguém nesta sala.", category: .never),
        PhraseData(text: "Eu nunca vi um espírito.", category: .never),
        PhraseData(text: "Eu nunca usei uma roupa que estava para lavar.", category: .never),
        PhraseData(text: "Eu nunca fui confundido(a) com uma pessoa famosa.", category: .never),
        PhraseData(text: "Eu nunca fiz uma tatuagem falsa e fingi que era real.", category: .never),
        PhraseData(text: "Eu nunca fingi estar mexendo no celular para evitar falar com alguém.", category: .never),
        PhraseData(text: "Eu nunca fui apanhado(a) a copiar num teste.", category: .never),
        PhraseData(text: "Eu nunca dancei o vira numa festa popular.", category: .never),
        PhraseData(text: "Eu nunca disse que ia só 'um café' e voltei de madrugada.", category: .never),
        PhraseData(text: "Eu nunca fingi gostar de fado só para agradar alguém.", category: .never),
        PhraseData(text: "Eu nunca fiquei sem saldo no telemóvel numa noite importante.", category: .never),
        PhraseData(text: "Eu nunca beijei alguém numa festa popular.", category: .never),
        PhraseData(text: "Eu nunca fui ao hospital depois de uma noite de copos.", category: .never),
        PhraseData(text: "Eu nunca tive vergonha do meu sotaque.", category: .never),
        PhraseData(text: "Eu nunca fiz sexo no carro.", category: .never),
        PhraseData(text: "Eu nunca enviei uma mensagem picante a um desconhecido.", category: .never),
        PhraseData(text: "Eu nunca fui apanhado(a) a masturbar-me.", category: .never),
        PhraseData(text: "Eu nunca beijei alguém do mesmo sexo.", category: .never),
        PhraseData(text: "Eu nunca tive um crush num(a) amigo(a) de longa data.", category: .never),
        PhraseData(text: "Eu nunca fiz striptease para alguém.", category: .never),
        PhraseData(text: "Eu nunca tive sexo em casa dos meus pais.", category: .never),
        PhraseData(text: "Eu nunca mandei nudes.", category: .never),
        PhraseData(text: "Eu nunca tive sexo no primeiro encontro.", category: .never),
        PhraseData(text: "Eu nunca fui a uma praia de nudismo.", category: .never),
        PhraseData(text: "Eu nunca usei brinquedos sexuais.", category: .never),
        PhraseData(text: "Eu nunca fingi um orgasmo.", category: .never),
        PhraseData(text: "Eu nunca tive um date com alguém que conheci online.", category: .never),
        PhraseData(text: "Eu nunca tive um ménage à trois.", category: .never),

        PhraseData(text: "[Name], bebe o teu copo em 10 segundos ou apanha 5 penalidades.", category: .timedChallenge, duration: 10.0),
        PhraseData(text: "[Name], faz 10 flexões em 30 segundos ou distribui 4 penalidades.", category: .timedChallenge, duration: 30.0),
        PhraseData(text: "[Name], conta uma piada seca em 15 segundos. Se ninguém rir (ou se não contares), apanha 3 penalidades.", category: .timedChallenge, duration: 15.0),
    ]
    
    private var currentPhraseIndex: Int = -1
    private var usedPhraseIndices: Set<Int> = []
    
    func addPlayer(_ name: String) -> Bool {
        guard players.count < maxPlayers, !name.isEmpty, !players.contains(name) else {
            return false
        }
        players.append(name)
        return true
    }
    
    func removePlayer(at index: Int) -> Bool {
        guard index >= 0, index < players.count else {
            return false
        }
        players.remove(at: index)
        return true
    }
    
    func canStartGame() -> Bool {
        return players.count >= 2
    }
    
    // Update getNextPhrase to return (String, PhraseCategory, Double?)
    func getNextPhrase() -> (text: String, category: PhraseCategory, duration: Double?)? {
        guard !phrases.isEmpty else { return nil } // Handle empty phrases array

        if usedPhraseIndices.count >= phrases.count {
            usedPhraseIndices.removeAll()
        }
        
        var nextIndex: Int
        repeat {
            nextIndex = Int.random(in: 0..<phrases.count)
        } while usedPhraseIndices.contains(nextIndex)
        
        currentPhraseIndex = nextIndex
        usedPhraseIndices.insert(nextIndex)
        
        let selectedPhraseData = phrases[nextIndex]
        let processedText = replacePlaceholders(in: selectedPhraseData.text)
        
        return (processedText, selectedPhraseData.category, selectedPhraseData.duration)
    }
    
    private func replacePlaceholders(in phrase: String) -> String {
        var result = phrase
        while result.contains("[Name]") {
            if let randomIndex = players.indices.randomElement() {
                result = result.replacingOccurrences(
                    of: "[Name]",
                    with: players[randomIndex],
                    options: .literal,
                    range: result.range(of: "[Name]")
                )
            } else {
                break
            }
        }
        return result
    }
    
    func resetGame() {
        currentPhraseIndex = -1
        usedPhraseIndices.removeAll()
        players.removeAll()
    }
    
    func resetCurrentGame() {
        currentPhraseIndex = -1
        usedPhraseIndices.removeAll()
    }
}
