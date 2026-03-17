Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazon11020141.outbound.protection.outlook.com [52.101.152.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0231E51E0;
	Tue, 17 Mar 2026 02:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.152.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773713887; cv=fail; b=VHQOLtMTNAs7dYC6zFKKrFAiMq8UqAtbdlkSrb+354bUqhP0a+9dMU3GXUPZgNOIY3sbTppOUT2okqd0BxBqLU6iZLUXzhYLVWZ8o7e1EdQI9Vu4RTm1kmUDNey5aPRr4Qfw/HY92RZ+VqPSMmqRAvBaPqJIBpBEzJctBBUk0QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773713887; c=relaxed/simple;
	bh=JcIBlsqXcPsNRURwNDB/nqxrcHhmE4swRKz4p47uUaI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u4lWKTTdzPQn/1UfaccUyIYOZbyB8sXh1mrNptId8E4g7SfbwscbyuHb1ZZlbkEea62hsjNVNvYxgDAV6njZwSthGRqSmRj8pR0jaW4HthcMWNynd75L4K+fS3JZjPn05q8Rqtixm46arxPpNKP1caTEm6JF9yoJqzDuweVCFxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=NpCAhGpo reason="signature verification failed"; arc=fail smtp.client-ip=52.101.152.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="NpCAhGpo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yiBT8BlqsgdoSE3FnsmtXmDlr0Z2YEURItR7Zj0GjVB+RWMYi33W0OWT4vAXlqKvX84bzkVWyS6jI2yre2LmEM59ssDzoxr8R/7CtonJEXAj8AnNG6CzqM5D0NDF4t7PFW0t40ydEj9us+gVzRSjYn8fxWlLnzUquW6EJqvhDjSAlXohnYo9Crxw7pTyNYlGiLxQ2k5IbmaKTJelvgiZZvY39M19fdHa86hLZbyvSt0UPRVEzD0CTFeVj5XxJc52sCCAWELfNh9DnlBD1kzYJtlOWKoL3YAFChcxVXwCqQfds4QCl+ogxl48pVc4E6bbErtr2bo6frQL3RcB+zpZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFOZTnzQ4Pdwn5IzYlabC6KkIiKmnsYb3ntK4ZqNnWY=;
 b=cLTtLDoaBykA7H49u2fdR138WYeYi/ceC0Vhg+0pLuUj6av1ImX2hUN+d1UTpYHtLjI9nElBEvzgm3YuqwbbN4EU6oHRxGrmnzjsWoFM+6KeDs148l9i04qgjxgVFrMbqrAV6tK+mLAfxmuk4WPvNm5QueeHDtCoC8WvoXhGkVVkZPwQTrTCRFOKObh2paGwQGBBivGcttfEADDBSVyun9c7m2PAg4znUVvZpWE3cPX7eeVu1c5u9Jlcm8o13Py8Mru2Ikwyq8ukr2fH88QvJHjZzpeAhqyexOcCoYFc31ZmRCelZN0PBuFaeRtOog5VDlmUwAT+Sd7dLivFGYh0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFOZTnzQ4Pdwn5IzYlabC6KkIiKmnsYb3ntK4ZqNnWY=;
 b=NpCAhGpoWSwdYIGEpb4SkT5ZppAAkjzMLCgeLNeNzgRt2iTwh0fGHRAnmJRr3EnWwOflsCn1z4lpJ840ir9+51VatDjyyKzBLGy89l3lupxh5drQF1Gpl4nWfL2kh3r3wIpr1KU98zXI34zlBDE30mKhbDJl3xzzl1adl+piDEP9edc8lvKz4RmuRl+rAct24aZJgKoHC8PXN8rMsohiP0NCC4fMLm4iGb9CtE9/erc0YlDHrPbdJPcM2WMQ5bwAQrz3JOUOp5DDGmOgxDVc/mO4ZIFSZfjvv8o4v+LYqSVSnEGuYGuB6nNVoupKTo7B1leX8ta6qeJureSK7yUJxA==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY7P300MB0751.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:288::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 02:18:00 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 02:18:00 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "linkinjeon@kernel.org" <linkinjeon@kernel.org>, "smfrench@gmail.com"
	<smfrench@gmail.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Werner
 Kasselman <werner@verivus.ai>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctbRGGoonuVIAdUaXnTGLgDaKVQ==
Date: Tue, 17 Mar 2026 02:18:00 +0000
Message-ID: <20260317021757.962692-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY7P300MB0751:EE_
x-ms-office365-filtering-correlation-id: 2dbcdd8c-c3eb-4d47-b0e8-08de83cb6966
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 VFSt3Fq8++H4Ag7jRSHAtzCWvAt1XjH+eO5sUxUue7mx23Ktu/tXKU9w8pWrlhgHeqgKzR2SJ+oTHU1fl0lXsNgBsr9ez+sgu0dmbXEV7WpkP3BFSztlN5otK6QezPJZmvmCALTRKgU216M2yruVuBqcopabnJ7YVGnesVx0dfmtUVtZZyALXEfQYKJcvMEv4/r+LfbzSZW0Pt8agbISbzjgH2+MKQMqBusyAFO56LRIT4xfcEhadQp9vuoN5qzgsAmeGcJihLOpAG6yb6dnBv4GBQaxF3sLa9xNevKBv2QzOGvPFvn1Eo3jZl8Kkf5rID/UG5kIW0frQcI4v2OlODVkWLJvg3nI1hSHmMPfM/c5VmKDDGS5g0Ku6/fLW2Fw8TUbzqx7aa3dJ2wea4but1Na7iGCBlCuLrsOJ2mqD+4rg5SC3gz4AjUx2lnNwOtRi5s4ZoDhs9xMj+wl3L40lh3X2zWWYodl9+Dyc9LbZmw+OTplDX+g42BRejOwxYOuTJYy91f10WTCBEUzdjMPPU8fvVpyyupau6W/gy54Ggda9Kk8BI8vG39SNrRVk/U85drTZmBZXUJVsqTk3DxOAB8dEffYlO+q7yB9cwoWM2z+9qWWz0wSp/K0RHI8F6ZjPW2LRohCDZvH9QB2cIDUvj9uxJNqFT7xf9yW8b+mdgNf7fLd5rPKqxNaqsSz/kQBIozZQfjyEvfksUCRIYfLz/Hs48qByg3IJuCZRsVhQq8FBsPQ4UZae9wP/Ng2eyY8o8RgapKliodvEjxtGvRbJrn1ydIjsSbx/OcI/Lh+rr8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?PR0Dtu1pUN9nFOkYbWOxthfK454FORJh1Pu52FzjaVBZpZar3K2Ff2TC9w?=
 =?iso-8859-1?Q?Zs2g7WzbYZaw5/ETZTJMabaGTop4Yg1WfusYZceZbOXFRWkUjeDcx48Bgy?=
 =?iso-8859-1?Q?F4cHN26OxNlNnFsgkm6AhD3Ku8vm9zmGC0IEFjgojzRi+V7lJc2CCgOo5Q?=
 =?iso-8859-1?Q?hdEC97JKq+ZccuKpiaAniNnJQ76Byfcim+vD+StkHwM2+B29ebDRUgNuMl?=
 =?iso-8859-1?Q?vClQ2aaTH/aZV726eNWU48VuMJilZlaq5oBybXtmco4yCTcd8eCUsKOOr5?=
 =?iso-8859-1?Q?3gaBnBB1vwbvjnW7cWb3RD6trz5irk0Ql0SgcSJ4PhdBo4wpnashacj/8N?=
 =?iso-8859-1?Q?bu3wYFQVhcoSyGjb4ZTP09wJpKQkLLRHZVAulfZwMDqN4XSTAVtyfXUQBF?=
 =?iso-8859-1?Q?75cO9RnLk3m5CggH9Lckvwk6xVB656ehgTP30N+/OnMZWGomwT6LFmES8u?=
 =?iso-8859-1?Q?NZDGm6SvwJarittx8ARWkWwjV3ONerWGPNLPnafnW5o73gLPYp/lkfOY5z?=
 =?iso-8859-1?Q?CCMN4JWeYE0K6iY9EhxSdb6zTMmhuE5LsGPwzBXooKJZ5z+S4EQdNJbnUM?=
 =?iso-8859-1?Q?L8NcJnGejnB3WXHHnscVjRn6cxP1NKMAw1yqFWyBRxR4LrSv9OJriWPm9A?=
 =?iso-8859-1?Q?EjXB1Sx8Ue6gTH5aPBphBjFrKDuvJfcE8EI1K4KwS5MCbthgiha/aqTAdt?=
 =?iso-8859-1?Q?q8j8Cvu8piYVfYUtTx2i5Qc9QqM5nWnYelYCt8WODSspfQBLy0VSUZEXsg?=
 =?iso-8859-1?Q?LTpsTEwErcqKBDsbdOQm2xYnjKaYFk0ghpIwDNeWM8rtbXb/y7sjVlcN3a?=
 =?iso-8859-1?Q?5uiAZPz4NI2ShSnMAJI9yApIpyfKSC1Tj1TiLM1cBzCBvGuLi8Puvs7Dcm?=
 =?iso-8859-1?Q?0tCE2g9Ix86+opVEmKC+HeZGoDuLn1GVMGOEghAf+xhqYIjC7lkT4srykZ?=
 =?iso-8859-1?Q?2mzOkpANnofKcp6T7kGgHpl0Fmaxk9WmQQ7GLFxKpK2nc4ES6eyFOo5XmC?=
 =?iso-8859-1?Q?fQpU2nv8MKcdkQKDyfoR+gNDlb4PVJsLazTcNV2hbQQj3wgyTl2Am2g9PA?=
 =?iso-8859-1?Q?JAHHVx/q71S2ggYfyDoOjaZCNRVo/A26cBoxdae4I6bVoRmlNE1KAsLAXn?=
 =?iso-8859-1?Q?94JYhedp8JfS/xNYxC/uoijAOnGMx/8Lkfyb7X1vh7pcyTga5h3oAZlt3H?=
 =?iso-8859-1?Q?AttYLgoz3OB1AAqYyH8kxKZTnSvnqhjk16r/Ep8DFcy26T5q0QMVkheop/?=
 =?iso-8859-1?Q?SendspcqgPP+cR8lBpHLOpZgrYQBubZqFF6XQFpDmRHhAJpfBpgwlOMPVw?=
 =?iso-8859-1?Q?aqY0B/jcgMH1YvJKboRZPxBlI719g/gf6tKYtVUP7RfGiu8NPjpJGWGUic?=
 =?iso-8859-1?Q?o/U6B+QO0bPmDHtWYY8PslLF3rb8yKUmGaeaekbtwwF9ZQbqEnm7QwWRTC?=
 =?iso-8859-1?Q?usem4D4n69REyS+8gW+3Dl88pNZZCBzrecEMMd6DYqQm1X/X8enrDy+tgy?=
 =?iso-8859-1?Q?PzUakxS+/MfeV5wGdTVzToAt0qZN7+F4dzPuwFyoaczD3VjXI1XMUzu8OC?=
 =?iso-8859-1?Q?ZMUQLrJ4Vs4y8pr2OdU1ySvTNVRbgK/sbXELPxgd5G3Z5n4paksWnr2N04?=
 =?iso-8859-1?Q?QSSxMXgbdPCPv9/4/9ssHL0IBCIaLapi+2zXkcvYjHLzvJ7p+U7pAA6/yz?=
 =?iso-8859-1?Q?SYpiCVYgMRvoMJ5uiRY/NF+dllBRGeQkmSZ6A7cssMN8RSM+avianQWVmd?=
 =?iso-8859-1?Q?vMy8TxEDgp02FhWpCl+BHm6T0QXvu5NA1NEeMzBtR+Fv70fKoeYEsk4ncq?=
 =?iso-8859-1?Q?0fGBUFZKPQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dbcdd8c-c3eb-4d47-b0e8-08de83cb6966
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 02:18:00.2533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ysBm/K6o1vnu8a7/YRmq9KXn4J14449S+IAEdCtcF3hZ0PBrCo3FfU3rYLmPk2f9kufY6JU5EYbEbP3oc8+vLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7P300MB0751

smb_grant_oplock() has two issues in the oplock publication sequence:=0A=
=0A=
1) opinfo is linked into ci->m_op_list (via opinfo_add) before=0A=
   add_lease_global_list() is called.  If add_lease_global_list()=0A=
   fails (kmalloc returns NULL), the error path frees the opinfo=0A=
   via __free_opinfo() while it is still linked in ci->m_op_list.=0A=
   Concurrent m_op_list readers (opinfo_get_list, or direct iteration=0A=
   in smb_break_all_levII_oplock) dereference the freed node.=0A=
