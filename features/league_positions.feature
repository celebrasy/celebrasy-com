Feature: Leagues have Positions

  Scenario: You can see a league's positions
    Given there is a BadCeleb League
    And that league has the default positions
    When I go to that league's positions page
    Then I should see the BadCeleb positions
