Received: from SJ2PR03CU002.outbound.protection.outlook.com (mail-westusazon11023099.outbound.protection.outlook.com [52.101.44.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BEF1E517
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jan 2025 01:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.44.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737508552; cv=fail; b=t8kkpDV3y8BTeQHNG0K7EYz/AfTkfMMkpRL49EN8M/RfB1QXeIdLZbZ2KnOPN3uRitaNpDS/v2PR7dzCD+lz0Wb1U5vbKOhTuH5TfkVF9dod/cUA3TrGIpM/ny1LspBeHRuy/XjVXQSAo7CL7HlJdELJR7IESpTV+bhLW5k2Krs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737508552; c=relaxed/simple;
	bh=+7QvGa5d0f1o2NlIY0hfD1WZtWA/iL1sRvNMVgCPkkE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UYbqP5/G8rHm/7tDwAKXS22xnDZPyrdKWZ1gFnEO8PqOp8Nhm9CvkyNPgL/dFOC3Q8mdTW0KCKCjdIjdKJgqtcgSlQ0WLzkp3e/EGExDmbGCcTqAYHnATD5mJ3pc2cmx7KxmKdugCrB9sI0jb+KdIETySlctD1fnJyg+4F5crZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.44.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U61yEZQhdtnJzadG4l+HHK7M+U5CNFqJjGej2ys6yqKDXGZbHiom/+UvKBkeAFoDiDvvfjKn4XUA6G27lkE+PEhfedwFcaOTNZNOr9fjv9GwD5bV/hElDnjx7O8hrsPdDOCD1r39w/7F4OPpAUt0SmH9AgzF3oDR0bLgi1KdnbbWSRbXmzyv3mOmXDbCmhM/JmqWISy64A0Lt8KusSgBJ0G1S4R/sDt3IMGHf13inqQijE8BZLixcOM7Y37Ut54DQFt6PzlcQ2GJsJwGx2Tv5InuPn1n1dscuB1u0BbsfF7mgSnR2iDJIr6sb9oWmmsFgpFAaYQyJ6lDWCbWnQEs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5hIrbB8mQt6QKdNY9innxNfm17Dl99g4D0N4X2FKbas=;
 b=JFj3BakYL/z5u+lOMj/ujGUlfNg/9sTI0wpxOrYLioLSCvYp6caUWEzxoYRhcWs0emEsAy3ZCymOTI6gQ2ijoZO1I63VfswP5uH5jpTyA9Tn1UUFHYHmzA49V9sBxV0881iAZ3vn7XcymItV9f/v4jjAyo+8h6C9wemhZfiEyBLCUxjVdMRVzreBXxgiQm+Ew1xuLw73XoXvbAgkP/b2Pk6x0GwAvcgzjblc+4KkKjah5glkn5sklmgaekLFaDxMDnl7XEhWw7d+SId5X8ZQOd7Pbinkc1iO4yUjgaOz/3MHlWXrUxU3FZEJ8lDF7Mmqh7xk9s72Rctwg1W9M6au/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 SA1PR01MB8179.prod.exchangelabs.com (2603:10b6:806:330::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.13; Wed, 22 Jan 2025 01:15:47 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 01:15:46 +0000
Message-ID: <7fdf8d1c-0294-49a4-86e0-325cda743946@talpey.com>
Date: Tue, 21 Jan 2025 20:15:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Fix printing Status code into dmesg
To: Steve French <smfrench@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5msUp2xqY062MRRXkNApwekZ_CJYL3q_J0boGFPzw4W1LQ@mail.gmail.com>
 <20250120175449.5i2a3bdd7xk2xjm3@pali>
 <CAH2r5mtA4Xr-tkNgjLpGqbOn60Rms2=52AfrLG-F6RwqVJfbsg@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtA4Xr-tkNgjLpGqbOn60Rms2=52AfrLG-F6RwqVJfbsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:36e::25) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|SA1PR01MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 98fe7809-487b-4513-d751-08dd3a824ce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1gzeUJTR3IvbXFtYmd4am9oL2xOSCs2TElTWE0vSDVPTFduMFBnWFFYZnhk?=
 =?utf-8?B?UWNlWDdkRnBNbHZOMjByTGFqL0Z5VzMwNDRuaWxpemovZGpZVG50RFY1M0RL?=
 =?utf-8?B?MWJyano2SXkyRTlLWEpyd0d1VDFncm1UWkpkV08zd2Jrc2VDb05pZFBWZS82?=
 =?utf-8?B?UFI4RlJIVHFGSitucGVjb1FqZW1QQzMrQkhsbHA1M0J6UENTanVtalRBQ2cw?=
 =?utf-8?B?OU5lZnpObHYyQ0NVUjJwRVk2R3JQdXBYSjNzSkMvcHlWdzJtb2VTVGxzc0Zl?=
 =?utf-8?B?dXArVzRPQUNWcWFrZ2pzL3JCTWJ1ejU5SDFmdmlrK0VDTTduTmcvYWxhSUky?=
 =?utf-8?B?SFZoN3NJV1RPTlZyYStCOFEvcnZOcFlVV3FIdWhSVGpxK0NLSXRLdVRZTU92?=
 =?utf-8?B?SS9RbzRGWDM1YTJwUXJLcXAxL05rbDNtQjNOaHErcVpvSFVFNVh0bWUreW9O?=
 =?utf-8?B?alBNQkptUE9INUNqY0VpUldud0JXQXNJNGVHaHVqaloyUUZ5aHpEakVGWW9P?=
 =?utf-8?B?VWlUZ1VPYjBGc3JtbkRtT2h0OExiRkhXa0NkTkdaRXFWWVJVb1o2cGp4Ni9l?=
 =?utf-8?B?MjFjc3dmRXVuNTdGY2h1V2FEcVk1MGtGMTNHMjJrZm5ZczlpR0xOM1ltNThX?=
 =?utf-8?B?YWpyWitKNlFXUHNxZWMxRGRUUUFuTzFhdUhEWlJKUW1nMG04K2t0TGt6Y3B2?=
 =?utf-8?B?ZmYyYngxWUYyWHhWbkQ1QmptNUk1WWliSDBmVGs4UE5ONTJ2OU1SeVJtS09M?=
 =?utf-8?B?K0VrOXNTUUlYa3dwR1kwTlROSktpWXFzbURFMXZuMWNZZ1dVZnlHZlI2bFUw?=
 =?utf-8?B?TFRyaE5ia3FhUjhyVW93NncySFhUOXhUTkJxZk95NlNSSUhDOGZiaEp5bUR4?=
 =?utf-8?B?dDhnSTRHcWVkSkV5L3hocmZvL2ZaZlVaVXZaRE1pWFBjVWRUS1JEb2hWelRl?=
 =?utf-8?B?Z1FrMk5WSm5WeG1hdkFhRmV6OWN2Ni9PNDFKT2JLTEtDU2R6MVlvbzhGaFpz?=
 =?utf-8?B?K1NSSVEzUW53dFJYUE5jeGs0ZjRLa3I2Zno3WGdkVWZyRlEwN2NjRUJhVHV3?=
 =?utf-8?B?RDVBM2xYME9OeWZNMVZmbTJRL3A1elFyc09ZTjRBaGhZTkxTQ0JqSnRrOU5W?=
 =?utf-8?B?RzgwdWpFc01rTU5ibWpTelBySzBOc01YYjN3dUpsSSs5MWhWMVhUM051amJ5?=
 =?utf-8?B?ZFNZZzV6RDRMdWhYaUdyNG45bnpsRnBuSDRDWS8yb05ZeTVod3VXK1NRTVRh?=
 =?utf-8?B?bDFWQ2Q4R3A5Si9uVk5LcG52T1BvcDlWNEZ0NFh5c1g0WlFEdTNETVk4RG40?=
 =?utf-8?B?YTVHV2R0NXdDcXhWZzlqd1R6VXJXcVNXN2g4UnViMFR1QVJGZ0pIMlVpNlE0?=
 =?utf-8?B?VTBkUFdrQzFzVVE4N0lzTFBEMWp4dTBCQlhXUUNIaGtGMUZLcmVZRzZPcS9j?=
 =?utf-8?B?ZjJlTFBvWllEMi9hejRkZDcvOU81bVdlZEE3ODdoWlpMNW5rcmJRTjQvNWM3?=
 =?utf-8?B?aVJTMk9kanlWZmZaVXRHN3FRdlFiSG9NQ3JkRkFsalVPWUlIcituR09RcUJ2?=
 =?utf-8?B?akpEQ0ZWZnl1a0Y4KzJ3YjIzRnhBYzB3L21PbjFKMENXYWxUMTMrUjhQd0VP?=
 =?utf-8?B?YkxQT3pJa1V6RDNCa0pyS0lEdnRCZm5HcW8zbW80VXhWRHhKUXRMQzJydncw?=
 =?utf-8?B?dXFzTy9kYnAvRGpLVkl6dUdSN1p2dGphSXNBMXRKMDErV0hFaWdqSm16QURi?=
 =?utf-8?B?dDRNTnM0clU3UythdHRQNkRab0lIUkxWV1NxYlB5ZVZjdjBrVmk0ZlpWbDNm?=
 =?utf-8?B?aXhMRHRKMUtYZHlmUi9adz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N21ha0pUdng0NEFxN2NSVFlJN21lQk1nSkNMU0pIR3hZcXg2UlpJK09aNDRR?=
 =?utf-8?B?VWRKN25qaStVUTRHaW9iR3VwR1pMeTlOZnZnYXRzeHAwVVJTeklSMUtrNHM0?=
 =?utf-8?B?VTZuNmlHSW0xQ21GTko5REo3aUUrb1YrK0RaMVN0QnIzRTQ2STdUMXJ6clJU?=
 =?utf-8?B?MVJ2MVQ3SUEyRGdkV3E3Z1E5d2pidjNwV3JZWXJGNWZJWlhNSEtHMEZXUXpU?=
 =?utf-8?B?NW96RElSK01QV1VneEFaVGVQeU5rZ1FxUVpNVnFtTmVuWTFQOTZSVEVTMTFM?=
 =?utf-8?B?bDdLMUR6NW5raWRpTWlMeCsvZkx4ZE5tRXNRMVAyekhoRktjMkQrNWRTWGV4?=
 =?utf-8?B?c2g1YnN3NW9VV1pLRjhkakZ3NFFEL05JNkEvOTJlUlg0YjFHajFLcURwYkVD?=
 =?utf-8?B?S212bU5VTVN5eWwwTFc4N2pzb1gwcFdUcFFIVks1TmdOcytza2t5ZXNxalp5?=
 =?utf-8?B?bVdCTnc3L2lWNXlsODQ5L3A2WFJPTDlMZ1VhN2toUXBNQlZHTFFVVnBGQ21i?=
 =?utf-8?B?aHFSY2hLanBtTUc1V3VaRWp6RlJZVFRxd3VJTkVQZmJJWWJPc1JQL1pGNTFH?=
 =?utf-8?B?cSsySklVWXppdnNZcHN0eFBuNHZTc3JlVWIyeXpnK0R1OC9pbVFDQ1BlM2Fk?=
 =?utf-8?B?RGpGNW5WRlZtcTJ5Sm1yWXNqOGZRdTVuQ3N6emZpaFlFSjFQdWFxT0VXK1ND?=
 =?utf-8?B?dzZuZDRkZVhoeHpTTHgxa3ZMOEc4RzBja2tBTWg5bDJDN2dNaWl0VEgvQTNZ?=
 =?utf-8?B?WDdlVWI1MC95cGt1STgvWkRDRnJsTlpINDhpSFY4Zk5ZWWZSVmJGK1U3L2sy?=
 =?utf-8?B?NnZNU1M1dnZJSE9NOUlCN256aXV2SkQzWFdrQUpyc29MckdqOFYzNFpWRWdK?=
 =?utf-8?B?SG1KcDVObkVMZ1BkVk9iWnhtL2UvdENuYnJjdnBScDJWaXBaa3gxb01INWlF?=
 =?utf-8?B?Rlk4YkR4cmRHNFp2bCtVYUJrMVRaaGtCWTg0bjBpVXBadUk4aWtPaXJ1cmdl?=
 =?utf-8?B?a0tsKzJ6Z1dqakRiUlB1VEpON1lMMElTaVJERUFCOFIzQWw2ZXQ0NWR4QWtQ?=
 =?utf-8?B?a3gxU2l0bHd1WlhUYkxnVW1SZ3laR1BQUjljblZrT2t1ZkhGaThNSG0xekNx?=
 =?utf-8?B?RDJKUGpzc3Ftc0gyYjV3SGtWSm1LcExxVlZyMHB4MUFkU243clpnZ25hWTRs?=
 =?utf-8?B?OXZMWWVmbEFsS3NuZTh2bGNTQWloN2tzUGxkckxFQkxveFRMa25QdC92dE5T?=
 =?utf-8?B?eE9KQlFlaHJiRmF2SVVOSkREVGI4VXN5V1NtalpPWUxHRFJRRUxod3N4TS8x?=
 =?utf-8?B?VHBzL0hxNG1tbmZ1UlR2ZG9kQnVWUmdYT1pGZ0F5VnIrSy9BVFBEWWJtdkNJ?=
 =?utf-8?B?L0xrbmZWd2xHa1V6L2dSTkZLZDlxVHFHU0thMnhQaU1sdlVmeFU5ZTBWSmpv?=
 =?utf-8?B?ZkgyM2Z3QzJxbHRxRWJ4blZvN2RyVmJ3dHl3eHVlRWRqVWdIQzFWaDh4c3pt?=
 =?utf-8?B?bjA2S0IrREh6SU4vRWRoQmdza01JOHV4eDJacHpqbmQ5Z0RyY1pYbTR6TFd6?=
 =?utf-8?B?RXhla3Jub2QrSEpuODBkKzRWMFEyT2t0dXVCOGQ1Tk11bWJSQm0rVEpOakNV?=
 =?utf-8?B?UEtDRTQxRWlmYmpxS21uY1hmZ0c0S2ZubHpFOTY5OXhtaUtYMjVUbjlneWRT?=
 =?utf-8?B?TlpFYnhQOElWbGI4ZStJTkR5RnZGMzFJbXkvcExmSGJlS2c3U1Qrd3c5SFJH?=
 =?utf-8?B?eWRTQ1g5eDJlaGlWald6cHJkVm5hMVE5NlR4Ky9laHhMMHpUWlBQU0FUbFRR?=
 =?utf-8?B?NE9Oc2VLUGt4cWNORVVnc1dpWG9peWQ1OVBSWTVZVjhTTFRZb0x2UVIvTCtV?=
 =?utf-8?B?bklEd1NDU2tXR3JBZHZWcVNkR1gxMjV1Wjlla0g5eXB3bzZuQ1kvNGdIRm9C?=
 =?utf-8?B?NlVSQ3JQNGFJMXlFQkFwTWZqTk1wUktFQlVqeFJ3b2pMTlN6K09FT0NlWG1H?=
 =?utf-8?B?aWVwZU1WZlhGQklMZ0lFbVN6YUIxeWVaV0JMVlRuWTZyNEdMbTg4RmNrRENF?=
 =?utf-8?B?QlhldFJVRTAxUHRsKzlpTFgwcmVJTjRUZzFKclA4UDZ1RnpXd3NyczRTV0l3?=
 =?utf-8?Q?5h9malxsmJAoZUwoDDs/5ZFxZ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98fe7809-487b-4513-d751-08dd3a824ce0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 01:15:46.7808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmJqdkA/13diTfnCbzgv9pcWCuV2z7kxfEful9DJ5oMzygTIVgtk7TPUyxb3DjAK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8179

It's actually not a 24-bit code or a 32-bit, it's a structure with
4 bits of flags, 12 bits of "facility" and 16 bits of "code" (which
btw means 28 bits not 24). And then the NTSTATUS shares its space
with the HRESULT based on the "N" flag - see MS-ERREF sections 2.1
and 2.3. These are constantly being added-to. So, it's entirely
correct to treat these as a 32-bit quantity.

It did surprise me that these two codes differ only by the "warning"
vs "error" severity value, yet they indicate entirely different
situations. Very, very odd. Fix looks like best approach.

Feel free to add my Acked-by: Tom Talpey <tom@talpey.com>

Tom.

On 1/21/2025 12:45 AM, Steve French wrote:
> On Mon, Jan 20, 2025 at 11:55 AM Pali Rohár <pali@kernel.org> wrote:
>>
>> Just to note that I have sent this patch in series with "cifs: Add
>> missing NT_STATUS_* codes from nterr.h to nterr.c" patch which is adding
>> also NT_STATUS_STOPPED_ON_SYMLINK (mentioned in commit message):
>>
>> https://lore.kernel.org/linux-cifs/20241227173709.22892-1-pali@kernel.org/t/#u
> 
> Both of these are in for-next
> 
>> On Sunday 19 January 2025 19:48:39 Steve French wrote:
>>> Any thoughts on the attached patch (which is tentatively in
>>> cifs-2.6.git for-next)?
>>>
>>> NT Status code is 32-bit number, so for comparing two NT Status codes is
>>> needed to check all 32 bits, and not just low 24 bits.
>>>
>>> Before this change kernel printed message:
>>> "Status code returned 0x8000002d NT_STATUS_NOT_COMMITTED"
>>>
>>> It was incorrect as because NT_STATUS_NOT_COMMITTED is defined as
>>> 0xC000002d and 0x8000002d has defined name NT_STATUS_STOPPED_ON_SYMLINK.
>>>
>>> With this change kernel prints message:
>>> "Status code returned 0x8000002d NT_STATUS_STOPPED_ON_SYMLINK"
>>>
>>> Signed-off-by: Pali Rohár <pali@kernel.org>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
> 
> 
> 

