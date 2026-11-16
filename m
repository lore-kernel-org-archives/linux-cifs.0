Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864370;
	b=WXvfpkqH92gkW6kUTqz15fFQOqfyZxYfskXrl4AOW+tpcyZyN5ZUFwxbAVE3e279rGOw
	 Eil2k2t66v67AWaOprVE9EXureBMVjYV+pvRrledbscxj7/I0UoxTnjh0VOiVucQD8ndZ
	 1k/QcKOu8nWp6QCprtbEqlwBbfKbRUv1O4s5AveJXDpvbLbpVsgzuPn9vv3ND1ev/gWil
	 SvhH0mot93RoiFTOKuizJshhhCpTSgQg7BrYwtjWCwj+51JxPftU8L37eiK3OpTCEQTon
	 S0CUGIZMOVMTWJrLMYAv1LPkVNPavMM8e+ZEYIjsqQBv+WEL+jaLbdOEctGVx1MDyzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864370;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L0RDOVn9ev2i25ubIASNHRtoVTqDu76QaCLhzgV90Rk=;
	b=Fcr9LDvM41BZg1trMFWMGWoCJYHItWN6cBPKNYbejz+AjzujaYVzUT5bFxOjpGshZGd6
	 lCxxl/zKrP5XzlxQiRH3viL+RZGANd7P7s5GnwnmOHc3n/5UNKQfepZf+JMupV7EYw0wH
	 g88zRILE8tzbDZcAqt2SgDxrSVKHC0IBXO1Jk5RLRHP1GxAZdGmFIK/IMur3oJzxatgQB
	 Jvj14JLjV6QdYIofUq5LUZA4rY+6J1MkBshBWdDGENKPO9ArWa+Ld+M9NBCjZQc11PTZ2
	 uGbTeHbeCBtXptFg/IVPl15cGnv/dCAljon2ljaEgtZf0uw8XYYL+998VY3xC8UAdHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=m3ibmhlH;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QbIiATLi;
	arc=none smtp.remote-ip=103.168.172.137
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1054606A323
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 21:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1054606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=m3ibmhlH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QbIiATLi
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id EF3461381B03
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 16:26:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 16 Nov 2026 16:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794864367; x=1794871567; bh=L0RDOVn9ev2i25ubIASNH
	RtoVTqDu76QaCLhzgV90Rk=; b=m3ibmhlHMoIlJQKNnMZsMTpt2tK1Zz9fREfG9
	p9OgYzIdLnXY45AhtF4QcyXjnWuA+40m1afe9UOMFy7qaDp1CQBxJMmwMMWRa27k
	HTABDlfj91LKJz49dayGbvjAfqF6QUgeNX+2/7zGwLTOsdF0frtGVGC5ppVNXDpc
	0xOqbHvUJRmsN6a7IxXzONFMAfJGGIFivzPX3Diw7BtQk66cfz2YRby3L8UqoEVf
	F245SDT/Ii36MLJLFt5cT3yguwixJPOpGkrsIRZNwte7zM3DfCTujS420cL4la+/
	03c3GAFdHZzxadpexuKdpDA3GyZR3gFnncR3hmnFygIy8WzdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794864367; x=1794871567; bh=L0RDOVn9ev2i25ubIASNHRtoVTqDu76QaCL
	hzgV90Rk=; b=QbIiATLi6SjpXfac91b1bk44N1rUxEvI7vtINq2cI8zPbjw2+fs
	46fVmZc0tgMR1ghby7/hPWSxef0gKTb5a35vglmpC2fM1ylxVCbpn3UGlgLpud1b
	H0KxK5yeKwaJVTWE0Ai4neIYDCQD0JKJk8sZMbn1zwIhbo3qMVmZ6Rbu+K/2sXjS
	V4XZDP6JllksFE1IgdTCes3Nljy7joFlFC04JuNr59KnPvQq4428Hvofy7NAKHWv
	44WtHxuW3XayObMGDJpjLQzN6XHmO7SkgK9VVruJpUKPItQmCQ3lqOyllanLdL1+
	Bvngr/BuuW7tX+UnHl2C2PuLV+OADycAS2g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794864367; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:P8rTWm4EgzUD4gWQEd075Q1V5cBS6ewSktdtp6+vgZDXTNB
	/PhBNC0d0BjoqBY3CudA2XansUoCq7+m2RqSVIiml7p5Taj0XdVTa7bRfoZZAKAB
	+GGvQ8LqWq6OKPpb4YBlCdZXaWoPbmAybGjTZ14SPi0Ll2Xtz9Place/ZtLN2YjG
	UvmreRX72gaROisrlUD7mgXn0oyp1J2Uw3EDKYQrM13dPeHMya7BbqHGtaDBKhnJ
	UPX8H0d3rgTZmCJkjfXNKvc+wxnznylNAQAcG/i0XvB1XKLLmNkCQPeQgTWPOX9y
	ampKB7aO4KNxqWeODl7wCmX7JzzAHA8LyB1HEoA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:/WRZXQIX3NLr3c5F7XHk9pDzN4CKOhzqSqmpEn6Qahs=:jziW9HwR6rQNpuQ0wEqIuVKcRrQJbMkbg3qnvjxkK3w=;
