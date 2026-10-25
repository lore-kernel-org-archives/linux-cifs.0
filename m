Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792920777;
	b=QmtAFMUcFm+cDTRwqPOqURD5jgYi6VNe/qoVZqqpPAvFYf5EAJrhGYGUXA5AB1ryateA
	 xHh1gTkCTuzSQjO7NJ31YkdaDOdSaWwdw7PvxFwXMWO6fEQuvc//RDMk3SVObsU3MSqm/
	 /rwPzcjAAbD05oXE6zUGjviGUuHCjtRx1WSc6xDrFipmupxH1Y1S+YXTcP7Sbp5uhFK41
	 cZeu2tq5O36kVBN13nJ7yQ8Tum3K5ccwHL+A6XOUTsI0Rs3zb32CHeMFA68QuwEICCKxq
	 Z0r36O3/7e0kbshAFXxdn9VRcH6/btw8IiPHOFDjdeZYJwnOXxadX5N5e51l3Q1E75Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792920777;
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
	bh=7m5xSzmosViLQMFjrkc4xer8lbTB8Skdv1SW3+UnpJE=;
	b=ZINs7/b1sVl+vtIyXyRqp/MLb0uf3EIz7998B0rC5eixx19DtS4BVcRe9jsUGbBloSga
	 K062G5jwuo/6Ykkzh7REEG/salz5WZzxVNsSCgv/vGA6STx7buPYXZXDksKNGMD/FnAkM
	 z1BmrIh7ozpUsvxqKNpA+bK258HG7i35eQw5YV2jxl4BSHAfR+Epjr7W2Y7RmyApKXhYv
	 V7uJ8kvHNV6u/dx++Yk/5XWIrkdEyPx4ZKJBLIMUZI/JRo9bIdQ11EVbTjNFsd4heoFTr
	 qg34iFDUzKNjwsMsx8vXRkB3RaHZvlvo6Yy5OB75h5RVAqggLnBixsaVpmGGBT0W21g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=a5+NgNQQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013083.outbound.protection.outlook.com [52.103.74.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8513606A324;
	Sun, 25 Oct 2026 09:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8513606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=a5+NgNQQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSkeJu9QyoWN5xK+9xq+VJTahAKeJevj9JJUGExyZQBlbG1KJuzsvKQYurFPHRqI3GLQygAOlN4h8l3ORXcAtPiVoy7fdqv/kMCqWO5jv7lIP0P/eHOLUT25zC0fDZRLyzQWEq9SrbPBmCOWSq+ubbazL3VAxvIUg/HcSfkUDnEGaOQEOXXtlpCp3BiVzs4yrfN/IAc2TFIUsHvbc0veos2v7t+/Y/oKu83QKLxK/Yh+AqpAs+gC50qdFGNGwrflEGvPK2AczBDDu+h2QVWv5BFIS6ybcLswk9WIA9kOScVcS1IoLk43mlCADfq+dcIVott5kgyZ+B9oorXXA1Np/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7m5xSzmosViLQMFjrkc4xer8lbTB8Skdv1SW3+UnpJE=;
 b=hiRrvMoEtJAPB3Ky6EvI8AprV5Dt21CfPbqN3bYtUTuUotZ2NuTSQSQz2a+FLUjz8KwhSufSh7sPsdVbJl21iHLsZX/W3SUyNW63NnPAJo5eZk/Mt9EOLTVpNIdttelwdvngFEO45R7Vu6hzrUc7nBRUHJrAnT26kaHvdCjCiFXOG3XLokU3URAjEYJuBrhgtcF68jqcGhkkeU42ArfxtJ9U9huS7IVoVXcHJ2Owt8EhDKz4nceY12Z+ia05pMvogTdBNqHWlGmVXf91H6Bm7sLOcT45nflzD8DiE/GWNge9LdvsysupDDa0n8JEmFUmdUYC+AqIfnk5YgyjpVcnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7m5xSzmosViLQMFjrkc4xer8lbTB8Skdv1SW3+UnpJE=;
 b=a5+NgNQQIVppmBVp60mC4keZugUC/kIcrszGrVQtC8hWQiRtdbmPd986bD/C2HEnu/gongdwhz65kgIX9EvWA/MjPHafj1BHk4QCTtJ2NKEOMETpe4Vs4JJUayF3J98hxyifEJ3XjrhPNoMIkiVvFhFzXFYi+LhLx6ADlbUcuDG8SLhBY6DcAAI5i6UVni5+mJOqx8R2n+haOLqrNOHVBTTBJVaJSAnJfp3ymRtH4kj2CGpJUSufBSX/wWRkTJSpQu5OvGMWXnu9E8Ve/b8qBWuupm9H9k2uKF9aVSR0xVoiXvawmAUJNNGsGLopA/RIqsyY9JWYsjQpi1qeGTWM5A==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by TYZPR02MB6882.apcprd02.prod.outlook.com (2603:1096:405:29::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sun, 25 Oct
 2026 09:32:52 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.019; Sun, 25 Oct 2026
 09:32:52 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: fix named-pipe reply loss with small output buffers
Date: Sun, 25 Oct 2026 17:32:38 +0800
Message-ID:
 <TYZPR02MB695916EEB5AC02FE8DBC31BCE6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <TYZPR02MB6959A392E5874255DF11F655E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
References: <TYZPR02MB6959A392E5874255DF11F655E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0148.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::16) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261025093238.974165-3-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3d9a3651-98e5-4f80-ec4c-08df327af15d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5040399003|4140399003|260925184616899003|8060799015|19110799012|24121999003|22091999003|5072599009|23021999003|15080799012|24021099003|51005399006|41001999006|12091999003|40105399003|26121999007|3430499035|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H2c+gEaEoP6Lwtm2/UeZlMDq1O1x/EZ7B/52b+6CVcs3tqF8EKFab9WljbSL?=
 =?us-ascii?Q?pCLl1iUkFYG8dwRsl85UwzQXbsa/Q9sEpo/ybwWytcEMUquLtlfyICVaGfKU?=
 =?us-ascii?Q?4xL3QbNAStfbN5RZi5p6R6SPJKZ0awIP1W/2ftLWHaZD7Gi78oVMFNenremX?=
 =?us-ascii?Q?6TdF94mB95+BSmtgvpS09hLWKrC7VYpKYGdBoLuGzQIe1V/F+PLiVlNodD7p?=
 =?us-ascii?Q?mt8C0xnzKtht5zrzwBxanYzDxF85Gktf4FWwOT7bOBl+Y9CcyGpQaSDu48KM?=
 =?us-ascii?Q?mbRSQ5a+gRnd7AjYkxg9C7pvDNOVybhubY385Z9u1MYAlLqb7wWnF64o9I/f?=
 =?us-ascii?Q?WqOSLFt3YlgddEFANwoYVf2s7XDcBYA7+9oDRPPnsfCzR9Vk033NtL8ZdifS?=
 =?us-ascii?Q?c4YzyW81pEvFd+sa/cupkyuggzVFh7gQIRfsdcI/5QSRN1XxEEa2tSeGuRJ6?=
 =?us-ascii?Q?PkmCr02D/157pQ5A0RiSvrQNPkB8iYWUydSudNp2ROptKKJP2WY1UffRXDKY?=
 =?us-ascii?Q?r7JOLuZyulVvGQJ5QM1XW68qtyoy0tkyJ21ZLl2KWkKMuSAGkNjOHXVzZigX?=
 =?us-ascii?Q?nimw9N8obRk61qa8CqdXIoDviPO7rIkUsbMxMsCgibKZWGHJRXkAVhRlkXvJ?=
 =?us-ascii?Q?KMM1U6RtMYcWYNPReJrhPf+TRyfLbrCEz7aQFYJN4FjpcQTHDBOtq5hyH6SZ?=
 =?us-ascii?Q?QBoD+GfiL50cTTprJv2xYd7TQSDAi/OAodJvh7la3jf9gdv8DVkRD2NWvYrX?=
 =?us-ascii?Q?lxknUJEnimcz7qjJBmuZB+1DFU17/Thlu9F9oooIPmLek69rhTAFHO00B7Dh?=
 =?us-ascii?Q?9MZQzk6HnW3tpDsNAd93YSFJTxH6ii1Pfehzdi7X3me81GOnDHTgrbFjbwkt?=
 =?us-ascii?Q?547WTtr4eweoU7fZNRnnqKY4IKIzrpmzzdod88Ghtsb8v0yWn2CPicysEkHC?=
 =?us-ascii?Q?ZMHjieAO99JlrerIcZFraepRld+A2Gz0w8bN524XWzwynt6cgPjqNoDORU4P?=
 =?us-ascii?Q?uJpVpvxlblzehblwlUc25pMPWnHv8dlRIT3B45n1KQrLpUL8dzvabOcui/WN?=
 =?us-ascii?Q?cK2cJdCxh+d2jxdfxacEIhhneXFn8E/e3FRdqkpnFz0z0tcBV3c=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VdwvO1ymMBxtkKu9Cz137zZ5bUuPYIArjWmvXhvRDAOpkunsBzaZVKOBh3DK?=
 =?us-ascii?Q?KHHw3mX3sSCpogw0a9mrS2btW9nPgzgBj1+VijLUZC32TFmUSdcrk788/0/I?=
 =?us-ascii?Q?AoqOcu2mnbR7Z6RA/Rn5TvKmdAoqG54ozbmc6O1J1BlO4bAomY8NFEQ1wlRM?=
 =?us-ascii?Q?cVj3smk7NtfOr2/x5WVa6J9KuJyK6ODXY0h4dJ85T10lTXw66tVQasoFAU8n?=
 =?us-ascii?Q?HvT56W986m/Y51w1293XwWCaM6rlbN8MOuXtZkYskqJ5MxTb4YQ78B7foruI?=
 =?us-ascii?Q?6jbPL6G1RI6dH4Ljt/5FpS1rGgWyUVmyUx/OYxTL1XFw0XQ4F5VyYcWIbVC6?=
 =?us-ascii?Q?6+4vOqEpUCIh9BK2G3SqOUNm0ihGMCSRBBG55yK6QRQmHnHLwOCrMpBWicZz?=
 =?us-ascii?Q?tEc7Ip3obMjdC6UFYE2W7SGS0SxOX6zKyj+V5SXtbMVdNmtnnIATy2dUNXtx?=
 =?us-ascii?Q?jmU24NMwWLr2u5ZyoEyubYla2/HxGuAGLZ3BcbcYJHzLlH0Wa4TnznfpWuni?=
 =?us-ascii?Q?JJ1Yj2p7hHaLTfMbwPmqWnm6bJBL/duQXm/NI0HhxtdPY3pY2vz/X6e9z48k?=
 =?us-ascii?Q?gzx9wsS2W5n1h/AYKkMHlurChgYj23MbhV3FF931YxjPCrYzuCFSpzNoCV0Q?=
 =?us-ascii?Q?HfqCZJaLvDwd1EYhPCDwdXoNVKSUBRxyRatcPKswKArwOgCy5mV3/5hot2/z?=
 =?us-ascii?Q?gbJOATjzXEwL6jAjcg/RR/1/Fiqt81Yvxsi4FVQrgaT11CZckVG4R0LaqooG?=
 =?us-ascii?Q?nD1AGiRp30ZoknR5vMKywAdJ4gWQu0sTGz2ZvwPQbjAOh0mC7lP4mZVRku1G?=
 =?us-ascii?Q?6j/uPpt8ziqZTcV0IY9DmHeerGRpBsSKe7/Vpr6JEJIupVYuZecIXoTX0csg?=
 =?us-ascii?Q?TklIlI5z7YtglIAHXJToJRnHsugYnH2sesNh1yhaKw307WQLuNrQerEYdLd5?=
 =?us-ascii?Q?qVeBjcIR3KWdQssyuyJzxU3r1vSLM2zrF0ZUgGCnMR5SBXmiWaQ3+dUxsp6m?=
 =?us-ascii?Q?bHdWnkcDHuhdeKtQxVFMk8JvAHwXKKdT6C0WzSFj1GrPiaGL45qCoYzF+TRJ?=
 =?us-ascii?Q?37SX8UjZR0za9uGx9wRXsoiXNs40p05rPyZSwElC0JJHNAbdxZv6Ahw7Kdyg?=
 =?us-ascii?Q?CKO2AX0VyaYhGcIA9700tjuEP4sBp1rVIj3c2sAJzJ/nampoo9aoSMd/u9Vt?=
 =?us-ascii?Q?y9YrQpB/3G41h3b1dOOtfyhvlgBd/mZu/P484Ij7CeYvy8EiS7btJLmHYRo/?=
 =?us-ascii?Q?wb/MXXwDvTCFV61hxM+LbteZLboBYjPGAEAgRSrgK/FAdGoFIPat8UfNfJ5M?=
 =?us-ascii?Q?al36CNrYVGOAYCYTsXo1BmhOR2Dex0q3YZ2kIVYveVkigpnd7H83NXl8yAuI?=
 =?us-ascii?Q?4jdtI2qQv8PPlZSx1H61yfXPWih8Eu2GMWlIIgNHcuigRHw0BQgOh955tqcH?=
 =?us-ascii?Q?kqlH3KT3Q+4=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9a3651-98e5-4f80-ec4c-08df327af15d
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2026 09:32:52.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6882

FSCTL_PIPE_TRANSCEIVE copies at most MaxOutputResponse bytes from an RPC
reply and reports STATUS_BUFFER_OVERFLOW when it does not fit. It then
frees the complete IPC reply, including the bytes that were not returned.
The client cannot recover those bytes with a subsequent READ, so an RPC
call can fail even though userspace produced a complete reply. Pipe READ
also ignores the requested Length when copying an IPC reply.

In the reproduced Windows NetShareEnum case, a 2632-byte reply is limited
to 1024 bytes of SMB output. The remaining 1608 bytes are discarded
instead of being available to the follow-up READ. Increasing the
application-level enumeration budget does not change that SMB output
limit.

Keep unread reply data on the pipe and respect each operation's output
limit. Preserve it until successfully included in a response: response
preparation failures and later input must not discard output that the
client has yet to receive. Treat a failed IPC exchange as an I/O error,
rather than reporting an empty read or acknowledging a write without
an IPC reply. Additional RPC reply queueing remains userspace's
responsibility.

Keep cached bytes on failed WRITE or TRANSCEIVE requests, and consume them
only after the response is pinned successfully. Release the original reply
when drained or when its pipe is closed, logged off or disconnected.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Wang Zhaolong <wangzhaolong3@outlook.com>
---
 fs/smb/server/mgmt/user_session.c |   1 +
 fs/smb/server/mgmt/user_session.h |   3 +
 fs/smb/server/smb2pdu.c           | 164 +++++++++++++++++-------------
 3 files changed, 96 insertions(+), 72 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index cba728a77aa2..8546c7422fd5 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -279,6 +279,7 @@ static void ksmbd_session_rpc_free(struct ksmbd_session_rpc *entry)
 {
 	if (refcount_dec_and_test(&entry->refcount)) {
 		ksmbd_rpc_id_free(entry->id);
+		kvfree(entry->pending);
 		kfree(entry);
 	}
 }
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index fe9d3ef1cc80..d6d0f3616cf3 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -19,6 +19,7 @@
 #define PREAUTH_HASHVALUE_SIZE		64
 
 struct ksmbd_file_table;
+struct ksmbd_rpc_command;
 struct ksmbd_work;
 
 struct ksmbd_session_rpc {
@@ -27,6 +28,8 @@ struct ksmbd_session_rpc {
 	struct mutex		lock;
 	refcount_t		refcount;
 	bool			closed;
+	struct ksmbd_rpc_command *pending;
+	unsigned int		pending_offset;
 };
 
 struct channel {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e251edc2d1ae..866f441485fe 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8666,62 +8666,85 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
  *
  * Return:	0 on success, otherwise error
  */
+static void smb2_pipe_response_done(struct ksmbd_session_rpc *rpc,
+				    unsigned int nbytes)
+{
+	rpc->pending_offset += nbytes;
+	if (rpc->pending_offset == rpc->pending->payload_sz) {
+		kvfree(rpc->pending);
+		rpc->pending = NULL;
+		rpc->pending_offset = 0;
+	}
+}
+
 static noinline int smb2_read_pipe(struct ksmbd_work *work)
 {
-	int nbytes = 0, err;
-	u64 id;
+	unsigned int nbytes = 0, length;
 	struct ksmbd_rpc_command *rpc_resp;
 	struct ksmbd_session_rpc *rpc;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
+	void *aux_payload_buf;
+	int err;
 
 	WORK_BUFFERS(work, req, rsp);
 
-	id = req->VolatileFileId;
-
-	rpc = ksmbd_session_rpc_get(work, id);
+	rpc = ksmbd_session_rpc_get(work, req->VolatileFileId);
 	if (IS_ERR(rpc)) {
 		err = PTR_ERR(rpc);
-		rpc_resp = NULL;
 		goto out;
 	}
-	rpc_resp = ksmbd_rpc_read(work->sess, rpc);
-	if (rpc_resp) {
-		void *aux_payload_buf;
 
+	length = le32_to_cpu(req->Length);
+	if (!length)
+		goto empty;
+
+	if (!rpc->pending) {
+		rpc_resp = ksmbd_rpc_read(work->sess, rpc);
+		if (!rpc_resp) {
+			err = -EIO;
+			goto out_put;
+		}
 		if (rpc_resp->flags != KSMBD_RPC_OK) {
+			kvfree(rpc_resp);
 			err = -EINVAL;
 			goto out_put;
 		}
+		rpc->pending = rpc_resp;
+	}
 
-		aux_payload_buf =
-			kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
-				 KSMBD_DEFAULT_GFP);
-		if (!aux_payload_buf) {
-			err = -ENOMEM;
-			goto out_put;
-		}
+	rpc_resp = rpc->pending;
+	nbytes = min(length, rpc_resp->payload_sz - rpc->pending_offset);
+	if (!nbytes) {
+		smb2_pipe_response_done(rpc, 0);
+		goto empty;
+	}
 
-		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
-		if (rpc_resp->payload_sz & 7)
-			memset(aux_payload_buf + rpc_resp->payload_sz, 0,
-			       ALIGN(rpc_resp->payload_sz, 8) -
-			       rpc_resp->payload_sz);
+	aux_payload_buf = kvmalloc(ALIGN(nbytes, 8), KSMBD_DEFAULT_GFP);
+	if (!aux_payload_buf) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+	memcpy(aux_payload_buf, rpc_resp->payload + rpc->pending_offset, nbytes);
+	if (nbytes & 7)
+		memset(aux_payload_buf + nbytes, 0, ALIGN(nbytes, 8) - nbytes);
 
-		nbytes = rpc_resp->payload_sz;
-		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
-					     offsetof(struct smb2_read_rsp, Buffer),
-					     aux_payload_buf, nbytes);
-		if (err) {
-			kvfree(aux_payload_buf);
-			goto out_put;
-		}
-		kvfree(rpc_resp);
-	} else {
-		err = -EIO;
+	err = ksmbd_iov_pin_rsp_read(work, rsp,
+				     offsetof(struct smb2_read_rsp, Buffer),
+				     aux_payload_buf, nbytes);
+	if (err) {
+		kvfree(aux_payload_buf);
 		goto out_put;
 	}
+	smb2_pipe_response_done(rpc, nbytes);
+	goto done;
 
+empty:
+	err = ksmbd_iov_pin_rsp(work, rsp,
+				offsetof(struct smb2_read_rsp, Buffer));
+	if (err)
+		goto out_put;
+done:
 	rsp->StructureSize = cpu_to_le16(17);
 	rsp->DataOffset = 80;
 	rsp->Reserved = 0;
@@ -8737,7 +8760,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rsp->hdr.Status = smb2_pipe_error_status(err,
 						STATUS_UNEXPECTED_IO_ERROR);
 	smb2_set_err_rsp(work);
-	kvfree(rpc_resp);
 	return err;
 }
 
@@ -9323,7 +9345,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	if (IS_ERR(rpc)) {
 		err = PTR_ERR(rpc);
 		rsp->hdr.Status = smb2_pipe_error_status(err,
-							STATUS_INVALID_HANDLE);
+							 STATUS_INVALID_HANDLE);
 		smb2_set_err_rsp(work);
 		return err;
 	}
@@ -10727,20 +10749,25 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 	struct ksmbd_rpc_command *rpc_resp;
 	struct ksmbd_session_rpc *rpc;
 	char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
-	unsigned int nbytes;
-	int err;
+	unsigned int nbytes = 0;
+	int ret;
 
 	rpc = ksmbd_session_rpc_get(work, id);
 	if (IS_ERR(rpc)) {
-		err = PTR_ERR(rpc);
-		rsp->hdr.Status = smb2_pipe_error_status(err,
-							STATUS_INVALID_PARAMETER);
+		ret = PTR_ERR(rpc);
+		rsp->hdr.Status = smb2_pipe_error_status(ret,
+						 STATUS_INVALID_PARAMETER);
 		smb2_set_err_rsp(work);
 		return 0;
 	}
 
-	rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
-				   le32_to_cpu(req->InputCount));
+	/* Write new input without reading past an already buffered reply. */
+	if (rpc->pending)
+		rpc_resp = ksmbd_rpc_write(work->sess, rpc, data_buf,
+					   le32_to_cpu(req->InputCount));
+	else
+		rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
+					   le32_to_cpu(req->InputCount));
 	if (!rpc_resp) {
 		ksmbd_session_rpc_put(rpc);
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
@@ -10749,39 +10776,41 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 	}
 
 	if (rpc_resp->flags == KSMBD_RPC_SOME_NOT_MAPPED) {
-		/*
-		 * set STATUS_SOME_NOT_MAPPED response
-		 * for unknown domain sid.
-		 */
 		rsp->hdr.Status = STATUS_SOME_NOT_MAPPED;
 	} else if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
 		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-		goto error;
