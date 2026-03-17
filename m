Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazon11021099.outbound.protection.outlook.com [40.107.39.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C763BED55;
	Tue, 17 Mar 2026 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.39.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752417; cv=fail; b=ZvOrXwFPAwkmf00n5AWBORhhEF6dDLS9n3HRv2F6Gr1LTUmrqT85MY3T2htPWK85uW8gOXzL0Lcfvk/o9Z/m+bSiNQgPG6D908PqmP7e+kdqzON9s/wiuTFqMn/9sdnfE959pd1zVKunsWSuVcv7rzBGQOF5fu6RmQpCRNbXkfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752417; c=relaxed/simple;
	bh=ljyddPMNeJM1xI0St2EnDLaNBzK2s/kiqdXyziqVC+U=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qebBYep8ZoOPovVN3rTftyMWJRN3pDwu62/vUaQ+oZ76pLZk3KT8FCjmMYu2CCEvjjrxsKzE4WyUU9t3j0oblcmwoShGnjjtrcmaZBIoa/YeVMLh2xx87jgfsr++yRtZUQaN5s5P451qp39pxLSqP0Ab4XELfLnuuLs/hBOTUPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=unDUa3yN reason="signature verification failed"; arc=fail smtp.client-ip=40.107.39.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="unDUa3yN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/0FDmCh7wj8PzdKoW7O3Yle4eK7mWLhO6vjpxxXJ7JnMFN3mkB2j3x13AOv8s6lVmi11dHSIoJhutkGjAoF3sTvyEVe9IIog7R2qH0iVtx3/+fjUWzBHlul1YDF0Mh4PvuFrIXNnRVTUhp4Xl4XhL2tPrsdIbnC/dseb4I55IHnbPPfLfAIW5rRQMBzUGs2j4TcvsjTAnxU3gSBUMKX6PRycwMTpg4+3cEaOE2PhGcgK4PJyUqGRAh1WJOCmW0NG3w69MpetN5hYTgcLxz9SGacCNguYOq6Vdr02LN27xReSQaFXjf2QZxO6M06HPiFOPjRx0WYAp15FNBfVowC0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPHRnjByqP1nY3F0jT++TDlSE7+Q0nSxkEL4uH+5nQw=;
 b=IYdAYtLysJI0sVqwJBQCV/DG9Cj/3NMjyCyfJIMbqQ7j7UV3lCQqUZkJ4OmpRD9cxIPRjWxQIcaW1w2/yFiCBNZk5hfLtDNaLGYm+E8Mu6Ek6IsCH0scTm+wIKl/Nq5QVlisaIgP+wkwAMMuxF4HAuRCBRbNs76zBujWoYfd3SQLSFGdEVOvcUvI/k9AmDxEN48KM0q/oD1KCBOedtLgSyG4EfiknRFMAIsI3aMAarc8dQFd/YcIjXTSObjYp7CMzCklAiuJKggqvcVPIGT+Wov2HtZEkszTHp97QlodlTEIuOq9BFtW7FPS/Jb5/IzAOTQ4ltBCSGPewIOdRjgHmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPHRnjByqP1nY3F0jT++TDlSE7+Q0nSxkEL4uH+5nQw=;
 b=unDUa3yNuIPqdnJjPo8rKRvRwdM9d+IpNG4eHt0yUK3VhNc7Sc4gkV8XZyqF29lLktSyyAPHXWRG6k/IeSQzobmMB7GtfEEZjrmQhRpB1v4BZ2WevGubUxGCmkQ1hRdHQZMpFS8Z40D2LP6ZiWh5Yzv9y2gEris7qFDu/mdHuHL/jHFZlVeZfTEodtZfajCBh1JF9LaIV1gmcu4e6tqawDyJRWTseOK93TwGwUzh0G8uW0rA9LjZwX3XMN+a4VsxTXQ71WX7zsVuJYQlD8w1cbQA3DCBoBkEHclzUhAIo3EGAca/w1kiijVgr+JyMAuBDjY9QnTkNo6553vblkw0Rw==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY2PPFF94AEAF49.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::3b9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 13:00:11 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 13:00:11 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linkinjeon@kernel.org" <linkinjeon@kernel.org>
CC: "sfrench@samba.org" <sfrench@samba.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Werner Kasselman <werner@verivus.ai>
Subject: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctg39qJ2L/xSk7U2RezYVCa/CVw==
Date: Tue, 17 Mar 2026 13:00:10 +0000
Message-ID: <20260317130008.2609025-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY2PPFF94AEAF49:EE_
x-ms-office365-filtering-correlation-id: ed35b461-84c8-4a76-d225-08de84251f84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info:
 BIp7KR19rVDEpN6GJ591xlWQTsRDAn3qb0i3QxN82S0TZq66YASNRWFtnJb2ZwprZchO8hxzrqed/2Rwr4ESPNqfNQkwsUAWjbbap3QR1Y5gmQdFUtsJ6rdob0s2IbKEOQIFiwX+ZhH1RIFXufjWYY3LS4hmDrz/wVMR+H8HGOt8/y5fnjhDEuKxCF3bcWTch5V5bN8HlEUGlUAcQ1f33ItXt5qxNLTo1ghbGuPV/7AM2T0lc/QrzEnf1IWxPepsp0C/Hk966Y27KJp2svWQl3fBLxMUSHO8wJFwxXUGzN4OyGLecHP3YRwntMSFGcVqf20hpBfqPLdZ85Lvylne1cncsu1zz03AMI08M8pNvDLOBW1g/1XYHpHKu8a4s/MKaD7HwxpJPcLdEPDC9BSKFROor36rCMOreKSgvGVisIXUn/NRUtPBqHEtx2OHfwdHQgrePhSWUBGxWyo5BkVGuY9XrIJgf49b+LduGOT9G7VfFtl9/8SqqhE3KvFXaspOopw3ZN/BoHLwT7avFTjr/yK0YZqj/gSvMXijlkcDnIxHEVOTblRTCjXUhKpQovLE+pB03D65r5WmMx58Pt0JrEHlNvd0YzQ2vNGV8AtyL0MvDTUc8mPMbMB3jzQHXUtW7+AcUytbkFEVSpM9iTsG/WISMgt1+N8pz73P5MLKFS7vYaphPgGshz8NIxX7ZTFwc4RSQbIfcLLKHLkkWQZD32UyTU1GhQ6KqqMdJmbHxU/2Swq8ZxZJHfOc88zpyacz1ChxIdkyP09wZEPySXYvMyGiZDNl3Uk5SXHhQePL3Ec=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?grhbrDcHuPSKW26cMvCe6Zm1z+2b8FmxQ9U4G6ZZUfj2Int/Mb6XEuFqFB?=
 =?iso-8859-1?Q?3KhssiGPtP1IQpqq9M13JEWyasZGGQ5DjD22Ap0h2QtM5kWalmn1yxBRiv?=
 =?iso-8859-1?Q?JnceizuFMrMgR8VcoYrTXaqZWM2TaiwHAW3tgacMysT6h1Hsiduvhzyl06?=
 =?iso-8859-1?Q?50Yyt//qPYGe0Kz0NgszwdmZjunr8hy48lnWpi+hzMaMbM0CEzVQ8fzIEX?=
 =?iso-8859-1?Q?2aMSJkoCDqtKFYsdrQP2er2Sgpd7LtFBMVnKSsWkp21zv1Pez2aYb2sXty?=
 =?iso-8859-1?Q?M5FCckoMocdp8NNMpVRn5U4+tsP5Xl7jP3wAF3v2AMLBCz8HQ705EISv5K?=
 =?iso-8859-1?Q?OKhcjz6Bavbi5k2QUWdlST/tcDoQBhwYQkuQWEeCGcb3lCWqcAhe7aAnN+?=
 =?iso-8859-1?Q?tQvAgdS5fLTWKXw42QVQQO1BXZQnaJwub3bYRJjK7Jhm5+O3yMh/8tLYou?=
 =?iso-8859-1?Q?vziYee5y+zPM9HziiAkz5/8RqM6HKdfZ+EUIKWFf0gcuABOUWZL1GHyp4J?=
 =?iso-8859-1?Q?e2l0By81S496dqXgpl2hDQDyFyQJrxBH6ljaUdVB802YQS4mXf8Tvyp6o2?=
 =?iso-8859-1?Q?M0hBs9tDg2g6m6XtbD5QicvAc6y1cQpEGtMDUWBKRYy+DkfPi3CX90B8V2?=
 =?iso-8859-1?Q?daPUU65eM24PzaQlqzQOrsSd4eg4GLvNkD1zy2trv4SmjRVu3n6qgbr0lf?=
 =?iso-8859-1?Q?sX/RafcTgDCTFinfv3RMv+va5e/D/tRpPrc+hWJcqGBnUFzzyAzwa7NruM?=
 =?iso-8859-1?Q?/lbfDexD7C+uaYAkKMV90S0tZdyT5FYdJ27wMhOQCrXW9/b9bLiord6Ha4?=
 =?iso-8859-1?Q?FTZPOneYljtpf5WY9+nH67sBFXO06Ryh/06n+pS+RbBqqK/o6MQpRQpQjT?=
 =?iso-8859-1?Q?EfVwzziQVX+uIOxLMNruyAinKRmh7iQcq2GPWpVuq6rpzhlL8gQ/VnEFSv?=
 =?iso-8859-1?Q?MYeSUZjGLrJXhaz/m6L+LqiOv4Uq5NYOk9ZSXkRsxnaF6Kzpc90jcupOzp?=
 =?iso-8859-1?Q?8DG/Z2TJLKBVrITyxST6LJrbi0Gq/KJQi2vPuaCYVSpyzdSb4GneYLPbs/?=
 =?iso-8859-1?Q?EVCtetP9dpATDCGfKaKjdd866zv/MzKJlHqI90uw+Jygc8VGft8zY6Nqsa?=
 =?iso-8859-1?Q?N09Pz9ghCB+yaTyPHQj2iCI/YO5b6eTgVpGOXFkTjfnKouYcpbrgsc0QpN?=
 =?iso-8859-1?Q?CQsbi+/YDfkZefXT+igoWDuc6mCQKtx65bV2OkS9grhZjzmmZspSYptYGk?=
 =?iso-8859-1?Q?3LCwsbRuz3zLFO3Wo+VFiq1VxdCPTnzQ2qKxG09/Q7SpLSzbF0AsBWQ7PY?=
 =?iso-8859-1?Q?QtJA1g5H5eh5reUOQFVBJex1ftIjHUY9dg3U1+mFFHyVV5cQf73DgtJJKO?=
 =?iso-8859-1?Q?MhdOfK7eG6E15xxgUMbE318h+c525L6N48oPbH69P6HbO6cqKcItXtfWYd?=
 =?iso-8859-1?Q?ZBT6vCyBbCIHh5DNY/AX9rDqt2T8eUvT2+6iWsUabNAikUO01wkEGLKqvC?=
 =?iso-8859-1?Q?4H1axG89rH8C+8+SVsS10emXu9XaWW/TC1FwK9aGxjI3/o86jzoPtCNUex?=
 =?iso-8859-1?Q?D8QC3yW0JRMwhPukoLMMchboTaW5nDYD3rkfcJ9f16yOhD8gFMJEtmFMnC?=
 =?iso-8859-1?Q?9OuHWBPolnOZhqMx6u46sawmhAoR7J7+0+lLZ/LwpafC8zNnFRSiNOJ4AC?=
 =?iso-8859-1?Q?EduaDuw2s3MJyJ+SHdMRFtOwvAA3sP43YJs4S2YJhpKurdD8s+84oOyC74?=
 =?iso-8859-1?Q?Z/OBpp9DOpz+DTs/21erdFvp+7SCisgIizN6Talnp9oIHOAu8ieKXFfOYl?=
 =?iso-8859-1?Q?8PQGUyh1IQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ed35b461-84c8-4a76-d225-08de84251f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 13:00:11.0065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZONc6RGj2XheSDLs+bQso2p1UO74rb0TUou15RD8OU4CnjLlxY72XJj9Sg2qLirmPUcyA8b26LlcPxq6yIJCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY2PPFF94AEAF49

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
 fs/smb/server/oplock.c | 72 ++++++++++++++++++++++++++----------------=0A=
 1 file changed, 45 insertions(+), 27 deletions(-)=0A=
=0A=
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c=0A=
index 393a4ae47cc1..9b2bb8764a80 100644=0A=
--- a/fs/smb/server/oplock.c=0A=
+++ b/fs/smb/server/oplock.c=0A=
@@ -82,11 +82,19 @@ static void lease_del_list(struct oplock_info *opinfo)=
=0A=
 	spin_unlock(&lb->lb_lock);=0A=
 }=0A=
 =0A=
