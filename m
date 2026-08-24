Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE0025B099;
	Mon, 24 Aug 2026 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533018; cv=fail; b=pjxHKGfVCqyxXoJfotEzpkcHtmKb0iAvKvvO+ltjR75iJA3u4XnxvSD4kdhOUMG7t08XBYjACbb+RNahBHZu8YNxvFwzUvurexCGBgRoeQekqrnDrsqvFZoN+rLcm0zfonTk+USCPWU7P5rN8oo8NOdgZAV0S7SkWzM4aAJN5/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533018; c=relaxed/simple;
	bh=cw8mYIbJ6GWOJ8huf79FYuVT/sNSGQm1zLjUkM8Whsg=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=g5NRxZtPpHDF5VcyGe+qUxvmoiFLVoqWHi4+woNXWfWMfko3GxuicFj9tRdnL5ErYDnmE0RVD4yRVkV58GJSGcCyIaAF3CpN2xKHGwQW6mg4O3ZKR3XPyhJmw5j0vecRx+gJr8uzWs6zIw2mAUOeeNTpeT8Pv+5gNgDvtpD17mI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=IqpHD1pA; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="IqpHD1pA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VPLVCBFkYrvHApffC670EXNSG4yJW+WXADe6khrMsC9yW1ejPazASBPSNIAsWLvvNK71V/kyZ0f6lqjsDvNeU0HRmoRTSm5t5wc2RXmhWlSssTG8lkl11zw6noQUGw7JIxz+WXxNED/u5YChhSkG+dQXCoRsQqiQCCsfHj5aKpad5KbSz4XNTaA+p9QNaCACShWafpX6wcpV0ljUUYZ3u3opaKNmU2qyJzKos0MT6JWneSwfcXp/jrr+GyCvRL4L0ZjLrH1ZX/qiT0jobhFUBptZjpYWrFfW+45QbvAJMlNeCatLN4eTmbHYOBjmtFuatTaPWgGbq7n4XJplakI2kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25mQSvdatJ3hJ7NsnmpI08uB1oWbFJSzMu6gUwZwOS4=;
 b=tW04a8Yy2hPta7Rc+oqAq+naHkrMU3tA42zT1CFxz309ZhNgZ39t7SV+4Dw7qa6TaBfdjL8Wg8wx8cxzVgNe3vcQRT1wxyTVrl4CuB0szHXmFncCitVeKjr7Ep4OpD0JMNkE8ipPRGAG8qljxTQ42YsMBbaQm47YmMyFFK+5RgNzB3+Ge2rzJqDyVB13rH350s0w5Vr375yiwzG2zzw9RBD06SjQknENvRgfJacpiFYaF3UUcD1c633ARbhs9TQNOFZhXxYFz0ZsKv+5HI0xNhWEfQF2aaejdU7fcOo64CbSiWzG22F3KB7/HcaYsrjcKhZPqu7UyLFBcX6vYWvDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25mQSvdatJ3hJ7NsnmpI08uB1oWbFJSzMu6gUwZwOS4=;
 b=IqpHD1pArOc+N+OwXNL7JV3ky40PxZjbKWGOcrPsx7kp2mMVyRoamw+3ZY3IqJahBtWoIHZnM6mRvkeBk5pjkMxdReq9qpZA+Noj0n+HKxyCTCBTmSK+bT41fUE7D/W+eXyJ/BZ9PtlAOgeZoqQgf9aQuI/BJqzhbn8r+KUPbBspj7iLHTN8JxsuSQCo+u0BoP1+ioWcFvdbBxxXzhTsKGsJ4ekbnerRfXJ2fgnSVTVp2tHfkOMKybhdTTMdnXjkonsm5jyWRjrR77l2nW56sjWf/6EZ/qtkNMUuH23Yx+7a8EPgxHJ6+RYSUPySBZEn/Pof3yuHT4mGAXQ332s9/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV4P189MB3726.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:2b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Mon, 24 Aug
 2026 00:56:52 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 00:56:52 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Mon, 24 Aug 2026 02:56:31 +0200
