import streamlit as st
import smtplib
from email.message import EmailMessage

# Configurazione Pagina
st.set_page_config(page_title="Invio Ticket Fornitore", page_icon="🎫")
st.title("🎫 Ticket Automation")
st.write("Compila i campi per inviare la mail di assistenza al fornitore.")

# Modulo di inserimento dati
with st.form("form_ticket"):
    fornitore_email = "assistenza@fornitore.it" # Email del tuo fornitore
    oggetto_base = st.text_input("Oggetto del problema", placeholder="es. Errore Login Portale")
    priorita = st.select_slider("Priorità", options=["Bassa", "Media", "Alta", "URGENTE"])
    descrizione = st.text_area("Descrizione dettagliata", help="Inserisci codici errore o passaggi per replicare")
    
    submit = st.form_submit_button("Invia Richiesta")

if submit:
    if not oggetto_base or not descrizione:
        st.error("Per favore, compila tutti i campi.")
    else:
        try:
            # Creazione Email
            msg = EmailMessage()
            msg['Subject'] = f"[{priorita}] {oggetto_base}"
            msg['From'] = st.secrets["EMAIL_USER"]
            msg['To'] = fornitore_email
            msg.set_content(f"Richiesta inviata tramite Web App:\n\nPriorità: {priorita}\nDescrizione:\n{descrizione}")

            # Invio tramite server SMTP (es. Gmail)
            with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
                server.login(st.secrets["EMAIL_USER"], st.secrets["EMAIL_PASS"])
                server.send_message(msg)
            
            st.success(f"✅ Ticket inviato con successo a {fornitore_email}!")
            st.balloons()
        except Exception as e:
            st.error(f"Errore durante l'invio: {e}")
            