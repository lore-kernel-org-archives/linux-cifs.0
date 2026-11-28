Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795879106;
	b=yxcm7+RLQhNR4ZQ0O0bais+Kqf62kTDEw7KzN+hj/yfqI74da+o0wmStuvWf1PYbLHF9
	 z/sREWEJ5H+th1mfmPjAyt475NZqTyi8m1Q93JjDJYKhHJD5neUhVUw/3mECL9ZzXCaOb
	 VFZG6QcqJDmVU+2dt8dA5gpE4EjCQJu0vXCkRC+I1bQbpvh1hINRN/zdd323DwgmexYn5
	 MYbptS8PjdQRE/kfzsmcGqtgKjU8IBj7XWEgL4783vYn70NIfL+IesjFU6671FKfZw5Sw
	 Zws6I6gxCtO0G0lZC0JgtX4dNyb3hILwxptTcYqznA090+WI2QUMvosLdZlBb4tYGrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795879106;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4fBsMa0cXMKTPhRtV0qWiGuZf6SgJhqoJnizvYik+ps=;
	b=JCMSrI6niIanDIhPVMPLdbRbQXjFy2raN46Rsv1tbLwV+i5xZs1Nj1XFM4YK82FLQUTO
	 +G4XPCt3NTNNYMkMN2WH4BKhSWPabZTsYTG/5+VcbC40K+aSqoigGFR3EQ2b2R6vzUlUT
	 xI+CGSzrXdmD6Ctp0uBvAluClQ6k9IA4w1NoduHFT5WJK5ZxNXWPtgOpEnQsH4VdP+kHO
	 xb1lvgCwEMQMrlQIJEMF23DDfxlG+sYYnNTkO+Yi0lZSYtGFa5Hdiu7PP6/obhYrg10v1
	 EPyrM1poOnX2weUFO33mI+sMF5rgpUoaF+GTGDw1kNPOwObKe7Avfry88muH9C/ejOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=VVHLrB1a;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=i6sVtG68;
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F596606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 15:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F596606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=VVHLrB1a;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=i6sVtG68
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 407C314002F8
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 10:18:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 28 Nov 2026 10:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795879104; x=1795965504; bh=4fBsMa0cXMKTPhRtV0qWi
	GuZf6SgJhqoJnizvYik+ps=; b=VVHLrB1a1uJs5wZ66pYGj6OGwD5dAVjBwdLf6
	L+zn+/AfbXbYxeJGeJiuB85T6DRuayAs+in3ggYbaTfUnEAI6cq1M0W5SADVXwXD
	yZ/jaSU2JG34FzDHusr63FLNnbxJDFTXnu3ogkjHp6jHl0YFaJFsRT230c4bUOQz
	R9Mmelsa9WjiOI6SemA+YEjI21YAyRyL3mjMzimFj1bQCE3eCGYwA8qcy7Izr+VH
	fQ5p8pn/GPwfTX52ezWg7aDr/pn1/gejgrP4r/MwjFX3lTl6VHV8cT5PCMTU6MYU
	fLD58k0MAT6n7xU+7Nmimb2z2DhNfvpkj/TjYYdXKncq5DGGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795879104; x=1795965504; bh=4fBsMa0cXMKTPhRtV0qWiGuZf6SgJhqoJni
	zvYik+ps=; b=i6sVtG68jn+siOYXeJCSGm0q87sDKMqLST7Ko/Rt5xBEb7bmhlp
	+bu+bClfN3HA3CZwe7AdjuNJuZk6nqwGuEFERdChMJHhKb/ErYw5e9gkYf5vwIEF
	6ouqm2aF0mrABk8ZvDB8nnXA5fkClFr/8mD1VKGXmq6K08QrP5ciiabV4XYi/qDm
	T11Rjw5PPVxM8pY7X1JRzviKWsaMAJvo2uIPbno2nOMkWExYDcQBAhhD16jqXuve
	QiJFT5vvoSWr5Z1HJzsQwKtQy8/GgyLf5qxyzV5VpXyfX+rcAFWlYWK9i/U+qO+J
	+3qYduNW8FDxGexd5o8+Lk+uEE65fEnIEMg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795879104; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:0iY19KNg1NFsMiCPsb5bJXiiRo42o8ZcR3dHM7gURVyObll
	oU8QV/dsU9upWPeV+Nt+KeeEeiUTxMz+ej7A5zVCtf9SYfO///6EhmotG3revWWX
	uDCIob2bEfPVhWjMAngVFtZ2ARdwAZKvWYVgKsrLz6qdnzmh/GUk9YBCxQU2aHlm
	S/G44qEeUI3nsuUvIwVfgVSWpabFLwkYhe4cylq/B335g+fLJJ1aaPl48DwzRwH+
	VFL8kwx+5gd9O4jl4TVwMXfEdeqYij6XBIKiD+/rQUpEZelJ1mqaEXs18YaI/VtV
	yfRUuB1hsR+FrekLxUrMam+Vn7SvaHb+iYtt9ng==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:5Y7gVK0pjKbNs1dJTVWQ2/A1Weu5G1JBFOERCEcLy58=:48gbnP9g/IoE6DCjV4UnP4dC1w8CGJZW0fHI/oL7S1Q=;