X-ME-Sender: <xms:73T7amlIlByfuWh08GNradpR9476i7yofHdRvhUuCeJgCRI7vE31aA>
    <xme:73T7auiYrMFMVpjfJeTB27Y0XsMlovspQb-hgrSYxFi9AX197byrmT1KmaJKjuC7H
    l7wiFP5QTF8Lcbh5Zo25mu8x8ZOEM76sS52CtSolHVIvKMm0dqfBnjt>
X-ME-Received: <xmr:73T7ai1fcvUzhhyNEfGYVuqwy1H7OxFwDanU7pYxWiWZqjI5NREqqUD-j6nSoKZSkJBwzw>
X-ME-Proxy-Cause: dmFkZTE7FLW3HHIAbdmepA7uZE9NnbP27pvPdzNYUvkMnUD65fiPBErq5hYxlxZjn6QO9q
    oPaaWavQIMOtf94mKyVoP6o1rODTGUhAMslWl1TmKvTYXnbS0yb/A1NyaM4jvnfP9zNTxD
    rOJMpZgcKPKLyrxY92qlz1/bvnb0hbO6Tn4O0ps0eSjI09ASHc7d4yvZF7bXPTOT3IHs/g
    52XavaPuMDXwiqwXJnbPvNqrA8D/yKHfWkBH0ESRqUzGVWkyo0TAnqm+xgI+6lBbhKcpzk
    VQ4E05nj2dsrb+8Jfh3vv005f8+3dGeY1gcRpNhWICfwAYbAwT/aTr50mRM23j2OJSSeQ3
    J1Yg1V8qrsS7cic2OFLhWTMd+zFNrcFfpbL0LXRaGbdrJ5hlj1VosUnQr0iXlYvhO1mJFH
    iHDMygP55bPTjVN8UD8wRD05rRRuatxUruFfQIcudc7Yunzw/a5Y0bAzFqcdRFHsNq1uOz
    XQVpMMhKv98nbIR8H/R6swILYi2UDQ4ZYOoITrlEk2J3d8w2ENnolX9aj4m42C+BDKqqiQ
    WMfrX7sIFoMpcGZc0PtIPIXjWp4DxL+rZ27dgSeKthEyrh7ry+RIuZDQP1eZZdXo5Gmzch
    OtBAV/58lKPK/yOcha5xEpjzHZoKi57BjWbnQE968dNNQFFyRaT7hvJUl4vg
X-ME-Proxy: <xmx:73T7avJT_ljSINWVOw7ibFfVy-SvoO8EsJHw-5MsRCEmUEZQzzLTag>
    <xmx:73T7aqyFpxbqBJA2R6NerQ07zs-tOaM5iQpGo9u6O91EYcUk2Zt-9g>
    <xmx:73T7alVtZRgrS6l34RQU7X-IUgkqAgrFF2SFa_jAC5wcipunRuFHgA>
    <xmx:73T7aiipUpfrsxAiuVf4xniLv8H4dxw2EsQ54nNuSPmqKXXTaIZUmQ>
    <xmx:73T7auOur-_BGdWDahfA5WKxAZ9O5McyqwbvLiOnD3HfV3GGZJ5tOGwD>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 16:26:06 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: drop the get_write argument that every caller sets
Date: Mon, 16 Nov 2026 15:25:49 -0600
Message-ID: <20261116212549.2574919-1-icb@fastmail.org>
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

