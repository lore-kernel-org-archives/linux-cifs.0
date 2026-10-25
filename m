Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792920775;
	b=JzVH0Rh7fniERSb0i/O4oUewuGdDcFg5naJR2OlRQpAu10Ku+ttmFL3cmLQfkkia8urW
	 FfaY8JGlgXXAuTao2m6qbS/fOx1HZX/nZKwsVZ1649zq2utLr1RCeXCI326eVFNIcoitG
	 KyPIYry9l6pkVHs0NLxwUtEvRPKQTboSuRWh+934VgTptmgDm1Z8yqoh+4dA8TCLDg98a
	 nakf0FeZmZ4kDWL3rgGt2koL6uOCnitYOs21IZdFgbk6cc7FmjiYQWnJ8j2fDzHOAjqo0
	 6Tf0KssjBUfWayynt97UAoXJGKACvQSUWAFDj8zuXhVOZ5aTsp9Tcws7wCUhJtZgEBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792920775;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:X-Microsoft-Original-Message-ID:MIME-Version:
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
	bh=zkoIdxGP3UI/QKKMwcn8Y2K/N9XWt//Z0JjAg9OdWPs=;
	b=FGaTKRKYwxxwvCQEjnGlc7fTFuPRxC9tl+RKkVWKDzEJVjWgQ2xn1eecQTcx1tlmegCF
	 6cRMbNHiV2J+9s6tftnu5vqwYmuYvPHkHXtAPnWW/iXDL2qdU95ENXGBpa0nEWKFqZdCh
	 EqFsnGxaGXo+Jo7jdUZRpyZmPw4ZfWzqHuFAXjZQygKyoNXLb+CcmdPBj91oAMwdzXngo
	 drKPgfNDfyxbeM5zYDvmFOCOQj8sJjjbOaMmQO8v5WRpJNH1BpDKJSRHs/Z6ZRMWlYJ6W
	 MXO3R3vAKp4QDgwZe0txcCDK8xNSVdnKtdd5LQNnBqSaQcK71gEna4NZH8NbbCpZnFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=EbFwLIUX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.83
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013083.outbound.protection.outlook.com [52.103.74.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF038606A31A;
	Sun, 25 Oct 2026 09:32:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF038606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=EbFwLIUX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1abin3dSThM2POFxJJYCiqh+MusDhtN9oJQrIjjNrhUyXsuMk7Ezlnn+aIiKPK12/OlROpXEE55NwYux4ddKi23v1wj2pQ+FJPZ7c14QdcrACkye44FsxRqjHz125vKuGmPQJtGl7GxaJRDx+wiTI88L6Ymy9kdUD/JjVaXt+wIcrGe7/oLpeDPLVH2PakagMnI2DHefBKea87qDTfSMr+DlY5KMX1/scGMVj/Z6/7Q7z9WOrzOA9oFWxuY0leCZkjRKfj8nKJKamyKww1nV3gT4J1oOjcgM8AZ10EZgb/skffY1nPqXkQscMYpaxcdVz/5+sGK2OD0SuJrDyWxGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkoIdxGP3UI/QKKMwcn8Y2K/N9XWt//Z0JjAg9OdWPs=;
 b=GtAPR24beYLLkYOg6cPeB2sjZDv1nes1A7QKEN51A0uXsfJk4eJkd8FCvuuVoVGV9ZQ4c2hjN1LzAE7/3RlfAooCK3FVMtQh+FBScVsOWlqUyaQnnzmXgLUZTgP8tXKYTbU5BOPu4P6ax/k7G3Gi2Gbd8odWpysnjjGEMfllEdPbF1VjnE05oUtbwctucQzEaGcGb6enkplhACvn3mfIHGzS1e/kLHpYcLuWtrbalqHPg3wXfZvm3mdCJECi5qQM+yIRJavVNqpZvO6osfDYvCsefeBR21a6/N+L9A4AjiSeiKYXi+iKr5HgQRXkhWlN8xEKExv7tEBYP9m9gceVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkoIdxGP3UI/QKKMwcn8Y2K/N9XWt//Z0JjAg9OdWPs=;
 b=EbFwLIUX3SQfwHAn9Tp7Pem4dJUD6MNbUSNsNBTM3hgZSKCKXDD7nBmM3iFoLdM3GsZDLZzIzz++DCISll9WpxTW1rEJA/CmL1PQiQWLMKD1pBdkkCp51hm2/i8RwCrRm878XdUObo/ulbJWM8TNxQjjX4SrmvYCJvou4gVTf/9BcJw7mzgf4dzw57KQXmvumYfZGQa5JfIhyYtwgabM3TX+xGpRbzLpzMEXjI76XGhMHue8gU1i5meMAifw+JDxSuqM+y69YME7LctZBBmC8ZFtcXRPtdbVSWd29gKUmGffMaY0pOn576YfU57IfHFs4TrUc0IYOKUnyzlLmnuYew==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by TYZPR02MB6882.apcprd02.prod.outlook.com (2603:1096:405:29::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sun, 25 Oct
 2026 09:32:51 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.019; Sun, 25 Oct 2026
 09:32:50 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ksmbd: fix named-pipe reply loss and operation races
Date: Sun, 25 Oct 2026 17:32:36 +0800
Message-ID:
 <TYZPR02MB6959A392E5874255DF11F655E6622@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0148.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::16) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261025093238.974165-1-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 395869a7-cc99-42a8-7072-08df327af00d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5040399003|4140399003|260925184616899003|8060799015|19110799012|24121999003|22091999003|5072599009|23021999003|15080799012|24021099003|51005399006|41001999006|40105399003|26121999007|3430499035|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DW39dH0rHwcUBkd0P4+j7gfLRxVeni3V7KD/l/YGKFwxhMySkuwD/1yvMB2O?=
 =?us-ascii?Q?3E5x7gC/l5FgjmGsmsj3FEyXvc2bQ6aQhFRbJ/b0VAYwh6VqBOtBieCq9XLt?=
 =?us-ascii?Q?DQLiH/l/cX6W+Zm06NRFKQ/12T3VJ8clBKA6RQ2bGjNIOH2xycWfqtM0JoZN?=
 =?us-ascii?Q?O9JBzBvotfifTW/KYZWntzQTXdEM0TgMy8VW+Ppk8eFx5TNLRQ3DXWd814AN?=
 =?us-ascii?Q?8B6HjoCx2FfeRn7aMwj7nbrLuqsEdDqjdKEjbQbZoHSf1WnkBYOIoR9seq50?=
 =?us-ascii?Q?RVh6T6NL7I1mxtsjjnbdjgFlLkvEzWbc7gc61tRSDyMa4tMcXHnCDTNi2Oiv?=
 =?us-ascii?Q?EVSuQzTQqP5gYbUwmy6VmHAd9epEKx745cSn/yS2wwyRXAOEl/3TeefERtQ1?=
 =?us-ascii?Q?Glf75tu0jIdQTmhx2s3O3iX5l7YGUi0YI8tiTIYpcYrhbvQX+O979kGInhiH?=
 =?us-ascii?Q?QKlQKUyAN9EGXbsbbu2+5hkxTXbO8ErcR51HkH5QYPPVpfP6ygt8ztKQTfbf?=
 =?us-ascii?Q?HOuON4ggspvI5dNfmj435Mzsz07ENhlso4FQeVniI8UBC2iPT+DajZ0sRvKy?=
 =?us-ascii?Q?dad0jBcHme9qDBMpvDe6nFs2VrttjKElVo/RIGr54exJEmt2ljN2+8pZ6QvZ?=
 =?us-ascii?Q?I6uui6e65kHhuOP0keLQNu44G/yh45rv6sKeG5UwyrXjEmv14HUHv6p6c1rq?=
 =?us-ascii?Q?44dyDyRKWRxS53cI4EszCrxtcG+9c5JBaAuzNlUHZeSikkCkjxfxB6qR7ol3?=
 =?us-ascii?Q?2yGZh2lY96cDgWzsQf2zJlxSIrQr7c/tY6U2NgfWiKrRzqEPO7i3g0L5amXO?=
 =?us-ascii?Q?+HR8Q0PdMb7/rcpWErDqXI6y3TcDKxM0FhWUBdS0C/jOo91zkRW/e8sFLkyU?=
 =?us-ascii?Q?40/P83RyKoqVyAHM5bH5ejLNWQhVaqVm71Jq/oUFgtm+/Iw/cRoS5YmY1Xds?=
 =?us-ascii?Q?CoMZHuvHAMPkcRgAcxQsjWbs1VgbwH6OCVJ1b3yx1pBkDe+vr1UcubXIRnWR?=
 =?us-ascii?Q?k0iWVw4FG+gBTPS5pKx51Z06Ee/D+8/oqcaVO7EvRre4sH8SUAO/qbtKGQFk?=
 =?us-ascii?Q?4xXlEfzP?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5D0doAgtfMmev5FKgZZDb2Y+tUnroaKFTQ2n5TTJKmSd0mA1kEInLizWiEmv?=
 =?us-ascii?Q?uP1t67+JHDJ7MIHcvW6MqTylDBbv+97ZMB1VqEn55gQjAwRUDlApTsTYHGsI?=
 =?us-ascii?Q?In24Clwp4Simpb6hJBPjapzjMBt6Ow0bW4BmDA3HljpP1KV3xHejoyuEd30C?=
 =?us-ascii?Q?vOa+A+KVuh9srgTrSWhg6QD/fJamNPyg65D/RibrQ8NbXaSwK7XwdjG8iAoe?=
 =?us-ascii?Q?0MeKQ33pRG5dFVgL2/OD4UjMqzmX+b7yrb9bXXuCTJNHiUOem0KevnRmOdiv?=
 =?us-ascii?Q?0BTY7sv244/2kw7+KU211264wcVK4f5N+FGDIKcMmR+/G0lhL3aalvMoIemO?=
 =?us-ascii?Q?EGKq0ZR0XBaH1A7neGtepBYtndjyVL7rPCmFQp7uOKr3KFQGof08FpkEnnPn?=
 =?us-ascii?Q?gSlkB4yj6tMtGPJI5jMeMiAOsA7Z4v7inAIbxwH2Y1Y0QgmozxbgOwujrrVm?=
 =?us-ascii?Q?9E8a69qBW1euh38aM0d+GPjmO7s/LmbogF68yiRKQinKyxgIpYmbxZsQh5NX?=
 =?us-ascii?Q?L99QAeauwK9ZvAhS/GQHVNWVBwaIsgB91SYZJvHuu0DZ59DHaR940mj7PSLM?=
 =?us-ascii?Q?5U0f6vO+fH5W+OriTsSUI3bg2FFC8sBLCt+TtkbhVBZyLpS7gtwGPHu5y4xZ?=
 =?us-ascii?Q?55fP+U0K1JuF+h/B8180oWwiYFE81Gv71bgHSKp1ndtIXb1pnlLuZUWozwAF?=
 =?us-ascii?Q?/zk1I+S7YCwlZA1HyK6CepdmxykFuSpZFc/W2NJHg1vGFix1WS8zMOKYmxLo?=
 =?us-ascii?Q?LaDAAkEaeKn5ynq3IcmZlLKzdELvzWwIQOhe3d7TQ7toITnxCnwcgwzGwPw6?=
 =?us-ascii?Q?Him653AIurcD0hx5pZc9aM8O+N2691f0wmpyvtU9C7ML4gXCaRFf5MJHRBYW?=
 =?us-ascii?Q?R8vhMflvQ7iAQdOrl3yRL8v21+4rvdRmEtJfItJwQXKlmNt1TN3JGNf+8Y3O?=
 =?us-ascii?Q?mjiTc4tpfVYH7K9cu9DSNFmh5IUYxmHdLwAV907kS9bHX1qE4MgeyeUuULqk?=
 =?us-ascii?Q?2oGDTvEyQWR4e5+wB43cwSQQu68uqybTroK4k4atwvTtdoirUwux1DWPBnL0?=
 =?us-ascii?Q?truGiYbLZZ9ux3/ozKPkKfDA6z0xo/tKtXCXzhQ2kZogLcQYjbYT29CCFfgG?=
 =?us-ascii?Q?2GG80o9ReVWeNq1sV6I9pgYIu0AwXjMS/g3ww/ppuj9sI/IgUOQC33nwsNqL?=
 =?us-ascii?Q?tPdBoVngXxEtvTU08BQvzXpbMzGWz+VPghijjsfI/ybH5gcZSEcHlKxPQTzX?=
 =?us-ascii?Q?4NBQEDT+dXnEUec5y33ZiDYRoGgwJesSUurMXkeFpFV7lPj92DH8ryStCaxr?=
 =?us-ascii?Q?mlXKtO4sb/m4n1Qos9Y0od2tXpfLzvQ8SmefwJPrqyKIoJYh7ZspJX2vK6Vr?=
 =?us-ascii?Q?/xJW7ejmTmEnl0iQNXobd92lb3Z9sdRWO85V/965vhstya9j34UY60N+047T?=
 =?us-ascii?Q?caLwpgbT4V0=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395869a7-cc99-42a8-7072-08df327af00d
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2026 09:32:50.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6882

This series fixes two related problems in the ksmbd SMB2 named-pipe
implementation.

The first problem is that RPC IPC replies are matched only by the pipe
handle. READ, WRITE, FSCTL_PIPE_TRANSCEIVE and CLOSE on one pipe all use
that handle, and the session RPC lock is dropped before an IPC request
waits for its reply. There is no separate IPC correlation ID, so two
operations can overlap and interfere with reply delivery. CLOSE can also
release the handle while an earlier operation is still in flight.
Protecting only the handle table is not enough: an active pipe needs
per-pipe serialization and lifetime.

Patch 1 serializes operations per pipe, keeps the pipe state and handle
alive until all users finish, and rechecks cancellation, connection
release and session teardown after taking the pipe lock. It erases a
closed pipe before waiting for its active operation and releases the
handle id only after the last user. Session logoff now clears the RPC
pipe list after the other requests have drained. Failed pipe operations
use standard SMB2 error replies while preserving the selected status.

The second problem is reply loss with small output buffers.
FSCTL_PIPE_TRANSCEIVE copies at most MaxOutputResponse bytes and returns
STATUS_BUFFER_OVERFLOW when the RPC reply is larger, but then frees the
whole IPC reply. The unread bytes are no longer available to a follow-up
READ, so the RPC call can fail even though userspace produced a complete
reply. READ also ignores the requested Length when copying an IPC reply.

Patch 2 builds on the per-pipe lifetime from patch 1 and keeps the
original reply allocation and an offset on the pipe.
READ and TRANSCEIVE consume only the bytes that fit and retain the rest.
The retained reply is freed only when drained, or when the pipe is
closed, logged off or disconnected. A failed response preparation or
input request does not discard output the client has not received. An
IPC failure is reported as an I/O error instead of an empty read or a
successful write without a reply. No kernel RPC queue is added;
additional reply queueing remains userspace's responsibility.

Reproduction:

- A reproduced NetShareEnum case produced a 2632-byte RPC reply. With a
  1024-byte MaxOutputResponse the baseline returned 1024 bytes and
  discarded the remaining 1608 bytes; a follow-up READ returned
  STATUS_UNEXPECTED_IO_ERROR. With a 512-byte output limit, 2120 bytes
  were lost.
- The same overlap/close sequence was exercised with READ, WRITE and
  TRANSCEIVE on one handle, including CANCEL and LOGOFF.

Wang Zhaolong (2):
  ksmbd: avoid races between named-pipe operations
  ksmbd: fix named-pipe reply loss with small output buffers

 fs/smb/server/mgmt/user_session.c | 127 +++++++++-----
 fs/smb/server/mgmt/user_session.h |  18 ++
 fs/smb/server/smb2pdu.c           | 283 ++++++++++++++++++++----------
 fs/smb/server/transport_ipc.c     |  45 +++--
 fs/smb/server/transport_ipc.h     |  14 +-
 5 files changed, 323 insertions(+), 164 deletions(-)


base-commit: f47d223627f80cb7a1eb14c585fe6cb35de5e984
-- 
2.56.0

