Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C5B4430
	for <linux-cifs@vger.kernel.org>; Sun,  3 Nov 2024 02:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730602063; cv=fail; b=CAN8MuDkUoax1RdjOU+gJFL1eK3sgmCn1IupF0oJjQEoPSK1cJEzJhUiRydEaSI+2OExMYeRml433JX3uMviIDw7xxWhBhKgkQBshidaxeH6I/g94SSppUuLmbP3juXF7YETD90bUlaQL0AXjngTFYcsSBmLuYzcvbGvLhISw6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730602063; c=relaxed/simple;
	bh=oTYeqtrtsnu05Vfo32etxqh1eZJIczYbEdJaTLRMXT0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n6ktoILGhaaDCpaDXp4Kpe1KNcV5egmQCY52Q2lcAu6DtSk4iWyxUvS94Jlg7nX/VzXbRZqVrGZORCzKez1PH26gqbOQOdDW5wOijrDipT23kgXngFpbOV/s0iiIw8Jb3uQ/TyQeMKTaUC7ZPplNEC8fp2gUPdCO4h2WAA6C2ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.223.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGnDLCIuAdPg4xa+xuTpxfJ3+P4SKYEhX0olh66Xq2WmIwW8zxjS6bHnIzxZV+RXWd2PY9i6cs5T+iXvWJ7Dulu31lh1+pCMbFZIfbC6ez4c6K+WveFwuwyPOBCwq9TDpnyldD6B8l1CNcIjO1yOge/C3BBuhZdOAf5S+B0ljGz5SQen8E0vopKAzvc+opHqsNSk760HPPtfKp4K/wJ733WQ8ZVqPfR8f+hgHnhuALYY7dBIZeX9CMCI2sb9MRJbLECsh6zzVNp4iId2qA/MD+7PfqClwjoATWdA4ObLQ+T5Ct1an9iC98g/xvjDU49DUx0UcpulRjVMx9d9o2Mb8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOEQWFcJhPMaPVzmSR5qP3cQ9ihwt5y0zgufEzLtllc=;
 b=dRAEAza8iJkPyeV6Ke0p2/on0uFBM2O1Ak8kKvtJIGUMeQLJ12wAODGObPAJgoXuIQmEp3B6SR88mMlO4rkcdu9tlQVabzAfEqZyd6Suhw4RdSL2k6F+OauC9j27IMgy0rxyOpjB0yCFT9kwJgaGPw+rdYfMFzk6bqsDA1DyUk42/Z2wv4SPNE7AsXcKqlvTM2TjX9RM04RP6EZyLyKKzT19vsnjo8cK1oFgExXH5uDfx0PmUAcpUYmu4U9Rc361eg2Xc4nSRCCsibQUCCuAji95+FSvmviZtfYpQiNeGGxoJDpo9vQKyhT2AUq/iHzaZHCMh2MJA8TSL8SYMQF1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 SA3PR01MB7965.prod.exchangelabs.com (2603:10b6:806:304::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.10; Sun, 3 Nov 2024 02:47:37 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%3]) with mapi id 15.20.8137.011; Sun, 3 Nov 2024
 02:47:36 +0000
