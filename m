Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2116.outbound.protection.outlook.com [40.107.95.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4851E32B7
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 18:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748371835; cv=fail; b=NCJQtUyeWh34pAjyv0CCrYLfOBrtGWS3BGISviK8iX/VjeyUdQXNNxbOiQ5/xIaUFx12+NX7aPxuVhjuQlwWkpv5H/jksklaxul8jucadBHQ/O5X/KI99fKD4+JV88zMyBhpEGidAemqlY2cB/9S9M4zAIwlQRAsMWuh6sGHtvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748371835; c=relaxed/simple;
	bh=O0epbeynt9GE/qaEtN9+bIJJ2DvG1eA6LUnbSedr5WY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n7og6QZKmT6OHmX3SabmHxehHGLh6gNR8NBuhyJXtVDS61Qgdjg1mbrV5mXjAgnN5RmQ30GeJPdyaDNqjzt/hOggvF8IIsFs5OkA1w6ZRknvJWhR9+2b2vWPfsrZRWYOYPloN4mACDI7vk0x9NIXJJ8qdOpAtTl1M/8UZf0L5QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.95.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mBwOdRcg1QT8rAymIHXGSEQWTjBKzkHh/dhhtK7b/K2PHV40MynZ82z65G9g23nlojUdrF6S/j1LA3mcsrETOVrV3wy6jXgOsbdg6Wse/ZfZVrATHZOBc1QWMbwBlkNYu717KI7UoxaWC8uyE7Mpxq2NhbqKPwo8m6WKLVLp+Dl/Pm5tLEnMDBapG3fFGrKGrTKC21V5pEo6+Ya7sYNTK8f510lcfUiqtOGc8FzGrJJOUUidpjacSVo8Mm2AliodFOBa0QXqhcZ7NxXS1xVYPbLtuBDmJOZY1nvk1UMyUZOvDW7nbQEaXjSek8IKLadTlpwmPU8dXK1hmm0NNAJhTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=im2oG8JVePyxy2/1ogIFspSWoOvEBRWekHXknojW/OI=;
 b=dkYSKhb+t0FHaNsn+eRiwn/WVypBtXI0WvtLOfebmEUlsXDBWMGrpL31i8fTtgTaxwCCIABaljy25Euyn+4mLieV/9l4MmkgU45EeM6DzBFi22yVScPWROoGCB8qIEjiT6RIBm3l0K699m2l/wB726/XLy59PMO/SRWAz+cYdk23b8vj8lOUefkVgqgQAUy8AvKaq9bLVmWy+NutYVmyCEEz5+hcqhr+MRHgy2YxR0zspACAmN3AzJtwEODI4H73P+Q/8OFDhmXMjXzIjR1/jQ6Un5p/g/ox5f80yztfECKu3FMkroh8dcvf67S15K5ngzJ/+LIwcHsz+w3LwErxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 CH0PR01MB7001.prod.exchangelabs.com (2603:10b6:610:106::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.27; Tue, 27 May 2025 18:50:29 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%6]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 18:50:28 +0000
Message-ID: <ace9b692-3a0d-4a47-b74b-c350a72efdf1@talpey.com>
Date: Tue, 27 May 2025 14:50:29 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] smb: common: split out smb_direct related header
 files
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
References: <cover.1748362221.git.metze@samba.org>
 <31f6e853d60ec99136f3855acb3447d36fa0fc82.1748362221.git.metze@samba.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <31f6e853d60ec99136f3855acb3447d36fa0fc82.1748362221.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:208:236::26) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|CH0PR01MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: f238fec8-71e8-4685-6b4d-08dd9d4f5994
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUgza1Rka1Y2eFlBaVNaanVaUHh4ck12ZzluZ2dGYUVNRDNqK0dQTHk4NXJX?=
 =?utf-8?B?WW83REhudm0rcGE2ODA0Qi8yM1gzeWdOZ2s4emN4bFhlMlA5UWcvekdzbEtC?=
 =?utf-8?B?T0Npa2hydDVGcXQzYjhzWVlpUWU0bzNXaklvRE5sbVRyNmZiaTdpVnQ3T3p4?=
 =?utf-8?B?RW14VE9uNlJuQXcwK0JjTExaM3ZBclBzUTdyaGk3U1lzNGNkZkVoTHovWjlG?=
 =?utf-8?B?aUc5VnpqajFaTnhwQk1zbVlCK255bEZ2NCtvQ0FMMlI5SFMzOUZsUUNSanIr?=
 =?utf-8?B?dUo1d05LNmxhdkgrSVFnczBROU1QNHJCQUZOZmh6N2RmZmVQY01uSlFEV2FT?=
 =?utf-8?B?a0VCQTJTREZkWWRlUEFiekNFREtEbGVPUlJ0Wmo5SjRmMzRlSUZFNEJzaUgr?=
 =?utf-8?B?T3FjaXE0TkFhUjJCTlpydDAyM3VQSndQVXpZL0xZSTR1TXJJNFVFTFZnU0E4?=
 =?utf-8?B?MEFBNFcybUNNSmhvdHNyTlp4cU4yN3B1QnkvWld6bklkK3RMSDRUV3YwNk8x?=
 =?utf-8?B?TG5JS3dmSmhaMWtobEVHWksxNEkxc0VCN1dMTWZmZG1VdDJMYlQxSS9CR2dO?=
 =?utf-8?B?WVkyS1VnM3cza3dLeHp0Q0Z6Y3ZjMFlpLzJGdVBYOVdMakpVV0czTVB0NWFH?=
 =?utf-8?B?UU1YOUJjcUxveUlvVUlpWk1taUJJWHpKWGtSb25rTE1HWVl0ZEVaY1hERW9u?=
 =?utf-8?B?OE85cDhLRGo3ZGFmS2tkMnNWeENWREVRRmI0VERmT0NYdHZYMUl5YmlKSmxM?=
 =?utf-8?B?L2ZJeGIrQzBkKzVQMmFPcytPSjdJcGRmVnV4ZlcrYklreHMrNFR0U0lMVGF4?=
 =?utf-8?B?eXRnNG1rdnJyMDFJVVh5YmtWLzUxYi9oU3ZrTlQzd2tEREFtcXE1ZGRFYXRT?=
 =?utf-8?B?RnQ4eC9yVW9mTk1jMUpXd2QydnN1QUVmSFFkQ3VLK055Rmx5ZHZVRWRsYURn?=
 =?utf-8?B?dFlvc0VRY01wWm1JbG5ISUU3aEI1WTMzMnlBVHJGdjdIa0M1V2RqNEhzcmZv?=
 =?utf-8?B?a0twQVpDeUlvRHZmdVVyU3UyOW5hVnpEajJLbkUwbVIyS21OVEdtNi9TN1pw?=
 =?utf-8?B?elBGR3lkMWpZWFcvNTRrRmZGWTRwWENOdkpUdGFRV2hOVVluYXBpeUp4U1JI?=
 =?utf-8?B?cjVXZ1RXeDdnTG9hRmIzclR1SEJiUFFpNFJKZitzU2hwZlU4N1J1a1Y0QnpG?=
 =?utf-8?B?QmhlQXE0amtpdmJLaTJBRjBRSDRmeWwyU2xKTFhlb0JxSlUyZ3krK3FBYWVj?=
 =?utf-8?B?YVRnemxUTFZacVNBUjliUDA3WWFnNloydEJYdDhTMUhySnZOM1IxZGI5WHNw?=
 =?utf-8?B?SEJRUzdxQTRnc1FsVXVVUmRrMEN2TEdTQVB1YXc5c1YzTk9kRlU2L1U0L09M?=
 =?utf-8?B?WEZJRXB4Z0pRSjZxb0hnS0lrTEZrOHMrUzN0WWlVaFoyMzNaVnhwU1JJdUhx?=
 =?utf-8?B?WWNGMG9ISUp5ZFc3dGNoZ0NHZjhzS1VwTTB3S3dEb1hWNWZ1bEJKaWpKWEVl?=
 =?utf-8?B?MGRFbVVFSGZ0cSt1V3N4czFheTRDUlF0M253akE5M1QyYURDN1I1d2FvRGFt?=
 =?utf-8?B?bHRJN0V0SmpyUy9FRGNLRGhKN1V6TmNDNjhkTlBsWmk0MG9maVFrYldwQTNL?=
 =?utf-8?B?Zk5KMVpKdEZySlN3eGdpWXB2RUhQK0dPMlRDZWVYWUcyRm1Ia0RETGhHQXc3?=
 =?utf-8?B?OVlKd0Q2VENsRjNuai9vRlBvTWh0OFZ3SXUvZU9TTyt5VFJwc3k1Nm5NK0pl?=
 =?utf-8?B?TzFsVHRHaFVWY2x5RGNqbk96TEZvdmRWdm9lUndTNTBKVTBUTVRtQVk5SU5X?=
 =?utf-8?B?QisrVUUza0kvZ1NHbWthWHd4VEZ5d2lWWVorMW5OM2txZzZZKzlOT2VJMnBS?=
 =?utf-8?B?NnBGWmwxMzJsRkhZZXEwZzYvL1B4SjBZOVJBNlVUMktwL0x2czFzTEdndGM0?=
 =?utf-8?Q?7bUXPu4zMOs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUc2a2pndWZyTy8zR2J0S0ZYN2lKSzdUN2RIeXNTSzMvV0VTbm1GcTdYcjBW?=
 =?utf-8?B?RHkvZjJoU2hZWGdBbXFseldON3grNDNOdW1aR0hrcDZueWYvRGJ6a2xlWGw0?=
 =?utf-8?B?SUpLYmJKZnFCR3JaR1ZHSHVzbjFLYXhzVkpWcVp0ejBxeVh2OFVMd3VKc3k2?=
 =?utf-8?B?aVBaN05IdGUzbFZhRnMwOHpoQ3lxMHVLT2xCU0dyTm5nL2lEdWM1V2lDa0p5?=
 =?utf-8?B?M1ZmaDkweW10WTNBdCtIZGxrYUltV0N6MjhKbFFlWHVpZUs1dFJMaTE2M2dW?=
 =?utf-8?B?MUlQUlMyTFVUTEluNmtVQWEvR3pROThaK0x4ZDhYZkpPczQxVjFxQ0J2cm5j?=
 =?utf-8?B?NHJ0YXZORGVhSEoyRStIN1F4eWdKcEg2SkxybWpIZGVUUVNDRVBhWGd4TDd2?=
 =?utf-8?B?RmovQ2IrQmZlRHNLREhYTkZyazhkbXlYZGYzMUxoL2N0UU9MYi9FVHF1Q29B?=
 =?utf-8?B?SU5UcFozWWNCais2MThteUtRdG54bzlHVHdwVlpKTW5GYmhwMjBpeXFXNTRD?=
 =?utf-8?B?TldmVXVESGxZaHllZk5wMmM2QjZZbXpiZk9kRUJCNndSNTc1MHo0UGg3MU00?=
 =?utf-8?B?dE5MTlNlSnZEWVdlSGcxY1RsMmRaWFNuMlpGY1R2eDdTL25vRnpQNTg0M2hp?=
 =?utf-8?B?MVY4N3VuM1krckk3b3dvYkdEdWE2eVMwbWVXN3d5OG1mMzV6VXBIcDRRQ1Fk?=
 =?utf-8?B?Z2VXbmhQNkFvZm1DOGJLanV6MG5sTkprZFNvWS94MFcxOUE4a0F6QnFVTjBs?=
 =?utf-8?B?Y24xRUtBaTF6bjZrWmR5bDZaclVWd1d4bmN3Rktjdmp6Y2YxMk16WUNUdjFv?=
 =?utf-8?B?dDQrRkFCSy9xZ3EydXBrNk1uKytrSTJDMHBzQU83N1U5S1MvSFV0RU5LOGM2?=
 =?utf-8?B?YjJ3QkM1dDc5Vi93VHgzdE1FY0FsdFd0UHcyOUVnU0FrUndDRU9UV1NuRU02?=
 =?utf-8?B?Q3ZsajB2eVBhVkxTZ3gzWTVzVkVHVUV2VWJvcnFCamJqdUpXejZQd2VDTitj?=
 =?utf-8?B?QWRBeXMwaU9kaW5DNnhzcmpBUDBMejRIb0ZrQnVRaHArOGFMRGVDeXJ0eEhK?=
 =?utf-8?B?VU5VczA5ZWFJbnNwdEVENi9heEt5ZkUxTllWUkFuaGhYaWZMVWI4Wm9ZSnRM?=
 =?utf-8?B?UVdrZCtZdjlrN05rdm14czZObGRYd3VqSXVVMjA4ek1jbERlSk8xNStTVDR3?=
 =?utf-8?B?MVF3N0hHNHQ1blRSV3ZyRkdpU0dnOEhFZUdWaVNBNFlCbW1LbS85ZXF5aFkw?=
 =?utf-8?B?QWRoSUsvaEFkbVZLdndaeXYwSXBPVTVUam9HZ1VTMGxtc0RPRTFGMUl5QXdL?=
 =?utf-8?B?dDF4bDl0Tyt5R1RDWVRONUlHckZBT0l3cXJIcWxEanNXTUE2NklFRDNZU2JP?=
 =?utf-8?B?R3owL1A5SWR0bit0ZHNxMTk2c0xDSDVYdDQrSlY2SlpKLzlJUUEvbzZCTWE2?=
 =?utf-8?B?TVAzaEYzVGFvV0pTQmJWTGxFYnFINkJzb2hvaWFLUHAvb3FKNFEvaWorOGww?=
 =?utf-8?B?TFJ4VmRmc3ByMFY0d0trR21VYmlpZHhPNlR1TGRJSTdsUzlydG1hcmM4NXp4?=
 =?utf-8?B?RU5lNGRzWjhkU2ZqVThLM0NGa0NOQnc2OGp5OE9HL0VYWWE0ZXF1RXpWZXBv?=
 =?utf-8?B?dDFiR0xTZUYvNFpHM2E5VVp2TUowckJScUN4RGp3Y01ITklDZVk4MnJpZ1JM?=
 =?utf-8?B?SHhMeWd4eXVFd1poa3c0eG96Q2c0ZlBNaElXWExMQmdkMm9XdUU5eTFTNFBV?=
 =?utf-8?B?cU1aTGt6MEU4OEVCTmZjMlZob25hcFVUQ3VZZU9INmxjd0N6ZGVSK2RwK2Zv?=
 =?utf-8?B?MjEwcDlxV21xdk9jdUdHS1owUVA4NXA2eFpDS0dNZTZabGVBV3k4R09SUWQy?=
 =?utf-8?B?MGxwbG5GV2xOT3IxMGRpemsybmYyaHFzbHRkNml0d2R1bmVDb3ZwWjNSUE0y?=
 =?utf-8?B?TVE4YkhSMEpKL3FZR29GTDNtNStEb3pOWFpnOHFEdml1UHVqRnVFV01WYUto?=
 =?utf-8?B?em1GZmpWbnVyU25VKzRhMmVKTlJVYlZLSWpLR3FMZFNmVFRob0RkaVVXbXR1?=
 =?utf-8?B?ZDJ1SVh3bmlyeVVSbXRmMWRZSlVsUWdDYmRZeFh2YnlORUZ3SG8wWXZsZnJO?=
 =?utf-8?Q?fFgc=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f238fec8-71e8-4685-6b4d-08dd9d4f5994
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 18:50:28.8295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkiRc9pH/c9KqNWJL1xxI1EDLBzG7Wu/tG2Aatv01W9OgyNvsuIy8RylZYzxBtuV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7001

