Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA8FB666
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jul 2024 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720053355; cv=none; b=SI3Qo+uLPKlXBLXOavcyU/PjeGJxG/LPC9ow7jsC5NXMh+/7q+I+62zxCY+eS9RCe9zf8bjvTxO/+/g/gGtNuT2EWsCydPH/Kqq8153CHZn2obAdynznhteerL3kc8d87/Xv7Qzn/PE8Z/31ckeI0uF22czrF8CS4alp1C6h3T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720053355; c=relaxed/simple;
	bh=JCWGg7lRVXbDrezZqjMst3bCH0mnwlOacdR6A5hWwUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=Wrh6kI4BYw8Whx+R9XED4teoCVoOxUp7Ua03ehd0Tm/lflY25G6q94hogKsLtLEZVZHfJilRF7LnsZ3xOoyuO2u7SGN9fKFQ0notQ6Ua93p/9Tj2+eMR6pClM0AXz3v/w5oBbqLmcTAAC8H6mT/Q94T7WStn7quv/XBVEvbLb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MaxVruKs; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MaxVruKs"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240704003544epoutp049ef878f84c7cba6ab01e5a94e3c3df4a~e22dJjq-L2930529305epoutp04O
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jul 2024 00:35:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240704003544epoutp049ef878f84c7cba6ab01e5a94e3c3df4a~e22dJjq-L2930529305epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720053344;
	bh=mLlaAcfMzcAx/hRnA1n5IiEj5NmZN6VWK3Nyv1lVleM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=MaxVruKs29/g5AwjTN0xo6QGuo0xof7bW143t8HWgSrb4iEyERrCVaCs8A6gV66nV
	 W+yslA5paPuE8kgeTz5UbZ9h9zReNKKxVy+6GftER+LwEKiDI9Tn2s/8I8bO2c3hFW
	 XM9EUcclVry1AMmqAW+ZIFY8B1Bp64WVM/fFPddw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240704003543epcas1p4a8366ede918b1484aa7ffaaf6d5fab6a~e22cxW_ai2043520435epcas1p4Y;
	Thu,  4 Jul 2024 00:35:43 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.36.223]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WDyNv27znz4x9QK; Thu,  4 Jul
	2024 00:35:43 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	DE.C4.34823.F5EE5866; Thu,  4 Jul 2024 09:35:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240704003542epcas1p15a42d38be6cebe95eaabbd828674d97a~e22btsDcj2878328783epcas1p1O;
	Thu,  4 Jul 2024 00:35:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240704003542epsmtrp167997bbbd2895799e2569c2b10744081~e22bsytrK0788707887epsmtrp1Z;
	Thu,  4 Jul 2024 00:35:42 +0000 (GMT)
