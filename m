Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2074.outbound.protection.outlook.com [40.107.215.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31994155333;
	Wed, 25 Sep 2024 06:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727247362; cv=fail; b=myEKedn3hNOjX09IIPB+5BoFoMQw4Gy/mwQhrkyScFsAckvn2TyECSQPiJG5DPo0IT1EgCCDuWm8uN03DnaomANLYNz+DA/qFFpK/RyFN+58FIplLZl0VpNXNq9HOW6d+KpEh7kZ09+O1TUkGNscqo5KkBWW2wu6C6rbpXw9lZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727247362; c=relaxed/simple;
	bh=YZtUMpV7Te+S8Strdnj+HF8JXFrVRO76+LD9qo+PZAI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ChHwYihPu+skRbKou92zVphEkmHZFY7xoxztcMUsO+3boVVGzbkUOl5i6U58lbd7X6MtIdJ7D6Z5S+XzBxFnwuwjIGsh31c2wnOqujNeZbwgSl9yLs0UEcfw620fV13C8JVVPaDaSFXaPJujqCiKNBtdOzKmLTlrOSITKs6Y9Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=VMhnCGQB; arc=fail smtp.client-ip=40.107.215.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="VMhnCGQB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyhsuXlTTiakPhy8QugVgIR+GICQURVym/aKqzV0hszLD6yt4uZTsWzUvyCOq4IVQGiA0evjqnjl82zq+ZvbiLfDkwdpaWQNwJOK9O+CvNODBmqL/59sJ/mXkig9u9e/x9UJ4nn+FmD+BARb1h3ofuk8JbC45QaUuPYz2xqv4LfQZTMxcmj9PP9dPcojTaTttysS2qMrOEF36d0TL2kHmbsHJB0g15A+qab8vCQpXOl0k3jlfZlS2PLLyHLvYFeUABUQBTf/l33IaZGA8CxbDFI6YZTsUmOdnEFEok8ji08XKJeXeeRYe9RsNUlcgFCkll4CabF2TvHQx9BUy8rZ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lplIkh7xTl8X5aRR0NiPCQBEjAOSnckDDSdA5di7/is=;
 b=ObPu4h47SbjFB6g5bnz7l8PqHqFXzxoCjKfJLhzW1rIXgCW97Vu3pfUI6y4BFMFs0DdyVhH88NSGg9PbGy0muxe51ijeV0ti9FmnCaTJEJYDfTnNTee02WSSMOXSHbpDrK69InQvvrx3RIQa00VXtNP6dKDc0ZBHNs4n94pH+fKGSpkNA6f7xsJpTq2YSeHXljmOLrZf2wV9cs5zcMy+hDv6OHOWkqoefQNWORnvqy1TxTrCSIKY60bx1GgnKmvZJYU6VqyfVg+wV4bGV6zJjaFB5N8KxKogNgUcx+SHPFQJV2JlQGkEAVMmUijueK3lLUU7Re/+Kzsp3pNcj2OApA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lplIkh7xTl8X5aRR0NiPCQBEjAOSnckDDSdA5di7/is=;
 b=VMhnCGQB5Hwqybg9x/1Bv7SiWRN8vwCibgwQ4V/pSyOtysmxLKWM34+ohOOz3NoNi6zv7Wq0LZVozPZO8hbCsnu4j0PsXWftVkb5LketZlzImKZPniBPu5daMHFpZBU6qoKgwWHBq8iQfxjAk+HuRLnw5vARmUP3tBlpr0RqOzpPSwEobKQZ96pVeWMOVsGqC8FYDkxiMP2jQ5HQaJb+Qs2e72gYAS9E6lITnkh//ldN7UsN0Keb8ON9WDBvptnxNFcsYZmmkH/6YAtBDpNgpKxFwnj7BuAG5BuXyfjhq+vNSx1d+Ku0Y5QfEg6uio8JI/uOQz/+X9Yp+/JuclPZ0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by SI2PR06MB5170.apcprd06.prod.outlook.com (2603:1096:4:1bd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Wed, 25 Sep
 2024 06:55:55 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 06:55:55 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] smb: client: Correct typos in multiple comments across various files
