Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011007.outbound.protection.outlook.com [52.101.65.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B3933E36A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702088; cv=fail; b=iR1zfb3Rk3fEAqbXEJh7asAZu4nhX0Y5b6I8m1wWpZO9lCfPeoaaQWV/VJxHH4hc7NTuekc1HGdaaWu26zNUJjMFNKG1FNVt3EOUEZsq3a1ZRW2rRKlQlJ5OvMtomoIxoUtLbA/+pbMCGD4S2fNjg5LJq04JA2d14C9Or9ZmlHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702088; c=relaxed/simple;
	bh=h8W6E0mL/2FvvOvr+F82/XwEO1Y4d54iXdS00WP99kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OzX6G9Z4RQhxFZj4g2EjRoVZXMVJqnLSAMqDPeChhrI8kfRDG8UhNExQhaGNonVepta6CO2yq+SHqW+RIes9FsFspQF1BVgiSqGgTZrw0ja5cvfegoYPnDJRsD943JRpXFN3uNw7KRkcPFBv+n9GytikZzr/vRksQU6O7r3yKQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=L0rHWZs8; arc=fail smtp.client-ip=52.101.65.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="L0rHWZs8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CoilvnOkbGRrD0UlLYLM6fkDkbh9S89AFNMOp7tcZq1ezbiqa+RaLRAxq6rfNvQxDgzb46AiEl/VFVI3E5fShSNCczZoPn6oMKhcsJ93QJMCYOHcaUgxBwhxTqKz41ZPHq3GvpgHKy90C0woz64WhsG09iXzc8TG817EDdzONiXEiY/XhW1Y8SbpClKaWEgVf/XBjiDB8J4DOe+9wgIJ9qjcPK7ngvOHQhXqEKTaefS+FhH6F68ZxxCryiVb+DThiMixygdLyEaoDBW3TJfVR7aurwH5f2mxXX0aoAxnxB6WTR1wZfpKDxRG3VFBnBWu+onBFjnjf1nScrj/KSfd6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0EcBpQZV1fPFRKGjow4Z6YRzRkxJ3PCxjpr/tFHLgI=;
 b=X+8lqXXXje5O0y2+jybnjGYmQkeGxlqF49OqtL7U4l/6WmSncbdo8XcNEnGEuprt/zKmYp3cMYW8+oY6IdPOGgBQJh42o7+lP24BsgjxJjA7r14l+DpByvZiW8ndEqSJDf3E/SYQZtstvkD7RuNfiMEQU4zN6UPYSus3t+oxWth00Cfs7L8HCsGwrcQx/lS2JtnZ4dDSjKHoZ9az955T6iYzIQQqekcEwGgrvSc8x6Mp3A25ORa9iX8kgJwsfxupWA7x5IeLZwXER01cowOthfJb4pR+qzENofgXdRnSnrpIqWzYcrU1kK4SnaUBe4VTM6NRCCE5DW3RYzipB/+aAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0EcBpQZV1fPFRKGjow4Z6YRzRkxJ3PCxjpr/tFHLgI=;
 b=L0rHWZs81B58g2YNqPkXHUa1ef33YJSur0jURSI3MjJ+38qVc75Bqo2vgimsd7dn8pX/YN9YEWUge//+4jeASWPMskcUTqoU5RBta48iBQXgmbkAzcJ44f2WiYMTSvKHm2p76PNRK08OzRI1/FAgCtnOEhekw3PYWQj3rrjWX+N97WwkR3cvr0QXlxdQLCFTxZlM/sWE0De3+ZUWVG5MEQdu2jaJCBOoFiqsqVock4BUClr66Gh+00LbTFrNE7CodNA0EF1HZygM2scsCDIXsHUelWvZn27Pr0ccideKTUF5cb0uxKw7HJ1+4Ren3g6LxxE/OZOdtCAsJOa8fXvhbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI2P189MB3587.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:297::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Tue, 25 Aug
 2026 23:54:41 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.006; Tue, 25 Aug 2026
 23:54:41 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Frank Sorenson <sorenson@redhat.com>
Cc: Yunseong Kim <yunseong.kim@est.tech>,
	linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	yunseong.kim@ericsson.com
Subject: Re: [PATCH 00/11] smb: client: fix OOB reads and UAFs in SMB2/3 receive paths
Date: Wed, 26 Aug 2026 01:54:30 +0200
Message-ID: <20260825235434.765005-1-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DB9PR06CA0019.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::24) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|VI2P189MB3587:EE_
X-MS-Office365-Filtering-Correlation-Id: d138b5c7-60a0-4a00-22e9-08df03043b00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|23010399003|10067099003|56012099006|6133799003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	3ZUSMYdbSmS2fknZrVHP8j/2eSjiGpSiObmMQvLi7OUS/PvWMNa1HrDYt+yryDOU+dnSHTOifqXuCrcPFT1d0KFYH095S0B+aTUdlHvXEW3p4JdVJ1BgupaBZWrgnfPHRsi1voDpM4L8LpksQeUKhbmayWshZ2pqb4lcU2Y2gOYQOZLdY+NeohHif21WV/fV6uUrKPXjo+irU7jknvKHix5279m9Y52W4JZMo7cITQRuqWSqxwX/nQI3OpVEStHNJuFRCPmnXj3Hp1AjWkUIAWcWmzrGvooki14TOlW+fvacST19QrpYs4XfnTh/6kINnEHwZKxg1poot/4t89jnZlyBJwmYwboFpYFskXM2NarO9uzUkR82t/MK1TBnJFVIMPpeTy735x8xJZXHR5hhjtAVqvS/r7p9i4Q9vjoxWSGoe4mP8aagKIqWmtlx3nzdGr/bOszmQ121iNmjmtRgRnrzNosARDg4GFONUSa8Xoiyhm5u+JGauTHZiYzMUbj1kBxXZFAyHzf7wZ0dDsCcdlXEI0XOKSL5d7pDgCDbmDFzmdt71W35BQ1Vh6WvTX1dSsZw2XyOpImUuYPzm/eYtgbgs5ce9u6eUzzEdjECLr03ZsziB37NgbUagRhL3jh+G/pcnGt8Yp+fP1NNCsp/n5uKcqoATMaZ8sA5TAA2vDw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uGCAuVs1fGnmzQ+MLI3epavRi71tlfRtZ2pqVP++Wdbdb0/yUfnwCp89vw4j?=
 =?us-ascii?Q?uMIcJ7tvmt6A16ShCETFmzhzVuBTxw3oJVs69EAw4FQk3oZIcRMFQjtB2nwC?=
 =?us-ascii?Q?D1UkAVlhZ84YOv16H6ZmaCXfVRhxtdrp9ttijq3YGlxg80qZYy02dSMMT3WE?=
 =?us-ascii?Q?6HtTTEEIaFEMTLpAYT0nyW/dNiUP7rDEoY/x37OFlxnx2Lzt1+CzqMnjGdUX?=
 =?us-ascii?Q?avt2iYLzPbn7tyK+b5azeF4y1LkokGBF70h5FJ/bkufxQrA7DCFvQEVJhH48?=
 =?us-ascii?Q?5Ru0dBMwAaIiHQEo6p5a5qPUJ//JUwDyd6fXB/3zubB+tNXJIT9u4oHGXbq0?=
 =?us-ascii?Q?fZmapJ6t9jliYxgXAZSx01MByIOEBk7mfHkXkRofy9qrFZxOmNt+PPLNnvce?=
 =?us-ascii?Q?fyfndi8J2/dLlJ+OZXRByCPbJk7zCZUXZ/0Eb5aUJ8M13xNbwnnM0J3dxgxD?=
 =?us-ascii?Q?2WI3TWA9vikXECau+VKYa7N0dZQaj8+su+HjskfPiIl3hVlpB9FN0Ax57CPa?=
 =?us-ascii?Q?T7dY+Mq7Eqg43MoIXnXCrG64leLRGw+z2FqpuJ4njMmmzK3J88MBP9YscZ8+?=
 =?us-ascii?Q?tnyvVU7sxu9kGwbg/vGuEnyBHyCSrOVIVanpKSLVMuQvkicwrs3T6rwGipgn?=
 =?us-ascii?Q?AqH/AzHUn42knHgrL3AWZ6NAWBetlOpTXPWKmgIyHej4goWp7CisHHBsFI2N?=
 =?us-ascii?Q?cS6N5mxrDkU9ubSp58WOYr/X0SbxER6lhTtzJ5RxcHi4ZEsEf59NpXvRK6u2?=
 =?us-ascii?Q?LKbZxfVuSozOk4gHXx/jPZf0jNSQpQwxUPh9P5cmS+QiIMBPY72M6TYYMOdi?=
 =?us-ascii?Q?9LDGTNIp3y5HpPPGwGeJvmrxOD9rD73/aTKizlhCK1ca/AgYrBtluzKMiU3a?=
 =?us-ascii?Q?VUYD0HnUBVMDwtXIF0jGI1p0S8vFLoZfd33h2AR3Qq1AWK0XUGT2yLrXrm6M?=
 =?us-ascii?Q?OG5o1vV09Hra3nsTEOqDxI27s/6sOIoY4+2deQ8DFpw2bGKIQSBC46LaDH6M?=
 =?us-ascii?Q?o1CiGsSNYt8VhX3Go6pXziCDfRBGhXaXUNemz0U0pKwuizUiPAIOfvl1dvjo?=
 =?us-ascii?Q?VU18drp8hZa5tKynLz04NlqKQXSmGnXol4jbzOIQKHdk+lyCbCio3qHt8vSZ?=
 =?us-ascii?Q?j88zo9kZHdDE6ms33LCEozme4iorLqiiCOf9Fv2096mDehVpaq1B+8zamapg?=
 =?us-ascii?Q?bW6WlxiVS2zmo3i8g4hMmuq4E6W0hqNUQjkQmvSw+F3/oiDDX0kb4D7lN50r?=
 =?us-ascii?Q?uGku5aTQBH/lyCE1hdYqxB4aDhRgsCU7xSDLGOvJSUKSq2wVH/8xCyzTrpJ8?=
 =?us-ascii?Q?qoRGW4/BwQ1fKf/RteZjQ/U4/1WT2laA70DeXwjFLhiZ6EO1ffukba73tD+K?=
 =?us-ascii?Q?pM7mMjSYSeSBfYQWWWX/Qk3tJiwHukPWCiTmyrACk/DZG8ytzHSTIITQxvFE?=
 =?us-ascii?Q?IxBgUt1cOnwTerEu+h09l/gLIzL+Lecz4I+4YBjtDsDPNBusOeBCj1izPMFt?=
 =?us-ascii?Q?wjZHWHqog6bNbIPSuifGMboY1TXzEA4EM+r6WQKNCVQ3B+q/pDfnKTaU+tVK?=
 =?us-ascii?Q?0NFSjnfuyk2WOGsrz/b7H+tljw1EWXobkLzWvq5nNHONGmZh3KeRxdb/BDyy?=
 =?us-ascii?Q?0oykG7XywcNejOGU7qFpGjlnqNdomyqRFY0U5D232/t7NiV8zTnvPZ1Ztigg?=
 =?us-ascii?Q?pUkZeAYvFo1MRnVe6IDovs9aOHgAXho9FjLH+zEp2ypAoCw7POWaw+ZuduP9?=
 =?us-ascii?Q?1QoulxGQmluK1GV3k54egx5HcJMWXevW7MJOjW0TIEcW//0YA1TdD40AE4Ef?=
