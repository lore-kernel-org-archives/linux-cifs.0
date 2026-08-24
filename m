Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEFA2472A2;
	Mon, 24 Aug 2026 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533012; cv=fail; b=P+EvFRY+7oLAJga+9wPvmdOLaUXR+amB2V36KVmOPONa9EJD94nFn0Cdrh6DbQOpQW/gqIL4AyeYh4SP8QCHfCfQDbkSDYMIms7vvb5Wc23skC5syzlvKZ6fXaSkgikWKiZKd343SObJ96MJ6lrMxe7SMidKqZxv5oSEHUYJSpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533012; c=relaxed/simple;
	bh=iIbw+dJKI73WTELEbm5qE3DIHky5/7T8fMnkaT4huz8=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=NJkHcisDuTGr17Rt2ZXFrT6P3PIz4RwORG7a7NvqW4bu+YPE8dvIxiYt/UdQRTw4uFgKUvEkc+Y3O2T2pj0x25oI3+myT0SpUPUO+NrKOQm5eBhv6QHjUc3traPfyH+t6Uz6o5q3k+VcDtTJIZjCR07GdomUjRz0JsJd5TkUpR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=nA/3jneW; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="nA/3jneW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QZpoSl0M4G6sOYdszD0bxOP9Nu/x15hjenrq6qURF/f4JE2AVHD86Z8rphPigAqIrE/0oeatdRKCmVw3QZFbTiTLNqloG9brM+vNOXLm/+LdBZaqW2X9wRXgxFsCDqxhGI3+VnwEvtNnrn2LrFDNNhcm06zag9CNMlR15mmq7t1oF6q02sS3DMZxG7shyguFxkYU40o82ItfUF2fQlVhoFcQwmYHoOrhAIxiPEV1DVUsvVSsJ2k/Mk4QVx7h0tcXLtCgDD5jVgvDDzkixK7lDedLA8BQWB/Kr3tB1xfclIXHqlg1AyFiC8fd4SazligVjzS0hWDVtlUcKiL16gI4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLZVKvCyxss/qo9XBVIZWXFEuXX7L3s+sr0nlM2QJIc=;
 b=yTjGs/EsWyIXC4dgPZW9jvxKYz8P+arp4hzYssxy3gu7brLmOr2ozpCOldSHB58bri9LF9mtx4foFPRXUSuUKh9xOGHvYd28rP8paYKQB6rgM5K0gE/1w5IBZ5e4JILeT7fm/0fYzWJXeuq7eYNySjMJLO7QCFI7RGWwuFrtCAsOHlTtLEwXQBFqVHo8wLXZ8/tgonkX0XJNbGNwCapOjDjzn6KUKX/k+avnuDJKKLstPRU4Sj/FKwUeMHraMR2MUKPNgHb1gQk9hrVrA9Ybo8lBY9VM7OvezjPQMcUaTLOjX4fKjqdkyV/ESGuZWK1HResfsv/sL7EHfYYE0Sup9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLZVKvCyxss/qo9XBVIZWXFEuXX7L3s+sr0nlM2QJIc=;
 b=nA/3jneWdlZ+lGw78yld95iAijsl5qASaQc08uWxcdyICtGK8Ok6fHNXDOiVBy4fQhoesLbEeUOndRQR/jhHIipk6fQBwNMFVIkzRtAqsAPr2uo93/zQcAxm3Oo4+/DJ+nBcKUlaeaIep62vZNeJn6DHAQRZfciL0U8Rm4p6C84jmlebiiUhiIHyU7ZHVDj9p4B3XbEGD7Qhc97KLksjvxawvY7jcKJlHPIy5qwq8cy/VGYBqStALDfmnUJLR5xhFqcWm1bgSNQIEqzWN0fECZiA/IXL+x7ezhYk4ED4jWARglqoxlUFL4l7vd/BERGRjk726HYI2G9+axuBAYPUNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV4P189MB3726.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:2b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Mon, 24 Aug
 2026 00:56:45 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 00:56:45 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Mon, 24 Aug 2026 02:56:28 +0200