Date: Wed, 25 Sep 2024 14:55:43 +0800
Message-Id: <20240925065543.7620-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|SI2PR06MB5170:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd6fcd7-5ad9-4a6e-e92b-08dcdd2f19cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7fk3dk23KBzatSPEkf+pWWhq8/zb1G2eEkSVsDRZM62SJbzyCbgELIHIGJ4B?=
 =?us-ascii?Q?Kg/fr/4f8kNhex7igzGvlK37VcTsnJuBus/mHSxFb7rQgeOa3cgLEMm4nFYn?=
 =?us-ascii?Q?IHC3I9ahI+xJ55QcHnnJlIv2XmdFaZsH70MuHlDwpvzuWDcOZNZOYw/nKaDZ?=
 =?us-ascii?Q?34UP0DeEw7vs6jYACNnKuW4VA323GRMx1YupV8ykbysIxJ4QxaJoHvGGJAMI?=
 =?us-ascii?Q?D26SRmZ7d0ioM13ljxU4FgckLidAxAL4AB2IrMAY737D4n5EqJsVTe2yvmZi?=
 =?us-ascii?Q?oZJBPstry8drIy3lWYZDVLfg+y5hYtqoHJ0oLJA6hZlE7Y3z/NGyjk6gm4k2?=
 =?us-ascii?Q?OdbrmO96PvMkjMn4Gq+ZEycKHy2NMeiO0DUmjm2D7xKi2LA1lkIBP6TVZ0jl?=
 =?us-ascii?Q?Nz8fKx3OhE1EjXn2ELrSvPCZCaJm8FZVagm/FW22QI4KazmoeFC/p5nan5G2?=
 =?us-ascii?Q?XjqEEJt9i22t0mvmLnNFRozrN9tEWn+KEPvd5cFMQ4jsXdRI2dX39dmXEjkC?=
 =?us-ascii?Q?+mruDKSPm0iJN6pwPI4kt+buool3kUkbNlxkKqEX57IQhHi2ftMtGeeWrF2V?=
 =?us-ascii?Q?q/XtvA75wtIqFAZTJN7cR4DbhUtxLr60bJWJyQIDM2I3BI4HqgjOUVNE7lHB?=
 =?us-ascii?Q?qxBxBG5Ni9Klm3+/tOfGkKZ+ev6TWKSrVNwkhD9Et5/NHOHlDDyu9jMox+89?=
 =?us-ascii?Q?sUBE/gOeamZrT8+ZeFWllwhEX88sioMnSHHiwpiPdqMK/0BIj+fJQnSfSlwS?=
 =?us-ascii?Q?matqBXrnqJ87O5gPKnyn9PYruwbPpRYgBOGxZKWQK5brE6QppKbT1SwUR7wR?=
 =?us-ascii?Q?O4tCZU64kRacTD7+RWWECvi4nWkE7Z/uv6aR+NsCxMxIyfmd8W/HKLGtuh5G?=
 =?us-ascii?Q?pHnQ5kUXlZQdw85yvXHCcj88AUkd7HWzuLnnPUit9idza8AhwLQbRs/0ertg?=
 =?us-ascii?Q?1HrrrRalYvIQCT/hv6rGYvDYgTmYKleR70oS8Whs33AJsWNZwQDghbyythEn?=
 =?us-ascii?Q?vej1wG2kE8Um9TbDDQc1f1enyqMdVxqXEzoaD7HOgYkDFBwDrebolqvhX3dh?=
 =?us-ascii?Q?efWc2J/TaYKD3fh+X1niviaw6yN6dBRj7YxmNDObYsAkZwT9+Lp+SZaxWBth?=
 =?us-ascii?Q?5ld5RbiCQj7gWw6DOXxyE7UykNS9v+2sR3yxVDPl+UhoGjUn0clGf0IYrMZJ?=
 =?us-ascii?Q?6y337Jcpf2t1IGfRkYTEZSDc1DAJv1PQRLZvAef3uNXXRrw1RrB4HVSArZUa?=
 =?us-ascii?Q?Zyofia5Q5SnAH121WPJYYHbPtmXzkOr0MgzuLNCPduLJ77emv5o5+At1d4iA?=
 =?us-ascii?Q?A9b1GbpsJqe/OR5iIXbRQcBnanDG3llAZbhb6CkfyRdb17CM5fJeKcL7z+FQ?=
 =?us-ascii?Q?jq+xsL1D8oZrozG2QSPQB26cCF3TLhT4/MXcls46B8I5mOTmRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j2X9FEW1tauq/RlKeh1eIG0HwZgLltl8810Tj3oHvTVbSthJ94F44xf6dSoL?=
 =?us-ascii?Q?x19dd041xDHdgLa5LARUodh4nGojZe5uvnddQs1UcyiIbJpLq0nXZSuB1wmj?=
 =?us-ascii?Q?18eXHIai9cgAclQJL77694GgcF8D2tXBfoj7DvqbmGOly3vRaQRM929Itzd4?=
 =?us-ascii?Q?GwpyJ+R12YwBRXAIDWJWVj6y31GQb+GIts5gO7dzE8iupgsfUMMRDLshWxyJ?=
 =?us-ascii?Q?NnECRYZQ5isAf/NuAr3ky8TiZx6i3IYQ1nvmT/Ox6J4PtGt9b1O21Zbsvf3w?=
 =?us-ascii?Q?D2yA393gpbhOeLEHE2mQksAIxp5svCsnu1fePwF1rghPkDm0B2WVDPRF2RDY?=
 =?us-ascii?Q?FjmpwvbF+2F4yDdyUCUU5sGqFLe06eZdTk3dDkaLOisDPYHAwqMjUt85jvoy?=
 =?us-ascii?Q?4sAf1QBn7oT0CCRzzJvx1cqf6zLngkVPn+/ZblDK/owbIh0VgqTVoPySnWHt?=
 =?us-ascii?Q?TyncZN6cXwUJlR3vujqeOUczHKqUvSoseSmUidabhJXZYEbuC5Fttm7rjy5f?=
 =?us-ascii?Q?wUEb+TgSuypWcr7zX5j/dWacw+Io3eBHfPXr7mAAcFYuu8axu6Jw26whzwG6?=
 =?us-ascii?Q?1hnAla4s4xj2eTgmUJLT4BK8UJMyN9C1rtwAZiY7V8DJsW4kxn/7L7B6N3EO?=
 =?us-ascii?Q?brA2vMlKFa1ouz8XhdLuINd1nvhZLQ7dnd6CeAHDwarhryby9UBGn9dqYMmD?=
 =?us-ascii?Q?+KwzEQpjjbrGu5vlJsRPUhLhukSKUwEZlEKHPAMgapIm0LOJTUesjwHB4DLI?=
 =?us-ascii?Q?9G8N4BLUV26wRzleQnuNo9puyHARmyLP9GEEFNQkiP+nkM/4Dt+gNkMwVRb4?=
 =?us-ascii?Q?pSxxRbtnfeyuCpCsLYM46tflJeG7tdy2U9Y3bkw85WZurfHKbPgkXQD+9Y1X?=
 =?us-ascii?Q?Hxh+qrmhf00obDnKlWw9Qt+88GlsB/xKGR8UBtVvP5Un1XFRwtuENHtP+cmd?=
 =?us-ascii?Q?XswM1KQyIpTMbPfjVnK20RlkmX94qHR8c0a2KQn4u4zmpZym/A1lEitg9J56?=
 =?us-ascii?Q?x806be6YUNY6HC1Ze1ByDyAcp9ETSERnzDTu/NGuKvNpGKR34NZ6ugQFwf69?=
 =?us-ascii?Q?vpkLM7zYaGzEE/E56/7UormFQG9iahrHv/neteZ49ZA7jCG2D30ajJfKsheI?=
 =?us-ascii?Q?4zbokv6y0IjWjVJ4SNFnXGleKQ2UKbunAfDymjyHrzHJk+XyY1ZcPhAvQzW+?=
 =?us-ascii?Q?QrunNYpAeiGlm13U8KkOOMZZbcKP5MesGm9rULHcSU4W3rdOSHinCdJz8mRD?=
 =?us-ascii?Q?uS8CeyU3hw3drzGza0oP4SsT+ilKjIbFfONRNFAKt3XJvabtLha7sv/FbQoo?=
 =?us-ascii?Q?7Bk5vdd5ihpj96UAD5nXtyNmUl/s1+TIhorozoTtNZC3aI6hOpz1rORezQcV?=
 =?us-ascii?Q?xpVVoWLxC+x/cqwNFz05tONKEpAUtHu1b9qFp9JNQg1tx6k+b9aP0AwAcR6t?=
 =?us-ascii?Q?aLOBWqbWpOGgFZF3nuRGS48ZalHxwLf47ERvmTHbnY9Gz4Ly0vt+bctu4hfX?=
 =?us-ascii?Q?ShaK2gnOAIPx4ds+e1laoAqvKZo/3lDcgKpcPMCOzYuBE2dihoymzmXZ1+lc?=
 =?us-ascii?Q?aCAo7yxMZ1JsxYrHRxvWZyd3xpUn5JVDqFQ/PrPg?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd6fcd7-5ad9-4a6e-e92b-08dcdd2f19cd
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 06:55:54.8543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2mX+xu2gmnSSeKAUQYCO2vHUBA7ngcUGWFjVZOnispp0uggNcSkXgxNYMIg7VrPkejVaOAwiBx5w3zutwYlDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5170

