# Crowdfunding - Aluno: Marcelo C Miguel

# Dicionário que indica o valor doado pelo usuário
users: public(HashMap[address, uint256])

# valor da meta
goal: uint256

#deadline
deadline: uint256

# Flag para indicar se foi finalizado o crowdfunding pelo dono do contrato
end: bool

# Endereço do dono do contrato
owner: address

# quantidade arrecadada
amount: uint256

# Função que roda quando é feito o deploy do contrato
@external
def __init__(goal: uint256, deadline: uint256):
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender
    self.goal = goal
    self.amount = 0
    self.end = False
    self.deadline = deadline # Deadline do projeto
    assert block.timestamp < self.deadline # Garantir que passou um timestamp maior que o atual do bloco

# Função que encerra o evento
@external
def finish():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    #Testa se o prazo já foi concluído
    assert block.timestamp > self.deadline 

    # Testa se a meta foi batida
    assert self.amount >= self.goal
    
    # Testa se já não foi finalizado o contrato
    assert self.end == False

    # Envia dinheiro do contrato para o dono
    self.end = True
    send(msg.sender, self.balance)

# função de doar valor
@external
@payable
def donate():
    # só pode doar se estiver dentro do prazo
    assert block.timestamp < self.deadline

    self.amount += msg.value
    # Armazenado valor doado pelo doador
    self.users[msg.sender] += msg.value
    
# função de receber valores caso a meta não seja batida
@external
def refund():
    
    # Testa se o prazo foi ultrapassado
    assert block.timestamp > self.deadline
    
    # Testa se o valor arrecadado não superou a meta
    assert self.amount < self.goal

    # Testa se o doador de fato doou algum valor para ser retornado
    assert self.users[msg.sender] > 0
    
    # Envia dinheiro doado pelo usuário para ele mesmo
    send(msg.sender, self.users[msg.sender])
    
    #zera valor doado pelo usuário
    self.users[msg.sender] = 0

