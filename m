Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013002.outbound.protection.outlook.com [40.107.44.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3C81EE017;
	Fri, 30 May 2025 08:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748593545; cv=fail; b=cYunKIzYJMqp4i3Y2a6aj4zJ+oHJIwF/rQ8AO3P+J9/dN3EjpDWJbUPwgcjhAABPc85Ykmo9VWJcghSno8qNjngzpLb8fIsItNRvOIG2rR6fIOxGHcUQu1/bFydqbiWCFp36CTJxwWKcsQF21Sagg4Iv5f1fbrdkUNuN6POsoWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748593545; c=relaxed/simple;
	bh=T51YxWJMznErqnHLXoIHSfN/3ulV5VMWAA7afKtrhQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fcx5HF7IZU7eB58byeziYulf0kl7cUAMgNSJ7DbfPvuU9r4Mw9fRlAQg+lAelTmF/gTe3WOlMcjuy3Vt4XfBrstjbDFv/DfEI9Z0cYxec2q0OK5vu+5HDVsicaKf+jtikI4i1v1WuJs6Uvm1DWI6AkVj3GP7tpTJM7GWi2aTVls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jUiJ8ohO; arc=fail smtp.client-ip=40.107.44.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jUiJ8ohO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwhjVW7WuN3j5aDPDnyVg9/++NQOwUXdjB4ZYBbe61SEJaL1iRw5AC/Cut16lJOz+HOEhlpnG+3QQq1CbIPHT2r8p2VasWAwejmQFQpAgN3Bw4XOl6/gIB31Prmj7GClfVUoHMOSMYmx87l8br312/17KvI8pUtWkmpAHLQy/YCrnbnM9QGQLSDD4HoGPI6vB2SKv//8VuDFe2F4NgA9KDwQSPTizoWVzK3uNnxzKzl+4UeFkkgIQ6HQdWpL4z6uMWnDtmJu4n2hy5IldHYFKPYTlkpCB6IE0bvTgyCuFp+kVtUN+W+IT0doW5CTXmv6Izp3e3sw4BYa1mxiCWpTBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hfukbyTFJWXVuRlGdE5TTxZG9+HqUKqFJawSu5aeC0=;
 b=WesDChpQaaWsQuMGzxwrc9w+vk/+PdQRtqiLIfkUmWHb4UupH+YNU9CMUlYudO84whjcddLAqRdgucSvw7Co2htRCjSScw0KOi9NSAAMxm9DPTknqQCMGVg9nzmfnGfndANU9bhFWVSuU2+AarCFJuB4mfYZxX8/9YKTYsM5kx3xiUAOoiPvw6kX00bdt6e6mUVOuh0xAAzUAPA7P4FhCINu3NTxmF96nlXfrlHcLkBZkIomRkbl1RD5dxIiMS/tnFceLwvYwFvihl97cw3b9/tbZTMvop9PRDIFlvrBPXZ9CuqmH+ylqf10pk90RKXxMScFi3eUJ5GkwWRuOdft5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hfukbyTFJWXVuRlGdE5TTxZG9+HqUKqFJawSu5aeC0=;
 b=jUiJ8ohOl8vWvE5q1qlyQXceaJYdGDFoO3ZfwgLRJL3OIkYk9g+rl1O5JApPWtmsHppiqThHLZ/qc8ztPmdsGSy40LKR74nI7rEbE5KoDaY2tOtF9YBTMNJ8AJoLD5yy6C9z40Z2/xOlikWKGFlZl93mv8UZv3DWjrzuMiRVY//XSd8npHIwYYm4xS/GKir3MgrIprxeyKUhof9TP2hfLiY2l0d/ltH1DV/VoKHZ/3L00cXjqJQEYxOuJu78P59dmMAket64G2zI6TMV7HGE17GF5aQOp1E+nrSawwZa0MRDNApsLrrBuwOj78ZDJ7Took0TvkgkXgX8cKOnvvk+Nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
 by KUZPR06MB8028.apcprd06.prod.outlook.com (2603:1096:d10:49::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Fri, 30 May
 2025 08:25:41 +0000
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::8c74:6703:81f7:9535]) by SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::8c74:6703:81f7:9535%5]) with mapi id 15.20.8769.022; Fri, 30 May 2025
 08:25:41 +0000
