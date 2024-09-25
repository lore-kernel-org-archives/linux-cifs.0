Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2060.outbound.protection.outlook.com [40.107.255.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E2114B950;
	Wed, 25 Sep 2024 07:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727250220; cv=fail; b=CgTgjKBnuhkdjGAO1isZDr4k9rwlELinQYHDOuuPSg5ADm/j1ExM5svvXrRzmdDcsT/GQebhCiuQnIjS8C7jX3znE4WUmfmTV4IXPx59JFTKDyp2WHdt3wvGnEc0DG1D+4G9SdrvHj81iSkqCSRJRyPkA0Awl//gnlkpYOzut4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727250220; c=relaxed/simple;
	bh=BpMl4aQPG3scioFVv+yLj2+gCP8Mjl1P7TMxLxQtlLk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=YC2iJH0Fe1nMLGTgMRk3cLYuRK+mRVIfa4XNXgftXpCSWBUubEmXqHcUdJtQ54qhm206L7NW78Bc8Eyac1pq6uCs9Ey0105oaUKSS2dH6Aw0bCiwsB0YYBd8Gp9RhMs6olxRA5ab9xNTbM1FOd7Dzhhu/XpyP1NcU8tXf6zYqD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dHSvTKDJ; arc=fail smtp.client-ip=40.107.255.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dHSvTKDJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDYkcatae7fEK6lQ0DxVhxKRlVPATOqRdggQIaoZqawEH/urpRk4Wxw2PtxsGiA/UmAjon3ObjVIGLDap63ehnoJIDjzAJgCiKuoGXuKyi6MnEOTZEQFslwtHJzjInp0iSX0DwKj0g4E5TWJs5kSs5sFOwxPyzI+Jd7UyhRprUwsgIFhUJNVuRtxLQ8fmWlF4ncYXC4wACY1eF5JKR5TtXE1gny9fsCcOk1PYF6DqVh2CqgN6FKlqPvRdsPAkn1r0StAXc5Ce7hd3Lm1bp4cPUEtLu1qOxL+5iExixH0LtKa7zvAAVaqHFFW5QRZE+rrS1nXvY5ixPzWkv/PGRsMDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMb/Ams0ip0tKt7sLSYRElNsoRy/0T4TpsTXhBOf2RQ=;
 b=WQ1pmNcG2C65JYbrp6JrLLToTmTgrNzjhxhv0fwEKWrGtHWW+1miIxWgrwk8YqNxLFq3DoPQCQk7fucYaDbs+IBsRPZBjc49XSXlJUUXxsMrtEIMx0J1yAzKAENsLPhCvW7v/OfFrD9aZhDeZAgV2rghcF53W3blVjdJTCi2HNYfftx/KqM+2X/Q9iziGyUe0HYlKDVtzz6Z/Olj7vZVqvYBvGW2VbJJCRQR1Tlb6II5QF+OZh0Nwyv2TOHauNNQg2YaYdvgHkdvxlP9cUSylB3+psdAybpj7LNh+3vPSWObAqRseetNczdkCai9dwbcQvNDTfvQE5J7/4VdXDIyzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMb/Ams0ip0tKt7sLSYRElNsoRy/0T4TpsTXhBOf2RQ=;
 b=dHSvTKDJwFeEWwh6YeUfUtdoTBV+j8A+NAXD+KVnR2R6atCOeFrTLDL2wwhPOWedkO/7m91UUsiipOZNcN7SEOggBOUWycIYXBMsrEk8r5Dwl35aMJWflf+vYA+pxLm/IZYm3eGTBAYrmbU4LmowgB9UnJxd/IdnrrV/dtq10IIn9CbZJujkzsusvhx09u5hWUW99XejpK+aUtmdttE7agRss530RQYW/Tun2XwFVsD80LywACC08Db0wqeX7FBjxS9vZSWLVEckqGk/6PeN18pueCpGmUseNfezEkRxrSYpTj0gc5EFrnV4voWZ6Mx+RRXOpwPeAysp8EziyL3uCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by JH0PR06MB7128.apcprd06.prod.outlook.com (2603:1096:990:8e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Wed, 25 Sep
 2024 07:43:35 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 07:43:35 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: linkinjeon@kernel.org,
	sfrench@samba.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] smb: Correct typos in multiple comments across various files
Date: Wed, 25 Sep 2024 15:43:23 +0800
Message-Id: <20240925074323.9823-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|JH0PR06MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: 56818eb3-81c7-437d-125a-08dcdd35c2c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dliF1T5HIkNjxCpHLwpTaRPXx90vWFMjGW6umv5xrzYzipfeW2nO207GHLEM?=
 =?us-ascii?Q?z9vfbX2OM8y+4S20aayRPeVgyScXhytubs0tLaDkSPXl11zrak2Az3yQYbQh?=
 =?us-ascii?Q?WmoXa4tZpsB8JcL09YVDq3Ur60rz0oTFGyWfkjK9GusfLJYsqPUbLEGi+T98?=
 =?us-ascii?Q?3TvVtjwkT0L2kuXaZ7/CX5tC008vMrXXQpJfDHxLjT8E8wzHyNy1RHmQzv8y?=
 =?us-ascii?Q?IwF83n0TysQDln6/J4cEJRweqjIw6q1H4lrzTKmFx528YB0aTcXkx/wzydQ7?=
 =?us-ascii?Q?y/YFpbV+PK8fznzhmkvNj97FnWoC/psAOIx/INroKx0Zvp2GWlb2U57rJ52c?=
 =?us-ascii?Q?LK0ir1e3jrnIjhknTR4HCOFjhDgc064ENMyZN+A0RlBH+Apc6ST6RMay7UvD?=
 =?us-ascii?Q?rDfDIJzwQe8pVHxsEhYh6j3rGlXZA5pfuUyYSGZByPgiI1lRuBmlCIoSZ6ff?=
 =?us-ascii?Q?OOqdUvR4G5qHDeaCMmGkiMUkKS+e6BclHabPEs5IBTgk4YFgbtNK73icidJy?=
 =?us-ascii?Q?3i1caMa0pbEfhM3d9rjYspGjZRQlv/HUGhErvc2wDieu972UMSaVJivrrUZZ?=
 =?us-ascii?Q?DvwTX8uYlzCIGUGSMeEJk6MLhRp/8bxdJ+DYDmwMKE9KP7EnzEXHAO7v7BnP?=
 =?us-ascii?Q?dfc1ia84wKww+EIKUJ5GhW5hqLtqvgAtXKRCrtqx6brX3dk0m8wHdA+njKDa?=
 =?us-ascii?Q?zP6IFwZVi0KyWHBKzkU7WAEsSuXyphPO/M+TopBf8L6JMiI+H9GHQwzHFROV?=
 =?us-ascii?Q?3HtJu3BU2t7OKL+dbSobmVXZuiGJGySIM45TCKHwU9SE3qa/VyHiDzgZ0inB?=
 =?us-ascii?Q?2bjsZyQeoKx5ezZNmYCmGOuZeyTvtZhN6sNueLS10qYTzD3CbS6iNwy8c5kK?=
 =?us-ascii?Q?S27xZQjr+16ZHDkT8rCdvPW42Eng11971zvoQ2r1LtVX99bbHtxQblN5Yu8C?=
 =?us-ascii?Q?LNFIetgZF/5zSIxuwKylCVtL2+09A0Chfbdy9jM2A6+e//IE2CVdiJqtEbiE?=
 =?us-ascii?Q?6jyIHsQCNcrItlfyu6ypLQv2embOoFGgIEVxkT6XMISNQ/EU7vHwgy/ZAQfu?=
 =?us-ascii?Q?chvm4EF7qWpGuHgTZsITIswky4OovoUuniAACmrU4hMTGjmyhbfR6/Rrk63m?=
 =?us-ascii?Q?8SKvl0/NcCL/oxiJ+V8up3o9bsUCoVEmAMJXQt06UkMp86A+/C53/HKgy/ER?=
 =?us-ascii?Q?WcvHfR5ZVgX7VcUqBbKjcG18DJVUictD/mmVQDQyAS3wjtCjoaeI8nRxyX/S?=
 =?us-ascii?Q?ejvD/EhQqdbGdQwTiy1MoSABUvUyTDJarw0VvGCHp3z7JxCEFAriEXw0iaFo?=
 =?us-ascii?Q?HFck0OgRE/+K19QbGH7FZ/Pb0ltObrmn1Vd5Fsd0TwFluw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gOxQyMmVh1lkxKyVfp1ADhWmahgB7gpV2ArmVm22XmKRAtjL7dZaYhMGnl7Y?=
 =?us-ascii?Q?pYMV23cqRSv8D9zI59b+wOFkQ4owLsIcshGorKmjot2aM01iFd7gy+zhGGH9?=
 =?us-ascii?Q?FfQlnvasM7oKxUklBsxy9T7YN5cqdUv74KkZ6T97I1R9po35oFej/MZ7b+zM?=
 =?us-ascii?Q?ojgV65bmAURVCHeJYISIxldgY1MVrMGJvEEV+DOHpuOA4xHfy5rz6fbBPTYi?=
 =?us-ascii?Q?GditiTVYQOeA8JXg9Koh8pslR17UI6HX4idLUX3/Ub05oMPPRhxdNxW8fUoA?=
 =?us-ascii?Q?nIMQIkBGps/nAAIOc5iO+Ne6VvLuNevoH6kCVsPGdTRCfsQ90H/vyh2E6jRM?=
 =?us-ascii?Q?p/oK264r0bgpDD0ha7/l6/cPY+hIolGxWS3aeoi6oRWyKnXX2vi4cs9juJyJ?=
 =?us-ascii?Q?ZWBVHzcifE8+zwehtBtEJl8K5yPuYUeG82M5QH0i4ThbQ5Fjby0s+mXRNSac?=
 =?us-ascii?Q?CrI8IoUc+jmPE/wOVSIIowq8u35yOtGCqS/xwuHKnZ5Wn/SB9P4yTM6ZXoQq?=
 =?us-ascii?Q?iIo3IlsC/KFKXSFnZu6dn5R80aqHaiYcRffRFKHuDkXjW/cIlRpzy/znSElc?=
 =?us-ascii?Q?2RnOIBfOW2W25ocDMSNPmb8o0SScOGtJtIf8jXgAp61etTNQMGba9BFJ89wN?=
 =?us-ascii?Q?VJojH15qzLbbLsDxLdMfelraNTwDpyYzrUkbKf+urTkli2/AGndJGPq6XQxP?=
 =?us-ascii?Q?j/gFxs6v15zxmxeQ7m0u10RButpcjvJwxWEOWFTfICI3oPKrM9YXptS8Vj9C?=
 =?us-ascii?Q?eFGLRLn++h9MqkB1QziHnmLaxMQjCjRMjkOewIZhuQFYgDyz7fmG8ZLMyRmx?=
 =?us-ascii?Q?XfjfzrClSTYW8w2IHimRI/oQHW/iz+DM5+4U15BKDMaSfzqbbrX8SryYiRHi?=
 =?us-ascii?Q?eJ0SW/24iHggM7bl1zua+Rgjqn0a+mrfKurOn+1UtX42Hjicm4O4xIWUIAKA?=
 =?us-ascii?Q?N019MwOFpEeHiFVyPC9bQuQEuXxHbYy5kgfJZiSI3eJU7xjd9lsVhpaW/LR4?=
 =?us-ascii?Q?KXA4t4CvZhiaQhDw6pPQ6peDlHqCK5NYkSDkit6mBiqADExP67Vs98gMixWX?=
 =?us-ascii?Q?up6LfPCWaiNQoODC2hz+mCfDogUciPh5dEULkHnMBGTWEDzYjPPvjtuwUvDr?=
 =?us-ascii?Q?Cnk4ZB9ZosdqbGufIXXY9ouogU9fxgCm8/LqGWm4mczc2I9BhxSA8sVDX5RM?=
 =?us-ascii?Q?rXGv4nCPMvzwd0oZ/yOd3ub5qUDc6fA/o+KjPguuJdHl14wZtWPjMhn4oLX9?=
 =?us-ascii?Q?EXO1v2jQSujLoM2M0+UgD9KrGX1SPFl8uXrkZW2HTYVYps6/y3NZY2WOSRP6?=
 =?us-ascii?Q?rhCqm84LNm8l4Jbwyd25qyxcaDgULDDuRF5/Pf77XmlaBM9fWeajiE9Zcl+/?=
 =?us-ascii?Q?hGyf50RxYCrzW/Dq9RnVnVNYMESmX6UjexvTWXU1F0h6b5DqB6Oj9EYrU8P7?=
 =?us-ascii?Q?TN5GDeKE9/QiHxx0JW2UoRt96kB1+u2Zq1JWh97bucKDQd7UC+11VmdVEOtz?=
 =?us-ascii?Q?7RyjNRh+rrUsOeW8AO3IuJLllis4SqJqj9qnRM1CTu9SegjqRIdPc7pn5Ftg?=
 =?us-ascii?Q?U+H7E8kSBtbS87KDWE08RA3bgtDzl893JIB2riCw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56818eb3-81c7-437d-125a-08dcdd35c2c0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 07:43:35.1966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TytZVNn/4ZLaD/ScWnPxiA+awKglG63RJv5kwrGp1ojgl03jOpseWLDyeZGA064U8xwKsDEnHGJIhF8qtrP4YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7128

Fixed some confusing typos that were currently identified witch codespell,
the details are as follows:

-in the code comments:
fs/smb/common/smb2pdu.h:9: specfication ==> specification
fs/smb/common/smb2pdu.h:494: usally ==> usually
fs/smb/common/smb2pdu.h:1064: Attrubutes ==> Attributes
fs/smb/server/connection.c:28: cleand ==> cleaned
fs/smb/server/ksmbd_netlink.h:216: struture ==> structure
fs/smb/server/oplock.c:799: conains ==> contains
fs/smb/server/oplock.c:1487: containted ==> contained
fs/smb/server/server.c:282: proccessing ==> processing
fs/smb/server/smb_common.c:491: comforms ==> conforms
fs/smb/server/xattr.h:102: ATTRIBUITE ==> ATTRIBUTE

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 fs/smb/common/smb2pdu.h       | 6 +++---
 fs/smb/server/connection.c    | 2 +-
 fs/smb/server/ksmbd_netlink.h | 2 +-
 fs/smb/server/oplock.c        | 4 ++--
 fs/smb/server/server.c        | 2 +-
 fs/smb/server/smb_common.c    | 2 +-
 fs/smb/server/xattr.h         | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c769f9dbc0b4..9f272cc8f566 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -6,7 +6,7 @@
  * Note that, due to trying to use names similar to the protocol specifications,
  * there are many mixed case field names in the structures below.  Although
  * this does not match typical Linux kernel style, it is necessary to be
- * able to match against the protocol specfication.
+ * able to match against the protocol specification.
  *
  * SMB2 commands
  * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
@@ -491,7 +491,7 @@ struct smb2_encryption_neg_context {
 	__le16	ContextType; /* 2 */
 	__le16	DataLength;
 	__le32	Reserved;
-	/* CipherCount usally 2, but can be 3 when AES256-GCM enabled */
+	/* CipherCount usually 2, but can be 3 when AES256-GCM enabled */
 	__le16	CipherCount; /* AES128-GCM and AES128-CCM by default */
 	__le16	Ciphers[];
 } __packed;
@@ -1061,7 +1061,7 @@ struct smb2_server_client_notification {
 #define IL_IMPERSONATION	cpu_to_le32(0x00000002)
 #define IL_DELEGATE		cpu_to_le32(0x00000003)
 
-/* File Attrubutes */
+/* File Attributes */
 #define FILE_ATTRIBUTE_READONLY			0x00000001
 #define FILE_ATTRIBUTE_HIDDEN			0x00000002
 #define FILE_ATTRIBUTE_SYSTEM			0x00000004
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index cac80e7bfefc..aa2a37a7ce84 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -25,7 +25,7 @@ DECLARE_RWSEM(conn_list_lock);
 /**
  * ksmbd_conn_free() - free resources of the connection instance
  *
- * @conn:	connection instance to be cleand up
+ * @conn:	connection instance to be cleaned up
  *
  * During the thread termination, the corresponding conn instance
  * resources(sock/memory) are released and finally the conn object is freed.
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index f4e55199938d..38e6fd2da3b8 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -213,7 +213,7 @@ struct ksmbd_tree_connect_response {
 };
 
 /*
- * IPC Request struture to disconnect tree connection.
+ * IPC Request structure to disconnect tree connection.
  */
 struct ksmbd_tree_disconnect_request {
 	__u64	session_id;	/* session id */
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 246cde380dfb..4142c7ad5fa9 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -796,7 +796,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 /**
  * smb2_lease_break_noti() - break lease when a new client request
  *			write lease
- * @opinfo:		conains lease state information
+ * @opinfo:		contains lease state information
  *
  * Return:	0 on success, otherwise error
  */
@@ -1484,7 +1484,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 }
 
 /**
- * parse_lease_state() - parse lease context containted in file open request
+ * parse_lease_state() - parse lease context contained in file open request
  * @open_req:	buffer containing smb2 file open(create) request
  *
  * Return: allocated lease context object on success, otherwise NULL
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index c402d4abe826..231d2d224656 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -279,7 +279,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 /**
  * queue_ksmbd_work() - queue a smb request to worker thread queue
- *		for proccessing smb command and sending response
+ *		for processing smb command and sending response
  * @conn:	connection instance
  *
  * read remaining data from socket create and submit work.
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index cc4bb2377cbd..5b8d75e78ffb 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -488,7 +488,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function comforms the restriction of 8.3 Filename spec,
+ * TODO: Though this function conforms the restriction of 8.3 Filename spec,
  * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
diff --git a/fs/smb/server/xattr.h b/fs/smb/server/xattr.h
index fa3e27d6971b..505101a8104c 100644
--- a/fs/smb/server/xattr.h
+++ b/fs/smb/server/xattr.h
@@ -99,7 +99,7 @@ struct xattr_ntacl {
 	__u8	posix_acl_hash[XATTR_SD_HASH_SIZE]; /* 64bytes hash for posix acl */
 };
 
-/* DOS ATTRIBUITE XATTR PREFIX */
+/* DOS ATTRIBUTE XATTR PREFIX */
 #define DOS_ATTRIBUTE_PREFIX		"DOSATTRIB"
 #define DOS_ATTRIBUTE_PREFIX_LEN	(sizeof(DOS_ATTRIBUTE_PREFIX) - 1)
 #define XATTR_NAME_DOS_ATTRIBUTE	(XATTR_USER_PREFIX DOS_ATTRIBUTE_PREFIX)
-- 
2.17.1

