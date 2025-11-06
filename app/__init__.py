from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config


db = SQLAlchemy()

def create_app():
    app = Flask(__name__, template_folder="templates", static_folder="static")
    app.config.from_object(Config)
    db.init_app(app)

    from . import models


    from .controllers.auth import bp as auth_bp
    from .controllers.shop import bp as shop_bp
    from .controllers.support import bp as support_bp
    from .controllers.notifications import bp as notifications_bp
    from .controllers.admin import bp as admin_bp


    app.register_blueprint(auth_bp)
    app.register_blueprint(shop_bp)
    app.register_blueprint(support_bp)
    app.register_blueprint(notifications_bp)
    app.register_blueprint(admin_bp)

    with app.app_context():
        db.create_all()
  
        from .models import Cupcake, Usuario, Avaliacao, Cupom

        if not Cupcake.query.first():
            demo_cupcakes = [
                Cupcake(nome="Red Velvet", preco=8.0, descricao="Com cobertura de cream cheese", imagem="redvelvet.jpg"),
                Cupcake(nome="Chocolate", preco=7.5, descricao="Cobertura cremosa de chocolate", imagem="chocolate.jpg"),
                Cupcake(nome="Baunilha", preco=6.0, descricao="Sabor clássico com granulado", imagem="baunilha.jpg"),
                Cupcake(nome="Morango", preco=6.5, descricao="Recheio e cobertura de morango", imagem="morango.jpg"),
            ]
            db.session.add_all(demo_cupcakes)
            print("🍰 Cupcakes adicionados!")

        if not Cupom.query.first():
            demo_cupons = [
                Cupom(codigo="DESCONTO10", valor_desconto=10, ativo=True),
                Cupom(codigo="BOASVINDAS", valor_desconto=15, ativo=True),
                Cupom(codigo="CUPCAKEVIP", valor_desconto=20, ativo=True),
            ]
            db.session.add_all(demo_cupons)
            print("🎟️ Cupons adicionados!")

        if not Usuario.query.filter_by(email="teste@email.com").first():
            user = Usuario(nome="Usuário Teste", email="teste@email.com", senha="123456")
            db.session.add(user)
            print("👤 Usuário demo criado!")

        db.session.commit()



        if not Avaliacao.query.first():
            cup1 = Cupcake.query.first()
            user = Usuario.query.first()
            db.session.add(Avaliacao(id_usuario=user.id_usuario, id_cupcake=cup1.id_cupcake, nota=5, comentario="Excelente!"))
            db.session.commit()

    return app
