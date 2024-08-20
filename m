Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021077.outbound.protection.outlook.com [52.101.62.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF38F48;
	Tue, 20 Aug 2024 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165561; cv=fail; b=tDXrd3YJvQg80vtqpuWLeF2k1RJDE29SQ+7fdubuvhYFaSOvf6zlq4PInYoTJjJgyE7eGAEOeNIxNRT0g9ktuVYKgvZLVgbIeYR02ec2mhOhO7N8XkWxiRNxSTDeLsWGDBeS/8oWqwaKEl/1/A3yTqs9ieJnMIVLiN/wZpIHI3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165561; c=relaxed/simple;
	bh=kgAgYSBVl1d8bhvw2fYV2W6bOfefPQ2GHwllM4p+20A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IWk4xWMiUPdefdbMhN6O4smEOxI8WLkkLB5wI3Syby+L3UC9gFaLcaCEPyOnJwyUY6l/58D2pu+JQygmZcb9edj82CbTjeLQFl4BZGQ6CsG8ADeqk/QGpQ3KMBQ3QjwEq6OxitN73iV+7Bef7JbNMjbE3I2CWPZEWwgvhL66+sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.62.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJPGFz2xP2D7uF6u6boYXKAL7CQ/XTyCdsi8AvDcl/dEw0ZiqLEBtAUlkBSHcdrIQRi3l52odcqZIaFn1CNovBw7vEZItDe/pTXKIXjAZM3Ne5EOLnGP9GtW8oi0wi+ogpeyZ5Qj9rbkHnDk5jhVeev42C4AvB4jh9PBSugvgFC2blzVN8aUCcr++YnUPAzgA/oQGxB78r+jC1LFEMKVADeg3zBJ0PBAquazIPovtW2f6IakA4z4aUhYrERVGnDgRXl3h93lbU8T+KoWZOagkIzvp97PXpWGRPTezppJ+r0AIPZafN2fVZMxqTFFarZL6v/s+JpSCzMD81fWnxYGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uo8xj9Up4LFWr+86eNPW/18EvnXwA5eR9xNntt8Ym1s=;
 b=SyudslEbpCeJRgIKPB18yDWrxJx/oNDOoc3v//QRY5hCJPC+3MLeQV17oEwO9Ic0hsM6GBRsKqrBPPqH60pT4S105e4Ua+TLH2KFjJVe64JIaxEHiiCheB6+wJ4grJa8rfmAk8PuYYSJDCYRWkilxtTt7EqbgMDFj5gsDHHz0ZJZ3vNKkeUoZ8th0PHmKkFeZbJxSI+G+vw1WJ3lN1NsSTRdGign/TY6rg83k7cQRMFrKmYSvYTELm32lAwzgme0yOLit05aykPWJJCvtvSPrT8fZsZZEJKUoAlj3L7AKVTM58p69Oz9croX/PnwiqfDbHuM+Pqno6DMJi5NY3MDPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL1PR01MB7721.prod.exchangelabs.com (2603:10b6:208:395::9) by
 SA1PR01MB6640.prod.exchangelabs.com (2603:10b6:806:1a4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Tue, 20 Aug 2024 14:52:36 +0000
Received: from BL1PR01MB7721.prod.exchangelabs.com
 ([fe80::d33d:8437:f7d:568e]) by BL1PR01MB7721.prod.exchangelabs.com
 ([fe80::d33d:8437:f7d:568e%4]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 14:52:35 +0000
Message-ID: <d7a30cff-e08f-453e-84f2-4584031e3d29@talpey.com>
Date: Tue, 20 Aug 2024 10:52:33 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: Replace one-element arrays with flexible-array
 members
To: Namjae Jeon <linkinjeon@kernel.org>,
 Thorsten Blum <thorsten.blum@toblux.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240818162136.268325-2-thorsten.blum@toblux.com>
 <CAKYAXd-pm01ietA1+Z4J8tDcLM6fUkAwQ69j9XZs9uhrBbdDQQ@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-pm01ietA1+Z4J8tDcLM6fUkAwQ69j9XZs9uhrBbdDQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:208:32d::15) To BL1PR01MB7721.prod.exchangelabs.com
 (2603:10b6:208:395::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR01MB7721:EE_|SA1PR01MB6640:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d24545-dbde-4015-2b61-08dcc127ba76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NSt5WUZ1SEJjVUdHVC94cFpqcFRZZGlFa2VqR2MyRVVVYkRXalpMelVoZzFy?=
 =?utf-8?B?cjhCMVpRY2p0RVBORFVBakh1SGpjRTZ1NTlnMHpmSmJReDhOMFQySDlkYUh4?=
 =?utf-8?B?N1VkTWl5QVRFTFRZdW5FM1NDU0RMN3VBVnd3MXZ2RmVnL0NMM1pDMk5KK3Bp?=
 =?utf-8?B?cFFMWkhZYVNXVnBrMXV4TXlnM2pLc1M4OXlDdDhBNm50QXY5bnhSUFRjZnFp?=
 =?utf-8?B?SFJqd25GdE5HTXIyOFBwOGhwdWVsUEw1VFNveGpOWWJNclAzNHdvUWt6cjY0?=
 =?utf-8?B?Rmhnd0E5MGtRVWJBZHRoNzQ2dDZDMllaRENXWnFkRnZmV1d1Q1R3UVVqT291?=
 =?utf-8?B?Qk41dzQwcHpxNjkwR2l2WXV6MVJSenV1U1FxZ0dhdE1RdnVMVTRKb2hITStC?=
 =?utf-8?B?TFQrY0VxWnUzWmdaWW1iMnJWVVk0cHJiU2hlbzZDdzZPdCtmWEs0Q1dIcXli?=
 =?utf-8?B?cUVhR2FMeDVncVhmR3VVY0tqSFJZQ3l0KzUybTQ2TWNWOFpHRzNoQ1JlOFIw?=
 =?utf-8?B?b00wdVVOS2YraERVd2RkKzlwN3Q0MFl4eFBpUWVqVTU4R1Y3dFl5WXNteUlP?=
 =?utf-8?B?U2piakxOZ2RlQUNwTStUWGlKN2ozaTB4cHJCeWVOQmNjWkxEd2N3YjFvdWZV?=
 =?utf-8?B?UmtpT3A0QjFWZjlocmNCM0dTbHcxUmlPRGtTZXpRQWp4cmovR0Q5KzllWm9L?=
 =?utf-8?B?NGhuRjBjSkExeXp1UTFpOWkyL0QyQll3MFhKVjQxRVlYS0c4Q1d1QU5wN3RH?=
 =?utf-8?B?YVNTdmI4OEt0c2lINnpZS2huTTRlQWV4RzYyZkVmb1FaVzkzRWJOeVBXVktB?=
 =?utf-8?B?dlBsb0VwQ3M0MnNtR04zODJBWGpsVW5KVU9mSUVwOUVxdEFHYmE5L0phWGoy?=
 =?utf-8?B?OUMzYkNaWEtKKzNMY2hadTFTU3A2N2M1ellURVZlRFB6N2F4NVI5SHBSVVla?=
 =?utf-8?B?VHZkMUxSTlA4T2R4KzhwSzRZSXRJVk9tSy9CM09yUHpGam1ibCtISXNrQ2gy?=
 =?utf-8?B?STBoMTZ2bHlrTS96MFdudEE1SGJqUkVMK0lVejRhWno3N3loWUJJMGNHSlk5?=
 =?utf-8?B?c3BuUFF3ck9BUWlXeHI0L2tkWlZPeVViL1Q1cTZ5N0tqQ2JpYzdhR3dIS25u?=
 =?utf-8?B?azBLSWY0QnNnS2VGQUF3MURJdStGMjZieG9ydG5QeGVvaWNTeWJ6SlVDeDU4?=
 =?utf-8?B?K0Z1dGxyTEt4azA1T0VteUhHZXFCMGtVd1pQLzBqeTBmN0xEbUZtRDdLbnN3?=
 =?utf-8?B?Y0trdWEwUWVJSUdZa2IvalVISGhHeVJYOFRGT0pwQ2Q1dThiSUlpalBDRXAy?=
 =?utf-8?B?blFVYzZsS1lYZG9qSEd4VXg1WHVJZW5LdTdNSnBGM0J4eUt4bmVFSU5SVW5H?=
 =?utf-8?B?YkpSVW9LeTFrdkkvKzIrbFJXQVFoL0NyM0xyVmhpbEtROEZ5SnBwTENzSUdl?=
 =?utf-8?B?MnMvb3NWd1kyQkJhamxlN1JlMHhFK0FZT0ExOVREODI2bWRDQ1hUOEJxY2xJ?=
 =?utf-8?B?SXpBY0FFYWNRNFJ3aXpPYW5FdDMxNHdmQmt2bGdKKzU4c08xenJIWEhWU2xS?=
 =?utf-8?B?OFNaZGRxUnFoYXQvYmxYL0lCZ1g2MlZLdVVOeTlJbE8ybWNZVVdNZjhoSEtU?=
 =?utf-8?B?OHNOa09PSWVwY1NCZmFzNU00MXJKVm1JdUFoeTd4ZVU1K3J6K1dIOEJhN0l4?=
 =?utf-8?B?NmpOL2FyL2xOcHV4K1FMSTBkU0xhaXlHdndnc3NhK016THh1UlRrd0d1WTBp?=
 =?utf-8?Q?XuGWtHUwEnMMOsbvnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR01MB7721.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVMvdzI4cTl5cW5zUG8yOVBDejR6QzRIdmJkNXp6dlhrQ1B6M0lJSDN3dE1p?=
 =?utf-8?B?L2xHTXo4R1d4Yi9jdmxROEdMR1JlTXg4MWtVY05uQ0tKdXpQUTFxNUpoUWdE?=
 =?utf-8?B?TnZGVTduNmltM29LNWliUWNteGdBOFJTTHNkTXpmTGcvUVBuYk9nd2dGcWg1?=
 =?utf-8?B?VG5jSDJkTVdJNDV2SEgwa3VPZE5iVXN5WWV6TlMxc0ZOQnQ1aUE4OVJIa0gx?=
 =?utf-8?B?bnV4WDVPSUxXR1REbk9DNlR5RUtjRCtSem1ialZ6dGlqMVNTREVnZElLUldW?=
 =?utf-8?B?VHZWTktMSXRleTVMcE81WHphZnhUYUhpQ2FPWkxjeHpIcHVQcHkvSW9UOHFs?=
 =?utf-8?B?YUgwdjVYblU4cjE2ZWNjdjR2TFBkRGgzZUhkS2xXNzZlbTdhYTRtTHg2QTAx?=
 =?utf-8?B?bXdwWkFvWUVjMWtnSGg3eVFZOFJnWVQzWTBvR1UzcDRTdG5sL1cvWGNvOEFa?=
 =?utf-8?B?cjNGNUZhVUgyMGljSW1IODdMNjdibENOM2VNdE81SDhTSFBsR3c3dEtNOHMx?=
 =?utf-8?B?WXJyM2lwa0I2L0xOYWtaa2pHdFhKazNmWFFseHRPUU1TNis2b0tWdnByMFRj?=
 =?utf-8?B?eUxJMjBvS1FUZlBMOHVzSUVJSEEwbmNhbENpSk55em9YelR3WHBhbmNZRkFH?=
 =?utf-8?B?Y0FTdW1GN0p1QTR4TFdFTkl2T2RXWmk1TXFhTTJlcXBldEVIc2tuWFYvZXM4?=
 =?utf-8?B?M3VwNnJacUVmMStXNjVoZHZaKzVZc2lQaCs4YUJCY01Bd3lybFgvYS9aUWVC?=
 =?utf-8?B?aEl0N1RFc0Flb1Rab3JIZTZla2JVdGZ2M1Zza00xLzRWT0R6OGZiWHpjUjJU?=
 =?utf-8?B?TUhNTGJITktKais2WGVBWWNhSy9vdlpNZkxidXZOYXJrTEFNUDM3OEY5eGM5?=
 =?utf-8?B?WkJhdllmUGZDdDV0OHdwWGhIdG5Ob0ZsK3EzS00yQ1Y5aDAxNUJiUlJEbDhk?=
 =?utf-8?B?S3JMc3JCb2x4Q1pNdEUrdXQ1T3dKYXk0aVE2TWhHMnBLRHRuRjhJeGYvNFRh?=
 =?utf-8?B?eVlNZGZ5WlN2ZlprOWpTMEJ0RGViRjNOSnpvSTB5RzIrQlQyR3hxUG8wR3Vw?=
 =?utf-8?B?Z2FTYnk5cUovQ2hNL1RPaEZZTUlYcVdzRXNlNW9pcDEvTmlWK1RkN0R1N1NG?=
 =?utf-8?B?Zm5oTFdqZmIrb2MxNzBqRmlYN0RMZWV0cmIxd3lERStDejdiMFMzUVFPMGNU?=
 =?utf-8?B?V0JINjY1U084bTZLQjJIa0taZ3ZXN0dGRzk0QXVid3hTVE9yNEI0Nlg4Rm9O?=
 =?utf-8?B?OW4rQ2t1WktTcnZQV2c3dXhIVVhBbFlUMzZFc2JsUzlCK1NZblpHcHZJZFAy?=
 =?utf-8?B?SU04bjIvbWdNOE90RzYvb1pqNEJPT1g5VUM1Y1pMSExMOU82Z1FPZlRhWk56?=
 =?utf-8?B?MmQ2TG9ScWpncCt5WjdKclRtNGF5VktiNkNCMHN0dFhHeGRtaUxJcFpBWUpJ?=
 =?utf-8?B?M2o2N1pCMkVkVzRmZjNsNDBDKzNuK3ZYZmJ1UXhiOVlQVzBTSzJXVHdIcEdK?=
 =?utf-8?B?MHVvZUZLNUhVSlpqRGFYVm1sTjI2aFVBUVIrbVNQT1V1MkUvSi8zbU51QTNs?=
 =?utf-8?B?QTdGODhZRDZxQjk1eEFrMWlncTE1Zkk0czc1eE80Z1YvOHExWVUyNVFjaDdo?=
 =?utf-8?B?bVFJdlZrQ1RYYUVzVlhvNG5Oc3RHKzR0bnh3eW9oc0IwYnlOK1FJNGtBR0xy?=
 =?utf-8?B?aWN5UTZIOVpqcEkwclJvaEpDNlpkcTk1eXlkRGEvK1Z1SW9LSDAxYWlNc3RZ?=
 =?utf-8?B?bUNyYzI3eU52MWdsUUhmOHRnWmJpSnRZR2xET0NLMEMvTWhrWHlGMWJEVmcw?=
 =?utf-8?B?NlVvdE5DalZlMlR4VEFWYmFwNTNJZDRLWXU3MTJJYzgzZXNHQzVkT05nTGNH?=
 =?utf-8?B?TFUzMGVQZmN6MzBQQjU4RWZsSDhPTVBEMEd0ZDYxbUZDVXNGN0dkcytnK0Np?=
 =?utf-8?B?aGhVTlh3SmNkODhGMjNmNDBZVGpaN2RxOUs4MGhnUXdMeWtUQjFDZ1RzcHB2?=
 =?utf-8?B?MjE0ODNhL0x5WVMwQ2VEb1Z3UlZNTnhKNXVMRnZjQTFDdlZDL0o3TFhaK1dT?=
 =?utf-8?B?YWRVVG1zNjRMekxVMFRqS0ROV0xuQ0o1NFFzejlxc3FNSGQ5L2p2bGtKbVlv?=
 =?utf-8?Q?/FZY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d24545-dbde-4015-2b61-08dcc127ba76
X-MS-Exchange-CrossTenant-AuthSource: BL1PR01MB7721.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 14:52:35.7289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiFokl+A5a8XPhEnYQStuOarqfT8JgsALJxif+iztntty/YiAaQCbrZORFqNjMdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6640

On 8/20/2024 10:11 AM, Namjae Jeon wrote:
> On Mon, Aug 19, 2024 at 1:22 AM Thorsten Blum <thorsten.blum@toblux.com> wrote:
>>
>> Replace the deprecated one-element arrays with flexible-array members
>> in the structs copychunk_ioctl_req and smb2_ea_info_req.
>>
>> There are no binary differences after this conversion.
>>
>> Link: https://github.com/KSPP/linux/issues/79
>> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
>> ---
>>   fs/smb/server/smb2pdu.c | 4 ++--
>>   fs/smb/server/smb2pdu.h | 4 ++--
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>> index 2df1354288e6..83667cb78fa6 100644
>> --- a/fs/smb/server/smb2pdu.c
>> +++ b/fs/smb/server/smb2pdu.c
>> @@ -4580,7 +4580,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
>>          /* single EA entry is requested with given user.* name */
>>          if (req->InputBufferLength) {
>>                  if (le32_to_cpu(req->InputBufferLength) <
>> -                   sizeof(struct smb2_ea_info_req))
>> +                   sizeof(struct smb2_ea_info_req) + 1)
> We can use <= instead of +1.

This is better, but maybe this test was actually not right in
the first place.

I think a strict "<" is correct here, because the ea name
field is a counted array of length EaNameLength. So, it's
a layering issue to fail with EINVAL this early in the
processing. All that should be checked up front is
that a complete smb2_ea_info_req header is present.

>>                          return -EINVAL;
>>
>>                  ea_req = (struct smb2_ea_info_req *)((char *)req +
>> @@ -8083,7 +8083,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                          goto out;
>>                  }
>>
>> -               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
>> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req) + 1) {
> Ditto.

And ditto.

Tom.

>>                          ret = -EINVAL;
>>                          goto out;
>>                  }
>> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
>> index 3be7d5ae65a8..73aff20e22d0 100644
>> --- a/fs/smb/server/smb2pdu.h
>> +++ b/fs/smb/server/smb2pdu.h
>> @@ -194,7 +194,7 @@ struct copychunk_ioctl_req {
>>          __le64 ResumeKey[3];
>>          __le32 ChunkCount;
>>          __le32 Reserved;
>> -       __u8 Chunks[1]; /* array of srv_copychunk */
>> +       __u8 Chunks[]; /* array of srv_copychunk */
>>   } __packed;
>>
>>   struct srv_copychunk {
>> @@ -370,7 +370,7 @@ struct smb2_file_attr_tag_info {
>>   struct smb2_ea_info_req {
>>          __le32 NextEntryOffset;
>>          __u8   EaNameLength;
>> -       char name[1];
>> +       char name[];
>>   } __packed; /* level 15 Query */
>>
>>   struct smb2_ea_info {
>> --
>> 2.46.0
>>
> 

