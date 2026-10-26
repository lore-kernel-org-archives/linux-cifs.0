Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792992971;
	b=EWzN8v/DnyK7g9KOcnY+qE7lXlaM+sr05QqaGRUdakh4F961cDwtOfed1zHLE28ejRiR
	 pzAKuCh/vvKg2KIsAArrClJAfUHqM+oqeFa+QGOIPzSAXbqP56MwR6hl/OHaKs1WlS0o/
	 pIfPYdrP//OSRckGnp1fst5TXBrMauEsBckMgnjjaKwbHUKFBFLBrjXtKykMPb12Wd/cV
	 Y+BXYh1PasAsEriXer435ueGzSIkl5IDgWE1OZy4qZkqaT2P+/aDSOL+JxVPIn6TvAPRL
	 lVjUpxeKN7GWojn4KdvHJjZ2oB0BooLV85w+Q7TecqpXIeDnoQen9LmS99Gyk69oreQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992971;
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
	bh=k8jy0yIgxZv11g6nQd4O6U+8Uen7dAAsqv2Y3sbNhdI=;
	b=V0G9S5pzrbWirCtwTBomXRyrVc/PYix7DLu9kmCudoojlmszJLlYgnuG8F1VPtIZGXEx
	 y1fnNWXCflyFXyXxptsoTtXYOAykHvwYKoo4MrT0yF3eqjuh23YoI/ULafYrJciLwbpp1
	 53+uYNZY++2BE2fqmZz7pvZhLpLCIWuYFFJZn1xKetrh3n+ycz90chNTBbv+7We6L+MSa
	 O5Jjp8UsHfZD1AoHmMrtBTAenFki6tCDqIDm6xi4MmG9OzDHoPuM7mwqpoTvakJrgxQOL
	 oek52RVCK3TSKEzO1nJxfOAxI/F06ou+IjLEytBXieEBrM4R2ghw9iRdcVsfu8FNioQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=P+Z8zvyi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.56
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012056.outbound.protection.outlook.com [52.103.43.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2157B606A31E;
	Mon, 26 Oct 2026 05:36:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2157B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=P+Z8zvyi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCRqV3XbpuCKbFwMMuG2V5/JS/Hfn4uZeGliVtUjgi08oeOH8mYQQez+R+u/NT9Q3E+TkhZPm6GJTeRqJfWS44riV5TLiv06skveLJo+zPDpUETPZgqI/HefokDvRPe21k9L79/hkqxDas0Z0CiYYqxxSCiQ7OCXjpFqPcdZ9x6r1DE+l/G6wLmn8LDEwooXkurxYLHv3RH5vdDf0m649HYhKzkjji1vwnHkacDqlG/d4eWqNJMPDMWf3Kj8lleLYozgNvevSQzU1bGg9TKW1GyuKcVJReYkLLbDIGvZ0TFy4C5YPopJB4k4RmCVN5r/iHKOUKFZWxtrGjaonStlvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8jy0yIgxZv11g6nQd4O6U+8Uen7dAAsqv2Y3sbNhdI=;
 b=vbTE8QNe9xZ3pSyq/zIi5i3C8fPAclUGBt6uumkY19Lc8+384yuAm/nHJyMQfgw/pXKPh0t2h8EmoF03KjtYgBnYdAxJV5O5LhrVbajLK6XLIh1P+oF8aOPqiHPyO2x4CuPjNoyMLGZ8pZHHr1Yt0wEEMmgUUAOEph1DwUqmHRqiZNQYkkfpZYK9WqgZ7tTOKESOpYlzYF34MH8EjLmslwK2lv2VA74oxJucLnjGr3ChA0siOwK7mK71gD6bqUCaeJbzTIfBlQrl4Mc9fIteXI1/Lb/PH1HeLjSGAC+K8qXSG7VHdrmgPuMPta3UT/ghGNZbRCKEu5ALJa3c8hxy9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8jy0yIgxZv11g6nQd4O6U+8Uen7dAAsqv2Y3sbNhdI=;
 b=P+Z8zvyiMQ4+Soqv11U89d8TDGktjD+NYcnmn7IOccL2rkztUabLbzsBdhK1GQPBO5RYKayRAWeFqMMjem7Mu1JyZnffjxRYcbZafAR3lA7p8Hr0RtTcbTg2xogfpeYCtf0681XNj6ysgDnk5tU0lugDSbs46Lrmt714wnb4Pb3yrZTFmOKL313ONVapzVId4DyZg2gtZ8HQy0Z27rw841qtpWxrhblfOhB5MjEtdIA8e+d85qHho1ZqCOzMcaSwsRi9Ec7ShuQTI51EQ+FXCFTEUcUUedE8CqMLUwJRLq5+e7ktOxmMMAKOiBQIKUPGAQ4BurycQmYq7eZhgqG4XA==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by OSNPR02MB8964.apcprd02.prod.outlook.com (2603:1096:604:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:06 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:06 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] ksmbd: avoid races between named-pipe operations
Date: Mon, 26 Oct 2026 13:35:42 +0800
Message-ID:
 <SEYPR02MB6964F080A28E68F112768BF7E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0042.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::26) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026053543.1460241-2-wangzhaolong3@outlook.com>
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
X-MS-TrafficTypeDiagnostic: SEYPR02MB6964:EE_|OSNPR02MB8964:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ed0876-092e-49dd-11ef-08df332306fd
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|51005399006|8060799015|19110799012|24021099003|23021999003|12121999013|15080799012|22091999003|24121999003|41001999006|260925184616899003|4140399003|25010399006|3412199025|4302099013|440099028|12091999003|10035399007|1602099012|40105399003|26121999007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y5p/4es2zsvC5JcnnNfhkYJD44iLIk5/6fBNmWLmcJlJNO3CzMKfoNbTYxMd?=
 =?us-ascii?Q?m4R9uidtOf4+olSOzXtEQlxYg3LSjx88pYRkQedo+cWaRkiDVecQu7TXZUR3?=
 =?us-ascii?Q?n+mbn7Z+YvbJBQAUd7JJ4UWRcK3nacTXeCSFRpzQwBCA7EvLmclIgtDA/tEC?=
 =?us-ascii?Q?WOcrMxJ+YgY/t1SLoEG5lviRiN/W5fh54oJE9UTOb8r7JZRnKkJKNrUZFQN9?=
 =?us-ascii?Q?hPt8SXXLAYdbQvCKjXBCEsuYUlwQxlQtJYTOgDzYaU7r9cbDWO2NjHY/6C4I?=
 =?us-ascii?Q?+nPfZYPyeBAzQXd3AU0Zo6LjP0lCTVR/qL33MuU7s5EPQfFs1exXkmSz1yy7?=
 =?us-ascii?Q?de/wJj8Uuzsb/dkLjTLGFYVxRK4AelCRbBOirEkoxslVVdIl6DpcaySSnNS5?=
 =?us-ascii?Q?8R5VSOu/1DhebNPayezCSI8yqF2kKbOHMWEdWBypBtX2hOGz0FiD7dyiFnX1?=
 =?us-ascii?Q?slXIYuT1mKk0I3dANpAPpz3EhRlFcet4zc5IS87DBv/jvwd6qJACg65heHso?=
 =?us-ascii?Q?xZqTVmBBbHad0DeFJO1yziBodOVanXUm2dthuUdRomxpTNCmdAONhoID5uTc?=
 =?us-ascii?Q?REfx3+3qdTKbhQ/Bjh5yRhwJHxuQDKp7qrpIF8FMfJWe6GhWKNJuyckuiXjw?=
 =?us-ascii?Q?5PnQIZ9FSX4h51kRiWbW2EN63SFAIrv2QFcJbi6WkL05rbVj/48v7yiU6i/m?=
 =?us-ascii?Q?T1rN1XhMOo4jqrDnBDrWaFMA2MrTkN1oiASJg+7AH+IQiYJHU9U4v0URdpwx?=
 =?us-ascii?Q?kjlnlEPKo+3cmuxW3jc2PRvGdzB3JW/t4+VrXWtTFAAUk7LMULRD3Aimw/C4?=
 =?us-ascii?Q?FCsFT9HVm5gvmqcQOodTdZKZIDdZCKZuun/S6WNX4bp0KS+5rszLk+1MUcNu?=
 =?us-ascii?Q?FfhQt7yfCSl5r6iwrAybBHG8n4R3HIqMhdPlejKEIaSuXx0xJJCC2dc5uoAB?=
 =?us-ascii?Q?KpDP3l42IiwnCHVPWRMuX5F41Jal23Mvc953hc5q9iF6u1D198zBGbdCymyN?=
 =?us-ascii?Q?K0hwvo5WHWugezHlyQTc7HNzRuoEsXYNaKKRLZGu6DBvL//UDAZM+o/deR/N?=
 =?us-ascii?Q?wt+2XXmrun9j5Ab3nUoy/4G+5MGBjcwg0tnh/MHJd+lPqOe82VNGsxjoX4QD?=
 =?us-ascii?Q?/ntno/vHVBwB+574HUDehaliriCPS6Q+D20OWfbX8DmUAv+C+ANji8E=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L5L6JAcBaoRd4Goe1jMqAZ1rKqRBoOxW//zNnmfy0dSyafRYe2f1OGkIVMpk?=
 =?us-ascii?Q?Fc2t9Ue/4cdBQ22m/Ew0MKX07GaSypXOfQNaS5HzebHh6bo9YEHby2IkQUa1?=
 =?us-ascii?Q?HeapEAX9MumDg/kc2W8OCzXMQ2lZMTmChK+TvTmLRMW2n+zy4s8t2uYtnyMd?=
 =?us-ascii?Q?gln+NsHfWhy+fmUc0EsMtgRAZ0Vf2d1ei8kdht8ISjDpljPlwRmN4iZKb255?=
 =?us-ascii?Q?5tZm4PnGd3ODZkxTE8emyvYQWbxIRajhadPCxoKMSQH2kjrxmXaSk5XzUm8J?=
 =?us-ascii?Q?C5Fyg6aWGJS7pOQmQL5vTux4r34k903QMn0mBbDLJltMdn8MEfMF3Aj05U1m?=
 =?us-ascii?Q?pECGzVqveeRBNlaIGmhYMjpciVvg0hhUHyB7WFpNrmpzv4yXXoQ1LUIrI3TT?=
 =?us-ascii?Q?SdDF7oaPnukOk07Ok0zuviCJOAC4tbZIJC/mGstg8n6sRgIN2AeL/Xi+AanL?=
 =?us-ascii?Q?32Ko8i0JOeQ+iM82OKjmWgtdsF5A2ntv596YjCGkqc7C3qtr/7u1ipCTlmMf?=
 =?us-ascii?Q?nxwuwsNh13JfpVGmmeMKLxcIgWbg84NZpSekjMMrotStfCJRpQpiONIsxsur?=
 =?us-ascii?Q?AG6miz8aawNBQnaBeu9BPbVD1IFLsanZ9D+QNcZVencx7S/mM/ST1xP5PnwI?=
 =?us-ascii?Q?uPe5R1Wsj3CcS/o4u8Qhq7WgG+gK7zMPxHdtj0RQwZL0htGaHm7hmb0ayiT/?=
 =?us-ascii?Q?yDKKx4lJFlvSF4V6Vhs+OlohuL85rqSBg7ukOiJAORcnfSGhxxAvrgO+Vrwv?=
 =?us-ascii?Q?o1YPITXwClT5AJr8y4E5xS7zG0W6CExLnyqkmO59u9MaaYKY5sMVpFV7gyEx?=
 =?us-ascii?Q?3B3f6ZeBwmMbk+YcHK5x7TZQiSXiCdZTN8OPqARjSaORen20LLHzIrFEF6wQ?=
 =?us-ascii?Q?XN2L0FOEOyNw2c884usVccXDcAogDdjPLDJEMCG3pZPetvcY0w4PrU/kxGG/?=
 =?us-ascii?Q?YbFhDe3DneFCfeBxX5zirluZ8BTNyqra3GVfGGuR1noqkJIImw4XuJOOkaq7?=
 =?us-ascii?Q?SMdX1UlsZyBAW72V+JvgM+iY8veLRBdRqAkZMivZ8pjqi+7TWmJYWrvFEDFA?=
 =?us-ascii?Q?cLthfZrCQcXPpyVvJvO7gYaVpgzzyvXLkX2qF5YcTRR8gwszSQwN8Il23oFV?=
 =?us-ascii?Q?56jFd2L/+WJ1gQLw2ZltgbA3vb6WihXuUmztByBs/N6uOqBgtj4LOF6jdTNR?=
 =?us-ascii?Q?vw/4t4Mrw92/t5SyfMgwPib/DwGrzZ22pI8H/J0uJ1IgQlziEPg8f7G0F6LV?=
 =?us-ascii?Q?2miyYaUXqYFDjE2VBjhaiLiH6gzVa8ykvUiXqM1GBLNvhhzAeIT7HB6tUjHV?=
 =?us-ascii?Q?JcA8ESUX5FcpsCz3cqyLRJNGCAAdz6oFPfFwi1LQlUX1Rj0/5Lm+MsPKpRVB?=
 =?us-ascii?Q?02jzESw3XE4D9TsduD7oceFK07e54mSaLXWDGJ6lDSqfhVYmZrGvswBWLiC2?=
 =?us-ascii?Q?t+YERXFZIzg=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ed0876-092e-49dd-11ef-08df332306fd
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:05.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR02MB8964

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

