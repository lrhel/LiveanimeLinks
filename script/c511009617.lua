--Helixx Necro Darwin
--fixed by MLD
function c511009617.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x573),2,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511009617.atcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23571046,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c511009617.sptg)
	e2:SetOperation(c511009617.spop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.damcon1)
	e3:SetOperation(c511009617.ctop)
	c:RegisterEffect(e3)
end
function c511009617.atcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c511009617.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and zone~=0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009617.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=Duel.GetLinkedZone(tp)
	if zone>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c511009617.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c511009617.damval)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c511009617.damval(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or r&REASON_EFFECT==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0 end
	return val
end
