Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2136.outbound.protection.outlook.com [40.107.220.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9C2A3F
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 19:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716407227; cv=fail; b=FLSksOPXtEDdVV/j+eFOEgKExqeb82RxlpSaRs0pc/l+p/Xj89v9wlwLlxEo2lsJUlJftZPxs0WPVduN1igJFOLDa/oqW8y0C6XDY5RbysaExAYxI7kJT9fPPeRl4TMzQJKCXxUiBNXG1+5NCUl8X3/gFaniAOtBJUxxygssEb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716407227; c=relaxed/simple;
	bh=sxTBR8j8xPdTYZw3AVBDT1Dat2RZN0optjBlZadKfAQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BoAIdoXk/uF3CWLyfgsT5jnW480lS200j2lhyOoGPQRsAV29+th5A0YEgDqIPArWIP6Fu3OPy0BYorUBaOMyA6qSMpskHQnmqerlgrEhOsSChpRjZeSqBkDge7KBGou9dyJc2kel34Y3/Phjebyu22Ef6HJQwZF1GUeHNlRxRNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.220.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKch3m7TbUP6mtaxW7W2Mq2z0fEgQoaWByLfCKd2TqOohDF1lQuU/P6R7F99ufIw+0/KC3oyXsHk6UgnM2O++bPEeK90ha5fYBDtaHed7w2kQwbshgMUX1xhoxv3bdKpwqkPuHMaYVw2nJi87ObP5IXcuO38QdxGizllqsJnyUCuj1d62XwaG64FocyIJYCaepinxm0h3xcVVFZDiZUT+1BzqCfhIDc9mQ3N4CyMRp1/kQB12Lg+g9pM4Tcr0a/QSgiMmrMtiLpgCPgjwu+KdBSbopxfoFADoDWW01xeNoAqKT8yp5eKRGu9xhelht3KPYc0d6KbQOIWloCHmI0kTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tc0WGDw5NippNlFwhIYEcryVjx9UIIvrHCYrswKmFyE=;
 b=kmgNaaGWvw6T1hKwqhFD1Rd83r5BWG2dQU/F2ZO29RbIKD/TTICv0AK2iVpqfUHW3Ch9TkuUqFyOq+X5mp2x90w01jWq8jTNG5bK4PvW9RExb91/U3KKzdiPaYwoiGSLGRLvr/yPkBWHcY7Fw+w97LGbW9zwSxFSoWhbUbmTZh2UzBB+j2pz/9pmf3frpI21ZLMbkz0fi893fE5Fyi29kONwnYsEDxSuV/rdmLpi/exlcAtB1N8VF4HuoW24T5sZdabB2zJrh090/9VdyvY6Z0679zJy4pFbVR7fbeGzZUyoD/dPGwCe/ATZgJ05m6N36BaGwUBX4DUAcwFwINl5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 BY3PR01MB6642.prod.exchangelabs.com (2603:10b6:a03:36b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.21; Wed, 22 May 2024 19:47:02 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 19:47:01 +0000
Message-ID: <14fa6bf0-00e4-4716-8569-a85e411228eb@talpey.com>
Date: Wed, 22 May 2024 15:46:59 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the
 client
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 atteh.mailbox@gmail.com
References: <20240521135753.5108-1-linkinjeon@kernel.org>
 <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
 <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::36) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|BY3PR01MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcdbeb0-603f-4b5b-b35c-08dc7a97f321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NitLVGVhdXZzazc5T2VnU0dENHJySGt2MnBDU1ErVjFsTi9ka0JBV29VeFRs?=
 =?utf-8?B?eEdSaUl4eUIvaWE1UEFwNUhoU3dBaFZWSmF3enhpUUE1ZU1oODJBek5OQjht?=
 =?utf-8?B?cFY3dDZwYXcyMURhclVDcU9XR3JuMnd0ZHAzR1NhWlA2REdGRjBmMVlQaGZZ?=
 =?utf-8?B?Y0c0QTJDQ2pqV2lKSDhrektpbGhYWVFpS0E2QndsUmNBM3J4WmM5MlEreUFX?=
 =?utf-8?B?T21Pam14MDBCSC9zK1NyZENFMlptNFJOUFVOWEttWm5RM2FMZElEUWFkdzJ1?=
 =?utf-8?B?bHNTZktQcmUrYW1DOE5PYWtJRm1WbGdRSEFBQ3BBSUZkOWxYY0JKcHRoNXJy?=
 =?utf-8?B?VFViaVJmWTV6Nkl4c1VCbGNjb3pYT2NRaWM2alhXUDVYdGptUXFzeUkvV1RE?=
 =?utf-8?B?TnJuVjF1L2JtVnN6TGhOWlZpNlpYTDJKS1gvOEg5LzNrYWR4R0VYeDh3Zk9y?=
 =?utf-8?B?WlFnRGUzMVBKSVJoWDNIdnhubzNSUUZNVEkzUEgrRUM1SklwNngxaE5rNVJC?=
 =?utf-8?B?WGFtbTBWcXVPSVp3dUFBR2tJc3lDTUtBMUtSWk1DS3RaajdyRUtMTDRRQWVO?=
 =?utf-8?B?TkZCcXdUL3RCZUJvUjRvZ21ZTjZkMDVSODZtcldLUjE2Y2UvVzJCUFlCc2tq?=
 =?utf-8?B?YjdrdjFuQkJ2aTc3VFU1am13MW9CMjIwaEw0LzZ2bDJWc3dERlRhNTNwNmhK?=
 =?utf-8?B?SGdLMEd1OFZJVlAwQjhtcnJwV01DRUhVdzFpQ3NtYU53Uzl4Qzl0Vmd4eU8w?=
 =?utf-8?B?OThTU2V5MlMyUThaZGgvajdTOVlySC82aSttdFQzbVJmVHRBdEt3enpjZXI2?=
 =?utf-8?B?RUZNSlBLM2FMYjN0bGM4VEVQOFhOUkdrd0FZVk85SjRjd2ZpUlhQeGtuUk9Y?=
 =?utf-8?B?UTdOS0ppWk5ma1JUamQ4SjhlK1Q3bFQ4VmJROW82dEpoZDNvRjZvaEIvZytX?=
 =?utf-8?B?M1NNVmxFUkJOKys2VXE1bEcvUG5ZVlU5blRiUUpTR3BGd0QrZGxNdnIyVExq?=
 =?utf-8?B?R2ttbzY1cVJ6c0ViME1SZEV5bnJqZTkxWnZSTksxTW9pNVIzYTE1UHI1N0Ro?=
 =?utf-8?B?aTd5bTE1RnQvYW8rbmovSFcwdDZDNlRjQ1lCcFFNazVrcWhXRjVXS3RlODVO?=
 =?utf-8?B?NEw0NmVlOTdaeFNaSHl4RDRQd2VtVFE4YmMybmhMSUYyc284L2Y3TDFQU0xV?=
 =?utf-8?B?VkYxbTNETmovOSsrYkkwK2JFZkhBNm1SaVdjZFMrUy93UVhpQzFXMG13ejRD?=
 =?utf-8?B?azB3WWZrK0dHTGloS0pLOHRKbno3a2pBMlBFVTB1Y3FpM2ZsQ1JyUUNTbGU3?=
 =?utf-8?B?dUVGOEFFejR1QXo3WFdWNkpJMnNlcStHeW15RXYycXBFbk9Pd0tTK1NBQnY0?=
 =?utf-8?B?cGNkcGNmWkwvWFhUQlJ4S2JiV1N4TTJJNkltNzNyMFM0WnpxcEp6cUtINEdm?=
 =?utf-8?B?WkIzcUJpS0EvWmlWbVYwOVFSenNDdVMyN1ZteDhxaElBNzMra1hndDdMdzhz?=
 =?utf-8?B?S2VZZjBkNUV0UXNUSDhobnAwWXlpZXdoM0x1djFndDBtODhnbkxLbkNhWlhW?=
 =?utf-8?B?VDcycW1QdmVTcjhWUXlxWXNxOGhuQ2hDY0F2WGt5aGpyVE1SNzN3c1Y4UERP?=
 =?utf-8?B?VFZWa2xoaGlzbGZlems4SXBhbEIrVlR0WjBoVDRzTTZIT3h1SCtPODgraFAr?=
 =?utf-8?B?bVl1N3hQT2xxd0M5eVBaZzNGTWxWM08wQ2VGRkVlaVRsSVdFaFJWclFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K05YMEhxdGtBRzgwTm8zcDY2SjVDLzYwYjY4OXVCdERmNU5wUm5DU09qK1pk?=
 =?utf-8?B?Vk8zdEptWGNyVGlhMDhGNXVoOGJEdVFFY3BPb2ZnSDlzcmdoNXJGTVJPakQ4?=
 =?utf-8?B?UVlsTGs2RUVkRFpZclFDeWordnBoY2dER3lwYk1XLzJUQmV2cU9UNjdWZHdL?=
 =?utf-8?B?SG9aS1lZTjFvY1pJMGVXazdYWUxEM0czWW5XMCtaZGttRi8wL05CZUhUK0NR?=
 =?utf-8?B?a0tvanBXempiMjY2WEdkRTBkbFlHNEhmeTNQL2NsZnJDN1h2Y0g2SGJ3UXRk?=
 =?utf-8?B?cEhpZXdPM1lwUWlBZGlza0pGZm15THhLbXU5VFdvVDQ2SldZUEZpa0YybVNL?=
 =?utf-8?B?dmczWEJ6ZWgzZ3g3RDlqSXh3d2hyS0RUZEtQMHRiaHM5VEJ1cmE0dFlyWlpI?=
 =?utf-8?B?MXJjb1VJcnRyTkZibm95VSs3RzFlTHlma2JiU05EQURDN3IxZXBqWWM1dG9D?=
 =?utf-8?B?ajlvbHR1QkNnaXg0WWRTV2tvOWVEQ2xFU0tISy9EU09nbXBsUjM5a1dKZGxu?=
 =?utf-8?B?dTluMU54em9QTEtiaDdDNUNqK0JEbTM5ejJXQ29hY3g1LzJEb3d2ZFhreDhw?=
 =?utf-8?B?cmRTRUdYTW5GUFdGUlBsNmc1cC9JQWptcnRYTWI1dElnUVdUbHZmNkl2YjQ2?=
 =?utf-8?B?a2hjUmhiVTUwSmI1ZE5EV1FrMS9rakRlV3BuR2wvcEt2VnB3eTZSNHRwa3hU?=
 =?utf-8?B?M2JZU1FETTBqVnZ2cU9tWUlyUmhTT1Q4RzFHZURiMUowUDVEbkJ4M3c2UXhh?=
 =?utf-8?B?U1hZV3QwNStzT0d6R1Bsc2hJck1LTnY4Rnk3aUx4WiswNUFUNXRJZlc2NUFT?=
 =?utf-8?B?c3E5Q2FTYndHZWpoMXczU3BnZm9CVEU5ZVBFcFJwQXhjVHFPcmt3UE10Yy9z?=
 =?utf-8?B?ZUFsRlFvVGFQd3RldC91RGlSRG1vVm1VMG0rM1lqOW9maFM1WXJnNUVnMXEx?=
 =?utf-8?B?RjRFSEEwWm9Cc0JGWk1LTFlZS0VwZmZleVFMQjVNUkd3RFdHelpoWWVhWTFD?=
 =?utf-8?B?Q3BmTjVTRjU5cStNN1R0THp3RXpMMmlmSHVTNUYyZkovNnNIcjlZdG1wL1ox?=
 =?utf-8?B?elJCdmNzNXpDbm1VZTlWM1R0eDFZSFpCU0RvWUJIVWZYWmVYbWtXMEFGNVRL?=
 =?utf-8?B?alhDM0Z6V2tGcTkvOTFZWGZlVitHaGpNVEtJN3Z4U2d0U09kaDVzSk55ZUs4?=
 =?utf-8?B?VVZTN2pRWlNHYlo3bXVMQURobHVCVWNjUFppSlV4UXM1VTlzc3JKTmtqQlI4?=
 =?utf-8?B?cVFNZHhFdGt2TVJ5eEM2RHAwTjZVRmh2MHJ3SVg5a3l2SDh6NDB0c3JOVklp?=
 =?utf-8?B?RVpSSWtGMkNNOHlFOHZ4N29meDNWcVg4alpXaGhrbUxacjRjdTdDTDhrVUcv?=
 =?utf-8?B?MHlaZTFMTTQyYU1PZUV2SHFyRTVNQWs3VWtmVXRYWG0wUHhtdHJpMmtWSzFT?=
 =?utf-8?B?TmVidlRSWmFLeEFxQ1puZlJCcVQ3Q05SMy9IT05sWExVb2tUQ01KaEZxUEZL?=
 =?utf-8?B?c3cvZFY4Z2hQdDdJbG02eEVHNFFJajRIa056NVByMnVTbFhYbXhJVURNSW5x?=
 =?utf-8?B?M05nVGRmNG9hMFhCb2N5cWRIRVcxaXlld0pHTi9haHU2QUNLYWNEaGR6N1VF?=
 =?utf-8?B?N3k3amRya3E3YnNva0tReE9WanQ5ZTJhd1U4QTVWN29jSzdzOTBGMXpCR2Jj?=
 =?utf-8?B?ejAxZSt3ZFBWZHJvV0xtRUtOUHl3eFVXMkhOMjl2L2xkWVkrdXZjcW1OSzQw?=
 =?utf-8?B?MDBuYUNvTlg5TUJ5Q1NpRjFWZzF3dGtmUDdUYU43RWM4NHBkT3ppWlZtY1Y3?=
 =?utf-8?B?UENocjl4Qitrb0h4NUlyN09NcmppcW9IN3lRL3JTV2Q3cW1INWp4WmtzMVJT?=
 =?utf-8?B?eFV4Tlh2a090UnYxMEt5U1dGME5ZNjNmbk1XSjV2OTJKMEt1Nk9HNWdUT012?=
 =?utf-8?B?WU9wT1YyYUpqYUgyRFlRMWtqNXhRUFc1RVAyTHpOVzczSlBzM2xNWS8vcko3?=
 =?utf-8?B?MW9DMFRPOWJxMmo2MlJPaWZMMEJHYjg1UTVSRkFhdUtvYlJyeDZjWmQ1cGk0?=
 =?utf-8?B?MmxWMkpua2Y4TVdjQWpGeFBWbWFGVjVCelk0emlIaDJzelc2Uk45Qkt3a0hI?=
 =?utf-8?Q?r7KqgTbo7lcNe1YWn2dM/u1PZ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcdbeb0-603f-4b5b-b35c-08dc7a97f321
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 19:47:01.9044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0HcLW9LnJ3OZn97NRLS2hNgiZ+SKbiLTj3uDh2dZGCPcSAao2qEPtcnf6/4maGS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6642

On 5/22/2024 1:13 AM, Namjae Jeon wrote:
> 2024년 5월 22일 (수) 오전 12:10, Tom Talpey <tom@talpey.com>님이 작성:
>>
>> On 5/21/2024 9:57 AM, Namjae Jeon wrote:
>>> The expired durable opens should not be reclaimed by client.
>>> This patch add ->durable_scavenger_timeout to fp and check it in
>>> ksmbd_lookup_durable_fd().
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/smb/server/vfs_cache.c | 9 ++++++++-
>>>    fs/smb/server/vfs_cache.h | 1 +
>>>    2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>>> index 6cb599cd287e..a6804545db28 100644
>>> --- a/fs/smb/server/vfs_cache.c
>>> +++ b/fs/smb/server/vfs_cache.c
>>> @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
>>>        struct ksmbd_file *fp;
>>>
>>>        fp = __ksmbd_lookup_fd(&global_ft, id);
>>> -     if (fp && fp->conn) {
>>> +     if (fp && (fp->conn ||
>>> +                (fp->durable_scavenger_timeout &&
>>> +                 (fp->durable_scavenger_timeout <
>>> +                  jiffies_to_msecs(jiffies))))) {
>>
>> Do I understand correctly that this case means the fd is valid,
>> and only the durable timeout has been exceeded?
> Yes.
>>
>> If so, I believe it is overly strict behavior. MS-SMB2 specifically
>> states that the timer is a lower bound:
>>
>>> 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
>>> of time the server keeps a durable handle active after the
>>> underlying transport connection to the client is lost.<210> The
>>> server MUST keep the durable handle active for at least this amount
>>> of time, except in the cases of an oplock break indicated by the
>>> object store as specified in section 3.3.4.6, administrative actions,
>>> or resource constraints.
>> What defect does this patch fix?
> Durable open scavenger timer has not been added yet.
> I will be adding this timer with this next patch. Nonetheless, this
> patch is needed.
> i.e. we need both ones.

So this code has no effect until then? And presumably, the scavenger
will be closing the fd, so it won't have any effect later, either.

The patch should not be applied at this time, and the full change
should be reviewed when it's ready.

Tom.

> Thanks!
>>
>> Tom.
>>
>>
>>>                ksmbd_put_durable_fd(fp);
>>>                fp = NULL;
>>>        }
>>> @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
>>>        fp->tcon = NULL;
>>>        fp->volatile_id = KSMBD_NO_FID;
>>>
>>> +     if (fp->durable_timeout)
>>> +             fp->durable_scavenger_timeout =
>>> +                     jiffies_to_msecs(jiffies) + fp->durable_timeout;
>>> +
>>>        return true;
>>>    }
>>>
>>> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
>>> index 5a225e7055f1..f2ab1514e81a 100644
>>> --- a/fs/smb/server/vfs_cache.h
>>> +++ b/fs/smb/server/vfs_cache.h
>>> @@ -101,6 +101,7 @@ struct ksmbd_file {
>>>        struct list_head                lock_list;
>>>
>>>        int                             durable_timeout;
>>> +     int                             durable_scavenger_timeout;
>>>
>>>        /* if ls is happening on directory, below is valid*/
>>>        struct ksmbd_readdir_data       readdir_data;
> 
