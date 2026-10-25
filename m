Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792920776;
	b=YdGkloslOR1tW/T6IzXfkGLjHZosi323ZAPMw7iAIddMI1P/ZzIXTukyffwjOH8VQrqM
	 GIxPnYDubJzap3cujMPI62TnST6u+XIrhAw5QpWmUzxj69iflIF4HeAVMBtic6d3gs1je
	 vdsl/IaHwdBafLYj9ud+XAhxSFo92I7DTNLSCD0MMGX6UIac7kVPLEZZsr7U8k70WSg1s
	 MJ15dT7zrhOYXJmWSV/sRwOzEc5RiI3p3ZMJgGAgNBlvSJFapdBJYHvsv0Lq3XgHvEmwe
	 p9e2ox7Dyyw6s1OcrkDVygamOgZHnWnn43HXPzyyP4wIZehDCKd+BhrEgRiQXatsYHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792920776;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=kuCJk06n+/C6mWrdx1l2Z64fnLAIUJgF9MN+ckHWTt4=;
	b=4+Udp5T1lGahohfeWCCwReI1M5fCPK8uqTvdwJ6FCSLT5QBtmqTeVU86fKyZv/jqzIug
	 ZU3fjaDVRsUCGWUten5EFolIvBPnu8Y1o9v+Rk+TkG4Y/qB1/pNTu0PDvZRMymfCFocoT
	 v4kU2ZdRKa5OBIes4NL545k2A1qs+wy0TDnNkP9/4Sq3nR38TxWG1QRwN4SWIEoXVrb9t
	 9MeTGTZmBi6hA+TNToGKNHod8QZ9CR2UclcuZMhiaAOWLPbv+W/ExgscyIzNR9kMWonvm
	 f3iIVa+qivi0gaLFiL+fw4YQ7kPpzJmNRLjib0+YkfKp/2VoEWqMQB9F69Bwr5anoTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Tz8dh89a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013083.outbound.protection.outlook.com [52.103.74.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B4A606A31E;
	Sun, 25 Oct 2026 09:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B4A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Tz8dh89a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BH1xCusnU3E9i1hhhUOnA/Y5DDSuL1SNfQUuA+WpRJO5WnQQwoq17zAwdEyuXA1RqUS3/noq7XAhEunCvbimTAtr187Utj6W2xkAnsJsUYxySDaAko+atxCTe6aiFJn+5jVD+y9vixNbf8eeQQQM0pFWUh9FF+jMxX03Ez9r24wosh1WyqmGQstjydoiiwMYZ38dW29EC3oFC6QMzoh6vsATV9kDbyjMtrSvYNg02SNG1k0Mrkec9wfKE4Tazy4yq2s3AXA5xGt9TEqB40wNWb+4btzxcTN00/NDvKw62awiX3mJcesNlpopnLDFfzXVJStkAq4SRteM8aahiwDv8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuCJk06n+/C6mWrdx1l2Z64fnLAIUJgF9MN+ckHWTt4=;
 b=wGtJcXl9lBBrgvM9/jt2Lr/eov6bsCmyKdoDI+bS0TnnPwP3EaJwc4tbpXMr0CddyvMq7YO3OUbo6d2FoPybvmoP++mQ5WcTi3rSMfKCDHy0G5nZyF1nsb3Ph4kP/annyYTJO2uPpJ9DFFf/bxDVq7xJenw5mibrQ80btPc8fm+wKrXFhaqF4d+WdpTaQoIRuFMskEim46gzULCw6UGNhbaZ4YiRSx0RL9H9XiM2SCmB8u+DJttM3Egeq53gBm9l2Yiu7q/80Zl9CAFMyvq+OWiWmcOTIVuR86/DZISji8YboiFsn3Nkl9vaa3Z9/GIrtAGNUQwCfhHDGwXpPtSJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuCJk06n+/C6mWrdx1l2Z64fnLAIUJgF9MN+ckHWTt4=;
 b=Tz8dh89a7DO2eBwyQ0STg0s12BYkZIPUxnrveQBDxDlvhARGwE96pAaLWEIyXnUCGVInoD/uJmqzjO7nAy7dWRN4k8akfljItGUbi4P0An+Oc/3lAOqBiJMcPj1Y4XsmTB77ASMoMz4o4hupp7wuzUbW7dXOg+4CH/y6+q6mVBdO2ADBUfyxC1q6ZZUTjoLP5mCc3LRAXX2aNvOqFrCFHMG9+w37XBeDqyz0AtT9P1D0sitDPfLavrHxrDKR2lmNLfesxKHOWgl6npn+FB7fIvGw9eQIpMqFDmj0XKyOh2s2k8SWJO8cVpS7zFAIcDOnYppSkFgAiEHPHlbhviQgmA==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by TYZPR02MB6882.apcprd02.prod.outlook.com (2603:1096:405:29::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sun, 25 Oct
 2026 09:32:51 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.019; Sun, 25 Oct 2026
 09:32:51 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: avoid races between named-pipe operations
Date: Sun, 25 Oct 2026 17:32:37 +0800
Message-ID:
 <TYZPR02MB69595A920E42FD84A63C1151E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <TYZPR02MB6959A392E5874255DF11F655E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
References: <TYZPR02MB6959A392E5874255DF11F655E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0148.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::16) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261025093238.974165-2-wangzhaolong3@outlook.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|TYZPR02MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e127f7-1aee-4401-5ff1-08df327af08c
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|5040399003|4140399003|260925184616899003|8060799015|19110799012|24121999003|22091999003|5072599009|23021999003|15080799012|24021099003|51005399006|41001999006|12091999003|40105399003|26121999007|3430499035|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9HpunzB4tWcdX/Vbh/sFoBmEEF33eBmzY/89ipXP1+YZDrSMw8IncxZHpiEc?=
 =?us-ascii?Q?jYPBYja1MEmokMCF7DKQbBC0I6yZKG+p8raNOCqUmgiyGMIhaZao9wRb4nFo?=
 =?us-ascii?Q?NvNVN0g9GXL6Md69Kv6IeixC0LYG/g0Gfg2x9JC/+S7ra2FELDOO8NPzuika?=
 =?us-ascii?Q?xmlDRXLzyxbfG7Y2st2cS4MOhok/c2gK3dnrUOip4blXtCRKr+X10Aih+KJr?=
 =?us-ascii?Q?TBSDF/zS7vEqgpLVlf+IVveUPWxL1uDwBqyX2LcyW1Rg9QJyc/aBRkk04TrO?=
 =?us-ascii?Q?8qVsSZyBKRL3lHMsBUb/ls7xZZAM/HdHM8ZplQncai8ZFhBMbYtRqez205HU?=
 =?us-ascii?Q?WkxcfCjOoz9e/dgZ8YG1ymqyICUrTchyOhJiLDJ2Rn1ffnV26ZoppjFv1r02?=
 =?us-ascii?Q?KpUKnFrGeBWTHAjow5y32VWuSTsr7StDu7UWEBW9KX650q/R0HfjejUcpiMh?=
 =?us-ascii?Q?THXGaopThUwjSqC2AiXQVneE4yED1d5NR+7GtQFnQMgnee0M/nbywXDHG21m?=
 =?us-ascii?Q?ujRx6OQovYmonwNyoTL/+QDZJqe+c/gRNgDdBfo88qKoPqU32k8kc9yX/3Ar?=
 =?us-ascii?Q?w3I2YAEE/wts8CVDugziYdK0jST6Trt28yBqBjQFdLigXQjOnuU+IPUuqobB?=
 =?us-ascii?Q?m1uitk0CxHBFnmKPY9w324sYpXiMYApEmjSOMM1WwlNXCCItSq3RZ5SRYOXu?=
 =?us-ascii?Q?szC4Ljf54FePs2AzJoIb9htU1+P+4qA64taAeBWIsU60SwrBFNbgUomkbprG?=
 =?us-ascii?Q?5IpA2AOROQP1hzUnV1oB57E+awgf/84xHM1/tL1t8VRwm79nsGfYdl+IG2I9?=
 =?us-ascii?Q?WwHbntvXX7vpq/A9+teiKbZBEmgoq86UUUn0JFCsqFTFqdGDg1dleEbxs+VB?=
 =?us-ascii?Q?AxQ6GmweNvyPNxZtb/rS4De90G6Y7zLDUdhnvvHJyIjJE74fec6W2z+4RKR4?=
 =?us-ascii?Q?LbSVEkZ+IuTJASNSCBycZOg3YOAV9H8PUPe+KM/YuMx/lWf6ldDkLWy2d0gz?=
 =?us-ascii?Q?+omXeTML5nVOWA7eeN1XguPa/FBfay0FwzmGWAOLJgibscaCq7wlJ6hsbIb4?=
 =?us-ascii?Q?2hoy6iyZaO0b0/BfWiijGx/gfpnPA7mPvF+tI0qHY4ix/1/psGosHLNhp4f0?=
 =?us-ascii?Q?paXahlAAh0SL?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X5ZlwEV27TdXtTR0+roXKkd0w9MbtiSmhb5RuS3vSUI6ISpEgW+Lg+9bSv8l?=
 =?us-ascii?Q?ri2ZtwKAeSqPPHOjV4gREkwevKRGiML95UTCo3R+vgSU6MH08Igd5ev+tSxH?=
 =?us-ascii?Q?DiFY9DXdquXed7legvCTWdrH9cQDQDmi0iq29Eghb+78An3ZRsCsUiBHZI5R?=
 =?us-ascii?Q?B7wysGPlHSBjvRQ7S3hjqPPY+jVkgs06RU/0b8xXVAG7h0YTOuA1QLBAD/I4?=
 =?us-ascii?Q?U4mn1QFMfaBOXOOGqNra5Dzjmn5pWDxhnLXZYvHWsn7nPwUqOV3wl0qwxzZE?=
 =?us-ascii?Q?ngBx2Cxv2AFQL/n+72nmm49WqeuCQyubujeq1wOy9897wRHL+pjvbaaMsV33?=
 =?us-ascii?Q?oBuRuoGphZHhJ2rupa9ZKN4EfDBNQcp9NpWMuotlV2TBEdHY54mS0Hu9IO+u?=
 =?us-ascii?Q?tSybv/y1jWJbfgErYkFymINoDKYeISMRAoxOMe57/4Z7lj+Zuo13VpSBTvp5?=
 =?us-ascii?Q?pF1FLAMoHhRxVmztf2lrbOH5Xq6P1S8oHaqvW8HinRJP5IhwxSKi6iIXXe5A?=
 =?us-ascii?Q?jZATXdcmE1L0VEMJayhdBJuhKmoEt7Rkq3qNxX4pOzz4rbTUazX9qUGOBl2R?=
 =?us-ascii?Q?wRe3+nOvzKNNYM9VqRaW0aAqNMdu9MZUZZMHzGmTcXeHOYia+Ci+BUU4y16D?=
 =?us-ascii?Q?ZTIrdZ4b/r72di/c1qc+4ZcZq+1DXnxzfFDcSTol5YiwUFMdTtIJAfd70cJ3?=
 =?us-ascii?Q?roSAc8+57mt2qQN5Ac4zk3s3CnS6srqxe/hOGd9272w5LiM5GAUFiAo7MkyF?=
 =?us-ascii?Q?w8Y8DnFTymcqcCajZr5l02YBf5QE/oeLazQhTBWB5A4/sOh1KMZs1N3JtQNp?=
 =?us-ascii?Q?8R1BPu4Jt/A56rWmgMnsG5yZgnmM9rK4gsEHidjpVjnPfaX1p1XFmjIcx3p3?=
 =?us-ascii?Q?gFk0cVSodlquRyPqGDAUytR+ZRKaEVU/0cjbt5bwmD4iWXClDlQo1iYG/wf1?=
 =?us-ascii?Q?M0TgQetrZUg04qjzmLrGxZeME1dVhMA1RFRzXTpPrdydmO/YRvxnUI/n8Ozv?=
 =?us-ascii?Q?i6dRNw7kX5VCKoxedeeLPR+gOx/zoviymZ4R2Re8CcMxKXnmNA1XkShfqoxe?=
 =?us-ascii?Q?FMbGgSqB5DHXN7nS2LtIBYZXWbkjMkegZK5YTakPbsC5LvmhHtolbpa093zg?=
 =?us-ascii?Q?8gs2FGTDorTN4k3QjCynKUuw7r1YPveZTgK5j7xQdYxgSXdhKJ4s5pHa/xL1?=
 =?us-ascii?Q?MoX0pvseA4gdNm1gRrRj0Yon0iUszLHLAHcuAHyLhY8YSqhgRvR4BlydAO+m?=
 =?us-ascii?Q?R8jM6TjMy9FzSGLlgFbTZee0wsWQs4ue7oddcsE6kc3hnVwpEkiFNzc8EsnP?=
 =?us-ascii?Q?ccH3o3lViCeRlOAGftDjvyxrRSHJ0VqST5aRjxMPt7DpfAuItda/swhlbm5G?=
 =?us-ascii?Q?662O1rcWGF/WjXw/U7lxFFxcXLoSUfY5AHmS9rm1AgVN0JZLTynI3H/ISbXZ?=
 =?us-ascii?Q?KkWkTlCr8yY=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e127f7-1aee-4401-5ff1-08df327af08c
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2026 09:32:51.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6882

RPC IPC replies are matched by pipe handle. READ, WRITE, TRANSCEIVE and
CLOSE on the same pipe all use that handle. The session RPC lock protects
the handle table, but is dropped before a pipe I/O request waits for its
reply. Another operation, including CLOSE, can issue a request with the
same handle while that wait is still in progress.

These requests have no separate IPC correlation ID, so overlapping waits
can interfere with reply delivery. CLOSE can also release the handle
before an earlier operation finishes. Protecting table access alone does
not provide the serialization or lifetime needed by an active pipe.

Serialize operations per pipe and keep its state and handle alive until
all users finish. Avoid holding the session table lock across IPC waits,
so a blocked pipe does not hold up unrelated pipes. This also provides
the lifetime needed to retain unread replies in the following patch.

Recheck cancellation, connection release and session teardown after taking
the pipe lock, and mark a removed pipe closed before waiting for its active
operation. Close all session RPC pipes on logoff after the other requests
have drained; keeping the TCP connection open must not retain old handles.
Use standard SMB2 error replies for failed pipe operations while preserving
the selected status.

Signed-off-by: Wang Zhaolong <wangzhaolong3@outlook.com>
---
 fs/smb/server/mgmt/user_session.c | 126 +++++++++++++-------
 fs/smb/server/mgmt/user_session.h |  15 +++
 fs/smb/server/smb2pdu.c           | 189 +++++++++++++++++++++---------
 fs/smb/server/transport_ipc.c     |  45 ++++---
 fs/smb/server/transport_ipc.h     |  14 ++-
 5 files changed, 262 insertions(+), 127 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 44dc3f800cd4..cba728a77aa2 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -3,6 +3,7 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/rwsem.h>
@@ -26,10 +27,6 @@ static DEFINE_IDA(session_ida);
 static DEFINE_HASHTABLE(sessions_table, SESSION_HASH_BITS);
 static DECLARE_RWSEM(sessions_table_lock);
 
-struct ksmbd_session_rpc {
-	int			id;
-	unsigned int		method;
-};
 
 #ifdef CONFIG_PROC_FS
 
@@ -278,32 +275,34 @@ static void free_channel_list(struct ksmbd_session *sess)
 	up_write(&sess->chann_lock);
 }
 
