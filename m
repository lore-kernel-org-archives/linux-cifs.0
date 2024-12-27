Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020136.outbound.protection.outlook.com [52.101.61.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2098446A1
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735317012; cv=fail; b=n6uCMUEO6fAnHu7bjSg6KiOnYpiA1chfi/ZCmdFOfFV+/VItOWLtb68aHWzq0GnChOVDNRMqLsuqPqct5dNKD455SNhAbXriuOkQ/8aPvaCdoDU4sRc1ZvZgTvYoGl4Yw2+TInjLPCSjDZVTPTaUMXIn05jXfeilsHNmDQT2cdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735317012; c=relaxed/simple;
	bh=3n+FegJdCKEsWI12f3SFMCg/HahKwC5VMps0RkoygNc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bR55DiC5nw6xXd+oUMYwPjIVEVvnoUjBfb9/CMkz57yCZh2H6Rj9R55GZueBeuEXNTnX+BlUO7kvTNACAhMqNg/6i1Q4viHxBfPRL7POIzB3yoaUpwMEWVkZjEArP+mR5IH44L1j9/tRAU0gqSEiWYSVtMLmp6raFFYwNBIlRI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.61.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=owATxcjoTj4JtZU+4HodNZ8klj1DmU8dbIxcR/miISo4ADFcgj5jyCVi1/8zHUUeTLLUppOZnKChd7n5d0mnBapOkljQibH3PgPBTdHDi3TcpL993WaJ0FDudyNRcWf5DS51YSXtCXJO9KK7p6oH+phC2BP6hdY18Rd0PGRVvbJslysIrO9GiH9iPEexmepIfhu7BKUuMNWmk/TmESIj5i8vvRHXrX314KFrDGNw1PbTvDd9BjvAGvHjXm3cX9DoTKdwNU2chYzp6Eqz3oVU7RMwdJYN34/IL+hZK6N67diZP9T+OvMDz7EgwzJYBfZIuRMIn2qxZC9ASMjV2WIPHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gs0ex2qidw44tYX2YSH7L61q2eAO5pvSdxjEdiREyxI=;
 b=JdJw8fDmwASmUwgtQhJPlMVt3mhRjjOP4zAWedqUI1eJ+9TaBXWPoLPkol6qstP6EBcNmJYEK9LoGItEoRq8PxMyBzRxpkW0eiNzkVYLVOiIFiJ2XLHQ9zmjSUiDoqMX5TATcfCfrkHKigX8vh8SrbXWMqhwDKR+jBhLzVJ99C5ngJaHe5iMK8zmDqRbet9MRbVLitKCgLtOa7KrIfq8TQToYuedBslLaf28hoRiMA2a3TCOTDOsM/WSi8HhxCyx4qsovvIm0yFIqDLCWbgMzlwdzdtBYteu2Y+hKfEzAzUe2SYAsU9jaBPJPudYh4SGvJ6zSKtiWzQQXPgRBUdHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB5238.prod.exchangelabs.com (2603:10b6:a03:91::18) by
 LV2PR01MB7766.prod.exchangelabs.com (2603:10b6:408:171::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.16; Fri, 27 Dec 2024 16:30:05 +0000
Received: from BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0]) by BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0%6]) with mapi id 15.20.8314.001; Fri, 27 Dec 2024
 16:30:05 +0000