Link: https://bugzilla.kernel.org/show_bug.cgi?id=222197
Signed-off-by: Wang Zhaolong <wangzhaolong3@outlook.com>
---
 fs/smb/server/mgmt/user_session.c | 127 +++++++++++++-------
 fs/smb/server/mgmt/user_session.h |  15 +++
 fs/smb/server/smb2pdu.c           | 190 +++++++++++++++++++++---------
 fs/smb/server/transport_ipc.c     |  45 ++++---
 fs/smb/server/transport_ipc.h     |  14 ++-
 5 files changed, 263 insertions(+), 128 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 3ff3671cd019..4db69809b9fd 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/rwsem.h>
@@ -43,11 +44,6 @@ void ksmbd_session_release_slot(struct ksmbd_conn *conn)
 	atomic64_dec(&conn->session_count);
 }
 
-struct ksmbd_session_rpc {
-	int			id;
-	unsigned int		method;
-};
-
 #ifdef CONFIG_PROC_FS
 
 static const struct ksmbd_const_name ksmbd_sess_cap_const_names[] = {
@@ -301,32 +297,34 @@ static void free_channel_list(struct ksmbd_session *sess)
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
 
@@ -356,9 +354,9 @@ static int __rpc_method(char *rpc_name)
 
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 {
-	struct ksmbd_session_rpc *entry, *old;
+	struct ksmbd_session_rpc *entry;
 	struct ksmbd_rpc_command *resp;
-	int method, id;
+	int method, id, ret;
 
 	method = __rpc_method(rpc_name);
 	if (method < 0)
@@ -370,31 +368,29 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 
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
@@ -404,8 +400,53 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
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
@@ -904,7 +945,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 		up_write(&prev_sess->chann_lock);
 		goto out;
 	}
-	prev_sess->tearing_down = true;
+	WRITE_ONCE(prev_sess->tearing_down, true);
 	up_write(&prev_sess->chann_lock);
 	ksmbd_user_session_get(prev_sess);
 	pinned = true;
@@ -923,7 +964,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 	down_write(&conn->session_lock);
 	if (err) {
 		down_write(&prev_sess->chann_lock);
-		prev_sess->tearing_down = false;
+		WRITE_ONCE(prev_sess->tearing_down, false);
 		up_write(&prev_sess->chann_lock);
 		ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_GOOD);
 		goto out;
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 8e4ddb04f0e6..38073ea9089d 100644
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
@@ -133,7 +144,11 @@ void ksmbd_release_tree_conn_id(struct ksmbd_session *sess, int id);
 
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
index f5fe3cf8ba32..66123b7afd5d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3234,7 +3234,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 		smb2_set_err_rsp(work);
 		return -ENOENT;
 	}
