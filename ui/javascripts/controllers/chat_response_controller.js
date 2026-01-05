import { 
    create_chat_response_message_from_html_string,
    create_chat_response_message
 } from "/javascripts/factories/element_factory.js";
import { delete_element } from "/javascripts/animations/loading_animation.js";
import { create_html_string_paragraph, create_html_string_table } 
from "/javascripts/factories/html_string_factory.js";

export function chat_response_controller(data) {
    delete_element("chat-loading-message");

    var query = data.query;
    var query_result_rows = data.query_result;
    
    const html_string_query_header_paragraph = create_html_string_paragraph("Query:");
    const html_string_query_paragraph = create_html_string_paragraph(query);
    const html_string_query_result_header_paragraph = create_html_string_paragraph("Query Result:");
    const html_string_query_result_table = create_html_string_table(query_result_rows);

    const html_string_message = [
        html_string_query_header_paragraph, 
        html_string_query_paragraph,
        html_string_query_result_header_paragraph,
        html_string_query_result_table
    ].join("");

    create_chat_response_message_from_html_string(html_string_message);
}

export function error_response_controller(data) {
    delete_element("chat-loading-message");

    var message = data.message;

    create_chat_response_message(message, "chat-message");
}