Subject: [PATCH 1/4] ksmbd: advertise SMB2_GLOBAL_CAP_PERSISTENT_HANDLES
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-b4-ca-v1-1-79d6ae0ad2c3@est.tech>
References: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
In-Reply-To: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
To: Namjae Jeon <linkinjeon@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yunseong Kim <yunseong.kim@est.tech>, ysk@kzalloc.com
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787533000; l=1697;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=iIbw+dJKI73WTELEbm5qE3DIHky5/7T8fMnkaT4huz8=;
 b=PSET1wIzs/QU3LLyVDePbohCZS2Mo5wm/HT11U8SPqjPnHNwz+RVd/r6znaNDI/DyRZDHPlsu
 /MVWNX9/b5EBBkY4mUXWfg3WdKX2uN4Fy6iIjKQgxVi0P65+zpL5heK
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: GVX0EPF0005F718.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::39b) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV4P189MB3726:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa5b206-7114-492a-f05d-08df017a91fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9r8b5HWtJ3XAA8DYzh3LAz68jAcSHfmV7Ezsp25Ur4Q/P7CDlzMhwoF/PY3xdCne7v1zxf6H7sty1CZKkf6Vfy84bZzmml2/xWx+ooqmnhKgORc8IVlTAs/Ovze49UZnerkf7DiPJjNkQKTEw7MZXbUVoYo9sHpej2zPurHt3ID/9uBD+23MqrQT6MioedsOf8Ls+2z+xbF7E1m1AR9+KGou+MI0zBflEg47Fl8G+2Vy10RHoUpEOwBrHgHDdxsI9MC1yWjwuLwfVo96HHZigBFgrOhhoLBgVrDAU79sq1E+E/6Ze0Pes554rOEpSlzcp+tG9El+ZI6ppnyFh7YkvyeoB/Y8dRG1YLAWjb/fMxGvR4L/QH0happB4ojMZ/SnNwek6nIaJnkJkgVktK9H39rCXRBg5QO7L26518/I6SlvaTl0rrrNs1CsHukFnb1tYYeJvY0B+LEU1sPYCiL7WKBk0414CH8KR8r0grYfQBPrIZZQxwOar2OLEjyqqI3Rq4gbpu5D1c1xmEXfpne1bLc2REjUaLtd34J9ccv4t6hvEE9NfJlFBQHrWKun3za3Bb9SdcfoM6KJkVQLOReRW1qk5h8YZ6n3fir3+yBHJn4D9IdgLg/AGh3IhTQxIpx9Lh4OnNt0O1GkMErH9IzCboakiHsy8ypbjI7JM+fTbOA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3MyaVNDNURzbjQxMWVSNWtiMTZwQ2o1dWcxaGVKLzJWaFJHeFM2YUNvTUlK?=
 =?utf-8?B?czlhSTNYOEY2QzJUanhOMFZtMjFvUTBRMTVqeklpT3R1NXFIT0dWNFY0TkNu?=
 =?utf-8?B?VVhENERJam82M3lqdDZnZlIrWTd5N0NGamVOKzJmWVBHU3R4YVZXaFcvak13?=
 =?utf-8?B?dmVqSktCUVFOOURLd2RTYkZyZUVLWmVQSW1zejRDd1RhbzJFeHZVVmJQMkZO?=
 =?utf-8?B?Q05uOWVGSGswd2pZNWdLS29YWWltazJJaW45a2MxZkxQNlJDcVI1VVlQWkI4?=
 =?utf-8?B?czNJKzBLeEZldDU2c2t1eVhKZTFHc1hGNkNrNEduZVBOa1JDejJtcmxUV0tW?=
 =?utf-8?B?Ymw4UlZJTkZYRW1zdmxZeXdrUDFyQmdpUmdSU1pBT1AyaWdqVE9GUE04QWcx?=
 =?utf-8?B?L1g1UmVFa1pLd0NXYzc4TlhXaUJEUkl2UlRIamxlbVRSNkVJdzRiZzlENG9P?=
 =?utf-8?B?c2tZU3p0UE9obWhaOG90enU2NWEwV2dCS3YveFVkUzRmUUZIWDFZb2RqUG5n?=
 =?utf-8?B?b0MvWWNnNUZ3SGpHSm51NVY0SEp1Z3hqRmRwRW5zWXpuY3M3ZTZhWUwzVldn?=
 =?utf-8?B?akk0Smx0K00vay91amE5Wlhtemc1VGU2UFpOWmFFWWRDei9zejFDNzJ1bWlF?=
 =?utf-8?B?bk9HTklGMFd2QlRkRDdCRlorNE5jMHFhM01HTWNVZWtJQXQ4K2xmNkRIZ2N3?=
 =?utf-8?B?VDRXSWQ1SHBmeGgzL2ovWS9QOFhiRDRWb0tqb0hEcFdMdWxON1JQb001TnFi?=
 =?utf-8?B?Z3JJczY0N1IzWXEwbzBiQ3VHeFh0RGEwRnRLTlRxbzlBWW1aT3lGSGQyenI4?=
 =?utf-8?B?U0ZSME12K1pVM2ppZnJtSVRhNFBlRjRuR1Qwdm51TlJVZ1lwc0xhWVpzWkNx?=
 =?utf-8?B?Z2tIbk9PTXpMV3dCelA2a2syMnBpZTdZQU9ERzRTUit0Mld4b1Nzc1Z5SHNP?=
 =?utf-8?B?REg2U0oyM1FOSjZwUjZGenFNVlUzQnlGYXI0emR5d2p3UnJ6aEtob1ovTnpa?=
 =?utf-8?B?am1ESEFQT3VwMEx5WEVjZlM3T0hmUmNrYXJSY1JCbjZyaUN5RkYxVzFNR1U4?=
 =?utf-8?B?SGw0MlBkVllGY2JPZUdHVlh6WGtIbGxJRnQyMjhOWXZheHFVaWRUYkdzK0Ux?=
 =?utf-8?B?dDVJV0lvQ1cvRE43VUhKMW9LMHoreElOSGcwalBsMktaeGtHaEJ2VmFTeWx6?=
 =?utf-8?B?elExdDlEY3lCNTk4anhsMHQvVXVLYS84Qlduelp6TWQ0NFZGSThtTHdWWHIy?=
 =?utf-8?B?TWpvVGJzZlN5UkpDc09nR096MEV5RGExblRQbEJZcHVZSkt3UWo3NllLWHFj?=
 =?utf-8?B?akdua0VHc0U2NzFva0R0dVo5dmhlSUxjZGdibEtNMm0xNHZtS0VNNm5nUGJU?=
 =?utf-8?B?T1BROUhBOXEwYm5Xbnp6bmMycUxRQ3BudDQ2bTVwY0hkZzBaa1RPS1dkd1lZ?=
 =?utf-8?B?YkE3RlB1TzVaS0RzVnNacmpubXExMURPNG9DVHJCV0Q0YTMzcjh1dUNwall5?=
 =?utf-8?B?d3dDTFkvcEVTRnBwSDdEN3VBdjFrUmRGYkRCWEVIZVpXRVdpYzFlNUZLdXRm?=
 =?utf-8?B?V1RnL21XUm0wNjBpbTFrTnNiMDJWbW1OWnNVTFV6cFZmVFZYUTVzNFBYcURO?=
 =?utf-8?B?WWpsc2xQVkxtRzRUbW9HU1lBUkROS2tOSFpuL0RFZlQyclNjb0VJYUtZWVBr?=
 =?utf-8?B?SHplbHl3cVExdzg5N3NwWDZ1eUkzMzFNSmVUZ1JHUDkxNUk3U3VnalNsUnA2?=
 =?utf-8?B?cERGbzA3MEJrNmJRUDVVeTRKYlVJSlZUYndhcmRnTTNPUUxIMjFkSTF3akVz?=
 =?utf-8?B?NEZiY1h2aU85MGZLVDkya1J4a2ZuSlNWM3FueDlpRGt0bHdLUEsycUxFWXYv?=
 =?utf-8?B?ZlJLanJNY3JMVzk1MjZ5QjcrWnFZL05HR2lyNGZzRFNlSkxZNk53U05HZENn?=
 =?utf-8?B?Zm5Zdi8xeTVVcXhPWURicjZ4Y1ZOUW9oZ05xZXFZdXllU09HNnhvSUVJMUJE?=
 =?utf-8?B?S3JGQ0VodklkZmowc2pyTzZOZm1pRS9OeVJnU1dpL2dwVG81SVMyMzM0YnN5?=
 =?utf-8?B?Tnk3dWpCY1hDWUxHZTBRYVNJc1lJemFnamE2RUpwamhJK2hHNzNFSVE3T2ZD?=
 =?utf-8?B?bTEwS0ZrK3JyTnI5ay9oc05zOVRsczB0V0IycGgvVDNSRGxmNFRyeTdwN0Zh?=
 =?utf-8?B?cVYvYVdDdzV0enhDbEQ3QkQ2SEtUTTBZbXFDZUZtUmF3OVR4blhqYXQ3aXJW?=
 =?utf-8?B?aGgyMyt2emUzQTF3K25RNGVkRk1zekY2ZDkwaHRDc01CWnB3Q0tSUUNYcjVP?=
 =?utf-8?B?L2N6aU16TXJEaWh5MjFNNkRseVhvOHlZWFUvUVlRYWJNeFZ5Y1p3Wnk1bEFw?=
 =?utf-8?Q?cng/yod+qsRD07D7CTDomTactLRt/wkjHBTmB+jDYbBtw?=
