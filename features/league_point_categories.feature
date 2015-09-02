Feature: Leagues have Point Categories

  Scenario: You can see a league's point categories
    Given there is a BadCeleb League
    And that league has the default point categories
    When I go to that league's scoring page
    Then I should see the BadCeleb point categories

  Scenario: You can filter a league's point categories
    Given there is a BadCeleb League
    And that league has the default point categories
    When I go to that league's scoring page
    And I filter the table by "Death"
    Then I should only see the "Death" point categories
    And I click on "Standings"
    And Pending I fix the DataTable issues
    And I go back
    And I filter the table by "Death"
    Then I should only see the "Death" point categories