Message-ID: <9ca83bf5-8c56-4de3-a202-84b1ed8fcc19@talpey.com>
Date: Fri, 27 Dec 2024 11:30:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
 <CAH2r5mvUjZdDo2gEZ-PSrP5cYT7q25yT7-J1RcaaLxGh-h7Eaw@mail.gmail.com>
 <20241014094913.nyaltrl2t7vjhcuw@pali> <20241227155854.5dpq2xihclrat6nn@pali>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20241227155854.5dpq2xihclrat6nn@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:208:120::24) To BYAPR01MB5238.prod.exchangelabs.com
 (2603:10b6:a03:91::18)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB5238:EE_|LV2PR01MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: b78c2d80-0e9a-461f-ad9b-08dd2693b83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RllLdFlsNlVkOGd4V1hDZk54YTZtQ2NxTEkwZTB6K0hXS0NHNUF1QTk4ZnI4?=
 =?utf-8?B?Y3AxTkkvVndOdVA0eWU4dDEycC9vdC9UcWZIakt4cFNLVUxKekdBMTFNNmh1?=
 =?utf-8?B?Z1BXNUFSUWRoZGMvVmx4R3lXNk1SMzY0MFdXek4rNDAwZ0ZUSlFoYWprd3VJ?=
 =?utf-8?B?VUFDZE9nUFh6NStvQkxOYUd5dU9VOXVDL0JsMEtndlRSUEx1dWhkT2FCY2RQ?=
 =?utf-8?B?M0pUZGdOeWlBMWVyNUw4Y2tDVU1FRWVUemp6cERhMnFib0p4ZXc4cnY1andi?=
 =?utf-8?B?OXRWa3Zwb201YUZEcUhPdjRULzZYcVBlS1c1SEJpUlpZYlBlK25QN1YrVzI4?=
 =?utf-8?B?QjZPaG01OURyb0FWWDZtdzY2QnJPdFZ1WXZVMnZUYnIrNUVFa1ZGemJMKyta?=
 =?utf-8?B?eHZhNlcwbHBybkpHSWNEREJxUC84MjljUDRvYXlaL0NpOWluazROelBmenN4?=
 =?utf-8?B?enJRdnZJOElESm4vNm5ZY2tOR3ZSTFcwY0RrRTFKaW5lT0xBYkN0MnhKRVpB?=
 =?utf-8?B?MWRLak1hMzRCVVorVDg1Nkoremd6cEdnMm9NWC9LTXFJdWk2NTF3M1RIbzdz?=
 =?utf-8?B?bE5aVkE2M0RtKzBSRkZ6R0tyMy9DWGo3ZnlZc0tMby9wZ0w1eiszSjJVOWtl?=
 =?utf-8?B?U2ZnQkJrczk0UjQyZG4xZHE5TDZXSVhNWWhHQmYvQ1FVNFNjc1JqaGpwdzJV?=
 =?utf-8?B?dkdXY0lXVTBxb1pVOUoyb3NRdzFTbU9WN1lqZ2hoRHBCbzg4L1UybklYdXpY?=
 =?utf-8?B?RktmblFLVTZkMHlnc1BjcXJiRmdrbEJEcEIyN3I0Y2JmaHg5Q29OSDFNUzNp?=
 =?utf-8?B?Yzh0R0pONGVWamFGYVQ1UXFweEZFYTVoOHY2TU1kbG9qaC93RDZRbk1MVlV4?=
 =?utf-8?B?YUZQRnFqejBDbzR3bG1MaDhzNTVxK2t0MVU5VTlUZ1NTMmV2OFJmM2czUXdy?=
 =?utf-8?B?a0M0cVZ2a2hCa1ptTkdwMmFZY3N6Wld1Mm1STHBIOU9aNHFuUXRtMWdGNWhJ?=
 =?utf-8?B?bzBVNzFTMnlnQmdpUmdtZjNlMUlydXZqck1lZUgzTnJHQ2hRVWZVRXAvU1dU?=
 =?utf-8?B?K2k5YmZIbFNYT3NFV1hmODRjd2twMGZ3ZFo3UFc0anBTQzZ5cHFVRHJoaW1E?=
 =?utf-8?B?dHArRUQ4elZlUmo1ekd0d0NBZ2xyeUlJdllYb2dTV2hoWkFmenBqakZ0R1Ay?=
 =?utf-8?B?OFdXakxmdFI2NjNNMkFGK1VGS2sxT1J5NlE5SXdzTjA4M2hPc3JtWjk2dUF6?=
 =?utf-8?B?ZlE2dkFieFdTbVMrNTM4U2hXS2d0dCtjVlN3ZXBxc3oycElud3FEV1FJT3cw?=
 =?utf-8?B?SnEyZ1Q1VGFPNFFOTWk2SXhFRVE4S3FxdU02ZlpicWI3MXJ5ZXVpT2VPb3JM?=
 =?utf-8?B?MUJrMmc5dzZpV09wZlpDTndaYTFzVFpZeUJPWVFSSlVXQnNQTUZ3SlVsUm1l?=
 =?utf-8?B?aXI4R25yNzY3OWFJbFB4Mmpha0FvTWJlVlhZdlh5enhoZXRVUFo3S2t2cXBx?=
 =?utf-8?B?MEZzNDRqYVQyMUREaVhIeGZPa09iaVlHTWNkOFI5YWlIb3k4M1orWVZyaFcv?=
 =?utf-8?B?RjVucWsxYm9UR1NRaW5sOW1FekdMUnZxTjk3TTVjdmdtelNid1BFOGZRMi9Y?=
 =?utf-8?B?ZlU2MGo3SUg4T3hnVzE5WVZlZVhGNUp6LzF5cVpJYm9BMGsybThCeldYMFpU?=
 =?utf-8?B?b2xwWnZOZHZEeDMxUm5LNGpjN1BXYm9jS0htRGJwaU1pL2xrV1pVUzZRc01I?=
 =?utf-8?B?cEozTzRlb3kvYWZrN2dEbkZnT3hPV2RJWERCQUFRcFVHdkxadmtNWkl6bmR0?=
 =?utf-8?B?WTlNK2lYM3VmcVlnSk9iV1BwdHUycVE4b25YZUNGdnk3RzNiOGdrSnF4UDFV?=
 =?utf-8?Q?jnWI3Pvj1bbg7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB5238.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enJZdXgvM2I0NTQ1V2E0MGtYYWVQYXl6c2VhbzRGQ1VxaGEwbkZ2WjlURlNI?=
 =?utf-8?B?WFJKeVF4VHcrSEZMTnIwUUhWYWFPdDNCUjQ3WW1lNWFyZ2o4SzY3TlVRVFU2?=
 =?utf-8?B?Z21xN1pVMks4aFpRSWwvTHdmSjBLN21yMzVjZ1ZUZ0kyaGswZTE1RzdsMWZs?=
 =?utf-8?B?SUk4cWxsSFZKRHFkYkhONHkvdjdxMXdvTzFvVFhEY0VhZHZFbGswcnpNMzNp?=
 =?utf-8?B?MFQwQnhOZHYzMzdiTUdvOUowZWpZUjFCNWNSUVVkRnJ6RWl1OEZwTnB5QlB0?=
 =?utf-8?B?UEpDaTNaa1lpYUQ1NVNQM1J6OUdtdk9CRFBPdkZwNWE0U2pTVWYwanllcVli?=
 =?utf-8?B?UG1VQjgvM3JDdHZyYkVhaVBnaWZGazQ2OHFCREh2aWo2eU5RNlo2bDRZWW5r?=
 =?utf-8?B?dXV4ZStJMW0rdDJqV2VqN1FXSFR5WU5QNmlWTlBHNUIyL01QdThtc3UvbHpO?=
 =?utf-8?B?eWxoQlhjY0orOGZ0WTJzSTVLeVFtdXk1TFd3YzRBdjZYN1JiLytKK1MyTnpF?=
 =?utf-8?B?OEs0eXZDcWx5K0RXOWkzeEZJMW1KcVZuVXNPTnZUNVRtaW5xL1g2Rmx6R0x4?=
 =?utf-8?B?TTlOYXJaVWFhQ1c4YmwxQkZuMk1rWXRBRHIvSmJkbDRBbWY4M2xDcUxaZFBw?=
 =?utf-8?B?bDVzd05lQ3lIVTVJQW1raUYwcUZIWHdBNExEVktodFlhMEtwb011T3hIRzBo?=
 =?utf-8?B?VlJhd09zTmZITTk0MndvWXVSWGY1SmN0clJYWjVWYUpqRDNsaU1aRjJMdG5Y?=
 =?utf-8?B?RzhLbmk1RHp6SWw2NnBIMHZlc2h6MFJodlNTVUV3Rk0rWWIwTTVvd1hNelpE?=
 =?utf-8?B?dk9JdXMrcTBjMlpuSnJYZ0JkUHozeUtEZ3NQR2RyRlcrUXl1OXNtOUV3NW1H?=
 =?utf-8?B?VUFSUjd1TkFTbTlyMEtZU0ZYdXlVQjUrTUp2dTg3a0w3YUo5YTkwOU1sVmRs?=
 =?utf-8?B?Z1g4ZEJDakNYNm5WOWx4aVkyUW5iYjI3RFg5QXhpaUpFVUhoaFJRbHg0Y0Za?=
 =?utf-8?B?QXJRTThJSzZjaEczd2t5TkRqcjg2MFFkcUs5NEtaZ3VqL2x5a3pTMkg4YytC?=
 =?utf-8?B?N2FwcW9UTnVVanFGZmgvbWlCdWRsU2FqdDBoWitqV0ZPNDZlTjBYenJNUWxX?=
 =?utf-8?B?WnRqQU9TTDArQkl4MzdLdDNlenMyZlV4OUVHMDllekh0VFlCTXRtM2ZacTdG?=
 =?utf-8?B?M1c1ZEdKMmxqVmttWTBSV3l3dHdYdWRUSHhOWG1QbG9NR2lkNWFRLzluYm5i?=
 =?utf-8?B?aUN6Y0phaDVENnRHai9GUUdTd1h1ZlMxV0h4elE0ZTMvVjU2TDRYTHlZVXV5?=
 =?utf-8?B?QW1GNm1IajQ1UlJBUG5jWnVPZ1hLUWp4TFZDZ1B2bE9MbUx2cTE1dmVBVzQ2?=
 =?utf-8?B?dnd1VWp1dTBpLzFuaHpCUTdhOHpRRlZkcCtuU2N2bk9FTkRBZnUxVXpDdFpN?=
 =?utf-8?B?c05DaW1FMTlqOVJicGhXZVJSTVo5c2pPRjFBcXBXdUptdzE0YTZ4UEFWVEd0?=
 =?utf-8?B?NjhXL1NCcWhuYk1SN2tDYktOT2F0YkVSald1ZXpYQ1JDelVNak1LUUZ4TUtw?=
 =?utf-8?B?WSsyaFFraWhReWVMOHl4dVJ3SjloNXluajhBRFVJZ2JTQ3Q0MWk5SW1DcldU?=
 =?utf-8?B?TzJDRlVSSnJlSkw2bEwyb2MySkd4T3IzYzFvRGZzN2ducmxjRW5URTR3MWF6?=
 =?utf-8?B?SmJKLzhhS1FuSlRTYWZmQWwwS3ZuOUZkcnJYRjh0a2I0bEJMV0o1OWlpekU1?=
 =?utf-8?B?MkJ6cUtZMGdYdDlkbWhXb3BjSElCc1VhM2xNcFVvWFhsTURWSGtwY284dlFZ?=
 =?utf-8?B?eU5Jakd6bkkyQnJMNnFhUTMrbkRUWnBKekVtVjJIUE1CL3JxbG5uY2dMRHFN?=
 =?utf-8?B?djRLMkdmOWRmOGx2d1RQUkJpUHVZOWI3TTBxQXJWTFozVnNuUEkvMVJacEU3?=
 =?utf-8?B?WmpOL3o4cWJsREo2REdDK1V5NStYVUZZaEpqSjgwNWYyRmsxcmZwaC9zS3pj?=
 =?utf-8?B?Y2ZocnExVmNZN0FuTUVWYWxiY3UvVXAwcmhESXRkNUZONG5rMVZ2dFN0NXZh?=
 =?utf-8?B?SDdJUGIybFBwTFhhYUFzbVlZZCtRL2dVUzVJVk1sSGFFOC9oSlpSamNWSjQw?=
 =?utf-8?Q?peIo=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b78c2d80-0e9a-461f-ad9b-08dd2693b83c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB5238.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 16:30:05.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrV3rn9m6VDNMzMJJlm3HAJSd8cjy6cI5YupCz9Z5Efws7YHX0c23oDjt4CYu4zP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7766