-static void __session_rpc_close(struct ksmbd_session *sess,
-				struct ksmbd_session_rpc *entry)
+static void ksmbd_session_rpc_free(struct ksmbd_session_rpc *entry)
+{
+	if (refcount_dec_and_test(&entry->refcount)) {
+		ksmbd_rpc_id_free(entry->id);
+		kfree(entry);
+	}
+}
+
+static void __session_rpc_close(struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_rpc_command *resp;
 
-	resp = ksmbd_rpc_close(sess, entry->id);
+	mutex_lock(&entry->lock);
+	resp = ksmbd_rpc_close(entry);
 	if (!resp)
 		pr_err("Unable to close RPC pipe %d\n", entry->id);
-
 	kvfree(resp);
-	ksmbd_rpc_id_free(entry->id);
-	kfree(entry);
+	mutex_unlock(&entry->lock);
+	ksmbd_session_rpc_free(entry);
 }
 
-static void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess)
+void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess)
 {
 	struct ksmbd_session_rpc *entry;
-	long index;
-
-	down_write(&sess->rpc_lock);
-	xa_for_each(&sess->rpc_handle_list, index, entry) {
-		xa_erase(&sess->rpc_handle_list, index);
-		__session_rpc_close(sess, entry);
-	}
-	up_write(&sess->rpc_lock);
+	unsigned long index;
 
+	xa_for_each(&sess->rpc_handle_list, index, entry)
+		ksmbd_session_rpc_close(sess, index);
 	xa_destroy(&sess->rpc_handle_list);
 }
 
