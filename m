Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.79
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792992965;
	b=wElH0vIQXfqiidVyPxcf3wVaoCt18vGWDPkIEJ7NU/xEX3W6uEzK/7teW6pyvuETkxQG
	 Kk65/O0n8GS//qDaSF18u7uRrdStc+Im6xG7FtXykiOLoF0kf+RsL9+Nx2ZPe4zeBnV4h
	 XUYyAlGUpbHOV94sreuKgDuu/TzNmyPhu3Gq3Vnek4odcWD9cShTdxlcIUBQ76yFcHr5E
	 Z1rOzyxZPxFTIkzjZZpDFO50qFonxCmTcLE9fYzXfYC4BJI9tD29rIILTq7v+wpNPmXy/
	 wLzQj3uEW5A7qwk49kC09uOu1xcTBciVVmEZPo3FSYNLcg3fRjR9kr1858F6sc7aTEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992965;
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
	bh=n9XZLK7k0w62I3Wh2/3RwPbZEIsQBTM+0N23fSpXcRs=;
	b=TPFpZLu0dLngqFNRfV4zUWOZncBVrqPVttYvEgpZMno5Cnbmsmp0GvTUzOOKxyrzArDR
	 ZqC9d6xNc00fuMmuwwM46d6V7UaMCaxnPYUdgokOUGz6SGzUMR74po6wC2NxAQ46WPfin
	 UVh5wrEFq5IaTiWIxnOpp8cIondraEmdm2DEj0xVh0Hm0j6dwBG7b8/j2VUwo3IZ1W8iV
	 Qmt52XljZhNeqMIM48D6rmIaCxfX/F9Q28LHyF7Y8hT5X2qqFBNPxR+TSYt9gmZCUGedh
	 Tnt/i91ygDbotwCAdPovmP4scxde/Qn4r7zmKVFuXs9TdmdLi1+HrD8BluBgPtE7J0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=FQgujuTJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.79
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013079.outbound.protection.outlook.com [52.103.43.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F85606A31F;
	Mon, 26 Oct 2026 05:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F85606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=FQgujuTJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=axK9PDMJHV2qcf0HF1zIJyfLQJ0XJFhN78CDtA6qCF87OspAan5DGHueLg/58t0sa4Wu22VCioi2L1C+Frd8nupK/t+37qLqXPEqaykdKdasxVOQ8l5XIcpG/yvdMeNBQsDDWZHRQuO831+9IAqjAzhyLwkSN0aR9BhReXO0PCAw3wMUEw2F9o83AwMMuFLyQjuB0poaSvbImWJaw8y7VsOPuzCWwc8gkYrnKp5JvIc5fYn6DRFcaEIu4oKa3dxINoQVJto3CKos1pbGtSi4Va9tiyhUlQX7Sqc84C4jFiOcNr07bhceDuzIKsfZ9at8qYs9ZxSk1CenZGnbf15wrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9XZLK7k0w62I3Wh2/3RwPbZEIsQBTM+0N23fSpXcRs=;
 b=KSEVVIKUXNSUPd9NRqNj5UHB1pN2ozmm5YqffzrvZ05I5T5tgKIXp/WbKSGY4uB89q3/CElurlPnjRrROahHLIt+WLLud9yBYyituXK4qtDcgllZUg02X5LMGyAG2pH2NSLLYyfZTUzgY8ssDdTXM38cWLgzIECnDmparJeNKqAdnQgaQNJ5inuzXAoq4bs6Tpb/0bdB2MosHv8xKQVmH0XUqNPEi2uWAG1zAGq7ukZx9WCSVowUxoaxprSf4/iuyv2XY6K7vLEz7bu58IzWdWp6xF3lZzhXmzTzh9qVNcooAEOB3o7/nvDAgcYrq367EvNsk6HJZmH3EAkP38y33w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9XZLK7k0w62I3Wh2/3RwPbZEIsQBTM+0N23fSpXcRs=;
 b=FQgujuTJqAFoXb40ie+sVZJYEuzvtv1ZVyJTIIES/whBZ127D60/x7+WjRM3hnZopYgykC+wws3e8EQy0r0U4KYpK/XUF6tYhdF/Z/n8wWoeorxGZ0RHpSMqpwtg8WWqHFSJZpwgENuNNIxmf0BovhZSaYGN9vJMSakxHXOTSf3sdd2N/iglcn+kxGCUI+CQqKAe18HhbclMcSWeT/YMkS2bZKptawtx/O2i6dqe9fBYhthEieoaByEZBWGWnj6a7lk0nryioaMI+D/W/W4LzxH31QV8cwPT2nCUFCG6LkovXrRB83u/G1xZ4DzVjbwGYmBz0qLaQAf8evtjjt9TLg==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by OSNPR02MB8964.apcprd02.prod.outlook.com (2603:1096:604:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:01 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:01 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] ksmbd: fix named-pipe reply loss and operation races
Date: Mon, 26 Oct 2026 13:35:41 +0800
Message-ID:
 <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0042.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::26) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026053543.1460241-1-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8af4ffa4-d55f-4dc5-7025-08df3323049e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|5040399003|51005399006|8060799015|19110799012|24021099003|23021999003|15080799012|22091999003|24121999003|41001999006|260925184616899003|4140399003|3412199025|440099028|3430499035|40105399003|26121999007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fcMdVXMPIIzCDAbgegLaij0dv1NoPyidqlDPkhW+kDDs1RTEGVdIqSIM+krY?=
 =?us-ascii?Q?kZhHaU1ySv9hwYclwAKiX7qYja1e1Yx0MRnjARk0sDq1cx9dZFedcuLJ/sh+?=
 =?us-ascii?Q?K26LzMCSs6M8Rl4pFbl7BdB95Ysht68HUB8iSZsUU5jiFkMomZ54R+WBcKes?=
 =?us-ascii?Q?5xbz9BFErTsPvEn1A7y4tj5gbjb4+XiFiZpeVA66sFShMB2gO5ErI+1Pg1/7?=
 =?us-ascii?Q?eTs4VucAZFuJyO31u84qQrtKZMnGG/RLo7D2rLLOThm/jDKLVlDQJ1RvhwIe?=
 =?us-ascii?Q?Hx9WiHi9kVMOAZ9vKXkING6jlNKZX+DjVp/wla5VuJgxG+Uvfl2uRg5g4JwX?=
 =?us-ascii?Q?BT/JLlkJG8xsasOC8SBplR9tu4WYdLinaZuX3tIf5lR+N57/hFV3M3vXrb2q?=
 =?us-ascii?Q?8PtMtu7DeSMhSWQAIGP6qijPNdrFVBQpwUcKUvkBD4WgkcGxxNrhjVSNccf7?=
 =?us-ascii?Q?hApPyP1ZuIopAvTAU+j+GC36sWoIcMyPI49JHNqc1a6ZPnQ/e1fnCQA0B4ad?=
 =?us-ascii?Q?x/LLYkQDfvmCFqmzbSg8AATkntxEK8xFPptmCTmX9uuEyPG/4+7higx4iW83?=
 =?us-ascii?Q?4op9GvvPBISxA8JUTdGM+rP511SHB/s0D8JoIa951zPijmWgRIZTzSPzhnJS?=
 =?us-ascii?Q?TsukRdhHk6QOwsnBq4tCkzXig+498f1v1eF2nfNLYH7OTryHUJe4b0IxFe5h?=
 =?us-ascii?Q?UxbspoPUzUrCVxWg0Agsd9rIIQ30O6/mvDMSD3byxLbKZqLzmHPElL1VFzw/?=
 =?us-ascii?Q?2Nf63HSxYrEApETArNYgtrAfK1jOdIvijC3ck3ttQP81pKxupv6dLlMkN+7f?=
 =?us-ascii?Q?ikbVFYjkbAsVXd1Eb2PB3q7A7i/1djk9JJ/AHQCGmCg0Q/sQ0AXbEOewJq4T?=
 =?us-ascii?Q?3YVl6wOjz6arCHj6/KKPbcL1klQ/4s6nToHaAzVgH31Lf2Du7iGvOlbHf0G8?=
 =?us-ascii?Q?uxQF9AoOcCZLdGMg/hk6ZXNzIJq7fmGh8z3rvTanVskfNjEl1ZmMxx1vsNUU?=
 =?us-ascii?Q?ALz0t46xvpr4UT/3KtY5YvLzj10D/WsIvHybnUrOKrmML78RPcvXes8CJ0j8?=
 =?us-ascii?Q?NJe/kFdq?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rafXAp7crqWS//VUtzMkyDhN1U2zi/2aFBU9dmg9LBJJALhKSOkZSHWxj1Ct?=
 =?us-ascii?Q?iImUBvIDpSZraPCzoz4NJgjjKKUXhbtQ/3oeggP/YzVtKFT1DWVbMwub9+rU?=
 =?us-ascii?Q?k40sK6A8tFx1pseaJ/1nbBntAwgI9C7cJOWghKs3l2c3TTXtNZZinvohB1uG?=
 =?us-ascii?Q?feOpU5BUV4CBQMdVnWZaEazcFgjyCUrobxSCN3gszooi8px/xekeuCEeN5w5?=
 =?us-ascii?Q?gzLpVpfE3AlyLurhUBqvWgxh/rzVjwj231dG6a6qOO3I0GnJrdDLdPSDsiFu?=
 =?us-ascii?Q?NTNflQ23xIi6KMswyHOZSTKJGWxKRC4A6ZoD7nCA2FcIhFpMusoW2A/x/6QE?=
 =?us-ascii?Q?SIwCgXmtxKtbUxEu0mjBVrFNAIdMZBwvcXq0RThkAX7TLKYt4fFbn5TL9nPo?=
 =?us-ascii?Q?zoLtRf6sazRhTS15Al8HDvI6g2H7tHZlFe3KkpzqRlKFeiNuQXNTj43Dd/b0?=
 =?us-ascii?Q?eEUr//n1ym8AFf9uussFuYLQOFfTFjucmQa3GQpT7pNa8Tj3wbNgog8qEqj3?=
 =?us-ascii?Q?N0z3+e0xmss69XOntmFBmXwAbHToXsB5eQhVYrD1iP+NCTSnBj2vIdkEf2+h?=
 =?us-ascii?Q?QbSWys0NynhDrwR/widfY0w01+no5XNj9jGbzRleeEPoVscDgLAo63z0pf9+?=
 =?us-ascii?Q?qBqL8et58/MWz42UVviNwK8xMAI4UiWgoFZD7KMrDL2VKrlrZJagRxkisQj0?=
 =?us-ascii?Q?MSZTkYy6R3/913GZ32I5JUXMHeG+DcPjK6ZzPk06KjcwAeYK+hYykbaQFUFp?=
 =?us-ascii?Q?7/OnQA67DsdpyBCqCgs0Ag8ctTl7FoKifiIdWqY1Ley83VFgC1DFt3BtZdrG?=
 =?us-ascii?Q?VqaX0BnC94KmrZTV3rO/3ccyt1Hz8+KPXeGbh0xsrW4v6jJ8HWqFaw812xu2?=
 =?us-ascii?Q?FaHVchgFIMC1tcuWVAl9f5677057dDYf8fpXgE9/d7uRZNrIDV7iPc2gYth2?=
 =?us-ascii?Q?8yhuCOoAH1sgV++UbIZ7HxRlqLCZHqbP8QqY3t1fruGwp75lITsoDdKa8UiD?=
 =?us-ascii?Q?GG4NuOvoPo23kT8t0mkf7vubqxGnIc+kekSAdqEGVBbZKNn9oJeL6aFGThVL?=
 =?us-ascii?Q?jzhdBKvpmeUJXmCDRFpXRn78jenYesqBDn5IDCZ/FJZ6+LPNY+Z5SjWCGnEl?=
 =?us-ascii?Q?NBG9nJFZ+YB1++AT35kcIfxJ+fC1PBKBltwC81icHqiW5rdGv5tpgv3da9g0?=
 =?us-ascii?Q?klTImAl68cczmQiWQtwnUFVPOtjp6A7v8M8DHJGIhKzpYDb9ki1MDa7pO3mB?=
 =?us-ascii?Q?bOhLQ3lzw4OXwnEoNAoMRT+e4yG/Lel0P7k3Za/XrHPxAlBHi8SV6mNgZtHL?=
 =?us-ascii?Q?pzcRMiBVJuOYKvFABD8r7VjOn+/cZeQ3hh+H8J5mfTLELrgz3JkiKpoU0e7j?=
 =?us-ascii?Q?4yd17ZE7wyzt3U0r4HkKf7XAeNe81yROBlqyhh4138OGt0+hKIVgM7vfh15B?=
 =?us-ascii?Q?g6zz2mcFguA=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af4ffa4-d55f-4dc5-7025-08df3323049e
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:01.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR02MB8964

