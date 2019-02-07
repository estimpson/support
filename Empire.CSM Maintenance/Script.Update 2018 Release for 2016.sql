select
	acn.Release_ID
  ,	acn.Version
  ,	acn.[Mnemonic-Vehicle/Plant]
  ,	acn.[Jan 2016]
  ,	acn.[Feb 2016]
  ,	acn.[Mar 2016]
  ,	acn.[Apr 2016]
  ,	acn.[May 2016]
  ,	acn.[Jun 2016]
  ,	acn.[Jul 2016]
  ,	acn.[Aug 2016]
  ,	acn.[Sep 2016]
  ,	acn.[Oct 2016]
  ,	acn.[Nov 2016]
  ,	acn.[Dec 2016]
  ,	acn.[Q1 2016]
  ,	acn.[Q2 2016]
  ,	acn.[Q3 2016]
  ,	acn.[Q4 2016]
  ,	acn.[CY 2016]
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.Release_ID = '2017-12'
	and acn.Version = 'CSM'

begin transaction

update
	acn2018
set	[Jan 2016] = acn2017.[Jan 2016]
  ,	[Feb 2016] = acn2017.[Feb 2016]
  ,	[Mar 2016] = acn2017.[Mar 2016]
  ,	[Apr 2016] = acn2017.[Apr 2016]
  ,	[May 2016] = acn2017.[May 2016]
  ,	[Jun 2016] = acn2017.[Jun 2016]
  ,	[Jul 2016] = acn2017.[Jul 2016]
  ,	[Aug 2016] = acn2017.[Aug 2016]
  ,	[Sep 2016] = acn2017.[Sep 2016]
  ,	[Oct 2016] = acn2017.[Oct 2016]
  ,	[Nov 2016] = acn2017.[Nov 2016]
  ,	[Dec 2016] = acn2017.[Dec 2016]
  ,	[Q1 2016]  = acn2017.[Q1 2016]
  ,	[Q2 2016]  = acn2017.[Q2 2016]
  ,	[Q3 2016]  = acn2017.[Q3 2016]
  ,	[Q4 2016]  = acn2017.[Q4 2016]
  ,	[CY 2016]  = acn2017.[CY 2016]
from
	EEIUser.acctg_csm_NAIHS acn2018
	join EEIUser.acctg_csm_NAIHS acn2017
		on acn2017.Release_ID = '2017-12'
			and acn2017.Version = 'CSM'
			and acn2017.[Mnemonic-Vehicle/Plant] = acn2018.[Mnemonic-Vehicle/Plant]
where
	acn2018.Release_ID like '2018-%%'
	and acn2018.Version = 'CSM'

commit

select
	*
from
	EEIUser.[acctg_csm_NAIHS bring in 2016] acn2018
where
	acn2018.Release_ID like '2018-%%'
	and acn2018.Version = 'CSM'
