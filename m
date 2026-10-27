Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112236;
	b=eXh8Bt2joneUhXYdWkoNdLW2euDb1JCbKDFilnBZYvgrnhQXUawNUUViRRw8cWNH11GA
	 uXQ4nq8LPFelSMXBUDkjkzofj4W7ORZdG1nbnnUytvkIRmFWPv+QGevKT+LD9aN2qc/cN
	 yEAuXr24MaH/6FaQG3DgktpfTTq1ua3/pKQ9Bo1etbCFppY/VWzrYTE4phSQxOMAahaYM
	 vmJmQ0p2VIEYKX4J+zDRjO5NGXKJkdAElXb/nHg3V/hevmXht/z6xAWWQ1Rpmj529zXi+
	 Nx4eXDzO4+1fmtX9o0rFD/LnmI8SAPEvwdHeA1XWKOpj0d6nAbEXeRDA7+rD9rSWNLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112236;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Reply-To:
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
	b=kzLPczFOK7DVRqfBAg2pB7rVTXL1KCMH/3Falx8+yxdM+jrFwQ3gouvpWYNTQg2Ogtq6
	 NEUsAc0atW4quX9Tnv8GJfUldBrEMX/b1H/RWfdkZPCoId/B7xLELjkwgrari6KkJ7Y1y
	 1Zd5ZyUVTaSmfk+ugQufvvrj09wfUr5C1BEDONSOidKxDtdC/BfIeeE2436L9u7PCVIwq
	 7T9Yzv/w7lDtr5XyVELxXE1UEt4AcsPEU/4x+zUyJ1i9OmwfOXCj/pRWMYaQyd0HPftU5
	 FUtaGx+yH+C4h2J7s/addnd5pVbAjzf0PjJQfywSMfmFIGvETrT7unFprwDH86VyvHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=I9GhLu29;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.56
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012056.outbound.protection.outlook.com [52.103.43.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DC1606A31D;
	Tue, 27 Oct 2026 14:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27DC1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=I9GhLu29
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrNpO5tud4KsfpFYsN5W1pplqKBbcvRFwo0RMEbJV9DufXGRcPKOMmuXIgBJ3BsXClBqNasCwceI6hC4Da824SubrBkZ7UK7bhRt8b/uHBnXQmVQ+CsF3YQxVH1qrtZyiUYBFkHG5rDQr0LNaTYcAu1N2qIVAI3PORpUs0sGBO9eR+be9rNO6pO0Jl/7+VXt3eYPRWPzHDI3aeVfJtvASqI1+LIpY/p6qXXvnGeg4H/FbTdwgvngSI2Ye8cciMLRF5f7iRmelEFLYoVSzO+/w/hfWMLxAUc5ytPEApDD7SW9E1ri1z2YVn6LftePjt3xu8x1MpwXGuE6FYpGC2vqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8jy0yIgxZv11g6nQd4O6U+8Uen7dAAsqv2Y3sbNhdI=;
 b=qeNH2Fh1Vt0AvJ1p2RM6ynVp/QvoLGV3aEzsnj2tgPTbsKpp4wJj82APECyoD7TCEgI9KIy2Is4So0GdYZc6szjg0tQ6NQVoF9cfzUBBbG2M0JmDHQ6nn2Xu/EAgiFvYp7aZWULUNAMS5Xq15E6l/gQIDnkcdcaQORhdlFmf7IYikJ5ia/ciFYbsfxvaVNN3ANOOv8QzaVpr8onL08ChFIrb5W0fApE35OJDgjrLVLQRxPk4vNjzOW4HkUsIPckQ5/BSQwgRLV8Ssro/efS0YvTeI6xZb/Br6ib/YnuTOiBCfIEml5W/rB5ZyTHPqE4oVKZ9lirMt1ByGrViOUvjLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8jy0yIgxZv11g6nQd4O6U+8Uen7dAAsqv2Y3sbNhdI=;
 b=I9GhLu29h+pyqcxcQ1zdDVXHquE5GtyiULe23J8DLi1cpkO04dDADijpXypO4cOrorKeo6/5/rIKAW/je1JrOpHICRfEPdk46k44iJ3pql38FBPfBB/RfMqZv4kkIpKY5XDQ9A5/Lj1zoTHsPblyip0Nkw94EQb9wScTm1mvomiube4X0qdLeJF9Jnh1gq1zPfPwwi+76IH5RnG5WsOQzYLUDT+e/fMwjnh7EaMmuOdv+G7KoLKT7TcUbXMXxfmsEsHSVaM8EGvRR20ur37o0CVQnWmJUJEZBV2ffW2uvmF7T7AvScihq2RSxrb43Gk0oqyuprRqJiPr/3GNnF3E7g==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by OSQPR02MB8798.apcprd02.prod.outlook.com (2603:1096:604:429::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:43:51 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:43:51 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] ksmbd: avoid races between named-pipe operations
Date: Tue, 27 Oct 2026 22:43:23 +0800
Message-ID:
 <TYZPR02MB695949234DE0E2F31CAD5D7AE6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
References: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
Reply-To: wangzhaolong633@gmail.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:610:cd::12) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261027144324.1869357-2-wangzhaolong3@outlook.com>
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
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|OSQPR02MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 43478758-ecdf-41f1-77bf-08df3438b748
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|12121999013|23021999003|22091999003|24021099003|24121999003|4140399003|25010399006|260925184616899003|41001999006|51005399006|19110799012|8060799015|5072599009|12091999003|10035399007|1602099012|40105399003|26121999007|3412199025|4302099013|440099028;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZDWtlv4i3KQb/4mz3aEl1oiXpH7WA8K9RGAaf4u4q8cN+Ep01AUENU5PRFtj?=
 =?us-ascii?Q?7Sh3Z5X06jgZIDeQ49sb+q1BD22j50ZVFK2y0IoxgNiSTwHdQKNh2renDgAp?=
 =?us-ascii?Q?q2f0tIxjnRgI0npu3v1/uun5OVIV/itnR8TkwywzQNSUt5q+SICKNRtWxA/V?=
 =?us-ascii?Q?oOgh+XCKoaAh1dPTYgtNeB0ooVbSBccwWoAervFtBwWumhYRw5ZfEEh1vGBq?=
 =?us-ascii?Q?w3ER2fCA65KsFTIOi/zGAIfeS3kA60bSOJO0AcQNjOX0hEZvr77WxJlmAoEt?=
 =?us-ascii?Q?bdAKe6e5YosjTqOOjMXjsM6ZF6veK4X+SGu9hwNEZl459XrdE2oBpSb1xevi?=
 =?us-ascii?Q?6E83sL+mwv7BRzLbAkcQ4MO4uO48+W3/ifiHwlytyc0r1IrmgguoQNTIHbML?=
 =?us-ascii?Q?FwMgZJWLsrvKploiC7++6MNemUEXxCv5qXlqH0zDQHuRTO2n7fIyypUZwiB0?=
 =?us-ascii?Q?40fJY1V9u1p5L9Iyxb5HgogtmciEJ7NuCIq4tjF8GpccIiLQXMnP5M8CR4AU?=
 =?us-ascii?Q?dTFqYpBOV0nWlHm/EHQ02xo/64eHx+gYB1I40dKt5bAHratFCJKMOiIddfrm?=
 =?us-ascii?Q?uark56E/uvOgxZ8PjnmyZK4bQKuKkT6BcgdThop3nghD6zjwCW1pGf6HucpZ?=
 =?us-ascii?Q?8Mr07yK615k2LyLHw3JZvqilM4AS8qfcIei1LNXi1d2Wh0Sn7ffV/D3KD6Qb?=
 =?us-ascii?Q?17p3jkmYAYDM0gj0TRMwkzJoR7VU/bzSOS4reUdx0VcchFU8cIy0D+7welW3?=
 =?us-ascii?Q?qo/wQ0Xc1wO4lFgDGp8yprTOXmrbJA3jSEPVtf6VchE65dLO6XZEzPA+qidY?=
 =?us-ascii?Q?n5YTmQaGneMOkn1teWVdHvMIkL/vIVRgBF9ENtpS7PNbUYb3lfYkPCZ38L69?=
 =?us-ascii?Q?ORCHBawc3PSGx0SLxsjglGmxPl++gekAV+kRYZvpyKS20fIsRiLoUtKdb+X1?=
 =?us-ascii?Q?90miLEaFs2TzvJiEaH/ljqRyVMmTLZhCqdw8Z6zh59eMKNMW+qVgaq6IlNFr?=
 =?us-ascii?Q?8EXSsXhdj6/WcH8L1RusKdk5Lmgbkxhn7+I4Bq8puu8O6JOSFwnP9itECvpF?=
 =?us-ascii?Q?pm6NsCZlXlNQU9UecGD6J43kdNIa42vFedVo+SnJTyJryVLpshPmKofH0Jqb?=
 =?us-ascii?Q?bxy5IhsEEYvCA+rq2LkqdCKSt6OwXt3RqETRBYOZ48kIHWJhat05BSU=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6Iu0hBQXqs9NsxYF4rOJZ0BTLvctHGcz2Um4WfqBRydeXoc198tiVqNBEkSx?=
 =?us-ascii?Q?zkGqRM+8wJMInMWW4mXBOliECU7SewP0+VvisXnQSlHIIWmA/01KisOGY8HE?=
 =?us-ascii?Q?CnpuCtuOrkbtixi78491WQYH6eDsRUQ2Pd+ElmIlMfxZyuDW6jfrfdecS8BA?=
 =?us-ascii?Q?+mOkHEp2kkGjGNLjy87z6Z4XGd4o+5u6sc6xmgRBS86QuiyzSNZXj1eG2L/Q?=
 =?us-ascii?Q?cwrmDwwbjNqrWH6hh/T24YTtoBloML+e2NSeBf3XeAaHUdEAxY8u6btE6THm?=
 =?us-ascii?Q?32tAWg5tRsGaY27jvfOMA5BizyIkpZnXIIeckVByezqxquF67avWC2PNNJvB?=
 =?us-ascii?Q?eZgfoNO5hdh5wfrpWFdxvbVqsdLuw+/Av9Ibp/TOMz0u8nj06qsl0TpWjjFl?=
 =?us-ascii?Q?Jv+0+82N2hVSd/5MFmf4/+3lknS9cKrS2FefHHXTzgCjwelW7TYrYnSlx0WU?=
 =?us-ascii?Q?BoyYJejv5s4UNYEu/25ugYexbpk/JozcSw7N2VQ2AcDml0y9AmDPbAc6GXIy?=
 =?us-ascii?Q?SgMbIRPOesxdltGI6zTGfJ18iO/lvAknwmC2b534Bb42xEPUS7vlYGHACPrm?=
 =?us-ascii?Q?yX5USXq+6veoUaT4T9NfbhzUFh4mNO78tT7Q/JhElW0FonkX/RAPVkkiQkdt?=
 =?us-ascii?Q?MYISb80IlzEXseNcCz07cniIxVJyBdyL4lVqDPkYKK/pIoFs6qo/R6IDaqAg?=
 =?us-ascii?Q?DHtg7xmCX6ErOZaGlLgAGaWr/So/yX8TSzDd8Q9v3gow3lMyoAIJbRNKEFR7?=
 =?us-ascii?Q?GKL9DchsCtpQabybLaUg7yIg3KLkAsUAGwmo1q6S6IbpMXcqH5LV51xmXqKq?=
 =?us-ascii?Q?0MLKjwGranofyzANj35u5xKSCIVG6OxfL4raCoWnSswetiDOMOPyd0EYyhoW?=
 =?us-ascii?Q?GTl/d4nMrM/At11Je6YFOQMKTe1RMM2cS+iKRCyum/HKP4bxaNj2E+uFK1bK?=
 =?us-ascii?Q?jZEgsVJqLqeIi1SeXvxNCxLSlxduZDTTbn3Wq43yodXmvcuSpr9TbTN9GJnF?=
 =?us-ascii?Q?qFeUiI2yuKIZZir8S84747OZH1jG+6LULIYxEOaTnjSH0fJ/uXL8X5/dn325?=
 =?us-ascii?Q?OxKovGcQ4zTpdF3kSfv7M1x1iSIBmWXq5wHmYGWtW1j88P/I4yhRQWgJwvjI?=
 =?us-ascii?Q?B/QoYjiB13ZE26JWs8chM533COMykle8ugmf16aQ7zXc7I8eFhfGDq97KEKG?=
 =?us-ascii?Q?erICOK2w3iDe8/vhBbMiZK9jpUqRT4Zbe6XyHkC2XiGHELQ4Ak/T/uhEbxXk?=
 =?us-ascii?Q?Lx7de6BKOOdP9qgdIb2ips3dbw+L1ArvQoDFTnFUK3L2N2DrArhf+ZequV+F?=
 =?us-ascii?Q?3hxXoxXtad6Ho6cudVtIN/dqN+PjlO+JK8ZWVucmp8c8tUnBdWwSfZz9cjdI?=
 =?us-ascii?Q?G8b08ZL9lGYjUw5zpci1SoalSidKTHR9Q7ApKD2LtumW/pEu5Q=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43478758-ecdf-41f1-77bf-08df3438b748
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:43:51.3234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR02MB8798

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

