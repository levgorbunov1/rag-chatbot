export function create_chat_response_message_from_html_string(html_string_message) {
    const chat_container = document.getElementById('response-container');

    const chat_response_message = document.createElement('div');

    chat_response_message.classList.add("chat-message-html");

    chat_response_message.innerHTML = html_string_message

    chat_container.appendChild(chat_response_message);

    chat_container.scrollTop = chat_container.scrollHeight;
}

export function create_chat_response_message(text, type) {
    const chat_container = document.getElementById('response-container');

    const chat_response_message = document.createElement('div');

    chat_response_message.classList.add(type);
    chat_response_message.textContent = text;

    if (type === "chat-loading-message") {
        chat_response_message.id = type;
    }

    chat_container.appendChild(chat_response_message);

    chat_container.scrollTop = chat_container.scrollHeight;
}