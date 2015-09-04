Feature: Leagues have Players

  Scenario: You can see and filter a league's players
    Given the BadCeleb League seeds have been run
    When I go to that league's players page
    And I filter the table by "snooki"
    Then I should only see the "Snooki" player

  Scenario: Defaults to the best players
    Given the BadCeleb League seeds have been run
    And one team has a bunch of points
    When I go to that league's players page
    Then I should see the best player first
