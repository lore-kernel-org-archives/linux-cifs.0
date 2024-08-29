Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2043.outbound.protection.outlook.com [40.107.117.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59909192B62;
	Thu, 29 Aug 2024 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724932383; cv=fail; b=V1GC5epaQubFZpvDnqkusx8LM3sXD4x9DIW06Uzn9J5e44Yb22UcrxJpIclCyUXX94W8d/2XVVdICSyFbI4v7CR7ktO9Kf+gMa9XHkyco8X16m+4wuE1z+sZsRzF024RrbmiaqmvsGDzzlvm9gFQZmk1SSOhN5NMVm5bIxzdNQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724932383; c=relaxed/simple;
	bh=mmE0w11rwIw0N8gMKostfmbVMCXkvK0y+w0tAlh1QKw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BPgfyLwBb8KYtJPRDtIxGiPJTiXNYZf2sl8hesXKW3k3QjTlcVDva2Z/ojWtz5Ii9+zfah6WmDhjwlRKfHqltBjl8gm2you3xx7yr265S3PXIzNDRWRRrxgGLIcs8xFL3Ab83f6psl9Tt+D27+45+8T3K7H9PBrFDsFmMJGjSxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=NTO5IkGD; arc=fail smtp.client-ip=40.107.117.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="NTO5IkGD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4I/R7aSqJZ/x9nSe+5yLA4ISwPDo6SDqT8s2YS+vYBCTH9k17494Gx7f45riqKyxKoipre4YtjEhoXnay+9Gw8uFCDb4k/eqTJ6ZwTBMM37JLnLmLi7T2epPUZnGs/TXIhE5xf90eKnYrNdlGrtrP8bFZZi0V8rWkHnX9knsKwikUrOn74zOIYyj8xMb1r8Llgb+CoH9iEpFLFohQxSOITdRCgkBZ9kmmUvVadm3OY28z6iDuuEMoG57wA6GET4UTD+JevISQsUEY7I/Ei6S+klsnEiYlg3knU7Tcedr/T3TlmDd+Rs9glu4N+2VnfjSROyqM92Ts23an314N0P7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJllGIdoxQgatApmgBzVsruqBRWXL1N1oNnVIJ74RV8=;
 b=fAScDUZhyktEx4eNMJRAmPBSqnF9+ggLYAqhGKTPG0h5HDQJ/ifogbyQ3JRSYmsQYgtw5SyEBw6hJjh9lVEcXX0obfgFCV8AtrP7M3wLIcVXrMoFdJlRKUHnKErIM60KXqITEIALguDg34qM9sQsMqDy8btcl+oPCLDXNIISHYQCxol/ezpyfVvY6i77uUf6d6JlxmUCpmv1uEyzECbTX0gYK3wrWfyEaE4q6ygQzsK2q74RxjO5jscHlaIhUs+NozhmdKZUKAejKNNg+ycPPPiaStfHe4SzciCaRN3dNABfTvY3O4OqwhbaSgIDXJsWIwngZozl0Vlv646b+JMNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJllGIdoxQgatApmgBzVsruqBRWXL1N1oNnVIJ74RV8=;
 b=NTO5IkGDXXlhXTq+V1ogvj0Wrvq/VRGiYDiSF7YRx+PE3mzk6Ht9VyMi5AMOhRvbQdnJjfza8en2K37X2XOVR0eYZFOQSVbWlwoplttGLlMUn77Pt8KWaBGZHSarKgzfOmLBf+VsQPH/GGtjHNkfnA7pd51xsHxLwJIS6yduJuezOlrwCWQ7JBgCvGXTb44O33iMlXieyOl1rg/6eXyANQn48nhN+UmF4pJraKOL9YG2zKH6YhdalbJ4a+TJLahSQdihFYrB1tcuuX3SsY93TDjNm7AmfLU+wx70mm+qCNJfxS/6tYoZJvrafkXLBF9sSBU7Lbd63xxYtGNzMdqAbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB5709.apcprd06.prod.outlook.com (2603:1096:400:283::14)
 by JH0PR06MB7150.apcprd06.prod.outlook.com (2603:1096:990:90::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 11:52:56 +0000
Received: from TYZPR06MB5709.apcprd06.prod.outlook.com
 ([fe80::bc46:cc92:c2b6:cd1a]) by TYZPR06MB5709.apcprd06.prod.outlook.com
 ([fe80::bc46:cc92:c2b6:cd1a%4]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 11:52:56 +0000
From: Yuesong Li <liyuesong@vivo.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yuesong Li <liyuesong@vivo.com>
Subject: [PATCH v1] cifs: convert to use ERR_CAST()
Date: Thu, 29 Aug 2024 19:52:41 +0800
Message-Id: <20240829115241.3204608-1-liyuesong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To TYZPR06MB5709.apcprd06.prod.outlook.com
 (2603:1096:400:283::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB5709:EE_|JH0PR06MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: c99f5b02-d50b-4e11-8ae9-08dcc8211f55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A6DnLxtSZWmeEBM3nE1EZI+0pjLazGGCnZWr/3stRLLrgPgmgSSzqqO0mdtW?=
 =?us-ascii?Q?me7v3p8LQ6HdvooylJsspKhQSPKDReRWfva8K2QKperw0/8wpR17nCcCiFvN?=
 =?us-ascii?Q?btBC4tCjtCheD8In12KxATUZLtW4TnbPmA2XLxaNGclsgHgFY8Qa93hMi1OV?=
 =?us-ascii?Q?O+xYOINUCO5iuMhUj0ab34ySSp/j4iDxvvE6KYbm/YQvHmEdyBoP4nQdlGEC?=
 =?us-ascii?Q?t19GhwxSgApmMpIU+NXsZ78Ez29qMfYnMubJaEOx8OYrukyYHbLYUs0a+O/l?=
 =?us-ascii?Q?iUBUWRuqHB/kdwZP7XN51aqOND1bxPK31hD6pzNNZh9VNr0psReRzCKP0diW?=
 =?us-ascii?Q?nMyvyT7ehYKN6/Rdk+8LFmSv/7GxbgRPrJsnczSG3xsyGj5+npkIqlso0VX4?=
 =?us-ascii?Q?uqNkR5G1OGXOi7yFOVzkiSSxgu+V86siB4cw+UBcGPHNVvFgjQok1l/sL6w4?=
 =?us-ascii?Q?XVUj1BzzSZ12Ok4dGOmX2rFaRd+go1r6VOfkWWd/4W/byGNZA8K2r7ssermy?=
 =?us-ascii?Q?fZRMkLoh7Lq4dC0sp0Yody/CaHAEgGw4+B2UXmNXsxhPZz6hTSqlEBqPlkat?=
 =?us-ascii?Q?CMTUtqXWYWCR5ODVV/JGIGKmNoNlMRGYWsN58BmgRwCjOhSn2mpGtDw0WUOq?=
 =?us-ascii?Q?Rh6CJ8hTDD4E/sz4KprQ9jUwGxEXYqSyRRrnGi/qthYdTYVsvaX1uZl5bo5v?=
 =?us-ascii?Q?Reek/HQOzUJ1dQW3KLwooCEsL01AwCuiRb7P9Y0ilFgY/hM1giBpOdKRe+WD?=
 =?us-ascii?Q?fowbOgbBv6cVkww7XOU98qqZe81UA69+gR51lFbSSVsBHznebCAkAGMPLXXo?=
 =?us-ascii?Q?NV3WNjmvbIJ44aGp2LHS83PE7yqY/RH022QV95YNHMQegePEkncyUsSvyXx+?=
 =?us-ascii?Q?oX/RxXA2spyGl4ZdZPEYrXetD2p8rOL+ZPEw383+pAc+hW5bodCXP+sAeHdl?=
 =?us-ascii?Q?i0GkO39FMHbw9/gfTUVu9IfcYOzNIPtk32M+/ERDz3nV9sioQwn9mfvcs2h+?=
 =?us-ascii?Q?ZLAnnrAteIvqBdC0wKHWdRGDEn5TAkApjez4Z8zplneXGUjO6E26o3yC+opa?=
 =?us-ascii?Q?lPfCDlknvvSmIt4etrw+Hv/ZQWc7d1oJcnvR5kl+upU8iCXtnI5htlhqoLLz?=
 =?us-ascii?Q?GEfX+56baUFpy+3BbmIXp4EJZJx4SWlMVvaMun0IXLawnuUODw4fqWlnXrwE?=
 =?us-ascii?Q?VBG6a2DKEzy4e8URQyGUvk7ACKfmbFfyFOnBg6OuXVJ1M+PlmXsmseV8ylXw?=
 =?us-ascii?Q?K0BbDtKdQbudd+jesoARae0OTTG12Jrf0e9PPR+cPRXQF1n7tZiBeTe6KIbf?=
 =?us-ascii?Q?+Z2lhOBqLhCt3DpZ4ERR04iH9pcDVBbI/OVAMtxW7kyZ4Qj44ozsGTr/y7RP?=
 =?us-ascii?Q?k9HPhdfpMf4bPmY9tzss5SmVF6X6A0/T3uI5Y5pwPvjT67TC3w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB5709.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zLWLGdBmmlPgrciz69+cGkHeAu5y3kDUvEcGKp8PADgMittD6KuOsXgnAeBV?=
 =?us-ascii?Q?MvQHDGccw2zR8rVjK3ezOnT6kR0UOxGpjN9CYxs5BrwaxfJSbPBzdvaTbPAj?=
 =?us-ascii?Q?WHgxo2FABPxo81dfst6wA35AOfCACKeWh9wbIJtK1mNbp4N0VhmXqidbWKfN?=
 =?us-ascii?Q?K+R/B9ZL/HgyFIGjxH5V0s50t02cMyUOcCDKXjDdWibn+hOeUw0Qq+rNXOdH?=
 =?us-ascii?Q?Pk4h8bm6iB5fi2VcvV63kwHaGbVa65e1hDzLPC1NLeUz622wYlzmRB6W56+X?=
 =?us-ascii?Q?M+7flkeejGZE0rPe+8x6Rf5DQ/AXH+o6CfC5Xmmg/L2S/O52HOgRsaBrIjwB?=
 =?us-ascii?Q?zjNp6qpCaaaaureymql/hDYuy3cVeSPbHzoXt7Xu8ymIoR4KA6RacDNA9MHh?=
 =?us-ascii?Q?kmCXdk87FKicF2y0k3n6nPlXFGWKwinuVopHNXCuNuY/pFj/MVM6wJzxdm1s?=
 =?us-ascii?Q?l0vj1D54LV+nv/f23/6cVycfFaV9epYGvE3JckGjTmLRbiMWt/MZiuWqp/x7?=
 =?us-ascii?Q?Gu8tA3e7raFLuIxEBb3wa+PmXDvB9G3j+Iy/Q9CzRvmRenZ0Qh6b/bGhsuWq?=
 =?us-ascii?Q?mYfpXzb/8DRzA6+Svdqj97iznyAP/ZBFjzyBtNFF5yUU7v8ulu2tgkoNrQQY?=
 =?us-ascii?Q?0W3t8IRSFN+kFP1MfE/D1XeTG/1u0li0wSnDW9r+dynvxx+taz2MqYgCPKpZ?=
 =?us-ascii?Q?4a9C/jN5u0qvUUVaaugUVQgNUv3BcxMcu1dkJInYBeac2Tah5yf4w3uNZNfQ?=
 =?us-ascii?Q?NCJT+6KIMhjKXjBshHI/xqlPVCy3cfoY+EXCGfyA7aKcQ/bSy5lO6fA+tugn?=
 =?us-ascii?Q?4Lvp5WraSF34OffkA5XCe5YfsLPynUMqi6yTGKRli5qwIqijWbX33ya6TVKH?=
 =?us-ascii?Q?FB+X0ML+bWqKT2FE6vNO50lqyTgeVsFTS6BSI75EcVcZebDZ0mD6eyx9KcRY?=
 =?us-ascii?Q?eSHh+Y12My5hBQKGbLNH3LRPK2YRA1vZi7YYjD04eDydodaKaJiIzR/U5d/J?=
 =?us-ascii?Q?sR9X3divMv7MO9LZnPNsBdX+ASVtn3N8Kf5zAcKvPAelDQBIaxUBoZAd5PpU?=
 =?us-ascii?Q?tvuH2sonh1kRZjBi/Lnxf1lNCOn9gybxDdvTpfpUr9gPD4yAqaIoiLE3mXWg?=
 =?us-ascii?Q?Ho7JJzD2yKggjiTMDIe2hlrbYdZR/c70Qsb7BUpl25/cfOn1DgPZ8e19Fvgc?=
 =?us-ascii?Q?f914btmLzFJGbwHi4rlqW9r+u23vbPZaCqUwPvMuChc3jzlq25Pn6Pte8SwY?=
 =?us-ascii?Q?Vr4p7y4MiErMVHt+7yhLihVF34C5ezKzn+i0NJY3fOCykZa0H68xUzH5/Ksf?=
 =?us-ascii?Q?PfNc88bUXEwu4rqyPO06EgddeUx1Lo/jn8tY8LYvhUzSDmSDZ3IIp1e6OMvh?=
 =?us-ascii?Q?H0nnUb3VD6ReEHYD1XIWroyDCTYBFbWothPr6NIqaMe99LUUNhJnbTjUeafS?=
 =?us-ascii?Q?VlBcwYwnHSJroBWjzvw62lMGx05S14fpmZZx+Q9suiP2ETkMPC0/01+DlcrJ?=
 =?us-ascii?Q?lusYUMRyCePFRTG6UQLrceuVSG/OX0Akrb6qV24VvQEL3CQIiozn8wZrDgIj?=
 =?us-ascii?Q?XapcqKqI9WOcEqWoKYAEzDoFCfQiczu89Gz3WrMH?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99f5b02-d50b-4e11-8ae9-08dcc8211f55
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB5709.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 11:52:56.6759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppf26IpPcdZXNWyadg1BkJmMerXK2Kzp4YZ42uD7oudqKeTFrZRxbRz81mfUrH/8lSTklekkTZT3dV68vlF8Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7150

Use ERR_CAST() as it is designed for casting an error pointer to
another type.

This macro uses the __force and __must_check modifiers, which are used
to tell the compiler to check for errors where this macro is used.

Signed-off-by: Yuesong Li <liyuesong@vivo.com>
---
 fs/smb/client/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c1c14274930a..c51b536aa9ad 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4069,7 +4069,7 @@ __cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 
 	ses = cifs_get_smb_ses(master_tcon->ses->server, ctx);
 	if (IS_ERR(ses)) {
-		tcon = (struct cifs_tcon *)ses;
+		tcon = ERR_CAST(ses);
 		cifs_put_tcp_session(master_tcon->ses->server, 0);
 		goto out;
 	}
-- 
2.34.1