X-ME-Sender: <xms:v_AKaybK0-k39hL5z8VFFUTlsg2nQOfEw6fuPcZxhM7x87rVrF2zGA>
    <xme:v_AKa2GkgrRgKc3CAOsi0-GwWL3MT1g2m2f8aa-Xg_vrv1q9spX795EnTZb3UV6pP
    2N0MjO1Tf_-2jnCvtt4-dhWr-iV8_j6UFOkaUINfMHDDNfaPDNX2Ts>
X-ME-Received: <xmr:v_AKa7L3byqqPOZzK0aKUItGeB_v0iwWn3MzTz2mYDocyKslh5zy5WGc_s4N5-tZ>
X-ME-Proxy-Cause: dmFkZTGFIS0a3xrZ5VK4vGC/CE1BaC2gRhjFwoOuDU1ztpuh5IaZJ2J02DXsaufj9EZf7U
    QeLcNBtqw6e3lm2l1FIvBPcYwWD31+yYZCq/4j3apKoNhxZoqSkbmEYZjOwnKWLagDErnw
    hXeA6tDkjZ/RWa0e9kfBrsL+CB2kV68/x2sdHI80HmbY73HlBb0KBiIlo7RLlCRe/fOPgJ
    WlgIYEc5PzXYtNKHxTuqfGqmEmmzDZ83eeQCfCVL12rgT6cyNoJRxirxvmZpnV/FAD04PH
    bXB5CxlXFWXLHxFXnwqg9rIyICrDQ3GjcSzD9Roc2oXNAi+6kYPtHOGfPoUj2iM3ARX3CS
    ht/9ybzhyaQb7/M8YjYHkkUrTGnc13klhBoGNLMmkdpNLLdsmIKsyvBSuTg9SFyamZ5Kbz
    FlT3LBYdNBnimGtu/8SXdHsTUhVimdfLGdE1A6wsQDefbCkEp+ERGW1CS67k+91rOijjnj
    IWiDxsejGDPMin6KZf2yfCIAWhw9v//DebuiEwxXzI6MP3KZVhnfcFiamdlxG742Pne1GA
    aAmz1TtQD1rnkYMNWLA5Nml8/OTboXF3+VtfxUEzauczlb7ZfvHXPsumVg0m6OQSZS0ahk
    U1Op+OIPYI3Vr3CH8oXkr75Jk7nBT6//ltwpOxzsIZ3+JJOsQHb/wnDd9/TQ
X-ME-Proxy: <xmx:v_AKa5PCm7AX64MbE0l-UlCbowYiLjmqzGWeVKgKzJ2FzW13DNIAbw>
    <xmx:v_AKazlGgHC4mSOgAfEKc-GTc_H_cI1mBlAvnGNJsUOx_VLcg6_tHQ>
    <xmx:v_AKa14Xqt6rRVe0byn9_NY2F6mvXAQGSZ7ofHBeRnAOxn5JKorMyw>
    <xmx:v_AKa_0kn0GM458xLgphCRpzm15QXMaveB9oYsldQgEn1JReBh2Kkw>
    <xmx:wPAKa_83m7i3_wwJ8I6x5yWPfIWIaWH7cTajJU4i_FsDIiftRt2pFoYx>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 28 Nov 2026 10:18:22 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH v2] ksmbd: return the cause of a failed link