Message-ID: <f9ba02aa-7915-4a07-9665-58db2abef3ac@talpey.com>
Date: Sat, 2 Nov 2024 22:47:34 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: Fix use-after-free of network namespace.
To: Kuniyuki Iwashima <kuniyu@amazon.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20241102212438.76691-1-kuniyu@amazon.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20241102212438.76691-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL6PEPF00016418.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:7) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|SA3PR01MB7965:EE_
X-MS-Office365-Filtering-Correlation-Id: 565955c8-ac54-4081-41ee-08dcfbb1e002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlJaeEgxbDFPVk9MSVF6cGdlVVRjc0FTeXBNVmhabEcyS0I0YXhvdkxnTkFQ?=
 =?utf-8?B?NDcyTGV5bTNZRlRTZ2xCYlNRWVNVbVFDaE80NGJ5MGVZSlpjczl6a2JHeTBD?=
 =?utf-8?B?S2R4YnpicFUzZG9jbng3M3djOHdmTGt6UHlMajdhUEJLdmNZVlFJemxJRHNv?=
 =?utf-8?B?VEJlMmhTS3VpcmVnS2wzcjdNbnUvTVU3OVBMemxISTQ0Rmg5am1KeUtnTE1K?=
 =?utf-8?B?L0k3c1N1M1IrMlErRUhXQkR1VGIxRHlILzhlaFAxRkFVV2VySmVNK3pRdkhB?=
 =?utf-8?B?a1prUXIwamsrZFc1UzgxVUMxQyt1Z21ESHdMV0VFeXBIUzF6MnFwME1CUUc2?=
 =?utf-8?B?cnU1U1UzMnI5SEhUWnRjanlnWFQrNnVyZEk5QnNJNWdkekJHYnpDT1J3U2NU?=
 =?utf-8?B?TGsrdGgzNnBTR1Q3dllNaVBrRHdBZ0hGNmxmd0RpZloxSUlVZGZZc3BYVGZv?=
 =?utf-8?B?TXU0d0grZEg2YUc1aExTUEhLencraG9SQVZ2V2l0MmU5WXdkbTAxWGpoMURl?=
 =?utf-8?B?UElxSWtlQTgwa3R5UXpFd3Fldy8wZSsvUDlMeHBSWmlmMFFmMHRRcnZERmxv?=
 =?utf-8?B?UjBaWGgyd3BhaTdqU01NVlFHQ1RXSk4vU21UVnJRazV5RGx2WitnU3hId09n?=
 =?utf-8?B?U2cvbXRvOFNkdno4ZllKV2g0enU0TFlBYjByeThGL1F4U1pXNnRuN1JnL0xx?=
 =?utf-8?B?d0ppYXZOL3lVWFVZNU1uUmV3RTNlRVZnN0lmL3dmL281YVRYU0lIYWx4TEZC?=
 =?utf-8?B?NmVtVzRpN1RKdEhpalhCWTJFS01ZTEg1SEIwQVBzRWNDdlNoUkdMcThDZGlw?=
 =?utf-8?B?ZFFlZUFvSm5HT3FwVUI0ZHBKVnU0SWZ2MWtTbGMwVm9zZFRTakQvbWdsY2Jt?=
 =?utf-8?B?QzRrM3IxbDI5SXVzVzR6dFN5OVYzVzdXUHlCb0hHM1FZenhNbkM5NFNjaFNT?=
 =?utf-8?B?c0xWVXhOa1VsSktJemIvakZmaklobDNMVHliRkoyY0RFSmN3WFZVQk1DVVlp?=
 =?utf-8?B?T1BOSGlvejE4TkJ5Q1BOU0RGL3dGb2NOb0pDYmlpeTFnb21odEZGaWRUQnRP?=
 =?utf-8?B?UTAvTG8zN0tLUVM2RU53QVpQektab1lRcW53Q1ViUnoxRVNFZFdjWHQxSEUw?=
 =?utf-8?B?L0loZEFnb0xWOTR6YmVVZThUQkJUUDBOOSsxVk04SmNsWVBTY2lsTlNlVXdV?=
 =?utf-8?B?WjJIUnQ1WXJKSm1KUzdvaytaL3BOUHF0UngxQzVMaGhmMzdaY1M5VDl5VGdX?=
 =?utf-8?B?WHM4Z2tQcVpRbnI2UGxYaEMvc1liaFZCc1lTd2NYYXl6UDhiaXJpVG03WXFZ?=
 =?utf-8?B?ZGo4MWpMc3lZclREa0pnSlRFYm5oVE5hVTRBa1VRMVU3UHJYNFdxRTlhL0tM?=
 =?utf-8?B?V1VoUzlscGdHc0laL0ZRWFViWFVJR1k5OUtLSmhSNmpTdXJaYzFTNTRiK1VD?=
 =?utf-8?B?M3FqVUpraE83TzlETnZLa1FXbkZ3K2VMb0RlSWM2ZmNJS0pNRU8zYlJuNnNh?=
 =?utf-8?B?VmlYWkhLcGRGZDdYd0pFNGhwUDl6bmYzVFZMRVp5UE54aHlMamdOU1k4dFZM?=
 =?utf-8?B?N3NPVnEza3BuVFlYanJUTHdxYTdoUm9ualU1eTV6cDFsQkR5QVROakx2T0Y3?=
 =?utf-8?B?V0tIYVVzNFQySk9IdnhCU2tOVVo5bkdRVzJiV0kyR25vWXhFbzdkVysreEY4?=
 =?utf-8?Q?wOZdvWkCcbA6EbTUTjSY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDlOOEhqTlFJWVhnR0twV0tLNGJTSGV4U3p5OGRydmw2UFQ1UDFKVUpNSTdw?=
 =?utf-8?B?MVNBTmlZZUw4K3hxMmRLeWRyRElvdkRMWHBBOWhIcktUcFJpUjA5YWQ4M0lO?=
 =?utf-8?B?d1JmQ2JLVHJrVzhRZDhheUhaNExaeC9LekpkSjVKbXZJMmdSeTAvRUpTcUtH?=
 =?utf-8?B?VEFSU0l3Mzh3Tkc1OWplaW1MVFpFbXVPaGdVUDhydFJxOFBkOE53cEdIU3Yw?=
 =?utf-8?B?eCt2TkpZOENDTU9jWVdrN2RKYSthSzdxa2NpK3RzUko1THN3WTBKME5hZVE2?=
 =?utf-8?B?bk1rcEVraGRxaXdTQS9lcWdEczlKRENyNDhWa1I1M1ozakZwNzhja1JhWDJY?=
 =?utf-8?B?MlFDQWIyZ2cwNVRWRDRKTGp3SzBPRGlYaVFaUGRhT1Bkclcway9XYnA3ZlU4?=
 =?utf-8?B?bCs1dFYvTiszTDY5SU5RSUdobFdLUlNUMEU4T3g4YVAxaWNPWE5teHJxZTFs?=
 =?utf-8?B?UzlZcHl2eTBCV1BacmV2UCtKL0R1M3FmdWREazlLcVVaTVcwSWhrWjg5Wk0x?=
 =?utf-8?B?RWNsQlE0T1RsQnBRUzBKVURDNFh2K1E0VE9JclJiSjR2WEY3RjJ3Nkt5dzVC?=
 =?utf-8?B?bFI5YTc5dE1QN0ZtVkhrN0N5K0ZyK2ZEYmZjMkRqeWRVdEdoWUtQVTQrUzBI?=
 =?utf-8?B?NG9aZlNBTEVXdzQyRGIxbHUrZG5nYytzTzc5RmduRk9yL3hJYm9tRmg4NzFQ?=
 =?utf-8?B?WFQ4V0libjNsc0NWUDloVlh2NjlNRUxITlpuMm1nVlpOV2dTa0tCVGUzQlRj?=
 =?utf-8?B?Z0haZjJHaTJwa3kzZVV6aHdVaGxEQi9IUDRzU3RXNEFDSjlCT2NDTjZ4dmEx?=
 =?utf-8?B?Y1VRV05QcEM1aTZseWJOTVlLdmI5SDJqcEg2ck15RGdVYUl3ZnZOT3dwb0FL?=
 =?utf-8?B?S0hZQThTQlFGeThrL2VkK2ozcU1tRVBXKzVKSjdSeFRHVHNtYVdqWDI5b282?=
 =?utf-8?B?WFA3K2ljYlVwZUpKT0p3K0VwNTBod3BBSTZzSUtlMHhSTXo5VlE5b3ROL1ov?=
 =?utf-8?B?MEk3YkpQbWhiTlp4YlgyeWlGYUY5aHJzWU5Xd0pCdElkOHNqODk1cFkxZ0pE?=
 =?utf-8?B?VjRDZzZkald3c2x0R0phMHJ3VDJtSmducUM1MmtDblNUTThqZWRqRDhQU3BM?=
 =?utf-8?B?MEwzdmljQXhuTHJNWTNOSzNqUXpWbXgxVzBNRmRFTlRSQ1lNOS9VdElUZ3BG?=
 =?utf-8?B?c0RLM3JnQ0kzY09QMUttV3V3VGVBdjF4RktiVm1PckdMNFhVVmNWN1c2ZzdL?=
 =?utf-8?B?c25ROERiL0lQaVM3c2lFT2dFU1Jta3dJQ2FZTGE0dXNrL1NSbnNYUnVJTTF3?=
 =?utf-8?B?blhaWUFaU1ZCRkd2K1YxdGdiSlhyaE1GMXpiM2RZaHFTdjNWRGJwdVFlZ2VR?=
 =?utf-8?B?eisxSFpwL2czYy9XKzkvanMyR2hNZzZjT2ZFN0NSeWw4NWoxdnN3WEFJVXdt?=
 =?utf-8?B?dU8xbitwUVB3cjhiRUFpMHl4Qk01eUYwWGRXVEFNT3lhV0FDWW0yNXJKQ1lU?=
 =?utf-8?B?UEFMYXlxM0hJLzFvY0hDYUU3YVF4Vmo2ZGxPSTU5M0h2cGg5ZGl2QVI2bkQx?=
 =?utf-8?B?cXFidUFLTUZiS0QxbGt6ak52OWs2bW5SRDR6d0o2cWJpdkFCSkU3VVY4clhx?=
 =?utf-8?B?b21EYzZNZnN2MlV0TXptOWV6djYwUTkyNTZCRGRmRVBmL0ZXNnBZY3dUTTdI?=
 =?utf-8?B?K1NsVUNYcDBxVDRIdU5Nd1h2Z3BXNnNJNThIMitSYUlIdFg0em9nMWVQTlB0?=
 =?utf-8?B?N0xnL2V1djVWODhqMXhYRUZ0Y2tSVW0yR2ZWMzAyQzNTdVE1c0E0SzMvVnd6?=
 =?utf-8?B?TS84UWZMb0Z3dTJwUzIyaE5sYktwbVRldDl4bkFlQXJwY3JxUlJQdGR2Q2xR?=
 =?utf-8?B?cy85eGs0TFU3aXo3YmgxNGcxT3F4Q0I3d2pWRklGMVhIbXlBWjNPcU15S3Fv?=
 =?utf-8?B?UWZCcllUbnBaOHdEbXJ4QWdNdHdHNTdjNjRNeHlRdTBCTGFOZlZHcVIxMGxP?=
 =?utf-8?B?Ri91S0FHS0JCQ3gzR3VGOFBneW9PNXRpR08xSVBmcWNCTi91b3g2SE1LV1p3?=
 =?utf-8?B?b1grL3dodHVMaXkvNllyY3NnRmFkS1BkS2Z4SDRFNnFTK0pGNVF6ZklIV0dx?=
 =?utf-8?Q?6fHY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565955c8-ac54-4081-41ee-08dcfbb1e002
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 02:47:36.7175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsi4SbDKClFnNn6pp2D+ER0kTdS/+ZBusNs/TVBBBfFW/v4Oqt6T4jSGveeWQ+Zb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB7965