@@ -333,9 +332,9 @@ static int __rpc_method(char *rpc_name)
 
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 {
-	struct ksmbd_session_rpc *entry, *old;
+	struct ksmbd_session_rpc *entry;
 	struct ksmbd_rpc_command *resp;
-	int method, id;
+	int method, id, ret;
 
 	method = __rpc_method(rpc_name);
 	if (method < 0)
@@ -347,31 +346,29 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 
 	entry->method = method;
 	entry->id = id = ksmbd_ipc_id_alloc();
-	if (id < 0)
-		goto free_entry;
-
-	down_write(&sess->rpc_lock);
-	old = xa_store(&sess->rpc_handle_list, id, entry, KSMBD_DEFAULT_GFP);
-	if (xa_is_err(old)) {
-		up_write(&sess->rpc_lock);
-		goto free_id;
+	if (id < 0) {
+		kfree(entry);
+		return id;
 	}
+	mutex_init(&entry->lock);
+	refcount_set(&entry->refcount, 1);
 
-	resp = ksmbd_rpc_open(sess, id);
+	resp = ksmbd_rpc_open(entry);
 	if (!resp) {
-		xa_erase(&sess->rpc_handle_list, entry->id);
-		up_write(&sess->rpc_lock);
-		goto free_id;
+		ksmbd_session_rpc_free(entry);
+		return -EINVAL;
 	}
+	kvfree(resp);
 
+	down_write(&sess->rpc_lock);
+	ret = xa_err(xa_store(&sess->rpc_handle_list, id, entry,
+			      KSMBD_DEFAULT_GFP));
 	up_write(&sess->rpc_lock);
-	kvfree(resp);
+	if (ret) {
+		__session_rpc_close(entry);
+		return ret;
+	}
 	return id;
-free_id:
-	ksmbd_rpc_id_free(entry->id);
-free_entry:
-	kfree(entry);
-	return -EINVAL;
 }
 
 void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
@@ -381,8 +378,53 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
 	down_write(&sess->rpc_lock);
 	entry = xa_erase(&sess->rpc_handle_list, id);
 	if (entry)
-		__session_rpc_close(sess, entry);
+		WRITE_ONCE(entry->closed, true);
 	up_write(&sess->rpc_lock);
+	if (entry)
+		__session_rpc_close(entry);
+}
+
+/* The reference pins the entry while waiting without holding rpc_lock. */
+struct ksmbd_session_rpc *ksmbd_session_rpc_get(struct ksmbd_work *work,
+					     int id)
+{
+	struct ksmbd_session_rpc *entry;
+	int err;
+
+	down_read(&work->sess->rpc_lock);
+	entry = xa_load(&work->sess->rpc_handle_list, id);
+	if (entry)
+		refcount_inc(&entry->refcount);
+	up_read(&work->sess->rpc_lock);
+	if (!entry)
+		return ERR_PTR(-ENOENT);
+
+	mutex_lock(&entry->lock);
+	if (READ_ONCE(work->state) == KSMBD_WORK_CANCELLED) {
+		err = -ECANCELED;
+		goto err_put;
+	}
+	if (ksmbd_conn_exiting(work->conn) ||
+	    ksmbd_conn_releasing(work->conn) ||
+	    READ_ONCE(work->sess->tearing_down)) {
+		err = -ESHUTDOWN;
+		goto err_put;
+	}
+	if (READ_ONCE(entry->closed)) {
+		err = -EBADF;
+		goto err_put;
+	}
+	return entry;
+
+err_put:
+	ksmbd_session_rpc_put(entry);
+	return ERR_PTR(err);
+}
+
+void ksmbd_session_rpc_put(struct ksmbd_session_rpc *entry)
+{
+	mutex_unlock(&entry->lock);
+	ksmbd_session_rpc_free(entry);
 }
 
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
@@ -779,14 +821,14 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 		up_write(&prev_sess->chann_lock);
 		goto out;
 	}