This is v3 of the named-pipe fix series. v2 was sent earlier; v3 is
rebased onto current mainline and keeps the new mainline RPC pipe
ownership checks.

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
The existing foreign-handle checks and STATUS_FILE_CLOSED behavior added
by current mainline are retained.

The second problem is reply loss with small output buffers.
FSCTL_PIPE_TRANSCEIVE copies at most MaxOutputResponse bytes and returns
STATUS_BUFFER_OVERFLOW when the RPC reply is larger, but then frees the
whole IPC reply. The unread bytes are no longer available to a follow-up
READ, so the RPC call can fail even though userspace produced a complete
reply. READ also ignores the requested Length when copying an IPC reply.

Patch 2 builds on the per-pipe lifetime from patch 1 and keeps the
original reply allocation and an offset on the pipe. READ and TRANSCEIVE
consume only the bytes that fit and retain the rest. The retained reply
is freed only when drained, or when the pipe is closed, logged off or
disconnected. A failed response preparation or input request does not
discard output the client has not received. An IPC failure is reported
as an I/O error instead of an empty read or a successful write without a
reply. No kernel RPC queue is added; additional reply queueing remains
userspace's responsibility.

Changes in v3:
- Rebased from 21a7f44fd076 to 7d37252fc49a.
- Preserved current mainline's ksmbd_session_rpc_method() and
  STATUS_FILE_CLOSED checks for foreign RPC pipe handles. The new
  lifetime lookup maps its -ENOENT race result to STATUS_FILE_CLOSED.
