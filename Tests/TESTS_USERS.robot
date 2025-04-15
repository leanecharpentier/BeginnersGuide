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
${username1}   James
${password1}   laplusbelle49
${employee_name}   Anisse Desvallois hi
${role}   Admin
${status}   Enabled
${newUsername}    JamesB


*** Test Cases ***

Test01 Ajouter un utilisateur
    [Documentation]
    ...   Ajout d'un utilisateur ${\n}
    ...   Cliquer sur le bouton "+ Add" dans la section "User Management" ${\n}
    ...   Remplir le formulaire d'ajout d'utilisateur ${\n}
    ...   Vérifier que l'utilisateur est bien ajouté ${\n}
    Given Aller sur la page Admin
    When Clicker sur le bouton "+ Add"
    And Remplir le formulaire d'ajout d'utilisateur    ${username1}    ${password1}    ${role}    ${status}   ${employee_name}
    Then Vérifier que l'utilisateur est bien ajouté    ${username1}

Test02 Rechercher un utilisateur
    [Documentation]    ...    ${\n}Rechercher un utilisateur
    ...    Remplir le formulaire de rechercher
    ...    Cliquer sur le bouton rechercher
    ...    Vérifier que
    # Naviguer vers
    Given Aller sur la page Admin
    When Remplir le formulaire de recherche    ${username1}    ${role}    ${status}
    When Cliquer sur le bouton Search
    Then Vérifier que le message qui s'affiche    (1) Record Found
    Then Vérifier l'utilisateur qui s'affiche

Test03 - Modifier un utilisateur
    Given Aller sur la page admin
    When Remplir le formulaire de recherche    ${username1}    ${role}    ${status}
    And Cliquer sur le bouton Search
    And Cliquer sur le bouton de modification de l'utilisateur
    When Modifier les informations de l'utilisateur    ${newUsername}
    And Cliquer sur le bouton Enregistrer
    Then Vérifier que l'utilisateur a été modifié avec succès    Successfully Updated

Test04 - Supprimer un utilisateur
    Given Aller sur la page admin
    When Remplir le formulaire de recherche    ${username1}    ${role}    ${status}
    When Cliquer sur le bouton Search
    And Cliquer sur le bouton de suppression de l'utilisateur

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

Aller sur la page Admin
    SeleniumLibrary.Click Element   xpath=//a[.//span[text()='Admin']]

Vérifier que l'utilisateur a été modifié avec succès
    [Arguments]    ${message}=${None}
    SeleniumLibrary.Wait Until Element Contains    //p[@class='oxd-text oxd-text--p oxd-test--toast-message oxd-toast-content-text']    ${message}

