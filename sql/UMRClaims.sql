create view [SB_Akhila].[dbo].[UMRClaimsMem] as

SELECT c.Id, c.ClaimControlNumber, c.AccountId, c.MemberId, c.ProviderId, c.StartDateId, c.EndDateId, c.PaidDateId, c.BillTypeCode, c.ProcedureCode, c.ProcedureCodeModifier, c.HospitalBillType, c.RevenueCode, c.Diagnosis1, c.Diagnosis1Qualifier, c.Diagnosis2, c.Diagnosis2Qualifier, 
             c.Diagnosis3, c.Diagnosis3Qualifier, c.HospitalBilledProcedureCode1, c.HospitalBilledProcedureCode2, c.HospitalBilledProcedureCode3, c.HospitalBilledProcedureCode4, c.HospitalAdmitDate, c.HospitalDischargeDate, c.AdmissionSourceCode, c.PlaceOfServiceCode, 
             pos.Category AS POSCategory, pos.Description AS POSDesc, umrpos.Description AS UMRPOSDesc, c.CMSPlaceOfServiceCode, c.EmergencyIndicator, c.TypeOfService, tos.Category AS TypeOfServiceCategory, tos.Description AS TypeOfServiceDesc, 
             c.OccurencesNumberOfProcedures, c.DischargeStatusCode, c.NationalDrugCode, c.DRGCode, c.AdjustmentCode, ad.Description AS AdjustmentCodeDesc, c.ReversalCode, rt.Description AS ReversalCodeDesc, c.PayeeCode, p.Description AS PayeeDesc, c.ReleaseCode, 
             c.AFVIndicator, afv.Description AS AFVDescription, c.TypeOfDisabilityCode, tod.Description AS TypeofDisbilityDesc, c.ManagedCareTier, c.NetworkProviderIndicator, c.NetworkBenefitIndicator, c.OtherInsuranceTypeCode, c.AlternateBenefitCalculation, c.BilledAmount, 
             c.AllowedAmount, c.PaymentAmount, c.DeductibleAmount, c.CopayAmount, c.CoinsuranceAmount, c.OtherInsuranceCOBAmount, c.AmountPaidbyOtherInsurance, c.HRAPaymentAmount, c.HRADeductibleAmount, c.CustomerReportingField1, c.SrcCreateDate, c.IsCurrent, 
             c.IsDeleted, a.BenefitPlan, a.ClassCode, a.GroupName, a.GroupNumber, a.IsCurrent AS CurrentAccount, a.IsDeleted AS DeletedAccount, a.LocationCode, a.MemberNetwork, a.PolicyNumber, a.ProviderNetwork, m.EmployeeIdentifier, m.DependentStatus, 
             ds.Description AS DependentStatusDesc, m.CoverageTier, ct.Description AS CoverageTierDesc, m.IsMedicarePrime, m.LineOfCoverage, lc.Description AS LineofCoverageDesc, m.MaritalStatus, ms.Description AS MaritalStatusDesc, m.WorkStatusCode, 
             ws.Description AS WorkStatusDesc, m.CoverageEffectiveDate, m.CoverageTerminationDate, dq1.Description AS Diagnosis1QualDesc, dq2.Description AS Diagnosis2QualDesc, dq3.Description AS Diagnosis3QualDesc, pq1.Description AS ProcCodeModifierDesc, 
             pr.ServicingProviderName, pr.ServicingProviderState, pr.ServicingProviderZipcode, pr.TypeofProvider, pr.ServicingProviderSpecialtyCode, pr.ProviderDesignation, pr.InternalProviderNumber, pr.BillingProviderNPI, pr.BillingFacilityName, pr.BillingAddress, pr.BillingAddress2, 
             pr.BillingCityName, pr.BillingFacilityState, pr.BillingFacilityZipcode, pr.SrcCreateDate AS ProvSrcDate, pdt.Description AS ProviderDesignationDesc, tp.Description AS TypeOfProviderDesc
