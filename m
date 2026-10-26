Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.80
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792990664;
	b=lGd1pYZxDKkyenV+ji0yL5gvRYHHsC4D+xtr7gzEz/kvxl3K5UNcs2qkW4aZkVyyYNAm
	 5g/r0xHRS+FTvTbuJruMS4F52H72erucvNccurvuQD20PZegVERVvGZwHBRupkc5xohH8
	 +HsX8aAIV62NtPso4Z7Gou+t0ZlUYLRu/zPZikK8FtLhkQwfRWiwTNrDCRTzbwy8icZno
	 hGaHdBEJGZbULfyfLbps87ynme0UjUqx4pGi+T6kOul4XCjedWBwO74dGqmcFYZ7JgS/5
	 M/BPhhURodv9jMnByfjxVgDraQmlOx5pEZFCvsNV5GP9Myor/fhBoEmsXQuQxc2N+nQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792990664;
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
	bh=5LQ5sf1pWzZUr/GHEru0oSZ8PONAKL82zGTW3RV7vnQ=;
	b=wMTCsTtQpstEHGclrhlxRsWwF2x8QA94fYWgdS4rmZ5ekFsvMwPItBu4WSn58wqzUJZq
	 ONnL982LIPYlRHPqGDsPd5VuldqEkUSVwuQVIGnBsYuW/7um35DN5eeoUR/vd+0NyAU0L
	 KBQcHwwNmaiu+6heRwdFczKqigGgVnQmdWl2JGIZBvnStK5fpObjP20Qx/SxE+IszkTSX
	 e8WeZpmPktQQSRYOnA1IVu10QNQAuGQvPymX6POt+Iuq2Oy3Js4J8tOVKJ/gAgyczKane
	 9Jj1Z+CTFIdqJNSE5W1U+AIny8D4W2b5VeeYSwEvR/O1mkuhR3Ky3upRl0KXM1m2nYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b="H5/E2adX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.80
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013080.outbound.protection.outlook.com [52.103.43.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A45606A31A;
	Mon, 26 Oct 2026 04:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19A45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=H5/E2adX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nd1+PvpuG6Ie/vPY43RjxS8v72i0NO4fIerh1edA04XBorTc5eME4chBhRFeJQYbWb2GoCzMlN0fE66zLO7D89oezDL7Cey4+sg73AWTqPvs2JAZ96mllW9Lv791fEMId19ddBXqucJUQpdrdVysncTAdUoJsvWlbhaRcHyLozMBadim5UE5Ef65vw9CnBcGUSZ7XZxKy2l0h1nPBH9QiSflijMkBlc5as1KPuc17m2GjFbq24vBaE+vAEJPSnUktpxNRO/x+YDr344JE7fXRMHPndPOFhNEKn6zfumgwuN3QSIDShSbWeL+wS6Xqsm+kPOT7mMr7uO/02fDvzyaKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LQ5sf1pWzZUr/GHEru0oSZ8PONAKL82zGTW3RV7vnQ=;
 b=p5VRX3zg7pmR4u+r/QuBOxzO7lbhOwOrWcT+mHJs+7NiehEIUZrOkapOAGaZD1PNuiAp5QxbMdreMS+XATCde7Yee04431F5KJpwRodG5t5CAKcEGaPBxtwtJ/oAZtbmtVIIwkt8OCZCnWSGBJBmnJJzXTWo0aUHtzUKFKAIgHnj8gRl9z9N7J2avYPxLqEguvoLKuyMWzdx4ccTyoJciNusVrpnQzY3ebtFv96LnvqnA7DSTU+PSzBtiYwc3WjEjZzn9da16ZRNq5l/QBoL+2rzRgAk+LYs1m4fiWTTRhHQaOXcfJ3CnJYm1SAL1ngUnH9X94Qz16zUp4Bs2wDgqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LQ5sf1pWzZUr/GHEru0oSZ8PONAKL82zGTW3RV7vnQ=;
 b=H5/E2adXMT/E8N9JZw1tJX4eeG7Nk+DDbERJe6dbARcpBVg3Wa1bBxnQJqx6MT9cj8thCJtXZVn/6iiU9ZQ5LUfZCd5OW4BHeIQlWCICJhJ2G5fNxE/hA5HvDpLaUsjRQWXZrWHzfc+evTCWx/Y+kWAc9vE22bl9nZbZ/xILttVe197oogLrhFAxMCtChL5V0CP3ZnSZnW622Nl2/W/35dsLlIZ14uxgugJrSHfd1nZOaK5IUptRWtJXn6889t0pYiSvQfkNbS6jHo95kHjGy5gaBgti/gIIsqiBIdKany63oemnBDDr+kir3vokWEsQiB2nCeATO2kiHuKAntidOw==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by SEYPR02MB7297.apcprd02.prod.outlook.com (2603:1096:101:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 04:57:40 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 04:57:40 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ksmbd: fix named-pipe reply loss and operation races
Date: Mon, 26 Oct 2026 12:57:18 +0800
Message-ID:
 <SEYPR02MB6964387A0BA1542BDA560115E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0013.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::9) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026045720.1324887-1-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1ded32a2-cf05-4ed1-eeb1-08df331da917
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|5072599009|8060799015|22091999003|19110799012|24121999003|23021999003|24021099003|8022599003|41001999006|25010399006|260925184616899003|3412199025|440099028|3071699003|26121999007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9wam54RoKOUy0LpWFybmDwRScDXFAQzSMpXEIPpTDMT7a2WYl6GTl3CR4juh?=
 =?us-ascii?Q?+zMDQlSXZ81EHLElvvCtNE78Kt/kgCTKFJnZlaA3p75ao5xdcTp0kxBCJueF?=
 =?us-ascii?Q?RmKbVvuU1Np1/9bPKeXfswxnlpPFTSZ24E/KjhyBXo+eZsNSiE7QG6RJ7KoT?=
 =?us-ascii?Q?Izc6M6KHfU5YuNBDLQd70jCM694jJcxM/JoX5uciHWu9/vdLLpbCSmv+bAqk?=
 =?us-ascii?Q?nmOgh2FEHWH7e6WX4Bx9+qUxMCJATI8+3NMXLRCl+X6KsL4z0AO6qdtE1ezI?=
 =?us-ascii?Q?t4rTX/XDonzmvbs8oUyMItG7yNlm8TfhILBwuqgk6/r9JpBojK5017vqSnTF?=
 =?us-ascii?Q?FO31ZjSLHPx0vtKXRPmtE1urAKDEVCY2wn/12A/sMl2FzRbMWsqcySmQR4Om?=
 =?us-ascii?Q?4fd8emn2mH1JDvzv6HrFARtLEWqTUKdOCJUUKH5BiJyIAx6h2jb4tAQ1cD+v?=
 =?us-ascii?Q?t7aXMRqSdcK2FqsYvbEaQkzLXJUC1WJ7DKsaRPyFTji084aGpUVZQHQm2dKg?=
 =?us-ascii?Q?6vC1Fp1/LxNQFkKAYhBe3veGt+EOVXDebt0iM2T/mMkhEu+L2n+3wPmSQxLw?=
 =?us-ascii?Q?293hJXMSDIQW99U538ZQ8SwuzyxMV4yaCgPgZ1/PktvgxTs+ckwD9Y5vnNfx?=
 =?us-ascii?Q?yWKzcRDpRouPQKsRA0yl/DVVuPhmN7dp9J4Kts1dm8dUBaUCGHYmge0aVlLG?=
 =?us-ascii?Q?HVz19/0Ps73DLIUhzJRSzI8sU57GWaOFzcDo5etjFo5KlfG4WRDBZZYnwhDc?=
 =?us-ascii?Q?CyORWtN0GY1fX1VHbKx668QpSEopPqCEx7NGMkwGXq8EHeUPPXPVQ6haAsPY?=
 =?us-ascii?Q?hoJu8TFNCUmozSDw1wOEs3/u4Rq0nBAjG6z77TqQTWRujT0NXmhU/dM8hKvx?=
 =?us-ascii?Q?cY8kbeBRSj3hyTHIsq63Yu5SiBSXR6VBAVYbH6+3Qo6wRI8FmbLfoud1q/Sg?=
 =?us-ascii?Q?oTC0gL4W2xKCUd+oiSeEAgKRi4gmQwtDqM75gTPPlZ0nBwPvrszD/w9Ij7D/?=
 =?us-ascii?Q?wfp7lw6FfwrgQpaGMXTEvQWO7TzmsSmt+EHvLBR5Oh405sNYrnWPWmNTPz6/?=
 =?us-ascii?Q?oSl5LGgd?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ErtoM+XNV6BNBfnQuGD+0Oq3TLhgDs0m51t/iqGmFz24/DgfPf0Fs0MQmYFf?=
 =?us-ascii?Q?Vi9oJX15yBzmAlmsQQG1fD13PSHImMY0Yq9mfmQ5mEtDUo+1TNBOxJGxwmPi?=
 =?us-ascii?Q?sLcdZZNl6mDLVnto+J3PnTOTvy46VUYd0TK06Dp4g0C/SX3BYhUfV8w8yUGH?=
 =?us-ascii?Q?JG4x7XbaaVRbAxhBbUQR0YObguPzHQJwpiFnhYTQNAzOL+5HX24get5dTXr8?=
 =?us-ascii?Q?jfNAVUYw6nbwXWQHPiWBRijPzZLDwHfHUBm/ylu1NrJQLOQniUCqGGJLzzQf?=
 =?us-ascii?Q?t0YAYA1aIas2gVDhhsXOyZpfsC64CTjdMVCfBtroTvCw7ayYFPdrZf8ke0xh?=
 =?us-ascii?Q?e1EPw/rjIjPFgLHgvwXuLkx0VTzSDkjRsOZpRgdcAgmtB1HtsZ+k2z3XvSMK?=
 =?us-ascii?Q?gWigXarddpqwx///D2ZVKC34fegseF/k8/4oPt+obOA4/zuZdbbnmpe1fD8F?=
 =?us-ascii?Q?U+gEBo3uxthIwIeT4Y0oEHOmqkbSoy5fkeAhKugoDlB2lwesko6uwVGLVlJ3?=
 =?us-ascii?Q?fAxd5aHGYB0h/gsJSl9aA9sFdgDm5s7TZ9N7PAQHr35EyrSgphEYrA7pQ6ZA?=
 =?us-ascii?Q?g0yHDWTMIBdVJakd8zqf0Z59rkam4oJnvCKTENtx0WZVbHy6yJtrzebZFBTy?=
 =?us-ascii?Q?9ZIef3kzUqUYbcYQLmHCaDAlNDT1b/0x1j4Y44c0NFi1YIb6YMEyVjUz3PID?=
 =?us-ascii?Q?seyClc9nJDzOAXLvwSjpn3C5NXtyUXgQObO4EzernCiYgydZW180Yg2NJi1N?=
 =?us-ascii?Q?F3bt6W3oxpM9vSD5ecXm8WcFtpn6q0kQfbwFAzeNgQN895ZoNqDXaglqDPqt?=
 =?us-ascii?Q?zMTCS+BWc554sI28yu8AsWztyKLPqoqTzZf+SDk38E8Z1JWsbfiFrnB4cwq2?=
 =?us-ascii?Q?4TTaJWA4NZU67a1hHpTnqhyFZ64KFti7YUD1qxDdezezF29rhtU7i4SBEM/+?=
 =?us-ascii?Q?j6PBF229DvkPzLmkIjFKX229URx3wNmtVoDjTgxucgpD/qTTX3EverQ1J9q1?=
 =?us-ascii?Q?wAIKmb1i5tGuaxz4bIJQj+/VlbTkvZwxZwCSeca7IejE/vodNh+ZSA9gv9wf?=
 =?us-ascii?Q?rsRJ2WNHY26TnErM/1XZpOFXNkOsCBh6NTwftd7awIIgpMG12QbjJvF8jrdG?=
 =?us-ascii?Q?tJ7WhlinO5slN3fXN45mhBta92E9eYau6KK7BB1pIfyjJunG3NqrkPr1QzZ6?=
 =?us-ascii?Q?0B/tu3eZpf8OcMuSaZ8mUkxhtGbv9bXbLY2v2BVCWsrN9AaAv5GXquqYDAO0?=
 =?us-ascii?Q?wsDSuFuayqgdWO8ebGZzpLKXQWzhE8m1hd1D5PSuAERexVSlgEGIx+xltuxn?=
 =?us-ascii?Q?e/vT2+pWdUhP+sq06lFPq2ytnMInlQhrSgz36DzTa2FOJN1D6qLbgrJ4Awk4?=
 =?us-ascii?Q?31E37B6Wa5AnXEUFgyEUV2w6IXv+XNQP801rhFomQX4Pe0ssGT4TFST1h7Wz?=
 =?us-ascii?Q?evGg42KGe8U=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ded32a2-cf05-4ed1-eeb1-08df331da917
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 04:57:40.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7297

This series fixes two related problems in the ksmbd SMB2 named-pipe
implementation.

Patch 1 serializes operations per pipe and keeps the pipe state and handle
alive until all users finish. It avoids holding the session RPC lock across
IPC waits, rechecks cancellation and teardown after taking the pipe lock,
and releases the handle only after the last user. This is also the lifetime
model needed by the following patch.

Patch 2 keeps unread RPC reply bytes on the pipe. A short TRANSCEIVE may
return STATUS_BUFFER_OVERFLOW and a prefix, but the remaining bytes stay
available to a later READ. The reply is freed only when drained, or when
the pipe is closed, logged off or disconnected. Failed response
preparation or input requests do not discard output the client has not
received.

Bugzilla references:
  222196: short PIPE_TRANSCEIVE output loses unread RPC reply bytes
  222197: same-pipe RPC replies can reach the wrong request

Changes in v2:
- Rebased from f47d223627f8 to 21a7f44fd076.
- Fixed the W=1 kernel-doc warnings in patch 2 by moving
  smb2_pipe_response_done() above the smb2_read_pipe() kernel-doc comment.
  This is a comment-placement change; there is no runtime behavior change.
- Added the corresponding Bugzilla links to the commits, and added
  Reported-by/Closes for the kernel test robot W=1 report.
- No other functional changes from v1.

The series was tested on 21a7f44fd076 with a 2632-byte NetrShareEnum reply:
the base loses 2120 bytes with a 512-byte output cap, while the fixed
series returns 512 + 2120 = 2632 bytes. The same-pipe overlap test used
SIGSTOP on ksmbd.mountd and verified each SMB MessageID against its own
RPC call ID.
No test-only kernel delay patch is included or required.

Wang Zhaolong (2):
  ksmbd: avoid races between named-pipe operations
  ksmbd: fix named-pipe reply loss with small output buffers

 fs/smb/server/mgmt/user_session.c | 127 +++++++++-----
 fs/smb/server/mgmt/user_session.h |  18 ++
 fs/smb/server/smb2pdu.c           | 283 ++++++++++++++++++++----------
 fs/smb/server/transport_ipc.c     |  45 +++--
 fs/smb/server/transport_ipc.h     |  14 +-
 5 files changed, 323 insertions(+), 164 deletions(-)


base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
