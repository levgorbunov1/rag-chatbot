import { send_request } from "/javascripts/request/send_request.js";
import { create_chat_response_message } from "../factories/element_factory.js";
import { trigger_loading_animation } from "../animations/loading_animation.js";

export function chat_request_controller(user_question) {
    create_chat_response_message(user_question, "user-question");

    create_chat_response_message("Loading", "chat-loading-message");
    
    trigger_loading_animation();

    send_request(user_question);
}