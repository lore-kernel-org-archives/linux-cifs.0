Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833281;
	b=TcmjkCIY9kG6HeuQaQfofdc9gLmclwjJkwPPQmBSLHnqTbP3QnZ1JWYXsvptggG7LwTS
	 1wXvhwL3ESiX8Qtd4pEJmpdeFTss/DjbBfwMacTZxQ2GtQPPpwKVrkWwutdD9HdUJ/m+l
	 NIAa0teSSIPdJj9QDneEvk7sBXDwHd4XNE0NBPLnaWwf8tRRdT/WcCc6V1Tv+16JSF5Fc
	 1IwsyWPNA8LguD63AkPaEUQQ3rOCjZB7cw4mjynb+UPm1VujZ+mtaHtqUCuGYz3zWp/1y
	 J6U3+R+1I6Gkf3rIPZcsxzNF5Ep3qzTf7DyFU+r9TQq+G7fgXnvH3xJREFmT1gBtTOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833281;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4Nhh+Myk7Yfs7g/NU55nfHgNLFz8G3A8qUiieuO0GHA=;
	b=PzW1ldQkiBkQnzuRbGIem0Ms9O14fEA7aURT9O15IrrNztXLgICAdhx+f+dbXNxF0VNE
	 B8pPajMF2qZcwapiWpIj0MLz2QgujXC00AObpVeev8rMK6Wi3z85y6/DWpmDSRsM3h6u5
	 2zmKb8z31tPpRjTSeYiM15UgLFECBz742/tDbcEURBxfLo2itxD7ZsONdOF3eYcZPqM/4
	 uMmXXX81kewEYrxZX2b05xzAG5BjS+zbDLNUICqKltm+ddFqNpvbY34U0E+LyuYAVByIE
	 t5pfNy5BsOJ6A0Bo3HWAn0u9Q4q8PsXOi3xU6mebkO9syIBhkJzAD9EgwcBNn83gpHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=U1tKZadF;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=aPRQ9mdi;
	arc=none smtp.remote-ip=202.12.124.143
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C419606A32A
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C419606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=U1tKZadF;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=aPRQ9mdi
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 866171302EEC
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 07:47:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 16 Nov 2026 07:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794833278; x=1794840478; bh=4Nhh+Myk7Yfs7g/NU55nf
	HgNLFz8G3A8qUiieuO0GHA=; b=U1tKZadF2VJyDxGh17o2TR6Y/hDq9s8lTfFSQ
	eg+CB3scY7p2OW+OsAiFwaozSSvPxANIq4FNoCTQ0Wg3oJZiPXJcH8baCb1Ca76R
	P6mW16vH+tUwDMCocTQAr08KOAjDrL0dV5p0YQNYlK7yTnckEjelDCYf1MGZJZG8
	vHr6QdUYaGUrARSafINdu1qIeg2xFCVA/gzuwnTkKkdCI7UCcLy1j2aF94saFKdK
	5tCA2I7iPBPUyrLfIenKjbWmy86FeNXISiTss+LP96okCPlqGwHh/9F7m/CxPohf
	GjXpcWLKDWZ8QyiKs/Y2LUuHd5TjR9lbDabJArbwwikRcmU9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794833278; x=1794840478; bh=4Nhh+Myk7Yfs7g/NU55nfHgNLFz8G3A8qUi
	ieuO0GHA=; b=aPRQ9mdiCJkCYXrDFhUhIR3rwTAKFLj1lMQIxbmm8xXj2hJtDYp
	WsevN9eRiIDdl71EzbSeXmYeMa/eciDlufIVAnG6Y6WeupZDoMAW8wVTAhZQ03kV
	Wfkjv2Du5x6c30yiUoWStqDKsTLQQl0/kM5e4+wG9lSr3WxDbC6SbnS7A9DobTNf
	sqzaNae9LbpiLNbNR4z+ZmAlwVnRahFEh3vTXuj2T5rvxAdFBi7mvdervljifwR5
	IUYNiyWyV7sPBWETPnOLx7wssaebVKVt0U7FsqFQbMDdz6V7NAEBkn6ZMl2MhRpU
	lz/mSWyMgX3pj07ShVsXWm26uA6vUEc5NRQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794833278; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:L2VEjDv+GnRx525KtRM71b99OO/qRNkQEPbWrBtckg0GLxf
	jfSS37vExGyJdSnzPPlPUQnhs6e8/Wnai3Iyz1eboMTg0nInd4XD/YMHiSJFPC0o
	7cqUVulChlklnLAxCzjk4Iou/Lqr1LAPcQnIzBlV21PIJNWmntxIZSyC+N5oE/t6
	dO2crlahz+5nhQaLFRXlzPv79A6oE0u1hXbhE+cng3MmnvsLVjc2jfugy3bj4gsH
	/ZZ6YelE5eSMff41OSgTt7Yyf4ZSnRLVf/bTbjk7hNnM0EXKsLcoAINWsuncAnO8
	waNwoNNIC14ckbHSczrNu5INe0b0jYqyWWom9ug==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:2RS39Rpgbyaw+8J2joXdq/Rgs0beJss6U3tJ1RZt3Cg=:+GDiYo6tSkjCHtYSxwo7Nfv3StSVNtQPClNLOgx/qfA=;