-	prev_sess->tearing_down = true;
+	WRITE_ONCE(prev_sess->tearing_down, true);
 	up_write(&prev_sess->chann_lock);
 
 	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_RECONNECT);
 	err = ksmbd_conn_wait_idle_sess(conn, prev_sess);
 	if (err) {
 		down_write(&prev_sess->chann_lock);
-		prev_sess->tearing_down = false;
+		WRITE_ONCE(prev_sess->tearing_down, false);
 		up_write(&prev_sess->chann_lock);
 		ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_GOOD);
 		goto out;
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 217258551d6d..fe9d3ef1cc80 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -7,6 +7,8 @@
 #define __USER_SESSION_MANAGEMENT_H__
 
 #include <linux/hashtable.h>
+#include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/xarray.h>
 
 #include "../smb_common.h"
@@ -17,6 +19,15 @@
 #define PREAUTH_HASHVALUE_SIZE		64
 
 struct ksmbd_file_table;
+struct ksmbd_work;
+
+struct ksmbd_session_rpc {
+	int			id;
+	unsigned int		method;
+	struct mutex		lock;
+	refcount_t		refcount;
+	bool			closed;
+};
 
 struct channel {
 	char			sess_key[CIFS_KEY_SIZE];
@@ -123,7 +134,11 @@ void ksmbd_release_tree_conn_id(struct ksmbd_session *sess, int id);
 
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name);
 void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id);