Date: Sat, 28 Nov 2026 09:18:18 -0600
Message-ID: <20261128151818.1784793-1-icb@fastmail.org>
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

smb2_create_link() turns every error of the link, and of the removal of
a target that the link replaces, into -EINVAL. The client gets
STATUS_INVALID_PARAMETER whatever the cause.

Add smb_errno_to_ntstatus(), a default mapping from errno values to NT
status codes. Return the errors of the link path as they are and map
them with it in smb2_set_info().

A directory as the source now returns -EISDIR. vfs_link() returns
-EPERM for a filesystem without hard links. Check for that case in
ksmbd_vfs_link() before the target lookup and return -EOPNOTSUPP.

The lookup of the link name returns -EXDEV for a name that leaves the
share. Turn it into -EACCES so that it is still reported as access
denied and not as a different device.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Changes in v2:
- v2 maps the errors with a new default mapping in smb_common.c instead
of the existing mapping in smb2_set_info(). Later patches will convert
the other handlers to this mapping, one handler per patch.
- A filesystem without hard links now gives STATUS_NOT_SUPPORTED.
- A source at the link limit gives STATUS_TOO_MANY_LINKS.
- A directory source fails before the link name is parsed.
ksmbd_vfs_link() checks for hard link support before its own lookup
of the target.

Tested on ksmbd-for-next 4543a3349127 with KASAN. The patch builds with
W=1 and sparse and adds no smatch warning. A script tried one link for
each cause of failure. A link into a directory without write access and
a link of an immutable file now return STATUS_ACCESS_DENIED. A link on
vfat and a link from vfat into ext4 return STATUS_NOT_SUPPORTED. A link
from ext4 into vfat returns STATUS_NOT_SAME_DEVICE. A source with 65000
links on ext4 returns STATUS_TOO_MANY_LINKS. A directory as the source
returns STATUS_FILE_IS_A_DIRECTORY. Replacing a directory that is not
empty returns STATUS_DIRECTORY_NOT_EMPTY. Before this patch, all of
these returned STATUS_INVALID_PARAMETER. A name that leaves the share
still returns STATUS_ACCESS_DENIED. A normal link and a link that
replaces a file still succeed. smbtorture gives the same results as on
the base.

v1: https://lore.kernel.org/linux-cifs/20261128013952.1691873-1-icb@fastmail.org/

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c    | 21 ++++++++++++--------
 fs/smb/server/smb_common.c | 40 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h |  1 +
 fs/smb/server/vfs.c        |  9 +++++++++
 4 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 38326db8da40..ab75104e5aa6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8924,6 +8924,9 @@ static int smb2_create_link(struct ksmbd_work *work,
 			le32_to_cpu(file_info->FileNameLength))
 		return -EINVAL;
 
+	if (S_ISDIR(file_inode(filp)->i_mode))
+		return -EISDIR;
+
 	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
 	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
 	if (!pathname)
@@ -8932,7 +8935,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	link_name = smb2_get_name(file_info->FileName,
 				  le32_to_cpu(file_info->FileNameLength),
 				  local_nls);