Fixed some confusing typos that were currently identified witch codespell,
the details are as follows:

-in the code comments:
fs/smb/client/cifsacl.h:58: inheritence ==> inheritance
fs/smb/client/cifsencrypt.c:242: origiginal ==> original
fs/smb/client/cifsfs.c:164: referece ==> reference
fs/smb/client/cifsfs.c:292: ned ==> need
fs/smb/client/cifsglob.h:779: initital ==> initial
fs/smb/client/cifspdu.h:784: altetnative ==> alternative
fs/smb/client/cifspdu.h:2409: conrol ==> control
fs/smb/client/cifssmb.c:1218: Expirement ==> Experiment
fs/smb/client/cifssmb.c:3021: conver ==> convert
fs/smb/client/cifssmb.c:3998: asterik ==> asterisk
fs/smb/client/file.c:2505: useable ==> usable
fs/smb/client/fs_context.h:263: timemout ==> timeout
fs/smb/client/misc.c:257: responsbility ==> responsibility
fs/smb/client/netmisc.c:1006: divisable ==> divisible
fs/smb/client/readdir.c:556: endianess ==> endianness
fs/smb/client/readdir.c:818: bu ==> by
fs/smb/client/smb2ops.c:2180: snaphots ==> snapshots
fs/smb/client/smb2ops.c:3586: otions ==> options
fs/smb/client/smb2pdu.c:2979: timestaps ==> timestamps
fs/smb/client/smb2pdu.c:4574: memmory ==> memory
fs/smb/client/smb2transport.c:699: origiginal ==> original
fs/smb/client/smbdirect.c:222: happenes ==> happens
fs/smb/client/smbdirect.c:1347: registartions ==> registrations
fs/smb/client/smbdirect.h:114: accoutning ==> accounting

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 fs/smb/client/cifsacl.h       | 2 +-
 fs/smb/client/cifsencrypt.c   | 2 +-
 fs/smb/client/cifsfs.c        | 4 ++--
 fs/smb/client/cifsglob.h      | 2 +-
 fs/smb/client/cifspdu.h       | 4 ++--
 fs/smb/client/cifssmb.c       | 6 +++---
 fs/smb/client/file.c          | 2 +-
 fs/smb/client/fs_context.h    | 2 +-
 fs/smb/client/misc.c          | 2 +-
 fs/smb/client/netmisc.c       | 2 +-
 fs/smb/client/readdir.c       | 4 ++--
 fs/smb/client/smb2ops.c       | 4 ++--
 fs/smb/client/smb2pdu.c       | 4 ++--
 fs/smb/client/smb2transport.c | 2 +-
 fs/smb/client/smbdirect.c     | 4 ++--
 fs/smb/client/smbdirect.h     | 2 +-
 16 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
