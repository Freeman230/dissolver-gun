local e = FindMetaTable("Entity")

local Dissolve = e.Dissolve
local NextThink = e.NextThink

SWEP.PrintName = "Dissolver Gun"
SWEP.Author = "1999"
SWEP.Instructions = "Press E to switch dissolve types."
SWEP.Purpose = "Dissolve."
SWEP.Category = "1999's Weapons (Admin)"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModelFOV = 54

SWEP.Slot = 2

SWEP.DrawCrosshair = true

SWEP.Weight = 5

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

function SWEP:Initialize()
    self:SetWeaponHoldType("smg")
end

function SWEP:Think()
    if self.Owner:KeyPressed(IN_USE) then
        self:EmitSound("Weapon_AR2.Empty")
    end
    if SERVER then
        if self.Owner:KeyPressed(IN_USE) and self:GetNWInt("Mode") == 1 then
            self:SetNWInt("Mode", 2)
            self.Owner:PrintMessage(HUD_PRINTCENTER, "Heavy Electrical")
        else
            if self.Owner:KeyPressed(IN_USE) and self:GetNWInt("Mode") == 2 then
                self:SetNWInt("Mode", 3)
                self.Owner:PrintMessage(HUD_PRINTCENTER, "Light Electrical")
            else
                if self.Owner:KeyPressed(IN_USE) and self:GetNWInt("Mode") == 3 then
                    self:SetNWInt("Mode", 4)
                    self.Owner:PrintMessage(HUD_PRINTCENTER, "Quick Dissolve")
                else
                    if self.Owner:KeyPressed(IN_USE) and self:GetNWInt("Mode") == 4 then
                        self:SetNWInt("Mode", 1)
                        self.Owner:PrintMessage(HUD_PRINTCENTER, "Default Dissolve")
                    else
                        if self:GetNWInt("Mode") < 1 or self:GetNWInt("Mode") > 4 then
                            self:SetNWInt("Mode", 1)
                        end
                    end
                end
            end
        end
    end
end

function SWEP:PrimaryAttack()
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Weapon:EmitSound(Sound("ambient/energy/zap" .. math.random(1, 3) .. ".wav"))
    self:SetNextPrimaryFire(CurTime() + 0.1)

    if self:GetNWInt("Mode") == 1 then
	local hitpos = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)
        for k, v in pairs(hitpos) do
            if v ~= self.Owner then
                if v:GetClass() ~= "predicted_viewmodel" and not (v:IsWeapon() and v:GetOwner() == self.Owner) and v:GetClass() ~= "gmod_hands" then
                    Dissolve(v)
                    NextThink(v, CurTime() + 3.25)
                end
            end
        end
    else
        if self:GetNWInt("Mode") == 2 then
        local hitpos = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)
            for k, v in pairs(hitpos) do
                if v ~= self.Owner then
                    if v:GetClass() ~= "predicted_viewmodel" and not (v:IsWeapon() and v:GetOwner() == self.Owner) and v:GetClass() ~= "gmod_hands" then
                        Dissolve(v, 1)
                        NextThink(v, CurTime() + 3.25)
                    end
                end
            end
        else
            if self:GetNWInt("Mode") == 3 then
			local hitpos = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)
                for k, v in pairs(hitpos) do
                    if v ~= self.Owner then
                        if v:GetClass() ~= "predicted_viewmodel" and not (v:IsWeapon() and v:GetOwner() == self.Owner) and v:GetClass() ~= "gmod_hands" then
                            Dissolve(v, 2)
                            NextThink(v, CurTime() + 3.25)
                        end
                    end
                end
            else
                if self:GetNWInt("Mode") == 4 then
				local hitpos = ents.FindAlongRay(self.Owner:GetShootPos() + self.Owner:GetAimVector(), self.Owner:GetEyeTrace().HitPos)
                    for k, v in pairs(hitpos) do
                        if v ~= self.Owner then
                            if v:GetClass() ~= "predicted_viewmodel" and not (v:IsWeapon() and v:GetOwner() == self.Owner) and v:GetClass() ~= "gmod_hands" then
                                Dissolve(v, 3)
                                NextThink(v, CurTime() + 3.25)
                            end
                        end
                    end
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
end