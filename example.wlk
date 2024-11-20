object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

class Personaje{
  var property copas = 0


  method darCopas(cuantas){
    copas += cuantas
  }

}

class Arquero inherits Personaje{

  var agilidad
  var rango

  method destreza() = agilidad * rango
  method tieneEstrategia() = rango > 100

}

class Guerrera inherits Personaje{
  var fuerza
  var estrategia

  method tieneEstrategia() = estrategia
  method destreza() = fuerza * 1.5


}

class Ballestero inherits Arquero{

override method destreza() = super() * 2

}

class Mision{

  var tipoMision = MisionComun

  method realizar(){
    self.verificarPuedeRealizarse()
    self.repartirCopas()
  }

  method esSuperada() = self.tieneEstrategia() || self.destrezaSuficiente()

  method tieneEstrategia()
  method destrezaSuficiente()

  method sePuedeRealizar()

  method verificarPuedeRealizarse(){ 
    if(not(self.sePuedeRealizar())){
      throw new Exception(message = "Mision no puede comenzar")
    }
  }

  method repartirCopas()


  method sumarOrestar()= if(self.esSuperada())1 else -1
  

  method cantCopasTotales() = tipoMision.cantCopas(self)
}

class MisionIndividual inherits Mision{
  var personaje
  var dificultad
  method copasEnJuego() = 2 * dificultad

  override method tieneEstrategia() = personaje.tieneEstrategia()
  override method destrezaSuficiente() = personaje.destreza() > dificultad

  override method sePuedeRealizar() = personaje.copas() >= 10

  method cambiarPersonaje(nuevoPer){
    personaje = nuevoPer
  }

  method cantParticipantes() = 1

  override method repartirCopas(){personaje.darCopas(self.cantCopasTotales() * self.sumarOrestar())}
}

class MisionPorEquipo inherits Mision{

  const personajes = []

  method cantParticipantes() = personajes.size()
  method copasEnJuego() = 50 / self.cantParticipantes()

  override method tieneEstrategia() = self.personajesConEstrategia() > (self.cantParticipantes() / 2)

  method personajesConEstrategia() = personajes.count({personaje=>personaje.tieneEstrategia()})

  override method destrezaSuficiente() = personajes.all({personaje=>personaje.destreza() > 400})

  override method sePuedeRealizar() = personajes.sum({personaje=>personaje.copas()} >= 60)

  override method repartirCopas(){personajes.forEach({personaje=>personaje.darCopas(self.cantCopasTotales() * self.sumarOrestar())})}
}

class MisionComun{
  method cantCopas(mision) = mision.copasEnJuego()
}

class MisionBoost{
  var property multiplicador
  method cantCopas(mision) = mision.copasEnJuego() * multiplicador
}

class MisionBonus{
  method cantCopas(mision) = mision.copasEnJuego() + mision.cantParticipantes()
}