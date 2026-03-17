Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazon11022132.outbound.protection.outlook.com [40.107.40.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5032C3254;
	Tue, 17 Mar 2026 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.40.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773730381; cv=fail; b=OMdAVIULcg2cGTm/0F4oTZCBt0tf307ToIPnMRIN9b4pNN53KEnxXqKMQujvHHdkbOnHHODhsmblaczYeZ3KbW8XQ+CJVPTHerDYj8gbzPYMA1QI1i8ou/ZYXJkB6cAml3aqHIpJlNtwlqVtT9x/ihPLFvPiEA55063ryHa6QnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773730381; c=relaxed/simple;
	bh=ljyddPMNeJM1xI0St2EnDLaNBzK2s/kiqdXyziqVC+U=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YcxmX69rTi/XFfu6l0nIcFeg5wNpSvTfWfvnMDSZ/mazzOYHc5kicu0fNtJ+01KwWDlG47dmMLrZv0JkBpCm8YY/1Qzhf01yW44q86hLGKBITsC9SOtfX1nAVQm3ffCdrmaEnX1OxbwD2TlEIvELN/p8fkxv8IDx0QiGoFVs0SI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=B1iKGcfA reason="signature verification failed"; arc=fail smtp.client-ip=40.107.40.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="B1iKGcfA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRpmXAZ4c6BWkWuxlC1xpq+POHqbfnWicYy7mDo3P+WmXoLT8VU7hLFmf0e3ux9tdB5Gk5k2eq/nnDLX62G98QLTYlbZ/OiBg2t3Bm/DM+MSYaeSgGcjL5lK1wLbkVzpwL1nEaL9Rb5iUP4C0I0Ym2Yl96IofYnhTXdSDOqIbRRKeHxZ0szHljBca/9QcHA7BbnvZLOqCecZLjD8y6ye40H8d595PxFw5sQKG1o+3YKEUJCzIg7bUrnCqmze5MF1UUeq0dcvw/D+riR8P+IiVgv/0ovnwJOLNuA9Tf5f67EOpwWY6QGAFXLiGURSHmzacX+liZ0VYWockHO2NP18EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPHRnjByqP1nY3F0jT++TDlSE7+Q0nSxkEL4uH+5nQw=;
 b=SGck8KBloH22qmxXjzEhvM2tiYgcqQOZzaVPPPtqs9p2pKnnylHihTCRKS6jvhbXZifN7lzoCa9romgWqZxfk7R/KnGVAwSbiQqfOJLlEcKAaHQz7YCoQsvaCRg7Z9lXYfcxc93Brp+jzkLb90go5ppAAt7jSJQGn2/EtiZKdGck64vFX4/w2CwsdD9M93XulEAUibbCRX23ER6oWbF1D72EB1MBmSq+lY5hrelpLTOmACZHj1qixDE9gjhXLR8osbiLaTf9wrhVEdA2uXIA3rf85IO9njbT3b+ch9UDXkiQCvhy3dua34szHJa6p3GYqMsEuRxRvlAGWm69NWHPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPHRnjByqP1nY3F0jT++TDlSE7+Q0nSxkEL4uH+5nQw=;
 b=B1iKGcfA5pNmTNIgGFb4aRJ21c6ozC9R5zBL3m4kVDbYwCWrqRDcz7TR+yo6aSUT/5SayLILkBjXeUVO5+A0qT/VhCw+ryI/L+KqpWJVzoxTTU7drbjhTEd4eIwsW0UHjKsOR3jpXRm/7GeEn5uEGVRNVqGo5Euv80zBdRSdYaXXz+usiT1OhHjB8RIoMvq7X2DK2vM5obSGLmRU5uMz4e9gTuEBXIDk3lzbHhn7wNom3ronwlH8U68oJftr1qBkEZZgN+BliyDYNsBSbBtOhYlgywhmj1Entf09xNCbuir4GSp1NW9ah5b0ws0IF6WLBCVkn+btPM+JEzEZsg5B2A==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY0P300MB1523.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:2cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 06:52:55 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 06:52:55 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "linkinjeon@kernel.org" <linkinjeon@kernel.org>, "smfrench@gmail.com"
	<smfrench@gmail.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Werner
 Kasselman <werner@verivus.ai>, "chenxiaosong@chenxiaosong.com"
	<chenxiaosong@chenxiaosong.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: [PATCH v3] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH v3] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctdquQ6RAMNJ6J0uWDLxUujB7AQ==