=0A=
2) opinfo->o_fp is assigned after add_lease_global_list() publishes=0A=
   the opinfo on the global lease list.  A concurrent=0A=
   find_same_lease_key() can walk the lease list and dereference=0A=
   opinfo->o_fp->f_ci while o_fp is still NULL.=0A=
=0A=
Fix by restructuring the publication sequence to eliminate post-publish=0A=
failure:=0A=
=0A=
- Set opinfo->o_fp before any list publication (fixes NULL deref).=0A=
- Preallocate lease_table via alloc_lease_table() before opinfo_add()=0A=
  so add_lease_global_list() becomes infallible after publication.=0A=
- Keep the original m_op_list publication order (opinfo_add before=0A=
  lease list) so concurrent opens via same_client_has_lease() and=0A=
  opinfo_get_list() still see the in-flight grant.=0A=
- Use opinfo_put() instead of __free_opinfo() on err_out so that=0A=
  the RCU-deferred free path is used.=0A=
=0A=
This also requires splitting add_lease_global_list() to take a=0A=
preallocated lease_table and changing its return type from int to void,=0A=
since it can no longer fail.=0A=
=0A=
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")=0A=
Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for opl=
ock_info")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Werner Kasselman <werner@verivus.com>=0A=
---=0A=
 fs/smb/server/oplock.c | 17 ++++++++++++++---=0A=
 1 file changed, 14 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c=0A=
