Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazon11020138.outbound.protection.outlook.com [52.101.152.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96FB23EAB8;
	Tue, 17 Mar 2026 06:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.152.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729305; cv=fail; b=OMTznYdIoYrxqMOyZekQfHWSiZMnADlVixhR1+Hyyr8DZydRf9wPqoA4nTb4GheNs0fXndZFhvZbVmoE3xQMceTLVQS3TZsRX8TTGXoS30W8AURf8PApGAsGB7GmL/9KxGRy0j6RnqqOZu9FehVrHvcALPm17TMwiVotiZfJ9YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729305; c=relaxed/simple;
	bh=JcIBlsqXcPsNRURwNDB/nqxrcHhmE4swRKz4p47uUaI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Lp+ODxY8Og78J0B0jMTt3hiLbM1Hobc6kk5s3pZivrYOt3PmLKvhAJegG1wo1+uwFLAXY9Sz7HVRfpqf8Sp9zDG9ilTWvyG5qjWrrY4g4gd6AhaRj3gaugMzOtYWFvoAAAIC502vq8Yyvy9rBbS+jsENgJojjVTK+Dfk4hyclTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=YQcvM4qJ reason="signature verification failed"; arc=fail smtp.client-ip=52.101.152.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="YQcvM4qJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQLUSuRJX4gU8aL6NjuAm0PVii9r/M1G5zRod8CC9YbwQVhRKO/kCwTs4DIM97puLpmRlV/tOLEokWsEU4XDfJEJPSd+Nf2OPnPV3Vx49KVkguxkrUIeadsWG2LI+9w/DD+5ukbK7OsA9NSXjfmk3FqWcQ1bB8t0qWGd946B+rVLtwa3ziPq4ULvflhcPXiOi7sKaKAMVZp8V7WUpgiZh5CZHSSNQcIRZxfg3cAVMRHSrgGe0mDSTXa8x3smucU+WIe/w0H66t31hboTLuDZcVWsMMvqdQxsmwZmIQcq/I7yHd4LwPza+KpF8YMky9M6QSm1cWRTVbpMg4pkr8Tfuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFOZTnzQ4Pdwn5IzYlabC6KkIiKmnsYb3ntK4ZqNnWY=;
 b=SN7DptCwt4llxsmBIzk8UI8bSQwLU6ihDslKD+OAU8EUZblbRmLtuCleKCWqoLR3KpHto1XAY7jSobMmmwRbi4dx7+6ts4QV9ZtxNUZcuyZnyCdFykqRroDYBCer+zjr6SbFN4RdHciaJ/giUMFfyqaiFul6SAHuiZDkh7H5RSElmcBtFbEJeu/ctxg5C8blrZ1TaS1jB0L/T8iNdK1VVzaNTH/iwP7SdvbCYzOSV1TNqhNF92jgCLf+2DhJCJMq4Xnr6cVAcrCaxK429R/dJQL9S4nCLD7bnfkAk3lLEP2XxGR2QHnvSWnYMChxVQnDCUnGWn5s1D/YDHC2hMV+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFOZTnzQ4Pdwn5IzYlabC6KkIiKmnsYb3ntK4ZqNnWY=;
 b=YQcvM4qJUdwyNIK0HWMbfih9dL6kHlDyn6x87v0jPWtJykMbULhY8cww06b5O1n0N9uC9/wwbPQ2yyRarTdRZpDKJVBF2LcdUH4todw8F8LEa1lLgtWIOWTLKHR7zEZwUiWVcipm058fOUqWHMpcsh9qkBUdZDPBwErUyE+4P0yJOe4/ZiQuqZ1MYIA4wLLxVQHL0LcfqQs8wh4yozTsai6hhFTomNlB6AJqQw5oSdUQfmHZioCYxCbJkkA03FhwdJN7x1nwKpHdRMxTPIa6i6Z3c9Bn1GTFdPUtrdFkue0lTPLqYvykwuNEfhY9M+gmD6HmRm8fakivg/NIBirYZw==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY3PPF9691F1569.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::4a2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 06:34:58 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 06:34:58 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "linkinjeon@kernel.org" <linkinjeon@kernel.org>, "smfrench@gmail.com"
	<smfrench@gmail.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Werner
 Kasselman <werner@verivus.ai>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: [PATCH v2] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH v2] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctdgsEff47vfbTkCfzgn4d4b/WA==