+		goto free_resp;
 	} else if (rpc_resp->flags != KSMBD_RPC_OK) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
-		goto error;
+		goto free_resp;
 	}
 
-	nbytes = rpc_resp->payload_sz;
-	if (rpc_resp->payload_sz > out_buf_len) {
-		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
-		nbytes = out_buf_len;
-	}
-
-	if (!rpc_resp->payload_sz) {
+	if (rpc->pending) {
+		kvfree(rpc_resp);
+	} else if (!rpc_resp->payload_sz) {
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
-		goto error;
+		goto free_resp;
+	} else {
+		rpc->pending = rpc_resp;
 	}
 
-	memcpy((char *)rsp->Buffer, rpc_resp->payload, nbytes);
-	err = smb2_ioctl_rsp(work, rsp, FSCTL_PIPE_TRANSCEIVE, nbytes);
+	rpc_resp = rpc->pending;
+	nbytes = rpc_resp->payload_sz - rpc->pending_offset;
+	if (nbytes > out_buf_len) {
+		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+		nbytes = out_buf_len;
+	}
+	memcpy(rsp->Buffer, rpc_resp->payload + rpc->pending_offset, nbytes);
+	ret = smb2_ioctl_rsp(work, rsp, FSCTL_PIPE_TRANSCEIVE, nbytes);
+	if (!ret)
+		smb2_pipe_response_done(rpc, nbytes);
 	ksmbd_session_rpc_put(rpc);
-	kvfree(rpc_resp);
-	return err;
+	return ret;
 
-error:
-	ksmbd_session_rpc_put(rpc);
+free_resp:
 	kvfree(rpc_resp);
+	rsp->hdr.Status = smb2_pipe_error_status(-EINVAL, rsp->hdr.Status);
+	ksmbd_session_rpc_put(rpc);
 	smb2_set_err_rsp(work);
 	return 0;
 }
@@ -11095,7 +11124,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_PIPE_TRANSCEIVE:
 		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		ret = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
-		if (ret < 0)
+		if (ret)
 			goto out;
 		return 0;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
@@ -11476,16 +11505,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		goto out;
 	}
 
-	rsp->CtlCode = cpu_to_le32(cnt_code);
-	rsp->InputCount = cpu_to_le32(0);
-	rsp->InputOffset = cpu_to_le32(112);
-	rsp->OutputOffset = cpu_to_le32(112);
-	rsp->OutputCount = cpu_to_le32(nbytes);
-	rsp->StructureSize = cpu_to_le16(49);
-	rsp->Reserved = cpu_to_le16(0);
-	rsp->Flags = cpu_to_le32(0);
-	rsp->Reserved2 = cpu_to_le32(0);
-	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_ioctl_rsp) + nbytes);
+	ret = smb2_ioctl_rsp(work, rsp, cnt_code, nbytes);
 	if (!ret)
 		return ret;
 
-- 
2.56.0