X-ME-Sender: <xms:fvv6aoumcHJ9VW66bg4iG_Ed4iV0H88VTAcGkQOU8TJtLXqEnK1Gbw>
    <xme:fvv6ahfJc-KqR4BL3SQKZTXkh-pFcLjNwCFGubOWO4JbCTJfQXi9ek_A004IPcUw7
    AAnYCJ0gKwt1GoPDjAeb3FipzBRAc-0Ju-OUICd6aPgRn9VjyKVRDQe>
X-ME-Received: <xmr:fvv6al-Z7kcEPT7tFJSPI4-p7rP72U1XXT73MQ0aOt99PH1Uu-ujPWtogaWLYNkl>
X-ME-Proxy-Cause: dmFkZTGOySjBYUo1B/JhD/yzmyleGW1OuzjED8GPy471VzQhXLb9eNFZLQxwb6UFphxkRL
    wTOOhzJBg9NM5KPvKTo8Bq1EW6KSwa/VudHHhPZRA6JxQJhssBlD/dU6guPRDGBZ3L58nx
    CfiulJTxysAYJYSsj2UkXcREckeP7jAOauV+kfRXmv4Zm48F8QRmhbnY/12O4vz4owk93i
    OjDXzkeXEOJ9YN/SsMxxOdndmJ05+S0J/KCASAoWBlZeTDUDae1mOKBs78n4exIk9QdcT9
    Qk61QLh3on1tJ+1YkKk+N4Ldqwwh7sqJBOF+7bZafEjqVohRJty0jADSRICylIj6G2M+KS
    LuPSUGKXO/DYTpjrsdR/sg+tD86mFjRc5SejIhTiXqz1pb4yPUqc87JXAyxXOoIjyrvn5f
    jOXipmppcjFXMKL3BZVQYoAJIy20pqV9uwQeByCEi0AXGK2swwGbXiMTOxLF3yPrrfirEl
    BoVa8BOR+c01UpcC2VNwTJfsnL0QtZYDejwiX/ZRceA1nrdC0++f1sEae7FzP9hw3vnjFX
    QUMkA1zcURGfX6jMSrCFZtXsxJnP6GsV5B0ll/cFEtHFVHxORVSZPmRyRNTUGcHR0GfEeB
    MBj5u2fncUZGbMVaMgF5ZwyNQz7zNa7ExeRi79kfCfT5DFvvlCl0yAS3rQrw
X-ME-Proxy: <xmx:fvv6asSHqvYcTVm8fs4niGq6YYG35uEU5u6dzLAEDcqKEcLDdOjX3A>
    <xmx:fvv6amq7Y-TMrG5GceX8g5I86UVAtIakNg49Zg7JnkkMiAUpFQI6Yw>
    <xmx:fvv6apm9HJjTbrqokxZgYfXdz7SMO9rCeg_d-NVPDIeekInMrrziGw>
    <xmx:fvv6avdfII_gWCKpyaXzHZL9-eBFPnp2ZnNAYlnHJzO-qkKh9Rasug>
    <xmx:fvv6apQQXiZnXFPG2w7hQx6tvf-pvfzZ6Khvh4BDrZyvyyW5Bl-rzYw4>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:47:57 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: do not treat an unreadable security descriptor as none
Date: Mon, 16 Nov 2026 06:47:53 -0600
Message-ID: <20261116124753.2521705-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On acl_xattr shares, a failed security descriptor load makes access
checks fall back to POSIX permissions. An allocation or read failure
can therefore bypass a stored deny ACE. Security queries also fall
back, returning a descriptor built from the inode instead.

Fail access checks and security queries on allocation and read errors.
Keep the existing fallback for missing xattrs, unsupported xattrs, and
malformed or stale descriptors.

