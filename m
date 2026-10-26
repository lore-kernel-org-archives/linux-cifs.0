Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792992974;
	b=0DnyOTAhuDqYIfNrrnrO5dH0JBWa6ho6Ho7PhrZpLMD4r1Ru8fqleqEKgPYliU/+eeN8
	 TZPcOd3kpm3EUDR7l4SQ+lTx3glt2lm6AREFVaVXwcO5vx08YLDrM1mJQbzMXx8jhUb2w
	 +v/gelB2VVoVikuPapsqsgMzdMDaJsAP8Zktry4RgkaMtX0ODSViHNGGwD80fEI2LQv8X
	 RoBqEctm3OluDjIsZqeUKThBCn/Y/3i5X26Ma1eMJqxJYfcfUrsfGakRE47+7r3yk9NTk
	 PEXUzYMQ9TozfLMCnbwDbNjg13N8dKjF57wwT9wjH220LQTQGsvIZN4hRXd5xTvGF5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992974;
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
	bh=7MkEuL5urU9K14i5rSeOB0EDwMuYj57O7bqXhhciFJ8=;
	b=BA/5P3drlfc4uatmZLMpSjSGXCyWqZn3ItcznwSP/U6BGkvHDbv/TCAtY0ZP2q+Q8ujz
	 y+sOeKJvHCL1eJdpp7XSKnbhe7sZB9SSgRe+EHe7qe4joApEyvRStf07Zot7b/70I2FGu
	 /4E51joFYunbAJVPndFpbJ4Vg85+pjm/rO2fsic6hUuvPTh9hkKNOrMEaMqNF9gs8Lmws
	 r1RYY8ZMMyWVFWpYdxItxaxFc6V2UCIfyHWL88BIuLv0gWFa4B+MamLZV3+VDkuHZw9/W
	 8lF559gtX2j1jGinkOxg60H08KXthjNFcnHnUAYLD0p7CPSzeJqH2I2NtEk9VKinzKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=S5UL0BSJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.52
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012052.outbound.protection.outlook.com [52.103.66.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8A9606A330;
	Mon, 26 Oct 2026 05:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E8A9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=S5UL0BSJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDOP/4TI5JVPWj/nL6Bj/zpWStf8A0NEPeEOQ7NLRw1dreLjnaryTg1vqPgD7uhyufaTlBER/mJ/k3sbgKV4PFmb0tdZrNRjQ5I/cMKOGY/Sz3/kJKopz1ReUn97G/Cb7A0QIk3ILe+/ZxocGWjJETtNjCeN4axFQlMDj1JEo/JucnUswmgKwsfHc0Zj1pSc3g649YY1fvk1VFjw9FNEl3dSXt9OcEEQY5eal7jVCmvM32W7x1CPA6ybKwRTy3WiaZq2q3iEWZHkDI95Dtk59t8nx6TDOd4fCP8ZTkxzW8YXqCLCZabMklJBCjmmnWahIJstff9ZG1ACws5utef54w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MkEuL5urU9K14i5rSeOB0EDwMuYj57O7bqXhhciFJ8=;
 b=PoVvNmLilT4doPiex+YKv4Aa2bO3CpbAWQakYRVQ53HRrvvXP1Py4ka9NOqlN5K9vYdxeOtRF3odXTOYYDc91nm2yV0YY2e42CJ5+9WMC5rVSZQ9grmjNVB+PaQDvtG35HcYwgnM/e5jjvt1DlBvacWw6g/eBmu0WbmvsI+d4rsvZqaK17szLZ9WpsLgzVw0XqP9G8cel5HNPvn0gzIr8e54tUiWm+qgc2PPqQK30Bs9WvQk9Ql6WU7oZcHR1JBkYC2+EKafzEp3D4MpwTuy/rINBGlBEbbxU+Tvfl1lcN7LSErWmgyikyitoZ7YZ0Icb+TZlRCSFA1MkqnHHlcXHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MkEuL5urU9K14i5rSeOB0EDwMuYj57O7bqXhhciFJ8=;
 b=S5UL0BSJhgeQ5CvwVYkTHBjklXC9T92xuIxwu2C1KInuyAJZR4UV3vTBskIYZ0G/XxWtdLtXBQS1UNvZPVSSaPEP4S7i1CJtu+8M6Q6m93tAIxnzKKbG+aTY6DXYo7H7ObBgSDLm9o1Labtkl2PCakGrksuG/ImSrWNxYOvCaxpnNob7VgsDC5TKxduKbXh2Huyrl7rn99978RiG20KPU2Mcfl9W0HET78WWYAAi/MydGz+wNjOZ5pJc5YfEkExPaVyMLvxxIOdB1s3EPoc+hj7A3nAAcDeWJ5Ks2cwc0viz0JXUmqYt708/XJgoFeHtqhYhsffVa6Qwq04HtkUYVg==
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com (2603:1096:101:1a4::8)
 by OSNPR02MB8964.apcprd02.prod.outlook.com (2603:1096:604:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:10 +0000
Received: from SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199]) by SEYPR02MB6964.apcprd02.prod.outlook.com
 ([fe80::9ff:515f:96ea:1199%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:10 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output buffers
Date: Mon, 26 Oct 2026 13:35:43 +0800
Message-ID:
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0042.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::26) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <20261026053543.1460241-3-wangzhaolong3@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: dbab43b9-af17-4bd0-ecb4-08df332309f7
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|51005399006|8060799015|19110799012|24021099003|23021999003|15080799012|22091999003|24121999003|41001999006|260925184616899003|4140399003|25010399006|3412199025|4302099013|440099028|12091999003|10035399007|1602099012|40105399003|26121999007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YjyG6ZhJdz23xRzXRg28wdRxwmhHZAs4wdS+gxD1j1UcX6kTqX65tCkjRyt4?=
 =?us-ascii?Q?OGm3t/xShg910q1QQHOgbjo3KsE1AtKROx+cgxX25PHAq9Nr35b3Qv3Up5Cj?=
 =?us-ascii?Q?omtFwpYG42slSQPMMGZbXudZYqnt1ydV1/npDsYKobn/nWNdMZZImrDt/4OT?=
 =?us-ascii?Q?IqBxqOTGidbFEBVlyVm6Yf+mf303FOVWTrgqmnnEyz66Bvq+mHUrZ3dYuKnx?=
 =?us-ascii?Q?0AwZjRZAp5Ter2tn2DZ06TaCGBzqauSgO0eG3GjmZk8AzxxQdliCwP/ed4wV?=
 =?us-ascii?Q?qNfJHGn+kr0uMw68EW9M/ftlO4+16f7TU1FaScFYHFpIxRrsmdmykbcftFMO?=
 =?us-ascii?Q?C+P4QHOKHkltMiVE2xB2182SFSde5WLKEVlNE92ysEuMxjAUp8lE6Qu1ZPuI?=
 =?us-ascii?Q?mpB8yU01Fl+jZ+Q8GrHgRpuMWMO/wKKFKSa3rUy+4UEdaQDOrvHNOxBhQf6M?=
 =?us-ascii?Q?C80nkSdM3uga8DjjvBHxrTDoMu2X/VyXuZ1igJqYBF/OPc8WExJ6GTgfaooY?=
 =?us-ascii?Q?kLxlSczsM6l4LSTxNfDSbE9afTKXmQWqlug/e66avmxJSHZx6qT6fbZ/fHkS?=
 =?us-ascii?Q?mq+paiIPnv9ArAcVEX2E4OMtiF2v3KigOOTIm1srhBh/e5fVsrAh4S/Nof1Y?=
 =?us-ascii?Q?kCD3zhaGBrPuVzB3K2RK1Etc2ef/bgAaVRKua0f2eUR1DG6ob5louHo8hy3G?=
 =?us-ascii?Q?WY4/dRUJF8zRaF6ckmylrOOO08/u8Cr//xsxxu6kvn10/RHk9ZBqckyBBotL?=
 =?us-ascii?Q?02HEZO8Px5PaZsuAi4tSdOzcS6IiNE6ddcfPNoWH19fgHV52uRJ1hDSa51Vb?=
 =?us-ascii?Q?zY1dRR2j+hUs7AAE8upIKPZGOH50mdzu9melc0N8oAuRZ3aiaHGGCA97HYZC?=
 =?us-ascii?Q?OJeWUdBeHYdw3xTmLgNPfP0fxA+JqiliYITS0nIyymLGzsxzNMFp8Jk0PHt+?=
 =?us-ascii?Q?kBeBqv4KuSeBryAx9/wMZ/TzITIZ0RrP1vhDKiCd0WmpuBIpL3Y3mXESodc1?=
 =?us-ascii?Q?g857PFKH802FhIT2l6v08xoqTaBSMmyfhwvxCLWPtzljVZ4oQYT9/AwUy+MP?=
 =?us-ascii?Q?UTcvBT8k5OTxFbiW/SnNRBDWbtTUgkEs8D1Ta46wsXHG7Sek00wsgB/8DwfI?=
 =?us-ascii?Q?BGcFyZ+aBOkjQ+yrqvHMgs84ubxeyP7syg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9sLcPH2OMRh8DqoGhgiwBVEIbMZwdfSqnBzL8R7244+4sOz/ogcJEP8DbyeR?=
 =?us-ascii?Q?wksIuhjvfDspJE7LgA4YtJ9tRQzjT7To1d71yT37ElJeMG3neKWTBaSINXK0?=
 =?us-ascii?Q?nt8vkef9dWqfagLE1i8Q4TE2t56yrveNqg5pw+c+gewyFNP3/V2isQZdQvMx?=
 =?us-ascii?Q?/UdLdtX0ySeapzAmT7iujnxcA0Pgy+XM+A2r0ZsalAe+we1a1KX7jeLjTpXq?=
 =?us-ascii?Q?9iOI3ykNKpJuiZGzDmNatRkG1LwssU9/b+MwdXgAErSM08n/KFtcYBCG9fOo?=
 =?us-ascii?Q?BriUC0LSjG5FB0L25HFPAVafg+jHF7rOqQq+0X3RwwkTw+aclq3Wq1Yn8G9C?=
 =?us-ascii?Q?7Lun5ZnpzPnyygSl0zb0ArMmNpktRvRneC7BFChnRmKRWN4jDtzVPQZKsBTc?=
 =?us-ascii?Q?AsJmQI0IKCX/d3G9gbnEB2nYgw/jx8bf8p8DRcihHUY1MNUL4UuO5pF9eGu8?=
 =?us-ascii?Q?2xvxk8QmlS4xijgTBaDv8qI27doA3VPoiUQM+VGFhzrCn926hYNzMHydxcz5?=
 =?us-ascii?Q?wDhTeb/DmYVNftR8Uj68UqOPX07zU31LdLRWArueEn5feQoEItDIljG4JWxk?=
 =?us-ascii?Q?uRsptmtobBCTkhLZpV0zZB4HPOxQuwvjwdPG8DHYKs9Wyer8R0RzPVXY/r8O?=
 =?us-ascii?Q?tuFpZCpC0fuRvSJOjpKQDVZugMOD6SrLuvg8GNgM+rCfvrGNGclXVfroZ7FA?=
 =?us-ascii?Q?m9rni0PtnF57nDH4gMHq/5hJovlm9Qp/2i8LobcGS+l8+DUK5PfnUW5p7l0/?=
 =?us-ascii?Q?8L9ncpACSmi3jBtq0tZUfBSi5CmtS7GnukRSeWLOD8XMZErnWlMZPLWQ+NaO?=
 =?us-ascii?Q?PvlNiP+rJUPTRnDXW66QWf8h0hVTHREM0LniYx/56AAgZba5TRHXhUGO6iQl?=
 =?us-ascii?Q?etp7Uba0p1wH5NHTVJaHXM0IRE8dmr5yAkGHJPCS0IXek9IKVzmD6/WNfbjS?=
 =?us-ascii?Q?i+7LV7tPaTK9LNkya7bpNsnaT9FRMvkjjBQfZ1w5agfwZvoOXUw7w2LR+9Ed?=
 =?us-ascii?Q?BXUX6oTD2BYFYdbPgm6Zv9eRCZs5u9FW8dROxnpDW0y7GF3I1oWyb7EVGyTK?=
 =?us-ascii?Q?pHftu9deBrvad7M4LZXAABSbph1C+4qdipTN1auNaqbRuAx9yNHqMGuYKh0Z?=
 =?us-ascii?Q?CiE/5qzU9afnwanmKRSp3zWzXJ3RU7tLZPcqVr8ZOZfdgiuNd1kWZczte+0/?=
 =?us-ascii?Q?35zn/2mJbxCgx+OvIEAIcgRuOelHBi0r9TS6yUZTkRgAv6gHec2no8rHm82O?=
 =?us-ascii?Q?W8BWK3/+iVDHVM7ryqMiVaVcOG25DYqKmw/cYeHgpdecSGFpPOBM9U7d1En9?=
 =?us-ascii?Q?n1oxQG8fP9ZtJAe8j4QOYA5SSb6KsK90HEiEYYVNbWtj4eZOFqt71KcHI81t?=
 =?us-ascii?Q?1hILumu2b+1XhMaYX0aajRfC3t4ItyJLSXyU5d+UsYGitIVcZgjKMtg+abui?=
 =?us-ascii?Q?B8jPeODMezY=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbab43b9-af17-4bd0-ecb4-08df332309f7
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:10.3110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR02MB8964

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
 fs/smb/server/smb2pdu.c           | 159 +++++++++++++++++-------------
 3 files changed, 95 insertions(+), 68 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 4db69809b9fd..3f75049be878 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -301,6 +301,7 @@ static void ksmbd_session_rpc_free(struct ksmbd_session_rpc *entry)
 {
 	if (refcount_dec_and_test(&entry->refcount)) {
 		ksmbd_rpc_id_free(entry->id);
+		kvfree(entry->pending);
 		kfree(entry);
 	}
 }
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 38073ea9089d..5f0f6276e316 100644
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
index 66123b7afd5d..627b4ff58da2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9262,6 +9262,17 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
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
@@ -9270,12 +9281,14 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
  */
 static noinline int smb2_read_pipe(struct ksmbd_work *work)
 {
-	int nbytes = 0, err;
+	unsigned int nbytes = 0, length;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
 	struct ksmbd_session_rpc *rpc;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
+	void *aux_payload_buf;
+	int err;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -9294,46 +9307,59 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rpc = ksmbd_session_rpc_get(work, id);
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
@@ -9349,7 +9375,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rsp->hdr.Status = smb2_pipe_error_status(err,
 						STATUS_UNEXPECTED_IO_ERROR);
 	smb2_set_err_rsp(work);
-	kvfree(rpc_resp);
 	return err;
 }
 
@@ -9947,7 +9972,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	if (IS_ERR(rpc)) {
 		err = PTR_ERR(rpc);
 		rsp->hdr.Status = smb2_pipe_error_status(err,
-							STATUS_INVALID_HANDLE);
+							 STATUS_INVALID_HANDLE);
 		smb2_set_err_rsp(work);
 		return err;
 	}
@@ -11440,20 +11465,25 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
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
@@ -11462,39 +11492,41 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
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
@@ -11829,7 +11861,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = id;
 		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		ret = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
-		if (ret < 0)
+		if (ret)
 			goto out;
 		return 0;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
@@ -12210,16 +12242,7 @@ int smb2_ioctl(struct ksmbd_work *work)
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

