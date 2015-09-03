Feature: Leagues have Positions

  Scenario: You can see a league's positions
    Given the BadCeleb League seeds have been run
    When I go to that league's positions page
    Then I should see the BadCeleb positions