X-AuditID: b6c32a35-e8dff70000018807-5f-6685ee5f619d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.7C.29940.E5EE5866; Thu,  4 Jul 2024 09:35:42 +0900 (KST)
Received: from linux.. (unknown [10.253.100.137]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240704003542epsmtip204fc2374ca1c52972af5310160092796~e22bgTwOQ0492204922epsmtip2T;
	Thu,  4 Jul 2024 00:35:42 +0000 (GMT)
From: Hobin Woo <hobin.woo@samsung.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com,
	kiras.lee@samsung.com, Hobin Woo <hobin.woo@samsung.com>
Subject: [PATCH] ksmb: discard write access to the directory open
Date: Thu,  4 Jul 2024 09:35:37 +0900
Message-ID: <20240704003537.4690-1-hobin.woo@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTVzf+XWuawdVJfBabpr9ksjjQ8obd
	YuK0pcwWL/7vYrbYvXERm0XHy6PMFlv+HWG1OPXrFJPF0RN3GR04PWY3XGTx2LSqk81j7q4+
	Ro++LasYPS4/ucLo8XmTXABbVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCswK94sTc
	4tK8dL281BIrQwMDI1OgwoTsjB9//7AVvBWouNjxgKWB8T9vFyMHh4SAiURXV1AXIxeHkMAO
	RolrD/ezQDifGCW+z/rNCuF8Y5TY+OcXYxcjJ1jH7d+97BCJvYwSnRtamSCcZ4wSi+Z8BKti
	E1CX2H2nkQnEFhGQk1i76STYXGaBo4wSt+dtYQVJCAs4SrTsvQZmswioSpx8dYQdxOYVsJR4
	fXIC1Dp5icU7ljNDxAUlTs58wgJiMwPFm7fOZgYZKiHwkl1iXft0ZogGF4n1rUtZIGxhiVfH
	t7BD2FISL/vboOxiiXUn10HZNRLds++wQdj2Es2tzWygkGEW0JRYv0sfYhefxLuvPayQAOOV
	6GgTgqhWlmh8/Bxqk6TElOWNrBC2h8TWIyvAJgoJxErsefSDbQKj3CwkH8xC8sEshGULGJlX
	MYqlFhTnpqcWGxYYwmMyOT93EyM4NWqZ7mCc+PaD3iFGJg7GQ4wSHMxKIrxS75vThHhTEiur
	Uovy44tKc1KLDzGaAsN0IrOUaHI+MDnnlcQbmlgamJgZmVgYWxqbKYnznrlSliokkJ5Ykpqd
	mlqQWgTTx8TBKdXAFHbo5OQ1KbUryiW6V0VEcKW3qoRV/3LcezpLJC7a+/gP98n2MbH/t69n
	LBDSWv1p5xU1k1Vml1ceMVM8MDnbbNFf1UtbX3sHPNRuv7wgpnqPTq3XZotPIppVec9dWdlf
	fltzhbtWT8ynqPTang3frqwXWL/26DbzG0e2bU9e0sc+T0xU7jpL5TT2kB1ftSfmd85WfxnL
	Hxfn4n/Nd5Ha8W3K8v8nPsx+Gzm7dbY7j5/Qcs5JrZ0b3T3XH591Rb00QXCa3p+0SVP7U1g/
	qU1M3fz7WT6PCXPkfZ+q000aiRIHdq+0NEkO//1rtvaDPSvvCNzauoslc39uu8YrXt8FBWsX
	lLmte1b2TYiXV/6DiBJLcUaioRZzUXEiACptE9sWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSvG7cu9Y0g43XtCw2TX/JZHGg5Q27
	xcRpS5ktXvzfxWyxe+MiNouOl0eZLbb8O8JqcerXKSaLoyfuMjpwesxuuMjisWlVJ5vH3F19
	jB59W1Yxelx+coXR4/MmuQC2KC6blNSczLLUIn27BK6MH3//sBW8Fai42PGApYHxP28XIyeH
	hICJxO3fvexdjFwcQgK7GSWuLNvP3MXIAZSQlHh2SQLCFJY4fLgYpFxI4AmjRP9hFhCbTUBd
	YvedRiYQW0RATmLtppNgcWaB84wSS8+lgNjCAo4SLXuvsYLYLAKqEidfHWEHsXkFLCVen5zA
	CHGCvMTiHcuZIeKCEidnPoGaIy/RvHU28wRGvllIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3X
	K07MLS7NS9dLzs/dxAgOXy3NHYzbV33QO8TIxMF4iFGCg1lJhFfqfXOaEG9KYmVValF+fFFp
	TmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBib3c6L+4aI5Lqt3JquX7jc327R8
	Wyej45SEBTcPCEr42odtv1w2ZWbjmdc7mf4uOhcS0LTbc9qf6fcDDjO/dFh+eoKv1qXq0EcW
	vV9fz1XSk9xYG/HPTfKJgnMG35w6fiYXttz1jJe/bYr8WivmkdWWpbz0lXZsPdeunfuEwnP3
	Ofn+XNp56EHgLpWyTQVT3/xi3xx93HaGrBxPvODyqe0zPzHeuPl4mcj7yDMnndx7vxjEdT1u
	E42ePv1hT3qFc4LKw9uyO6e23D/JJtZwL9BagDXzuMB0qV9J4surcifN0rk5Of+SxDs+68lL
	EmUavnffF9I/+P9n69q9Bp/EpeIqbhVezN/+eElywvcdPBZKLMUZiYZazEXFiQDqmGp6zgIA
	AA==
X-CMS-MailID: 20240704003542epcas1p15a42d38be6cebe95eaabbd828674d97a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240704003542epcas1p15a42d38be6cebe95eaabbd828674d97a
References: <CGME20240704003542epcas1p15a42d38be6cebe95eaabbd828674d97a@epcas1p1.samsung.com>

may_open() does not allow a directory to be opened with the write access.
However, some writing flags set by client result in adding write access
on server, making ksmbd incompatible with FUSE file system. Simply, let's
discard the write access when opening a directory.

list_add corruption. next is NULL.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:26!
pc : __list_add_valid+0x88/0xbc
lr : __list_add_valid+0x88/0xbc
Call trace:
__list_add_valid+0x88/0xbc
fuse_finish_open+0x11c/0x170
fuse_open_common+0x284/0x5e8
fuse_dir_open+0x14/0x24
do_dentry_open+0x2a4/0x4e0
dentry_open+0x50/0x80
smb2_open+0xbe4/0x15a4
handle_ksmbd_work+0x478/0x5ec
process_one_work+0x1b4/0x448
worker_thread+0x25c/0x430
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

Signed-off-by: Yoonho Shin <yoonho.shin@samsung.com>
Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
---
 fs/smb/server/smb2pdu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e7e07891781b..bebfa5f6d82e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2056,10 +2056,16 @@ int smb2_tree_connect(struct ksmbd_work *work)
  */
 static int smb2_create_open_flags(bool file_present, __le32 access,
 				  __le32 disposition,
-				  int *may_flags)
+				  int *may_flags,
+				  bool is_dir)
 {
 	int oflags = O_NONBLOCK | O_LARGEFILE;
 
+	if (is_dir) {
+		access &= ~FILE_WRITE_DESIRE_ACCESS_LE;
+		ksmbd_debug(SMB, "Discard write access to a directory\n");
+	}
+
 	if (access & FILE_READ_DESIRED_ACCESS_LE &&
 	    access & FILE_WRITE_DESIRE_ACCESS_LE) {
 		oflags |= O_RDWR;
@@ -3167,7 +3173,9 @@ int smb2_open(struct ksmbd_work *work)
 
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
-					    &may_flags);
+					    &may_flags,
+		req->CreateOptions & FILE_DIRECTORY_FILE_LE ||
+		(file_present && S_ISDIR(d_inode(path.dentry)->i_mode)));
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		if (open_flags & (O_CREAT | O_TRUNC)) {
-- 
2.43.0