On 12/27/2024 10:58 AM, Pali Rohár wrote:
> Hello, I have redone these tests again. And the results are that
> Windows SMB3.1.1 server really filter out this class 64 and does not
> allow to use it.

Not surprising. Windows is quite strict about poking holes in the
protocol, which is something Microsoft has a statutory requirement
to adhere to.

> But Windows SMB1 server does not filter this class 64 when sent over
> SMB PASSTHROUGH (sent as level 0x03e8+64, see [MS-SMB] 2.2.2.3.5), and
> normally execute it.

This is very likely a bug and a significant security issue. However,
it will be one of many SMB1 vulnerabilities and Microsoft's "don't use
SMB1" policy will probably prevail over any fix.

> I have checked that over first SMB connection I opened the file, then
> over second SMB connection I sent that UNLINK command and check that
> over second SMB connection the file is not available in the directory
> listing anymore, and at the same time over first SMB connection it was
> possible to use file handle (of that opened file) for other operations.
> 
> So it looks like that at least SMB1 can benefit of this POSIX UNLINK
> support. I have also checked that if I used first connection over
> SMB3.1.1 then it still worked correctly (opened file handle was usable
> and the file was not in directory listing anymore).

"Improving" SMB1 support is a fool's errand and we should not pursue it.

> Do you know if SMB3.1.1 has something like [MS-SMB] 2.2.2.3.5
> Pass-through Information Level Codes? If yes then it could be
> implemented also for SMB3.1.1.