index 6529478b7f48..31b51a8fc256 100644
--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -55,7 +55,7 @@ struct smb3_sd {
 #define ACL_CONTROL_SI	0x0800	/* SACL Auto-Inherited */
 #define ACL_CONTROL_DI	0x0400	/* DACL Auto-Inherited */
 #define ACL_CONTROL_SC	0x0200	/* SACL computed through inheritance */
-#define ACL_CONTROL_DC	0x0100	/* DACL computed through inheritence */
+#define ACL_CONTROL_DC	0x0100	/* DACL computed through inheritance */
 #define ACL_CONTROL_SS	0x0080	/* Create server ACL */
 #define ACL_CONTROL_DT	0x0040	/* DACL provided by trusted source */
 #define ACL_CONTROL_SD	0x0020	/* SACL defaulted */
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 7481b21a0489..ba4540bcd7ac 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -239,7 +239,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
 			 cifs_pdu->Command);
 
-	/* save off the origiginal signature so we can modify the smb and check
+	/* save off the original signature so we can modify the smb and check
 		its signature against what the server sent */
 	memcpy(server_response_sig, cifs_pdu->Signature.SecuritySignature, 8);
 
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c91cf57f337c..6f76432b9159 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -161,7 +161,7 @@ __u32 cifs_lock_secret;
 
 /*
  * Bumps refcount for cifs super block.
- * Note that it should be only called if a referece to VFS super block is
+ * Note that it should be only called if a reference to VFS super block is
  * already held, e.g. in open-type syscalls context. Otherwise it can race with
  * atomic_dec_and_test in deactivate_locked_super.
  */
