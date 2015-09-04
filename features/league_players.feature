Feature: Leagues have Players

  Scenario: You can see and filter a league's players
    Given the BadCeleb League seeds have been run
    When I go to that league's players page
    And I filter the table by "snooki"
    Then I should only see the "Snooki" player
