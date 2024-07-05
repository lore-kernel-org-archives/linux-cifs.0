Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4241643D
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 03:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720150057; cv=none; b=Ux0xT7SSUy9SlWZV/78XapJpWtLgVojNbC7HK4Gji9YttQUnsnK30IfNv6pv52BRfgpQbIAzwaMTDNLIKGBSsK/9M/aDBJh6KVFLIabesCsBJqTvQgXs822hOCx8GE6rUWJszmVqVWeskfNy7v/M0UGOMdNYrGmNEx0LAVyopMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720150057; c=relaxed/simple;
	bh=X/J/b5sW9LFWV4FiYsItor3WcQPMWf64DkLrqMoa5vU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=AnbCY9NfKgkBybcKWVbU6KD8uUGzIK79a/K+9tL4VVmlPvxyP4sasfQbZ+Z7uftYvkKocqdKDg9gbQEVtP/ka7mGxOY3BZFsOzFg9KHcD9C8iEz6tzTsQ2heC+IZVjbxvOcUQgIoR3agLYClhQMEElku/c+xyAtffHDwDU3SJms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SBmE2a45; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SBmE2a45"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240705032733epoutp03deeebb652c54feb550f4102370b40d1b~fM1wF9mSO2492324923epoutp035
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 03:27:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240705032733epoutp03deeebb652c54feb550f4102370b40d1b~fM1wF9mSO2492324923epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720150053;
	bh=aKD8Q08Ks5U6vGq7CNJevKdqAROIak+XQi0kaV4pn7Y=;
	h=From:To:Cc:Subject:Date:References:From;
	b=SBmE2a45JDG5IY2tGyiwLo2OaK2jYBqXcS8cAiBOkCZiZ9FsaoXF+FRXIC9W6el1D
	 Nj65LRARxgScVOCTuhzCJ1fvYB3Do9WSLBU9XD1KQmv4grlOPpGBNukOgyMyzeurH5
	 O+DTFQOk08+aj6HDYLvHbJr8raLaCVTq2ZfWmzqk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240705032732epcas1p20524a1f9bafd376c45e300831e5c5ca5~fM1vsyNhY2261322613epcas1p23;
	Fri,  5 Jul 2024 03:27:32 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.36.222]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WFf8g6fTKz4x9Pw; Fri,  5 Jul
	2024 03:27:31 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.93.09847.32867866; Fri,  5 Jul 2024 12:27:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240705032731epcas1p177d910a154ded37c459af1c2374a3571~fM1uteD6r0569305693epcas1p1P;
	Fri,  5 Jul 2024 03:27:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240705032731epsmtrp2d2f4cb229d7f642d448f58d3e7a9bae4~fM1usvWa-1872618726epsmtrp2g;
	Fri,  5 Jul 2024 03:27:31 +0000 (GMT)
