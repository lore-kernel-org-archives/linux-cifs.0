Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010070.outbound.protection.outlook.com [52.101.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB73197A7F;
	Tue, 27 Aug 2024 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748886; cv=fail; b=T0fumyS8Rg4swZYdnhpsmEk/SfdQdN07m6i3izRUpGww+1toahE0CIoe+Fuvm2zp42mP3QDhRWqP3Cq8gEcFyGcxvykPuDQPArclnuQKn04xD+9MQm0S+B1/Mo3soE8v7ZMcQqwkGHuo9qK3ciYMzC9PV6T0x0Kzh27qWPS3BuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748886; c=relaxed/simple;
	bh=jgZBvFvwi2zzvu6/jDjHj0HUR8saQj6Xow8S4Oy7Gck=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dj/ExgGY4jRk5pHdP/iwt53JdSra8lXmCpueb3bo+ceVetUyleRXUaPmDCdM522pN+tR/wbEa0ApX8tHJ4KrGynr9QGKKaZhA5icejCfqNRSlPrUT8+ZXF5/nteaOrDucgztYjxlpZmVuc/02+CCxylpsjgekg/t6eNdtvxxI5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=CtCo6O2k; arc=fail smtp.client-ip=52.101.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="CtCo6O2k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHO2S23ee5mt6LZUUkUvFORf25Zu8Q6m+DQN5ZdxaaRnl6dfjCe7MCTu9P5L2x0oz+84dn0bmDWs9JfecN0JozXkj4sFTY3f2iocjbTZhWnoXUpeELO7hH4ZevO0FX468SDoQ57YZjZKEPSyCqT+a0nB00+kvsX+j5wHS5d4c9I7cmplbAnC+9ZklDmejKrg6Csxn6YiGgjIvNvP0NfvQibYZSNIyg2Tv8MMBFEkd24RsRqFGZYtuKY06oVLRRx6w3P8P/gg7K35T+vPyjBckvMWsOzHGEbVgJvAnwCRsNpHM3XqgRLjaSBeqHkPDEZcFjFdQ1sM46ViIHO4VvFtJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBHDloAr8UZRvJmQh8PlMUBzTBx4PRqNtOsVv8ssxMY=;
 b=d0LZUYAhc1veU7M3dDlR00M9emkp3hOTFPJNHWXjHaVw3EyqRtmm2/H0DsSWr7Z8YFXrmC419abe/9aV5GnuXu2dzYd0r3PHuKcVu6P2jA+ILuDPPZ6kDlss2xJGbIpo52clRItIgZ8ylBwchGjkrb8ld0zpjqM49cuRDU3qsFWClNqkcMzZbAAGBVCVzhPaLTNAWQoLXLKECBWVmGGxzrnVSb5pk648E156j69d/Au7CEuyvYMAAuCt3At7JJSoKgvplsQaJpCfO+r227rgZKQ3qLsvNiJf/Qo3IRz9y8/dulTVg5m4Zb8FKvqYXHp/yjR5U5bCsSqL+7h2KcKTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBHDloAr8UZRvJmQh8PlMUBzTBx4PRqNtOsVv8ssxMY=;
 b=CtCo6O2khE3kjyeLUELNpR/ofAwrPxHSOpDwZLx9PRWvi3bA+3Aek914I/xRxWHPunCM5PlKYdaHadHRRjg/UGfuWDi3LyGMdFn1Pk8cUbVEX8G6hEd/ti/rlYykSBjWT5gO/Ds8ul4zqqGMee2Cvyed6h2bb7obapeFqDc/eSvRpoQhgW9alETrV5vaFnENTvJCUwIlxophtIntYyNTv3Vc3tit6b4xpMuEekifAjqxOI2Z7g758z4jOXJXHZ3GLnXw6CB/0pD1d86GOuLOC6K9a4eTWt+WfX5KdQXtm+By9SFFqUNe+pSMbzHC4Kcck4lwjSvCkMQ0xY16+nmz5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by TYUPR06MB6098.apcprd06.prod.outlook.com (2603:1096:400:358::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 08:54:40 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 08:54:40 +0000
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
Subject: [PATCH v1] smb: client: Use min() macro
Date: Tue, 27 Aug 2024 16:54:20 +0800
Message-Id: <20240827085420.76655-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|TYUPR06MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a4755c2-5d50-413c-b1c7-08dcc675e2ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NKFrq8akPH1W49uayGmJyFSe3Zjdh4UChOZk36kXAr/437OJgYd2JIcSyN3j?=
 =?us-ascii?Q?iYiulrbpggPz4/laB5ds070NG22gNYFkS9jlZb2ErmVxNtaJ2Cz6OlJG/i2Z?=
 =?us-ascii?Q?FK6GvqnbqPterWgPngRxUGRHC6w4AXHub7ZdHjACIW90PFPUmbgeOXohIoup?=
 =?us-ascii?Q?ZKLulNYa9CQpy3+jT5pRD4YdN6Vgynl3MmEuAkyuNO5rftIixac2kruE7etx?=
 =?us-ascii?Q?tcrpmWYxr1TsnUTVhNQPJW4oGRseSN5q1YD9SZ9Z1ZOvFa0tJ6e+LvXGGLE/?=
 =?us-ascii?Q?jpmVpABZ7fsu0SsMIzOlVU6Bvs6EYhR+hCISLKlYhCac8RUflXqgaixSUdK6?=
 =?us-ascii?Q?QBswH9UEb0M9u+AF5PgiR9RVKHG4WhycRU/NOL8QCcfdWfGJbDQ6E2cOI4jR?=
 =?us-ascii?Q?KmEJCHR8QTpao/z6VhgpN2TuqHPlcJx8KZzi7TUkX0tZuk5L/J6GfK70s9zW?=
 =?us-ascii?Q?9Uw1Nn3315qouoEE1NRZcIA1oZJsoAkE9+Bx830BCL9Q+OFxTG02Lgsx1QVl?=
 =?us-ascii?Q?+9mrIRVhjGfRvhXhpMn3WrIsNvmJQVCdXv85owpYC6yDSbfW1B6mrE7rq8V/?=
 =?us-ascii?Q?tpXzNpsP7mVbYB2bL8DVVgMM9gTDwqMlHF7qNc58aBjYQ6k8I2FqdRkZlwXs?=
 =?us-ascii?Q?QrSKDk9vWmv33LDGJs5+wlBa0dAq5bVIE2v/un64EJb/R1g86ytJbyb1mv8Z?=
 =?us-ascii?Q?rXr108Mi3FlEO4pFAcRB96VjXNvRmU6Eyj9Ywds/Hi1XvHSye9iuRpDlv3dC?=
 =?us-ascii?Q?Vh7ytpzrIUKQ5Wl1J2HyuGMdlMYZGrWWKl/SSzcyf1e+549WHzUwlZNgbAhu?=
 =?us-ascii?Q?Mky1hiEUgHdn5wEBQUYz+K8u4uND6457zTmfqthW9FLrSHx68d1OnbUtCsvd?=
 =?us-ascii?Q?z7fp55JhpQfohmVshdFBgxersVIY8dOW8LBqsRrQxTJEfteZYYtmS9sYM/Pa?=
 =?us-ascii?Q?NPzRWx/6ev/xnLRvPHs6ll55HQG4YgijDtyDWDFn2bFnboDfMxg2l8kCGtGg?=
 =?us-ascii?Q?tu2HTMR239yD+4YFOBxirw/1hZmWRwyyflofGdJRWH9zbdHw3Ae4RuaPjo+q?=
 =?us-ascii?Q?1F0OxXRZ7Bc56YiPIDxAZD5Skyzoe5AlvDLAPI4ynvoCe5oAbAWkM2bFf71U?=
 =?us-ascii?Q?ZxffTGysXEol8gHJnm41D+O/hquDPPZ3zYVh9I0xtDVowBkZxMVjD4JiVjg0?=
 =?us-ascii?Q?ynWdjzKdFMjJwjCu8Dn9nwZqEWPKaPg3rLUOIFy5rZiDIs1tDuKN3Unvpeqe?=
 =?us-ascii?Q?Wa20KxgoD3ZLFGL31iICCXl6Wv6p7fadD9IB2c1gkqHuxXIADB6lZtqmQ05z?=
 =?us-ascii?Q?lHxHsJgqCzQp1BOW7DY4Bb8PUAP2kscN+L4OCcpCWuymZaqF241pxCVFwacV?=
 =?us-ascii?Q?hdqlyi0+JghPvlK7IKhJHvXBp9QNqll2LZUOQLyw1kPYo3C8Dg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LNrKoL8ItTydkJpwiTIb4cPAsgYE3rihIN5+STedc7V/U13yQoM0OycXb4wI?=
 =?us-ascii?Q?cRBbOMg1n/mxeNWf5bsWcxJmPS6bkYe0/PLNfK28v+Z0jLIfRJ8/ZMlTFJtS?=
 =?us-ascii?Q?lNkLLGx23+jxTwnZbZRu243g25yZ469Ms7+afcinky/iv5ndwP8+wt0lBv1y?=
 =?us-ascii?Q?YlMN52STuJChfvY66/jVyXc4wxq4eCBFxnbvUbfj7NLoiqqRAxQTZ3RiRgot?=
 =?us-ascii?Q?5zKDBFJDRXT74804rL7HnPs/UHmRIeysqS4eiI4oKwu4Od4dVJi7BhYuQdXT?=
 =?us-ascii?Q?YMNB2qOc8pGb+QtmOviwyQGbl+YQOnenUmfIBIimrAtD9IGR7Y89wLGvLn+Q?=
 =?us-ascii?Q?yxPXkGgP50s+KRLtz8hO5a6P4BtYl6lf481QLxZSYDOiLfzjPVrOyMpf8QfU?=
 =?us-ascii?Q?OKh//Nv/mnyGj7oH32nYGf32rm5EtPdD0D+JktGLY+WblgpBGCHEQlb3EPEe?=
 =?us-ascii?Q?iJzzTvHa8UmmW29ejnBIqQLRJcwHzYN6AQDSMqQglBI83B9vXKhJsAwFm7UB?=
 =?us-ascii?Q?QoC7EOSeGJtdY5BXzvTKoL0ipdikxPQ4KjFT2T7H/PfT9W+4KcvddFAPPaXe?=
 =?us-ascii?Q?lNL3BGuw4y7pqPCguKRN8Shf3jFAUYmQs4W3hZCrsjsqAfgcF7SJi58/54iK?=
 =?us-ascii?Q?g0G5U6IU+sw5ad7qV/OrS/+JNSQUOd2IOi0skr6yDpCSZPVRUCiWOdjRvDIc?=
 =?us-ascii?Q?cN3L4kGoUKveiaaxgJrOqskuGlG39DStRRSUHxi+hnnzDBlYWi1DfE0yik7d?=
 =?us-ascii?Q?wVi40iMffsn4OLlNgomATgoReghRDhb8S513gWfc21DtZ2Euz/6S4/GiKRzS?=
 =?us-ascii?Q?xhBb8fdlLAgN5KRSWfyCLOS3v2Q+Kd9fUNFQXzJAwrxs2UYIVfGwldoj76KS?=
 =?us-ascii?Q?f8qvO4b9+ffzpqGWJMQYxgbWP3u/JopHFgat7KTtqXjpQidbQ3wiENSfVjc5?=
 =?us-ascii?Q?RAJjDzMrE6lSGLk+5aQeuB89EVvSiV1WSLfctsgz/Bs+A35PMmJ61/riah5L?=
 =?us-ascii?Q?LRYBo5anPfv+vKLC99fQBH+G/7aaUENiKafT+jvCBdgR82KM2FJ4JNN/DOMo?=
 =?us-ascii?Q?J9dBjfNgA2ovxAO2Qj2qmpOPXpuUm+Ejw2VcEvUJEJveiBZ1C4/ObGt+qe+X?=
 =?us-ascii?Q?bgO7c+NRaAlMGU6PyffAuW0dCJX/tq15G6DTR/3ostC7cxTUDv1K4BdA+WLL?=
 =?us-ascii?Q?/0CPATTCKY5V1//fvSdYrDHAr5bjtNbFGqTGV0yoPiqycy2xGcimXGEAjFgR?=
 =?us-ascii?Q?I5PiLf1pV54XETsZ3Q3U4JKcNEdo2Wo9qAhzJBGV1EMLRUDxTHK6cUn3yDQF?=
 =?us-ascii?Q?rZt4fgh/GP+XWy/qNGSapFco+8LAb4hpSP8tTBjFpzejCrYevQMCFSzLBLo9?=
 =?us-ascii?Q?T8Hl3zrEFSjD1UOwrhDeIt6T4JFfrhqAEPmUG5gh47z0+dBPunb7hrhKAi19?=
 =?us-ascii?Q?3HQb2O2SzGF+4dbgTegdRizlIMyy6OFdcBMP+4+iiwpfdCECMeCWyAC+rEJA?=
 =?us-ascii?Q?A3Ja+RtmcE/EMp7GiYM7v+KkHz2Ihzw+FXwcF0vdCXS9z2mVK90uV9NH5Lq0?=
 =?us-ascii?Q?fFYK2OO49IRuX+NoKVNPR1qMdEl4NLQtisCOYsaq?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4755c2-5d50-413c-b1c7-08dcc675e2ed
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 08:54:40.4039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBntiSCChFn0OAm/JQnnJMI5FWHaWV9fhrgBbyqAXdYfBc9XKPDxv+gvAi7JCsZLQpLZeuIIP+Lv33wXMip5LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB6098

Use the min() macro to simplify the function and improve
its readability.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 fs/smb/client/cifsacl.c   | 2 +-
 fs/smb/client/smbdirect.c | 8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f5b6df82e857..2f9a1bb6e21c 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -187,7 +187,7 @@ compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
 	/* compare all of the subauth values if any */
 	num_sat = ctsid->num_subauth;
 	num_saw = cwsid->num_subauth;
-	num_subauth = num_sat < num_saw ? num_sat : num_saw;
+	num_subauth = min(num_sat, num_saw);
 	if (num_subauth) {
 		for (i = 0; i < num_subauth; ++i) {
 			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7bcc379014ca..f307122b59fe 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1584,11 +1584,9 @@ static struct smbd_connection *_smbd_get_connection(
 	memset(&conn_param, 0, sizeof(conn_param));
 	conn_param.initiator_depth = 0;
 
-	conn_param.responder_resources =
-		info->id->device->attrs.max_qp_rd_atom
-			< SMBD_CM_RESPONDER_RESOURCES ?
-		info->id->device->attrs.max_qp_rd_atom :
-		SMBD_CM_RESPONDER_RESOURCES;
+	conn_param.responder_resources =
+		min(info->id->device->attrs.max_qp_rd_atom,
+		    SMBD_CM_RESPONDER_RESOURCES);
 	info->responder_resources = conn_param.responder_resources;
 	log_rdma_mr(INFO, "responder_resources=%d\n",
 		info->responder_resources);
-- 
2.17.1

