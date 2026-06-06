Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022102.outbound.protection.outlook.com [52.101.43.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2912F5498
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780761184; cv=fail; b=dGEIMmpXJr5lVvdmiBQ04uq2b5RICFfxTuubDCgV8e9cW38P+D1JUx0xo7S+92S6zDVHqjwoib4YIOlcOFNNMIjuf3n5wl1DzDV3ghCpEQ9PB9TosywVbYkAtDVXK/Rn2fdtv/aD+wxQxOUhNcNv5hMDbO4ydPz1lRedFFMnUsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780761184; c=relaxed/simple;
	bh=3bCB+Nzp4WztbVuyoqi3IC8bjF8AbUWHFkOyWpGeOWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MZflzZRsFBtvaznHXZu8QijNVr7wLAaOyIG40ziesEOgU91xLUgmah31pW7g1VHd4405sJsLQvLWHJWf7nfGzuw9NjIYNJSYsS2Vn+YgD/BFiFlAIQY9A55vvV17sOd1oIwRHVJqa55DFoCGxI+jzonm2iTnYiOXnOC/NY882RQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.43.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O3UM0C402aiPKEx0YQqlhb2AZ/XcOtGfxORhyViNSKe4gIINnfStIkJQVgHM6H15zfFMaJjJ+vo1Ic404bGy6nzYx9FPFmXee2ICcbTRfo9AM8MVu0tTryzo7XLa421JEJ7YpOML+6wFJ8k8a/jctPrAZOVtTyQCrcCdXcZbGJd8wEBphZgaStL6SiOR3XAy0Q4IdBGxNlGrKZaAEK1EZqtlzkPhazSmpR0TVMls37WnH0EuSPaNPzXnLCzrHZ8opcmw4qpaVKstJJ7UmMUdMBwl77v1h7uG3r4g7qcaOkL61xg7vLrvt2M+vCnXg+PmPWMLbKfdyJpf83i64w9MKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffkt4fBa9p6L+0IY1DGT9bCiAamkRnW0V5MdEL0ZINE=;
 b=j23x9TFZO8/85uDHkM9v7/BdS8GVVFpKLoTMsVLzoowV0+0OwvyBXQUQuxXrHO+hkVAg+kYCawgMvrA7UXqqkibaIysMXElaC0DRfHhw4HuL2CsUuZVTDAjMylRWHWjOF6xYY5Syv4FFZGCt5S0zboItdDj/3tg5iNAEmg/+jDzS/AYgTD8anaGQUUx/CZGHEwurqBBkM28M0VbZrJ35GYuckfXM6LgBfAMGoxtSz3+x7aEe0zfZcBU5T80yF2OReOIwYO30SPoZ6BRnN1Y92ZRVlb7IeK+OJUF8t9cb/SJ1pipJWHoTN/55RwDrbJq3Ad89pHmfBmdMuPKKfi1xgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 SA7PR01MB994295.prod.exchangelabs.com (2603:10b6:806:4ce::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.9; Sat, 6 Jun 2026 15:53:02 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%6]) with mapi id 15.21.0092.010; Sat, 6 Jun 2026
 15:53:02 +0000
Message-ID: <d53829b9-5e8d-41d2-bf3e-4c33208bbbee@talpey.com>
Date: Sat, 6 Jun 2026 11:53:01 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
 <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
 <13768420-79d3-46ba-9144-c517f47750bd@chenxiaosong.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <13768420-79d3-46ba-9144-c517f47750bd@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:610:76::6) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|SA7PR01MB994295:EE_
