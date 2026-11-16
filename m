Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871171;
	b=m/sAmXm7uz+/h2+/TUnJb2nd3rdszJhcrGoB9MDyTyewOP9cvKvU1kYcQZfC1+wAD5AW
	 85maS54VtC9sNowcAE9h+8p3tHHOfjcyhd6f+yzEVwJrhvnNn2vidBX5Fm0wy34vKjzVM
	 GLbe/g/7SXdo8CsoEdZi5oTXGlkeO/bF14VcFghotIiICqPdsyucs24BGPrCeoKWHuBBq
	 rM7lMmCU+GhLGnxorVjSYdz3NVsdHRsCkLfQg7hkOjIEXSt+zBBm7cYYMgH86pyWc1IpN
	 N1emwS6wjxHs6Rx17+zVXJ3W/310qldcmaPbYGRjj+Wp41pUBK0ooM787lH7WRA4Oeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871171;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3mi2MURLq2D9TIEmt+9IdF6d4vDvoX02siG9m/EXZ/Q=;
	b=Xsg0Rl4YSY7P/AsSdJdmis+OV6JMlsl00vth0rzTpTG/OvxUKCSmGJVZav0OP0zZu1Mk
	 OPEoqi0Rxfw/TWHvtUYdlL4YYDrpm4n3RWJk+5VM3NaNIy6Ddexjzo03hwk72/Cpi8Zvv
	 jwNSU0jWc4psoImSqKNd01iVUxeBTX6eX79Xw71trfOqDkOfeSj9s/j3wGCnsyMbz+g4A
	 wipXwAjCn0Jhxi0UqIZ/IuV6mwfyLI4JsSLMyYy+K9G6dYaTwKI7Yfk5hDaxlFvsIWvip
	 3xy/yZnTf2pqSh5C5wkL5KVHw3dV1LWaemDYYpS/DEUQ6SbsdJn2TSy5sHOyjrf/b9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=oDdQA7LW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=YtYuZmgC;
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5CA606A323
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 23:19:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A5CA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=oDdQA7LW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=YtYuZmgC
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 58E6A14000BF
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 18:19:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 16 Nov 2026 18:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794871169; x=1794957569; bh=3mi2MURLq2D9TIEmt+9Id
	F6d4vDvoX02siG9m/EXZ/Q=; b=oDdQA7LWbhN0QhIsXgBZiOWEbwKIHKtrymJOa
	IqkCI+MjeWAc+R3daAeoHXGHs0G031/Fn++YxjXZISFoFb1BZBse4+tTTNel59cu
	RB686NXi6UlUlUiwQ0A18b3VG7MGaBAYZyoQp9ieimSUP5bUFVFbAbgSbX5HF9zr
	Gphuhw+DNoN9YzESHWVfVRvgKzh+bUAMSdSjZ4hHZspT8FfmyiOteg4YITDajtDT
	4Gew16y6uP0yH3/m/KsEcy1Av37xlvIarH1NHwU29wTO2xSn9Obldm4J0Pn5S0r1
	FBNtXY6W+0LxKNTSIHE0/x2efSAuq1ucKHr7tJHNwz9SHzixQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794871169; x=1794957569; bh=3mi2MURLq2D9TIEmt+9IdF6d4vDvoX02siG
	9m/EXZ/Q=; b=YtYuZmgCF08Rm1tZ3cHREAeKNFcElzeb8YY97NfZx2xov74QNi+
	NvAla9b7AxzQIVYvhT3ohMFvSnn3Xz7WC9vQMrFRx/FEAS0y0VjvSMpVfWNX2QPg
	2/mJdROoHW8G5zozXux1A1LzO86tWIP2jGg1FUL4ODO888g6VRJsXBEIY8Tpnx+2
	DjvpaoLdGBgg5Rhsg715yENe048ax48pJH6QC8J2yhQnSTfFfSy4IcvcIlz1dxkg
	iq0p3UGxVsczUGsf0DAvpn6kMDVrA3/HvETUzUBX05zZ3qabBCnxCxrOw3GOs/n3
	3uVcHYFUhh4xTM7OUXfIQXIUA7vqLxRPw1w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794871169; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:RLiJdiaCujRomPLgpdFtrfM+1RKHQ+UIeDMNs3Nf3lx81fM
	Q6Xv1J+yeleNfo7JQ5paZAiFvjmX4rBL1uTY9EGUvXUTOdQYcqeZRc5AYvGY1F6b
	EzquQ67k/kqbiEdRbyR6BjA+mN3ZuaEpa3KQNkN3qagyNZva9L6Ua6u1dvo7v7EO
	4ErjJG6Wkliepb5yFaAWHUVGi7pa2SPnz0nmf4t/pUsvVccXG7N4Wtu9lDzPBvnD
	FF3WcJ1dHX8sA/nwPLCdujn61scDkVZVz9LtLw1RJe/tkDHY8niw740uUW070Xki
	ZMwtpvnG6Lrprlso+iI/b3CtjQ5893IXx2qoVLQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:b6FQydsq1+h+6suAH3fF7YJvYhrnYOotW+K/d2iLT4Y=:dNM9bpy/xvzf6D0nJQQ3e9zQR3sDaeTN/Si/+ssW2AY=;
