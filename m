Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazolkn19013009.outbound.protection.outlook.com [52.103.33.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95992DEA61;
	Mon,  7 Sep 2026 04:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788755509; cv=fail; b=l2oXeV+HNwtiRHUAF6QlD+j00TMhHZZzGQxINdeG1axSy/K09T8EcHabUYoGlcG2SlXAdHyk/m9Kn6K4IOGCcfhrirlQgYdz8UL7+cVi5MSihgvNACd3/hZ9QsMJI+jd4fHVMY4y2IQG6nyIcRKoBDnKU4Sfq4/0WOAGi7CAYHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788755509; c=relaxed/simple;
	bh=Ko2KuOz76uU8WieIEGYTvkkly3dD4mkExMvdgqdECEE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hdlqs7E3DAC9k/WyOqMqyJGlQFNnU1TmNoPaJ5lg34HQ5BxesgDf9AIouiN+10KTpqeKDCHulIRHJfcjsWAAWAod73CrYzdyXZSpiiiVTU9ht1hpHPmDfnCzOhmUliyC/DsH3Z0Hh/iynd9TO8rgyiK6rUT3C8X1Nc00eb0TQsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=fBmO98yw; arc=fail smtp.client-ip=52.103.33.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="fBmO98yw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1FYTWfAPSot8eXebz0QP0Ig0gif21S3nk+iOofiva1Kx1Gga76hLrtDgsVPYaIMpQu1CXqALr8WleXMe3SWjF8E3hIHROKOuRptulXKtPhMWZUCCgCxVvzfaWLcNVeATveWKteMrTLiJ1RFynGjCmz65fD81CwQqIfpbC9tQlcpSFsScCLTpiiqT0HEwzU265WvsYYTAV0Z0dZAtjEdzzxZFuBnab3PjAhhc4x4uo4oUVkNr75yMew+9ed9uYhufF1RBTEBeObBBJ0DJsgji6CmluFbpGqfMdD0UwR1IM225egl8+VQBK9LL7ys1bpK1gIdvjvUD1LCZKr+bjLUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzmauwkTcz4kKBkIfqa2iUbchSfSJrhi6j156gYNZHw=;
 b=kmRae/4YuoqYIhl0UHN9Wd90KXbbos68Jy4kRSDVgr9f93hXtuJk83g3Hu6gTwAcXb3oaWjTYcaic4Cz/f5Usat/620z+NIpRL+Gsr2zr6v7eTfuBKAtOpCE+ctXt/HxzgeCyMPu4dCcBaH0lEkS79L7xH+X0/Z69+qIjbTIcmT89EnrqJNLAmtaJ09OFa+BW/jPfhTQbj/hzy658xrx53pJ472yZLyioKvT4Hjd7QLoHpcPS9ic2OuByF60n1hwttkwatktopkXje5RXMA31qHb32Y0p03iQd/QKXT98RVtT7ql/vEBqGx91mMS+MjhJntzFwwzDrx1+VBdle8oJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzmauwkTcz4kKBkIfqa2iUbchSfSJrhi6j156gYNZHw=;
 b=fBmO98ywWooTzQxsC75TmPqXWUp3ztLr9CZjGolRWFYAjADa5tSzGCVKiguYDovpYhLk8xBEt817VT9A53rC+XO2EMiKQWFQAp3Hy2OMDrPmi3P9l4YmhvPVHs4cM66Ql21Te2TmUJeZH9qAgdhUzKJDDtKd5zpbuoeCiDaHhNM3nVuFqHvDnmxPpc9MGHBVlZaN1sqLASp4/f4dJRRDNsHAZ14PxRuMkKV69Gaxp/n0jGaXSUO/IwbQn0c+WCWgTeBynwju0jb1TCSZoHOQvCri29cRY37hmpGvCIfz6ywCi9Cvwdm8rVMGYft1nK0MYhOaAhclq+uCXWxd0K0tKg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS4P251MB0585.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 04:31:45 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 04:31:45 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] ksmbd: fix empty DACL handling in smb_check_perm_dacl()
Date: Mon,  7 Sep 2026 04:31:42 +0000
Message-ID:
 <AS8P251MB000193FB2931EC2E2363F2B9C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0437.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::10) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907043142.536307-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS4P251MB0585:EE_
