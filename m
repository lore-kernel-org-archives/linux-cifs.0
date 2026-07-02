Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020141.outbound.protection.outlook.com [52.101.56.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C74381EA5
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007080; cv=fail; b=MQk4H7fs9yXuBfphmYcLGlkz5CHb8fBs8XYyLyBXKdGxURwhe/FDyCpVsslgRg155NHk8FBNC1imo0Sz76gp4wIKqj6MdqK1LzPrmR25Zbo0aiquRrAUglYWpApMP8l59AVglsp7XaycacDGO8A2O4ryJ+3EPFMzhTqfRgfIz44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007080; c=relaxed/simple;
	bh=Y4KnTEaPUwUBAvBFy2Pku3okCDsTzaVbwvGiJlFxkfM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hlLeLRofykIi7cuYbDH8qXJYaRT+XXBxGeCcZjEvVzAekB7F9QmPH8k8HAiPRoK9Md1qnHwIvjBT+ziaFE/vSG+0FPU3DEACOY03rV/s7rMWcsRjQ+xgeblkhyFU546YYsqmhIWedrrchKAVuYNA6Zl3mhBhYmB590PkU2N0mSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.56.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvaht2GTXq2t5/qXRi91d45jrjqiXHGbS6PIJMOT6kAYdAINGYrLPWJn8329hKdqAZUXGO4xti6OqekX4KHzGee6mohH1dONDX4EN2VqVndiOT5P9fnR0B1hQF9Yr5n6akJVEoKrKIYPWvjKtIPgYTGlWjqY17Z0+PPRC16sfIvdAK57NgRj79UXgDa2V1YoNvUS26IQPzHY1VWQuHE+jTYHadYO7C2NUwNH9QoZMjdRxs5pqDreoxULgrFtoluH76MQDZt/1tL3hzUZgYVBAxwcggAQglgnkdwL3Q2ni7uTyvDdh5EU17qljSR9qKaG1vhGxRxmf04wUkYReoKKPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0MAJhJNMMQR77JraaiQKtY8tHLAOcSbqAX1/ZwMm5Y=;
 b=shvgYhYdZg5wtAyE3UPPgitZ624pICf+4nbwfpDsO8oBnC6zrpqCsAJZFQrDqrE509dcaY301/bosiu13ffD2otsbO+n5paTsJpUp95dWkhkD/qJ3vQLnq89KSrgCxM1ciaaekQRDrZsaq5np/+UNQVXVzxVxPxI8q3a4+hlpvUdMjNAXWaHwt6aqblCXgHR/68h0W9ZxMFizWLdZHW24yh58/cYnEzMGYXMtgiD/bzWdyFXbKIeslMrZBH0qRT6RMfzGpW2wTfR9vJJeX6yJECmQUBx/UZkSsPan12VXr0uo8N/8rinnlBsh2c5xkuoJ5zEEI0ZaC4c2hxDhLbzDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 CH9PR01MB994745.prod.exchangelabs.com (2603:10b6:610:344::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Thu, 2 Jul 2026 15:44:32 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 15:44:31 +0000
Message-ID: <3a2cff89-2ad3-4b52-9357-b11fa643b789@talpey.com>
Date: Thu, 2 Jul 2026 11:44:30 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: Additional SMB3.1.1 FSCTLs
To: Steve French <smfrench@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>, CIFS
 <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5msQ7V9juC8nh2QMA+m=MD=u6Nb62j60Xx1EEDuRdkLr3A@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CAH2r5msQ7V9juC8nh2QMA+m=MD=u6Nb62j60Xx1EEDuRdkLr3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::31) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|CH9PR01MB994745:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0d56d1-2c85-4efc-3726-08ded850cee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|18002099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	PmzvJ+gAWvzVBS/l0vb+CyN3K5AkKn0ZVYcnOfnVcttFvmeT1SavHq2PW963ikoWoTyp499HCQp5q/QSp6u7UrDjR8vuMNsYBOu9YjiCUj7Wy5MhJ/Hg7Oz+FMNeeuwvZi2IqkBehxzSelfOU0BvtMOGN7TenyqKgafut27ZAFvAmd21iBnlSPztQcHiEq4IZpCtPHe6gC5WCPAFI3YB2eaUCDOwBz7KMObxpQ2Ycyn3JHLrwR/7jaJv7eVMqVfsHJbZ7ZT5zxD2jRDrczsxMn/1FlKb/+DQuc38roExFpS2h0rOYcLWjGGUVeiqmoCjIOgK+a/+q1XewPEXvsVA63Cd+IrdVCVPNKc3aJEsSg7+jAsFa5sE87KBEnIdkwdSk8zT9ZdXnUgFEJIwNTTFrjDVolclFoua7G2gXKom0yLY//hdbxgq/jm2HJWir6yAUU1Y9Zr5wHlfZfgG3svlk5DheiSAg4lm70EHAmi6unFrT+OH8sWIOLIb0cf7olsEOc+Y1jmVj5BHVbh9KZXotDzV8uAcCNaAJQsYxEqYL6mVHrDFjtH7hk2/lahorN9lHYdVsxGON+OJ2nxbsagJGsYKy8rvRm7kwbo0RKP3L0s8JQx0M2ZleNTOxWOpstKtom/ze+J48p/glRFqnaPnawMwMPBdMH9GF9aw1ANuhKU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnYzbzZXaGN3K25lVkRaa1BMYzVMM1ByY29EN0t2dm12SHpnY2JScFZEUS9M?=
 =?utf-8?B?dFpYMjlNa3prV05QSVRDbFN0MUR4aEJ3c0NCU3NZcXZSTjRYL3hPdWFTQ3Fs?=
 =?utf-8?B?TjJyaWtwYzMxL3BtRzRVZzJDcm5Pa3NOczRYZFdVUWRpcDhneUJxTnRMdnEx?=
 =?utf-8?B?U0VQcC9XSVcxWExvUTNjaWZ5ZjR0Q1JmZjhQbmplajNRNGhBeFovSktod3kr?=
 =?utf-8?B?Ulk0QmtUbG1wbUtaaDdMcVF3ZUNKMnR6ZlVqY0FJR0RJWlpuQ3VYRW9nMC9V?=
 =?utf-8?B?MzE3bUp5UmlrK3JKbEFQNWpjYWZWUWJKYlp1bWNLMWhaWEd4M1JoZHVLN2Jw?=
 =?utf-8?B?ZHVBOFRjVnRGd2E5MDAzajNxamFYeXVFM3FjT2p6cmFTMHJuQmtUbFpQakxD?=
 =?utf-8?B?SG9YeW5tQjFiajVPbjRWdXZFcVU1VS9OUFlSYm5MT0QrWkdRZEVyVk5OY1VT?=
 =?utf-8?B?dk52L3U1Nk5qNVVWL3Y4SDdjanUxQmgwR2FGYTBYQ0FqSjlpZkdQWksxYVFR?=
 =?utf-8?B?RFZjbHNRU0JvVFNSYnpIZnZ3aGgzdEtpYVp6RUFiaXhmTlBMVEk3ekFOR2pX?=
 =?utf-8?B?RHBjTVhneno2cWdOaG4vcmx6UkcvMjhXWmdkdWdsVThIZGFwbExUTXlKbGhZ?=
 =?utf-8?B?Rk9BQVRYRmRkajlpUWZzcXFzcDVlakZvOE9wZmRmc3haMXpJeUJmU0VpMW9s?=
 =?utf-8?B?bFBpVmZva2F2M0RvVEQzT2ZMY0VRdFp5Q2lsRHdkQ3lUeDBSVUxqRm5PR0F2?=
 =?utf-8?B?eEwwMkRPeE1FaW1HV0x2MXByZkpmRG5RK1VKMncyQ2lnVDZIcFpDa0JpVUZG?=
 =?utf-8?B?QXcwOEsvNWtVb0lBRDZWcW95YVdjcVdOOGllTWozVklTc2djZitsQmZEdTV1?=
 =?utf-8?B?dW93dFdhWTdQLzRpY1g5c3RtLzVNQ0Jpa1BXZXdVeWdsWStFZUlHQUhzL1cy?=
 =?utf-8?B?VXEwYjB3VUpDbzJLSUtBUmR3bXpFanA5T2IycGdKaFplVmlFTFJVTFZRRUNs?=
 =?utf-8?B?V0JpY2lmOEhwN2hWSEdWbFArZUQ5UVRmTXFIN09VcEJCSmFwRnlTTm5HSC9s?=
 =?utf-8?B?cW9GMGUrbmZxK29RNXNtSjB5NExwRCtDWUtGazBzMDMvT0cySUl1WTc1ZDJm?=
 =?utf-8?B?RVAvNm5FZ0ZTZnE0WEJHNy8vczNlYWltbGxMMFJVVkJxeUVlUVZxSjB5TXlI?=
 =?utf-8?B?bW0vRTNtT2FkYzdOS0xrd1dwR0RDNlJ6NEtKVjhpWWZNTnFVQXNjL0xvRWhk?=
 =?utf-8?B?NVJvZDJwSWVSc04zcW5ZUEREbklDc2pidi9nMFo0Q3Ntb1VYS24rMDFSYVNs?=
 =?utf-8?B?VTVsWndVK0ZUK2x3a0FFSUNWS2VrRHdIZjkrdkxYcjJKL2orQktxZElEYk1F?=
 =?utf-8?B?WGxiRGlXTUg3bFgxVGxGMTk0RVlTTXRKRm96MVd2dVFSbE1zYVA1SEU5M2Rk?=
 =?utf-8?B?UEZUdHZHYThMK0hsaEpzKzZjZ3J3QWcvbjVPUjdXZnMrdzdld2JtdmtmQUho?=
 =?utf-8?B?d2ZDU2lLQVoxakhLZkxvOUhoZWJtZmxvYVIzbWxuNU50SXBVUkNZTU90WlR2?=
 =?utf-8?B?aHVoS2o3bGJyUEVReEk4dWRtZGxJUThyUSthTjZZaGo3NFMxUDhiaDU2UjVy?=
 =?utf-8?B?TUx0dTkyMTFpQ3dJYS9oY2hlSmtLU2lkUWk4WGJ6ZExYMm90TStGMGxmNTAy?=
 =?utf-8?B?RDE1aWJnbk10NHdMdmdzYUhaK1lFWEJ5eDU2cFFXRGFGT284Nk9tS1Nray8z?=
 =?utf-8?B?NHJvMXFQZk5YQlBkVkRrT3NVU2E5ZWtUenR0cHFldmVQN2JmbTdCR01zNFF0?=
 =?utf-8?B?Z21HaDQ4TTVGYmhwN1dUaU95cWZqcnV1bFgyQVNrQ3pnRGVYdmlGTUhPYjJD?=
 =?utf-8?B?WTJuZTB2dDdoajJHa2dHOTg1VTRVdmN5M3Y1cU11V2RFYmdLS2RmQlphVUVV?=
 =?utf-8?B?cFIreEp3eXpZbFJCR0pJaDM5dXhSNm1nYkhvMXdLOTFoak91UnpvekVFM0M4?=
 =?utf-8?B?ZlY5SlpPTVpZT2R3VzRoeFBjOTZmMkwrWCtCNmtTU2VHMmRGYVN1SjN2MEZq?=
 =?utf-8?B?aWhVMzdQRXpzbnhIMXpaNEFqNTJNdnhVS21ZR1VlbCtmcjhCREFDTTBLVkxG?=
 =?utf-8?B?ampaaUo2SlJ6bFkwUDVyWW9sclFtdGhUVXFqeW5SY2pVMDM0VHdZeXJlcTJI?=
 =?utf-8?B?ZThnVk02NWNoRzg4eEtvcnlFYmZrQjQweVI1cmEwTDljbGVkQUZjcUJaQlRa?=
 =?utf-8?B?SStlSFJoUThvSEZrUXhyelZEaUZKZWlnSjN4V3NwMkF5c3ZHY0hBd0l5Rm15?=
 =?utf-8?Q?q3YoWfwVoYrWLEIo0v?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0d56d1-2c85-4efc-3726-08ded850cee9
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 15:44:31.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU73wCjID5l92sn53QEqLLnCHCNJC+dRKPcLRLOHHVDZU/88r+NEFu7x9tYJ736M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR01MB994745

On 7/1/2026 6:41 PM, Steve French wrote:
> Looking at MS-FSCC, I noticed some FSCTLs we don't use in current
> cifs.ko but Windows supports:
> 2.3.13 FSCTL_FILE_LEVEL_TRIM
> 2.3.29 FSCTL_GET_RETRIEVAL_POINTER_COUNT
> 2.3.41 FSCTL_OFFLOAD_READ Request
> 2.3.43 FSCTL_OFFLOAD_WRITE
> 2.3.55 FSCTL_QUERY_FILE_REGIONS
> 2.3.63 FSCTL_RECALL_FILE (maybe add an smbinfo command for this?)
> 2.3.87 FSCTL_SET_ZERO_ON_DEALLOCATION (maybe add an smbinfo command for this?)
> 
> Do you see any of these that we should be using in cifs.ko or userspace tools?
> 

I'd be careful with these. They're whitelisted by SMB3.1.1 but they
are implemented by the server's backend filesystem and storage. I would
not expect third-party servers to support them routinely. Also they
are somewhat exotic, that is, specific to narrow scenarios and apps.
What Linux API would we expect to use/support them?

Tom.