I love the idea. Couple of questions on the pathnames...

On 5/27/2025 12:12 PM, Stefan Metzmacher wrote:
> This is just a start moving into a common smb_direct layer.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/common/smb_direct/smb_direct.h     | 11 +++++
>   fs/smb/common/smb_direct/smb_direct_pdu.h | 51 +++++++++++++++++++++++

Why the underscore in "smb_direct", in both components? The protocol
doesn't use this, and it seems awkward and search-unfriendly.

>   fs/smb/server/transport_rdma.h            | 43 +------------------
>   3 files changed, 64 insertions(+), 41 deletions(-)
>   create mode 100644 fs/smb/common/smb_direct/smb_direct.h
>   create mode 100644 fs/smb/common/smb_direct/smb_direct_pdu.h
> 
> diff --git a/fs/smb/common/smb_direct/smb_direct.h b/fs/smb/common/smb_direct/smb_direct.h
> new file mode 100644
> index 000000000000..c745c37a3fea
> --- /dev/null
> +++ b/fs/smb/common/smb_direct/smb_direct.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *   Copyright (C) 2025, Stefan Metzmacher <metze@samba.org>
> + */
> +
> +#ifndef __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_H__
> +#define __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_H__
> +
> +#include "smb_direct_pdu.h"

And, why the empty redirection? It seems unnecessary, do I assume it
will later contain API signatures for the planned common layer? Perhaps
it should say this, to avoid confusion while that work is being done.