-static void lb_add(struct lease_table *lb)=0A=
+static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)=
=0A=
 {=0A=
-	write_lock(&lease_list_lock);=0A=
-	list_add(&lb->l_entry, &lease_table_list);=0A=
-	write_unlock(&lease_list_lock);=0A=
+	struct lease_table *lb;=0A=
+=0A=
+	lb =3D kmalloc_obj(struct lease_table, KSMBD_DEFAULT_GFP);=0A=
+	if (!lb)=0A=
+		return NULL;=0A=
+=0A=
+	memcpy(lb->client_guid, opinfo->conn->ClientGUID,=0A=
+	       SMB2_CLIENT_GUID_SIZE);=0A=
+	INIT_LIST_HEAD(&lb->lease_list);=0A=
+	spin_lock_init(&lb->lb_lock);=0A=
+	return lb;=0A=
 }=0A=
 =0A=
 static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *=
lctx)=0A=
@@ -1042,34 +1050,27 @@ static void copy_lease(struct oplock_info *op1, str=
uct oplock_info *op2)=0A=
 	lease2->version =3D lease1->version;=0A=
 }=0A=
 =0A=
-static int add_lease_global_list(struct oplock_info *opinfo)=0A=
+static void add_lease_global_list(struct oplock_info *opinfo,=0A=
+				  struct lease_table *new_lb)=0A=
 {=0A=
 	struct lease_table *lb;=0A=
 =0A=
-	read_lock(&lease_list_lock);=0A=
+	write_lock(&lease_list_lock);=0A=
 	list_for_each_entry(lb, &lease_table_list, l_entry) {=0A=
 		if (!memcmp(lb->client_guid, opinfo->conn->ClientGUID,=0A=
 			    SMB2_CLIENT_GUID_SIZE)) {=0A=
 			opinfo->o_lease->l_lb =3D lb;=0A=
 			lease_add_list(opinfo);=0A=
-			read_unlock(&lease_list_lock);=0A=
-			return 0;=0A=
+			write_unlock(&lease_list_lock);=0A=
+			kfree(new_lb);=0A=
+			return;=0A=
 		}=0A=
 	}=0A=
-	read_unlock(&lease_list_lock);=0A=
 =0A=
-	lb =3D kmalloc_obj(struct lease_table, KSMBD_DEFAULT_GFP);=0A=
-	if (!lb)=0A=
-		return -ENOMEM;=0A=
-=0A=
-	memcpy(lb->client_guid, opinfo->conn->ClientGUID,=0A=
-	       SMB2_CLIENT_GUID_SIZE);=0A=
-	INIT_LIST_HEAD(&lb->lease_list);=0A=
-	spin_lock_init(&lb->lb_lock);=0A=
-	opinfo->o_lease->l_lb =3D lb;=0A=
+	opinfo->o_lease->l_lb =3D new_lb;=0A=
 	lease_add_list(opinfo);=0A=
-	lb_add(lb);=0A=
-	return 0;=0A=
+	list_add(&new_lb->l_entry, &lease_table_list);=0A=
+	write_unlock(&lease_list_lock);=0A=
 }=0A=
 =0A=
 static void set_oplock_level(struct oplock_info *opinfo, int level,=0A=
@@ -1189,6 +1190,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req=
_op_level, u64 pid,=0A=
 	int err =3D 0;=0A=
 	struct oplock_info *opinfo =3D NULL, *prev_opinfo =3D NULL;=0A=
 	struct ksmbd_inode *ci =3D fp->f_ci;=0A=
+	struct lease_table *new_lb =3D NULL;=0A=
 	bool prev_op_has_lease;=0A=
 	__le32 prev_op_state =3D 0;=0A=
 =0A=
@@ -1291,21 +1293,37 @@ int smb_grant_oplock(struct ksmbd_work *work, int r=
eq_op_level, u64 pid,=0A=
 	set_oplock_level(opinfo, req_op_level, lctx);=0A=
 =0A=
 out:=0A=
-	opinfo_count_inc(fp);=0A=
-	opinfo_add(opinfo, fp);=0A=
-=0A=
+	/*=0A=
+	 * Set o_fp before any publication so that concurrent readers=0A=
+	 * (e.g. find_same_lease_key() on the lease list) that=0A=
+	 * dereference opinfo->o_fp don't hit a NULL pointer.=0A=
+	 *=0A=
+	 * Keep the original publication order so concurrent opens can=0A=
+	 * still observe the in-flight grant via ci->m_op_list, but make=0A=
+	 * everything after opinfo_add() no-fail by preallocating any new=0A=
+	 * lease_table first.=0A=
+	 */=0A=
+	opinfo->o_fp =3D fp;=0A=
 	if (opinfo->is_lease) {=0A=
-		err =3D add_lease_global_list(opinfo);=0A=
-		if (err)=0A=
+		new_lb =3D alloc_lease_table(opinfo);=0A=
+		if (!new_lb) {=0A=
+			err =3D -ENOMEM;=0A=
 			goto err_out;=0A=
+		}=0A=
 	}=0A=
 =0A=
+	opinfo_count_inc(fp);=0A=
+	opinfo_add(opinfo, fp);=0A=
+=0A=
+	if (opinfo->is_lease)=0A=
+		add_lease_global_list(opinfo, new_lb);=0A=
+=0A=
 	rcu_assign_pointer(fp->f_opinfo, opinfo);=0A=
-	opinfo->o_fp =3D fp;=0A=
 =0A=
 	return 0;=0A=
 err_out:=0A=
-	__free_opinfo(opinfo);=0A=
+	kfree(new_lb);=0A=
+	opinfo_put(opinfo);=0A=
 	return err;=0A=
 }=0A=
 =0A=
-- =0A=
2.43.0=0A=
=0A=
