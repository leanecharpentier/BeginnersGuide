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
${password1}   test123
${employee_name}   James
${role}   Admin
${status}   Enabled


*** Test Cases ***

Test01 Ajouter un utilisateur
    [Documentation]
    ...   Ajout d'un utilisateur ${\n}
    ...   Cliquer sur le bouton "+ Add" dans la section "User Management" ${\n}
    ...   Remplir le formulaire d'ajout d'utilisateur ${\n}
    ...   Vérifier que l'utilisateur est bien ajouté ${\n}
    Given Aller sur la page Admin
    When  Clicker sur le bouton "+ Add"
    And   Remplir le formulaire d'ajout d'utilisateur    ${username1}    ${password1}    ${role}    ${status}   ${employee_name}
    Then  Vérifier que l'utilisateur est bien ajouté    ${username1}

Test02 Rechercher un utilisateur
    [Documentation]
    ...    Rechercher un utilisateur ${\n}
    ...    Remplir le formulaire de rechercher ${\n}
    ...    Cliquer sur le bouton rechercher ${\n}
    ...    Vérifier que l'utilisateur s'affiche ${\n}
    Given Aller sur la page Admin
    When Remplir le formulaire de recherche    ${username1}    ${role}    ${status}
    When Cliquer sur le bouton Search
    Then Vérifier que le message qui s'affiche    (1) Record Found
    Then Vérifier l'utilisateur qui s'affiche

Test03 - Modifier un utilisateur
    [Documentation]
    ...   Modifier un utilisateur ${\n}
    ...   Cliquer sur le bouton de modification de l'utilisateur ${\n}
    ...   Modifier les informations de l'utilisateur ${\n}
    ...   Cliquer sur le bouton Enregistrer ${\n}
    ...   Vérifier que l'utilisateur a été modifié avec succès ${\n}
    Given Aller sur la page admin
    When Remplir le formulaire de recherche    ${username1}    ${role}    ${status}
    When Cliquer sur le bouton Search
    And Cliquer sur le bouton de modification de l'utilisateur
    When Modifier les informations de l'utilisateur
    And Cliquer sur le bouton Enregistrer
    # Then Vérifier que l'utilisateur a été modifié avec succès

Test04 - Supprimer un utilisateur
    [Documentation]
    ...   Supprimer un utilisateur ${\n}
    ...   Cliquer sur le bouton de suppression de l'utilisateur ${\n}
    ...   Vérifier que l'utilisateur a été supprimé avec succès ${\n}
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

Cliquer sur le bouton de modification de l'utilisateur
    ${text}    Set Variable    Edit User
    Click Element    xpath=(//button[@class='oxd-icon-button oxd-table-cell-action-space' and .//i[contains(@class, 'bi-pencil-fill')]])[1]

    Wait Until Element Contains    xpath=//h6[@class='oxd-text oxd-text--h6 orangehrm-main-title']    ${text}

Modifier les informations de l'utilisateur
    ${username}    Set Variable    ff  
    Input Text    xpath=//label[text()='Username']/ancestor::div[contains(@class, 'oxd-input-group')]//input    ${username}    clear=True

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
