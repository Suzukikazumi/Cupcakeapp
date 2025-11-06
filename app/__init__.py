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
    with app.app_context():
        db.create_all()

        from .models import Cupcake, Avaliacao, Usuario
        if not Cupcake.query.first():
            demo_cupcakes = [
                Cupcake(nome="Cupcake de Chocolate", preco=7.5, descricao="Cobertura cremosa de chocolate"),
                Cupcake(nome="Cupcake de Morango", preco=6.0, descricao="Com pedaços de morango fresco"),
                Cupcake(nome="Cupcake de Baunilha", preco=5.5, descricao="Tradicional e suave"),
            ]
            db.session.add_all(demo_cupcakes)
            db.session.commit()

        if not Usuario.query.first():
            user = Usuario(nome="Cliente Demo", email="demo@email.com", senha="123456")
            db.session.add(user)
            db.session.commit()

        if not Avaliacao.query.first():
            cup1 = Cupcake.query.first()
            user = Usuario.query.first()
            db.session.add(Avaliacao(id_usuario=user.id_usuario, id_cupcake=cup1.id_cupcake, nota=5, comentario="Excelente!"))
            db.session.commit()

    return app
