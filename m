Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021105.outbound.protection.outlook.com [40.107.208.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CEA15853B
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565134; cv=fail; b=QReApmSaK3JYMn76c2kkyYDYnSJhz4A94EFtpHoSYVCkZD5YWL95XpGwZN9YaA4KVwbcFN6lv6vAo0ImcAzXMo8x9/BKbsFdbObSwJmXymHcK+Sw5dJDm6zPLNF9saPQq/dPOD/QeZuXQkd8CEPwVY9fAEaUZ8xAioodnaMSZks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565134; c=relaxed/simple;
	bh=BTgWYsav8Ma/9fpCtPZcmMTKWgyZILt6UkgArPxFWuI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pFNaCtv+6JCkxaR+dwekZ9qf7jb0gPpijSe9hubdJ8ns/DldUm9a8fgtk/i07HW0NLdq1cfl8x2NFYcIXvrnzOuWRkQJc+ek5Hbily0jXqfG/OUtUKGuZ1A9MASU7Msua24EgeSjrOPcaa1945KWtEDLtc5wH0VSYSMcv5IxVzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.208.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rD60JRxV21Pwk0KAH20GXNYFAsLXjdfphM5LPCQPcGjDSVt7EumGd+yyqV4BhXPJ4jdHbLffL0nNpzjFTdDlSzjYiz88SnxHV+MzS52f8NYkskz59I+0ttz+xTiEeaXN4dVxZ+K5cm3aJdyAPzoJmScsLtBuXdY1S1uwZF2QFrNkOyfkoODf/WUuwd37a3lhq/bOJ7q76CgLKZnI6nJz1+8yjjoyGfOe2wVLvWGbKjee1ufvl9DaPlx5BlC4bVja77ifGQ98+3e1kjpFf9tE5ynBjteGvUyRVAIbvdnvydv75ZP6q74N1kOUJgRQMUtrR9IiqumJIr2lZs7tCP35AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0HRWUCGOtTsdDP3D+8BmvXugLZVTUEm4LWfbtDRnwM=;
 b=Juy/l4w5lcoiAYsr9VNfinoiT61eMezhhDrDhpkawhIxM6MBhXGJsygs0vFwW0FqwJJWltRkqQY1EyPcSrx09ehJRS45I4UODH2ieyV+syUZOhr0tY5Kp2T4mnSI7DoI5w7UanVt0f70d+UoN9gv9N3CTWaTyIvwK+Qv2RP7YFXdqXRlhNVc+3Y/5Iv8o2Wf7pWS3c0BkCatFsFCuqCGxmN9/BAx0iOcO+VPDCR6cTSvKF2rnhhFapH7g/IODwh/vFyceHJt0q1vdbsE/4Kz6BE880zehQFvCDyZ0YiZt4SzHhmAqSh9f4P3tCQrRtA2kt/HGNr/Eg62DXTDC67O0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from DM6PR01MB6105.prod.exchangelabs.com (2603:10b6:5:1cc::20) by
 SJ0PR01MB7313.prod.exchangelabs.com (2603:10b6:a03:3f3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.23; Mon, 22 Sep 2025 18:18:50 +0000
Received: from DM6PR01MB6105.prod.exchangelabs.com
 ([fe80::4784:5106:9c3a:e608]) by DM6PR01MB6105.prod.exchangelabs.com
 ([fe80::4784:5106:9c3a:e608%4]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 18:18:50 +0000
Message-ID: <5987d33c-f3dc-47a4-8ac9-befd689c0650@talpey.com>
Date: Mon, 22 Sep 2025 14:18:47 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: smbdirect/RDMA patches for 6.18
To: Steve French <smfrench@gmail.com>,
 "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5mtPs4=gUB02r12MN29kwK57+qJ_ugAsN6=83_vhA5aDCA@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CAH2r5mtPs4=gUB02r12MN29kwK57+qJ_ugAsN6=83_vhA5aDCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0044.prod.exchangelabs.com
 (2603:10b6:208:25::21) To DM6PR01MB6105.prod.exchangelabs.com
 (2603:10b6:5:1cc::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR01MB6105:EE_|SJ0PR01MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: 20267a4a-b16c-4da8-6e1b-08ddfa047a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmh4dmZCUkRISkNJWit2eDRXZ3U0RERIV3dWZVdhVnVQcmVwWHRZbnRRVmN1?=
 =?utf-8?B?eTZwSWhZaVhHSjE2ODQzd01IbVgyVVlYWnIweWVUL3crNjBEK1dHalU2SlRX?=
 =?utf-8?B?NCtyN2tkbCszMU5RcWVlUTZDcHpyQ3ZLNjJmMktON0hvZnhRaFYxRTNmMHow?=
 =?utf-8?B?aEVGOUlUNkpHWVhxd3MzUGNNSnJ3RU1KQm40UGlPMjhSeTFjNzJ5MkRQZ1J0?=
 =?utf-8?B?VGROVlQ2ZVYrU2wyaHRyMFd3VG1WazRoNXVteVhNdm5qd3lGY0Erd2VHaWRr?=
 =?utf-8?B?YTd5K095OHVMSW5BYzJrUkxFT2dabUQ0b1cvUkJna2Y2OW5BQzJkdUlZRUNq?=
 =?utf-8?B?bitVZEJ0cXpSNDNCK1drMHFNUytHWTJ3d0I2NXFwamRBM0IyTXJVQkljU3Fm?=
 =?utf-8?B?WHJWVWNaK3Q5UFBuNW0reW9Ram1wK2F0aVgyRjRRUkQxNER1blAySy9uNTNJ?=
 =?utf-8?B?NXh3NlYxbW9SZGNhdU8wdlQrZmlYL0txM0J4VkcxOXpUUGhuUXNMSkVNMnQ5?=
 =?utf-8?B?S0VxK1NHU3owamhJaFpuR0RxYTdCMHVKUkZmQUt5UlIrcXprTmlOelRQZ0ZB?=
 =?utf-8?B?Si8xRGRkTUNYelpQNUJYN0Z1YU9WWEE2dVIzYXliazBRN2tORWRXSjRsdnFQ?=
 =?utf-8?B?N2RjSjFhWUhXR1hFYlhKczZma0JCbjVOdWRVSmdjOVdVVFJBZUdiWjZWVC95?=
 =?utf-8?B?Q1JEYno1UTFzZ25GWTRJSG56cWhaK203OEdjK1FWUm0rVEtMY0ZGeVRVZ2tQ?=
 =?utf-8?B?Z3M2a0g1SzRGSGlPZjM1MGd4Q3JFWWxRenNvaHBYQWhja0xmUVN3TFVvOFZ6?=
 =?utf-8?B?TkZKckRtTDZKUTFMdW9yUXh5aTJURFhrbUhPRW1vcXB0MmhibVdwUmtPSGRm?=
 =?utf-8?B?M1BsZnZvZXZDMk1zN0lhQTBCMzR1dyt5SzBmd1JrU3U0ZVMrU2RvR2NNaFhm?=
 =?utf-8?B?Q2o4UTQvVkdERnRRQ2dqWjdaajdZNk0vanJGVzFPdlIvRHpyS2dNNFk1WURz?=
 =?utf-8?B?ZWw3cG5jd2NleElYeUloeThBWUhxdjBnUXgxQ2ZYcDNzY3FtUnBhcWl5dDVX?=
 =?utf-8?B?OG1SMWl2dVIvc3BZOURUdmU1VjY2eUVsR2RVd1lSei9wVFh3SUJ2dGtMTjQ0?=
 =?utf-8?B?Z25RbFNsdW1QcnJDc3VrTEI1ZVM2V05nK3laSFhFeFl6R3d1bXJ2emJ0M2kw?=
 =?utf-8?B?eVFjQzcrekRUWm1LVWpUd3Z5Y29lWkpYc1kzNlRRNDk2WUF2QTR1elpRT3hV?=
 =?utf-8?B?M05BU1pBYjJVbnFLd1JVWHVTOXRKeXVVbUNheHB1S0pWeGd5a2hQZUFPanMr?=
 =?utf-8?B?Wk9RUTN3MHpNWWJ0TUtZM1RaelNYcm9VQlRoR0VkZ1JYVnRacDczNHpDTitY?=
 =?utf-8?B?UmpOU3UyM0F4Q0hKblF4cG1HQmZPTm1Fem5jZWh0bkJVa3lxclUwWnZFRng3?=
 =?utf-8?B?VVRvQVA0WkFRMXRZYXJhdW44US9DYzVraFdmUEVXWjhWU1plTkRsMlBVNWQ5?=
 =?utf-8?B?aGZkMVdXUnlsaDdwdlpxdWdwTTk2SzFpWXYySkNQTi9GRHNJTVVsbnJ1aWlS?=
 =?utf-8?B?SkRhMmFaS1VuUDcyRktjTSsrR2E4NHpHKzFoaWtQa1pNam41MitwVEhMdURG?=
 =?utf-8?B?eHN2cUtQckVoejRFZHoydW8xZXpwYzE3WHE0YlE0WmdJa2IrRG5OUFRDRjEy?=
 =?utf-8?B?T3RQUzRjZVlkV0lZSnhjQmlaNWFXQW9lcGRaM3RJdFhYMWlQMzA4VVo0ZWMx?=
 =?utf-8?B?bEFBMjQ5MTRNL1k4U3Q5NVhsS2NUZVQzN01KVjhYOXZYU1FSMzBnRE5idHBn?=
 =?utf-8?Q?FisdjO0MgSj3NnKTqSSDEPzb0jQHpaIAYlc2s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB6105.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MndkMmhPbDJOR3pHSE9BRHEzU1dlVkJZY0FDVGRBNGJRZGFBcTEwdFU5Vzkx?=
 =?utf-8?B?cG5wWnRLZzV6TnNyZTVJR0hQdTF0WmdQbTZRZmoxd1dMZzB3UEZSQXRxUmRj?=
 =?utf-8?B?WGNySlhKSXEyNnlBWXZQaGhkSXFIV2ZyeEQwOXVnYk9oWmxBMHZWTXVpTE9O?=
 =?utf-8?B?SHRTeHliTzBYMDh3ZUs2L29DbEdna1VJVzZ1K3llbUo0eXRaNGxCOUlqQjZ0?=
 =?utf-8?B?cjR3N0RZemROb3pxejhWSnREWEM5NTR1SnZiSGJZaXRrNlhBNnI3a2prdU9q?=
 =?utf-8?B?RkJaMENsNXQwbytvdjd6WGIyb0svbHFDcGJ3RTRORHEyd1NBdGgyOU9aYUFS?=
 =?utf-8?B?Z2hERTZZZG8ySFhWTUdUdTlSWEpkZTE5YUVVSzRLUE9yNHZscG9VT09qamZn?=
 =?utf-8?B?Q0Q0SmRia3BmTTZvb1FWbEZSTnA2V0FMSm9kRjhldmhZR3BqeWFLY0FiaTMy?=
 =?utf-8?B?QS9qMjk3SWtCb3BDZVErL1RvSDlZWXI2cWRhOG9nR0JRaE84NXRMbU9TNHVy?=
 =?utf-8?B?TkJuSUkrc0Q4cHA3Q0l1VzhlWm1IYnlkdGVrMGV5ZjNDR25uc0d4YVNRMW84?=
 =?utf-8?B?aXV0aEhERCtLYXBUajJSSnEvT0Z4NDZwQlZIN3hIQ1FzenZpWXpvUGNJck1m?=
 =?utf-8?B?VmZUeGpYa0FvMUVvOUYrc2dsTnExa21ZY043UVIrRXIybGpIL1B3dHc2VlBB?=
 =?utf-8?B?a0Fjd1JkckhFOXNHc2pHclJsam9LVHhhWHNuVXRkdTZqczRMM0JNK2Flc3FH?=
 =?utf-8?B?OVZNMUdqeXd6UjlKNWZnVmVOM05JSEwyU1RvUmxmUk05WkRHZDlpV0w0YWR2?=
 =?utf-8?B?REMrQnhSYzBKN1A4Qm15YXlCbFgyS3VxajNYK0t5bXdNOGJwWkZ2enhHZjdT?=
 =?utf-8?B?SGNFaUUySEJhNENsWm1SYWpUVnNKUTM1dUtaa0NwZTZFSllXMjNYeDZCanRR?=
 =?utf-8?B?Z2NMUzlXMzBjYVcvUzNUb1hsZDRGN25ZZitBWTBnMEdqTjZKd1B2VXpFTWln?=
 =?utf-8?B?ZkpPbFRwekd2a0Y2VFdhekxFTmwzVXBOemJjc0t0T3hDdVpnZWViS091VTh5?=
 =?utf-8?B?U1M0UDA4QnJ1QThuZ0hvWitzTU9wd0RNWVl1WDBFSzNTL2xPdk1ZZHUwZ0x5?=
 =?utf-8?B?aHVtR0pOUk9mVXg4SUxKZFFjRVd3eGs2VzNMcUdjVGRHays3S01jTkgxYTFQ?=
 =?utf-8?B?djE0SGk5Q092OEZ3dUp6SjAyaTZaUzNaUDZCaEkwTnpyUVpaUVhWRGtnaEpW?=
 =?utf-8?B?YTU5L2lZS0g2UlY5S1QrRnJURm5GdUZzems1RmdnSFhobXl5TWFrQzJLaXdY?=
 =?utf-8?B?ME8yTlBqTFhYRGxyMkc2a3ZNZ0JmV3IvWVBPTElqR1BCOCtlMkpaaGoxMjRD?=
 =?utf-8?B?N0lBb3U1SGZtVStEZW80RjdPanM5VTF0bXRsbTZRVEpyS0o4Uys1aDZJUmFF?=
 =?utf-8?B?Zzc4ajZYK0psNXI2emFBZWpBcHN2ZmpXTWZHQ0trcmhib204SklZdzJ3RlVq?=
 =?utf-8?B?Y0RwRjBnZjdTcithYTVDYUN5TFZvM1h3VjlzdFdxU1E4QUhNMjN1REhGTkds?=
 =?utf-8?B?bExPUVp4SGh3R3BYQlNrbTNjOU9GMkJxQW5jNzJ0ZnVQNTFMaWMybXpON0x0?=
 =?utf-8?B?VkRyYW43SXdpRnAxQ1NDMWIwd0VxaGJ2MG9ha28rblgwTzdBVXdUNDR1Y2JQ?=
 =?utf-8?B?SVZYTGkyeWl5R1ZJTDgrYitOL1MwRTVJc0U2blNrYnZCdGg4V05ENUJxYVlK?=
 =?utf-8?B?cHF0cDZMUWFkcklZSkFjd24xeExDZG1Ed05XU0EzYVR1WU5wRk04bU5PWjNY?=
 =?utf-8?B?dmFwLzJzbmJHWXRPNDJrVkN1ZlROazM5Wk82Zmx5U0E2aGNObE5OTU1PeXM1?=
 =?utf-8?B?VUJRM1VMdWEyMDAvMEdoVGpsSkR1V3lZSzN3YVBCcDRrS3lTL0xXNmRmNFln?=
 =?utf-8?B?TExEZUxGTDF6RFFGQzlrT29HZE55ZmJxK29MSmJFTzMzcEZEU0thZllsZFNB?=
 =?utf-8?B?SUROdE1VYzh4YUZnM0RMZXByMSt0NkVBV1Z0VHRXU1FGRXg3eExLTGw2b3Rr?=
 =?utf-8?B?YnNHdGdIdTZ4Z0VFaU5FdXBZdThXcHplVDBIdVRnSEM5bU5HYWJWNkRVeWVt?=
 =?utf-8?Q?8vIq1oxtqJr5v/ZD1DbmiRNU9?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20267a4a-b16c-4da8-6e1b-08ddfa047a72
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB6105.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 18:18:50.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fluEdi20syINPADRSAOF65wFsQdHQXtWbtQ4oPzcN/eti3YJvoB0KcWNp/pJhuFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB7313

On 9/19/2025 9:57 PM, Steve French wrote:
> I have rebased the very large set of RDMA/smbdirect patches from Metze
> on current mainline from today (and the patches in ksmbd-for-next and
> for-next).
> 
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next-next;pg=1
> 
> Testing and review would be very welcome.   There was a lot of
> discussion and testing of these at the SMB3 test event at the annual
> Storage Developer Conference this week (and they look VERY promising),
> but it is a very large set, so more reviews and testing will be
> helpful.

FYI the server-side ones were tested on my machines at last week's
IOLab and they checked out well so far. They passed the relevant
WinProtocol tests as well. I need to verify some details so this
is not yet a Tested-by from me however.

I also plan to review in more detail. Thanks for merging, it makes
this easier.

Tom.