FROM   claims.Claim AS c LEFT OUTER JOIN
             claims.Account AS a ON c.AccountId = a.Id LEFT OUTER JOIN
             mbr.Member AS m ON c.MemberId = m.Id LEFT OUTER JOIN
             ref.DiagnosisCodeQualifiers AS dq1 ON c.Diagnosis1Qualifier = dq1.Code LEFT OUTER JOIN
             ref.DiagnosisCodeQualifiers AS dq2 ON c.Diagnosis2Qualifier = dq2.Code LEFT OUTER JOIN
             ref.DiagnosisCodeQualifiers AS dq3 ON c.Diagnosis3Qualifier = dq3.Code LEFT OUTER JOIN
             ref.ProcedureCodeModifiers AS pq1 ON c.ProcedureCodeModifier = pq1.Code LEFT OUTER JOIN
             ref.AccidentFieldValues AS afv ON c.AFVIndicator = afv.Code LEFT OUTER JOIN
             ref.Adjustments AS ad ON c.AdjustmentCode = ad.Code LEFT OUTER JOIN
             ref.CoverageTier AS ct ON m.CoverageTier = ct.Code LEFT OUTER JOIN
             ref.DependentStatus AS ds ON m.DependentStatus = ds.Code LEFT OUTER JOIN
             ref.LineOfCoverage AS lc ON m.LineOfCoverage = lc.Code LEFT OUTER JOIN
             ref.MaritalStatus AS ms ON m.MaritalStatus = ms.Code LEFT OUTER JOIN
             ref.Payee AS p ON c.PayeeCode = p.Code LEFT OUTER JOIN
             ref.PlaceOfService AS pos ON c.PlaceOfServiceCode = pos.Code LEFT OUTER JOIN
             ref.Provider AS pr ON c.ProviderId = pr.Id LEFT OUTER JOIN
             ref.ProviderDesignationTitle AS pdt ON pr.ProviderDesignation = pdt.Code LEFT OUTER JOIN
             ref.ReversalType AS rt ON c.ReversalCode = rt.Code LEFT OUTER JOIN
             ref.TypeOfDisability AS tod ON c.TypeOfDisabilityCode = tod.Code LEFT OUTER JOIN
             ref.TypeOfProvider AS tp ON pr.TypeofProvider = tp.Code LEFT OUTER JOIN
             ref.TypeOfService AS tos ON c.TypeOfService = tos.Id LEFT OUTER JOIN
             ref.UmrPlaceOfService AS umrpos ON c.PlaceOfServiceCode = umrpos.Code LEFT OUTER JOIN
             ref.WorkStatus AS ws ON m.WorkStatusCode = ws.Code;

create view  [SB_Akhila].[dbo].[CUR_MEMBERSHIP]
			 SELECT Id, MemberIdentifier, EmployeeIdentifier, DependentStatus, IdCardType, BenefitPlan, LineOfCoverage, CoverageTier, Gender, BirthYear, City, State, Zip, County, CountyFips, CongressionalDistrict, IsVacant, IsActive, MaritalStatus, WorkSiteCode, CoverageEffectiveDate, 
             CoverageTerminationDate, IsMedicarePrime, MedicarePrimeStart, MedicarePrimeEnd, WorkStatusCode, BlockGroup, SrcCreateDate, IsCurrent, IsDeleted, EtlCreateDate, EtlCreateBy, ETLUpdateDate, ETLUpdateBy, CURRENT_TIMESTAMP AS CurrentDate, DATEDIFF(mm, 
             CoverageEffectiveDate, CURRENT_TIMESTAMP) AS MemberMonths
FROM   mbr.Member;

create view [SB_Akhila].[dbo].[dbo].[AggClaims]
as
SELECT 
COUNT(DISTINCT Id) AS ClaimsCount, AccountId, MemberId, ProviderId, CONVERT(varchar(2), MONTH(PaidDateId)) + '-' + CONVERT(varchar(4), YEAR(PaidDateId)) AS PaidDate, POSCategory, POSDesc, UMRPOSDesc, TypeOfServiceCategory, TypeOfServiceDesc, AFVDescription, 
             TypeofDisbilityDesc, SUM(BilledAmount) AS BilledAmount, BenefitPlan, ClassCode, GroupName, DependentStatusDesc, CoverageTierDesc, LineofCoverageDesc, WorkStatusDesc, TypeofProvider
FROM   dbo.UMRClaimsMem
GROUP BY PaidDateId, AccountId, MemberId, ProviderId, POSCategory, POSDesc, UMRPOSDesc, TypeOfServiceCategory, TypeOfServiceDesc, AFVDescription, TypeofDisbilityDesc, BenefitPlan, ClassCode, GroupName, DependentStatusDesc, CoverageTierDesc, LineofCoverageDesc,
WorkStatusDesc, TypeofProvider;