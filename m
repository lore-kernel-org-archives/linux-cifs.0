Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021094.outbound.protection.outlook.com [52.101.70.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2F9501F5C
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539510; cv=fail; b=mue3+jt8lzjz1ZcpmP+K4uEjol/4Hf1RUhTEPTRyEK5+1otTYeY96mem8P3yu76Y6G+PVYQkOvluOtU2JUpEPd1NLcAL24eHFbvMWi24SeBWcCNdWDh/ZOzmS7NBoAUpeH3BsowJWoPOgwufQWvz7/UwUQogrAr/ob7WRtqDtyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539510; c=relaxed/simple;
	bh=HKlVdAWx3ARuxe778sH78KcoYJEJXWRcRWJnBmR4k1k=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PVB5rnrq1Xqp7fO1UxU2RMd81YL+tzmJw+nRGw5pGmas9f2PFKpzSjVi05Hh3krbwIlxtIpM+oBRpcN2NdDRqpyMB7+VgAq5ek2f9+E+NBROSY6Pr0UulMXAaymuFMvjMD/d2A5cYdhUBQ0gIQ3scjDbbUhD+3dqKG3T1IQjfiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ulb.be; spf=pass smtp.mailfrom=ulb.be; dkim=pass (1024-bit key) header.d=ulb.be header.i=@ulb.be header.b=ESA73C2O; arc=fail smtp.client-ip=52.101.70.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ulb.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ulb.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ulb.be header.i=@ulb.be header.b="ESA73C2O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uk4W1uyXqejjfgxLV2uM6A2amv7ejKVvqmvsWRpfUs8hrPgpBLRMfoZAR3BLS1zAsOgzCgvKvOvNS9iyV0ZFG7z4gPnSLpJmIJDVPbM+Z8DMQ5fBoSvaNsdtrDJQk96WHS/UoswIhIwMO3cOjAn/s3+K0gdIbrYLbF7muFkj7onLWjYgtIwgg+YXVUVsicbB7ZSsHk0qnJ/jBvlJaRaYC4+c4S6PWDsHFraoTsJcc95c2TAgmdiOciK/VV0O+8w8J5cGvrxi1Wj7tGETV+4UQiF1VSSCrnCjzRl3O9sJQP71OceJPi33izWX8rJTGMsn+H9K1mcbS49LzMsjE7j7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJSLM+318GIW7Nlxugn1GfaKWQSyV2+lvPxHlpIwG1k=;
 b=dwVKxJ9PrNfukz5Qi5RM4ybO1p6xIIFJ5tfdfZ76Yabln3Z4XuEZpb5lrxZWH5qQYD8F1viSLGRZ84Gwg+hrtEXqU+sZcNpSJDQyqsE2hpJRcxu+rXWjJFw0KBY+cDkk+6k/7K7VAfDqyhhPCR6g0+Y+yfaJVIFpIVKA6Xsl/ofkDNWKOiASd6MXUaeCqhouIcayLytYBcsl+tPBAl5nt0a+/PpcwyVSRMXOmtN5o1iU99OK08ayIaUr4SrvAYU3a/ySPFGzTueblhIRHiRzqPV/Ifh+eP0ZJTE3EA8gm4Ii3wo6JGwch/h4ntjnNadJ5aVhKclYI21pZs6wAbc9cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ulb.be; dmarc=pass action=none header.from=ulb.be; dkim=pass
 header.d=ulb.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ulb.be; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJSLM+318GIW7Nlxugn1GfaKWQSyV2+lvPxHlpIwG1k=;
 b=ESA73C2ObubaoLIFJlFLvA3mhq5OIQaID2WHeRLIncq1DELOa1Zb7ydhdrzoopHNELI3+SoqguKMISig45UgAWveIT6w0kNHxOB8MVW71XOj6Mlija2dGmuf4svRte7PPb6ahlAGH+Oszerq4vWLSJq5I5YIN7oY9308D043er8=
Received: from DB9P190MB2012.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:39c::14)
 by AM0P190MB0612.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 16:31:43 +0000
