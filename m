Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020078.outbound.protection.outlook.com [52.101.61.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71765148FEB;
	Tue, 20 Aug 2024 18:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724179147; cv=fail; b=Qq9p01PtBYtLfYkNtwDa7AR8mtZFARk46jh6VKo2MZDo7kODV8U1FdlheDoN1rTtDpxiAQ5IuvLERZcEd9NiORTF7OgsdkX25h2yU7/jQ3zYo4UpuiT2sw6EvT21k2TWThQC1xjjKjZnSpwahafLFFKWnOlQPK9FR5Z7Q8gr+LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724179147; c=relaxed/simple;
	bh=iwilNS7wocBRZpRrTSKq5yewTTfYbtKH5xG8nJucjC8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nl18z75wJplnVKeJFeMFj5U3iPyMjONGiPnDMFr3/y75jCuztYcJIB5GSNXr9DNMsYDlvFjNmd6Gyf3gL2Yt+t7Taw5f5B+PkbqrrEKul6HMwZ4CX3qkd8Q1j7i2EHpI81jcjkDXDMyCpUQcz907s3cTpIIS2TRb3Gl5EX7uafk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.61.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mySNB1reU8Cci7A+I7GU1hesxh9NqgJ9N7fLkvKcQrgoDDU43VsFORd922zPk8tHIt+UNlF4NK/Q80jwJuHHdQi9YBnEqjnzrf2JRAWU5rruuQGC0I9BLc/AtTIIasjE2B2bWdOl4HV+eeuNdWDzub32Q5HdOg1A0+v+zUMAZ2QQIJYqIN54zHQCdhD8943xdI9ntu53pkrPuF4Sqv8Jed/u6Lha+LOmY3EqLp4Cw05rWSx0+H+xwwde6rbUiikz5Eg+H7ezpouq063uI9MIVs9qoI+65ATfHP5V6mML/Pmuoz5kYbA9nxqanrSsbPvczGgEhVPUZVNNfKrORQGOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yv9u4MlEI5dpkjw1vaIio/4HVCi8MNWINVSEFhxfVP4=;
 b=V5dHcp8BIaMqu40x5NPw+uenGuR8jCDkhqqorptLQp9PT5Yrw7O3OLSsk4rTMTGxm2ucFVzPilYXTBHH/1kqwYl2/5x7J91MumotXU+5tGwZgsNqVvLPNHcZi8ps2B2fbPfxpAwJH3JAT7fcG/4EfSLf0Lzqob7ae0ku/1WRP41cIJAEwt1oXPuW1in247PFLmfb2m7x5pUe1YTfYOXGecAAaOUEGXslvj7Gv5l4U2LftcVg/Ff9r0xIp/pgSsc6NR02dRdvBUFoEPYC/jUhI2d1tn/2+hp9o808mZKY9LZNVNAzFKRlXWbHNsi/9pTWl4EZ7YBHLjQ5q65a7JCBFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL1PR01MB7721.prod.exchangelabs.com (2603:10b6:208:395::9) by
 SJ0PR01MB8142.prod.exchangelabs.com (2603:10b6:a03:4d7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Tue, 20 Aug 2024 18:39:02 +0000
Received: from BL1PR01MB7721.prod.exchangelabs.com
 ([fe80::d33d:8437:f7d:568e]) by BL1PR01MB7721.prod.exchangelabs.com
 ([fe80::d33d:8437:f7d:568e%4]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 18:39:02 +0000
Message-ID: <dc134856-8735-4169-89fd-5b7359e446cf@talpey.com>
Date: Tue, 20 Aug 2024 14:39:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: Replace one-element arrays with flexible-array
 members
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, sfrench@samba.org,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240818162136.268325-2-thorsten.blum@toblux.com>
 <CAKYAXd-pm01ietA1+Z4J8tDcLM6fUkAwQ69j9XZs9uhrBbdDQQ@mail.gmail.com>
 <d7a30cff-e08f-453e-84f2-4584031e3d29@talpey.com>
 <05A23230-C800-4693-AB69-273A0B10C822@toblux.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <05A23230-C800-4693-AB69-273A0B10C822@toblux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::25) To BL1PR01MB7721.prod.exchangelabs.com
 (2603:10b6:208:395::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR01MB7721:EE_|SJ0PR01MB8142:EE_
X-MS-Office365-Filtering-Correlation-Id: 59db5573-f526-4cbd-cde6-08dcc1475cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1JUZFRVRXJTUGhPVmJQNUJzbHpWMURmbGJEZWVlRHc0WUJ5K2pSNXZvSi9D?=
 =?utf-8?B?bjNRWUM5NERFd2tlSStqSWxjZ3JkTEJNNU1vR2NUeHBTdjhsSm9jemxMKzNE?=
 =?utf-8?B?dFJtT2VaSytmeW5zZVZYQVJMYWd3MCt1dzUvbG04UWZqNzdqUUNpRnllZ2NC?=
 =?utf-8?B?NFVxSEVyVTlCQ2d5Rk9MY0JKSi9SNVNnTHNwanZ5RW1NcW9tRzhweGdaVk5Z?=
 =?utf-8?B?eXUrei9UY3lFSUdwb0QzeG5ybEwrdEVhZUhISFhwUnlZdDU1RTRkT3FvYVNL?=
 =?utf-8?B?Yng4NStlZ09qYWVwaWNrUS80TlV5NGpQN3hBcUdZcWxMdHVEZmNFekpmRWdQ?=
 =?utf-8?B?elFOdXh3UE54L2NFa2dqZGV0aFdLcFEwd2Jxak1mREtFcGdLOG1TY3djMTl2?=
 =?utf-8?B?bTlDc29PZXRZdWlGOHBTZFBuT3RrZGJOUmpES1lJek05anJVcDRxaU1pV2FJ?=
 =?utf-8?B?cXhjRzdRY210cmVEcXhUQnBmRjJIb1RlN0VYRXl1Vm5IZTlKZFFweVdMWmo4?=
 =?utf-8?B?cjU0WDhTRzlEN0dDUzlOdWdNVEw1dGw0eDhQOXlZemg3Tk1VRU9xQlBya1J6?=
 =?utf-8?B?cytwb2RLUGRzaGhRcHNoSHNZalg0ajgrSmdqeHNCeFdqME1Oc0ovWXZoK1Js?=
 =?utf-8?B?bXR0dlFVY1JabFczVS9xZ0o4YTdmUHFpR1g5THRZYlRFVEZYdE85V0Fpc1dq?=
 =?utf-8?B?MVlVVkQzNnEyaXpQSlI5Zk1MM3RKL0RRV0EyWVJEYjUxTFBDaE1nTHJZMHAr?=
 =?utf-8?B?VzFDVndmVDRLNWRFMXJyRkZaOUNTeEhsMzQ1S2dNTEpIalVjY01hMkdGMmp4?=
 =?utf-8?B?eWJnT3ZBVkFhNC9zdnh0cStTSExkREl6ZkZyWTEwUFZqTzc4V1ErOFJRcitS?=
 =?utf-8?B?dVlIZGdxdGtzVml4MHlaUTdLS3RtTU9VekIzRW90QWN1ZTZxYzBpaUJVdUh2?=
 =?utf-8?B?U2NVczd2Rlo1RHNrVnhMR1RLNUo1YnRGM1IzSnNhUkp4cThkbk4rYzk1Qi9M?=
 =?utf-8?B?M1ZTcWZ3WjAzcG9CNjVnbExTWEx5eDBScTRPeDhsa2RHaTVmc1MwUnlaY3ht?=
 =?utf-8?B?SFMybGxLbzhPUk4wUlZNMnhDYXdyeGVvcWRBdXQwNldMc0h2bUYveisxUUR6?=
 =?utf-8?B?QmdJWW9laFBORFY2V1Z0bHAycmZJYmtRenhmSFF1YkI5cldNMFdXVit2T0ZE?=
 =?utf-8?B?M3RhMkk1OHdSdlRkR0tXQloxdWNvOHdkUmFVZ3Y0OTNxRXpiU2RrVndSUzh3?=
 =?utf-8?B?SE1PYlFkY2FQbVg0V3JHK1J6WUkwcGkyeXFFMUdYWlN2MGY0Q2JJNVlwTjdI?=
 =?utf-8?B?cnEyV1BBSkVoeVlWV0x5LzdzTDAxQkdrTUtXTzhCYXVYQnFqTHVrVFVWY2h3?=
 =?utf-8?B?L25TMnZlRFJMSGhoUFZmZ2xmZDh5ZmtEWEVZZGY5QlJWRWhHYy9scGs1MStm?=
 =?utf-8?B?czJHNGhGdWlSeVd2NFRlRjNJNkhpN1Q5VHBHQXBubjh0ekY4ZHhXRk1zY2Vy?=
 =?utf-8?B?ZUpnSFNoVVY3dUhEYnQ4Y0YzdVR6bndjdE01WU4yV2pBNzhLL0l0a0h5MVRs?=
 =?utf-8?B?UE8rWEk4clRvcC9VYjVXWjg2MERCNW5pVnBodEJKb2hEZ3c0YkZTdURMbkZO?=
 =?utf-8?B?V2pUSlpwVDNaN3l3R1phZVM2ZUtQTVZydmVma1RwMnBZbkFETEtaZ0I1UlE3?=
 =?utf-8?B?T0FsQW50NndiY3JrYjJWZjhzenFDaXViVVJHYnRDRklzU3ZrZllTMWNvUHBL?=
 =?utf-8?Q?qQWwreOWdfpWbW1MG8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR01MB7721.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEdESHAycFd6OElGMUlCRWM0THJCeWM3bkZEM0RINmpQMm5PRTZjM2pNRGtt?=
 =?utf-8?B?R0dsaStDb1RIaFpqWXkwSFV4NTRnMC9Bd2NyNTlzeHI2d25Jc2ZlUGlYODJt?=
 =?utf-8?B?MENxbW8xeUhRYWxrNXpvNWs0N3hySUZIeUxrYWpNVnpuRTAwMUZWekhNL0h4?=
 =?utf-8?B?bG1QQjNqN2JITERYQlM4MzErMEhCSG9lTUFUc29PVFBrZmFEcjkzZlZOQi94?=
 =?utf-8?B?SVQyajFvQlJVWVdOYW90bStPUlNmeE43cVEvOFlRQ3VETlV1b29CbVVDdGNB?=
 =?utf-8?B?cks5djR3ekkwTGtwdy8vZUxQOTlhTTF2ZjBHRGgzb0c0RmJYeHYyU2FCRy9S?=
 =?utf-8?B?eDlZc2JSZlJDdGNYU1FqSTZvc0dRdEY1dUg4bHArZ3N6dFNDTFJydkhJdGV2?=
 =?utf-8?B?WkMyNEMwcUtpUW8xZlBzR0pMbk5ROEt6d0MzYVZobW9iWHM0NFZNc2FqS09I?=
 =?utf-8?B?Q3lLS1IvOTNCd1pYQmJ6cE5McmU5UkF3Y1M0STVrUDhEUEtWN0NEUUthSGt0?=
 =?utf-8?B?KzBSR1h3dmJzeWFPZGZqTi9iQ3Y5bWR6cDZkaVREWnd6UlJHYmtFTjA3c3lJ?=
 =?utf-8?B?UDBmWTdpZVQ2cHNWbGsvdWRyOWQ1QTJsS0d5MGNIM01lWnBReGVKTUNNR20z?=
 =?utf-8?B?cHZmRE55ZjhZVTBYUHRsMmVveWkyK3VXTHdVWUVGT1c4NmUvQ1huaXovSnI3?=
 =?utf-8?B?Z21WaDVvSmx5U2UrMFZKRTFtVGRQdWt5R1huUUg2MTVERHJ5TnJnYUVpODFL?=
 =?utf-8?B?S3V0d2ZsaDhIdHV6UVdKSlJjUU9MZDlZa3BSQncvdDJxN3RBMnR5MXVRd2k5?=
 =?utf-8?B?SFpMWXUzWTFQcGNWUjFxNDRmWlpzUXlPckNjN1lWSXdlQU9FYW9RckNtNENx?=
 =?utf-8?B?SVM1dVprWkxwRS90TzlEdVhSZTRNQmRaR01tUjI2N2ZjbFZwRG4vU2lwWU9m?=
 =?utf-8?B?UTZuYUFGR2FwTGpNRlEwTzR2anIwZmRrdEd6cXV1WmpwRnN2UnQwRzIvTVFK?=
 =?utf-8?B?STJXZEhpRnA2MmdGLzdHMUQ3b2N3c0VtN1poWUNPdjNzbldEUEc1NFVzaVBR?=
 =?utf-8?B?VWNBbFFjTjVXUnZLRm5NdXR6ME52T3l2ZTJLWjFXS05IVTQ5OG1walJER2M1?=
 =?utf-8?B?aWhiT2RNQ0lDZCtsNCtDc0prRXpsUTdwaFhYQ0FFZmhycjlDUXh3b1NOeUhI?=
 =?utf-8?B?UHJqdzg1WTc5Q1ZDZnozVVJxVGpJc0RCcEw1TDg2V1NScGlYTnZBZXIxUXFI?=
 =?utf-8?B?K2pPNXd4SUhST3VYZU1uczZBR3kzV1pCb3lBOUkrbVY4d2VLc01MMkVxbXRC?=
 =?utf-8?B?QU9Qd0pSdlRUVkE4MEk4THpjRTZOUENTUUdmb2xUQi9ta0RqVnUvUUwzMnhM?=
 =?utf-8?B?aWVLSXJsNFIzSnRtU3FjUTZJT0J1UmQyaGU2a09KS1plQ1FrUVhSY05XUm93?=
 =?utf-8?B?ZlY4citISnpjRmVBRXdsa0JqNUd1bFB3MUYrMEtiZDRYS09ocFdwNnlUSzND?=
 =?utf-8?B?cW1iZlA0d2ViN0dCMGZRd21iUjVWblpOM0puazlIOFF6aWQ1OTRrdHVLOHdP?=
 =?utf-8?B?akJacUpDVU02ZGtqMkJiZEFiZ0tNd1BUbEszMnBrOW5HS1NOdzU0b1grbXI0?=
 =?utf-8?B?bTVrNFkwRkhKNXdyem5pNXZkL0kwU2NOUjlqUHFUU3k4KzVOQ1dNZGZRZk01?=
 =?utf-8?B?YmFaUXloV0crTHgzOEh5aHI4R1FuNDFNVmN1RnFReUZGNFgzRDNHWGx0dVRU?=
 =?utf-8?B?RURiWXJVUk5zRy9NNm11K3dlWUR5dTRoWk05Wm1sMTJ3Y3hnL2syQVZHRjF5?=
 =?utf-8?B?QkNBa1JLWHNBYnc4V3pCeVlnckJxakpSMHV0NDhTMnE1Z0lhRVQwWkRTbVNW?=
 =?utf-8?B?cVhnV3VYZy9qMVRLS21IRWtVVnpJc1czTmRmaVNjMGRkRlV6SFdDRjRaMWFC?=
 =?utf-8?B?YlZOYkxBYXJyM01CbTJuRDJWbXRuZTYzMTFINUNkREkrbm5DQk9CeWxxSnpy?=
 =?utf-8?B?M21YWXZIWlFkUjQ2ZXNMV1YrNGlYOVdSR2JESTI0MmliL1g2WFd5U0Y0cVkv?=
 =?utf-8?B?bWZ1bXRRdjZxTEQ2Y2xPMHcrVHJxZ0pJaHJFaXQyQnI1TEJZbkd1Y2xpUGhX?=
 =?utf-8?Q?pNxM=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59db5573-f526-4cbd-cde6-08dcc1475cac
X-MS-Exchange-CrossTenant-AuthSource: BL1PR01MB7721.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 18:39:02.3047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vu+4EWilIBwDiI6VH3m0ffQXdNQpNuQShmtctTK2aivl7za8ziOnGnxhmMsUjZm3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB8142

On 8/20/2024 12:33 PM, Thorsten Blum wrote:
> On 20. Aug 2024, at 16:52, Tom Talpey <tom@talpey.com> wrote:
>> On 8/20/2024 10:11 AM, Namjae Jeon wrote:
>>> On Mon, Aug 19, 2024 at 1:22 AM Thorsten Blum <thorsten.blum@toblux.com> wrote:
>>>>
>>>> Replace the deprecated one-element arrays with flexible-array members
>>>> in the structs copychunk_ioctl_req and smb2_ea_info_req.
>>>>
>>>> There are no binary differences after this conversion.
>>>>
>>>> Link: https://github.com/KSPP/linux/issues/79
>>>> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
>>>> ---
>>>>   fs/smb/server/smb2pdu.c | 4 ++--
>>>>   fs/smb/server/smb2pdu.h | 4 ++--
>>>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>>>> index 2df1354288e6..83667cb78fa6 100644
>>>> --- a/fs/smb/server/smb2pdu.c
>>>> +++ b/fs/smb/server/smb2pdu.c
>>>> @@ -4580,7 +4580,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
>>>>          /* single EA entry is requested with given user.* name */
>>>>          if (req->InputBufferLength) {
>>>>                  if (le32_to_cpu(req->InputBufferLength) <
>>>> -                   sizeof(struct smb2_ea_info_req))
>>>> +                   sizeof(struct smb2_ea_info_req) + 1)
>>> We can use <= instead of +1.
>>
>> This is better, but maybe this test was actually not right in
>> the first place.
>>
>> I think a strict "<" is correct here, because the ea name
>> field is a counted array of length EaNameLength. So, it's
>> a layering issue to fail with EINVAL this early in the
>> processing. All that should be checked up front is
>> that a complete smb2_ea_info_req header is present.
> 
> Just to clarify before I submit a v2: Is a strict "<" and without "+1"
> correct?

Maybe safest with "<=", because it changes no behavior.

I do think there is an issue with the test, because it is
just checking for one byte of the EaName and not even checking
EaNameLength, and similar for copychunk.

But these are pre-existing protocol parsing matters, not flex
array ones. We can discuss those later.

Tom.

> 
>>>>                          return -EINVAL;
>>>>
>>>>                  ea_req = (struct smb2_ea_info_req *)((char *)req +
>>>> @@ -8083,7 +8083,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>>                          goto out;
>>>>                  }
>>>>
>>>> -               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
>>>> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req) + 1) {
>>> Ditto.
>>
>> And ditto.
> 
> Same here, strict "<" and without "+ 1"? Or just a refactor to "<="
> without changing the condition?
> 
> Thanks,
> Thorsten