On 11/2/2024 5:24 PM, Kuniyuki Iwashima wrote:
> Recently, we got a customer report that CIFS triggers oops while
> reconnecting to a server.  [0]
> 
> The workload runs on Kubernetes, and some pods mount CIFS servers
> in non-root network namespaces.  The problem rarely happened, but
> it was always while the pod was dying.
> 
> The root cause is wrong reference counting for network namespace.

Saw your similar fix in the NFS client, thanks for attending to the
SMB client as well.

Question below...

> CIFS uses kernel sockets, which do not hold refcnt of the netns that
> the socket belongs to.  That means CIFS must ensure the socket is
> always freed before its netns; otherwise, use-after-free happens.
> 
> The repro steps are roughly:
> 
>    1. mount CIFS in a non-root netns
>    2. drop packets from the netns
>    3. destroy the netns
>    4. unmount CIFS
> 
> We can reproduce the issue quickly with the script [1] below and see
> the splat [2] if CONFIG_NET_NS_REFCNT_TRACKER is enabled.
> 
> When the socket is TCP, it is hard to guarantee the netns lifetime
> without holding refcnt due to async timers.
> 
> Let's hold netns refcnt for each socket as done for SMC in commit
> 9744d2bf1976 ("smc: Fix use-after-free in tcp_write_timer_handler().").
> 
> Note that we need to move put_net() from cifs_put_tcp_session() to
> clean_demultiplex_info(); otherwise, __sock_create() still could touch a
> freed netns while cifsd tries to reconnect from cifs_demultiplex_thread().
> 
> Also, maybe_get_net() cannot be put just before __sock_create() because
> the code is not under RCU and there is a small chance that the same
> address happened to be reallocated to another netns.
> 
> [0]:
> CIFS: VFS: \\XXXXXXXXXXX has not responded in 15 seconds. Reconnecting...
> CIFS: Serverclose failed 4 times, giving up
> Unable to handle kernel paging request at virtual address 14de99e461f84a07
> Mem abort info:
>    ESR = 0x0000000096000004
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>    FSC = 0x04: level 0 translation fault
> Data abort info:
>    ISV = 0, ISS = 0x00000004
>    CM = 0, WnR = 0
> [14de99e461f84a07] address between user and kernel address ranges
> Internal error: Oops: 0000000096000004 [#1] SMP
> Modules linked in: cls_bpf sch_ingress nls_utf8 cifs cifs_arc4 cifs_md4 dns_resolver tcp_diag inet_diag veth xt_state xt_connmark nf_conntrack_netlink xt_nat xt_statistic xt_MASQUERADE xt_mark xt_addrtype ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compat nf_tables nfnetlink overlay nls_ascii nls_cp437 sunrpc vfat fat aes_ce_blk aes_ce_cipher ghash_ce sm4_ce_cipher sm4 sm3_ce sm3 sha3_ce sha512_ce sha512_arm64 sha1_ce ena button sch_fq_codel loop fuse configfs dmi_sysfs sha2_ce sha256_arm64 dm_mirror dm_region_hash dm_log dm_mod dax efivarfs
> CPU: 5 PID: 2690970 Comm: cifsd Not tainted 6.1.103-109.184.amzn2023.aarch64 #1
> Hardware name: Amazon EC2 r7g.4xlarge/, BIOS 1.0 11/1/2018
> pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : fib_rules_lookup+0x44/0x238
> lr : __fib_lookup+0x64/0xbc
> sp : ffff8000265db790
> x29: ffff8000265db790 x28: 0000000000000000 x27: 000000000000bd01
> x26: 0000000000000000 x25: ffff000b4baf8000 x24: ffff00047b5e4580
> x23: ffff8000265db7e0 x22: 0000000000000000 x21: ffff00047b5e4500
> x20: ffff0010e3f694f8 x19: 14de99e461f849f7 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 3f92800abd010002
> x11: 0000000000000001 x10: ffff0010e3f69420 x9 : ffff800008a6f294
> x8 : 0000000000000000 x7 : 0000000000000006 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : ffff001924354280 x3 : ffff8000265db7e0
> x2 : 0000000000000000 x1 : ffff0010e3f694f8 x0 : ffff00047b5e4500
> Call trace:
>   fib_rules_lookup+0x44/0x238
>   __fib_lookup+0x64/0xbc
>   ip_route_output_key_hash_rcu+0x2c4/0x398
>   ip_route_output_key_hash+0x60/0x8c
>   tcp_v4_connect+0x290/0x488
>   __inet_stream_connect+0x108/0x3d0
>   inet_stream_connect+0x50/0x78
>   kernel_connect+0x6c/0xac
>   generic_ip_connect+0x10c/0x6c8 [cifs]
>   __reconnect_target_unlocked+0xa0/0x214 [cifs]
>   reconnect_dfs_server+0x144/0x460 [cifs]
>   cifs_reconnect+0x88/0x148 [cifs]
>   cifs_readv_from_socket+0x230/0x430 [cifs]
>   cifs_read_from_socket+0x74/0xa8 [cifs]
>   cifs_demultiplex_thread+0xf8/0x704 [cifs]
>   kthread+0xd0/0xd4
> Code: aa0003f8 f8480f13 eb18027f 540006c0 (b9401264)
> 
> [1]:
> CIFS_CRED="/root/cred.cifs"
> CIFS_USER="Administrator"
> CIFS_PASS="Password"
> CIFS_IP="X.X.X.X"
> CIFS_PATH="//${CIFS_IP}/Users/Administrator/Desktop/CIFS_TEST"
> CIFS_MNT="/mnt/smb"
> DEV="enp0s3"
> 
> cat <<EOF > ${CIFS_CRED}
> username=${CIFS_USER}
> password=${CIFS_PASS}
> domain=EXAMPLE.COM
> EOF
> 
> unshare -n bash -c "
> mkdir -p ${CIFS_MNT}
> ip netns attach root 1
> ip link add eth0 type veth peer veth0 netns root
> ip link set eth0 up
> ip -n root link set veth0 up
> ip addr add 192.168.0.2/24 dev eth0
> ip -n root addr add 192.168.0.1/24 dev veth0
> ip route add default via 192.168.0.1 dev eth0
> ip netns exec root sysctl net.ipv4.ip_forward=1
> ip netns exec root iptables -t nat -A POSTROUTING -s 192.168.0.2 -o ${DEV} -j MASQUERADE
> mount -t cifs ${CIFS_PATH} ${CIFS_MNT} -o vers=3.0,sec=ntlmssp,credentials=${CIFS_CRED},rsize=65536,wsize=65536,cache=none,echo_interval=1
> touch ${CIFS_MNT}/a.txt
> ip netns exec root iptables -t nat -D POSTROUTING -s 192.168.0.2 -o ${DEV} -j MASQUERADE
> "
> 
> umount ${CIFS_MNT}
> 
> [2]:
> ref_tracker: net notrefcnt@000000004bbc008d has 1/1 users at
>       sk_alloc (./include/net/net_namespace.h:339 net/core/sock.c:2227)
>       inet_create (net/ipv4/af_inet.c:326 net/ipv4/af_inet.c:252)
>       __sock_create (net/socket.c:1576)
>       generic_ip_connect (fs/smb/client/connect.c:3075)
>       cifs_get_tcp_session.part.0 (fs/smb/client/connect.c:3160 fs/smb/client/connect.c:1798)
>       cifs_mount_get_session (fs/smb/client/trace.h:959 fs/smb/client/connect.c:3366)
>       dfs_mount_share (fs/smb/client/dfs.c:63 fs/smb/client/dfs.c:285)
>       cifs_mount (fs/smb/client/connect.c:3622)
>       cifs_smb3_do_mount (fs/smb/client/cifsfs.c:949)
>       smb3_get_tree (fs/smb/client/fs_context.c:784 fs/smb/client/fs_context.c:802 fs/smb/client/fs_context.c:794)
>       vfs_get_tree (fs/super.c:1800)
>       path_mount (fs/namespace.c:3508 fs/namespace.c:3834)
>       __x64_sys_mount (fs/namespace.c:3848 fs/namespace.c:4057 fs/namespace.c:4034 fs/namespace.c:4034)
>       do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
>       entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> 
> Fixes: 26abe14379f8 ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> Note:
> 
> After this fix lands on net-next.git in the next release cycle,
> I'll post the series [3] below and convert some users doing the
> similar conversion for sock_create_kern(), MPTCP, SMC, RDS, CIFS.
> Then, the CIFS code will look the mostly same with now [4].
> 
> [3]: https://github.com/q2ven/linux/commits/427_rename_sock_create_kern
> [4]: https://github.com/q2ven/linux/commit/41f8874bb4ac329b388c38b14d1c615a968abbb3
> 
> Changes:
>    v2: Convert socket to hold netns instead of passing @kern=0
>        to __sock_create() to avoid inet_release() BPF hook
> 
>    v1: https://lore.kernel.org/linux-cifs/20241031175709.20111-1-kuniyu@amazon.com/
> ---
>   fs/smb/client/connect.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 15d94ac4095e..0ce2d704b1f3 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1037,6 +1037,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
>   		 */
>   	}
>   
> +	put_net(cifs_net_ns(server));
>   	kfree(server->leaf_fullpath);
>   	kfree(server);
>   
> @@ -1635,8 +1636,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
>   	/* srv_count can never go negative */
>   	WARN_ON(server->srv_count < 0);
>   
> -	put_net(cifs_net_ns(server));
> -
>   	list_del_init(&server->tcp_ses_list);
>   	spin_unlock(&cifs_tcp_ses_lock);
>   
> @@ -3070,13 +3069,22 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	if (server->ssocket) {
>   		socket = server->ssocket;
>   	} else {
> -		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
> +		struct net *net = cifs_net_ns(server);
> +		struct sock *sk;
> +
> +		rc = __sock_create(net, sfamily, SOCK_STREAM,
>   				   IPPROTO_TCP, &server->ssocket, 1);

Wouldn't it be clearer and less fragile to use the sock_create_kernel()
wrapper instead of __sock_create()?

Apart from that,

Acked-by: Tom Talpey <tom@talpey.com>

Also, does this issue appear in the ksmbd server?
In fs/smb/server/transport_tcp.c, it's calling regular sock_create().

Tom.

>   		if (rc < 0) {
>   			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
>   			return rc;
>   		}
>   
> +		sk = server->ssocket->sk;
> +		__netns_tracker_free(net, &sk->ns_tracker, false);
> +		sk->sk_net_refcnt = 1;
> +		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> +		sock_inuse_add(net, 1);
> +
>   		/* BB other socket options to set KEEPALIVE, NODELAY? */
>   		cifs_dbg(FYI, "Socket created\n");
>   		socket = server->ssocket;