Received: from DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
 ([fe80::6336:5deb:4cdd:2048]) by DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
 ([fe80::6336:5deb:4cdd:2048%3]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 16:31:43 +0000
From: LESUISSE Arthur <arthur.lesuisse@ulb.be>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Kernel smb client: multiuser mount & new SMB3 POSIX extensions
Thread-Topic: Kernel smb client: multiuser mount & new SMB3 POSIX extensions
Thread-Index: AQHdPIlM50KMR0vh20O62yKV3uZd/Q==
Date: Fri, 4 Sep 2026 16:31:43 +0000
Message-ID:
 <DB9P190MB2012266F6B8DECBE5D26A1798DB52@DB9P190MB2012.EURP190.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-BE, fr-BE, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ulb.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9P190MB2012:EE_|AM0P190MB0612:EE_
x-ms-office365-filtering-correlation-id: a20ffba2-e349-42ca-67a3-08df0aa2018a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|23010399003|1800799024|366016|376014|13003099007|18002099003|56012099006|38070700021|10067099003|11063799006|3023799007;
x-microsoft-antispam-message-info:
 S2Bdr+Sj3+ZOfXAu3VqISiiDMfL3TMzY5pNhHi1RUz60Iwe9IA0yBO2b1ULhX9SI5B0nLwywjaGMm4KFcT2zN7j5ZHQYplOPoHjUsiQeecNTU5tiCY27C4KLxW+1LvU/Tk+Xb2fIhD3NQYJ+15wTERSwveM6pA5XwFZUQNumy/NS9uDgc0qbs/BzhFZ+NnhlEfP2ytUovj+aEM8E+1kQ1LHOv2iVsKyk9gAt68qtotKDrgri3NV/zp+zK5owtjdOU9bIYXdgMQqOfgHzAb6J6R8e11ZCNjk0sdALkKc+zoDvgrO6BMV/HatLuzGi3PE4SrL4nBZfJ7RN6bd+LxGSxRVVchX5x5kbk6whg4wUw4ZMcxfVvBJfkKqLFwYqa48DKXEHn3Tz+G6DzcsGlngGK7X0Wdeg0gNow8Vx0jdmbkwm0wb5vf2ATUSmoqFDPtipLTO2aVU6SCiK7knqHB8oX1VabXCOBqbpGBsqt1oA9nKh46Axt49cb9tH+izMnEeCDKBpPrtINeYrTxSUOrDLnb/F5Z5wsZGy4NyPsR7uwpdL/iZBajGHnSkLTCw1ErmLUWs1dHOaY/nz65cCDC2RwA9qvuA/h9vhUbEsjuUJgHaXAx8yGjHA5S+zRdU6QaBmFS1c45pvd+W1qJq2TJ4D+4vfDT4za8s4VrCRRSHuAQQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P190MB2012.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(786006)(23010399003)(1800799024)(366016)(376014)(13003099007)(18002099003)(56012099006)(38070700021)(10067099003)(11063799006)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?OaC18yEaSOPXDn85h7DfyD4w+lXXe82WZyrgaJwpg7ZQVhBpSaL8Uw1X/f?=
 =?iso-8859-1?Q?9e/cfO3gjIufCggPx7lodR7OmXEgJGbeFrmoXs6MmZgQbjT3j8NnkijcPr?=
 =?iso-8859-1?Q?FnNsg9g/+Q2TrVSUQCryGgvvAQE8GgKI83Sowl31eHqzF4O+pDGESraHQu?=
 =?iso-8859-1?Q?fPWpRS0n2tRLdny20NxOQ6kGEKP6R6bBzBfRtNAucOTb0u2x2QAIAuubvl?=
 =?iso-8859-1?Q?oU7ozXT4MzxnQRj9kDXjadTvfiZ4h0DZkGICeqqc9UEVD+9X7tacRKRI5o?=
 =?iso-8859-1?Q?fcetL+SXx+vkM0YnDsASS0+00r3DTW+G6+7MVL3VBe2c6fnwabv7CDjCH2?=
 =?iso-8859-1?Q?vZb2BImDMje0+BiXOwdPinRKDuvW+dYvmKB7px7iaO5z6MuZeVkDikao/X?=
 =?iso-8859-1?Q?bZXMgAIAs+edi43NaghetkmdAsXkgmHs60RQf0NaVDTrYOWlEGbeRgegwW?=
 =?iso-8859-1?Q?mNmH+TnQN6N9uubWgDDGgG3yej/s/1xGzojcguDFX2v7Nznzx7In8TFyqJ?=
 =?iso-8859-1?Q?8myVcj/8fth3W3MW+7ztjNjt1ovfXRiXbxc1L+SNXWLmh1oKPZ2ryZulnv?=
 =?iso-8859-1?Q?QQFw5iKQxZ5tWzkOqwtmqTcNIiOd4ixKq/E/ZdCgtYgy8goqXLCcr4IJzo?=
 =?iso-8859-1?Q?TyNuAwy0TYTIdcTJiUwL+s+Xftpz3/H1pQjWiVuEDilEIazsuqW4F83Lac?=
 =?iso-8859-1?Q?lxpzSn6F7quQttP/cn2XZCyiVzLeKwGKRo5jkevEXSWTsP8HC+X9tMrM4/?=
 =?iso-8859-1?Q?mXjVM34BggIJW7QvkZZS7EIrF8qmsm+JV9dvjw2k/MvhksqSJeZqeZ78xL?=
 =?iso-8859-1?Q?a+0FASpCBq4/BMiAiQXwIGaERQHCaltLekm5DmdMzlMixdz8Qhtg+kxk13?=
 =?iso-8859-1?Q?iQT7T8BFiNAMnHRBnpz6QnzfrQh1btbaESWhZVxhnqp608cNlGpTuGS6W3?=
 =?iso-8859-1?Q?aY8gRKNk3ZNqBHZc0qJxnQFzus5UWacn2yxmbmCHJ8aGOt1wIN9wDmglBw?=
 =?iso-8859-1?Q?RbWlAg051t6FP1UBCkgHUdHkT/nyF7lrgo69Drvl0aa2tQIEv48vXq5VXy?=
 =?iso-8859-1?Q?Gum7pA5/Oh/CnxM3wHoI04TvO03iAgyWqqedbIJ9q6RPsYm7QfmNQfKdn1?=
 =?iso-8859-1?Q?00OKsvTvKRdp7MT067jJ5dT7/DuDYyhYNJtf02c6v+znOPfv2beObxhfMj?=
 =?iso-8859-1?Q?H7vs0vVIURj/9MaS3S0ac4WdbmAKamU5/Lke/Z/h9556cQkcQjG3mKoPKf?=
 =?iso-8859-1?Q?EsvcSWm04eF9uZ2NgXOpcpt/pPVwTLYEuFq+SCju+D662KNkvs3yUMTT23?=
 =?iso-8859-1?Q?120MgtKWBLuIF0r1VP6VI6BlcfIY0aGR7/tiXA4kLnM9i6FMqFzvojqYKV?=
 =?iso-8859-1?Q?kJaqkWRZ7aUYwbAbznQI/ktonfSjmlCwzHBjzLCqCzEheVRV+vGKzJY4ah?=
 =?iso-8859-1?Q?MatkNV+kawoHEG52NdSKcEaHdzqJuekK651Vp2s4dLu00iynUjBJVS/u7p?=
 =?iso-8859-1?Q?oDvaHRjhm8sAjHzReJ8zzB2uLg9vB72ZK8ix/jeAXu6jMvCrhyodETYuj2?=
 =?iso-8859-1?Q?lsXOy17WxcOeY1sG6sow6lEeAQR59Ndh/5sYAUJkvy2NTFiiFrI5W+8ybP?=
 =?iso-8859-1?Q?AJyMW9re4MVs03BUYtbtN7mM4HmTM2+9Yc0t/wjYWzIiGMdpbh3c/HdOcg?=
 =?iso-8859-1?Q?v0kgCju8JiNgK4SMIOy14nyCxjeqeoZSyQGSjxWGvGIUQOMi9l8ocGEY8Z?=
 =?iso-8859-1?Q?Ibrn4QsuTLbl/0cCXAQ3lzKNScaSLNdv2L9OpAkxiCulji?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ulb.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a20ffba2-e349-42ca-67a3-08df0aa2018a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 16:31:43.6268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 30a5145e-75bd-4212-bb02-8ff9c0ea4ae9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yz9IaqfVS6wAaW291TnUY6AGU1r/s6ic/+805UGAzd/+KRKL4Z+zLg31f78rvIJdFB5fNKkJuI12VM7F32bukg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0612

Hello,=0A=
=0A=
Please forgive me for possible etiquette or protocol mistakes with regard t=
o this email; this is the first time I submit anything to the kernel.=0A=
=0A=
I noticed that the kernel SMB client doesn't behave as documented when moun=
ted with "-o multiuser,posix" with the new SMB3 POSIX extensions; instead i=
t behaves as it would without the POSIX extensions, i.e. stat reports the c=
urrent process' UID and GID instead of the correct ones.=0A=
=0A=
The code just doesn't check the flag for these new extensions, only the old=
 SMB1 ones. The very simple patch below worked for me.=0A=
=0A=
Best regards,=0A=
--=0A=
Arthur Lesuisse=0A=
IT Platforms Engineer=0A=
D=E9partement Informatique - P=F4le Technologies=0A=
ULB CP 197=0A=
Tel. 0472 76 23 55=0A=
=0A=
=0A=
diff -urdN linux-source-7.1.orig/fs/smb/client/inode.c linux-source-7.1.new=
/fs/smb/client/inode.c=0A=
--- linux-source-7.1.orig/fs/smb/client/inode.c	2026-08-09 20:26:58.0000000=
00 +0200=0A=
+++ linux-source-7.1.new/fs/smb/client/inode.c	2026-09-04 18:18:40.40698672=
8 +0200=0A=
@@ -2989,7 +2989,8 @@=0A=
 	sbflags =3D cifs_sb_flags(cifs_sb);=0A=
 	if ((sbflags & CIFS_MOUNT_MULTIUSER) &&=0A=
 	    !(sbflags & CIFS_MOUNT_CIFS_ACL) &&=0A=
-	    !tcon->unix_ext) {=0A=
+	    !tcon->unix_ext &&=0A=
+	    !tcon->posix_extensions) {=0A=
 		if (!(sbflags & CIFS_MOUNT_OVERR_UID))=0A=
 			stat->uid =3D current_fsuid();=0A=
 		if (!(sbflags & CIFS_MOUNT_OVERR_GID))=0A=
=0A=
=0A=
=0A=