Commit 020ad4a0d0ba ("ksmbd: protect SET_INFO metadata updates against
filesystem freezing") and commit 3c463ed5bb47 ("ksmbd: protect CREATE
metadata updates against filesystem freezing") made every server caller
of set_info_sec() and ksmbd_vfs_set_sd_xattr() pass get_write as true.
Only the two KUnit tests pass false, and they store on a shmem file,
where taking write access works as well.

Remove the argument from both functions. set_info_sec() now always takes
write access around the POSIX ACL and attribute update, and
ksmbd_vfs_set_sd_xattr() always asks ksmbd_vfs_setxattr() to take it.
Nothing changes for clients.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---

The argument no longer selects anything a server caller needs. It only
leaves a way to store a security descriptor without freeze protection,
which is the gap the two commits above closed. Without the argument,
every store through these two functions is protected. set_info_sec()
also drops one of four bool arguments in a row, so its call sites are
easier to read. The lower helpers such as ksmbd_vfs_setxattr() keep
their get_write argument, because some of their callers pass false.

Tested on ksmbd-for-next c710c654b8a3 with KASAN. The stored security
descriptors and security queries are the same as without the patch for
SET_INFO, the CREATE security descriptor context, inheritance and the
default descriptor. The ksmbd KUnit tests pass with GCC and clang.
smbtorture results match the base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c            |  8 +++-----
 fs/smb/server/smbacl.c             | 18 +++++++-----------
 fs/smb/server/smbacl.h             |  2 +-
 fs/smb/server/tests/smbacl_kunit.c |  6 ++----
 fs/smb/server/vfs.c                |  5 ++---
 fs/smb/server/vfs.h                |  3 +--
 6 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b74dafe6a307..29750970f8da 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3954,8 +3954,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	/* parse_sec_desc() refuses a length shorter than the SD header */
 	pntsd = smb2_context_data(context);
 	return set_info_sec(work->conn, work->tcon, path, pntsd,
-			    le32_to_cpu(context->DataLength), true, true,
-			    true, true);
+			    le32_to_cpu(context->DataLength), true, true, true);
 }
 
 static int ksmbd_acls_fattr(struct smb_fattr *fattr,
@@ -5276,8 +5275,7 @@ int smb2_open(struct ksmbd_work *work)
 								    idmap,
 								    &path,
 								    pntsd,
-								    pntsd_size,
-								    true);
+								    pntsd_size);
 					kvfree(pntsd);
 					if (rc)
 						pr_err("failed to store ntacl in xattr : %d\n",
@@ -9419,7 +9417,7 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 		return -EACCES;
 
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
-			buf_len, false, true,
+			buf_len, false,
 			fp->conn->dialect == SMB311_PROT_ID && fp->is_posix_ctxt,
 			addition_info & DACL_SECINFO);
 }
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 9aac87ff3b4a..a87c22fa9a6e 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1443,7 +1443,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			pntsd_size += sizeof(struct smb_acl) + nt_size;
 		}
 
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size, true);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
 		kfree(pntsd);
 	}
 
@@ -1905,7 +1905,7 @@ static unsigned int smb_parent_derived_rights(struct ksmbd_conn *conn,
 
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write, bool posix_open,
+		 bool type_check, bool posix_open,
 		 bool dacl_requested)
 {
 	int rc;
@@ -1948,11 +1948,9 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 				   (fattr.cf_mode & 0777);
 
 	ksmbd_vfs_remove_acl_xattrs(idmap, path);
-	if (get_write) {
-		rc = mnt_want_write(path->mnt);
-		if (rc)
-			goto out;
-	}
+	rc = mnt_want_write(path->mnt);
+	if (rc)
+		goto out;
 
 	/* Update posix acls */
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
@@ -1975,8 +1973,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	inode_lock(inode);
 	rc = notify_change(idmap, path->dentry, &newattrs, NULL);
 	inode_unlock(inode);
-	if (get_write)
-		mnt_drop_write(path->mnt);
+	mnt_drop_write(path->mnt);
 	if (rc)
 		goto out;
 
@@ -1987,8 +1984,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		/* Update WinACL in xattr */
 		ksmbd_vfs_remove_sd_xattrs(idmap, path);
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len,
-				get_write);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
 	}
 
 out:
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 6bb64fef02cd..b51a8c6c1d4e 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -106,7 +106,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			bool authenticated, bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write, bool posix_open,
+		 bool type_check, bool posix_open,
 		 bool dacl_requested);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index bf28439a7696..39c9f8bb1ea7 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -222,8 +222,7 @@ static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
 
 	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
-				    &file->f_path, pntsd, ntsd_size,
-				    false);
+				    &file->f_path, pntsd, ntsd_size);
 	KUNIT_EXPECT_EQ(test, 0, rc);
 	if (rc)
 		goto out;
@@ -264,8 +263,7 @@ ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
 
 	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
-				    &file->f_path, pntsd, ntsd_size,
-				    false);
+				    &file->f_path, pntsd, ntsd_size);
 	KUNIT_EXPECT_EQ(test, 0, rc);
 	if (rc)
 		goto out;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7c3edbe6cb77..8cb91315ac66 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1685,8 +1685,7 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idm
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len,
-			   bool get_write)
+			   struct smb_ntsd *pntsd, int len)
 {
 	int rc;
 	struct ndr sd_ndr = {0}, acl_ndr = {0};
@@ -1743,7 +1742,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 
 	rc = ksmbd_vfs_setxattr(idmap, path,
 				XATTR_NAME_SD, sd_ndr.data,
-				sd_ndr.offset, 0, get_write);
+				sd_ndr.offset, 0, true);
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 21b0d29a3db0..8568184ff05b 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -164,8 +164,7 @@ int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len,
-			   bool get_write);
+			   struct smb_ntsd *pntsd, int len);
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
 			   struct dentry *dentry,
-- 
2.47.3