X-ME-Sender: <xms:gI_7ahUsCJVDX-fsGLhbiO9qxP2Q3y4RiLs1gCuwixUsbitHARsC8g>
    <xme:gI_7aiQRITQt5sAnLDmyPwpYVvwamWLQnbH0Yo9BWEpBzkYBcv7zaVpnz8vf7ilQ3
    a_qrEh-sxIYaLP-joyMVqRwR9or_tgaPDZC2hTIGf3UCqnZPRIV6YPb>
X-ME-Received: <xmr:gI_7arl4XzSU3fLMCSkieAhgWg5NVnG-ellUhvHLYaIwq0TPSJUH8YOzKn3clV6k>
X-ME-Proxy-Cause: dmFkZTEJ3CIJfA1hP7YHW35UPoQyEUprrj/QGnRwhNqllrS4EIgFkJcv7DS3V4CSaIZ4J1
    4nc9AyIyYqDOm8mF88XeG+0fDyP6ODfK+HjQHDnis5nSd4+7mNmd/+C4dzhq6s07qavSgI
    wNBEer5Y70x3cS9X9BhlC2axmBUaVhlX3RhBUJ4yZAhTBUzVXgyE07l3OWq54fahLgeLN2
    Pn2yDmw0BX1jziKOn0safIqruKK4tJxHRkq+kJ+8nutghqDX5KmT3NnAKXn5KhQgY9eYFI
    QzQMOK4U8l0erXoUOHIkrPx52zuF8K+WJJlFmxHpehRl7muVbngMk1QTvOF6kefQdasyVZ
    XKhMqf1YPePOgspFkyDAQO011IoSVzS/NNoB8tYZBl4xm3/z90oBrP5LUIcwhouq424Xeq
    O557Yd2qYKEZZAV21muf09/tozKIPPMD2t01dt+gv3FZUIqhuRjdMLbTUMt0v5q9I0NJje
    i9OnmK3ofFO6HCD5LBDvrCUxvtY+0Xh1zKp2cmx5Mx4WZ6e5HyeUmiWi5rI+6PLxlQUzz+
    iyim3t8V54487D+i4rD+Zc8aiku30AJxHYB2MCViq6CIwL7CFu8EuhELBnTH7hS5Mo0L9P
    DxV6Scd/JT41bBPG8BI1BQJI/J9pDzmL1P1pLH+gxnG2uy5rx0DNaCi0HPkA
X-ME-Proxy: <xmx:gI_7ao789R3IC5wF7E5sD6FwCo9FtBu66S13S_p7TOc-kIjk2iNTUw>
    <xmx:gI_7ahh4Zi34FpOocrz9Jbc7S_58EhoZnwkxkwfYnq_4C5qrszHPWA>
    <xmx:gI_7alGtD3n0ML3MvicXF94fO7TqJZODT5259-u4AQrPjW3c5n-mQg>
    <xmx:gI_7anRPnDkaNQcbDimVtcGLuFnxQ3reKRKICrKCcCfs0vs8DZdKZA>
    <xmx:gY_7asKaWJNPnchssTN5L6ZAzn88ta7ivbQin52lzo6TRW8JiUR-398x>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 18:19:27 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: store the security descriptor from a copy
Date: Mon, 16 Nov 2026 17:19:23 -0600
Message-ID: <20261116231923.2587994-1-icb@fastmail.org>
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

Storing a security descriptor changes the buffer passed by the caller.
ksmbd_vfs_set_sd_xattr() adjusts three offsets for the on-disk format in
place. For SET_INFO, and for CREATE with a security descriptor context,
this modifies the client's request buffer. Current callers do not reuse
the descriptor after storing it, but a later reader would find incorrect
offsets.

Adjust the offsets in a private copy and make the input argument const.
Reject a length shorter than the descriptor header before copying it.
This keeps the caller's data intact and preserves the stored format.

Add a KUnit test that checks the input stays unchanged after a
successful store and after a short length is rejected.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---

This is a cleanup. Current callers do not reuse the descriptor after
storing it, so the patch fixes no bug today.

Tested on ksmbd-for-next 2746a02296a7 with KASAN. Stored descriptors and
security query results match the base for SET_INFO, CREATE, inheritance
and default descriptors. KUnit passes with GCC and clang, and the new
test detects the input changes made by the old code. smbtorture results
match the base.

