import SwiftUI

// MARK: - Modelos
struct Opcion: Identifiable {
    let id: Int
    let texto: String
    let personaje: String
}

struct Pregunta: Identifiable {
    let id: Int
    let texto: String
    let opciones: [Opcion]
}

struct Personaje {
    let nombre: String
    let descripcion: String
}

// MARK: - Aplicación
@main
struct QuePersonajeEresApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    private let preguntas: [Pregunta] = [
        Pregunta(id: 1, texto: "¿Cómo prefieres resolver un problema?", opciones: [
            Opcion(id: 1, texto: "Con valentía y acción", personaje: "Moana"),
            Opcion(id: 2, texto: "Analizando cada detalle", personaje: "Hermione Granger"),
            Opcion(id: 3, texto: "Con creatividad e imaginación", personaje: "Spider-Man"),
            Opcion(id: 4, texto: "Ayudando y escuchando a los demás", personaje: "Shrek")
        ]),
        Pregunta(id: 2, texto: "¿Qué valor es más importante para ti?", opciones: [
            Opcion(id: 1, texto: "La perseverancia", personaje: "Moana"),
            Opcion(id: 2, texto: "El conocimiento", personaje: "Hermione Granger"),
            Opcion(id: 3, texto: "La responsabilidad", personaje: "Spider-Man"),
            Opcion(id: 4, texto: "La lealtad", personaje: "Shrek")
        ]),
        Pregunta(id: 3, texto: "¿Qué actividad elegirías?", opciones: [
            Opcion(id: 1, texto: "Explorar un lugar desconocido", personaje: "Moana"),
            Opcion(id: 2, texto: "Leer o aprender algo nuevo", personaje: "Hermione Granger"),
            Opcion(id: 3, texto: "Crear un invento o probar algo nuevo", personaje: "Spider-Man"),
            Opcion(id: 4, texto: "Pasar tiempo con tus amigos", personaje: "Shrek")
        ]),
        Pregunta(id: 4, texto: "¿Cómo actúas ante un reto difícil?", opciones: [
            Opcion(id: 1, texto: "Sigo adelante aunque tenga miedo", personaje: "Moana"),
            Opcion(id: 2, texto: "Busco información y preparo un plan", personaje: "Hermione Granger"),
            Opcion(id: 3, texto: "Improviso y busco una solución ingeniosa", personaje: "Spider-Man"),
            Opcion(id: 4, texto: "Pido apoyo a las personas de confianza", personaje: "Shrek")
        ]),
        Pregunta(id: 5, texto: "¿Qué frase te representa mejor?", opciones: [
            Opcion(id: 1, texto: "Me atrevo a descubrir mi camino", personaje: "Moana"),
            Opcion(id: 2, texto: "Aprender siempre me hace más fuerte", personaje: "Hermione Granger"),
            Opcion(id: 3, texto: "Con grandes responsabilidades vienen grandes decisiones", personaje: "Spider-Man"),
            Opcion(id: 4, texto: "Valoro a quienes me aceptan como soy", personaje: "Shrek")
        ])
    ]

    private let personajes: [String: Personaje] = [
        "Moana": Personaje(nombre: "Moana", descripcion: "Eres valiente, perseverante y tienes curiosidad por descubrir nuevos caminos. Confías en tus capacidades y no te rindes fácilmente."),
        "Hermione Granger": Personaje(nombre: "Hermione Granger", descripcion: "Eres una persona analítica, estudiosa y preparada. Valoras el conocimiento y buscas soluciones mediante la lógica y el esfuerzo."),
        "Spider-Man": Personaje(nombre: "Spider-Man", descripcion: "Eres creativo, ingenioso y consciente de tus responsabilidades. Intentas ayudar a los demás y encuentras alternativas ante los retos."),
        "Shrek": Personaje(nombre: "Shrek", descripcion: "Eres leal, auténtico y valoras las relaciones sinceras. Aunque puedes parecer reservado, te preocupas por las personas importantes para ti.")
    ]

    @State private var indicePregunta = 0
    @State private var respuestaSeleccionada: Int? = nil
    @State private var puntuaciones: [String: Int] = [
        "Moana": 0, "Hermione Granger": 0, "Spider-Man": 0, "Shrek": 0
    ]
    @State private var cuestionarioTerminado = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("¿Qué personaje eres?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                if cuestionarioTerminado {
                    pantallaResultado
                } else {
                    Text("Pregunta \(indicePregunta + 1) de \(preguntas.count)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    ProgressView(value: Double(indicePregunta + 1),
                                 total: Double(preguntas.count))
                        .padding(.horizontal)

                    Text(preguntas[indicePregunta].texto)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    ForEach(preguntas[indicePregunta].opciones) { opcion in
                        Button {
                            // Solo se guarda una selección para la pregunta actual.
                            if respuestaSeleccionada == nil {
                                respuestaSeleccionada = opcion.id
                                puntuaciones[opcion.personaje, default: 0] += 1
                            }
                        } label: {
                            HStack {
                                Text(opcion.texto)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if respuestaSeleccionada == opcion.id {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(respuestaSeleccionada == opcion.id ? Color.blue.opacity(0.18) : Color.gray.opacity(0.10))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .disabled(respuestaSeleccionada != nil)
                    }

                    Button(indicePregunta == preguntas.count - 1 ? "Ver resultado" : "Siguiente") {
                        avanzar()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(respuestaSeleccionada == nil)
                    .padding(.top, 8)
                }
                Spacer(minLength: 0)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    private var pantallaResultado: some View {
        let ganador = personajeGanador()
        return VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.yellow)

            Text("Tu personaje es:")
                .font(.title2)

            Text(ganador.nombre)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(ganador.descripcion)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button("Volver a empezar") {
                reiniciar()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func avanzar() {
        // La respuesta ya quedó registrada y los botones quedan bloqueados.
        if indicePregunta < preguntas.count - 1 {
            indicePregunta += 1
            respuestaSeleccionada = nil
        } else {
            cuestionarioTerminado = true
        }
    }

    private func personajeGanador() -> Personaje {
        var nombreGanador = "Moana"
        var puntuacionMayor = -1

        // Recorre las puntuaciones y conserva el personaje con más puntos.
        for (nombre, puntos) in puntuaciones {
            if puntos > puntuacionMayor {
                puntuacionMayor = puntos
                nombreGanador = nombre
            }
        }

        // El diccionario contiene todos los personajes definidos.
        return personajes[nombreGanador] ?? Personaje(
            nombre: "Moana",
            descripcion: "Eres una persona valiente y perseverante."
        )
    }

    private func reiniciar() {
        indicePregunta = 0
        respuestaSeleccionada = nil
        cuestionarioTerminado = false
        for nombre in puntuaciones.keys {
            puntuaciones[nombre] = 0
        }
    }
}