X-MS-Office365-Filtering-Correlation-Id: c6224c16-eb46-4da3-2b0d-08df0c98ec7e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|55001999006|24021099003|5062599005|5072599009|4140399003|15080799012|25010399006|23021999003|37011999003|25031999004|19110799012|8060799015|12121999013|2604032031799003|3412199025|440099028|26104999009|52005399003|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lrykgOIws7qL3rH+aJrc+luSjnRZSdZKIrHWBmD0sGr1LsloCMADFRaHu0sO?=
 =?us-ascii?Q?D8btyI3NuwyCQZoM+WBZAeze+2z2Re+JKe63fvAQSCTAbZwCwfA44ovWsCsC?=
 =?us-ascii?Q?BnsuRwEEZ7wtiCq3ZcBulo410Hsi/odoNWdJ7pr0arOLkFo5JXNQaRiKHRWK?=
 =?us-ascii?Q?DdUesvQhiNmNSRnFAylYsbEdQgRS6H92Ia5jdBxZgqINHgXHAznz8H5KRnT3?=
 =?us-ascii?Q?uD55E1wsY7ySlsYL/Z5Qjq1yvRxiFWOotUK1U77TmHk2VQvYC78nP51JP3B1?=
 =?us-ascii?Q?donFiQe6wa/tbsAFMd2H30Tu1AkY9DJIu8EToIkyOce/9CYqk9RcxG/pVT5S?=
 =?us-ascii?Q?/7hbmgaoEWzhoeVn7U3lfRynLyfL2xhZ/TYGo8YeB4n2AXFuR3QjwPRTEw0g?=
 =?us-ascii?Q?uBLAFYuB9kGVbj1tX+1rXH0yavMMVnkA5O2Xkuge1FmEiPHfpJGZeLcwzUMP?=
 =?us-ascii?Q?kiA/ALZsQMfa5eAgVH6FY1eUEkC/VM3RjGr1Rn0XJtPvGB2hPblWeaICWBPg?=
 =?us-ascii?Q?r0dEAc1Yf+Koc3SJi1HYe5LjRNc3cGBzPGsKsvql8bkiD695EmuBVVKjQtZ4?=
 =?us-ascii?Q?1uSRpcA369xpveNMlgddebMVgOA+EFwOx3veSKNk4a0HZ+15G6TBoW0HQak2?=
 =?us-ascii?Q?vjMzK3bVjUC41iJU1X0A3iDjuGPCZWOJhBdA691f7TJh8Q/C2MHJNLc3QS0K?=
 =?us-ascii?Q?zUwL803kwjZXSQ21jSlipm0QFVbYS1NDpsbmi0l0pTjmUqqaSaQMDFDlSFq6?=
 =?us-ascii?Q?aUsaKl1M192H/0XM6Jm+xZxS8soXHzqby4zyVAePgPVzXLN6wTOj0P8XITkr?=
 =?us-ascii?Q?JpHJEqfhn4pJZ0r7XfN7GK4zj6gxCoCc47CUaQ7nA3StCzvtxE1CGUqad1jA?=
 =?us-ascii?Q?v7blsU/VMns6+3JZ6HFQnL3N0KRMnxuN1pegnUYhgdDhLcQkIT/3hnt15GLD?=
 =?us-ascii?Q?IH2E5ITKCjwdcrdPWgvOW0lJILfWPl/uvaZwkIQ1AjiP2Z9jNvdzxYK8Ajw9?=
 =?us-ascii?Q?AnwQOx5AHJDt+9cT9ntzxThWwXxqB8wqLKVkeCzSS2B5ZiQmGYxrIBdOiuwc?=
 =?us-ascii?Q?ZMWqJ6YPZXfN+UPYssiAzGb+lTfWQBRJTIUfWkFIs1/9EIB5jvn+R9ueFZp5?=
 =?us-ascii?Q?/FRJPG8A6gPyS02Anc7kduDa6WYXiPumpX4eQahqPeFL3uThTAtlOWw=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?si5bFpI8rTQ0I0326pDK6i3OyMGgw8bQ1RMHiBV2lJvZk5ATkbMyv9DyAG+l?=
 =?us-ascii?Q?ZBkrMk/bodMsMdN12oD7OhO3HFyLth4ncbUSUfHlHfexEgbq4gAuxnHjuqSW?=
 =?us-ascii?Q?JD/JtF17tUKyC/3YFP53s0pSb7sfST6iFJhGE8uA+snnqx3h5AocpAORHw1I?=
 =?us-ascii?Q?69lBIZzFPwVDlfvGIh0Bo/+RBdk5wCxEnuP2ETF1rjw3bGIx2jrICvw+HJmE?=
 =?us-ascii?Q?Wy+/PBH7HFD2+tajXj7+REd5nk0+pF7Z49PDXrRKz48eIOWlwlTyCKrffqwB?=
 =?us-ascii?Q?wBZZ96t+xY+D1wIVobbgtOZFRGIPGws9Q4SBTMznCZ484VN7v5xsnkOf2s38?=
 =?us-ascii?Q?GiLklhUAImdIRXw6hm04MX9iRWlts6GLCmX+/LoluNvk7fZLJ8Mc+xLgYUNS?=
 =?us-ascii?Q?MSJFip+oxm4f38nflmDCfk2fi5omwQmFeRUDmtR6tOFE/DuXtuBqQqb6FKZM?=
 =?us-ascii?Q?/hDfz8QKENXBbxIEZSnNAQxDHdRFJ6ovvOy89Ik7+HA9tayzGit8Uro57kvx?=
 =?us-ascii?Q?B52SHbCMhRDfKmyLXqEvab+rIjzjDCT5eCdgERo6VWYV9OdUFjBlNV/To1GQ?=
 =?us-ascii?Q?WXbTiwAlmDoPk9VtE5UArKPRX5rw9EKKm570ND7YcaxMZvbkUeulx1SexuU2?=
 =?us-ascii?Q?5ZglFHrvPsWQtRf7mmaqpVxu9l+itxVrSGjdj2yJM4HTIRIN4pjBDKAROvyu?=
 =?us-ascii?Q?vsv0bEjVNLWFYetBYC/z93ZKBpankvdrO1Tj2bU6l/kNWVFLq2pI8PUcxwtH?=
 =?us-ascii?Q?LK8VYObfd3vDN/14UNv3JkSPi0aXmx6+Txslbbrpmz9REcz95l/7cr5NyQCa?=
 =?us-ascii?Q?Zq+BK5KPA7PQ49TDY9hs8U9lO+Eoftirrt1FJOT9UeJhhbAA94lyPZtMmytQ?=
 =?us-ascii?Q?O/ShPjagA9MM6QwbX+KGA1wKNec2OagKL1T/TtfTTbNJ6UXZ5nwi183yLibd?=
 =?us-ascii?Q?B2qJGRUhbYMbfOwKY5/BoodLBkx3wANP9xi8YncrilblGLAl6GtMFvXQwavk?=
 =?us-ascii?Q?u/Y0gM6mVK+pLYsmF2cvuDR5uqUsGIcjvQTlCX3RVaoS5kgaKgsCVoGUgtnU?=
 =?us-ascii?Q?NwSv1UPAip4v8ftrAVCoeTjTwduV26UvdkUN++ZylU5s3YxiPN4dnv2u22IP?=
 =?us-ascii?Q?HdcyerbQz2ShnN+15W184fQOArrTiO2MhuRGCI7/dealajOl6IrfEV2NDdF7?=
 =?us-ascii?Q?2jxhylONIMqwSL+3LduTEQDw6lnVWwmCRsDvpf3/sT08eAHkuoU12PRqyRSX?=
 =?us-ascii?Q?G8yHle8ESeWaK83WS4Jcm7rlXwT/KTUHetu/WSzLGhPco5JSAarU9tNSsnBx?=
 =?us-ascii?Q?EvMvVH0HUrD0zWBx6WjpdVGy9qMOSePks0gzanJzVCZcTCuw23Y20SdKl28r?=
 =?us-ascii?Q?rJMNlRmtCqfN5Ffe6pZhAwPG7JVB0GUDc058Xd+nqofBuwt17LU9RrRYt+qj?=
 =?us-ascii?Q?f0FmK/15RG7I9jt6aUUsHKPTqCOaR5vB?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c6224c16-eb46-4da3-2b0d-08df0c98ec7e
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 04:31:45.4392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P251MB0585

