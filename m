Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.81
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792990668;
	b=kM12vZc5YGidj2CO2gQKGk68stAfrqsv5MNg6PSifAZPT+gyoBNVWK6+f6KnAkcaYf3B
	 6Ru2+5Bsz24cPOSQQ0oJuhmjMnp2bFkjzKyVgNXI71MUo3GWKPM3RRPL0a9HowJIdr1Sa
	 Yj6mYx8U333kpfqZSEdePMDOOQQPO+jI6d9V8L5b0DIyzWRQwt4AiiYtUbP5E1LbFP/t0
	 w8AvRtVx9p5Vpz62gu3sXemxuJ7G+HwijIrZxnWIp4UxiYcM2WhRHJkPgMf4rFjTx/Z5e
	 xwd5tkmb/zEO9lrqKd4+8VmrVLQNGsWFa1GAV4d+Fo1YBRXk3pLMVN3iUGFlYWQU05Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792990668;
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
	bh=wmo/QnHskEj67HbB0iM3g0MF/kLncHH5bdanO8rg28E=;
	b=Kr2nZxPWfpEJ4mzveAPskLBlAReDTgyUQaU/4qBKv3A8EIS0paG90xxKAmYGnA1/UZAs
	 EDT9ezMbMwyTg0wIUNe28p3AvvdGUBrvnJRWYU70kZqWR/6Pq39pbG2Q+2odlTpii1z6J
	 vnoAA0FUmvMdLPCGv58ggBSBLTAtiX7vbdsghfxBHUPyZ/K/xzvd3kDjlzHC8aBdVwehR
	 CKiv+KdXv/vC0pcTAlkibS6qa8n19ch+PxZI4thppVwFfxoFYIZogFRFn/R2FyyCiG/vR
	 iED/GC6P1WAg1JJOtKXbJ6qLqQtHrYTMuC3hvYupxO5VYJh264pHVpuCMEibaYQ5/WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=SS1nczqC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.81
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013081.outbound.protection.outlook.com [52.103.74.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C08606A322;
	Mon, 26 Oct 2026 04:57:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90C08606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=SS1nczqC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykSxdRQUVBLL3VYpECbG3LQAHY14Z8AW6uXpvQC1Pxr8l1Rh5UElL5C1TRSLALrXFakzt3TyqUX0sWJZfVnhm6PCWtAUCj7xpb4lLladN8O4mXvLSNmWFQ4P3pHqwyZLEAPj0yz61uYFDqhX0nqDjLhW35wbz6z1Fup2A4b0G7P6hKwIAmbPoe+LV4ZuIAQcCTijweiTgI8Xq9jN32HVio2FF2wN6p7ImtAJJUodH7e1ZRJtZDGbR3vJyk+JnYM2B5pujWeXqg/m6EiwDiYXHF4JJ2Ax7ErXMAFCkL/NxiW4TWpAt1qglJ8AcJ/IEnlFXFl2P35w0Vax3pj+tHQyaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmo/QnHskEj67HbB0iM3g0MF/kLncHH5bdanO8rg28E=;
 b=kE772ywOHPZWE7HqAkWWuU7Owwhklz6LhNW+4DRU+8SejzPa0cuK87IKp8TnXZvdznTxx67KDWMSyXMdLK74bI/qdkh6EqvF8yUEoh5HSvq6hz68uufAtHA/67gtVo42Dr8CvBHIqN6dk5Ujpwtag7b0CfywSmDuXSReRi9U5gMX8SJsuH13Z8RMUVt1jQwKsbPP/JjqEWCNiBZEvXf8g7P8FXs7pPb6lK2HPqwIa5OkdQSJmMRuITMcNKNqAhNPQT1ERAMxw3VZj4hJdPP48CYQTbwqzbYeRObreM3ljwKNUw/Sh+Y3FaveCHylCCn9RJdulrYtaSFhhrZi6k+KZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmo/QnHskEj67HbB0iM3g0MF/kLncHH5bdanO8rg28E=;
 b=SS1nczqC1cD5MzLoUZLGkz66q+CiiDEml6hAZwgUGFuepDPpxNKQvHcqreMYEMczOiWf9jD9ycpmfwHBSPSX0VFWK4JxxHi7odoUkcpYd84Sl9VNQ1B4hvc2XYlHXR2Ptf2NjX0UjNMhc/vJkAkM8kv+0DxCVeMPNQrvGhDwlbvtBKlXkTnujZEmVReluI8UNOFVQPc7rgEMSKlThAYFR9WckNsoapXtBcUF6WvVg4yJ6+ygKTemitArZdwbnCNJl1+sLelJ17C/1m2aqPP99kpFd2XNdUi+f7czxwEVEOgvjkz6FFwevNQCVRrDzWjixVYkaydZKLYyKI8j7NS21Q==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by SEYPR02MB7297.apcprd02.prod.outlook.com (2603:1096:101:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 04:57:43 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 04:57:43 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ksmbd: fix named-pipe reply loss with small output buffers
Date: Mon, 26 Oct 2026 12:57:20 +0800
Message-ID:
 <SEYPR02MB69645211A7DA754648190967E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <SEYPR02MB6964387A0BA1542BDA560115E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
References: <SEYPR02MB6964387A0BA1542BDA560115E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0013.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::9) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026045720.1324887-3-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5beccba1-358b-44a9-6657-08df331dab6f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|5072599009|8060799015|22091999003|19110799012|24121999003|23021999003|24021099003|8022599003|41001999006|25010399006|260925184616899003|3412199025|4302099013|440099028|1602099012|12091999003|3071699003|26121999007|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0z8T318/02qwzVc1B6Cz3DShWHq/2Hj1jy8hHDDOvlIxAVmfEXHn3avMbdJy?=
 =?us-ascii?Q?P5yw+U/Q6EXOM9nHu7S0OXjh/hR3Y+GQ9umRK49VrDsVPkPt5kXTVnEfzi9g?=
 =?us-ascii?Q?msmjE2aaLWCRIX8fHsN6YHyr6AzQS355zt55jD+7Vtj0X6kEAUSVv4nJjliK?=
 =?us-ascii?Q?F4G7BxN2WPewkWnR2VnYArC7Zcbx9pt+YzDvTH+5+IVMB52oWWTLh0D9tV6Y?=
 =?us-ascii?Q?3Gqtcl8VBp5DfmK0sdZ67KBOIiuZzQ95tyUYrnLJ57lr8WBysIZcLOsY01va?=
 =?us-ascii?Q?KN2PZutddjnyYc+7j6855+xPNjweUr5kj9tqCdTTyikVOcowAoZqZ0VqlqxV?=
 =?us-ascii?Q?BK+Na+4dQv4w2Z5sHzrzKhrQnVTrw2pNG40/WukiTMQ5X7LmZppPbiSIHfRm?=
 =?us-ascii?Q?9Vc2uYWlm0C3TqDOw/roI/XyLnaNrbM/6Sgg3kfoTUh3kdOkXbFIU0r+qs0y?=
 =?us-ascii?Q?KJQ6c0ab2ba1djEVPxkCjSmA+QSKFXgJn+h/+UauUZ7scNQUh5Qf2Khd1WDE?=
 =?us-ascii?Q?broxMnxaZQ0QvxpCvaV/0Q2yieEUVHshoqK27yKWsiYkQvB9pcqWu4z7e0/G?=
 =?us-ascii?Q?dM7uDYYocEIXLkQlNba7ndK7Jvvy0QGS+qh5jJhZabu3YLT35wt287QWyUkL?=
 =?us-ascii?Q?QnYhsnJVjhxN/0pvfnd31y+0xvAR1jIe0k6slp/yLdden2IDpilkDb7CFeML?=
 =?us-ascii?Q?agFe2OLIl+HyjLJB8mkPGV7yoJXm7cE+DW6ASjBGm6JaYNK7kGPdoZr/qvv6?=
 =?us-ascii?Q?Pr12JDUyqs1bGhpVgP8v014uaP7hsRLvZnnXvTthBEltfagF4SYU9VQByFjh?=
 =?us-ascii?Q?N4ec7yDxipRrAwma/8SFkBpViAbFJlah6TXT0VOPpzjAQIIu64fofRgzkimC?=
 =?us-ascii?Q?/xODhmRobLxVg32LmKAd7UyEuwcPCib7AUkn+YCxZPWxk0h/z4ifdOBBFdsz?=
 =?us-ascii?Q?z+l7VSbc9RoSSLjVViplm6E+P27oRM6Hrbvn+xn9u4HJ1D50fS6ewVc+P8L1?=
 =?us-ascii?Q?rh8fgMAujYGqmOgzPvfslnbjV8ADi9rOXbNbRs6sP8PS0NeTMOlvXnUXM1KN?=
 =?us-ascii?Q?5Lxslcp2Ki2hi54Nm5yXSmrK6a50Tf3FtbFh9gPWuein+J75MTcRyRUjRaFE?=
 =?us-ascii?Q?4d38H35wE2tb?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x/4rJ5WddSmHAJAWZFRRnr4uGetomZL2TKW3YibATuRSiVobzeI3z3sqOUa5?=
 =?us-ascii?Q?6hIYqj3Mhs4kx3vQj6sbWm63IP85arYNs55Z2oYvXfobMNoE4BltpISfLIww?=
 =?us-ascii?Q?oLuaRjGGaBxgk26qTtR443QE8CRT7ZMjztTDq5MNIN62KViVBMm4yDFoZR10?=
 =?us-ascii?Q?l9mdTKSKoYjofu3QAMFp2A10xq5XACmdFehI9vbbERzyrgHHOqWv2L0nPhAh?=
 =?us-ascii?Q?6c3+pbgGQogPPeIyRRfkqYBuWmsT34a+G8sxNHhEGM3kogdnRgq+CETSL0yx?=
 =?us-ascii?Q?SYZC3PEdYJbbAwW7P77GRZ9w3N7ngAgfjJKUXKWgfFZ2WJ0j6MH1GlsiXlHH?=
 =?us-ascii?Q?k3hVzBigYUljGdaQK73kg5FHB3WzFCBbKFnWiFAbns+JEGx4qOa17Ozks/lv?=
 =?us-ascii?Q?+kVkVNvxxKrOXO8075HfUKCSzB8TrAthc+GbOSyiVZs0ykXNZPDRuPwyATRE?=
 =?us-ascii?Q?qxNW6gdo1Kc4uMUIaiT9KajDY72ec3kvsCC+0bP85eKVjJrDivc1H4FGmr+T?=
 =?us-ascii?Q?I8nf/qPU4mDoZF60lC0jBamKE9BQ50A9RmAbrNLJvK395AekkBHz1dY8ETvD?=
 =?us-ascii?Q?aBqksuyKUJzC3eq2DDKVVI6WqRY8S6FFqRz5M+NKKyyCfJBmsADjjL5oPas8?=
 =?us-ascii?Q?Zsd1R7nzyZHODxGpKemSakZfSVPUFvQY6QXNdss6PZz2U4ntvRA/V/spnMMn?=
 =?us-ascii?Q?RUKE0p5XVYNs5/kDZqjuJvN16r9CsvJTAz9SQ/HA9h5eMkBCEy/NE5t/UgYi?=
 =?us-ascii?Q?aoOnSCvdpJiweFUAAfMQNkpCnoQm6x6Qvs++CxgsDY9iVw/QSk7oTKzrziwb?=
 =?us-ascii?Q?MAYKWbbl9MPvqrJQaPa2Bn1SVXOc+c4RpzFob+Sxdasf0kH5SErq95LYhkM1?=
 =?us-ascii?Q?MNcFFxsPSITFr2NxW5O7cvLVoFRRwu0l9HMOHFyWSTdwHcKxIE0ERfWTVIzI?=
 =?us-ascii?Q?mhnuCZ0jnGOj9rYmMhFTduuLLpP13nCqNDGTptdTu7IoLXto/8vy2cwu0hsN?=
 =?us-ascii?Q?vWcuZmWV1awrDliMTaentMirFAnnuIM9dax691mH5sFBRwcaTE2RQVT/6kOf?=
 =?us-ascii?Q?dgWH6ASX1gBcdLRm5lKIybQu82yPlih8QbywbFZY6lfehGF3Z6kP5fM9OZsJ?=
 =?us-ascii?Q?K61/a0xg76VL+JVRUBlQCTBXe9NoUSTfYL9Y+vF0zXvthDpQ6RgWCddJToFK?=
 =?us-ascii?Q?lvWIoLf6dgQeAwxDaG7d7aaVMkhwOP2nRKKe+DCzqfEfW8fDro/1km5xwgkO?=
 =?us-ascii?Q?jwIb5a0X+1fKNcDJy0NXLu/bpDyBzXtAjXBNATx79Z3bfR/onKu28s6uvZV3?=
 =?us-ascii?Q?VE7ckDFN3wva0LzqFk6Kb90x3YkjOptqsySc7F6Iqgwof4oHV46iP/9Zfy3f?=
 =?us-ascii?Q?jFNHtBHyoT6gLWxBTLUepGUFHdCTMj/4127HxkZX9dSiBGmL2JoFgz8Rd2/f?=
 =?us-ascii?Q?3MGS03iCAWc=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5beccba1-358b-44a9-6657-08df331dab6f
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 04:57:43.4876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7297

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
Link: https://bugzilla.kernel.org/show_bug.cgi?id=222196
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610260610.5prVfJss-lkp@intel.com/
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
index e251edc2d1ae..4037c1110c42 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8660,6 +8660,17 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
 	}
 }
 
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
 /**
  * smb2_read_pipe() - handler for smb2 read from IPC pipe
  * @work:	smb work containing read IPC pipe command buffer
@@ -8668,60 +8679,72 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
  */
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
 
