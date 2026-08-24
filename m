Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FD4296BC8;
	Mon, 24 Aug 2026 00:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533014; cv=fail; b=JqET+d+Bo2NZ4N4CoiDgt/jGM/gYXbG9cF4GQDPMaty34buFH3NKOI2o/Bi/fbTldbpsgmi2uSZ29j+5h6UDt4kE4q+qQ9hAm0d5g8upQarDLj3tffdIzOcZ2qih9zJgA+PNyWpeErpMy4UmOB71U+q6fuTEXSVUL+dh4R8T4VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533014; c=relaxed/simple;
	bh=1WMvV53ENad8TPA2FUOgU5vZ1JKrMPw3EbjaacUMLo8=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=h0N657OUmfjJXyNAvxa22NXmCGB100X/n23clzuqcL/E9yurpHAxLf7QB+G4BwKGciu9TMjr0MROvNkmiZPuUk8mnoHra23HqwzpiZtyjT5lLCvpg21rqWa282GV4wGD10hBtMPrnt7s9vWrvV8se4nhLWoOOXOzNQGpSIwrmLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=ru6mNm5A; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="ru6mNm5A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t22oW/7UM8SLdrQcesMe01rhLjaCj7RBhadF0Y8Ba+IOZGGjqKyRmrpM63mf0kfGq9hCGUaqm+UhPJEBFXUzyKR7Ccgn+QrBYev9bVVC+WYo1jaRwSiNB/hrmhowBJTUfVdodCRxwe3b4EcrD1ScNIRVVgdxXV6JVKQJe0CnzIimtsnkyPCU82nZCxbwEYLaJXksSZ7Q/x5oR2bhXkRR8Ms91oKTATayJLCZIGPRfQJF5yegO7YN6dexoMUKAQCqHpvQI5BtC47syGGLah5GmQvhb9X67e3CTEz03ggOHZRGobFntdKnuFUXawMiaMj1VWnv8ioEaFZdS6lT/80asg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVb7ftB63+s7x4ZzyNcxhXVU1YyZbnT3ksTPIX7wsNM=;
 b=K0HWs1Ioreq2QMsstEbqJQ5GAeP2s0tk30Yi6j9VkllKSOA4s2Nyg1wWEJmfCHOLzBmZI8i8sJ3+AJ3JzL3DexcOrtKnuzwcx8GBIWumaBSIUu3hcCTzyGecO8aPAXQgZsZp1mmbBhqOWvmJ2PmXYt0aZpS1FgIM5G1RBuptI/eSvcWR3ackyrK0qxyl9qsTF2S55YKBLjsZrRrqRfKB2K1E3L59emjSVnXnv/6bN9aMMcHCCtBfkbAwSiC+/KeDBCEJjSBHWAQUWYL5jUTl/8nco9owy/KiQbw9AoyX3/q1anxQwkdCeMzXSNoMnuZ4sXzn15adUXSz+Y4W6dFRBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVb7ftB63+s7x4ZzyNcxhXVU1YyZbnT3ksTPIX7wsNM=;
 b=ru6mNm5A65AmZf3e47fRtdcB29Vr8ndkGvsrKWMjrlpbFodFG9Gn+fGFj0IpkIJgtm1XPOAdKzUeHR2N7G6mL20PBW3F4ex4OmSRGsOG4K5GbnS3vuq/TrTpzkfL+XI8F/Rb7ohHMX87plTd34fb6ROOgCV/Je+G53v5kbZzzPTxMqtqaLOz4BnXnwy1wdRX4ajw9wtaN3Hi9o3/iSSCWstjMLl9zniKVP5H8kyN407DaAlOw8KvMUiCXg6ESK/JhjagaHKAZSryDCm/Y/x1dgzRjmdRwoW5zKZse2amhjyYygPFPiUL+3Cr3e9j/LyHWHdUMI5tkuOcgw6H7TT5FQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV4P189MB3726.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:2b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Mon, 24 Aug
 2026 00:56:48 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 00:56:48 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Mon, 24 Aug 2026 02:56:29 +0200