Date: Tue, 17 Mar 2026 06:34:58 +0000
Message-ID: <20260317063456.1696853-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY3PPF9691F1569:EE_
x-ms-office365-filtering-correlation-id: 395cb99a-25f3-4b22-b6ca-08de83ef4f5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 wj3tlVdH8IJyn+tKLVvdHhu8WYzYe3y3n4WQB2U4AsFp+pB3nWwOfWnBYqVP1nKSzGjAhyd7KyKGypXugGOxiiGV4hfnVp5teZ4kaOumFVryAx8QQxaDHxGNdqxeyyRVI/2NMNVWnHSmRsWVRSWqcbboyA16GRGxj7r3z1JtXAQq5STgD2NCdjI2thq9Bjyktw8uelAKezBQRtdeCGO1oU8qrnN26gPdNcwlbXXOYQoFsIclne3FMMp/DPSJsv3sLrIQH2JaAgiRbjl/DTDP6ddmMaF2ZAus0VzsBknI8NubnpTUH3ag3puQgcZeGwcJsv1agWqhA6nwIEfTGhWGhI7oARdIQRgmR+oEFLaWOX92MlXpxiF0mcb1m+ptKJUFnQnK7rEmYclViHZF5s+0ZKRa+Az30tQNsg+yDOUauK+yKWZhQ5ntF8NHGHmNiLNfLnt13hSlgKH5ZDlyYQa5z+JAChk6cs/9c7VEk/nDqbFJ7I2tIIUAcB0Zoa02Ze4wsWv6sy5TyFUUWiku4o52h7qPiYVJmGCuP9GmugmZ0rQjagw/f3iYvvb3lsHFInsBGZscRVYW0ap1+JwETEozKIEN/6Z2px9fC+aSPk0z9aQ9GgP/t40FCs/BAs/CEzlSxgSHzHPD4JgV8ykQbJeieEd6j4OaY9I0gdtt3STFig0uWqs0xW7rXszfWnLtZd1a+1bkuLdOY8XTff0ojlKcNtmsg4BzBsIDaNY2yhdrcMEBj49S3mMKV5qzeDzqcmB03A2nBk5adIukwPy755eN1bbGckdRLm551UwuvPOLITk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/OaTya/2GvT/ktcv8orQDBKQnLZFXF/cC0aiDocmeGgAULLcMIbHRj2XZK?=
 =?iso-8859-1?Q?SpHZZncmrmJepH0KOu+athztZBPRQDi3ZSQvBxRjUzLJP4c68s+hM+1UkM?=
 =?iso-8859-1?Q?/bJSyMTjVFGPTNvldXaHv1hZxHPJCczbXhxAIO1PP4iqFGP1rSaHdDLKD9?=
 =?iso-8859-1?Q?dE5bW8W6Qxdh2Yz4fktZdt68p618w1INn/LNXr8LkLwLBLU0PzxpEIwgOA?=
 =?iso-8859-1?Q?+h7I8v+ng8U9FhWnzU3io6FWWGZlQ71ey/ujUq9puwuajC/9hbFeUhMr6w?=
 =?iso-8859-1?Q?/sD2Mf6+ZZqicOCvLb4qmyKITDkg2jMIg8J+6Mrpsvbyl8xrlFZAJ8wJp+?=
 =?iso-8859-1?Q?E5ZUXlCDD5+vlKkC/RHPxoVAaPlUy+HYwcJOp1vaPVIV5Qr6SOXjzpEcYP?=
 =?iso-8859-1?Q?bFMaHKP8oOY4GyyTI7BX6+NKqidpFD3IJeUa7O3C8JsruHQVi+PwFMk0bB?=
 =?iso-8859-1?Q?9cAcSd9j+gxxau6dxMDfYhFzA/I/cSamd919665wmx1DAtdry68R3n2+66?=
 =?iso-8859-1?Q?AFz+Cqh5viEM9mu0RVBe+ffEjX2c/xeCy4Y6mwJ8Kzp5jAYQD+towYhKSR?=
 =?iso-8859-1?Q?PRPuVsM+7iqEUYHJ1ib6I5VxcWdUzT2c9+PXHb64ymmEuzuafGdxOyQQNS?=
 =?iso-8859-1?Q?2Sy9+yPHul1Nk1UfrlAchB225KIWvbhuygH4GyqOQyXI43ScdLe1UbAWgd?=
 =?iso-8859-1?Q?FvrdDUP2UWu640hLkOdKaGk3O3A5rO5RbLRSDnxErl/V3xVrlxwLdb9mRE?=
 =?iso-8859-1?Q?DesyWlJjHoLayBzA0jWwFO2TDEDWeUaA/aIMPaoFv93ag//pVR0GL8h+mG?=
 =?iso-8859-1?Q?M7H79xxxcfHh+tcUJlQ+4+TNsBO89YA3RQrAwORr+6IS28u7uugR7FOsIZ?=
 =?iso-8859-1?Q?c/hz3WIpO7z38LdHrA5bLe2WnFcTR1MubmGEzd/q+j3ZKxe9sX1QePb4jG?=
 =?iso-8859-1?Q?y9txqUeeHRcqOFoXZpykQYSg/Nn/sPOiG5wjvM1rXLI4CRexHmzLk7hi9O?=
 =?iso-8859-1?Q?Y9n4Ft9WvmXy81XiK797R5VX6dpuw/kpLzIrctUpU732DKHVaBz5Y3O81V?=
 =?iso-8859-1?Q?sfvu6xUrjQtixWKo3oWHkeHXxoU27+mQtMCuqkBrX5zStaS22eXT6kRbZT?=
 =?iso-8859-1?Q?cFnPZ+JBFszkrThw/fKVXNMJceeGbDetyfCkeswqJAUH3D4CReuL0e37Ng?=
 =?iso-8859-1?Q?HV6467Mw09xTWuF+TsjlBNc6ZrYc2Sq5y5klvVfXfvbFw/DOnGad+e3Bl+?=
 =?iso-8859-1?Q?Wj1QfMuD/WyAponamLDZNhzBdCZwy9vfyLI/O0XEE+zEorPOyFTjYmBX97?=
 =?iso-8859-1?Q?+Bp/h2e9Q7Lflvw7RiUB74F4Zy1LR3t5MGDT+c23DEfRK7LsVmd7nDj9dH?=
 =?iso-8859-1?Q?Bc/YgJRyVO9Bn7zZHJ7/9jQ10T7ZIzmTl03S805ktIkWsD3Tx9lyBIPZ3s?=
 =?iso-8859-1?Q?9DBxIfjWw6WfwcLC64f6UMO0tA3EDSJgsGJ99Qk83WSeEFoKn4wMbDZwAS?=
 =?iso-8859-1?Q?QWYvjF8fV/wEHJ6k91feBqm78o+FfhkrwsAofpKy6IcdIedfNWMd/1F0hl?=
 =?iso-8859-1?Q?Hpu1tsmxTqiHYlJ2TlQmyykE5MpWjVgqFMuL/6b0uxwK57crxbrZQFjEDu?=
 =?iso-8859-1?Q?lHW9DWtC3YkzwiVfLdT59+oMfoRYa7yEsHypICocWC0zdL2K5K2pCOuPJx?=
 =?iso-8859-1?Q?728CfTB+24xEaNNMLqwv79eROa2vJO2ckN04Gj3h1N93a5jbuGourt/jL6?=
 =?iso-8859-1?Q?bvIsvObUdRS+QNnsPzGrYicIyaiOSJK1Fn37l564AQPjkoY6hQoQwfkxET?=
 =?iso-8859-1?Q?zMxH/Nie+w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 395cb99a-25f3-4b22-b6ca-08de83ef4f5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 06:34:58.4539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r73Y10no+fyeeLaw7j/xWaUrgRvK20TgpLB3Pk0xXQmu3oqyVQCCbhv1rJKilCp1YXP7PzfKBTBdPTxCWnmcPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY3PPF9691F1569

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