+void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess);
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id);
+struct ksmbd_session_rpc *ksmbd_session_rpc_get(struct ksmbd_work *work,
+					     int id);
+void ksmbd_session_rpc_put(struct ksmbd_session_rpc *entry);
 void ksmbd_user_session_get(struct ksmbd_session *sess);
 void ksmbd_user_session_put(struct ksmbd_session *sess);
 int create_proc_sessions(void);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 18602a4759c0..e251edc2d1ae 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3112,7 +3112,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 		smb2_set_err_rsp(work);
 		return -ENOENT;
 	}
-	sess->tearing_down = true;
+	WRITE_ONCE(sess->tearing_down, true);
 	up_write(&sess->chann_lock);
 
 	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_RECONNECT);
@@ -3121,7 +3121,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	err = ksmbd_conn_wait_idle_sess(conn, sess);
 	if (err) {
 		down_write(&sess->chann_lock);
-		sess->tearing_down = false;
+		WRITE_ONCE(sess->tearing_down, false);
 		up_write(&sess->chann_lock);
 		ksmbd_all_conn_set_status(sess, KSMBD_SESS_GOOD);
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
@@ -3130,6 +3130,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	}
 
 	ksmbd_close_session_fds(work);
+	ksmbd_session_rpc_clear_list(sess);
 
 	if (ksmbd_tree_conn_session_logoff(sess)) {
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
@@ -8645,6 +8646,20 @@ int smb2_set_info(struct ksmbd_work *work)
 	return rc;
 }
 