Subject: [PATCH 4/4] ksmbd: enforce write-through on CA share opens
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-b4-ca-v1-4-79d6ae0ad2c3@est.tech>
References: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
In-Reply-To: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
To: Namjae Jeon <linkinjeon@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yunseong Kim <yunseong.kim@est.tech>, ysk@kzalloc.com
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787533000; l=1412;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=cw8mYIbJ6GWOJ8huf79FYuVT/sNSGQm1zLjUkM8Whsg=;
 b=7RpgI5Hqku7Dl0AT3GcUye+Mfkgm3D4bZwkpZv3JqO6tkz3DzT6vkHiikR7+5AnPzvyVrq0L2
 7RS/DPEU0TjA1P/MkrhZlxnZbksIXkzH1V50Zh/EVXaDZJHykCeoRpR
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: GV2PEPF00023A16.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::20e) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV4P189MB3726:EE_
X-MS-Office365-Filtering-Correlation-Id: 468514ff-32a9-470e-9d3d-08df017a95e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|10067099003|11063799006|56012099006|10063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yXg04Zygz0Q/1iu6u5iuF3pAHgkfjky9Go7B/6FwT7GlDNPge9Nnlxpui+X2qf/4fwLWIzMN/ZAUaklT6oxXLC5iV5HcT1xSOxeus+C2jg+jSjyliTYm7OkkjMugyQ9LH8V1Gc9EFh2IhoXUojSgUDNGcQIuUWQPr1XALPNk6hnZMuZzydnWWzh4xCK1P6F3ZtlsUdu97qqV8DXCO5x5xqZvKo/bRYYfVBaUGi/iJ8sJPni4G+INq3a2xnGl+0OrgRhUYW/r3qLMdUtDaCpjsGR668wf8yxKHbDMdtw/KB0qgrzNLq5YYFbX3olaANjurW78Ve1sxbAOi0EQySL41tiPYwcmXraH9PpGpjco5go6M4F9hKERLDwyjvd2WV4cg99rKSTBV9ZJ7okZXNfqH0+AtEjEdDldErhR4plD+/rMfJNqh3GohlhESEE/cG4ylRopnVaHSqR1h8QC1t5M9PQqpWw531bTq7rS/73a23/HL3sntkpXEc7j4pKO2taiDToHSFffaO+LDfuQAbiicic8ITCVF/1kw7F0+wgHgMMLkDwOlYFMyo8LWiwKufVKljZvGfZ/WzVvHfKj5v+6kQeqomhOPJaBNWewTWm9fdEplAq1+PYH4DxvHrjX0MW1tIZzBlnS2uDjGSEWsznapBkPHvTiEAJagAfLXRSoV9U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(10067099003)(11063799006)(56012099006)(10063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXdZMlZEcTdVOGdSUU81dnFwQzVsNzFHVFAxck03dFVTYzd4MXZGcTJEVGJ2?=
 =?utf-8?B?NFBjY0JqTHIvWnAwUi8vaXBoTkRQK3VXSjNRZ0VtcHRxK1FoclpEZkhGZUlo?=
 =?utf-8?B?UCsyTG9iZTR2UjVpWnRLM0RlNCs1aUdzZmo1T3NQaXpyYjJVTHBuUmNkaitj?=
 =?utf-8?B?WGlyTXJ2TDRrUngwaHBBQjl2VjdjNEpubGZ3QVQxdXdKUnNVL0VyZnM3cHc0?=
 =?utf-8?B?Y21KOEo0MGFPUnhodjlLS2hjd1UvYk9iZDNvQTVKak1FT25DN1EzZzN4QVgy?=
 =?utf-8?B?cnErZzJZSGVqQmUwUHV6UExxZWNvbXFjMXRmL0c5THVwTTVjS3o3QTYrQlVH?=
 =?utf-8?B?b2RZWEFYREN3enlwblppT2RXUnhwWHcxUjlrc1VzbmpPaHFFNGxmTmY5aFB2?=
 =?utf-8?B?Mno3aklyVU5neUJHbkxzQW9QTWdqZERtUC9qUlNzZnQzaG9PMjFuWmlOKzNI?=
 =?utf-8?B?NXZjeDF2UXhEenBhYkxlSDIxRTRDTURLV01qWXdhVFZlYnJjdlF3SExGdTZP?=
 =?utf-8?B?ZEVHM09DYUV6ZlNnOTU2WkFFYjhlQ1F2dFo3SitZSmlINVV4bC9HVlYzRHov?=
 =?utf-8?B?VEFiejZGb05oZVJIcEcvdzR2WSt3VktkczdvUEVMTjBxcWR1TG5WbjhMb1pv?=
 =?utf-8?B?RTBnbWlnVEF0ZFZFZE54Y1FEUlFRODM2Tkk4WmZCckMxclF4NGdieHNBY2Jz?=
 =?utf-8?B?Nnp1ZTV5YmlXb1ZFNFQ4M01PSFJUUFVDUG9mKzdZbWwvajU2UHE1Yi9HelF6?=
 =?utf-8?B?VW5laXdtR2l5aVRBV3VMRzdxRVMwVzhURWlLbnpCYUV1VHVXU1hDM2wrRXVr?=
 =?utf-8?B?V1lCVTNDMGNVSTlhY2JreHJqaXhKaktHRnNnaDRaUXI5VnY3LytCNTkwbE9D?=
 =?utf-8?B?MGx3MHFCejhQZ25pdi9yZE4xa25iZ3pHazV0NVdXblVZQ2Q5b3hTd1EySkJk?=
 =?utf-8?B?UEdTVmgrVEtRWDZPcmdQYUVFYk9lZkIxUnFOQ2FMVm5GTUVYdGYvSmtBQlhT?=
 =?utf-8?B?RFJEaXh2N3RLUE16dVpQTUZISDRVNzdyUTJCeWlmRW5XQ3l4SjVEYjZuMGxh?=
 =?utf-8?B?cHZRZWNDL2xRUXJkQUZhZmxSV3U2VUN3c2lwWUdKU3FsZGd6QzgyY0pmRFFM?=
 =?utf-8?B?MjBIbXJnS1pjWFhCZ3BKZFc0WHBORll1Yld0T3B6c0pIdjMwSHdxekkrcTRZ?=
 =?utf-8?B?clVybDNhY2RLaCtMYUc5NUVyakN4ZHRIdzZvNkxaQ2J5NG1XQ1c4NDVYd1ZU?=
 =?utf-8?B?ZGF0cDJCaGVPV2VpbXRTdUxvS21mQjYwTDRXTGVkMG0ySTVJekN5cGkwOU5y?=
 =?utf-8?B?dEN0NGgvZjFzK0dZWWRrVGhJNENyVzBaUmFkd01jVmN0Mm5WY2JGekYrQmNn?=
 =?utf-8?B?b3ZPU2hUQjJSbXU1d05MdzhFdkEyMjdGWG9zOE51WTNOSXh0N01pTTl3eVFs?=
 =?utf-8?B?eVNxOElNRzN5czExZVdvOVd3OW9wTzdoS1lJaUxUN2tub2sxY1lsU25ZcG04?=
 =?utf-8?B?cUJoZ3dkeDd4YlRwN1VpQ2hLYzJXNncremJLOFhXdVI3bmw2cUxBMTBGRjh0?=
 =?utf-8?B?cFFUaGJRcGdtT0s5SFg0ay92bzV0bjdkVDVvTGVJdFV4c0hQU2YwVmNjdysr?=
 =?utf-8?B?bE9MVDdhc1VGTE1iYlhpeU1ZRUZGb3FWQlpPc04rM1VzMDFISGg5dUVLU2FF?=
 =?utf-8?B?UklzeFlZRmo2UlFSSTQ2NXFTakt3SG9GME0vbjJvbGtNcHdkbzIzYW1rajBK?=
 =?utf-8?B?a2xob2p2R1dEYjZheURXTFF1MEtGWGdMRW5KdUxUMG5FNnIySFA4RmVrWHNR?=
 =?utf-8?B?THN1RktPQi9zVnpJSEdYeGgxQlJhR1pwSkNmVTN6UXhxeWs2L2h5ZjFqZVBK?=
 =?utf-8?B?U0RpWmZQcUNFN1VSNHRiU1Q5OXh4eW5ZNU9Wd0R5QkVrYkFDY1Axd0RReXZJ?=
 =?utf-8?B?b1lBeFQ5ZStUTDFwcGEzSVhRcSs2SzJUaU9EUGtMSVB2djhhWHZvWWp0NXN6?=
 =?utf-8?B?WHQzV2lsZFp1NFg3Wlp6ZU9uOWkveWF5K0FVdWlKRVlvMFI0WGJveGZ0Y1JW?=
 =?utf-8?B?LzJuNjZMeXd2dzFwcE5kSEJ3RW40RHI4eEtWaTVuZzNlQlhKNnZ4ZS94YjRq?=
 =?utf-8?B?V0t0TnJ3RWNpckJaTnVHdmYybHVYVmtWckMyNitleUdQUk9na2VCUWJ2KzhO?=
 =?utf-8?B?bUZsSlQ3UXI4Nkl4Nlo0OGoyOG1ONVdLd2ZwajlEZG8zQ2orU1MyZDc1c0Z0?=
 =?utf-8?B?ZFJ2WUphSkNVdzZ0Y1NUMFBCUGV2WmQwL1VQTmV1WVdNc3pQUUhqWEk1MStI?=
 =?utf-8?B?S0lVTG92THVPNHNoYlZxNE8xS3U2SGZqS1BudXFzUzhkVW1lQUpoeFhxb3pS?=
 =?utf-8?Q?E3FwjKOAwh/QBenX8PvNAO7vhp+E2Bv5hNj/SH9Mxf17n?=
X-MS-Exchange-AntiSpam-MessageData-1: KgwFMkpBm1j3BQ==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 468514ff-32a9-470e-9d3d-08df017a95e9
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 00:56:52.3246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhgCrptdKM10rcJO4LLszQrKqeWUwXs+abzvLFPq5RXd4dUSUXT23TywJETpVZAdD/XO0fcF1W8qFAjzfeNkPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P189MB3726

Per MS-SMB2 3.3.5.9, opens on Continuously Available shares MUST have
FILE_WRITE_THROUGH semantics to ensure data is committed to stable
storage before the operation completes. This is required because
persistent handles may need to be recovered after a server failure, and
any data not flushed to disk would be lost.

Force FILE_WRITE_THROUGH_LE in the CreateOptions passed to
ksmbd_vfs_set_fadvise() for files opened on CA shares, which sets
O_SYNC on the underlying file descriptor.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 36efc3f0bf15..beb5120013ed 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4681,7 +4681,14 @@ int smb2_open(struct ksmbd_work *work)
 		file_info = FILE_CREATED;
 	}
 
-	ksmbd_vfs_set_fadvise(filp, req->CreateOptions);
+	/*
+	 * MS-SMB2 3.3.5.9: Opens on CA shares MUST have FILE_WRITE_THROUGH
+	 * semantics to ensure data is committed to stable storage.
+	 */
+	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
+		ksmbd_vfs_set_fadvise(filp, req->CreateOptions | FILE_WRITE_THROUGH_LE);
+	else
+		ksmbd_vfs_set_fadvise(filp, req->CreateOptions);
 
 	/* Obtain Volatile-ID */
 	fp = ksmbd_open_fd(work, filp);

-- 
2.47.3