Cliquer sur le bouton de modification de l'utilisateur
    ${text}    Set Variable    Edit User
    Click Element    xpath=(//button[@class='oxd-icon-button oxd-table-cell-action-space' and .//i[contains(@class, 'bi-pencil-fill')]])[1]

    Wait Until Element Contains    xpath=//h6[@class='oxd-text oxd-text--h6 orangehrm-main-title']    ${text}

Modifier les informations de l'utilisateur
    [Arguments]    ${newUsername}
    Input Text    xpath=//label[text()='Username']/ancestor::div[contains(@class, 'oxd-input-group')]//input    ${newUsername}    clear=True

Cliquer sur le bouton Enregistrer
    Scroll Element Into View         xpath=//button[@type='submit']
    Click Element    xpath=//button[@type='submit']

Cliquer sur le bouton de suppression de l'utilisateur
    SeleniumLibrary.Click Element    xpath=//i[@class="oxd-icon bi-trash"]
    SeleniumLibrary.Click Element    xpath=//button[@class="oxd-button oxd-button--medium oxd-button--label-danger orangehrm-button-margin"]

Clicker sur le bouton "+ Add"
    SeleniumLibrary.Click Element   xpath=//button[@type='button' and @class='oxd-button oxd-button--medium oxd-button--secondary']

Remplir le formulaire d'ajout d'utilisateur
    [Arguments]    ${username1}    ${password1}    ${role}    ${status}    ${employee_name}
    # Sélectionner "User Role"
    SeleniumLibrary.Click Element    xpath=//label[text()='User Role']/following::div[contains(@class, 'oxd-select-text')]
    SeleniumLibrary.Wait Until Element Is Visible    xpath=//div[@role='option' and contains(normalize-space(), '${role}')]    timeout=10s
    SeleniumLibrary.Click Element    xpath=//div[@role='option' and contains(normalize-space(), '${role}')]


    # Saisir "Employee Name"
    SeleniumLibrary.Input Text    xpath=//label[text()='Employee Name']/following::input[1]    ${employee_name}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=//div[@role='option' and contains(normalize-space(), '${employee_name}')]    timeout=10s
    SeleniumLibrary.Click Element    xpath=//div[@role='option' and contains(normalize-space(), '${employee_name}')]

    # Sélectionner "Status"
    SeleniumLibrary.Click Element    xpath=//label[text()='Status']/following::div[contains(@class, 'oxd-select-text')]
    SeleniumLibrary.Wait Until Element Is Visible    xpath=//div[@role='option' and contains(normalize-space(), 'Enabled')]    timeout=10s
    SeleniumLibrary.Click Element    xpath=//div[@role='option' and contains(normalize-space(), 'Enabled')]

    # Saisir "Username"
    SeleniumLibrary.Input Text    xpath=//label[text()='Username']/following::input[1]    ${username1}

    # Saisir "Password" et "Confirm Password"
    SeleniumLibrary.Input Text    xpath=//label[text()='Password']/following::input[1]    ${password1}
    SeleniumLibrary.Input Text    xpath=//label[text()='Confirm Password']/following::input[1]    ${password1}

    # Cliquer sur "Save"
    SeleniumLibrary.Click Element    xpath=//button[@type='submit' and text()=' Save ']

Vérifier que l'utilisateur est bien ajouté
    [Arguments]    ${username1}
    SeleniumLibrary.Wait Until Page Contains Element    xpath=//div[contains(text(), '${username1}')]    timeout=10s
    SeleniumLibrary.Page Should Contain Element    xpath=//div[contains(text(), '${username1}')]

Remplir le formulaire de recherche
    [Arguments]    ${username}=${None}    ${role}=${None}    ${status}=${None}
    # Remplir le champ username
    SeleniumLibrary.Input Text    xpath=//label[text()='Username']/ancestor::div[contains(@class, 'oxd-input-group')]//input    ${username}
    # Ouvrir le select et cliquer sur le champ ${status}
    SeleniumLibrary.Click Element    xpath=//label[text()='User Role']/ancestor::div[contains(@class, 'oxd-input-group')]//div[contains(@class, 'oxd-select-text')]
    SeleniumLibrary.Click Element    xpath=//div[@role='option']//span[text()='${role}']
    # Ouvrir le select et cliquer sur le champ ${status}
    SeleniumLibrary.Click Element    xpath=//label[text()='Status']/ancestor::div[contains(@class, 'oxd-input-group')]//div[contains(@class, 'oxd-select-text')]
    SeleniumLibrary.Click Element    xpath=//div[@role='listbox']//span[text()='${status}']

Cliquer sur le bouton Search
    SeleniumLibrary.Click Element    xpath=//button[@type='submit']

Vérifier que le message qui s'affiche
    [Arguments]    ${message}=${None}
    SeleniumLibrary.Wait Until Element Contains    //span[@class='oxd-text oxd-text--span']    ${message}

Vérifier l'utilisateur qui s'affiche
    ${row} =    Get WebElement    xpath=//div[@role='row' and .//div[text()='jonas Paula']]
    SeleniumLibrary.Element Should Contain    xpath=.//div[1]    Admin    parent=${row}
    SeleniumLibrary.Element Should Contain    xpath=.//div[2]    Admin    parent=${row}
    SeleniumLibrary.Element Should Contain    xpath=.//div[3]    jonas Paula    parent=${row}
    SeleniumLibrary.Element Should Contain    xpath=.//div[4]    Enabled    parent=${row}


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