This patch was developed with LLM assistance.

 fs/smb/server/tests/smbacl_kunit.c | 36 ++++++++++++++++++++++++++++++
 fs/smb/server/vfs.c                | 26 ++++++++++++++-------
 fs/smb/server/vfs.h                |  2 +-
 3 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 39c9f8bb1ea7..37d21c10a144 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -280,10 +280,46 @@ ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
 	fput(file);
 }
 
+/*
+ * Storing a descriptor must leave the caller's buffer unchanged.
+ * Check both a successful store and rejection of a short length.
+ */
+static void ksmbd_vfs_set_sd_xattr_keeps_caller_sd_test(struct kunit *test)
+{
+	struct file *file;
+	struct smb_ntsd *pntsd, *orig;
+	int ntsd_size, rc;
+
+	pntsd = build_boundary_ntsd(test, &test_owner_sid, FILE_READ_DATA,
+				    FILE_WRITE_DATA, &ntsd_size);
+	KUNIT_ASSERT_NOT_NULL(test, pntsd);
+	orig = kunit_kmalloc(test, ntsd_size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, orig);
+	memcpy(orig, pntsd, ntsd_size);
+
+	file = shmem_file_setup("ksmbd-kunit-sd-copy", 0,
+				mk_vma_flags(VMA_NORESERVE_BIT));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
+
+	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
+				    &file->f_path, pntsd, ntsd_size);
+	KUNIT_EXPECT_EQ(test, 0, rc);
+	KUNIT_EXPECT_MEMEQ(test, pntsd, orig, ntsd_size);
+
+	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
+				    &file->f_path, pntsd,
+				    sizeof(struct smb_ntsd) - 1);
+	KUNIT_EXPECT_EQ(test, -EINVAL, rc);
+	KUNIT_EXPECT_MEMEQ(test, pntsd, orig, ntsd_size);
+
+	fput(file);
+}
+
 static struct kunit_case ksmbd_smbacl_test_cases[] = {
 	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
 	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),
 	KUNIT_CASE(ksmbd_smb_check_perm_dacl_maximal_boundary_test),
+	KUNIT_CASE(ksmbd_vfs_set_sd_xattr_keeps_caller_sd_test),
 	{}
 };
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 111321b131bb..1114f2503ea7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1699,7 +1699,7 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idm
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len)
+			   const struct smb_ntsd *pntsd, int len)
 {
 	int rc;
 	struct ndr sd_ndr = {0}, acl_ndr = {0};
@@ -1707,6 +1707,15 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	struct xattr_smb_acl *smb_acl, *def_smb_acl = NULL;
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
+	struct smb_ntsd *sd;
+
+	if (len < (int)sizeof(struct smb_ntsd))
+		return -EINVAL;
+
+	/* Shift the offsets in a copy and leave the caller's SD as it is */
+	sd = kmemdup(pntsd, len, KSMBD_DEFAULT_GFP);
+	if (!sd)
+		return -ENOMEM;
 
 	acl.version = 4;
 	acl.hash_type = XATTR_SD_HASH_TYPE_SHA256;
@@ -1715,14 +1724,14 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	memcpy(acl.desc, "posix_acl", 9);
 	acl.desc_len = 10;
 
-	pntsd->osidoffset =
-		cpu_to_le32(le32_to_cpu(pntsd->osidoffset) + NDR_NTSD_OFFSETOF);
-	pntsd->gsidoffset =
-		cpu_to_le32(le32_to_cpu(pntsd->gsidoffset) + NDR_NTSD_OFFSETOF);
-	pntsd->dacloffset =
-		cpu_to_le32(le32_to_cpu(pntsd->dacloffset) + NDR_NTSD_OFFSETOF);
+	sd->osidoffset =
+		cpu_to_le32(le32_to_cpu(sd->osidoffset) + NDR_NTSD_OFFSETOF);
+	sd->gsidoffset =
+		cpu_to_le32(le32_to_cpu(sd->gsidoffset) + NDR_NTSD_OFFSETOF);
+	sd->dacloffset =
+		cpu_to_le32(le32_to_cpu(sd->dacloffset) + NDR_NTSD_OFFSETOF);
 
-	acl.sd_buf = (char *)pntsd;
+	acl.sd_buf = sd;
 	acl.sd_size = len;
 
 	sha256(acl.sd_buf, acl.sd_size, acl.hash);
@@ -1765,6 +1774,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
+	kfree(sd);
 	return rc;
 }
 EXPORT_SYMBOL_IF_KUNIT(ksmbd_vfs_set_sd_xattr);
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 8568184ff05b..fb184546d26b 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -164,7 +164,7 @@ int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len);
+			   const struct smb_ntsd *pntsd, int len);
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   struct dentry *dentry,
-- 
2.47.3

