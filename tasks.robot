*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP
Library    RPA.Excel.Files
Library    RPA.Tables
Library    RPA.Robocorp.WorkItems
Library    RPA.Desktop
Library    RPA.Robocorp.Process
Library    RPA.RobotLogListener
Library    RPA.Excel.Application
Library    RPA.PDF
Library    Collections
Library    RPA.Archive

*** Tasks ***
open available website
    Open available Browser    https://robotsparebinindustries.com/#/robot-order    maximized=${True}
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=${True}
    ${sales}=    Read table from CSV    orders.csv    header=True
    FOR    ${sales}    IN    @{sales}
    Run Keyword And Ignore Error  Click Button    OK
    Select From List By Value    head   ${sales}[Head]
    Select Radio Button    body    ${sales}[Body]
    Input Text   class=form-control    ${sales}[Legs]
    Input Text   id=address    ${sales}[Address]
    Click button    preview 
    Sleep    1s
    Screenshot      id:robot-preview-image      ${CURDIR}${/}output${/}${sales}[Order number].png
    ${screenshot}=      Set Variable    ${CURDIR}${/}output${/}${sales}[Order number].png
    Click Button    id:order
    Run Keyword And Continue On Failure    Click Button   id:order
    Sleep    5s
    Click element if Visible    id:order
    ${Receipt_in_html}=     Get Element Attribute       id:receipt      outerHTML
    Html To Pdf     ${Receipt_in_html}      ${CURDIR}${/}pdf${/}${sales}[Order number].pdf
    ${pdf}=     Set Variable    ${CURDIR}${/}pdf${/}${sales}[Order number].pdf
    Open Pdf    ${pdf}
    Add Watermark Image To Pdf   ${screenshot}    ${pdf} 
    Close Pdf    ${pdf}  
    sleep  2s
    Run Keyword And Ignore Error   Click Element If Visible   order-another
    END
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip  ${CURDIR}${/}pdf    ${zip_file_name}