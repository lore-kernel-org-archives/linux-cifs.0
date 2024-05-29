Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2112.outbound.protection.outlook.com [40.107.236.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023F126AD3
	for <linux-cifs@vger.kernel.org>; Wed, 29 May 2024 20:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717013682; cv=fail; b=IJ5ACQqXxzitlXzZ37SXZiXMp1pGRvT+f3vqNfDxR4a1tHau+yMfq3BCUZbT7Ldh4TenHmMWTDfpXBZmr0bvxUPEvtJjbph5POENeKu/2HhFQ1/pZfHWGMrhhmFCIuOf9ckjpZj1DjE7bWEcXvNwAdVBPGK+NHKkiMceyk8YuGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717013682; c=relaxed/simple;
	bh=rWkLshQ2sV/GBHzMd/whALrNsEhyP2QU4qngg4j3SHY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=poYeBCIuSSo/jxh7/wNBskS52CYXWmDewR2/VNI8J3WfzRXEIpoB480P0v+k17dekJcmZGxih+stlgG8ggfP4HTYlgO+74xnNLLB0TzwxgRqovoqAtpLEWlKlgOitfZoTLW8N52iWjmJy187MWAPZn5hfOzDxShd6CdJeMhRxXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.236.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GivRCi8gRqnoAJhmZB0zEMHNkkvPYpm9vLlhEeQ7EgLU7ukX5lDEKzc0tM1iLGMNtQ6c7moi94Cl6WVpe6sXXAu+UswWfZez546+cPqfyfCS/57gcqMMa1wBwxZ4PWnQXAP4ZxgzvTsbEBPdsGJIy9ZwvWWYqIXVTfgMfT0K1/GGi5mymp9jnJhwc+gRoReKsnfxEF2L7/ScQZaGnaUYcG6YHjW7c8Ru82FCsr4Mq31vk4BjBFTWZK87bTBFr6NUCej/kqBBgDC9ZkAbk2vIyziQCIxcQrE0xR/styrK0EF2W8S+saTCiOwHTQxvMk2e0d1kgSpa3wXKYcF2XQ3IFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AP0slLHsXy/IttLYkdVWuHGv7fGyNW6yOQWu0c6yQGM=;
 b=LVc+rKRAUtEAwCVH5/h5r7ytRJFiEt5woA7PekbGQLvSOqAPW/8ZXuKmgOveDdip8FRnP7M+xKzzitl+U2doFskcq1cCiDed+NBtLqor5tUieC/UGJVOSHzl0iD0MoawizWGrCMcK4+kPJbU5zkHDoqdtXH+2+uU54MlwtDEl0zlkH1J+l2MHZctNGcl4KprzzZutZCSMHES0llb5z+z7y55FZBe+RMWPdYvHl/fiwoQi0eU3J+PBk2MRxXopAAXQDGkPzTA/TUK58FUz97ayGPVQUfnnh3cchneUkqRmhCk1eXOI9GmC7NANOhcz7/mfxZ5cK4Trlqd8ERcjJGiAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 LV2PR01MB7549.prod.exchangelabs.com (2603:10b6:408:17f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.21; Wed, 29 May 2024 20:14:33 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7633.017; Wed, 29 May 2024
 20:14:33 +0000
Message-ID: <d0e23b72-40db-4149-8c9b-877c2e953a2d@talpey.com>
Date: Wed, 29 May 2024 16:14:31 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: smb: common: add missing MODULE_DESCRIPTION() macros
To: Steve French <smfrench@gmail.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>,
 CIFS <linux-cifs@vger.kernel.org>
References: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
 <CAH2r5msb7G8Gh6mMXiMpS3ykC73WdTwRo9Zj662JaxU5Xq2H0A@mail.gmail.com>
 <bcfeb77e-e986-4be8-87a0-65051bf98c29@talpey.com>
 <CAH2r5mvcM4_86_+Zf0a2XECztP6fS0nb=avGZeQgMjH8iXOF4g@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvcM4_86_+Zf0a2XECztP6fS0nb=avGZeQgMjH8iXOF4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:236::17) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|LV2PR01MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: f426fd61-a9bc-4eb9-6c98-08dc801bf43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2RFbFFGRThzbU1QOHlUTnBRaDUxU1ovL2VjbERISklrcW1aV3FmRWxJemc3?=
 =?utf-8?B?YkNyK0prdUZnRk5abU5PK0g5RnZQMzB5SXVhOVFOcUhjenNyUnhjb2ZMRW5x?=
 =?utf-8?B?aVVPaFNGRk1pRTFySFRDZzVpL1BEblIxbEJxcTdrWHJ6V1ZWWnBJd29xQzdY?=
 =?utf-8?B?SjV6UDFGY3BpNzBGK2J4c3BqbWRVeXYvb05BUFc1OCtEcFc4YkQzbWRpM0tk?=
 =?utf-8?B?bEgxQkhiZUhiZmJRWVFmbGQ1WWRDVzVvRGF0QklueDJIWU1sbG0wdTc1MHNy?=
 =?utf-8?B?UlJHbEo1VkxHZEtNTFhmMk5hSVo3SERFV3NOUzYxSmthMVhNWm1zaTl5cXQy?=
 =?utf-8?B?U3Q5eE1WQkRLRks2YmdlOW0vVjFJa2xreFoyYUhVRjJ5UzNpcWt1dDFReEE2?=
 =?utf-8?B?MUxaaFZueVBaTHh2bG9sbTlud0hpa2lPd1F3dFI2cUdmS1hMVDJVSE80ZEsx?=
 =?utf-8?B?bUtPeDFFcmswWldJVGdnSjhFUzBHQXNxZHVneEozTUQvRS9MN0JNT3BjRzVS?=
 =?utf-8?B?RmlmYUMrV2Rac1puQUR2bThsZURkdGtjdU5UbGRLTVdjZ2hadVZLVFlpZEla?=
 =?utf-8?B?YWgyWWw4Z01yYnBrK1F6MjFUNTYxK2M5N2dLd3EvQkZhK2JJY0dKMmN6VE5N?=
 =?utf-8?B?UmRTTVRtbE1LZE9kVUpYWGlnVkI3dXVhbGRaTTE1a1g2NFZRRDRaU3dzYjdQ?=
 =?utf-8?B?WW9yNGFNTUdUT3Y0UnRvbEhSUktTTi9NTHZ2YnFwNlVsNDlib2dPR0l0YVFw?=
 =?utf-8?B?N240bW5RSGxTcWczRW5TVkhZTDNGVlRTUVJYUGFaREhZK0ZUQlJrWEplTk5z?=
 =?utf-8?B?NnhmUnBSWlFvdHlSZ0xZMlYzd0tpV1dIeWNHWjE1MHZrblFzMlErNkdULzFM?=
 =?utf-8?B?MVFTLzNHUnpRZDVaakJaTXlZL05JY25ScG03M3RQUFN2eFQ5cHFtbEFReFBw?=
 =?utf-8?B?b05DTFA2QkJFZzJnRTAwZUlRamVhaE84aG5IYTJjSzlSVjd5cER0SEVYNjQz?=
 =?utf-8?B?ZzRkU3VsK1V5MkNFU0hHcWxnN3FIVWZxU1hOQUpGcVBGWFljMEZPTDdyK0Zx?=
 =?utf-8?B?UzIxd0VwbU5hcEl1S1lLVUx3Z2pqU2NRN2VBYzloU0U1VEtoblp5TitJOTRk?=
 =?utf-8?B?ay8xZkNRY001UWFOOVh0NnpiMGVMa3hCT0plK3E3NDNFcWI0bG8zRk5xQ01a?=
 =?utf-8?B?ZVpLbFQ5cDEydjNNRlQyR05XZDdJcjF3U04xSHpWWG05WjQwY3VOb0hrYlZw?=
 =?utf-8?B?T1E1THFhRnNlWTk0Rk9WVldscExKN0V2eCtha3ljTDNCYjhmNCtFRnhsT1V5?=
 =?utf-8?B?bTltc0dPT2dSUUx4UmNmTGtrOUlZMisyb2k2Z0E0NysyTS9VWkMvbm1hVFM5?=
 =?utf-8?B?UEJmTFRSZ0xoN1l2VEN2cGcvMFQvK0ZEM1FTRTJvUWt4bTBDY1ovN2c5dUxL?=
 =?utf-8?B?aTd0d3pmZkR1SHVPOThSTWl6dUtTaWE3YUR5TEJVdDN2cVU5T3Y0OEpPMXdO?=
 =?utf-8?B?cXJnVEFvZHZ0c1dsQVJLalFSdHpPeHA1NXdLMEVKL0hpNG0ybGt2U2hCUWFx?=
 =?utf-8?B?UFBhVFdWQm9xaWovTXVxZGpLY0ZWZW9NWmsrcEltUzFDdy9RUGd6L1dtb0V0?=
 =?utf-8?B?eVNtSmJHc29QSC92ek9aMllkOEFsc20wUnoveFpDSUE4SzN1OHpZMzBjS3ZI?=
 =?utf-8?B?Z2p2K0V4K01qMGlNa3dZeXZkRFg2QXI4WWJDcGFobWdPclZZOGIzKzVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnhMaHU0SER6K0NROTU3b0JaVkpIVFYvVHFsb01hV2JGSTJsT21EOE1YNzRP?=
 =?utf-8?B?dm5QTUltNnQyc3Z4R0grZWJjZXpMOXlLc3VQQVB2cnRFZ1FGYng4OFZTM1NB?=
 =?utf-8?B?VzJOcnhzaUJ5Wno3dEZJbERXcTIrT1BmdVdVRzZBNmpVRTl1MzlOOUkvK1dP?=
 =?utf-8?B?WEVPMGN0QzZJcEpmcWRDMWxTY0V0UFBUZlVjVWRtRzQ5OXRYaS8zaStLZm44?=
 =?utf-8?B?RlF2c3EvWG9LZlRtMkpIK2V5b005OVdRc1ZvMFZXaHpTNHJsSGp6Z000YVBj?=
 =?utf-8?B?eFFCdDRGdDMvdm5LVVBuaWgxQUdtREpEcmpvMDd0MWpWL3U4T3RFVldaSEgv?=
 =?utf-8?B?d0RFRmxNUjUxVVBIVEJYN09RSUlsdmpmZytDWTgvQ2QycEptelVpd3NPcGYr?=
 =?utf-8?B?TkZJSDlldFFPaFVWTlc0QjBnT2htUVd4Slo1L2s2b0pJQTNTREhCamcydE9X?=
 =?utf-8?B?dFlZeDEzaGNtUC8xQmFZSE5tWUV1a1FNWmlRbEt0WllpMU1NbURFTWs4c1Nm?=
 =?utf-8?B?ZEFIYkRqa2ZLUDFJNzdEWFptR3U3QmZFTkl4OFdMVHNkbXMzZlNhS1JCcmU5?=
 =?utf-8?B?cW82eTVwV1krUjdCTldIaElRWmMvTTdseUJQaHlpOXRmamVFMzlwdUJsbkpV?=
 =?utf-8?B?cFgyT0xIYUhhYStBdjMvMGRIUmFtRk05cERZeEZKVnRLRElPaWJ3bUtycVZ1?=
 =?utf-8?B?MnMxNjNBTXFLMHEwWmZsSmpYK1JkT2dPS0x4ZXZYMFQxT1ZFUVZacG53L2Z3?=
 =?utf-8?B?c0hnOTRpR201SW41aEtLL1hRRDNNTzY1TTlVNTNBM3EzNjB3ZEJpUjlWV1RJ?=
 =?utf-8?B?ckJ6cy9rWlhhV0lmSUZ4c004MnowVGdyaVhiSE1HNlJmckF4VFdiZkhEUG1D?=
 =?utf-8?B?Q2U5QmVOUXVwdXhOeDJWN1VmRWQ3WTJUNHFFSXhjKzlCSUZPSGE1QkxHTFpw?=
 =?utf-8?B?S0wyK1ppWXlmS0E2MVE3RFBnNzRjVVkyOHUyNzRRaCtFQ1M3dTFvNnpMSVVW?=
 =?utf-8?B?UEswL1RGVTQ1b2pKbjdhNFhQS2JhemkxTEJ6MzNZb3dPcnMrenB3UWFpVjZK?=
 =?utf-8?B?NXNGY0tiK3p3WUVWanJESVIzc3AyR1d2WHEzUGFwM0dSNC9wVWhRd2RQTUt4?=
 =?utf-8?B?M29JRnFQaVhlckNNQWZ5SVpmUGhyUnE4REQweEpKRjlaSmNvcDN0blgyTGpi?=
 =?utf-8?B?UHFrMXIwUzdGMDZIN2F3bG9iY3UyeXVTQVJZMHhpNmNzV1FWNkhmQ0JaRkVZ?=
 =?utf-8?B?cGEzSTkxOGVhdjV1V1Bucjk0aXpySVMyUWNkTVhZTWs5Q2YxdWFGcUxYMnkv?=
 =?utf-8?B?WHA5a1FRS1lVTjZDTERWYW5iVWhGRWV6ekVWdFYxekxIR3ZVN0tvblZudm1l?=
 =?utf-8?B?bTZZcWQ1TFpNZ3pxQ1IzZU9PUUpFUnJhd3Y0bGdjOXBCVEY1OW9hckcwNFFE?=
 =?utf-8?B?UlBlZGozUWFjcFBxSkRxT21waGV1eTQxR2lualNrMDVEYS81QkZRdXdDUmNl?=
 =?utf-8?B?Z0FMZEpiVlAreU54eDhncWo5VmtOdVVJVlNGaFE4ZHV1eUtLcHNFYktiem5r?=
 =?utf-8?B?a2FiRlNwcWlINGVXTnlnbjdNY05nbTlFUFRXQkFNK2tpVnQwakJxMndXMzdN?=
 =?utf-8?B?aTJueWZkdmFTcU1iMVdoUytBL085NlMyeHZ0anUwNlZVMmtEVjBraTdMNkg2?=
 =?utf-8?B?RG9UWHhHcFp1alFyRzBLNWIyd0ZpNTd5cm5zY1gxZFpaN2dHQk5RRDl2RXov?=
 =?utf-8?B?U0x0NmlBZzQ0ZjVVeGhPRTJxbEM5dEMvUHNiWE1wRk1QamFEM1JveWU1aDd5?=
 =?utf-8?B?ZWVkcHM5bWJIK2ViTTdBNENwNllVVlZjd2owZ2pDMmg1QlYycE9sL0UzcDhX?=
 =?utf-8?B?WWpFSzBHRnNaeDZlUGZsQ3A3Q01nYmIvV3d3OGVqV1hLYWJHd1h6dlAyOFl3?=
 =?utf-8?B?VzB5LytscHk4KzAvRjg5RVB0bnpTNkFLMCtpeDVNYnhTbjJ6WCtzWWtjL0lz?=
 =?utf-8?B?L0FmNkxnMWtlU2VCM05Xb2N3UnZXZVZwajJ4U25IRU12WkcxYWlKNVI2Uzh0?=
 =?utf-8?B?K1pDaVVXRTgwcHU3ZjFyOGVPU3liKzUyWFR4NHlBUGszdnVOSFVMcmQrSUR5?=
 =?utf-8?Q?Jdco+jxG2p5P3hd+LNXE4qSKv?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f426fd61-a9bc-4eb9-6c98-08dc801bf43b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 20:14:33.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dCRtGPA/qMLJ4GR1ot+/1xJgQ7FbKIq8A9fkng9BMxb/NPJyhgMuWBqu+mzy4e4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7549

On 5/28/2024 4:11 PM, Steve French wrote:
>>> Would it be worth adding the word "DEPRECATED"
> 
> Perhaps, but it might get confusing since those two modules are loaded
> by default (and ksmbd also loads cifs_arc4, but not cifs_md4)
> 
> Note that Reiserfs shows "deprecated" in the config menu (Kconfig) but
> doesn't mention deprecated in modinfo (in the Description field)

Yeah, agreed I withdraw my suggestion. It's loaded by default in
other configs, such as NTLM and ksmbd. Oh, well.

> An obvious first step would be to allow cifs.ko to be loaded without
> cifs_arc4 and cifs_md4 being available but simply limit the auth protocols if
> those two modules aren't available.

Indeed, and perhaps a worthwhile security hardening task.

Tom.

> On Mon, May 27, 2024 at 10:26 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 5/26/2024 3:44 PM, Steve French wrote:
>>> merged into cifs-2.6.git for-next
>>>
>>> On Sun, May 26, 2024 at 11:53 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>>>>
>>>> Fix the 'make W=1' warnings:
>>>> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_arc4.o
>>>> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_md4.o
>>>>
>>>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>>
>> Would it be worth adding the word "DEPRECATED" (or some such)?
>> These are present only for SMB1 down-compat, and we don't want
>> people to think they're generally useful.
>>
>> Tom.
>>
>>>> ---
>>>>    fs/smb/common/cifs_arc4.c | 1 +
>>>>    fs/smb/common/cifs_md4.c  | 1 +
>>>>    2 files changed, 2 insertions(+)
>>>>
>>>> diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
>>>> index 043e4cb839fa..df360ca47826 100644
>>>> --- a/fs/smb/common/cifs_arc4.c
>>>> +++ b/fs/smb/common/cifs_arc4.c
>>>> @@ -10,6 +10,7 @@
>>>>    #include <linux/module.h>
>>>>    #include "arc4.h"
>>>>
>>>> +MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
>>>>    MODULE_LICENSE("GPL");
>>>>
>>>>    int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
>>>> diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
>>>> index 50f78cfc6ce9..7ee7f4dad90c 100644
>>>> --- a/fs/smb/common/cifs_md4.c
>>>> +++ b/fs/smb/common/cifs_md4.c
>>>> @@ -24,6 +24,7 @@
>>>>    #include <asm/byteorder.h>
>>>>    #include "md4.h"
>>>>
>>>> +MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
>>>>    MODULE_LICENSE("GPL");
>>>>
>>>>    static inline u32 lshift(u32 x, unsigned int s)
>>>>
>>>> ---
>>>> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
>>>> change-id: 20240526-md-fs-smb-common-e92031f7d8cf
>>>>
>>>>
>>>
>>>
> 
> 
> 