-	sess->tearing_down = true;
+	WRITE_ONCE(sess->tearing_down, true);
 	up_write(&sess->chann_lock);
 
 	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_RECONNECT);
@@ -3243,7 +3243,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	err = ksmbd_conn_wait_idle_sess(conn, sess);
 	if (err) {
 		down_write(&sess->chann_lock);
-		sess->tearing_down = false;
+		WRITE_ONCE(sess->tearing_down, false);
 		up_write(&sess->chann_lock);
 		ksmbd_all_conn_set_status(sess, KSMBD_SESS_GOOD);
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
@@ -3252,6 +3252,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	}
 
 	ksmbd_close_session_fds(work);
+	ksmbd_session_rpc_clear_list(sess);
 
 	if (ksmbd_tree_conn_session_logoff(sess)) {
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
@@ -9246,6 +9247,21 @@ int smb2_set_info(struct ksmbd_work *work)
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
+	case -ENOENT:
+		return STATUS_FILE_CLOSED;
+	default:
+		return fallback;
+	}
+}
+
 /**
  * smb2_read_pipe() - handler for smb2 read from IPC pipe
  * @work:	smb work containing read IPC pipe command buffer
@@ -9257,6 +9273,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	int nbytes = 0, err;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
+	struct ksmbd_session_rpc *rpc;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
 
@@ -9274,13 +9291,19 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	}
 	up_read(&work->sess->rpc_lock);
 
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
@@ -9288,7 +9311,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 				 KSMBD_DEFAULT_GFP);
 		if (!aux_payload_buf) {
 			err = -ENOMEM;
-			goto out;
+			goto out_put;
 		}
 
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
@@ -9303,14 +9326,12 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
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
@@ -9319,10 +9340,14 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
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
@@ -9883,6 +9908,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	struct smb2_write_req *req;
 	struct smb2_write_rsp *rsp;
 	struct ksmbd_rpc_command *rpc_resp;
+	struct ksmbd_session_rpc *rpc;
 	u64 id = 0;
 	int err = 0, ret = 0;
 	char *data_buf;
@@ -9917,22 +9943,34 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 			   data_offset);
 
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
@@ -11378,49 +11416,87 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
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
@@ -11752,8 +11828,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->PersistentFileId = pid;
 		rsp->VolatileFileId = id;
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
index eb07cdf17410..e8dfc42a1d08 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -834,7 +834,7 @@ ksmbd_ipc_share_config_request(const char *name)
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
+struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_rpc_command *req;
@@ -846,8 +846,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
 
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= KSMBD_RPC_OPEN_METHOD;
 	req->payload_sz = 0;
 
@@ -856,7 +856,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int handle)
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle)
+struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session_rpc *entry)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_rpc_command *req;
@@ -868,8 +868,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle
 
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = handle;
-	req->flags = ksmbd_session_rpc_method(sess, handle);
+	req->handle = entry->id;
+	req->flags = entry->method;
 	req->flags |= KSMBD_RPC_CLOSE_METHOD;
 	req->payload_sz = 0;
 
@@ -878,7 +878,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_close(struct ksmbd_session *sess, int handle
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle,
+struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess,
+					  struct ksmbd_session_rpc *entry,
 					  void *payload, size_t payload_sz)
 {
 	struct ksmbd_ipc_msg *msg;
@@ -892,25 +893,24 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
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
@@ -920,24 +920,23 @@ struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle)
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
@@ -951,18 +950,16 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
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