@@ -289,7 +289,7 @@ static void cifs_kill_sb(struct super_block *sb)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
 	/*
-	 * We ned to release all dentries for the cached directories
+	 * We need to release all dentries for the cached directories
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 15571cf0ba63..6e4bee57baa3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -776,7 +776,7 @@ struct TCP_Server_Info {
 	} compression;
 	__u16	signing_algorithm;
 	__le16	cipher_type;
-	 /* save initital negprot hash */
+	 /* save initial negprot hash */
 	__u8	preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
 	bool	signing_negotiated; /* true if valid signing context rcvd from server */
 	bool	posix_ext_supported;
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index c3b6263060b0..ff694dca4248 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -781,7 +781,7 @@ typedef struct smb_com_logoff_andx_rsp {
 	__u16 ByteCount;
 } __attribute__((packed)) LOGOFF_ANDX_RSP;
 
-typedef union smb_com_tree_disconnect {	/* as an altetnative can use flag on
+typedef union smb_com_tree_disconnect {	/* as an alternative can use flag on
 					tree_connect PDU to effect disconnect */
 					/* tdis is probably simplest SMB PDU */
 	struct {
@@ -2406,7 +2406,7 @@ struct cifs_posix_ace { /* access control entry (ACE) */
 	__le64 cifs_uid; /* or gid */
 } __attribute__((packed));
 
-struct cifs_posix_acl { /* access conrol list  (ACL) */
+struct cifs_posix_acl { /* access control list  (ACL) */
 	__le16	version;
 	__le16	access_entry_count;  /* access ACL - count of entries */
 	__le16	default_entry_count; /* default ACL - count of entries */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 131f20b91c3e..c6f15dbe860a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1215,7 +1215,7 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 	req->CreateDisposition = cpu_to_le32(disposition);
 	req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
 
-	/* BB Expirement with various impersonation levels and verify */
+	/* BB Experiment with various impersonation levels and verify */
 	req->ImpersonationLevel = cpu_to_le32(SECURITY_IMPERSONATION);
 	req->SecurityFlags = SECURITY_CONTEXT_TRACKING|SECURITY_EFFECTIVE_ONLY;
 
@@ -3018,7 +3018,7 @@ static void cifs_init_ace(struct cifs_posix_ace *cifs_ace,
 
 /**
  * posix_acl_to_cifs - convert ACLs from POSIX ACL to cifs format
- * @parm_data: ACLs in cifs format to conver to
+ * @parm_data: ACLs in cifs format to convert to
  * @acl: ACLs in POSIX ACL format to convert from
  * @acl_type: the type of POSIX ACLs stored in @acl
  *
@@ -3995,7 +3995,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
 				       PATH_MAX, nls_codepage, remap);
-		/* We can not add the asterik earlier in case
+		/* We can not add the asterisk earlier in case
 		it got remapped to 0xF03A as if it were part of the
 		directory name instead of a wildcard */
 		name_len *= 2;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 78b59c4ef3ce..a58a3333ecc3 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2502,7 +2502,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 			}
 		}
 	}
-	/* couldn't find useable FH with same pid, try any available */
+	/* couldn't find usable FH with same pid, try any available */
 	if (!any_available) {
 		any_available = true;
 		goto refind_writable;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 5135f7b2e8d3..6ea476cd8fd2 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -260,7 +260,7 @@ struct smb3_fs_context {
 	unsigned int min_offload;
 	unsigned int retrans;
 	bool sockopt_tcp_nodelay:1;
-	/* attribute cache timemout for files and directories in jiffies */
+	/* attribute cache timeout for files and directories in jiffies */
 	unsigned long acregmax;
 	unsigned long acdirmax;
 	/* timeout for deferred close of files in jiffies */
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 054f10ebf65a..4373dd64b66d 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -254,7 +254,7 @@ free_rsp_buf(int resp_buftype, void *rsp)
 }
 
 /* NB: MID can not be set if treeCon not passed in, in that
-   case it is responsbility of caller to set the mid */
+   case it is responsibility of caller to set the mid */
 void
 header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		const struct cifs_tcon *treeCon, int word_count
diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 1b52e6ac431c..2a8d71221e5e 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -1003,7 +1003,7 @@ struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	 year is 2**7, the last year is 1980+127, which means we need only
 	 consider 2 special case years, ie the years 2000 and 2100, and only
 	 adjust for the lack of leap year for the year 2100, as 2000 was a
-	 leap year (divisable by 400) */
+	 leap year (divisible by 400) */
 	if (year >= 120)  /* the year 2100 */
 		days = days - 1;  /* do not count leap year for the year 2100 */
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ebe1cb30e18e..b3a8f9c6fcff 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -553,7 +553,7 @@ static void cifs_fill_dirent_std(struct cifs_dirent *de,
 		const FIND_FILE_STANDARD_INFO *info)
 {
 	de->name = &info->FileName[0];
-	/* one byte length, no endianess conversion */
+	/* one byte length, no endianness conversion */
 	de->namelen = info->FileNameLength;
 	de->resume_key = info->ResumeKey;
 }
@@ -815,7 +815,7 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 		 * However, this sequence of ->pos values may have holes
 		 * in it, for example dot-dirs returned from the server
 		 * are suppressed.
-		 * Handle this bu forcing ctx->pos to be the same as the
+		 * Handle this by forcing ctx->pos to be the same as the
 		 * ->pos of the current dirent we emit from the cache.
 		 * This means that when we emit these entries from the cache
 		 * we now emit them with the same ->pos value as in the
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1ee2dd4a1cae..d319cd8839e7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2177,7 +2177,7 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 			NULL, 0 /* no input data */, max_response_size,
 			(char **)&retbuf,
 			&ret_data_len);
-	cifs_dbg(FYI, "enum snaphots ioctl returned %d and ret buflen is %d\n",
+	cifs_dbg(FYI, "enum snapshots ioctl returned %d and ret buflen is %d\n",
 			rc, ret_data_len);
 	if (rc)
 		return rc;
@@ -3583,7 +3583,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		/*
 		 * At this point, we are trying to fallocate an internal
 		 * regions of a sparse file. Since smb2 does not have a
-		 * fallocate command we have two otions on how to emulate this.
+		 * fallocate command we have two options on how to emulate this.
 		 * We can either turn the entire file to become non-sparse
 		 * which we only do if the fallocate is for virtually
 		 * the whole file,  or we can overwrite the region with zeroes
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a328b9dd145d..8814be932324 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2976,7 +2976,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
 
-	/* Eventually save off posix specific response info and timestaps */
+	/* Eventually save off posix specific response info and timestamps */
 
 err_free_rsp_buf:
 	free_rsp_buf(resp_buftype, rsp);
@@ -4571,7 +4571,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	}
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
-	 * If this rdata has a memmory registered, the MR can be freed
+	 * If this rdata has a memory registered, the MR can be freed
 	 * MR needs to be freed as soon as I/O finishes to prevent deadlock
 	 * because they have limited number and are used for future I/Os
 	 */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index c8bf0000f73b..b486b14bb330 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -696,7 +696,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 			 shdr->Command);
 
 	/*
-	 * Save off the origiginal signature so we can modify the smb and check
+	 * Save off the original signature so we can modify the smb and check
 	 * our calculated signature against what the server sent.
 	 */
 	memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE);
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0c64b37e2660..b0b7254661e9 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -219,7 +219,7 @@ static int smbd_conn_upcall(
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED:
-		/* This happenes when we fail the negotiation */
+		/* This happens when we fail the negotiation */
 		if (info->transport_status == SMBD_NEGOTIATE_FAILED) {
 			info->transport_status = SMBD_DISCONNECTED;
 			wake_up(&info->conn_wait);
@@ -1344,7 +1344,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * are not locked by srv_mutex. It is possible some processes are
 	 * blocked on transport srv_mutex while holding memory registration.
 	 * Release the transport srv_mutex to allow them to hit the failure
-	 * path when sending data, and then release memory registartions.
+	 * path when sending data, and then release memory registrations.
 	 */
 	log_rdma_event(INFO, "freeing mr list\n");
 	wake_up_interruptible_all(&info->wait_mr);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 83f239f376f0..c08e3665150d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -111,7 +111,7 @@ struct smbd_connection {
 	/* Used by transport to wait until all MRs are returned */
 	wait_queue_head_t wait_for_mr_cleanup;
 
-	/* Activity accoutning */
+	/* Activity accounting */
 	atomic_t send_pending;
 	wait_queue_head_t wait_send_pending;
 	wait_queue_head_t wait_post_send;
-- 
2.17.1

