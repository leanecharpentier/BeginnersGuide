*** Settings ***
Library             SeleniumLibrary
Library             DateTime
Library             Collections

Test Setup          Ouvrir Orange_HRM
Test Teardown       Fermer Orange_HRM

Test Tags           tnr


*** Variables ***
${ORANGE_HRM_URL}    https://opensource-demo.orangehrmlive.com
${usernameAdmin}    Admin
${passwordAdmin}    admin123
${employee_id}    898989
${employee_firstname}    Jean
${employee_lastname}    Dupont
${employee_middlename}    James
${updated}    Updated


*** Test Cases ***
Test01 - Ajouter un employé
    [Documentation]
    ...   Ajout d'un employé ${\n}
    ...   Cliquer sur le bouton "+ Add" ${\n}
    ...   Remplir le formulaire d'ajout d'employé ${\n}
    ...   Vérifier que l'employé est bien ajouté ${\n}
    Given Aller sur la page Employés
    When Clicker sur le bouton "+ Add"
    And Remplir le formulaire d'ajout d'employé
    Then Vérifier que l'employé est bien ajouté

Test02 - Rechercher un employé
    [Documentation]
    ...   Rechercher un employé ${\n}
    ...   Vérifier que l'employé est bien trouvé ${\n}
    Given Aller sur la page Employés
    When Remplir le formulaire de recherche d'employé
    Then Vérifier que l'employé est bien trouvé

Test03 - Modifier un employé
    [Documentation]
    ...   Modifier un employé ${\n}
    ...   Cliquer sur le bouton de modification de l'employé ${\n}
    ...   Modifier les informations de l'employé ${\n}
    ...   Cliquer sur le bouton Enregistrer ${\n}
    ...   Vérifier que l'employé a été modifié avec succès ${\n}
    Given Aller sur la page Employés
    When Remplir le formulaire de recherche d'employé
    And Cliquer sur le bouton de modification de l'employé
    When Modifier les informations de l'employé
    And Cliquer sur le bouton Enregistrer
    Then Vérifier le message de réussite qui s'affiche    Successfully Updated

Test04 - Supprimer un employé
    [Documentation]
    ...   Supprimer un employé ${\n}
    ...   Cliquer sur le bouton de suppression de l'employé ${\n}
    ...   Vérifier que l'employé a été supprimé avec succès ${\n}
    Given Aller sur la page Employés
    When Remplir le formulaire de recherche d'employé
    And Cliquer sur le bouton de suppression de l'employé
    Then Vérifier le message de réussite qui s'affiche    Successfully Deleted


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
    SeleniumLibrary.Input Text    xpath=//input[@name="username"]    ${usernameAdmin}
    SeleniumLibrary.Input Text    xpath=//input[@name="password"]    ${passwordAdmin}
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

Aller sur la page Employés
    SeleniumLibrary.Click Element   xpath=//a[.//span[text()='PIM']]

Clicker sur le bouton "+ Add"
    SeleniumLibrary.Click Element   xpath=//button[@type='button' and @class='oxd-button oxd-button--medium oxd-button--secondary']

Remplir le formulaire d'ajout d'employé
    SeleniumLibrary.Wait Until Page Contains Element    xpath=//h6[text()='Add Employee']
    SeleniumLibrary.Input Text    xpath=//input[@placeholder='First Name']    ${employee_firstname}
    SeleniumLibrary.Input Text    xpath=//input[@placeholder='Middle Name']    ${employee_middlename}
    SeleniumLibrary.Input Text    xpath=//input[@placeholder='Last Name']    ${employee_lastname}
    ${id_input}    Set Variable    xpath=//label[text()='Employee Id']/parent::div/following-sibling::div/input
    SeleniumLibrary.Click Element    ${id_input}
    SeleniumLibrary.Press Keys    ${id_input}    CTRL+a    DELETE
    SeleniumLibrary.Input Text    ${id_input}    ${employee_id}
    SeleniumLibrary.Click Element    xpath=//button[@type='submit']

Vérifier que l'employé est bien ajouté
    SeleniumLibrary.Wait Until Element Is Visible    xpath=//div[contains(@class, 'oxd-toast--success')]    timeout=10s
    ${message_title}    SeleniumLibrary.Get Text    xpath=//p[contains(@class, 'oxd-text--toast-title')]
    ${message_content}    SeleniumLibrary.Get Text    xpath=//p[contains(@class, 'oxd-text--toast-message')]
    BuiltIn.Should Contain    ${message_title}    Success
    BuiltIn.Should Contain    ${message_content}    Successfully Saved

Remplir le formulaire de recherche d'employé
    SeleniumLibrary.Wait Until Page Contains Element    xpath=//h5[text()='Employee Information']
    ${id_input}    Set Variable    xpath=//label[text()='Employee Id']/parent::div/following-sibling::div/input
    SeleniumLibrary.Clear Element Text    ${id_input}
    SeleniumLibrary.Input Text    ${id_input}    ${employee_id}
    SeleniumLibrary.Click Element    xpath=//button[@type='submit']
    Sleep    2s

Vérifier que l'employé est bien trouvé
    SeleniumLibrary.Wait Until Element Is Visible    xpath=//div[@class='oxd-table-card']    timeout=10s
    ${record_found_text}    SeleniumLibrary.Get Text    xpath=//span[@class='oxd-text oxd-text--span']
    BuiltIn.Should Contain    ${record_found_text}    (1) Record Found
    SeleniumLibrary.Element Text Should Be    xpath=//div[@role='cell' and .//div[text()='${employee_id}']]//div    ${employee_id}
    SeleniumLibrary.Element Text Should Be
    ...    xpath=//div[@class='oxd-table-row oxd-table-row--with-border oxd-table-row--clickable']/div[3]//div
    ...    ${employee_firstname} ${employee_middlename}
    SeleniumLibrary.Element Text Should Be
    ...    xpath=//div[@class='oxd-table-row oxd-table-row--with-border oxd-table-row--clickable']/div[4]//div
    ...    ${employee_lastname}
    
Cliquer sur le bouton de modification de l'employé
    ${text}    Set Variable    Personal Details
    SeleniumLibrary.Click Element    xpath=//button[@class='oxd-icon-button oxd-table-cell-action-space' and .//i[@class='oxd-icon bi-pencil-fill']]
    SeleniumLibrary.Wait Until Element Contains    xpath=//h6[@class='oxd-text oxd-text--h6 orangehrm-main-title']    ${text}

 Modifier les informations de l'employé
    SeleniumLibrary.Click Element    xpath=//input[@name="firstName"]
    SeleniumLibrary.Input Text       xpath=//input[@name="firstName"]    ${updated}

Cliquer sur le bouton Enregistrer
    ${xpath}=    Set Variable    //button[@class='oxd-button oxd-button--medium oxd-button--secondary orangehrm-left-space']
    SeleniumLibrary.Scroll Element Into View    ${xpath}
    SeleniumLibrary.Click Element               ${xpath}


Vérifier le message de réussite qui s'affiche
    [Arguments]    ${message}=${None}
    SeleniumLibrary.Wait Until Element Contains    //p[@class='oxd-text oxd-text--p oxd-text--toast-message oxd-toast-content-text']    ${message}

Cliquer sur le bouton de suppression de l'employé
    SeleniumLibrary.Click Element    xpath=//i[@class="oxd-icon bi-trash"]
    SeleniumLibrary.Click Element    xpath=//button[@class="oxd-button oxd-button--medium oxd-button--label-danger orangehrm-button-margin"]
