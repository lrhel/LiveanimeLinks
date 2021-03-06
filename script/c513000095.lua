--黒の魔法神官 (Anime)
--Sorcerer of Dark Magic (Anime)
--updated by Larry126
function c513000095.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c513000095.spcon)
	e2:SetOperation(c513000095.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88619463,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c513000095.discon)
	e3:SetTarget(c513000095.distg)
	e3:SetOperation(c513000095.disop)
	c:RegisterEffect(e3)
	--atk change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77058170,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c513000095.atktg)
	e4:SetOperation(c513000095.atkop)
	c:RegisterEffect(e4)
end
function c513000095.rfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(6)
end
function c513000095.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c513000095.rfilter,2,nil)
end
function c513000095.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c513000095.rfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c513000095.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c513000095.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c513000095.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsFacedown() or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c513000095.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c513000095.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=-Duel.GetMatchingGroupCount(c513000095.filter,tp,LOCATION_GRAVE,0,nil)*500
	if chk==0 then return c:GetFlagEffect(513000095)==0 and atk~=0
		and bc and bc:IsOnField() and bc:IsFaceup() and bc:IsCanBeEffectTarget(e) end
	c:RegisterFlagEffect(513000095,RESET_CHAIN,0,1)
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,bc,1,1-tp,atk)
end
function c513000095.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsFaceup() and bc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-Duel.GetMatchingGroupCount(c513000095.filter,tp,LOCATION_GRAVE,0,nil)*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
	end
end