Subject: [PATCH 2/4] ksmbd: set SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY in
 tree connect
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-b4-ca-v1-2-79d6ae0ad2c3@est.tech>
References: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
In-Reply-To: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
To: Namjae Jeon <linkinjeon@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yunseong Kim <yunseong.kim@est.tech>, ysk@kzalloc.com
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787533000; l=1640;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=1WMvV53ENad8TPA2FUOgU5vZ1JKrMPw3EbjaacUMLo8=;
 b=ehnf2CFpCvY0OR9OdzBVsVPSCxXk7nIqB82J2UyNV2Bgf0zkQkZrjAfLtBcfpLPagzXNNt7/P
 QxxMD376h5RD+rtSttrrVg8T21vczk8xXpmQ32L68ML7JGDBf5NSqRp
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: GVX0EPF0005F6CF.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::64c) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV4P189MB3726:EE_
X-MS-Office365-Filtering-Correlation-Id: e31f6b6a-204b-49f2-6400-08df017a9359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qn8Z+yH34usyAlRukhP4HR0nBI4/4NfiB1BcabuTsEqVavIF7Ae7DMSUOvw0wdHvPdfE5VbzhEHOkeuFPZsU4qP6gWhP8UQoK76BCcd7VPTjFXfl9tjQYhYKzllpAY1gBSK4G0WeN8GGd8aMoYWuc/SPCMkjVLtaa9/IX46HkgQ/DF9D9UwcyR1o2tKO3yfjTygGmarSlpnye5n5b6yQD6F4jv5w6s9icOkDdQ7fyhOa2FSGz2kucHw0OWjNXt7fe0SmOYD1wEwMakrXBagVMGYPqxEUv1KrtrbU15zj6sbIxK3ChO0578M7Qb3+H+qkvza2jk91UgTjnPP2oPp1vQXRXmt8uXdsevZ+x3u7g1aWFXSGPymPnCSIZad/f4+/lxwcwoF36bkYp4cm29N9Pv2S6guPFZzIh+9g2ijkmtgWj0w9WEAJqU2x7MzxeQDuMmwDbfwhdzeQSsqVs2HdpbR5fflPyFEv7EFNE1G5CLO9sNHxK/Pn5AIiHdcaaOpqE5IWVzOxRnR8dIB4OmlOyVBuQjIgReLF6b9EmOIQC9/iCRrH+1TsIRnPO48QMHE4FeITgvDWuIKj/uxzYRGufm3e+pMJZ1ElWzK201Xm2bHdtIkq1AQo/JeXDV2IYZDcWVZANavnVirz//INk2ydfcxVrY750+zjKBw7Dc0BTUU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkpiNVZEN2REdVhsWUc2c2U2YVNoaUNJMHJwaHVpSXZBS0xyUVpvbFAzNFZ0?=
 =?utf-8?B?WUQ1dDhkVTBUVXdadm02TFlsUzJCZ2U2ZlMycHppN2owaHNDSmRjT1cwMWVD?=
 =?utf-8?B?YUdyV0hpTW5nQUozbDBIZWRoQTU4OG55OVBLMnN1bytmakU4MmJhWHdvbUZK?=
 =?utf-8?B?aW1TQUNVdXphQTNIL21EWS8xSTZHT25uQ0MrdEZyLzVUN1crcmxBOGRkWkdy?=
 =?utf-8?B?VzRuTHZaeU9uNFRpa3ZtbHFuRW16OVBHc1dQZWxtUjlrb20vcFB2YzYrcys2?=
 =?utf-8?B?R241eWdUeFc4bGxqSkdNdytYbDhNZUxjbksvTmoyMzlKZEZURWxmMXRjeVZv?=
 =?utf-8?B?SHVoN0VZWFdoZldXWDRQcThnc3pkNzV2MndhWm90MnhzUS9DSDUzWFlMSlZV?=
 =?utf-8?B?emlxUHhSZmZzeVVHRHlsckxuNFdzaStrb3o1UGRScmVLdHJnL1N5Nlg3MWFu?=
 =?utf-8?B?YklYMGZ2NmhaOFVYVzJzSk1NMS84SEJvQkJKVkJuNjN3NW1ya1lGbTQzQXEx?=
 =?utf-8?B?aWNlN3BOcDQzT09rdWcvNE5rQUsxaFNyOVBqQmVBY3JQWHZEUTRTRVI4Uzky?=
 =?utf-8?B?VGZ6YmQ1NXpkWTMzRkdudlc2Qjd6dDZvRTBCWFNCWUJZa2UrNmVmd2I2Qkk1?=
 =?utf-8?B?Ymg0VzF6Q0VHUzUvS2cvclUvQ2hIQ1VMZklidXJDem1aSy9MZ3VmRlpmcWVI?=
 =?utf-8?B?OWlFRUo1dmVGRUdsdlpUUDkvTDc0T20xMCtJdjVhcm12MmJzbFNFeDdYSzhG?=
 =?utf-8?B?TzJZRUxsSGREN0FXWFFQR2VYOEpYRksvZ1R4L2tpeThiR0JZRDV3cmNrcEY4?=
 =?utf-8?B?eDY0c0FQSkVQdEJwVUxYZGVtd0pnVXFETTRBUzhlKy8vQU03TFhEaGlDYyt1?=
 =?utf-8?B?czFKeU1udWRvWk1wUmhmVVh0ZU1ZdEY3WldsbzFmc2RwMXl3THdrdFZlK3Ur?=
 =?utf-8?B?SnJYeWNIb0V3UmFBL2p6S2draHFEVksrU1B1VjRjdndFYzlwdFM1VDdRVXU1?=
 =?utf-8?B?Nk04OVB4eWVEeHlrb1VxNHhLVE92M0VPREJLVlY2b1kvVGc3QVQ4K0VFaUd6?=
 =?utf-8?B?dDBDeFYwZ3dBVHd1djVxUXpmR1hoWFROUUJOSEhncXpnYnVGZkQvOHk5UURv?=
 =?utf-8?B?bEgxU1d1NVRBVmJDbVA1UUV2ZmI0VGlwVWpJc285R2srNk51VXR3U0pwNmRn?=
 =?utf-8?B?TTFQS3VYclhQMnd3VnBTM2JRVXJjdmJsdXR2bHNWaXFLUEY1K3lTWWhxcGw5?=
 =?utf-8?B?SHF4TDh1M3kyK3pzdHBBQlNoVG13WEhya1I4Y3ZMRkdmbDZEc2JWeERBY0I4?=
 =?utf-8?B?bEE3cjFSeUFzeGxlZHFRKzZGUXFUbGRtNWtrZW04VzFVNVBnTjc5NFVrTjJU?=
 =?utf-8?B?aWRjMDRNU1I2MVF5c0ZHRVdjRWFXajhMdVVudUt4OUR2T0x4YUJUY3BTT1hh?=
 =?utf-8?B?a2NhOTFTV0RNWk5vZ3VBMEFnTDIwbkptVEIxYnBmRzV4VW1wN25DWnBiaVZk?=
 =?utf-8?B?SHRKZ0x4L25XS0t2V3BYeVVONlMwMVpQN1N6bWFoN05waTFwckJKYitLazdB?=
 =?utf-8?B?bnN3cms4eGh3ZVR2NUZHZ3R6UkxHWUppdnNXT21sbGJPWFk0OXdrb2dZb0dV?=
 =?utf-8?B?QWVmVjVVNXZXczg4Yi9OVWdPSkhrTXMwVmFaVDNuZ21QSFpoZDhmQ1JMNmNl?=
 =?utf-8?B?a3JDckEyUTZSbTVBRzJMdXdkR1JodXFrN0dtK1ppQ3NMcWRXeHZzQTZ5ODN5?=
 =?utf-8?B?V1VaQ2E3dlhtOEU4QmQ1L0R2bVhOMWYweTYyUTNoVXRpdzEwN3dDWHJLTk9x?=
 =?utf-8?B?SDJSUkZPNVhPdkQvdjR6ekltamc1c1AvZEF2ZW5xcWJlRkd0MVd4ZWZNQnlE?=
 =?utf-8?B?RTJqUEdRN21lT1AwdUYybnVwQkw2aGYwUVYrNGd1ZTFudURvOTJWOXp6bUN0?=
 =?utf-8?B?cWhYaWJiZzlmMWlBVzVTUGk5T0ZSOFNmOCtpUHM1ZFBQZC9Ya1IwdUlIKzNN?=
 =?utf-8?B?TmZZaWxhd3FtTjZhSksvazZiS2kxcTN5L2kzQXdVVmFyL1RyYnBLRU5OeDdG?=
 =?utf-8?B?Wlppam5rU3dxK3dOYm40VE5peEZOa2o0dUJScDF3bXBIUFBJZzRzcU53ZDdh?=
 =?utf-8?B?aGFuc1RBajNGTEQ5YXRwWHRlOUxYWFRKVk8xRTRRNEc3V2syYTNUWG13S1BL?=
 =?utf-8?B?bUVBV2wrdHlSdDVTVUJKQ1U2N1JNSG9CQmxsUFNoV21YaHVmNlBNaHBKTW1H?=
 =?utf-8?B?WEdvMEpnUWlvaHQ2djhJMmN4OVVydHNEWnJLZ05VZzJpL0pMVkVRV0x6VHBY?=
 =?utf-8?B?WDI2dUlDTVJHcnkyVGNQNmZvMGsyY21UNEVuM3JLQlJXM0ZCaVVIbXBxZllm?=
 =?utf-8?Q?6QTf/xAl4qydrAKqeUgMXx/hvqoJj2qIw23uP0d1C8l/0?=