X-MS-Office365-Filtering-Correlation-Id: 72d736bf-fcf7-41dc-add7-08dec3e3b0c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+XLmCrto6vmEO35/C5iPY5182uU3N2Zt/HYCBZhNGYNCsal0HpOeaq9Rh91z1ZGv0wdrZKZ1yQTVS1sy/FR1W9KFtu+NRutACZHv62U7ONEzD5mJQ+AgBqXEysT4nru+g0nnpnwVABPSw63YdfmpVyAawAX8BzYD3mdPeMpjKv1S4gTXw3M1sP0lbZ7D2C43shnaBq/zbaU7N5hzpt91aExXJB7wNvPYL/YcSpM2Ys9au+x73DYjdqcYmfAXmvROOjBWuXjVL98cHHNOsEWTtedFllMTR+eRe4VmCahAUMECrAWfLS2ZwtxNdDRMfrS3BNzI3EgpgIQNptqZK10v81YhCImPQai0pt766LHA6BtFHp6kV+pjlaR53mHg212W1OrTYRavHyvmNbgsf1d6RjZCzdm/KjquSML02Se6x8uQpDueqN7c9i469SAPZe53fNXfO0JKzWM5LcmJZG/kwPvKheAkWmGFhphr0TrjRLga77oYvGLJ1598bRKWnCPihjzf1kJDg6q+t6CG+bYuhKcA2qabYMtdbGLODkr8oicPmw+Jy+t49PY4BolsCsPAt37Y9SK1oQ5K9Y5uYQPOp3PXkAwk0b8CFAPKkQPhmql0EZ5nPnaewqztwWHlZKck7C65RUU7lg3NxQRwXgFHYAdTiHNK/jjupacfwxU+AFVGE42dhPFS1OOKU7WtSJU2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDZLOFl6ZEFiaWc1SVV1SFZ1QjJBbUxGeVB0cnBpZFMwdVRyZ1NEMGpiaHZF?=
 =?utf-8?B?ak53Tjc5M1NYNTIwSTlzb3dsK1VTSWRwdHVQYjVKL3YwYktOc0FHRmZ1T2Jh?=
 =?utf-8?B?bmVrN3BmdW4rSjYzcmYxbU9zVDhlRUp4Y1pXT0NxV1JleWNCWVBvNFNMUjMw?=
 =?utf-8?B?VHZzbWc3RHN0OGFXVysvRXBKM0xDZFVPbVlFT1QvRnJ6VjlNazZ2OXBkSnFI?=
 =?utf-8?B?MjBlUUtmaithb09zMWw4c2oxTmxBU09ueVBRU2NiOXRWTmlHS1FpMDY3Z2Va?=
 =?utf-8?B?amxVTExPUi9UNXREekU5YnRuVzN3RGJVMHJQK2dUNHlrWUFGM1NwWmtsbGpm?=
 =?utf-8?B?SHRVMVJXTkUyakEvTGZPckFOTm9BN3dFb204SUdYcFNwT3g1Y0hUc25LSTQ4?=
 =?utf-8?B?eHZ2T3VQcExPN1M1elpZeDNEQ1F5T2xrdmhRUHdFWFJPT2VGS0xzNEZ3MzJn?=
 =?utf-8?B?aWRlbFVqRGRpNXdxKzUzSk5oNlk3VmVLQUxEbStLbHFpd1dCRCt4cDhFNXlz?=
 =?utf-8?B?ZU9qN0EzUlhSMXRwdlk4a2tTUTU0Q3JINHRIUTlpL3MzMG5nRy9vNGZEbUNZ?=
 =?utf-8?B?djVPVlJyQ204cUh5VmFVQ21oUkJtSW5RbmFHd2F5bU4xelZSQ0dBa2FMa281?=
 =?utf-8?B?Ny9uTU55ZDVHUUNpQ0dEbFRxQm5NMUNUdTNkeE5jS1BxWGFKeFRXa2hxbEJX?=
 =?utf-8?B?d2ZyMjFYRmF2VHNRRi9Pc2VYSW54b01PK3pZMlhGMGNUMU1hcDFYcjBUOExM?=
 =?utf-8?B?dGJOc1VZcWw3R2MxelI4bU4vY012RE5XN3RTOUdoaE9ENWRrODJsTEdOZDg0?=
 =?utf-8?B?ekJqUUtNeHVFMFBHaTdiR1czK2lmcFo4dzBiK1o0RTNEcHFQNFJvdzRRQmZP?=
 =?utf-8?B?RmZqaTE5Q3BWQm9yWFZhMmsvRStPWXJTT1JCb2hCVk0xVVNyOEY4VVVHdjdp?=
 =?utf-8?B?Si9NcUxmdjg2ZkVhVk14ZEdjNlZXbkQ4WGN3NTdTWWRXUGtrZFpTcmRZM2w1?=
 =?utf-8?B?WkNNclpCdlFjTGRwRGp4akZ2OG9CaTVPUEhjOFMvVzFsbnVKdkY5dXRyNVRk?=
 =?utf-8?B?NE5QdFY4aWVBcHg1SVpubDVIZmFTMi9qMWZwdkZPR244STRCN21yVEZ5c0wr?=
 =?utf-8?B?U2pnU1FTeCtESTVzOVpPcytabElUU1YraXV1NUZ1dzJrMHpETzJrQUJSalBQ?=
 =?utf-8?B?dmRMZzJaZXlsVitGWXI2L1A5Vng2RDZkaHQ4UVdQQ3hqYTh2ZXM5dllrOWR3?=
 =?utf-8?B?MGtUQUdIamUvMEVybEJPK0pqRlQ5eWtCUWZmZ09oaDQ3WWFLbTJTdmVRMmlC?=
 =?utf-8?B?RFRqdDhEVmxoNmsxM0FaejNGdnJDNDdxa2lvZ2trOERudU1vcGUvN0FDNC84?=
 =?utf-8?B?RWsybVh1MXZoRUVFa1UrRFo2eWtRcG1uRVJOWmYvYXFRYmpSNTFHZG5KalFw?=
 =?utf-8?B?Mk4xWnVmZkxsWURvWlBKRW45b25BRU1jTkYvSTZ6SE51dzhNVWpuMzdVR0Zi?=
 =?utf-8?B?ZU1vVTNFbGJFVjB2VlR6MlR0dmpKV1A2amJNU3R1WDBNS1pOM04xaE43TDB3?=
 =?utf-8?B?TnNTaUQ1cUNGZm0yUFlVbE9oVkNtelFzOWV5UHZWN2JMWS90VHN6T3pWOU9v?=
 =?utf-8?B?c1ZMbEQ0clVxREpVbExBdlFGQXp2ZXIzVnFLYUs4d2FFUHpVaUljZ0RCaWk2?=
 =?utf-8?B?MDQzUXlhdENPNWpOSHFEMEtPVWlVaW9VbHlGenBoSnZvYnN4UGViL2JmN3Zz?=
 =?utf-8?B?TFVYQm1XTXJTQ3NLdGVSNnVsU1R1cERBcXk3N3czaHdBY1g2eG05OUZMZjZZ?=
 =?utf-8?B?aXpyRFV5cS9XUXJoRTJpZi8xQ2phU2pIMmRwbVNQNnF5LzQvYzFzVTFZV3h5?=
 =?utf-8?B?QUNXOE1MNG1WSFdWUXFMajZmNFE2RWRXMk5CZzNma2NSVnBaNXdvV3oyWTdm?=
 =?utf-8?B?YlZJalV0bnFjd3AxejFsQ1lGS1A2bFpuZHZBWlJDZ0NMc1VacHBpa0RieVkz?=
 =?utf-8?B?a04wV0Q3YlR4aDlMMXpOajc5cFZVakUxOEVDMC94NjhVb1B6bmlVWGt2Q1dr?=
 =?utf-8?B?b3VhQk4vZ2ZkYlYydm9wazR3WlRaRGlkM2FPWks5ZjEwM25jS2YveUhscyt6?=
 =?utf-8?B?UFMvdmpwcGxGTmY3Q0tGOStHeDRyaW9qUHpyaU5IYTM0MCtnS1BsRFBubng1?=
 =?utf-8?B?dWxXUjlXcElQMC9mV0s2MjBHR1lVNmU1REpnRVNKeGJFMzdTYm1rNWtQZWlM?=
 =?utf-8?B?YWJsWE5vNGJ6NW9UamIxRWJNbDZSTEpaSXRWcHdyLzVobXdRL3NVMjFPb0Ns?=
 =?utf-8?Q?YWtfS/4syn24RKXD3R?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d736bf-fcf7-41dc-add7-08dec3e3b0c8
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2026 15:53:02.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utCbEvc/k5mt4ZAiWfiQY5BfBA6wuOQRxO7w3vri60prpbOoJI36W9156u1vslHG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR01MB994295

On 6/6/2026 11:21 AM, ChenXiaoSong wrote:
> I will update it to use LZNT1. Thanks for your suggestion.

This thread has forked badly. See my other reply.

Bottom line - servers must never send DEFAULT. Clients may
choose to.

Tom.

> 
> 在 2026/6/6 23:15, Namjae Jeon 写道:
>> It seems possible to get the file's compression algorithm format or
>> information via ioctl in f2fs and other filesystems. However,
>> COMPRESSION_FORMAT_DEFAULT is not defined in FSCTL_GET_COMPRESSION.
>> Isn't that why it showed up as UNKNOWN in your test results?
>>
>> 2. client: smbinfo getcompression /mnt/file Compression: 1 (UNKNOWN)
>>
>> My thought is that if the file is compressed, it might be better to
>> return COMPRESSION_FORMAT_LZNT1 even though it is not actually
>> compressed with LZNT1. Of course, we need to test this with a Windows
>> client. This is because I think FSCTL_GET_COMPRESSION is simply a
>> request to check whether the file is in a compressed state or not.
> 
> 