+static __le32 smb2_pipe_error_status(int err, __le32 fallback)
+{
+	switch (err) {
+	case -ECANCELED:
+		return STATUS_CANCELLED;
+	case -ESHUTDOWN:
+		return STATUS_CONNECTION_DISCONNECTED;
+	case -EBADF:
+		return STATUS_FILE_CLOSED;
+	default:
+		return fallback;
+	}
+}
+
 /**
  * smb2_read_pipe() - handler for smb2 read from IPC pipe
  * @work:	smb work containing read IPC pipe command buffer
@@ -8656,6 +8671,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	int nbytes = 0, err;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
+	struct ksmbd_session_rpc *rpc;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
 
@@ -8663,13 +8679,19 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
 	id = req->VolatileFileId;
 
-	rpc_resp = ksmbd_rpc_read(work->sess, id);
+	rpc = ksmbd_session_rpc_get(work, id);
+	if (IS_ERR(rpc)) {
+		err = PTR_ERR(rpc);
+		rpc_resp = NULL;
+		goto out;
+	}
+	rpc_resp = ksmbd_rpc_read(work->sess, rpc);
 	if (rpc_resp) {
 		void *aux_payload_buf;
 
 		if (rpc_resp->flags != KSMBD_RPC_OK) {
 			err = -EINVAL;
-			goto out;
+			goto out_put;
 		}
 
 		aux_payload_buf =
@@ -8677,7 +8699,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 				 KSMBD_DEFAULT_GFP);
 		if (!aux_payload_buf) {
 			err = -ENOMEM;
-			goto out;
+			goto out_put;
 		}
 
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
@@ -8692,14 +8714,12 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 					     aux_payload_buf, nbytes);
 		if (err) {
 			kvfree(aux_payload_buf);
-			goto out;
+			goto out_put;
 		}
 		kvfree(rpc_resp);
 	} else {
-		err = ksmbd_iov_pin_rsp(work, (void *)rsp,
-					offsetof(struct smb2_read_rsp, Buffer));
-		if (err)
-			goto out;
+		err = -EIO;
+		goto out_put;
 	}
 
 	rsp->StructureSize = cpu_to_le16(17);
@@ -8708,10 +8728,14 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rsp->DataLength = cpu_to_le32(nbytes);
 	rsp->DataRemaining = 0;
 	rsp->Flags = 0;
+	ksmbd_session_rpc_put(rpc);
 	return 0;
 
+out_put:
+	ksmbd_session_rpc_put(rpc);
 out:
-	rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
+	rsp->hdr.Status = smb2_pipe_error_status(err,
+						STATUS_UNEXPECTED_IO_ERROR);
 	smb2_set_err_rsp(work);
 	kvfree(rpc_resp);
 	return err;
@@ -9272,6 +9296,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	struct smb2_write_req *req;
 	struct smb2_write_rsp *rsp;
 	struct ksmbd_rpc_command *rpc_resp;
+	struct ksmbd_session_rpc *rpc;
 	u64 id = 0;
 	int err = 0, ret = 0;
 	char *data_buf;
@@ -9294,22 +9319,34 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 			   le16_to_cpu(req->DataOffset));
 
-	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
-	if (rpc_resp) {
-		if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
-			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-			kvfree(rpc_resp);
-			smb2_set_err_rsp(work);
-			return -EOPNOTSUPP;
-		}
-		if (rpc_resp->flags != KSMBD_RPC_OK) {
-			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-			smb2_set_err_rsp(work);
-			kvfree(rpc_resp);
-			return ret;
-		}
+	rpc = ksmbd_session_rpc_get(work, id);
+	if (IS_ERR(rpc)) {
+		err = PTR_ERR(rpc);
+		rsp->hdr.Status = smb2_pipe_error_status(err,
+							STATUS_INVALID_HANDLE);
+		smb2_set_err_rsp(work);
+		return err;
+	}
+	rpc_resp = ksmbd_rpc_write(work->sess, rpc, data_buf, length);
+	ksmbd_session_rpc_put(rpc);
+	if (!rpc_resp) {
+		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
+		smb2_set_err_rsp(work);
+		return -EIO;
+	}
+	if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
+		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		kvfree(rpc_resp);
+		smb2_set_err_rsp(work);
+		return -EOPNOTSUPP;
+	}
+	if (rpc_resp->flags != KSMBD_RPC_OK) {
+		rsp->hdr.Status = STATUS_INVALID_HANDLE;
+		smb2_set_err_rsp(work);
 		kvfree(rpc_resp);
+		return ret;
 	}
+	kvfree(rpc_resp);
 
 	rsp->StructureSize = cpu_to_le16(17);
 	rsp->DataOffset = 0;
@@ -10666,49 +10703,87 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	return ret;
 }
 
+static int smb2_ioctl_rsp(struct ksmbd_work *work, struct smb2_ioctl_rsp *rsp,
+			  unsigned int cnt_code, unsigned int nbytes)
+{
+	rsp->CtlCode = cpu_to_le32(cnt_code);
+	rsp->InputCount = cpu_to_le32(0);
+	rsp->InputOffset = cpu_to_le32(112);
+	rsp->OutputOffset = cpu_to_le32(112);
+	rsp->OutputCount = cpu_to_le32(nbytes);
+	rsp->StructureSize = cpu_to_le16(49);
+	rsp->Reserved = cpu_to_le16(0);
+	rsp->Flags = cpu_to_le32(0);
+	rsp->Reserved2 = cpu_to_le32(0);
+	return ksmbd_iov_pin_rsp(work, rsp,
+				 sizeof(struct smb2_ioctl_rsp) + nbytes);
+}
+
 static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 				 unsigned int out_buf_len,
 				 struct smb2_ioctl_req *req,
 				 struct smb2_ioctl_rsp *rsp)
 {
 	struct ksmbd_rpc_command *rpc_resp;
+	struct ksmbd_session_rpc *rpc;
 	char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
-	int nbytes = 0;
+	unsigned int nbytes;
+	int err;
 
-	rpc_resp = ksmbd_rpc_ioctl(work->sess, id, data_buf,
+	rpc = ksmbd_session_rpc_get(work, id);
+	if (IS_ERR(rpc)) {
+		err = PTR_ERR(rpc);
+		rsp->hdr.Status = smb2_pipe_error_status(err,
+							STATUS_INVALID_PARAMETER);
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
 				   le32_to_cpu(req->InputCount));
-	if (rpc_resp) {
-		if (rpc_resp->flags == KSMBD_RPC_SOME_NOT_MAPPED) {
-			/*
-			 * set STATUS_SOME_NOT_MAPPED response
-			 * for unknown domain sid.
-			 */
-			rsp->hdr.Status = STATUS_SOME_NOT_MAPPED;
-		} else if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
-			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-			goto out;
-		} else if (rpc_resp->flags != KSMBD_RPC_OK) {
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
-			goto out;
-		}
+	if (!rpc_resp) {
+		ksmbd_session_rpc_put(rpc);
+		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
 
-		nbytes = rpc_resp->payload_sz;
-		if (rpc_resp->payload_sz > out_buf_len) {
-			rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
-			nbytes = out_buf_len;
-		}
+	if (rpc_resp->flags == KSMBD_RPC_SOME_NOT_MAPPED) {
+		/*
+		 * set STATUS_SOME_NOT_MAPPED response
+		 * for unknown domain sid.
+		 */
+		rsp->hdr.Status = STATUS_SOME_NOT_MAPPED;
+	} else if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
+		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		goto error;
+	} else if (rpc_resp->flags != KSMBD_RPC_OK) {
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		goto error;
+	}
 