Propagate POSIX ACL read and allocation failures during descriptor
validation too. Otherwise, hashing an unreadable ACL as absent can
make a valid descriptor appear stale and allow the same fallback.
Leave the descriptor store path's error handling unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: f44158485826 ("cifsd: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Tested on ksmbd-for-next 3bc1fb9c3b20 with KASAN and failslab.
    Failed descriptor and POSIX ACL allocations now fail opens and
    security queries instead of falling back to POSIX permissions. With
    hide unreadable enabled, directory listings omit the file. Files
    with no stored descriptor behave as before, including under
    allocation failure. smbtorture results match the base.

    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c |  7 ++++++-
 fs/smb/server/smbacl.c  |  5 ++++-
 fs/smb/server/smbacl.h  |  6 ++++++
 fs/smb/server/vfs.c     | 28 ++++++++++++++++++++++++----
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9ef2d086fc4e..a900f1331c42 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8503,10 +8503,15 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
-				   KSMBD_SHARE_FLAG_ACL_XATTR))
+				   KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn, idmap,
 						     fp->filp->f_path.dentry,
 						     &ppntsd);
+		if (ppntsd_size < 0 && !smb_no_stored_sd(ppntsd_size)) {
+			rc = ppntsd_size == -ENOMEM ? -ENOMEM : -EIO;
+			goto release_acl;
+		}
+	}
 
 	/* Check if sd buffer size exceeds response buffer size */
 	max_len = smb2_calc_max_out_buf_len(work,
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 0ca093de83c6..9aac87ff3b4a 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1545,8 +1545,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	ksmbd_debug(SMB, "check permission using windows acl\n");
 	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
 					    path->dentry, &pntsd);
-	if (pntsd_size <= 0 || !pntsd)
+	if (pntsd_size <= 0 || !pntsd) {
+		if (pntsd_size < 0 && !smb_no_stored_sd(pntsd_size))
+			rc = pntsd_size == -ENOMEM ? -ENOMEM : -EACCES;
 		goto err_out;
+	}
 
 	dacl_offset = le32_to_cpu(pntsd->dacloffset);
 	if (!dacl_offset ||
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index bbd35948a379..6bb64fef02cd 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -95,6 +95,12 @@ int compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid);
 bool smb_inherit_flags(int flags, bool is_dir);
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
+/* Missing, unsupported, malformed or stale SDs retain the POSIX fallback */
+static inline bool smb_no_stored_sd(int rc)
+{
+	return rc == -ENODATA || rc == -EOPNOTSUPP || rc == -EINVAL;
+}
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool authenticated, bool strict);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 09dad151360c..45618b2bc1fb 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1630,13 +1630,15 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idm
 
 	posix_acls = get_inode_acl(inode, acl_type);
 	if (IS_ERR_OR_NULL(posix_acls))
-		return NULL;
+		return ERR_CAST(posix_acls);
 
 	smb_acl = kzalloc(sizeof(struct xattr_smb_acl) +
 			  sizeof(struct xattr_acl_entry) * posix_acls->a_count,
 			  KSMBD_DEFAULT_GFP);
-	if (!smb_acl)
+	if (!smb_acl) {
+		smb_acl = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	smb_acl->count = posix_acls->a_count;
 	pa_entry = posix_acls->a_entries;
@@ -1712,11 +1714,17 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 
 	sha256(acl.sd_buf, acl.sd_size, acl.hash);
 
+	/* A POSIX ACL that cannot be read is hashed as none, as before */
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
-	if (S_ISDIR(inode->i_mode))
+	if (IS_ERR(smb_acl))
+		smb_acl = NULL;
+	if (S_ISDIR(inode->i_mode)) {
 		def_smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 							     ACL_TYPE_DEFAULT);
+		if (IS_ERR(def_smb_acl))
+			def_smb_acl = NULL;
+	}
 
 	rc = ndr_encode_posix_acl(&acl_ndr, idmap, inode,
 				  smb_acl, def_smb_acl);
@@ -1770,11 +1778,23 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	if (rc)
 		goto out_free;
 
+	/* ACL read failures must not masquerade as a stale SD */
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
-	if (S_ISDIR(inode->i_mode))
+	if (IS_ERR(smb_acl)) {
+		rc = PTR_ERR(smb_acl) == -ENOMEM ? -ENOMEM : -EIO;
+		smb_acl = NULL;
+		goto out_free;
+	}
+	if (S_ISDIR(inode->i_mode)) {
 		def_smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 							     ACL_TYPE_DEFAULT);
+		if (IS_ERR(def_smb_acl)) {
+			rc = PTR_ERR(def_smb_acl) == -ENOMEM ? -ENOMEM : -EIO;
+			def_smb_acl = NULL;
+			goto out_free;
+		}
+	}
 
 	rc = ndr_encode_posix_acl(&acl_ndr, idmap, inode, smb_acl,
 				  def_smb_acl);
-- 
2.47.3