X-MS-Exchange-AntiSpam-MessageData-1: nH/gwWir1cAH8g==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa5b206-7114-492a-f05d-08df017a91fb
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 00:56:45.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Chow/r+qiCo9Yk3NHuVebp2BxhGiwDKeF9mb0v/tT/FReWZ0sI0uI9QfmAIXPn1Cxm5xqL97e9vWHCmoG7PdIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P189MB3726

Advertise SMB2_GLOBAL_CAP_PERSISTENT_HANDLES in the SMB2 negotiate
response when durable handles are enabled globally. This tells clients
that the server supports persistent handles, which is a prerequisite
for Continuously Available (CA) share functionality.

The capability is gated by KSMBD_GLOBAL_FLAG_DURABLE_HANDLE (controlled
by 'durable handles = yes' in ksmbd.conf) so administrators must
explicitly enable it.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 fs/smb/server/smb2ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 4578291fb172..414153fa2a68 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -270,10 +270,8 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	/*
-	 * Durable handles are in-memory only.  Do not advertise persistent
-	 * handles until CA recovery and fencing are implemented.
-	 */
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
 }
 
 /**
@@ -296,7 +294,9 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	/* See init_smb3_02_server(): persistent handles require CA recovery. */
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+
 	return 0;
 }
 

-- 
2.47.3