-		if (!rpc_resp->payload_sz) {
-			rsp->hdr.Status =
-				STATUS_UNEXPECTED_IO_ERROR;
-			goto out;
-		}
+	nbytes = rpc_resp->payload_sz;
+	if (rpc_resp->payload_sz > out_buf_len) {
+		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+		nbytes = out_buf_len;
+	}
 
-		memcpy((char *)rsp->Buffer, rpc_resp->payload, nbytes);
+	if (!rpc_resp->payload_sz) {
+		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
+		goto error;
 	}
-out:
+
+	memcpy((char *)rsp->Buffer, rpc_resp->payload, nbytes);
+	err = smb2_ioctl_rsp(work, rsp, FSCTL_PIPE_TRANSCEIVE, nbytes);
+	ksmbd_session_rpc_put(rpc);
 	kvfree(rpc_resp);
-	return nbytes;
+	return err;
+
+error:
+	ksmbd_session_rpc_put(rpc);
+	kvfree(rpc_resp);
+	smb2_set_err_rsp(work);
+	return 0;
 }
 
 static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
@@ -11019,8 +11094,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 	}
 	case FSCTL_PIPE_TRANSCEIVE:
 		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
-		nbytes = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
-		break;
+		ret = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
+		if (ret < 0)
+			goto out;
+		return 0;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
 		if (conn->dialect < SMB30_PROT_ID) {
 			ret = -EOPNOTSUPP;
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index e550aa41ad2c..480d43c5a5bd 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -813,7 +813,7 @@ ksmbd_ipc_share_config_request(const char *name)
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
+struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_rpc_command *req;
@@ -825,8 +825,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
 
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= KSMBD_RPC_OPEN_METHOD;
 	req->payload_sz = 0;
 
@@ -835,7 +835,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle)
+struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_rpc_command *req;
@@ -847,8 +847,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle
 
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= KSMBD_RPC_CLOSE_METHOD;
 	req->payload_sz = 0;
 
