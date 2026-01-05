export function create_html_string_table(rows) {
    const columns = Object.keys(rows[0]);

    const html_string_columns = columns.map(column => `<th>${column.replace(/_/g, " ")}</th>`);

    const html_string_rows = rows.map(row => `
        <tr>
            ${columns.map(column => `<td>${row[column]}</td>`).join("")}
        </tr>
        `
    );

    let html_string_table = `
        <table>
            <thead>
                <tr>
                    ${html_string_columns.join("")}
                </tr>
            </thead>
            <tbody>
                ${html_string_rows.join("")}
            </tbody>
        </table>
    `;

    return html_string_table
}

export function create_html_string_paragraph(text) {
    return `<p>${text}</p>`
}