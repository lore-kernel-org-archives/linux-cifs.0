Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020089.outbound.protection.outlook.com [52.101.56.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ABC3B0AF3
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563784; cv=fail; b=dptibaFORPzs/Urw6+E7AYXVGLlq7Td3xMPxMwa+lKizg7pnleqPSRlI2SNk13HJKXrq7GuGUdZLlQRiV/7UsFQCu3JJwv67qM4twlurEnupZ6FwH5ksgAW+silwlxGT1hSymGY0ntj7mVwnBgbmXffEludb1EDGKzALn7nppSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563784; c=relaxed/simple;
	bh=ceDQq8eLF0zcDupxzVY85kDroEs4vXYeYd437IIVUTY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RPWfzMp4Pj2PDneJrJxOtmhSE7eWkygl2QNINkW1YgLL1kIYvG80UQsjgm4leONbnksaSogIKnLSLqCbK/xA1z7pVR+3uM4fqtiTsIOn8sQLzLzYOvGZXUOldo4y++Oeedn2fdmethOrbGisGvhQC9ats4VGk64gbRF9g7bQ0T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.56.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIq17iq1iAwuNQ4ReHsB/cpN1lqP8wu1u3MUMAbl2/TYzVjfyIdPt0AEUdmto3r/YHedShD+ps/4ubu0AGSUuqeZkm2DNE2wKm6mdv3Z6xkavE+DJswqojbJL3s+VHpu0iyaPMtNetbrjInaCKgrbwI83AnCdvKikwYgPVQ2pKUNHkT10pqS3rUApPWx2GYFtTLr+wPfXspviCKJXeogVYeo2ToeJHm6eDljjiG6cKg/kWy16zxz/lnMsXWSz7RGmEc0FZkm83Wft29Qy5IHT6TFJgQuUzqQcgROyspIQguT9lpjtzjh/5fxPl1J/mtlWY5eWXgQGMsfXsz2THHnWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RgnHX7Sf3ALAO4hvLaN052eMqhNnfk3inGdUzAMO/g=;
 b=j405jEyRXvfffQczQ/FrdWPfwolso/4G+2AZT9st68EP+Y72rSkIBCPe6K9l+cdWfRf0VLKkw4YDhKUdcE2dkpca4m/qxScsEAUJdfl4D45mjuI2tCOrjC5mt3183semOD2tCWjDbmpDM7w0JyvSoq8eJlmBc+lGgDnEAhvyPUtfvHrqLuQJ0iNU8q8pjQwtq31z541Ot1KM2vQaUDbX5z8OfngALOx+jDWw6/Pw+Y+KsRhbIyI5zD956eaJ9JPtSgADULOu7q2t4AhkwGNETjfvs4Fsft7oeOwD/l14ssEkydvPVJye+O+wU4ywmn+3bSqeex47Sgbf405oNevFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 BL3PR01MB6882.prod.exchangelabs.com (2603:10b6:208:355::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.17; Fri, 9 Oct 2026 16:36:16 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 16:36:16 +0000
Message-ID: <2cae5f8d-c07f-4778-a890-dcfa5aeb13ad@talpey.com>
Date: Fri, 9 Oct 2026 12:36:16 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
From: Tom Talpey <tom@talpey.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Paulo Alcantara <pc@manguebit.org>
References: <cover.1791229120.git.metze@samba.org>
 <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
 <CAKYAXd-2uBhGZuSFdLM00D+Sty2+DdGbZLWiA1DG0jGvfJjUWA@mail.gmail.com>
 <6981e5e5-e856-4613-a3fb-c8cdc7a9219d@talpey.com>
Content-Language: en-US
In-Reply-To: <6981e5e5-e856-4613-a3fb-c8cdc7a9219d@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::25) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|BL3PR01MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 89f81c21-c4e3-4367-e701-08df262370b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|22082099003|18002099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	QiOBW+7neEhHmGO6hRu1ff2A6Sm1vu6Q4BARk5/MMCifv4cLj7UZ04tJEThMKjpd+KuXVPcABWPU3ZmniZYzbxGp9XIv222002wsoP+VQ+s0nk4TawfC+jyze04MmIraJqc5Hzf7SMkH70a/sV8NjpSyIRMu5G2jKpjMsr+lUl8NVkagjB4pcpAhmaxenP5xneCouuiqLDDzxet4AW07TxgtdV3Ws+29M8cRLKk+7RH2vrbxeaY5O4nl9mY3VOGYgsTOHXzTkOUQm697PKE+I6hXiApDbzevupECQz2K+DUVnVUYGxNxjyeW3fPPIBH2bDquJZUO1JP+PZuHq8YdP3IshXK2LCPmbRpPyw5lFmFYsX1BuORiYCeiIlxH+4KgfWF9EQvqm2lKynKmb96ZEx3msW+2GzWzZO2n+qNTSS/anfpw5WYyRtCfm0sVNz7gfvOcsjlESzLYxub+aFeeoaHZhQgckwRCv/ldiYgRtdq1JlHzLGq+zl8/q63wwQAqY1YenKM4epeSvgZc/UqdJngxrY7JTT+ixK+AZDvD/m+bKKaHWNZLk/LVKuvlTRu6TMbCE7cE5kOAyn+c+7L4xTQ+B3RzGlT/3lXSXPtvTwZINGVHbwYwcMLClL1CNqll17VotKanmuZZ82Tq3kxIWh2j3/5NRfMpsPAj2bjGDPg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkRuK1YzV0x0QUxVb2RvaEtCYUlESjhrNEczRE0xcjRQd2VjOUJ6VU8zSmNl?=
 =?utf-8?B?K0s3L0Mra1dRZ0drdVlGTkdjYzU2dWgyOWxWNGl2dTA5T0dKRnQyRDIvSjhn?=
 =?utf-8?B?alZaR1BUaGg5UVZqaHg2dWIvU3VjWnkwczRodGF4blc2dXJJRGF5Q2xaS3lx?=
 =?utf-8?B?R2VYVFhLODlqalVzTXNadkx0UWtoSFIwY01WTXhlZ0RZMkNxZUM0ZVNueE5Y?=
 =?utf-8?B?NUdHUTl5R0dnYWdnVnM0YU5NVFhaV1ZiVkJnek1WYTRtZzVlMjU3dzdubjZY?=
 =?utf-8?B?VFFraUc1NEhnakh2QzJ5MFB4amxQMlFxeW5JNWwrYjd4Y1hQVUkvenpLZXdr?=
 =?utf-8?B?V0lmTGxJTkU2ZWV3VE9JRWtLZHg2V3p0VC9CWklkMERadmNQMVRWbndvei9E?=
 =?utf-8?B?dm11czdqM2RSRlVCUXBDeGQ2d3JaZFVTTG9QUjA5bmpXL0lla3UrZUNYQXFY?=
 =?utf-8?B?VlptQ3FGcDlHdmRIOFM3YTZZMzk0RXpuekUyN0dOMGhaTncyM1dSZU5nbXUx?=
 =?utf-8?B?OVQzZGkwOHorRUl6TitEbzNJT3AyU2NDbEVzY2hmRlVObTFzYzYvQW5QbUIx?=
 =?utf-8?B?UnBiZ1d1eWUrcGFJN1RxUTY5YTFwU0dLQ0UxZXU3b1FoeHBJeXJCMlZ4YXF3?=
 =?utf-8?B?SUhLcm14SXdLcVBKRUVvQlJyT081VEdNaEN3cDhzMWNFUlFobUZlMWVtSjd1?=
 =?utf-8?B?T3ZWRjhrZjZpMkNxLzlrVUZIL3MxVGFqZUc4SHkzTXIyODNML0hESFhhTkdJ?=
 =?utf-8?B?ZDNjS1NEVytlaktheVZxQWNTZWlJZzhHc3p0ZXBUM3JzRTJxUDMraVRYaDVW?=
 =?utf-8?B?a0Qwb0RmV1NTT1hlZXYvSDdEQXQ2K1IwL1VldGZHREhzekxOdGp2NWs2SFhE?=
 =?utf-8?B?bXpKVDlMeHFDd1o3NjhxYUZORlFvSm95QkRPWmJUVUVLSzRtWWw3RXg0aU05?=
 =?utf-8?B?K2NEUzNnS3B0TzlRODlIM0hicTBjZ0JWbnNZMTBlUFhyZktDMGZWSTRJdndl?=
 =?utf-8?B?aDlITW5Pdlh5eTgzQjR2NE9yTzE2M1Vta1lYYnVRTUVCYk15ZlVQT09pZjZN?=
 =?utf-8?B?Z2dOZmI4SVp6WERIV0FUNkY5d2VVUTIrL0pGZXJ0czNEUlpwY1N5aCsyZVgw?=
 =?utf-8?B?Tm93V25JdWJRaHUrMmJEbjJWQlpEcDhhMWs3WEVCQnFGcmlXOUJTa284U1Qz?=
 =?utf-8?B?WVRrRHRPSTRzLzg5dzY2cjdPY0xFNytBNVJZdEp1N29nWFFtQjA2NlJRVi9j?=
 =?utf-8?B?anlkMzViL1lUNzF6ajE3ajFYU2RtTmVmeEVZdzNPL0E2bmxyZEtOK0MzSTQ5?=
 =?utf-8?B?WXVWNVFqWDNmSGluQXI4YnlSdFBXSVN5ZUZMdko4UEJzN1dob3ZhbEtoRDc1?=
 =?utf-8?B?T00zSFUyVUJlbGhYMHpxQVFOa2NIUXRoandJWWIrbG8reWxRSUUyOVppWDM0?=
 =?utf-8?B?S3ZvZG1la0E3MjNKSkhnOElHVENzVm1FTjYxTmRkYit2ayszL0VjWWNJS29L?=
 =?utf-8?B?UlI2Mm5OdkxVREJPRll1Mm9EcGFnZHJaMUNPWnc0Wk10NHlsYmNiakIwZTJy?=
 =?utf-8?B?ZjlpdDlnOEhyK1lSc0U4VkY0TkR1NWNsYkhxQjNqVHZxRTdUZmRkbWgrSEJP?=
 =?utf-8?B?NUFHV1kwMWpWV3JpYUpEZFZreEdHV3MwNll6c3hKc01ESkp4WUpGVnhwM0do?=
 =?utf-8?B?UEFkaFF2SUpaQTZ3Wm9oVjJ4SHN0cjE4emgxalhkVlMxbm41M3VkUGJYamI4?=
 =?utf-8?B?ZzFHWmJ1MkU2cmQ2SWR2WStWMEVhNkZxTzR5ZE1mVDBOZ3FzcnFyNjJWYkVk?=
 =?utf-8?B?aVlMYWt1ZGsybHl2SlpzMEphOVJHSVpDNGNHWk1iMm5pSWErNDhPM0p4dkI3?=
 =?utf-8?B?cnc1NGJRSlFKckRMQU41MjZ0d0dPZnBjNGc1aVc4TUdTcGtrYkMvSWxDd05o?=
 =?utf-8?B?TEE0aDdjWVUyZEt3dFhCWjMyOVhrYmk5bFVkay9mS3Z6S0pIOE5zVnJrYXZS?=
 =?utf-8?B?TVFNakFNcW5zL2g4UFp4S09talV6bTFlRWRaVHpsMDNQakRTTW1LYlpydHFx?=
 =?utf-8?B?ald2NzRtYmhxNDh1YUVRb2dhMlRVM2lhNjNTZ0hhb3BVcUl1OG5tKzk4ajZC?=
 =?utf-8?B?dGlUZ3dHTXhkUWV3UHkzNE5nVzFMZUtKN2Q5OUgwMkVhMlpGL2FvbCtWU2Vj?=
 =?utf-8?B?ZzR6NXZuNXhmVHdZejZFc3FlaEhIcTZMazVDamFYN2k4NXFRMFYwSmxTVWhU?=
 =?utf-8?B?Qkhhd2l3S3RIZ25senNvQ1p3VlIvVDYzd1BCSnJSR3BhMkoxU3NLeDJmZDZY?=
 =?utf-8?Q?Wkr82YoI7uXHn/ijEH?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f81c21-c4e3-4367-e701-08df262370b1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 16:36:16.7288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kS71ZTUX9o5ZcL7KeugqsE4zGGAPYOI7oy6TbwthZG7Ylgabf54+/YgvhfBTbui
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6882

On 10/5/2026 9:34 PM, Tom Talpey wrote:
> FYI I am hoping to be able to test these and tge others Tuesday (tomorrow) to verify they fix the issues we saw at IOLab. Some were not available when the test network shut down.

FYI that I'm not having much luck getting the tests running here, the
Network Direct DDK appears to need some sort of update which I can't
locate, so the test suite fails to build on my setup, for now.

Tom.
> 
> Tom.
> 
> Oct 5, 2026 9:23:57 PM Namjae Jeon <linkinjeon@kernel.org>:
> 
>> On Tue, Oct 6, 2026 at 9:19 AM 이성현 <ihopenre@gmail.com> wrote:
>>>
>>> [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and teardown races
>>>
>>> Hi Stefan,
>>>
>>> Thanks a lot for the fix and for crediting me.
>>>
>>> Could you please use my real name instead of the display name in the
>>> Reported-by: tags (patch 2/3) and in the cover letter, i.e.:
>>>
>>>    Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>
>>>
>>> The address stays the same. If it is easier for you, I'm also fine with
>>> you fixing it up when applying, or with Namjae doing it.
>> Okay, I will directly update it when applying this patch-set.
>>
>> Thanks.
> 
> 