smb_check_perm_dacl() does not properly enforce an empty (present,
zero-ACE) DACL. Per MS-DTYP section 2.4.5, an empty DACL grants no
access to anyone except the object owner's implicit READ_CONTROL and
WRITE_DAC permissions.

The current code has two problems:

1. Non-owners requesting only READ_CONTROL or WRITE_DAC are allowed
   access because the code does not check caller identity before
   granting these permissions.

2. When pdacl_size exceeds sizeof(struct smb_acl) (trailing bytes
   after the zero-ACE DACL header), the condition
   !(pdacl_size - sizeof(struct smb_acl)) evaluates to false, and the
   function returns success (rc=0) regardless of the access requested.
   This means trailing bytes after a zero-ACE DACL bypass all access
   control.

Fix both by moving the uid/sid resolution and is_owner determination
before the num_aces check, then denying all non-owner access and
restricting owners to READ_CONTROL|WRITE_DAC.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 fs/smb/server/smbacl.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 1fad6ccf3a72..ae55813790bd 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1490,21 +1490,27 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
 		goto err_out;
 
-	if (!pdacl->num_aces) {
-		if (!(pdacl_size - sizeof(struct smb_acl)) &&
-		    *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
-			rc = -EACCES;
-			goto err_out;
-		}
-		goto err_out;
-	}
-
 	if (!uid)
 		sid_type = SIDUNIX_USER;
 	id_to_sid(uid, sid_type, &sid);
 	vfsuid = i_uid_into_vfsuid(idmap, d_inode(path->dentry));
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
+	if (!pdacl->num_aces) {
+		/*
+		 * An empty (present, zero-ACE) DACL grants no access to
+		 * anyone except the object owner's implicit READ_CONTROL
+		 * and WRITE_DAC (MS-DTYP 2.4.5). Deny every other caller,
+		 * deny the owner any access beyond those two bits, and do
+		 * not let trailing bytes after a zero-ACE DACL become an
+		 * implicit grant.
+		 */
+		if (!is_owner ||
+		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+			rc = -EACCES;
+		goto err_out;
+	}
+
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);
-- 
2.43.0

