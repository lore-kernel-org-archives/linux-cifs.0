Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.66.10
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795002693;
	b=ob4olAG9jPHNn2Y8I17l6BKIE3ON9kKnZW3A37ZIWJ4jloALJSS2qtGMLIhyLkODyKLG
	 kqWnb4L4v3WYz99D5jJfJbJ76MmW9wwtjM5c6TjYD+CquZIsa2Qa4WC8g4d0ZS17HExPJ
	 h8mItE2Q7dKh0jZ/aHOhBw5UkpBFGNsjwcBwEJpJfrjCH/e42TGNQ/YQeVKZIVGXdrtI1
	 X9nUXGI8F8U+/DrggpmeUYmZe/R2htEada8gzTrPESNsFiH+inNmkhOBdmcRVnSEIGBaa
	 HXTKAc69SUqczoLRduDBWfxlAZv/7C+5Vj3p62P3Tcn/b7x9qIWlNVje8yFzjXE4JYw==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002693;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:From:
	 Date:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 x-checkrecipientrouted:NoDisclaimer:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=IqbuGqCWt2nz9c0tRPpSBgmY7a/a3DtoKICs8nKgOvw=;
	b=TSWvGG3ggsU2We/NHaHFE3knrajhgDVyIyEYCwW9x8nrG4NdoU24tIX+0QA7ZpBoixeW
	 8Yn1f+rewtEGS6LBrL08GLGMysbaFEMgGF6Xzex5ELraCkGEY3NfpJPs6GdcsAcpNeLdM
	 EV4ip2ZuTMc7388+6mD2djmLWFy86gQUucE+xk+1B8RRsfOOavI08W1KXHhDRcZTXvYxo
	 VKun+7D31CVoBQ02GYprRt4MgtqISAWSzA/TXQqTL1QUG3V+/S0diAEJJD7gWcb1Xq0xn
	 LA5qFz9KkHqT3ZGW0kq5Q994GYi6ziMyTZGmAekDrEwvvZ9nNvtRZTHuMA+gidlO7JA==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="A/HzFuV0";
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="A/HzFuV0";
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.66.10
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012010.outbound.protection.outlook.com [52.101.66.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56834606A33B;
	Wed, 18 Nov 2026 11:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56834606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=A/HzFuV0;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=A/HzFuV0
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qpdEQ9gwk7LAzFSstXxvUYlXKEupprZtThap7oh2WPYsTyzowws2hOcgZUBl98eH8DvKbwzm0CSE21Ou/4vqNBp+tIQau7B8E2cJTW6ynPsPQoYCqPR9V7+2WrInyooy8Uod3wJWkQ0ptBKMgoh4sp/uvlJzJbW2M76Z5piGkil9VfPbFa8oEzJuOfleFxR/WREsJittkbLOX2ZO+KmRpGoe6KHGT/vZf1gFV4+68euUYhJE2V3r3anM9sPU0vgm59Pqkv+RDKFKaC07ZZj4AF1KMYZzR7QUGS91pVpV6fkxsz/9YTaz93pbdklFIyBtK5903eWmVjke7YrW6QMKNA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqbuGqCWt2nz9c0tRPpSBgmY7a/a3DtoKICs8nKgOvw=;
 b=nOAFmSHHVN678ywskl+1GjJ8ncvkTqd2k4eC725Y9scFll7hqOzWexJk9NeVajpOsRKorbu8/LGu8X3ksLbgP+K/jI0DaDZAFnqOAos0AQTYFkdcp/jd5jzT4cytoiFaBONXzRRL7bPGV6ILa5xHp7UwjBHMEC1pYVsdNsAqaxQKtI9whmFP3o6/YkvUdo70kudJ0pSBVahwAW7ATBXx+lVe4ALu2vwWQ6uh65xH9CAO3hvGPdtOHHbzA3zJlJMSU11OsKw1CogJRTFWPuQnRHjh9sC4yQXFzxyNyLSblyqXVW8glWctoOH5YrLlWHlF6e43yM4DhyJ/UmPqS68ejA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqbuGqCWt2nz9c0tRPpSBgmY7a/a3DtoKICs8nKgOvw=;
 b=A/HzFuV0SYisPpjtbZo+C4ku38wGywb+fMeQwe2Kv8CWpKHGmsR6q1tgg/NGmY2RD90vmJXIITYLb5I2oaOGOXcYzZeA1hoYLhg4m9sJ2N+qaWJ51HBd+jc9JraT8DYVvbAueeMt/ZYxsNGKly+fgqT3bT98KpXbXtXG51ABnqM=
Received: from PA7P264CA0141.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:377::19)
 by PAVPR08MB9081.eurprd08.prod.outlook.com (2603:10a6:102:32a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:51:24 +0000
Received: from AM7PEPF00000051.EURPRD83.prod.outlook.com
 (2603:10a6:102:377:cafe::69) by PA7P264CA0141.outlook.office365.com
 (2603:10a6:102:377::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 11:51:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM7PEPF00000051.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.0
 via Frontend Transport; Wed, 18 Nov 2026 11:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUeXY69BTlAKGNDN8SunAYKeRtk6Ob+ZDp6FTLuO6f5KbEXMvyJ+t+pX1Qude78sPz0O6nDL203elGh0tiKHHyxQAZId+eyeeWPHssC1lgkDUNNzfC3/AJvyJG1HddRJwdJVCQWsFAr5J0KInpaN3Wso4eWnmbyZY91u5JURJFKUVJCX2C86rw71blsy6to0qVOySXhvA53qHvfPB7EH0WwPftMPvchgrEFLImsyG9p73Ne4ztF8r6Wnj+VZNFD8eqsvCIjQTxrfricNtzMYbE3w/mwDdU/9Qli8ycE3eqdQqd01lATNaqO1XSdtI9xz8U4GHj4XDrD8s5cOnhxYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqbuGqCWt2nz9c0tRPpSBgmY7a/a3DtoKICs8nKgOvw=;
 b=TWipiO5xrOCjJLFn/bdok1SR/tDO0pR2n/rgPBiIRZhu6ZyA54uQpCzOLjEg+JgnkmBVhusqEtDGg72Vbpf18q+VvwLhtwv6lKFYoowa3NUp1EwKRH/pPzs4k99kLtPsDqJhtzCiD+TM4N9j7mEPFR5Cm0Bzfh+yBeYd5S8Dve/kHR/a76I25+uFrjxTpbCWQeo82Q2H0IkQSJla0HsHC0I5d/cSYNoG/GT4inDXwF4a5lrIeq35DX/qh4v8RoMC8ra13lzdxx2GJ51R+yLS3Li1v1kyTsWdqgjCECcnEgdsc31OqK1lXg8pqVFlyFuQi7NPYdO6RcRLhgjEBShlaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqbuGqCWt2nz9c0tRPpSBgmY7a/a3DtoKICs8nKgOvw=;
 b=A/HzFuV0SYisPpjtbZo+C4ku38wGywb+fMeQwe2Kv8CWpKHGmsR6q1tgg/NGmY2RD90vmJXIITYLb5I2oaOGOXcYzZeA1hoYLhg4m9sJ2N+qaWJ51HBd+jc9JraT8DYVvbAueeMt/ZYxsNGKly+fgqT3bT98KpXbXtXG51ABnqM=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by PAXPR08MB6352.eurprd08.prod.outlook.com
 (2603:10a6:102:150::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:50:37 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:50:36 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Wed, 18 Nov 2026 12:50:08 +0100
Subject: [PATCH v4 1/2] overflow: Add offsetofend() variant of
 struct_offset()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-offsetof-v4-1-95b385c10b22@arm.com>
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
In-Reply-To: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
To: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Philipp Stanner <phasta@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>, 
 Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Hans de Goede <hansg@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
 Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, 
 Nicolas Palix <nicolas.palix@imag.fr>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Carlos Maiolino <cem@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 =?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, "Geoffrey D. Bennett" <g@b4.vu>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: Bence Csokas <bence.csokas@arm.com>, linux-hardening@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, cocci@inria.fr, linux-fsdevel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev, 
 linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: LO4P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::16) To AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB10291:EE_|PAXPR08MB6352:EE_|AM7PEPF00000051:EE_|PAVPR08MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: a992ce5b-13d6-4fbd-ccff-08df456a44e5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261009223027099003|6133799003|22082099003|18002099003|921020|56012099006|11063799006|261026140227099003|261102123227099003|261028144727099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 6BhwyEBN0Lg9aktbvS5iHc8lYAT0fHx1DruG9WciosaXCcX6u0/b/Fvvoh3EOAp2s+2O33DkPk1vRKLMSZ7PtwTHI51X5Xl6nUYhRy1m2MC+kgHfFcEt02IxkaPmYult17H667VR/I/YbisYvRagZi9LOPU2IF7FBJlX0dF6ssgU4q4iMWlnZncAqfKeFTc9wzc1RRudGy0sW+2B2ue4sqx1uMXf7ird8HTLTmVLH8gm5m29xLpfygyuaN+TYMuI+HTGIxSu2Equ43u9pIBcg1KwDaAnhcYp5kNNzSxMnok/IqMoUEyNPqRKKYeaaHFtQ9T4O5OAjGxpdX2MLe96DSb2Gss1M0r8PdEvptOwvnue+FVWAXPRBlbxEokckKjY3PL7+jxwXomnBWe9bshE9YUCjZdaRINE3O48LXiJ5uzy0LFOKI8vfSJniVeGFiWj+c55dx1w5vVKOjd6s3bF63C5/hf2sZjx6AC51nhsatis80csg6YTK0rdpfNIPyiFDSTv5ebkXnY8MEhA6JKhvAQadFV9ZTgBjizhtavV5Kcy5HLAKqXGWskaicIXdaXOVZMqcI9H3428JoCm4jrNNQmiCo5+QKvZSMdLcSRFIeJd+T8Mi8oGglsBROwRRQjoK8BvJSSQTUlbGuiO6R2kblLYsGcYh3WI9RNs9CoOBIvj3abP6R2mX+m921Olg3QH9JbmuiWZaNZgQnqSoF3u8A==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261009223027099003)(6133799003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(261026140227099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LiHjjEBvkRpqSleHw0HDwBZeTMAAEaZ68vEYTdxxqqviCKhO9oq+jC7oj38cwnbvwu0qHyUPMdb08V9FgqgrvY7vfUzCFxh6VcrbqGTgdMSWR1eW/Mb0JaFj2uEvsIXKad804Ok68QdB52H9u0aQwnp2C5THiK1hyhJT/UDrg+wE6abZYpucFxm4lUj/BkblMkOZVGjQd9gTLx4ZGPY5//vqz5O5Zn9zXqWqSSs9OUGjen05dbWDLF3dP2iWHE34kLvIfOhvBwAdlljdlW2r3iRftzp+PT36h7ZZt6sUrlDf8S+xtUV5JHTb6pMBVb1TkDRl/YTX3pAgFqxuVWczfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6352
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7PEPF00000051.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4bf08f80-e327-49df-d188-08df456a28d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|7416014|376014|14060799003|35042699022|18002099003|6133799003|22082099003|261009223027099003|921020|11063799006|56012099006|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	SX+CIW8Xj9fgLGL1XGEJcSMtDGCehjuJx9HfaHr8WiGsfH7XteL/dLIF47r//T1qVe8hMJDItUZR9lBw+NFykGMWTOgtVUHcWoi8CNFqLLvj6ohwAJbg0MsiwXT9ivyT8AJ5RvXD2qNsUaVzjGpE2rqs2cQUcMCfZARtYAbJy2v19QWCh3Ig7aPnKxM+7zeP0OTrOx9CN9Mv4gdvMdv0y9S99NsIE0m4oQ/Nckh5Zl4moc5Xb/TLyIUBhfdMtfsjiZIkebydeno8y2dFjGIRvLPJT49/8Ni93uilqmwoUOLTMGdKJPpcFs3FONjY7mrH736Pis3tzddmEf4e8E6qkDIuPZHEVA+DuCuuaeKGSw/f2LxHh97Hgb3k4UpJL3g0su+xMnegXg99sg3PZujBDraMl59MWfYoIOPwcC2R/9zWlDN4bwNwm+znxhXnyZFc8owvPXHbok33GY/r9x+8QuNFghj+Y0HdgoO+WkmN+RMBtpPKH3KRkBriQQjomz8CVGQlQQ/oro+pNfmbTeO9etuQJgXfR9KHR6vxVBhR1EWeik8hveX9nE7tZ/9uXMDf5ivLOn9jvSxgobNhIZ7noB6vMRDyO/8jvt796wBrRVVfzIVsMaCl63nfbMnla8hCTYnQ4BtDGWI+Appzviy5EB9kiutbychdSBCPqUuKZFQgnEiscgaxGZGhff4qD+xg3L1VtWp5A2oeI1Pg3iaX8frna7wbDqXV9fS1DGwMma0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(7416014)(376014)(14060799003)(35042699022)(18002099003)(6133799003)(22082099003)(261009223027099003)(921020)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2fNdGa9MwJ76qPRJje8oBm6VNjItqJqyndtx0UP3gAIjzHzRW/EsiThRnUK7UGDDeN7GJcexpDMrlrxa7UKfmLW/rVfCkjYu2SqJiTpE16TW/U5O2uV8+2guq+pDKXDWmqQ31IoRZw77ORdpQW2DqCa5fXteEpkeV6OYnlillX1uel+vly8WT9wAPNY5/4oAKY3/cKGtBT4/67jbsGIk8ahxLxDs+LKiupI/Aw9yt3fPlx2ZCZNEF7sK6MVdz/ploiuC6ZQr/ZYddzCIFcIGoxIQigsxerxlygKzeHTSCLXXMtCml/Ccv5Jw2NvVPZC1LTKQEQ7M4xAiFwwBPONArgzR4YG05aeaGKXJyLRtSP8dtvZV8Ze9mxp4cD/4esYxy/huZ0EQJEn2pNrZ2wRYtPfVLDR5paS3WHrvdsYt9GJqKvVrym/5Q04CKo0+s5FX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:51:23.3230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a992ce5b-13d6-4fbd-ccff-08df456a44e5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7PEPF00000051.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9081

Many call sites of offsetofend() use it for the purpose of pointer
artihmetic. Thus, a common usage pattern is:

  offsetofend(typeof(*ptr), member)

Capturing this in one macro helps keep lines short and terse, while
still making the purpose clear. It also helps discourage spelling out
the type name on every callsite, leading to more maintainable code.

A similar struct_offset() macro already exists, so add an offsetofend()
variant in the same spirit.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 include/linux/overflow.h                     | 12 ++++++++++++
 scripts/coccinelle/api/struct_offsetof.cocci | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index d0f04436343e..c029d68daeca 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -464,6 +464,18 @@ static __always_inline size_t __must_check size_sub(size_t minuend, size_t subtr
  */
 #define struct_offset(p, member) (offsetof(typeof(*(p)), member))
 
+/**
+ * struct_offsetofend() - Calculate the end of a member within a struct
+ * @p: Pointer to the struct
+ * @member: Name of the member to get the end offset of
+ *
+ * Calculates the offset of the end of a particular @member of the structure
+ * pointed to by @p.
+ *
+ * Return: number of bytes to the end of @member.
+ */
+#define struct_offsetofend(p, member) (offsetofend(typeof(*(p)), member))
+
 /**
  * __DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
  * Enables caller macro to pass arbitrary trailing expressions
diff --git a/scripts/coccinelle/api/struct_offsetof.cocci b/scripts/coccinelle/api/struct_offsetof.cocci
new file mode 100644
index 000000000000..5a30647d3787
--- /dev/null
+++ b/scripts/coccinelle/api/struct_offsetof.cocci
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/// Use struct_offset() family of macros
+///
+// Confidence: High
+// Options: --no-includes --ignore ./tools/
+
+virtual patch
+
+@offsetof depends on patch@
+expression ptr, member;
+@@
+- offsetof(typeof(*(ptr)), member)
++ struct_offset(ptr, member)
+@offsetofend depends on patch@
+expression ptr, member;
+@@
+- offsetofend(typeof(*(ptr)), member)
++ struct_offsetofend(ptr, member)

-- 
2.56.1

