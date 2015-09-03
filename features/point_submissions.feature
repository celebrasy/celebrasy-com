Feature: Points can be scored

  Scenario: You can submit points
    Given the BadCeleb League seeds have been run
    When I go to a team
    And I submit points for a player
    Then I should see the points for that player
