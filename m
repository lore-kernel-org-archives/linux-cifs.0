Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.81
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792990667;
	b=xw2Wdyc5hUaDqBapj+4NsCiyFd+3NFQZtr6ZDNDqUMOPsbujXneAJMyULICrtg1VVqtD
	 /IVFxv5rplgPiaTW3ldissQTkod+dgAWgIE9RyoB9DIqtaoZ43cQWc/6Nsu9r37YuFrSb
	 Oc6Clx785fDXmunqKxsOvYplVe/aWjhAbEPEZokrSXnlJqOlpRPzWXXJJoWhW6S3iHDF2
	 2ViuLNomLo/CYr4/EQGLba3Yq8Pc6MlOKefIJQNXwzS9MBixVd1ZO+myEbs3zZw7i2aGq
	 b4Ns7zwJ/Rkv4ZPbYbeUt2abUpwqzKwKFgW1Fg1w8vtYskAI9oEOqli7Ht3NZCDcoRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792990667;
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
	bh=NXTbiOMw4Op41OhscgKw9Pj8GmYwQPI3AERr7grtTa0=;
	b=Q2S0RXQ3he5YZH4Uc2e70JASN+uzKBTHQyvQJ9wWh5FTxyraMXxEvr6SkhrAI48CbhU2
	 oQrv5HhD9uJ6ayURRujqqoiP07g9oToVoCodjC3HoH7gYoVvoQm/vH7ZlSkmiWO9kcP7W
	 fCC6gZALaETm9TyYv+J/KeJf3NbwAC6LtJsCPmFY8KqHtvbIMuINCadJhdhBXtOjvxu6K
	 x6iN/seN1U5/lBvsMz4qqtKSYPWkv0IUP1MsRuQ/FX2lyU/7LpfeqgYeHzBfKoZWFsNrX
	 q2R29uI+4WTKnVTExRjUrBmvzA/CtIbV7TP75OsNR6CbNSez9lRx6FSeVDQSxwTyQtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=E7MwpfxZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.81
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013081.outbound.protection.outlook.com [52.103.74.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22B606A31F;
	Mon, 26 Oct 2026 04:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C22B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=E7MwpfxZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/aVedLUHC9gZysO3p2csp1zlKJLQBgGMwOBnudKw5fUa4WdNXDogJamc8NwDVRLFjyPRdRHWavtInMRtL/uBjBM5jl+0ZgREM7lH6wOJySvtW+97cV1s6Qa5K9PL0xA8X9Xicwl5yTMkd88reFo/j80UrA514MknPKhpJ12IvaEMji6MdX/kT1olL+h/UEfDbYq/90PUjmqTrfZFL8bA1Ofcf4tzMlna8XdOregDbzEqB6xJWk/Exusd2R0ka8XGhvLMoXZVlK5Why+sIup3FbQl1dwMCIT2cRkoD9ir4hbhcmReUXa9/DVv7UaFhIWUawpMwz4QcrzA4nomCDedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXTbiOMw4Op41OhscgKw9Pj8GmYwQPI3AERr7grtTa0=;
 b=hrsSf/A4ODkVlVz+y7MxglH0Dleqn0XXfOj3HLhk0N66b+Gzj6w9CNJm0sVE2FrdDKzPLo8l/DljgA0+yhh+/mPWqa/DgVroPn04JDRKTK5yc2nUHjBsjj435yeJSaMzzPlPmlxLM5Og86pUpqmWa/KMdnjSkBJckSW+gTI8Hx9dr5PENZdJ/jELasjHTAQtEEs1MUlAn5RrPNYIjJ+28l9IrAJxE0AT0N1Bu9x0KqZNKFKAP/qpFezrMP1CnElQEIyPsgK2vrUhZImwzAzyrvZp+Zaz9tYL+haIvIkWpHEVnjk9YlZOYEpU3oGmrdRiF8jtMB868H/pTA6wj3tW6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXTbiOMw4Op41OhscgKw9Pj8GmYwQPI3AERr7grtTa0=;
 b=E7MwpfxZNaHuv+SVOqTqHI01LdSRuWnsQgMqiT/oRB/SN6kOcXnuX51KdqwL0BLIt9ujUZPhPnYcMCzd74D39C9iIJ0vNg1hZ7CZAasVSu+tdrWkyKiW5NZAlqHGweYGLln2anekfRJQCeFIDUSuDjXIFk/i3C5CkFeAhzNgYy2G3gzSirt60PiLjlRLa10kIhxnZcXQ5bLZQaH+lOVFK4tZI6o6NtNhhoEeKiLGoXkx42RpBJnK/EUG+fN60WnVTP+pk3XuVgA0Q9AkHIVkvXeDWPFH+Ns+l+aPjTrI65dzVFP7EnfXz5Ch7ALOkrN/ZUGEScld/fFPs4QlsG3KGQ==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by SEYPR02MB7297.apcprd02.prod.outlook.com (2603:1096:101:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 04:57:42 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 04:57:41 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ksmbd: avoid races between named-pipe operations
Date: Mon, 26 Oct 2026 12:57:19 +0800
Message-ID:
 <SEYPR02MB6964F063E5CBE93F0996D98AE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <SEYPR02MB6964387A0BA1542BDA560115E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
References: <SEYPR02MB6964387A0BA1542BDA560115E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0013.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::9) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026045720.1324887-2-wangzhaolong3@outlook.com>
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
X-MS-TrafficTypeDiagnostic: SEYPR02MB6964:EE_|SEYPR02MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 44de58aa-2188-47b2-ab69-08df331daa5d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|5072599009|8060799015|22091999003|19110799012|12121999013|24121999003|23021999003|24021099003|8022599003|41001999006|25010399006|260925184616899003|3412199025|4302099013|440099028|1602099012|12091999003|3071699003|26121999007|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NKPdEJtsCzn8jCxAS1luPh/pZD3fjIrv4dWdxx9YfWYaZgAs7WzbRrJZI00o?=
 =?us-ascii?Q?D7IdhvrEGBUo9H0pQhj4b09cFNhF+9z/s2usDt6/desDQPmbRoxPuN6st2H9?=
 =?us-ascii?Q?U4NpRaWDZE6LIHAUMfjwKBIPE74rYOFZwYSwZi+Ypi7WC2ouFUrh42Jj0XNY?=
 =?us-ascii?Q?9FOTcBgckPN5VH7URzUgLj6OtNLlr817pMESRU4YZX3RYAFk63ZU69zExl25?=
 =?us-ascii?Q?9p/OyWYy1tRrbh+ou/kRU3ZM5n70KBPVPNZr5PFatCwbog34Fy4hdE120rRi?=
 =?us-ascii?Q?5CvnR7neU16MRK9HCMwTO2DzGb0NRj3tfOis+7rsdteNvnyf+Uw+2j+ZvotT?=
 =?us-ascii?Q?LTAM5yx0eOWzP6jVN077WDFIt+f3wNGoOfBM4hytjkfQK62t+zArTKIbnfsy?=
 =?us-ascii?Q?GgCiR4Mac3BsL1VPwjq8txc+SmgzxfhwnE/F8cA3/ewdYatj9vmGr9B8MV+R?=
 =?us-ascii?Q?tLMu+EaoydcmuaF3IAImL3FheSk1FNxrkF0B069fTAItviCw1Lzr6oE9CjRO?=
 =?us-ascii?Q?MLZspZqs40Th/RVkGH2UFsBdIvgwLPk+UzGmIy1fm0EcbtK21UzwHnLeKMXC?=
 =?us-ascii?Q?7KD0ubhsLUVRPUc1Rfn+kI6FWGDlfZh5zOKcf6TitmeFTSw6ea6IqxHK4qFC?=
 =?us-ascii?Q?M5Qp8RwhVetmki7pS0AfL0hAgjABDW7/MlS18DtGbQS6UgxpmdWTjusWV/D+?=
 =?us-ascii?Q?4Zuy1bYwfUT1SWZY9e1BQRI8OdoRzMWfbOFfnT5zelRqeQNMfS+qRlIoHeR9?=
 =?us-ascii?Q?dS5b9V699ZHtuEuhrKPAeNBY4pqwj9t+eRdo/2WxzIfNe/rvw23St5nSKHLu?=
 =?us-ascii?Q?NNYnTMdCYPmkPQ7gPsbN6QwbfJylcpyGcoT+aerluCErUPw0NSeTgEHbHAvC?=
 =?us-ascii?Q?Os4P07vb32yZfNXU0jGasAb4TEfpNy9qrQsPIfT9NSN4OR2g6DGV+e5TvW4O?=
 =?us-ascii?Q?WpnnVPgSWcXUmVCWZt6szu6EsGJpBEe0yyxWwzR8eyDP7DqyMjNr6bP3yG2R?=
 =?us-ascii?Q?vtPWDU61/T0bAUsKnk9nwaSbpvy+l8zlIihp0IL3IboTl+Yw8EuaLwS3A6TX?=
 =?us-ascii?Q?Os0reUFx6Sl6/40LQH7VimAz2EKpEjULzhtch5H/gz7Bv7Vg0lThj5rPY7Yg?=
 =?us-ascii?Q?HatJ2viqAZ7ypeVCtqKPE6bvdiQssBeQkhYtuo5Mf/QUzt0jpCq5FQA=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ej090gYQ57LM1rBCRAhfhngu3XpdwYvb92PEnkNvGbo6bOe9SDL6f6vdUdhr?=
 =?us-ascii?Q?AhpOtiP+Cm6HA1wNuj3T3SlbHu0uLihgrLb9moomFngafBBXb2HF6q8dHc6s?=
 =?us-ascii?Q?3E8cgiho83zj9yv0X2s5jqhwM8eXfHx8xo+/3VUhBeQKlfnUyhCs88smFSmG?=
 =?us-ascii?Q?Zzim+pvRNj2yqas8lJ8ShNuZ14p8HT6mSwYiLX4J9GIvFAc3Av3ab11vVlzT?=
 =?us-ascii?Q?OJnCmbNpvsFFHQy1q+7U5qRa4NsYQZamu23P4bWHXc2O4m3lU9jsxB9G1Uhd?=
 =?us-ascii?Q?tGZG/23cSb46WE/aYYKQ14i9sintk38dcm8p+TZQK1+gJaZCGRFyQxjGtCxU?=
 =?us-ascii?Q?VblwtCf27Oj0FyMbVVBuuFMS7vdIo3ij7oVfp7jCUh1WGw7AQfkdukNhlIUQ?=
 =?us-ascii?Q?M+yElHXaFN3fJmDU6/nVoc45xczRh/My7/0oZKd2aGKxd0x5kCR9pb4RguMI?=
 =?us-ascii?Q?LwCbJ3muKSlLIBiiyOeqGONOUaZMFao3uPjBf6X29apPQbpV+myHdgZETppc?=
 =?us-ascii?Q?BzKEq5Aca+9MmRl2s+Ovu9rL5HlMxdPHztJKH26oX9VWo8ImaZAfUy5w41O7?=
 =?us-ascii?Q?YynZEPGE3+AsXzeyazPVtELSHJxJVEU1pApFKP4WaU4d9kKwvH8O4tJNq436?=
 =?us-ascii?Q?2b1FGgHMvqMiskVl6a/4iciRUZo1Y56W2FOyNP9zDOL6FKHDKb6oogTZgsu4?=
 =?us-ascii?Q?v45F40wJGoxX5TvMgiM4wlMr/uH459JMQCVwKdn0rnG0y846ITQ3nwqp6HI6?=
 =?us-ascii?Q?MEG8d5FlNq8/+bJ8cfdVC6C90HhFBdY6hvd2EG0lq5PxGLOyn1RKrslpf1b1?=
 =?us-ascii?Q?RDN5ILUE4rj7c9HzMIDJ3rawp1JypoqWR/aBjGySH4PYYCldSZLv8TUqjME7?=
 =?us-ascii?Q?Gxz5OvYPnWTVQxIPAwn3jZLDvW3+ttuMZgNSTehHoZvFfQeK5K9tOk7HJpZl?=
 =?us-ascii?Q?QHYwmX+qm42kjt9HTVQwfVC2IbeU+j9/x2Ji/HR1l+2dA3o61wFsBVXKtHi0?=
 =?us-ascii?Q?2TqsTl6Q7UtfxdXDnVNi+cbIAtvfKVQfrU9ciZWr7+U9mbC6+z1eAi2Z6RN9?=
 =?us-ascii?Q?ubMLv7/sMxiYgy7g1ew+quReZBX4PYumNQXLGjG/vC7dozI8pI0nwH9Ks1He?=
 =?us-ascii?Q?nY8Cp+mofBL0xCc0ZfAAMNEOK2BeeEodJpQSomArYhic8nKV+No9SZVDmtXy?=
 =?us-ascii?Q?vWWrpCvEmD4h6tF2MT//hOzzub+zLPa+yyNST2WkE8d5XDXi68UxgsoQY+hT?=
 =?us-ascii?Q?Yu04dkOQjZMrqZzZuvgyrFzzs/kK5r9X/wmc9Vtz+5nx/CSaigVI5xoA11OG?=
 =?us-ascii?Q?2dp+WibIdmvLfw64BEowcWRakhCpxCaFlpkSNl2r/cJ2wxlWeTOvSF7T+n9k?=
 =?us-ascii?Q?R9ihUOdMetnStuZO3OQInhACxeQCWwsnp010vnsPEdf9terr/zBToppephi8?=
 =?us-ascii?Q?2LlKpQdi2H8=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44de58aa-2188-47b2-ab69-08df331daa5d
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 04:57:41.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7297

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