Date: Tue, 17 Mar 2026 06:52:54 +0000
Message-ID: <20260317065253.1743552-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY0P300MB1523:EE_
x-ms-office365-filtering-correlation-id: 44540833-1f9c-454f-ac95-08de83f1d10a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 TG0ffLqkUSrlYH8l5GuD6u45je81HyYvrOlge5TfjNxLShNbnT76k/aFk6JXvIXjTQCYlTHvUTJUENydU1FbKieIZdVNy4if5UAizsyyN77EFoy06G3sI28XKxHbR2M2NF2VaUlWRksqz931avmTtXHZQ/Jua13b3o/6I6gvRLhWgTZhF4z5iffJO6raUTAJA7iK6PXOamlKKasUL9PkVhKqORDhTis983K9L7TjzPlfMyGUDwfalI7I0eVOE2OUp16tbvC1Jyb7VF1flG3K30dZGs8ysN54SsZ77Zh3mFy0DilPuk1MS3WHybuwweOYvwLnMkRkXNxZaSoAKC2r2tTFWpRr0hPVub3cD/s1rQaHr+DSzIoFjr6Xrzwb8VJ6SiA6iqK4FXApRtIwIoBbheMAZhlwXQLgowfkyOD3NZ5Ul7oQ8R0I8J2qk8UIcNkb13vK6ySauLQ/CUUDI7+A2wK4ntCfPnCdJdAjJAF0jwlo2X3Ma8miS+wx5hOLWdYlF13EVtEv4v7qZ4HrG+5HC1Ou2yylM+pyUyRdIpEnaaeLSIoPnEcsXfruVnWJjGFxjoPv21Qe1WZ0ya6leBRu8H3tg3GCgMmLo3kYs1gfYTKZR6rf65NV5iavcSC4vSQVgMwxFgn4FXxBt3sQFXeNw8tXk7pjO8q/Nlwz8oDLLhi/e/+VCadwYbIa3Bd1UYZwIfUreX64pipyXsTHVVMj0niHOucdrzpqfgVU6AeoZnrBJAbrY8O+L0yneqArwteleKADskU/Zx2lUx1S+RiwGbyAi96T+hmAFwzss5/atVQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+rqjKt2PTXHk7FJ5Obags2a0VdIq9C9TT5Ha5L/8OTuByM91N4yNnyYt3U?=
 =?iso-8859-1?Q?J6qWws1FN0u8XMrnnTrS1ga2PPP5GSUsghSuFmwjR/tFLhXQhPtBuYqc80?=
 =?iso-8859-1?Q?m2u1aPzvIfCDytKlah4OTqbl0Ktvc1Cj2TZzbSgBFZFx+LBh91FRqYtg9r?=
 =?iso-8859-1?Q?/MG4n8Ojjf4JwokvK/0Mu7/Ehky2S43KjAjmqIEQEdmdN8oKmjj/+7g8yY?=
 =?iso-8859-1?Q?LAsV9ywFSp8pc5aN2ZCfEDk6oDdlUnnkETKrgWym4U5F9YKOP1bTL9ybKp?=
 =?iso-8859-1?Q?WEuodKU3EWx/S9Bcg+OsC0FJ2pq48huwR4BsqHFV9UXRLc87OUJqLTdMEf?=
 =?iso-8859-1?Q?AY9pcGIquY31EqL8Qrx2NuYd5ujlY/vDRgEnoy91bhlw0ijkKYjZ35RFxm?=
 =?iso-8859-1?Q?01dpTj6MJPpKyt2ssDY6hHTldtWFRhbh5PJpN5x7UemGTBL3sfpeFoYzx1?=
 =?iso-8859-1?Q?Wm2Z/DRGmo3GzgDbyCOYXSTC2t70h6IQN3gsTS2xkdFx78mK0n0n/efGbq?=
 =?iso-8859-1?Q?pPwkwtNDByGhjJKqxnVwy7GgasLB7pdFNT8XHHgi+D+TMa6d4KyIQDSvGu?=
 =?iso-8859-1?Q?gx59Xn6klWK8n45DH0hohKqML+G/8u+KvWa/UfDboxDogS6x4s4lBS2h/X?=
 =?iso-8859-1?Q?8kz+5/v1J5uv/TqjPI0z3Fllxm6QEjdUvcrbGCcK+T5X8uylvBkYmmMR+F?=
 =?iso-8859-1?Q?lNZHIvjvvyObncAVEeOKzcnJsl2u+fiwWuEjkS3IzQ/yBNZIVvde+HjLCJ?=
 =?iso-8859-1?Q?bILGCeH2OEWJ92h7M/lqZ0ocV8EI/REg109vgM4vhqm90N43NtzFTbTm3H?=
 =?iso-8859-1?Q?H1upVLQkK4S2X3z7tdFO5cUwyU1LSLd20JYg8RQ6FNAXj/S3CpBgYB5g7w?=
 =?iso-8859-1?Q?2/jcR4OP+6wKzbuxX0159Eavo8L4UYFfmLOOyezGC5EaUtKER/QWTZkQzs?=
 =?iso-8859-1?Q?eIFOkaLyRy1qWosHTP+S898Xa7/ipxh92Cht4yg8OJ8gBOIpr0WxgdS2qe?=
 =?iso-8859-1?Q?Qb6upS4M8nXiPsqijJBM+061Fo4EBhRLkY2Lzvv52eBdcMb4uJkRt7PNMf?=
 =?iso-8859-1?Q?MUNoSw5VX2cuc2w68wGEYWusH+fPDNjYaRa6z+u7LnqWlJSDclxbD53Tn+?=
 =?iso-8859-1?Q?T5dtwAw4yyO+8pu+b14aOjHC652/A6gnQ32onlyDyqT0+7fLf0sKWuihtT?=
 =?iso-8859-1?Q?vW8qqtQitscf8Toi6shiq+RemyR8eFuF+/wWEyAk6BczZCd3/VQqJwdz8o?=
 =?iso-8859-1?Q?ynVFqg+wlHGdnh5RgIrbpGdlYH4IpsnRGtLr4SpkD7Jnmpa2f9mXS2VZIt?=
 =?iso-8859-1?Q?TqIuDUnGASVvaA6XCffAIBqBiH4JFBf7ASd6qvjKNA0YtqsxooxwB2TQLh?=
 =?iso-8859-1?Q?nJ59NDcCX/njXM0eGU/e2gYwRG+/nExyySxpSbcP9iEBxRXS7ppJpizKYi?=
 =?iso-8859-1?Q?zJjbjgd7HPGVZNiIoUL7GS1xvIHq9nqAtH1cMKVPnsrWWhkj6354TaBFaR?=
 =?iso-8859-1?Q?f7e3pHqwDlvcFq1Bd7rhxwg6yI6qb4weylov4ibj+ZJg+j171KWKXuc+mp?=
 =?iso-8859-1?Q?XrxxCl6wuQSxzV/UoXTsks1nZGtlG7E2noRrFwYcyRFJIneN+RsSv/GYsQ?=
 =?iso-8859-1?Q?6mlZTz8iNPKe57y+zJajusHbRZKrg322mDlCipNbqyHkYHJdHwTUngbxRh?=
 =?iso-8859-1?Q?K8YK3exkBg7m1NNCOPueOdEqZb9lZTuqk+32OBJivJHZKhPkDXUznRRj4L?=
 =?iso-8859-1?Q?XjNHeSzgnfwYaG6fFkky0GranhR+wTko3qdb9BFBx0uRGkxSloUkKbRajD?=
 =?iso-8859-1?Q?16dO+3K0AA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 44540833-1f9c-454f-ac95-08de83f1d10a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 06:52:55.0111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFa7jqZcbuCHJ/a2AgKncSNYw8sPxGGmDuR/wPbX5d0TvO4h5a+hd1U8s+gRz6ZuiGqlA13+4EXnkKhhzkfm5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0P300MB1523

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