X-MS-Exchange-AntiSpam-MessageData-1: 94URFF5XhX3tlw==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: e31f6b6a-204b-49f2-6400-08df017a9359
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 00:56:48.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvEurCPlNs/WNDmeY0YBsM9EFQKVYVDN1EYdjfGQQ++ZqTlTZBv6krMifFSrrgzaeeNTmHJaa5w3v5jIMd4WUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P189MB3726

Set the SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY capability in the tree
connect response for shares configured with the 'continuous availability'
option (KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY).

This capability is only advertised when persistent handles are also
enabled globally (SMB2_GLOBAL_CAP_PERSISTENT_HANDLES). It informs
clients that the share supports persistent handles, allowing them to
request SMB2_DHANDLE_FLAG_PERSISTENT in DH2Q create contexts.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 fs/smb/server/smb2pdu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bd74b45ce0e7..b4bf36fb7183 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2858,10 +2858,15 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	/*
-	 * A configured CA share is not continuously available until persistent
-	 * open recovery, ownership fencing, and failover are implemented.
+	 * Advertise Continuous Availability on shares configured with
+	 * the CA flag, when persistent handles are enabled globally.
 	 */
-	rsp->Capabilities = 0;
+	if (share && test_share_config_flag(share,
+					    KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY) &&
+	    conn->vals->req_capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
+		rsp->Capabilities = cpu_to_le32(SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY);
+	else
+		rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;

-- 
2.47.3