index 393a4ae47cc1..4bc7737f7aa8 100644=0A=
--- a/fs/smb/server/oplock.c=0A=
+++ b/fs/smb/server/oplock.c=0A=
@@ -1291,8 +1291,17 @@ int smb_grant_oplock(struct ksmbd_work *work, int re=
q_op_level, u64 pid,=0A=
 	set_oplock_level(opinfo, req_op_level, lctx);=0A=
 =0A=
 out:=0A=
-	opinfo_count_inc(fp);=0A=
-	opinfo_add(opinfo, fp);=0A=
+	/*=0A=
+	 * Set o_fp before any publication so that concurrent readers=0A=
+	 * (e.g. find_same_lease_key() on the lease list) that=0A=
+	 * dereference opinfo->o_fp don't hit a NULL pointer.=0A=
+	 *=0A=
+	 * Add to lease global list before publishing on the inode=0A=
+	 * op list.  add_lease_global_list() can fail on allocation=0A=
+	 * and we must not leave a freed opinfo linked in ci->m_op_list=0A=
+	 * where concurrent opinfo_get_list() readers could find it.=0A=
+	 */=0A=
+	opinfo->o_fp =3D fp;=0A=
 =0A=
 	if (opinfo->is_lease) {=0A=
 		err =3D add_lease_global_list(opinfo);=0A=
@@ -1300,8 +1309,10 @@ int smb_grant_oplock(struct ksmbd_work *work, int re=
q_op_level, u64 pid,=0A=
 			goto err_out;=0A=
 	}=0A=
 =0A=
+	opinfo_count_inc(fp);=0A=
+	opinfo_add(opinfo, fp);=0A=
+=0A=
 	rcu_assign_pointer(fp->f_opinfo, opinfo);=0A=
-	opinfo->o_fp =3D fp;=0A=
 =0A=
 	return 0;=0A=
 err_out:=0A=
-- =0A=
2.43.0=0A=
=0A=