X-MS-Exchange-AntiSpam-MessageData-1: dDrmgeJASMZNmA==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: d138b5c7-60a0-4a00-22e9-08df03043b00
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 23:54:41.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXEb9cSdUjf95Kc9SiGMGY4+HtwkOXl23fvxGirIeZUK1rjzpYheu7VvuQ6e7YesRDWfCx8eiCcmNLykCE1cvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2P189MB3587

Hi Frank,

Thank you, for your security works!

On Sun, 23 Aug 2026 13:57:56 -0500 Frank Sorenson <sorenson@redhat.com> wrote:

> This series fixes eleven bounds-checking defects in the SMB2/3 client,
> all reachable from a malicious or compromised server.
> 
> Patches 1-3 address the compound encrypted frame processing path:
> 
> Patch 1 fixes four interacting bugs in receive_encrypted_standard():
> a missing lower bound on NextCommand, an off-by-one upper bound that
> admitted trailing slices too small for an SMB2 header (producing a
> write-after-free via next_buffer aliasing server->bigbuf), a stale
> next_buffer pointer not cleared before goto one_more, and use of the
> pre-decryption pdu_length instead of the plaintext extent for bounds
> checking.
> 
> Patch 2 adds smb2_min_pdu_len[], a per-command table of minimum response
> struct sizes, and uses it in smb2_check_message() to reject responses
> too short for smb2_get_data_area_len() to safely read command-specific
> struct fields.
> 
> Patch 3 fixes server->total_read tracking in receive_encrypted_standard()
> so that smb2_check_message() sees the actual per-sub-PDU size rather than
> the full remaining compound tail.  Without this, a rogue server can craft
> a compound frame where any non-last sub-PDU is shorter than its declared
> fixed struct, bypassing the guards added in patch 2.
> 
> The remaining patches fix lower-bound gaps and OOB reads in DFS referral
> parsing, EA list traversal, posix SID bounds, change-notify offset,
> snapshot enumeration, and SMB1 reparse point validation.
> 
> Note on overlap with a concurrent series: Zihan Xi's
> [PATCH v2 0/2] "smb: client: fix create context out-of-bounds reads"
> (Message-ID: <cover.1787486936.git.zihanx@nebusec.ai>) touches
> smb2_parse_contexts() and parse_posix_ctxt() independently.  Patch 11
> here addresses the same function (smb2_parse_contexts()) but focuses on
> complementary issues that their series does not cover: NameOffset
> validation (lower and upper bounds) and gating all three handler
> dispatches on a non-zero DataLength to prevent zero-DataLength contexts
> from exercising parse_lease_buf, parse_query_id_ctxt, or parse_posix_ctxt.
> Their per-context cc_len bounding and lease/QFid minimum-length checks
> are not duplicated here.  parse_posix_ctxt() DataLength validation is
> omitted from this series entirely since their patch 2/2 addresses it.
> 
> Frank Sorenson (11):
>   smb: client: fix NextCommand bounds and aliasing UAF in
>     receive_encrypted_standard()
>   smb: client: validate PDU length before smb2_get_data_area_len()
>     struct access
>   smb: client: fix server->total_read not tracking sub-PDU size in
>     receive_encrypted_standard()
>   smb: client: fix missing lower-bound check on DFS referral string
>     offsets
>   smb: client: fix missing lower-bound on Next field in
>     parse_server_interfaces()
>   smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
>   smb: client: fix missing iov bounds check in parse_posix_sids()
>   smb: client: fix underflow in is_valid_oplock_break() notify offset
>     check
>   smb: client: fix potential OOB read in smb3_enum_snapshots()
>   smb: client: fix incomplete bounds check on reparse buffer in
>     cifs_query_reparse_point()
>   smb: client: fix NameOffset and Next field validation in
>     smb2_parse_contexts()
> 
>  fs/smb/client/cifssmb.c   |  2 +-
>  fs/smb/client/misc.c      | 12 +++++++--
>  fs/smb/client/smb1misc.c  |  3 ++-
>  fs/smb/client/smb2inode.c | 11 ++++++++
>  fs/smb/client/smb2misc.c  | 53 +++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb2ops.c   | 45 +++++++++++++++++++++++----------
>  fs/smb/client/smb2pdu.c   | 11 ++++----
>  fs/smb/client/trace.h     |  1 +
>  8 files changed, 116 insertions(+), 22 deletions(-)
> 
> -- 
> 2.55.0
> 
> 

Just a small question: I wasn't able to verify the call stack from this
patch series alone. Is there a reproducible test case or script that triggers
the issue?

As a security researcher, I'd also like to independently verify the findings
and cross-check the behavior on my side. Any reproducer or additional details
would be greatly appreciated.

The reason I'm asking is that I've been working on CI coverage for SMB. I hope
we can integrate tests for this issue as well, so that similar regressions can
be detected and prevented in the future.

Best regards,
Yunseong
