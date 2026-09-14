-- CRAFT SKILLS OF THE PROFESSIONS WITHOUT GATHERING
-- Skill ids and names from the client lang (skills_fr.swf). The Java side (Player.useCraftSkill) checks that the
-- player has the job and its tool equipped, and takes the number of ingredient slots from the job tables
-- (JobConstant.getPosActionsToJob), where every skill below is defined.
-- Gathering professions register their own crafts in job_alchemist/farmer/fisher/lumberjack/miner.lua,
-- smithmagic workshops in job_smithmag.lua.

local crafts = {
    [JewellerJob]      = {11, 12},       -- Créer un Anneau, Créer une Amulette
    [ShoemakerJob]     = {13, 14},       -- Confectionner des Bottes, Confectionner une Ceinture
    [BowCarverJob]     = {15, 149},      -- Sculpter un Arc, Réparer un Arc
    [WandCarverJob]    = {16, 148},      -- Sculpter une Baguette, Réparer une Baguette
    [StaffCarverJob]   = {17, 147},      -- Sculpter un Bâton, Réparer un Bâton
    [DaggerSmithJob]   = {18, 142},      -- Forger une Dague, Réparer une Dague
    [HammerSmithJob]   = {19, 144},      -- Forger un Marteau, Réparer un Marteau
    [SwordSmithJob]    = {20, 145},      -- Forger une Epée, Réparer une Epée
    [ShovelSmithJob]   = {21, 146},      -- Forger une Pelle, Réparer une Pelle
    [AxeSmithJob]      = {65, 143},      -- Forger une Hache, Réparer une Hache
    [BakerJob]         = {27, 109},      -- Cuire du pain, Faire des bonbons
    [TailorJob]        = {63, 64, 123},  -- Coudre un Chapeau, Coudre une Cape, Coudre un Sac
    [HunterJob]        = {132},          -- Préparer (viandes du chasseur)
    [ButcherJob]       = {134},          -- Préparer une viande
    [FishmongerJob]    = {135},          -- Préparer un poisson
    [ShieldSmithJob]   = {156},          -- Forger un Bouclier
    [HandymanJob]      = {171, 182},     -- Bricoler, Confectionner une clef
}

for jobID, skills in pairs(crafts) do
    for _, skillID in ipairs(skills) do
        registerCraftSkill(skillID, {jobID = jobID})
    end
end