I'll review more later, but a first pass looks good!

Tom.


> +
> +#endif /* __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_H__ */
> diff --git a/fs/smb/common/smb_direct/smb_direct_pdu.h b/fs/smb/common/smb_direct/smb_direct_pdu.h
> new file mode 100644
> index 000000000000..ab73cd8f807a
> --- /dev/null
> +++ b/fs/smb/common/smb_direct/smb_direct_pdu.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *   Copyright (C) 2017, Microsoft Corporation.
> + *   Copyright (C) 2018, LG Electronics.
> + */
> +
> +#ifndef __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_PDU_H__
> +#define __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_PDU_H__
> +
> +/* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
> +struct smb_direct_negotiate_req {
> +	__le16 min_version;
> +	__le16 max_version;
> +	__le16 reserved;
> +	__le16 credits_requested;
> +	__le32 preferred_send_size;
> +	__le32 max_receive_size;
> +	__le32 max_fragmented_size;
> +} __packed;
> +
> +/* SMB DIRECT negotiation response packet [MS-SMBD] 2.2.2 */
> +struct smb_direct_negotiate_resp {
> +	__le16 min_version;
> +	__le16 max_version;
> +	__le16 negotiated_version;
> +	__le16 reserved;
> +	__le16 credits_requested;
> +	__le16 credits_granted;
> +	__le32 status;
> +	__le32 max_readwrite_size;
> +	__le32 preferred_send_size;
> +	__le32 max_receive_size;
> +	__le32 max_fragmented_size;
> +} __packed;
> +
> +#define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
> +
> +/* SMB DIRECT data transfer packet with payload [MS-SMBD] 2.2.3 */
> +struct smb_direct_data_transfer {
> +	__le16 credits_requested;
> +	__le16 credits_granted;
> +	__le16 flags;
> +	__le16 reserved;
> +	__le32 remaining_data_length;
> +	__le32 data_offset;
> +	__le32 data_length;
> +	__le32 padding;
> +	__u8 buffer[];
> +} __packed;
> +
> +#endif /* __FS_SMB_COMMON_SMB_DIRECT_SMB_DIRECT_PDU_H__ */
> diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
> index 77aee4e5c9dc..71909b6d8021 100644
> --- a/fs/smb/server/transport_rdma.h
> +++ b/fs/smb/server/transport_rdma.h
> @@ -7,51 +7,12 @@
>   #ifndef __KSMBD_TRANSPORT_RDMA_H__
>   #define __KSMBD_TRANSPORT_RDMA_H__
>   
> +#include "../common/smb_direct/smb_direct.h"
> +
>   #define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
>   #define SMBD_MIN_IOSIZE (512 * 1024)
>   #define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
>   
> -/* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
> -struct smb_direct_negotiate_req {
> -	__le16 min_version;
> -	__le16 max_version;
> -	__le16 reserved;
> -	__le16 credits_requested;
> -	__le32 preferred_send_size;
> -	__le32 max_receive_size;
> -	__le32 max_fragmented_size;
> -} __packed;
> -
> -/* SMB DIRECT negotiation response packet [MS-SMBD] 2.2.2 */
> -struct smb_direct_negotiate_resp {
> -	__le16 min_version;
> -	__le16 max_version;
> -	__le16 negotiated_version;
> -	__le16 reserved;
> -	__le16 credits_requested;
> -	__le16 credits_granted;
> -	__le32 status;
> -	__le32 max_readwrite_size;
> -	__le32 preferred_send_size;
> -	__le32 max_receive_size;
> -	__le32 max_fragmented_size;
> -} __packed;
> -
> -#define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
> -
> -/* SMB DIRECT data transfer packet with payload [MS-SMBD] 2.2.3 */
> -struct smb_direct_data_transfer {
> -	__le16 credits_requested;
> -	__le16 credits_granted;
> -	__le16 flags;
> -	__le16 reserved;
> -	__le32 remaining_data_length;
> -	__le32 data_offset;
> -	__le32 data_length;
> -	__le32 padding;
> -	__u8 buffer[];
> -} __packed;
> -
>   #ifdef CONFIG_SMB_SERVER_SMBDIRECT
>   int ksmbd_rdma_init(void);
>   void ksmbd_rdma_destroy(void);