- No other functional change from v2. The W=1 kernel-doc warning fix is
  retained.
- Revalidated both reports on current mainline.

Reproduction and validation on 7d37252fc49a:
- Short output: a 2632-byte NetrShareEnum reply with a 512-byte
  MaxOutputResponse returns 512 bytes; the base loses the remaining 2120
  bytes and the follow-up READ returns STATUS_UNEXPECTED_IO_ERROR. With
  the series, the follow-up READ returns the remaining 2120 bytes and the
  reassembled reply is the exact 2632-byte control reply.
- Same-pipe overlap: SIGSTOP ksmbd.mountd, send two TRANSCEIVE requests
  with different RPC call IDs, then SIGCONT. Five base runs all failed
  (three call-ID swaps, two empty bodies); five runs with the series all
  passed with each response carrying its own call ID and the full reply.
- Both tests used the same baseline ksmbd.mountd binary and the same
  16-share configuration. No test-only kernel delay patch was used.

The series was built and tested on x86-64 in an isolated Debian QEMU
guest. It is kernel-only and does not require a userspace protocol
change. It does not change the IPC timeout, quotas, on-disk format or
protocol ABI.

Bugzilla references:
  222196: short PIPE_TRANSCEIVE output loses unread RPC reply bytes
  222197: same-pipe RPC replies can reach the wrong request

Wang Zhaolong (2):
  ksmbd: avoid races between named-pipe operations
  ksmbd: fix named-pipe reply loss with small output buffers

 fs/smb/server/mgmt/user_session.c | 128 +++++++++-----
 fs/smb/server/mgmt/user_session.h |  18 ++
 fs/smb/server/smb2pdu.c           | 283 ++++++++++++++++++++----------
 fs/smb/server/transport_ipc.c     |  45 +++--
 fs/smb/server/transport_ipc.h     |  14 +-
 5 files changed, 325 insertions(+), 163 deletions(-)

base-commit: 7d37252fc49a939d005a7495b81d1bb337c29e45
-- 
2.56.0
