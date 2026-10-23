Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.127
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792781534;
	b=nPK/qejXrvB/oXdWiFc+W7qnGXnUN17Ldulga5Ae/+97GJOG4mrEsIZhyWDn/BDMiKC8
	 GJaRos9odGe1we99OGS+BCW2WujJ7G+C3CkZbSH4M48VNh356RTsTmqFJ7BskMjC+PhSL
	 1tcs6kI5AoEBgW7nXt1z6Mce90unqbFxvsdL+ukWLY29DZEZY4ym+2Dfsc8aKRhgRDyDc
	 /lurpX/ngd3YQXIK+kxZUPh24m+BuVaaxpVCBJuI8Up8SeAV19UDyFIv+EV1DC1YwVe47
	 npLmNF9A3YjJMln5zSiELCtKWnXX2P9c7EE3qR8HzF+V3Nfp90CRbEeaBBJyYfz8Oqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781534;
	h=DMARC-Filter:Received:Received:Message-ID:Date:User-Agent:Subject:To:
	 Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=WJOs+BTlzQVMmi/HKGEC/dSika4KICY8lD7aXHQq1pQ=;
	b=rQ+GQwysAThpe/ouo+f9EKJaoxoczkAWzETWOzjQmASqVxoUcUUWICUAo0QBSK6QRUJv
	 pbMFmCmFAq1i96MCeAnk83AdeBcug8gkRvjMa6dbT9QXtdeLQW/JVrV/26Y0nnNrUuyQq
	 xmtQP9Tc47XFtgrtyC0jS3retnePFHB7P/3uyL9kG7R+nU1mI7B43T+YP6+47ibyzhQoF
	 L6HWJC72AnprD5pPaZVAaPHLVmzxapFeyzfZL3mrUBL8jivT1d7qjpYcp523Es423oJcX
	 SS0TLCeM7CjIRDwLiNC+ZycLQCGu9ylSblI9eFQZWqzsVLaCVw4gMOStIHosgqUBjuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=talpey.com;
	spf=pass smtp.mailfrom=talpey.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.127
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022127.outbound.protection.outlook.com [40.107.209.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68CC606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 18:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B68CC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBVEGEMYz3bThqFPhlY+RP/5xHHMeR30Qy/bBvX+DCWuTQayRhQ085Lf/U+xKDpXpw9Wg5zifLpLwmRgqyLsyLAtH0ujXgUHL8HiljrgCyg5hVdXebAC8MsBuCxoVQrnQA5eq33OzKoBqx/oqWr73MrmuoE/9WGhsNSXrDhUQsUEhRdiVRS5RIr9i3lCQymi38os/2tSdW17mJlk0lqA5aXW+ZdyNxfuiYsV658Gh/Vdd1oCMtphvbMYlVu7LqDvNHeqcaByOb3ldMZbm4SxT8orP2JncMETgIF3qXIHjJvVtQcsGXtz/4HCdwdy2oOPH3klSPSbzIfToaQcEo4hqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJOs+BTlzQVMmi/HKGEC/dSika4KICY8lD7aXHQq1pQ=;
 b=BCR0xVaNhH4vrK3ddpUWrE/fmD0v4mW+T+htE4QsJ6EgOribE014+3lPkaN1Oaeveenmas63IOkGaAovuDjIBqO9lS8HED79BfEsAJ/nCVNiInoNngQoFgTgIgJReB4okHv49eX/w9K87ZU5Pt6fry6G4cCVKNNIzNH7pOn0ake5egXitt9nqmXtrRPoXJLU2z6mMYG/T251lWB44rkZPFawfjLXLS8U9itgRurshifhCypTVvAujHjJQGf3u3ZkKZTp+d7w5zRFH/ne1/cwJtynt/VlLwfztqC4ywJ/K8ICWcHwTOEhOOgX7jDY/Uxs9cho2nhM3pEZHgubYfoYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 SN4PR01MB7408.prod.exchangelabs.com (2603:10b6:806:1eb::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Fri, 23 Oct 2026 18:52:06 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0569.002; Fri, 23 Oct 2026
 18:52:06 +0000
Message-ID: <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
Date: Fri, 23 Oct 2026 14:52:05 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: AES-GMAC signing support?
To: Enzo Matsumiya <ematsumiya@suse.de>,
 Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <atugaviJxR8nzHQO@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|SN4PR01MB7408:EE_
X-MS-Office365-Filtering-Correlation-Id: c2704a0e-d17e-463b-421e-08df3136bc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|261009223027099003|56012099006|10067099003|261021121427099003|6133799003|18002099003|261021135927099003|22082099003|261022105027099003|4143699003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	k9+Pvpnli6fWN6rFpw6w6wa3BWDcJwSXjjCp207b4X7GoXJAZfvst8OwP2jMAXD+yuLTUTG7TUsgsTTPCLrlWTW8i1pdfChYns3Duv0aNHGyVvQmegf8fdfoNmlxF5/oSVdGLBDzoAhomOB/rOJULT6Vf83m5shEaCqlzrx8xM5riH3JKZUoxRtv2j+4zBFMLITjk5rGb2zkh0KSEP7bS3snV6XYqe1a7qUQIYGnI5ab0Lf0mqEUbRQbN4N5Z+IZZlTNP+KUn61K6VGUr4BO6+VZdAHI0Rzke+OR2NQ96I8VEej90MACoB1h8vOd+EDHFCi/1j1i9AU+SxJoG42CwhOfHX4jobkmksK2Vi4sJMNdOiTl6NS2iuaQFgG4t7Z5XlPmgelqt+jbkNbST46YTeLTYx7Jc/8PByHRM4R8gEZ5r4wJoG1xG2Hq71Sduo0jwYlvDWMGjGEbGwNF4U0YFNvyuAF9EAeft0zGlcfRM6G1gCI297ofOfJ7RB0QGoPARdEfdxrtU6b9hVVuie6QBp09o29WWJYntUZetXg+tHsyAQMC72/iliLTfQZy/M51PsZy4Kh7V0pn/HQRWJfWrQA9aaF0d5N1OFY9n42tE4lbiZWSHG3F01CGR2q2tEpySQykYhIfK8+y5p0ckbN2KSsMUj29jkzKPfhU0eDgj3o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(261009223027099003)(56012099006)(10067099003)(261021121427099003)(6133799003)(18002099003)(261021135927099003)(22082099003)(261022105027099003)(4143699003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SExaZFNiRGx6NFdMcE5QdUJoRlNVZ01vYkdyNEJhRzNLQktKREhjWk5PeVRx?=
 =?utf-8?B?K1lGTnlFbzFSOC9lOE5kQ2t1Z0huZU1QcE03cTltV0lvcnYza005YllheS9N?=
 =?utf-8?B?ZkJaMUNNdUZ5K2U0VS9yRDlIRHdHc2VZTUdnRmE3LzhaTXJSaVNJNnpPUHBx?=
 =?utf-8?B?ZWtMMDB5N0FhZkxGbG0xWVRrQndJM201Q214b01qTDE3MUVSR0pETURxeW9O?=
 =?utf-8?B?cGZkeFZRS3Y1TEtRNVFQVEtFaU0rSnlLNUxyN2E1MkxneWFyVGMyajA4b2h2?=
 =?utf-8?B?KzdtMStKTlQxNXpqR2RhbVdISUlyN3lIT0NPdmJMZVQyR3pmUnNya2hoU2xn?=
 =?utf-8?B?SHc1dFcvUC9sVkxjMWxjUzlYNWR1SUo3U09Vbk1JRU9CemMzQ24vU2Z2aE83?=
 =?utf-8?B?QUtHK0src2xCc3FqUGNnSFBFcUZPVEk2K1ZrL0loZTlRVGYzR2taMEsrVTYz?=
 =?utf-8?B?V1E2aWtxalY1aGIvMURRYzV6a0Z6azFLcHorZmx0NzdscTlHcDA5d05pY1Iy?=
 =?utf-8?B?Qi9PTmNlMTl2aG81bnN5Mm9wRDhwU2RIZDJFQkpaalkxRHFtN3ovaThHT3po?=
 =?utf-8?B?Mys2NllnK3M2NFhlK0FFS3J6cmlzZy9SYzJYTjFGYTVuaEJvcUJrczlhRWt5?=
 =?utf-8?B?d1RwVUZkcDBiajIra2JvdldLTVlYVlJEdUp6VjRjYkdWc1ZueDVDYmgzeWdO?=
 =?utf-8?B?UXdXc0dpWUxmclQ3KzNzcVpGQnJ1bm9OL1h5SzRneGNSNFM2b29iK1JIWXpt?=
 =?utf-8?B?dGxzRmEwNWc2N2l1MEdwTHl3czM5YmEwYlEwUld5WEZ5bkpUZnVCcVl3NkJv?=
 =?utf-8?B?NDNDSytvYjZqYW1KaXBOU1NtTDNJajFLUHpEaFlaanZ5RGRTM1BXWjNBMUR1?=
 =?utf-8?B?Q0VTa3FScG5SZzF1VHpDUmo2NnREdE1iVDQ1empFbkNLTWRITWpidnZRZHI1?=
 =?utf-8?B?SGVwKzJjeStTUkd4R3hIVmkzSTk3b0NnclZUYlZneUl0djF4VjhZZHZCMzgv?=
 =?utf-8?B?WFBLcUpTdkRJR3B0Tk5ZelkzVWlPbWgzNUcwcENSdzEvMjRDY1BlS0JnYlNj?=
 =?utf-8?B?WHRIV3duNk1OdjA2cTE4c2J2Tk9aWU0rSXdqTmdyZ1pWbld1dDc3OElIc2xH?=
 =?utf-8?B?U1NsTCtvMmVkWjljcExCUEhrT21tcmVrMlMvR05nYXdXR2FTd3FGd3dsSUZF?=
 =?utf-8?B?SmE0T0dBb1lneVhTa3pUNEtmQjNoZGVqOHdiVEMxRyttQzMzVlVCeEhYcWJH?=
 =?utf-8?B?UFRhTW80TVU2SXhBY3grMGtYTU0ydmFFVFU2UFFWM1pSeWw2bUlSalk1eTVi?=
 =?utf-8?B?V2Z1aTVZa3VPZWF2cXVISWQySnFxVWVsTDFHUUFpWnZNRy9MZnEvcVhTQVpU?=
 =?utf-8?B?cFNPSDgxTEh4blJ6a0xKLzdidVlaTGtIeDlJTmlkZ3UxRWhETldoR0cvdlpM?=
 =?utf-8?B?NVZnRzJ6MEprbDE0RWRoUDhKKzNjNXpsbGs2bFVMb0dqUXI3NVBUMHFnNkp0?=
 =?utf-8?B?SkZBeDNmaVBIMWZJb0YvZ0syQVl6S1k3TUpjOGVFMVZXQ2FjUUFmdHJQMTNK?=
 =?utf-8?B?Q1VKTVpycXhRMDNDM2xjWHQwSGUyVDhkZzU3NWovQmZ2VDZpTlMxVmRBRFY1?=
 =?utf-8?B?NS94a1U2ckQyazlnZm45Y1U3N0lwNkJqZzN5VVFhaUJweFYvYldtS05XOHlz?=
 =?utf-8?B?OFV2eWVETVc1ODcwWWxuaXpUdGc5WFBDR0Zzc29YNzVHWDNVbDBseDNYbHJQ?=
 =?utf-8?B?RHlZemt2K3RUcEpLeUFoSDBtL05SWndBdWFxK3ZHQUxrUzVUZVJndmxHbFVV?=
 =?utf-8?B?WkpRdEtZMlhBM1d0c0o1TFF6eVRxdjBETUV0cVE4VjR3NHo2YXphMWF3dU9k?=
 =?utf-8?B?eVY1RWlaZXpZNnd5NWdtUkY1L2xhQkJHU2RFUkxReXFWOFVURjZ3M05aM1NR?=
 =?utf-8?B?R0NJdEVlTU1CUXFGS2gxbzlGQ25NeTNOU1d3REtvZEVHMkNPTXhFYU00K2dX?=
 =?utf-8?B?Vy9lL2F6Q1cwMnJyMktVektYYit4amZYZnlBQWZQZzVDVTBzWWhCbkN3U3l5?=
 =?utf-8?B?L2psWnN6b2tGdnZTTzFoQ0V6TnNSUysxU2d2V2xpSFUwZDhzNmV6U2lyUTRV?=
 =?utf-8?B?dGxqeCtVaktxakYxeXgxSXliNEtCTE80aWl3Uzg4ZkloUWFwWWYya3dBejkw?=
 =?utf-8?B?cU1iZnVWb3FiUUJBaDY5K2ZEY0lqUXZnQ1lhTktxT05BWXArOHU3Vktma0M3?=
 =?utf-8?B?L0xvaG1kalkzdXBOY0JlSkFMZkRHb2haclRmYmhCblF4WEI5emhGQVAwU2hm?=
 =?utf-8?Q?W48AuhgTFzpwnYplXk?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2704a0e-d17e-463b-421e-08df3136bc02
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 18:52:06.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nckd/6WeoITOpXhnSYL8jOwhzF9gqSXUNG/oaGGeyb/SWT4+oI3TEaFAw1yOhTZ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7408

On 10/23/2026 2:24 PM, Enzo Matsumiya wrote:
> Hi Michail,
> 
> On 10/23, Michail Andreas Michalopoulos wrote:
>> Hi Namjae,
>>
>> ksmbd currently negotiates HMAC-SHA256 and AES-CMAC for SMB 3.1.1
>> signing, but not AES-GMAC (SIGNING_ALG_AES_GMAC is defined in
>> fs/smb/common/smb2pdu.h but unused), which is what Windows 11 and
>> Server 2022 clients prefer when it is offered.
>>
>> Would you be interested in patches adding it? Roughly:
>>
>> - accept AES-GMAC in the SMB2_SIGNING_CAPABILITIES negotiate context,
>> - sign and verify with gcm(aes) over the message, using the nonce
>>   from MS-SMB2 3.1.4.1 (MessageId plus the request/response and
>>   CANCEL bits), and
>> - keep HMAC-SHA256/AES-CMAC behaviour unchanged.
>>
>> I would test it with smbtorture's signing tests and the ksmbd CI
>> tests, and check the existing signing paths against an older Windows
>> server I have access to.
>>
>> I have exams until mid-November, so I would start on it after that,
>> and as it is a bigger change it may take a few weeks. If someone
>> needs it sooner, I'm happy to leave it to them.
>>
>> Before I start: is anyone already working on this, or is there
>> anything you would like done differently?
> 
> I did this 4 years ago for cifs:
> 
> https://github.com/smfrench/smb3-kernel/commits/aes-gmac-v3/
> 
> I never sent the patches because my tests [0] showed that AES-CMAC was
> slightly faster for cifs case.
> 
> After talking to Steve about it, our conclusion back then was that such
> non-negligible overhead wasn't really worth the code change [1].

I remember this discussion, and wonder if things may have changed.
Windows certainly prefers GMAC, and refreshing the numbers for Linux
(especially on ARM64) should be part of the discussion.

Personally I'd love to see this work, if for no other reason that
it's not about the local benefit, it's about requiring the peer to
implement something that it may not consider optimal. Choice is good.

Tom.

> Feel free to use that code as a reference for your implementation.
> 
> I could certainly have gotten something wrong, but I didn't (don't)
> really have the time to work on it again.
> 
> 
> Cheers,
> 
> Enzo
> 
> 
> [0] my tests were done with a user POV in mind, so everything was
> measured in workload time rather than us/ms tracing.  Tested only
> on common desktop HW too.
> 
> [1] AES-CMAC uses the shash crypto API, but AES-GMAC uses AEAD
> encryption API (to only sign a payload you use an empty plaintext
> buffer, and set the full payload to the associated data buffer).
> 
> This makes it require non-trivial changes other than simply loading
> another shash alg.
> 