It does not. By design, since SMB2.0.

Tom.


> On Monday 14 October 2024 11:49:13 Pali Rohár wrote:
>> I checked it and seems that both Windows SMB client and Windows SMB
>> server on Windows Server 2022 filter out this class 64.
>>
>> Windows SMB client does not send request to server at all and
>> immediately return error to application which tried to use class 64. And
>> Windows SMB server returns STATUS_NOT_IMPLEMENTED, which indicates that
>> server recognized it, but filtered it. Older Windows servers returns
>> STATUS_INVALID_INFO_CLASS which indicates that they did not understand
>> class 64 at all.
>>
>> So seems that against Windows SMB implementation, this class 64 is
>> unusable for now.
>>
>>
>> Anyway, can somebody ask in Microsoft if they can allow to use
>> class 64 (FileDispositionInformationEx) and class 65
>> (FileRenameInformationEx) in their SMB client and server?
>> This would really help with Linux/POSIX interop, which Windows already
>> provided for local filesystems.
>>
>> Steve, are you able to ask somebody in Microsoft for this?
>>
>> On Wednesday 09 October 2024 00:03:03 Steve French wrote:
>>> FILE_DISPOSITION_DO_NOT_DELETE  0x00000000 Specifies the system should
>>> not delete a file.
>>> FILE_DISPOSITION_DELETE  0x00000001 Specifies the system should delete a file.
>>> FILE_DISPOSITION_POSIX_SEMANTICS  0x00000002 Specifies the system
>>> should perform a POSIX-style delete.
>>> FILE_DISPOSITION_FORCE_IMAGE_SECTION_CHECK  0x00000004 Specifies the
>>> system should force an image section check.
>>> FILE_DISPOSITION_ON_CLOSE  0x00000008Specifies if the system sets or
>>> clears the on-close state.
>>> FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE  0x00000010 Allows
>>> read-only files to be deleted.
>>>
>>> These are interesting flags, but are we certain they are passed
>>> through over SMB3.1.1 by current Windows?  It is possible that they
>>> are filtered and thus local only
>>>
>>> Have you tried setting them remotely over an SMB3.1.1 mount to Windows server?
>>>
>>> On Tue, Oct 8, 2024 at 1:18 PM Pali Rohár <pali@kernel.org> wrote:
>>>>
>>>> On Tuesday 08 October 2024 11:40:06 Ralph Boehme wrote:
>>>>> On 10/6/24 12:31 PM, Pali Rohár wrote:
>>>>>> But starting with Windows 10, version 1709, there is support also
>>>>>> for UNLINK operation, via class 64 (FileDispositionInformationEx)
>>>>>> [1] where is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does
>>>>>> UNLINK after CLOSE and let file content usable for all other
>>>>>> processes. Internally Windows NT kernel moves this file on NTFS from
>>>>>> its directory into some hidden are. Which is de-facto same as what
>>>>>> is POSIX unlink. There is also class 65 (FileRenameInformationEx)
>>>>>> which is allows to issue POSIX rename (unlink the target if it
>>>>>> exists).
>>>>>
>>>>> interesting. Thanks for pointing these out!
>>>>>
>>>>>> What do you think about using & implementing this functionality for
>>>>>> the Linux unlink operation? As the class numbers are already
>>>>>> reserved and documented, I think that it could make sense to use
>>>>>> them also over SMB on POSIX systems.
>>>>>
>>>>> for SMB3 POSIX this will be the behaviour on POSIX handles so we don't
>>>>> need an on the wire change. This is part of what will become POSIX-FSA.
>>>>>
>>>>>> Also there is another flag
>>>>>> FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE which can be useful for
>>>>>> unlink. It allows to unlink also file which has read-only attribute
>>>>>> set. So no need to do that racy (unset-readonly, set-delete-pending,
>>>>>> set-read-only) compound on files with more file hardlinks.
>>>>>>
>>>>>> I think that this is something which SMB3 POSIX extensions can use
>>>>>> and do not have to invent new extensions for the same functionality.
>>>>>
>>>>> same here (taking note to remember to add this to the POSIX-FSA and
>>>>> check Samba behaviour).
>>>>>
>>>>> -slow
>>>>
>>>> So the behavior when the POSIX extension is active would be same as if
>>>> every DELETE_ON_CLOSE and every DELETE_PENDING=true requests would set
>>>> those new NT flags FILE_DISPOSITION_POSIX_SEMANTICS and
>>>> FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE?
>>>>
>>>
>>>
>>> -- 
>>> Thanks,
>>>
>>> Steve
> 
> 