@@ -857,7 +857,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle,
+struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry,
 					  void *payload, size_t payload_sz)
 {
 	struct ksmbd_ipc_msg *msg;
@@ -871,25 +872,24 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	if (!msg)
 		return NULL;
 
-	lockdep_assert_not_held(&sess->rpc_lock);
+	lockdep_assert_held(&entry->lock);
 
-	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= rpc_context_flags(sess);
 	req->flags |= KSMBD_RPC_WRITE_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
-	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle)
+struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_rpc_command *req;
@@ -899,24 +899,23 @@ struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle)
 	if (!msg)
 		return NULL;
 
-	lockdep_assert_not_held(&sess->rpc_lock);
+	lockdep_assert_held(&entry->lock);
 
-	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= rpc_context_flags(sess);
 	req->flags |= KSMBD_RPC_READ_METHOD;
 	req->payload_sz = 0;
-	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle,
+struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry,
 					  void *payload, size_t payload_sz)
 {
 	struct ksmbd_ipc_msg *msg;
@@ -930,18 +929,16 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	if (!msg)
 		return NULL;
 
-	lockdep_assert_not_held(&sess->rpc_lock);
+	lockdep_assert_held(&entry->lock);
 
-	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= rpc_context_flags(sess);
 	req->flags |= KSMBD_RPC_IOCTL_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
-	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
diff --git a/fs/smb/server/transport_ipc.h b/fs/smb/server/transport_ipc.h
index e51850f1423b..df94ba116d43 100644
--- a/fs/smb/server/transport_ipc.h
+++ b/fs/smb/server/transport_ipc.h
@@ -16,6 +16,7 @@ struct ksmbd_login_response_ext *
 ksmbd_ipc_login_request_ext(const char *account);
 
 struct ksmbd_session;
+struct ksmbd_session_rpc;
 struct ksmbd_share_config;
 struct ksmbd_tree_connect;
 struct sockaddr;
@@ -34,12 +35,15 @@ struct ksmbd_spnego_authen_response *
 ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len);
 int ksmbd_ipc_id_alloc(void);
 void ksmbd_rpc_id_free(int handle);
-struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle);
-struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle);
-struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle,
+struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session_rpc *entry);
+struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session_rpc *entry);
+struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry,
 					  void *payload, size_t payload_sz);
-struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle);
-struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle,
+struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess,
+					 struct ksmbd_session_rpc *entry);
+struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry,
 					  void *payload, size_t payload_sz);
 void ksmbd_ipc_release(void);
 void ksmbd_ipc_soft_reset(void);
-- 
2.56.0