-	if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {
+	if (IS_ERR(link_name)) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -8948,16 +8951,17 @@ static int smb2_create_link(struct ksmbd_work *work,
 	rc = ksmbd_vfs_kern_path_start_removing(work, link_name, LOOKUP_NO_SYMLINKS,
 						&path, 0);
 	if (rc) {
+		/* -EXDEV here means the name leaves the share */
+		if (rc == -EXDEV)
+			rc = -EACCES;
 		if (rc != -ENOENT)
 			goto out;
 	} else {
 		if (file_info->ReplaceIfExists) {
 			rc = ksmbd_vfs_remove_file(work, &path);
-			if (rc) {
-				rc = -EINVAL;
+			if (rc)
 				ksmbd_debug(SMB, "cannot delete %s\n",
 					    link_name);
-			}
 		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
@@ -8967,8 +8971,6 @@ static int smb2_create_link(struct ksmbd_work *work,
 			goto out;
 	}
 	rc = ksmbd_vfs_link(work, target_name, link_name);
-	if (rc)
-		rc = -EINVAL;
 out:
 
 	if (!IS_ERR(link_name))
@@ -9442,7 +9444,7 @@ int smb2_set_info(struct ksmbd_work *work)
 	struct smb2_set_info_rsp *rsp;
 	struct ksmbd_file *fp = NULL;
 	int rc = 0;
-	bool chseq_err = false;
+	bool chseq_err = false, map_err = false;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	ksmbd_debug(SMB, "Received smb2 set info request\n");
@@ -9494,6 +9496,7 @@ int smb2_set_info(struct ksmbd_work *work)
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
 		rc = smb2_set_info_file(work, fp, req, work->tcon->share_conf);
+		map_err = req->FileInfoClass == FILE_LINK_INFORMATION;
 		break;
 	case SMB2_O_INFO_SECURITY:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
@@ -9519,7 +9522,9 @@ int smb2_set_info(struct ksmbd_work *work)
 	return 0;
 
 err_out:
-	if (rc == -EACCES || rc == -EPERM || rc == -EXDEV) {
+	if (map_err && rc != -EMSGSIZE) {
+		rsp->hdr.Status = smb_errno_to_ntstatus(rc);
+	} else if (rc == -EACCES || rc == -EPERM || rc == -EXDEV) {
 		if (fp && req->InfoType == SMB2_O_INFO_FILE &&
 		    req->FileInfoClass == FILE_DISPOSITION_INFORMATION &&
 		    fp->f_ci->m_fattr & FILE_ATTRIBUTE_READONLY_LE)
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 6595d40b06bc..4996840bc9d1 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -909,3 +909,43 @@ __le32 smb_map_generic_desired_access(__le32 daccess)
 
 	return daccess;
 }
+
+/* Map a negative errno to a default NT status. */
+__le32 smb_errno_to_ntstatus(int err)
+{
+	switch (err) {
+	case -EACCES:
+	case -EPERM:
+		return STATUS_ACCESS_DENIED;
+	case -ENOENT:
+		return STATUS_OBJECT_NAME_NOT_FOUND;
+	case -ENOTDIR:
+		return STATUS_OBJECT_PATH_NOT_FOUND;
+	case -EEXIST:
+		return STATUS_OBJECT_NAME_COLLISION;
+	case -EISDIR:
+		return STATUS_FILE_IS_A_DIRECTORY;
+	case -ENOTEMPTY:
+		return STATUS_DIRECTORY_NOT_EMPTY;
+	case -ENAMETOOLONG:
+		return STATUS_OBJECT_NAME_INVALID;
+	case -EXDEV:
+		return STATUS_NOT_SAME_DEVICE;
+	case -EMLINK:
+		return STATUS_TOO_MANY_LINKS;
+	case -ENOSPC:
+		return STATUS_DISK_FULL;
+	case -EDQUOT:
+		return STATUS_DISK_QUOTA_EXCEEDED;
+	case -EROFS:
+		return STATUS_MEDIA_WRITE_PROTECTED;
+	case -EOPNOTSUPP:
+		return STATUS_NOT_SUPPORTED;
+	case -ENOMEM:
+		return STATUS_INSUFFICIENT_RESOURCES;
+	case -EINVAL:
+		return STATUS_INVALID_PARAMETER;
+	default:
+		return STATUS_UNEXPECTED_IO_ERROR;
+	}
+}
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d3d19f1a23ea..1d93bd00fcd1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -300,6 +300,7 @@ unsigned int ksmbd_server_side_copy_max_chunk_size(void);
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
+__le32 smb_errno_to_ntstatus(int err);
 
 /*
  * Get the body of the smb message excluding the 4 byte rfc1002 headers
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 5b0722fe7788..2a48b875c327 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -705,6 +705,15 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 		goto out1;
 	}
 
+	/*
+	 * Fail first if the source filesystem has no hard links.
+	 * vfs_link() would only see this on the target directory, and it
+	 * returns -EPERM for it.
+	 */
+	err = -EOPNOTSUPP;
+	if (!d_inode(oldpath.dentry->d_sb->s_root)->i_op->link)
+		goto out2;
+
 	dentry = ksmbd_vfs_kern_path_create(work, newname,
 					    LOOKUP_NO_SYMLINKS | LOOKUP_REVAL,
 					    &newpath);

base-commit: 4543a3349127baa8395397b7f4aa930d9a4f8dd5
-- 
2.47.3

