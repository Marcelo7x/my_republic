# MyRepublic

O MyRepublic é uma aplicação frontend em Flutter projetada para facilitar aos usuários a gestão de despesas compartilhadas em um ambiente de convivência, como uma "república". Os usuários podem criar uma "república" dentro do aplicativo e adicionar contas para suas despesas nesse espaço. O aplicativo calcula as despesas totais, divide entre os usuários e fornece representações gráficas e porcentagens de gastos e valores.

## MyRepublic Backend

O backend do MyRepublic foi desenvolvido em Dart usando o shelf_modular. Nele, todas as regras de negócios do aplicativo MyRepublic, incluindo login e cadastro de usuários, são executadas. Além disso, foi implementado o JWT do zero para controle de sessão do usuário. A documentação é feita via Swagger, além utilizar o Prisma.

### Execução

Para executar o backend do MyRepublic, siga estes passos:

1. Rode uma imagem do PostgreSQL no Docker com senha Postgres e usuário Postgres exposto na porta 5432.

2. Configure a URI do banco de dados adicionando-a como valor para o parâmetro `DATABASE_URL` no arquivo `.env`. O banco de dados deve ter o nome "myrepublic", como no exemplo:
    ```
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/myrepublic
    ```

3. Configure o parâmetro `JWT_KEY` no arquivo `.env`, que se trata da chave privada do aplicativo.
    ```
    JWT_KEY=chaveprivada
    ```

4. Instale o Prisma via npm.
    ```
    npm -g i prisma 
    ```

5. Suba as tabelas do banco de dados com o Prisma:
     ```
    npx prisma db push
    ```

6. Baixe as dependências Dart.
     ```
    dart pub get
    ```

7. Rode o servidor. O servidor é exposto na porta 3001.
    ```
    dart run bin/server.dart
    Server listening on port 3001
    ```

### Acessando a documentação das rotas

A documentação pode ser acessada em `localhost:3001/documentation/`.


## MyRepublic Frontend

Frontend do MyRepublic.

<img src="/frontend/images/screenshots/1.png" alt="MyRepublic Login" heigth="500" width="200"> <img src="/frontend/images/screenshots/2.png" alt="MyRepublic Sign Up" heigth="500" width="200"> <img src="/frontend/images/screenshots/3.png" alt="MyRepublic Search Republic" heigth="500" width="200"> <img src="/frontend/images/screenshots/4.png" alt="MyRepublic Search Republic2" heigth="500" width="200"> <img src="/frontend/images/screenshots/5.png" alt="MyRepublic Notification" heigth="500" width="200"> <img src="/frontend/images/screenshots/6.png" alt="MyRepublic Invoices" heigth="500" width="200"> <img src="/frontend/images/screenshots/7.png" alt="MyRepublic Balance" heigth="500" width="200">

### Execução

Para executar a aplicação MyRepublic, siga estes passos:

1. Configure a URL do backend adicionando-a como valor para o parâmetro `API_URL` no arquivo `.env`
    ```
    API_URL=https://sua-url-do-backend.com/api
    ```
2. Baixe as dependências do projeto Dart.
    ```
    dart pug get
    ```