From: Yangtao Li <frank.li@vivo.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yangtao Li <frank.li@vivo.com>
Subject: [PATCH] cifs: correct superblock flags
Date: Fri, 30 May 2025 02:46:14 -0600
Message-Id: <20250530084614.2434467-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|KUZPR06MB8028:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df599bb-3ef9-4b6d-2afc-08dd9f539033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yqf/IpsU+s1tBq6rV1VGSO8cCMeecVvSvAF3FF1P1LYoo7ytNwVdG0nETAWh?=
 =?us-ascii?Q?oPv1Fonq1yync28hWyMPugstbXW+3o32br3rnD6mc62XDYx2iiMkZaqhBdlU?=
 =?us-ascii?Q?dywgqfRx0mmizjm33ZWQu6b6pz7j0cw4KaLQBPmiSurok/gMHpcoLqIz6OuP?=
 =?us-ascii?Q?X1JJ5y2niwAUfTC1gEHIXm6IAZt7ApbDJaWCt8sm30lhOyBYitJvdH1q39mV?=
 =?us-ascii?Q?1HToYYJmxp+MnT8pVIKO1HVYJsM72q2Fm8mzLXgnwEwULRW4kif0GIGHG9fE?=
 =?us-ascii?Q?G4oi8gTUokLWFifoNeX9XbeWxX/8KsvfxgjAd7ji/vmpJSbQvheJ4ctcBXOr?=
 =?us-ascii?Q?ODJk/3XGxDcnTGVUWFJhJVqlm9Lnkge3msI+Rj8pxK4ptmT5KjoAEBDYB0m1?=
 =?us-ascii?Q?5UnSOwqq0lu+C5dqw1kfcB8aWmFBJpYCYPqDM+qDborYs3tr5qgBjYpGTshN?=
 =?us-ascii?Q?94zuS2LmTxtZ5pND2nkxInlgd0AeZLLtWPDlkTWLH0aoRGsPpak1VJ9FgQ6T?=
 =?us-ascii?Q?QERBZW2N9OL8FXGIHsHATm9p94Bs5HNfgfbSVcpgLMPhGFjQs4lhRtN1UbTs?=
 =?us-ascii?Q?bz7IO1yPof0wVub8Qp+fwC7WooyNvvDqDIGctqHtPUJQ8teY0OGHNdWT6EeL?=
 =?us-ascii?Q?o8pT9m967cz+9F2cQ/lkSRua3vDj87Zl164tHImGSq+4HSSDCxbO3P89Lotl?=
 =?us-ascii?Q?heQ9Wxz9fl6mBoK4VoiOMYc7BW5UfqsuFVb8C3OU2Y7xYSRGbNXzfG6BSCYq?=
 =?us-ascii?Q?KcH2iFz+Hnmj+mQMHmfdkXHKHaaXNnPUWLCVnqyo0KUZS5PbuTC9iQIWlc3Z?=
 =?us-ascii?Q?WJGepe2gmMZWCY4jyGIu4Kc/XIfURomhTiVWKrAJvRSa+OiuPdGl9uUcWkFz?=
 =?us-ascii?Q?n46g1xGDUAGyF8kjknGYoVTIjMoWH6H6ptUTTw87L3THLv6GyntaNY8KfIcc?=
 =?us-ascii?Q?QMyx0yV7IXuiiW7u2ZKDDdPx7dqBfqy2FyyxVdiPah3HI9mtDLb2XOu5uXGU?=
 =?us-ascii?Q?VOWjIGRLN+mUvjTjOindBQEsMW7AB+Z/7nIt5Mc4TUSq2SDh2LMhDYRM9Wxe?=
 =?us-ascii?Q?NFBipbihlJrTYE+s4ycpoaj7yWq6FhtJBVVa4uGXuFFDyktIzZlP1z1731jG?=
 =?us-ascii?Q?DPW1fpmAjsyIuet5Wk3b1YFj3T3MvONBzB2w+d+1T7ggh66W4SDUsuXNJNZS?=
 =?us-ascii?Q?Ow69eHlPG0ZOL8smNJ9f8Z30NxcbueX4eDCixeBhugSkDzBDvdCOyWt6NDJc?=
 =?us-ascii?Q?/cyhNIKY/r6TivkmuJLDlcxhHnf2igxnlN4TTmyNyPEzbQH0R6XSc1J4JMfQ?=
 =?us-ascii?Q?JCGcBMRbxUY/D5iI/NP4LyAvRx+vs+7KBy8852yBJOWzfhdb3RU/kEk9Q6Q6?=
 =?us-ascii?Q?0qxQv09meZ9vOOHm0lCyKmnQuHXMkNJtV2krsfliJNwXw32ZcQXfX2zHAeOg?=
 =?us-ascii?Q?KmCXUJF+7WR64ZjhBO9r7Tndq9nIbsHiU55NZAoLUyvUFzeo9TL2uA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5269.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SR1wCGhTCGXhTW4KTB7HfNhcM7OdTgJxIJv9MH3Xluu4dcPofoaYoENSmw5A?=
 =?us-ascii?Q?oSE1Ax3dkitRfyrdbMhQjm/kd4zD9NQIozjJPCrQMvZ4xZYMVeyhDt5jCbba?=
 =?us-ascii?Q?ZPRQAb95OVLBa/ol1hbdVXyRHKsrh6c60NRqfXodK5AFzsauIdJJZMkDf9mH?=
 =?us-ascii?Q?isOYNyL42nN+LctsPeysbdrZdxfh90sJ26yAZJhDb3Sr1vxpEGLuklVNr29b?=
 =?us-ascii?Q?rYZ/y1t0sh27l4BgRvAYefcGwZ6b/AEeNTq+AJAvpMWr3VGmw7mD27y/ijQX?=
 =?us-ascii?Q?m8Xzz5WFPtd52vOQAleivxTUpHsbEErw7zhy8vUypfcaUu6oQ245Q7rWptcA?=
 =?us-ascii?Q?65X+KY9Z8GcXMcr83//4z7a/XXHpKq+TVOFspJW4/pirnpkEOnIsTiI71bUT?=
 =?us-ascii?Q?WPeoxgnLQsfItSJBLnEixvm8fw++Bc+IZgKoRgUPnZJgXX1nvR1RLjDSG+NK?=
 =?us-ascii?Q?efdMwjg8XJB7Hx+eKDwnIK1hK8Kj65cyqSw7en2tLSUBJwmYNTNDR71pNlu7?=
 =?us-ascii?Q?Ql9soAR1WQawrGITwp3TboubeOf2QkkYxj4t3bzUQbeD3cJKtlp1jwtQsw2u?=
 =?us-ascii?Q?FSS1MSLqmD/aB20uAWOsge3nE7iUyA3B12a7GrfJU44jVjf/MYef8ZyzPwNF?=
 =?us-ascii?Q?BE/H40AtF3r+rMFYqU5tJFqoJu9HLO/l4c6DHl6Y3D9QVALqNgzrnGxeLuQu?=
 =?us-ascii?Q?SMCN+KZX7LV42LjpBuAy/CQX1VGjazM2t/879wBHkt0MI4YWI76JazOW6xdp?=
 =?us-ascii?Q?l96MdgcP+/uV7+M8SfzqOAzyAdg6NOhm/+um0mqDm1w3aVQASg55HUY5+Bbt?=
 =?us-ascii?Q?gWzDHQNhkcogaJ497g20+99FRTGowMcwnVZfXd8jvQ5kuBH32mq9qg/OkUEZ?=
 =?us-ascii?Q?oqGnVnWISPxb8IXbfqMdnfynUgbOyfPq0pHujevPNjwnFB70Gykr2jmdahYc?=
 =?us-ascii?Q?ol5wdW06ZGZuiRTJP9RcNDos92M04FgSlZ4UnIAyzKLa/aSRsdwDRsWpWUv0?=
 =?us-ascii?Q?bF/NtDs+V+KX0pZLBMO3+u8VeKALInF4iD+f2tUn4kAhlk/PdepSTLQhcAgC?=
 =?us-ascii?Q?UHNA/LzBUg5tp/sG6OffXAxC1b35IagG5Ucr0MJh0iwIvrfIx6pB4jsCpftW?=
 =?us-ascii?Q?sCJ6X1TBvnBY9eKb3dS4kLoHRsQW2LzaesDpQlj6gVRgQe3m2E/kdXiCU8wn?=
 =?us-ascii?Q?t30fvUOD9c6oWwSIZgBUGJlVZuqiC4XbXv2HgRWwtvKj4ZfV9e9MzzuMNJCH?=
 =?us-ascii?Q?3qv/I6uhXIdzNbwaJKi/qMtBFTgK/w+GnVYYJR+clL7ODfY8u7uEV1F3daKq?=
 =?us-ascii?Q?u8lKjUKVv4khsk6bAFmYtxa0SUeVITP6Z6lmgiwBZfuKm/kWpPzW73sK04D8?=
 =?us-ascii?Q?EGDXDZaIlnQnfUREB0h7oLagNqWwwhF8YTpHtLe6A2OmLY8xiJEm5N95yNUK?=
 =?us-ascii?Q?jjdjquaS9/N+ZSg1ymW5vZt7UGFoV0XdUr5+2BIx9tNNlxUrHlwtOVVzyfLg?=
 =?us-ascii?Q?/sV55p2VoKsTjQyAzlIAKXNkYnLJAYaF/LPKCucnxIf4yMAklmSLz0MNFB6o?=
 =?us-ascii?Q?UdvDNFv+j2pEOOvpcCmOhwbmbbS73tfutrg8Ghwr?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df599bb-3ef9-4b6d-2afc-08dd9f539033
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 08:25:40.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTFFaeMiYP6AiT1dhS5nAp/uQ/ujKrA135D1zQhtMcWuOzYxBK6E8xsfAymFwtwFidhQ38eQHLPmRWGRgktXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8028

SB_NOATIME includes SB_NODIRATIME as a subset. Therefore,
setting SB_NOATIME is sufficient to disable atime updates
for all files and directories.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a08c42363ffc..b4bc15ea33bf 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -996,7 +996,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	mnt_data.flags = flags;
 
 	/* BB should we make this contingent on mount parm? */
-	flags |= SB_NODIRATIME | SB_NOATIME;
+	flags |= SB_NOATIME;
 
 	sb = sget(fs_type, cifs_match_super, cifs_set_super, flags, &mnt_data);
 	if (IS_ERR(sb)) {
-- 
2.48.1

