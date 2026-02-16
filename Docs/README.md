# Agrofit - Sistema de Consulta de Defensivos Agrícolas

Sistema desenvolvido em Delphi para consumo da API Agrofit (Embrapa) com persistência local em banco de dados Firebird. Implementa arquitetura em camadas, princípios SOLID e interface responsiva.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Arquitetura](#arquitetura)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Banco de Dados](#estrutura-do-banco-de-dados)
- [Configuração e Instalação](#configuração-e-instalação)
- [Como Usar](#como-usar)
- [Códigos para Teste](#códigos-para-teste)
- [Princípios SOLID Aplicados](#princípios-solid-aplicados)
- [Responsividade](#responsividade)
- [Padrões de Código](#padrões-de-código)

---

## 📖 Sobre o Projeto

Este projeto foi desenvolvido como solução para uma prova técnica de Desenvolvedor Delphi Pleno. O objetivo é criar uma aplicação que:

- Consulte defensivos agrícolas através da API Agrofit (Embrapa)
- Armazene localmente os registros consultados
- Permita buscar dados tanto da API quanto do banco local
- Implemente separação de responsabilidades e boas práticas

**API utilizada:** [AgroAPI - Embrapa](https://www.agroapi.cnptia.embrapa.br/store/apis/info?name=AGROFIT&version=v1&provider=agroapi)

---

## 🛠️ Tecnologias Utilizadas

- **Delphi Community Edition**
- **VCL Framework** (Visual Component Library)
- **Firebird 2.5** - Banco de dados relacional
- **FireDAC** - Componentes nativos de acesso a dados
- **System.Net.HttpClient** - Consumo de API REST
- **System.JSON** - Parse de JSON

---

## 🏗️ Arquitetura

O projeto segue uma arquitetura em camadas bem definida, separando responsabilidades e facilitando manutenção:

```
📁 Agrofit
├── 📁 View (Apresentação)
│   ├── Agrofit.View.Principal.pas
│   └── Agrofit.View.Principal.dfm
│
├── 📁 Controller (Coordenação)
│   └── Agrofit.Controller.DefensivoAgricola.pas
│
├── 📁 Service (Serviços)
│   ├── Agrofit.Service.ApiClient.pas       (Consumo da API)
│   └── Agrofit.Service.Mapper.pas          (Conversão entre camadas)
│
├── 📁 Repository (Persistência)
│   └── Agrofit.Repository.DefensivoAgricola.pas
│
├── 📁 Domain (Domínio)
│   ├── Agrofit.Domain.DefensivoAgricola.pas      (Entidade de negócio)
│   └── Agrofit.Domain.DefensivoAgricolaDB.pas    (Entidade de BD)
│
├── 📁 DTO (Data Transfer Object)
│   └── Agrofit.DTO.DefensivoAgricola.pas
│
└── 📁 Core (Infraestrutura)
    ├── Agrofit.Core.Connection.pas (Singleton de conexão Firebird)
    └── Agrofit.Core.MyLib.pas (Biblioteca auxiliar)
```

### Fluxo de Dados

```
┌──────────┐      ┌────────────┐      ┌──────────┐      ┌────────────┐
│   View   │ ───> │ Controller │ ───> │ Service  │ ───> │  API/Repo  │
│          │ <─── │            │ <─── │ (Mapper) │ <─── │            │
└──────────┘      └────────────┘      └──────────┘      └────────────┘
```

**Responsabilidades:**

- **View**: Interface com usuário, captura de eventos
- **Controller**: Orquestração do fluxo, decisões de busca (banco vs API)
- **Service**: 
  - `ApiClient`: Comunicação HTTP com a API
  - `Mapper`: Conversão entre DTO ↔ Domain ↔ DomainDB
- **Repository**: Operações de banco de dados (CRUD)
- **Domain**: Entidades de negócio (sem dependências externas)
- **DTO**: Objetos de transferência (parse de JSON)
- **Core**: Infraestrutura compartilhada (conexão, utilitários)

---

## ⚙️ Funcionalidades

### 1. Consulta de Defensivos Agrícolas

- Busca por número do registro
- Prioridade: primeiro busca no banco local. Se não encontrar, consulta a API
- Exibe origem dos dados (banco local ou API)

### 2. Campos Exibidos

Os seguintes campos são extraídos do JSON retornado pela API:

- **Número do Registro** (`numero_registro`)
- **Marca Comercial** (`marca_comercial`)
- **Classe/Categoria Agronômica** (`classe_categoria_agronomica`)
- **Titular do Registro** (`titular_registro`)
- **Classificação Toxicológica** (`classificacao_toxicologica`)

### 3. Persistência Local

- Salvar defensivos consultados da API no banco Firebird
- Evita duplicação (verifica se já existe antes de salvar)
- Lista de códigos já salvos disponível no ComboBox

### 4. Interface Intuitiva

- ComboBox com histórico de códigos já consultados
- Campo de entrada permite digitação ou seleção
- Indicador visual da origem dos dados (azul = banco, verde = API)
- Botão "Salvar" habilitado apenas para dados novos vindos da API

---

## 🗄️ Estrutura do Banco de Dados

### Decisão de Design: Simplicidade vs Normalização

Para este projeto, optou-se por uma **estrutura simplificada** com apenas uma tabela, armazenando marcas comerciais e classes/categorias como campos concatenados (separados por vírgula), priorizando **simplicidade de implementação** ao invés de normalização completa.

**Vantagens da abordagem escolhida:**
- ✅ Estrutura de dados mais simples
- ✅ Menos joins em consultas
- ✅ Código mais direto e fácil de manter
- ✅ Adequado para o escopo do projeto (prova técnica)

### Tabela Única

#### DEFENSIVO_AGRICOLA

```sql
CREATE TABLE DEFENSIVO_AGRICOLA (
    ID INTEGER NOT NULL,
    NUMERO_REGISTRO VARCHAR(20) NOT NULL,
    MARCA_COMERCIAL VARCHAR(200),
    CLASSE_CATEGORIA_AGRONOMICA VARCHAR(200),
    TITULAR_REGISTRO VARCHAR(200),
    CLASSIFICACAO_TOXICOLOGICA VARCHAR(200),
    CONSTRAINT PK_DEFENSIVO_AGRICOLA PRIMARY KEY (ID),
    CONSTRAINT UNQ_NUMERO_REGISTRO UNIQUE (NUMERO_REGISTRO)
);
```

**Campos:**
- `ID`: Chave primária (autoincremento via trigger)
- `NUMERO_REGISTRO`: Número único do defensivo (ex: TC17824) - **UNIQUE**
- `MARCA_COMERCIAL`: Marcas comerciais concatenadas (ex: "Marca A, Marca B")
- `CLASSE_CATEGORIA_AGRONOMICA`: Classes concatenadas (ex: "Inseticida, Acaricida")
- `TITULAR_REGISTRO`: Empresa titular do registro
- `CLASSIFICACAO_TOXICOLOGICA`: Classificação toxicológica do produto

**Constraints:**
- `PK_DEFENSIVO_AGRICOLA`: Chave primária em ID
- `UNQ_NUMERO_REGISTRO`: Garante que não haja números de registro duplicados

**Generator e Trigger:**
- `GEN_DEFENSIVO_AGRICOLA_ID`: Sequence para autoincremento
- `TRG_DEFENSIVO_AGRICOLA_BI`: Trigger BEFORE INSERT para gerar ID automaticamente

### Exemplo de Dados

| ID | NUMERO_REGISTRO | MARCA_COMERCIAL            | CLASSE_CATEGORIA_AGRONOMICA | TITULAR_REGISTRO |
|----|-----------------|----------------------------|-----------------------------|------------------|
| 1  | TC17824         | Lufenuron Técnico CCAB III | Inseticida                  | CCAB Agro S.A.   |
| 2  | TC23122         | Match EC                   | Acaricida, Inseticida       | Syngenta         |

### Scripts

O script SQL completo está disponível em: `Docs\script_database_agrofit.sql`

---

## 🔧 Configuração e Instalação

### Pré-requisitos

- Delphi Community Edition (10.4 ou superior recomendado)
- Firebird 2.5 instalado
- Banco de dados criado

### Estrutura do Projeto

```
📁 Agrofit/
├── 📁 Source/          (Código-fonte)
├── 📁 bin/             (Executável + fbclient.dll + Config.ini)
├── 📁 DB/              (Banco de dados)
├── 📁 Assets/          (Ícones e imagens)
├── 📁 Docs/            (Documentação, scripts e códigos de teste)
│   ├── README.md
│   ├── script_database_agrofit.sql
│   └── codigos_testar.txt
├── firebird.msg        (Mensagens do Firebird - raiz do projeto)
└── Agrofit.dpr
```

### Passo a Passo

1. **Extraia o projeto**
   ```
   Agrofit/
   ```

2. **Configure o banco de dados**
   - Crie o banco no Firebird usando as instruções em `Docs\script_database_agrofit.sql`
   - Execute o script SQL completo para criar as tabelas

3. **Copie arquivos do Firebird** (se necessário)
   
   Se ainda não estiverem no projeto, copie do Firebird instalado:
   
   ```
   C:\Program Files\Firebird\Firebird_2_5\bin\fbclient.dll
   → Para: Agrofit\bin\fbclient.dll
   
   C:\Program Files\Firebird\Firebird_2_5\firebird.msg
   → Para: Agrofit\firebird.msg
   ```

4. **Configure o arquivo Config.ini**
   
   Edite `bin\Config.ini`:

   ```ini
   [Database]
   DriverName=FB
   PathDB=..\DB\AGROFIT.FDB
   Server=localhost
   Port=3050

   [FireDAC]
   VendorLib=fbclient.dll
   ```

   **Ajuste o caminho do banco conforme sua instalação!**

5. **Compile o projeto**
   - Abra `Agrofit.dproj` no Delphi
   - Menu: Project → Build Agrofit
   - O executável será gerado em `bin\`
   - Configurações do compilador:
     - Output directory: `.\bin`
     - Unit output directory: `.\Source\dcu`

6. **Execute**
   - Certifique-se de que `Config.ini` está configurado corretamente e na mesma pasta do executável
   - Execute `bin\Agrofit.exe`
   - Use os códigos em `Docs\codigos_testar.txt` para testar

---

## 🚀 Como Usar

### Consultando um Defensivo

1. **Digite ou selecione** um número do registro no ComboBox
   - Exemplo: `TC17824`

2. **Clique em "Consultar"**
   - O sistema busca primeiro no banco local
   - Se não encontrar, consulta a API da Embrapa

3. **Visualize os dados**
   - Os campos serão preenchidos automaticamente
   - Um indicador mostra a origem dos dados:
     - 🔵 **Azul**: Dados do banco local
     - 🟢 **Verde**: Dados atualizados da API

4. **Salve no banco (opcional)**
   - Se os dados vieram da API, o botão "Salvar no Banco" é habilitado
   - Clique para armazenar localmente
   - Em futuras consultas, os dados virão do banco (mais rápido)

### Comportamento do Sistema

- **Primeira consulta de um código**: Busca na API → Pode salvar no banco
- **Consulta de código já salvo**: Busca no banco local (instantâneo)
- **Consulta de código inexistente**: Exibe mensagem de erro

---

## 🧪 Códigos para Teste

Para facilitar os testes da aplicação, uma lista com **10 códigos válidos** está disponível no arquivo:

```
\Docs\codigos_testar.txt
```

**Códigos disponíveis:**
- TC17824
- TC06324
- TC23122 (exemplo com múltiplas classes: Acaricida | Inseticida)
- TC25722
- TC27222
- 6616
- 6516
- 16918
- 4518
- 6316

Estes códigos podem ser utilizados para testar o consumo da API e a persistência no banco de dados. Basta copiar um código do arquivo e colar no campo de consulta.

**Dica**: Após consultar e salvar alguns códigos, eles aparecerão automaticamente no ComboBox para seleção rápida.

**Nota sobre múltiplas classes**: Quando um defensivo possui mais de uma classe/categoria (ex: TC23122), elas serão exibidas separadas por " , " no campo Classe/Categoria.

---

## 🎯 Princípios SOLID Aplicados

### 1. **SRP - Single Responsibility Principle** (Princípio da Responsabilidade Única)

Cada classe tem uma única responsabilidade bem definida:

- `TAgrofitApiClient`: Apenas consumo da API HTTP
- `TDefensivoAgricolaRepository`: Apenas operações de banco de dados
- `TDefensivoAgricolaMapper`: Apenas conversão entre objetos
- `TDefensivoAgricolaController`: Apenas orquestração do fluxo

**Benefício**: Facilita manutenção e testes unitários.

### 2. **DIP - Dependency Inversion Principle** (Princípio da Inversão de Dependência)

O Controller depende de abstrações (interfaces), não de implementações concretas:

```pascal
TDefensivoAgricolaController = class
private
  FApiClient: iApiClient;              // ← Interface
  FRepository: iDefensivoAgricolaRepository;  // ← Interface
public
  constructor Create(AApiClient: iApiClient; 
                     ARepository: iDefensivoAgricolaRepository);
end;
```

**Benefício**: Permite trocar implementações (ex: mudar de Firebird para outro banco) sem alterar o Controller.

### 3. **OCP - Open/Closed Principle** (Princípio Aberto/Fechado)

O Mapper permite adicionar novos tipos de conversão sem modificar código existente:

```pascal
class function DTOToDomain(const ADTO: TDefensivoAgricolaDTO): TDefensivoAgricola;
class function DomainToDomainDB(const ADomain: TDefensivoAgricola): TDefensivoAgricolaDB;
// Novos métodos podem ser adicionados sem alterar os existentes
```

---

## 📱 Responsividade

Para garantir uma experiência adequada em diferentes resoluções de tela, foram implementadas as seguintes práticas:

#### 1. **Uso de GridPanels**

Os componentes foram organizados dentro de `TGridPanel` para organização automática:

- `grpConsulta` → Contém `grdConsulta` (GridPanel)
- `grpDados` → Contém `grdDados` (GridPanel)

**Benefício**: Os campos se ajustam automaticamente, conforme o tamanho da janela.

#### 2. **LabeledEdit para campos de entrada**

Utilização de `TLabeledEdit` para todos os campos de dados, garantindo alinhamento consistente entre label e campo de entrada.

#### 3. **Botões com dimensões fixas**

Os botões (`btnConsultar`, `btnSalvar`) mantêm dimensões fixas:

- Largura: 130px
- Altura: 30px

**Motivo**: Dimensões fixas evitam que os botões fiquem desproporcionais em telas muito grandes ou muito pequenas.

#### 4. **Alinhamento Estratégico**

- `cmbNumeroRegistro`: 273px fixos (alinhado pela esquerda com `edtNumeroRegistroExibicao`)
- `btnConsultar`: Posicionado ao lado direito do ComboBox (indicando visualmente que a ação depende do uso do campo)
- Uso de `Margins` para espaçamento adequado entre componentes

### Estrutura Responsiva

```
grpConsulta
└── grdConsulta (GridPanel)
    └── pnlConsultaFields
        ├── lblNumeroRegistro (alTop)
        ├── cmbNumeroRegistro (alLeft, 300px fixo)
        └── btnConsultar (alLeft, 130px fixo)

grpDados
└── grdDados (GridPanel com 2 colunas)
    ├── Linha 1: edtNumeroRegistroExibicao + lblOrigemDados
    ├── Linha 2: edtMarcaComercial (span 2 colunas)
    ├── Linha 3: edtClasseCategoria (span 2 colunas)
    ├── Linha 4: edtTitularRegistro (span 2 colunas)
    └── Linha 5: edtClassificacaoToxicologica (span 2 colunas)
```

---

## 📝 Padrões de Código

### Nomenclatura de Componentes

O projeto segue um padrão consistente de **3 letras minúsculas** para prefixos:

| Tipo         | Prefixo | Exemplo                    |
|--------------|---------|----------------------------|
| Panel        | `pnl`   | `pnlTop`, `pnlCenter`      |
| GroupBox     | `grp`   | `grpConsulta`, `grpDados`  |
| GridPanel    | `grd`   | `grdConsulta`, `grdDados`  |
| Button       | `btn`   | `btnConsultar`, `btnSalvar`|
| Label        | `lbl`   | `lblTitulo`, `lblOrigem`   |
| Edit         | `edt`   | `edtMarcaComercial`        |
| ComboBox     | `cmb`   | `cmbNumeroRegistro`        |

### Nomenclatura de Units

Todas as units seguem o padrão:

```
NomeProjeto.Camada.Assunto.pas
```

**Exemplos:**
- `Agrofit.View.Principal.pas`
- `Agrofit.Controller.DefensivoAgricola.pas`
- `Agrofit.Service.ApiClient.pas`
- `Agrofit.Repository.DefensivoAgricola.pas`

### Convenções Gerais

- **Classes**: `PascalCase` → `TDefensivoAgricola`
- **Métodos**: `PascalCase` → `ConsultarDefensivo`
- **Variáveis locais**: `PascalCase` com prefixo `L` → `LNumeroRegistro`
- **Parâmetros**: `PascalCase` com prefixo `A` → `ADefensivo`
- **Fields privados**: `PascalCase` com prefixo `F` → `FController`
- **Interfaces**: `PascalCase` com prefixo `i` (minúsculo) → `iApiClient`

### Gerenciamento de Memória

- **Classes**: Sempre usar `try/finally` com `Free` ou `FreeAndNil`
- **Interfaces**: Gerenciamento automático por referência (ARC)
- **Singleton**: Destruído na seção `finalization` da unit
- **Memory Leak Detection**: Ativo via `ReportMemoryLeaksOnShutdown := True`

---

## 🐛 Tratamento de Erros

O sistema implementa tratamento de exceções em pontos críticos:

### 1. Consumo da API
```pascal
if LResponse.StatusCode = 200 then
  Result := ParseJSON(LResponse.ContentAsString)
else
  raise Exception.CreateFmt('Erro ao consultar API. Status: %d', [LResponse.StatusCode]);
```

### 2. Parse de JSON
```pascal
try
  // Parse do JSON
except
  on E: Exception do
  begin
    Result.Free;
    raise Exception.Create('Erro ao processar resposta da API: ' + E.Message);
  end;
end;
```

### 3. Operações de Banco
```pascal
try
  LQry.Connection.StartTransaction;
  // Operações SQL
  LQry.Connection.Commit;
except
  on E: Exception do
  begin
    LQry.Connection.Rollback;
    raise;
  end;
end;
```

---

## 📚 Estrutura de Dados

### Fluxo de Conversão

```
API JSON → DTO → Domain → Repository → Banco de Dados
```

### Objetos de Dados

1. **TDefensivoAgricolaDTO** (DTO)
   - Representa o JSON da API
   - Usado apenas na camada Service
   - Campos como strings simples

2. **TDefensivoAgricola** (Domain)
   - Entidade de negócio
   - Usada no Controller e View
   - Independente de banco e API
   - Campos como strings simples
   - Exemplo: `MarcaComercial: "Marca A, Marca B"`

### Formato de Armazenamento

**No Banco de Dados:**
- Marcas comerciais e classes são armazenadas concatenadas (separadas por vírgula)
- Exemplo: 
  - `MARCA_COMERCIAL`: "Lufenuron Técnico CCAB III"
  - `CLASSE_CATEGORIA_AGRONOMICA`: "Inseticida, Acaricida"

**Na Exibição (View):**
- Os dados são exibidos exatamente como vêm do banco
- Separador: vírgula (conforme retornado pela API)

---

## 🔐 Segurança

### API Token

O token de acesso à API está definido como constante privada na classe:

```pascal
const C_API_TOKEN = '9c9e9246-6835-33b3-90f7-fb1cff941bae';
```

**Nota**: Em produção deve ser considerado armazenar tokens em configuração externa ou variáveis de ambiente.

### Banco de Dados

- Conexão usando credenciais padrão do Firebird
- **Recomendação**: Alterar usuário/senha padrão em ambiente de produção
- Parâmetros sensíveis no arquivo `Config.ini`

---

## 🧪 Testes

### Testando a Aplicação

1. **Teste de Consulta da API**
   - Use um dos códigos do arquivo `codigos_testar.txt`
   - Verifique se os dados são exibidos corretamente
   - Indicador deve mostrar "verde" (dados da API)

2. **Teste de Persistência**
   - Após consultar, clique em "Salvar no Banco"
   - Feche e reabra o aplicativo
   - Consulte o mesmo código novamente
   - Indicador deve mostrar "azul" (dados do banco)

3. **Teste de Código Inválido**
   - Digite um código inexistente (ex: `TESTE123`)
   - Deve exibir mensagem de erro apropriada

4. **Teste de Memory Leak**
   - Execute o aplicativo
   - Faça várias consultas
   - Salve alguns registros
   - Feche o aplicativo
   - **Não deve aparecer mensagem de memory leak**

---

## 📄 Licença

Este projeto foi desenvolvido como prova técnica e está disponível para fins educacionais.

---

## 👤 Autor

Desenvolvido por Sérgio Carlos Guimarães Alves como parte de processo seletivo para a posição de Desenvolvedor Delphi Pleno.
Por questões éticas, o nome da empresa que ofertou a vaga não será citado.

---

## 📞 Suporte

Em caso de dúvidas sobre configuração ou execução:

1. Verifique se o `Config.ini` está configurado corretamente
2. Confirme se o serviço do Firebird está em execução
3. Teste a conectividade com o banco usando ferramentas como IBExpert, DBeaver, FlameRobin, etc.
4. Verifique se a DLL do Firebird (`fbclient.dll`) está acessível

---

**Última atualização**: 16/02/2026  
**Versão**: 1.0.0

### Changelog

**v1.0.0 (Fevereiro 2025)**
- Versão inicial do projeto
