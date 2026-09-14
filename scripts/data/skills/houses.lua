-- HOUSE DOORS AND SAFES
-- The client offers each skill according to the house state (owner, locked, for sale); the Java side checks
-- ownership again and handles the dialogs (buy / sell price / door code).

-- Door (interactive object 70): Verrouiller, Entrer, Acheter, Vendre, Déverrouiller, Modifier le prix de vente
for _, skillID in ipairs({81, 84, 97, 98, 100, 108}) do
    SKILLS[skillID] = function(p, cellID)
        p:useHouseDoor(cellID, skillID)
    end
end

-- Safe (interactive object 85): Ouvrir, Verrouiller, Modifier code
for _, skillID in ipairs({104, 105, 106}) do
    SKILLS[skillID] = function(p, cellID)
        p:useSafe(cellID, skillID)
    end
end