X-AuditID: b6c32a36-86dfa70000002677-9a-668768230418
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	93.FB.29940.32867866; Fri,  5 Jul 2024 12:27:31 +0900 (KST)
Received: from linux.. (unknown [10.253.100.137]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240705032731epsmtip2001829d5f294f6660b438915c22a1836~fM1ujMi3W1113911139epsmtip28;
	Fri,  5 Jul 2024 03:27:31 +0000 (GMT)
From: Hobin Woo <hobin.woo@samsung.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com,
	kiras.lee@samsung.com, Hobin Woo <hobin.woo@samsung.com>
Subject: [PATCH v2] ksmb: discard write access to the directory open
Date: Fri,  5 Jul 2024 12:27:25 +0900
Message-ID: <20240705032725.39761-1-hobin.woo@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTT1c5oz3N4MZsQ4tN018yWRxoecNu
	MXHaUmaLF/93MVvs3riIzaLj5VFmiy3/jrBanPp1isni6Im7jA6cHrMbLrJ4bFrVyeYxd1cf
	o0ffllWMHpefXGH0+LxJLoAtKtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+gqJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BWYFecWJu
	cWleul5eaomVoYGBkSlQYUJ2xsOfu5gLuoQrZu0Ub2C8zt/FyMkhIWAiserZVpYuRi4OIYEd
	jBJLOyczQzifGCXuNc9jg3C+MUqcmzeHCabl0MI9jBCJvYwSE8+fg3KeMUp8f/GUHaSKTUBd
	YvedRrAOEQE5ibWbToItYRY4yihxe94WVpCEsICLxNIptxhBbBYBVYkVP+8xg9i8AlYSb84d
	ZIZYJy+xeMdyqLigxMmZT1hAbGagePPW2WDHSgi8ZJeYMvERkMMB5LhITLwlA9ErLPHq+BZ2
	CFtK4vO7vWwQdrHEupProOI1Et2z70DF7SWaW5vZQMYwC2hKrN+lD7GKT+Ld1x5WiOm8Eh1t
	QhDVyhKNj5+zQNiSElOWN0KVeEi8fi8JEhYSiJVY1XmJbQKj3Cwk989Ccv8shF0LGJlXMYql
	FhTnpqcWGxYYweMxOT93EyM4LWqZ7WCc9PaD3iFGJg7GQ4wSHMxKIrxS75vThHhTEiurUovy
	44tKc1KLDzGaAkN0IrOUaHI+MDHnlcQbmlgamJgZmVgYWxqbKYnznrlSliokkJ5YkpqdmlqQ
	WgTTx8TBKdXAtDR5qola2t0fGlHs6z3fRriV3n+/8c2Uwqulel1dbNt3lPQ4nDz9gJ858dnu
	mpMVqiyu02JWSxoX9H/RcWKYUXBTaY3miYCbf3TVvl2MnuUtkbTu5s68nSL1z3V0/yqZsWas
	PnUjLtnlffguwefbXkWtuZpySUyH/1JcyAI7JePJLy97THSMV4rf43P6gParjuaGqV1RMybf
	rV1UyPl4cfUnAT7Rv/NWvm18H76Zgdn5u9Xl1Nu3X7T9nmn2KVNiZvu+Sa8Wb7si0+a+uVDS
	kyHEdd3V+9+tWaWaNzIuq8iqsJu2TGqBwn7WSMEnW1mc5pxbcen6AdmpS6edcWI+0T4zcL/8
	4XvX925Zs8Tk+XElluKMREMt5qLiRADnRxv+FAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSvK5yRnuawYyr0habpr9ksjjQ8obd
	YuK0pcwWL/7vYrbYvXERm0XHy6PMFlv+HWG1OPXrFJPF0RN3GR04PWY3XGTx2LSqk81j7q4+
	Ro++LasYPS4/ucLo8XmTXABbFJdNSmpOZllqkb5dAlfGw5+7mAu6hCtm7RRvYLzO38XIySEh
	YCJxaOEexi5GLg4hgd2MEn3nTzJ1MXIAJSQlnl2SgDCFJQ4fLoYoecIocXz9PHaQXjYBdYnd
	dxqZQGwRATmJtZtOsoDYzALnGSWWnksBsYUFXCSWTrnFCGKzCKhKrPh5jxnE5hWwknhz7iAz
	xA3yEot3LIeKC0qcnPkEao68RPPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84
	Mbe4NC9dLzk/dxMjOHy1NHcwbl/1Qe8QIxMH4yFGCQ5mJRFeqffNaUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5xV/0pggJpCeWpGanphakFsFkmTg4pRqYxA9Is3yeZxg5K1u07E7p8gnFfPW/
	amIM/p0vkjFRtXvBlbFdgelr+P+bp45NSv3KnLr3w8Pt+1a32uyv1wy4dnbqqsjtVpfyLBdX
	bqsSPnrgSpvd5S/Prz3bxfTHktvi1dJEvz/mFlvSS1Zec323I/vfXiOHVWpzTq0q8L/Od6fV
	sTdmsabvmdnXN277qJozaXM44wrNBf8nb6jnPGvNma8a8j9l8rXA93envneTdN38qKlk01al
	Y+w/l04UvxYb9uoMh/W5Wb0bf9+exM0+U2zB5oDfT2etTNpc3rI7onXx1EpBrXtXpiy91lK8
	xefdDD/FeLnu3csLstbKCsxZfcLG507FjUoR/r0qty7yvZukxFKckWioxVxUnAgAOCgTxc4C
	AAA=
X-CMS-MailID: 20240705032731epcas1p177d910a154ded37c459af1c2374a3571
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240705032731epcas1p177d910a154ded37c459af1c2374a3571
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>

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
v2:
 - Describe 'is_dir' in function parameters of 'smb2_create_open_flags'

 fs/smb/server/smb2pdu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e7e07891781b..7d26fdcebbf9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2051,15 +2051,22 @@ int smb2_tree_connect(struct ksmbd_work *work)
  * @access:		file access flags
  * @disposition:	file disposition flags
  * @may_flags:		set with MAY_ flags
+ * @is_dir:		is creating open flags for directory
  *
  * Return:      file open flags
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
@@ -3167,7 +3174,9 @@ int smb2_open(struct ksmbd_work *work)
 
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

