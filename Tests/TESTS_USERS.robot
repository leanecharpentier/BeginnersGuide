*** Settings ***
Library             SeleniumLibrary
Library             DateTime
Library             Collections

Test Setup          Ouvrir Orange_HRM
Test Teardown       Fermer Orange_HRM

Test Tags           tnr


*** Variables ***
${ORANGE_HRM_URL}    https://opensource-demo.orangehrmlive.com
${username}    Admin
${password}    admin123


*** Test Cases ***

*** Keywords ***
Ouvrir Orange_HRM
    [Documentation]
    ...    Ouverture de Chrome à l'adresse ${ORANGE_HRM_URL}
    ...    Connexion à la plateforme OrangeHRM avec les identifiants Admin/admin123

    # ETAPE DE LANCEMENT DE L APPLICATION
    SeleniumLibrary.Open Browser    ${ORANGE_HRM_URL}
    ...    browser=chrome
    ...    options=add_experimental_option('excludeSwitches', ['enable-logging'])
    SeleniumLibrary.Maximize Browser Window
    SeleniumLibrary.Set Selenium Implicit Wait    5s
    SeleniumLibrary.Input Text    xpath=//input[@name="username"]    ${username}
    SeleniumLibrary.Input Text    xpath=//input[@name="password"]    ${password}
    SeleniumLibrary.Click Element    xpath=//button[@type="submit"]

    # Vérifier que le titre contient "OrangeHRM"
    ${title}    SeleniumLibrary.Get Title
    BuiltIn.Should Contain    ${title}    OrangeHRM

Fermer Orange_HRM
    [Documentation]
    ...    Fermeture du navigateur
    ...    On laisse un peu de temps pour visualiser l'écran final
    BuiltIn.Sleep    3
    # Capture Page Screenshot
    SeleniumLibrary.Close Browser

Scroll Element To Top
    [Documentation]    Permet de placer l'élément en haut de page avec delta
    ...    Par defaut le delta=0
    ...    Le delta peut être la hauteur d'un bandeau
    [Arguments]    ${locator}    ${delta_top}=0
    SeleniumLibrary.Wait Until Page Contains Element    ${locator}
    ${el_pos_y}    SeleniumLibrary.Get Vertical Position    ${locator}
    ${final_y}    BuiltIn.Evaluate    int(${el_pos_y}) -int(${delta_top})
    SeleniumLibrary.Execute Javascript    window.scrollTo(0, arguments[0])    ARGUMENTS    ${final_y}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}

Highlight Element
    [Arguments]    ${locator}
    # Change le style de couleur de l'élément pour le mettre en évidence (le bord en rouge et le fond en jaune)
    # Le style est repositionné par défault
    ${element}    SeleniumLibrary.Get WebElement    ${locator}
    ${original_style}    SeleniumLibrary.Execute Javascript
    ...    element = arguments[0];
    ...    original_style = element.getAttribute('style');
    ...    element.setAttribute('style', original_style + "; color: red; background: yellow; border: 2px solid red;");
    ...    return original_style;
    ...    ARGUMENTS
    ...    ${element}
    BuiltIn.Sleep    0.1s
    ${element}    SeleniumLibrary.Get WebElement    ${locator}
    SeleniumLibrary.Execute Javascript
    ...    element = arguments[0];
    ...    original_style = arguments[1];
    ...    element.setAttribute('style', original_style);
    ...    ARGUMENTS
    ...    ${element}
    ...    ${original_style}


Wait Until Element Attribute Contains
    [Arguments]    ${locator}    ${attribute_name}    ${attribute_expected_value}    ${nb_loop_in_second}=2
    ${initial_implicit_wait}    Set Selenium Implicit Wait    0
    FOR    ${counter}    IN RANGE    ${nb_loop_in_second}
        ${find_element}    Run Keyword And Return Status    SeleniumLibrary.Page Should Contain Element    ${locator}
        IF    ${find_element}
            ${attribute_actual_value}    SeleniumLibrary.Get Element Attribute    ${locator}    ${attribute_name}
            ${comparaison}    Run Keyword And Return Status
            ...    Should Contain
            ...    ${attribute_actual_value}
            ...    ${attribute_expected_value}
            IF    ${comparaison}    BREAK
        END
        Sleep    1s
    END
    Set Selenium Implicit Wait    ${initial_implicit_wait}
    IF    ${find_element} == ${false}    Fail    locator ${locator} not found
    IF    ${comparaison} == ${false}
        ${outerHTML}    SeleniumLibrary.Get Element Attribute    ${locator}    outerHTML
        ${message}    Catenate    locator ${locator} found but the value of attribute ${attribute_name} is different
        ...    \nExpected=${attribute_expected_value} != Actual=${attribute_actual_value}
        ...    \n${outerHTML}
        Fail    ${message}
    END
