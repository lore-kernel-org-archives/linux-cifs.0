Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282744;
	b=V26xgBpSFZokh+mgBaqVeO4V1EpxWOkpmtx6X84CKecYFg+Lktr8VTjjxdfMK/iLPF9Q
	 Qsxsk0LRu8ADjEdfutPuYay0OqfGCWLTMF7nGLVrcf+qdxqXZmivYJHpCQi/2EGTARHjr
	 NCDJT3s5y/C7mogt7SVAH2tly0WdUaBRWqDp6YUGOHL+GV8XsM+rwDKDFw8xvNogTPOU4
	 7r1Ww734f74D8jTg4/GUqOUUilUj3AAlWUEhOejSI/CE2hjj+J9lzi3qzMki6IbMsmh4K
	 V+e606Xy2pHM4nz+TAbSr2pAcjBvt7kQscd4keHChvxf+K3i3zGa2ypaXuyMPiP2J1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282744;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4jTN78THfSvL+vxWNV3+1CUe7NElaOIsDD8FJKmsYWw=;
	b=Lo0l0P9bxI77C705UjrTTfPWg8Jd5SB34xfTfLj80fKcCa1aNGe3eFl6wlxcD0oRUJ15
	 7Gx1wUq5D72oMItNVjYN8HZLbwLP3ZTw2jAV2zwtXfeKTWseh7bti2WDF8hyWZAnGOTRx
	 UnAUZt6AoYER6VG3oJ/kYZAHV1M7VhACEd/uIGvXdAI5sttD5ezra8uwMiqIDqdngvGAR
	 rlXS3mIGxoRinCGwoAHF7p3VUlBt70Dq/nK4efx9mjkfCZGuKhl2JLSe2q5vOIbUJFcsk
	 zzAxQX+VQMGX6shMgKFeBx/520UI3SeZHV2FN1gL+oEn2bivG4vUn7umq/7zipF9Ggw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=BaRRAPE8;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=inISdAR2;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C00E606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 14:05:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C00E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=BaRRAPE8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=inISdAR2
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7DA33140013F
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 29 Oct 2026 10:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793282742; x=1793369142; bh=4jTN78THfSvL+vxWNV3+1
	CUe7NElaOIsDD8FJKmsYWw=; b=BaRRAPE8Ye3jVrP/fiwb5eeWg2mgYsmm0BpfA
	s8hA3HRs4Mm/2deyaeCET2HD7XDHdPMuEzSDdnKgc/BvUTEOkNkaQ9w5qGzFPimd
	simB6ZCYmWfE6BDN7yeMB/G6sPS0HqGKUbgKUUXHKJn+oTWXfsOi+gdYRk9zdqrK
	U2ceJpVjAD1orjGqhkRnPxBxpcsRUjGsh33Bujh9FDlZcjhzEneB02nUi0erg9Ds
	GqPsDc+a4bOX9DTB1GokNBHNM9/eFy8rpitZ3rZBeg+Qeg/fEkiqGs3WpuPwa56r
	vVM8vLJvDKS1DeApbx3iEcAKrksvb0s1FkdCtU2Lrxl63Ei4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793282742; x=1793369142; bh=4jTN78THfSvL+vxWNV3+1CUe7NElaOIsDD8
	FJKmsYWw=; b=inISdAR2OX/+96bZ9AW75ILih1WmpXFBqt0q7GNlha1KvpLmDgV
	YyQmSTqOtcJWD5O8EfvUlGwIJSoPWBciB0tSJI8JvjWOv6nwe/4/nUxH9qQgUCSW
	k5E4RMG2fwxOhQ8GlzHD5OU6ncj+E7SJuJKSqnIgUvsQePYixlbSeasPv4g35yYO
	K5yVGFMZH1toL0OKHTi3FZnkAjitdFJlZxLMw3JXzSJvZpOyfvf1bwt4I6JNRFP7
	7kK+VQzSKmKV9/JZo81rchUeEVHx3gF9SjaB+CD/yu0g1Pg5wdCBkz0/neyyk4Cj
	+6fk5/P6xI5G+5G+2a48PnwsCK0Meh+jF7w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793282742; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:SqONjN0fdGz1SQAoFtC/vxrGCg3z0t7TCsCV9aRm4QFuNCu
	F4jw6u7MWUMv0hfPceqwIleOC2FBgM11OIVw3M0PX1UwcGNW6tbKYJMWbrkRuGt2
	GRjw6F7CTRQgv5MvMcjIDhhu73401uKAl67VRjRQqLzY4Oe7dZ6wQS/ZIKJh3jzX
	rpaS+eZ9/YC7Aa8HnpNBv78GkxsmyX8Z59Li9Awaoh77mQPv9WX5pnfEotMEnIVu
	0mfuj73W3J8O1i0LEvsxSMnsi8HDji/PBtXjPbRTIK14Z/HnHflnD9E71U2iKBfX
	glQQjqNm7DhTmrlugCI1Spvwvz0eSc3/s28YHig==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:QKMaNCXM51knhMydt3P1qyjBG3vY979Fsn4L+mKVeT0=:r06IUXEr/SK9/HNny/Yd0jvh9pIMdnPDJOlhi1wTglM=;
X-ME-Sender: <xms:tVLjauAakKpfiJDO7sFenNc-yF6SkdwRCcIb8kqLTBwzLddCzfFqzA>
    <xme:tVLjapMfsKyo-3PTTd_6wN_jlFpn_sdvZrTlprLcozulasTVO-SVdVRfhxHr7d7QL
    OAKiemEmcA4r0eW5rYKYdCONWJtL8ImOiNuaXUPsL8jOOWBeuHH8NpF>
X-ME-Received: <xmr:tVLjavxXlKD-1SIT01lEuRFNJ-jwFdFuF1aw3W9Iq2crwjZvQOMufITOz6z4g3Ot>
X-ME-Proxy-Cause: dmFkZTE7KLuhfrKb2HIseNOs169xOuvyKQYbygTniTtVamIAmj1omvQo7UUU4i0xiiF/95
    FHnK9owemhYX8ezXPAgK8hUdUIBzUq1HOsJjZbG++o06xuuMpwVAoX8vT0ut/5ryO5ERee
    uq+MMyBBUuI6sBZwgA2V1qZlypcwT6PbTFXu9Ftzu7st0PGT/GqKkUWOo9UMWzaIcJqUhw
    87kafCMbbYc5wo6wdtM36kVF+JpOkLlVwyq5gPA+iQU/duPu6r9IJbS26jc5ip8Dr045hj
    nUNZTwMUTTnkxge67BFNb7PnJeJji4gwIKP55pdrokJXlq6qr14oNrvV7suZu0ICaXOChJ
    GnTRqwpUFX83DO9LP/TSyUPJN7RxkSNGgfu44Pw2arxkkIFIXh41eWKfmy/KuqxrgD4dri
    6hgtupbBNF/hoynoOy+kgHSzsWt7OfkFy/5EI8MpqxPkk3p7ZOqCYwBUlgB0S9QXTUHF4D
    MBgq2jfGrWNp0HvfpUNaXniuIaljC/LPTy4l7f0sCV1O3QA5w8iVTeMM0FgFkqddT7VdLS
    7rZSILfJO0rw2FGuEYUTViFKDB+k16OXdr6cD+r3pCv+CJqXvaVdJB1rxZUrtJnLsnT/8K
    YhnAv47VxkKLUKarxMVletU8AT7SSV7yx3edjqoqlnYGZaQ5PdwqBa2QjhRw
X-ME-Proxy: <xmx:tVLjahU-05wg1Gp3mbyJM3Rz834ozbkaJQag1mazYOC2uQZHFss9nQ>
    <xmx:tVLjapOo7nTOtguL2h2T9Y1iBRp-9lXDX0CreQAWuK9wBotVxwuzUQ>
    <xmx:tVLjarDT_qTBWZOPzBVCA4nEx9MMpDl5r7oNmf_ExU2BFKQkSCJTRg>
    <xmx:tVLjauf_fIzjaTeyE9IxWP9nSxCYaFipnPjOGuEqBOs6fal3Ae1seA>
    <xmx:tlLjauevTuQ1UHF9fN2LtsLA-pzvhG4_yjVBndzejH8tIYwaNOXRXFC8>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 10:05:40 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH v2] ksmbd: enforce the DACL permission check on delete-on-close opens
Date: Thu, 29 Oct 2026 09:05:35 -0500
Message-ID: <20261029140535.260498-1-icb@fastmail.org>
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

smb2_open() skips the DACL check for delete-on-close opens of existing
files. On an acl_xattr share, a caller who passes the POSIX checks can
therefore delete a file even when its stored DACL grants no access. The
handle can also get read or write access that the DACL denies.

Add a dedicated DACL check for these opens. Evaluate the applicable ACEs
in order (MS-DTYP 2.5.3.2). Allow the parent directory to grant DELETE
and FILE_READ_ATTRIBUTES under MS-FSA 2.1.5.1.2.1. Use the DACL grants
when resolving MAXIMUM_ALLOWED.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Changes in v2
    - Replace v1 and the proposed parent-delete follow-up with one patch.
    - Use a dedicated check to preserve valid delete-on-close requests,
      including smbtorture smb2.acls.INHERITANCE and opens requesting
      FILE_READ_ATTRIBUTES or MAXIMUM_ALLOWED.
    
    v1: https://lore.kernel.org/linux-cifs/20261028153441.184701-1-icb@fastmail.org/
    
    Tested on ksmbd-for-next af8c72f65507. The original deletion bypass is
    blocked. Targeted tests cover group and forced-group grants, parent
    permissions, owner rights, guest and anonymous sessions, streams and
    MAXIMUM_ALLOWED. smbtorture smb2.acls and eight related suites match the
    base results.
    
    I did not Cc stable because of the patch's size. The size comes from
    keeping this check separate from smb_check_perm_dacl(), so this fix
    changes no other open. A backport needs 67cc25f7307c ("ksmbd: require
    DELETE access for delete-on-close opens").
    
    This leaves smb_check_perm_dacl() with its own DACL walk, which could
    later use the one added here so that ksmbd has only one.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c |   8 ++-
 fs/smb/server/smbacl.c  | 153 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smbacl.h  |   3 +
 3 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2e955d272f4b..b56fcbfc6039 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4848,7 +4848,13 @@ int smb2_open(struct ksmbd_work *work)
 
 	daccess = smb_map_generic_desired_access(req->DesiredAccess);
 
-	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
+	if (file_present && req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
+		rc = smb_check_perm_delete_on_close(conn, &path,
+						    path.dentry == share->vfs_path.dentry,
+						    sess->user, &daccess);
+		if (rc)
+			goto err_out;
+	} else if (file_present) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
 					 sess->user->uid, false);
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664f01263611..b6f4ec17c6fc 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -17,6 +17,7 @@
 #include "server.h"
 #include "misc.h"
 #include "mgmt/share_config.h"
+#include "mgmt/user_config.h"
 
 static const struct smb_sid domain = {1, 4, {0, 0, 0, 0, 0, 5},
 	{cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2), cpu_to_le32(3),
@@ -1685,6 +1686,158 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 }
 EXPORT_SYMBOL_IF_KUNIT(smb_check_perm_dacl);
 
+static bool smb_sid_equal(const struct smb_sid *a, const struct smb_sid *b)
+{
+	return a->num_subauth == b->num_subauth && !compare_sids(a, b);
+}
+
+/* Whether the caller's credentials hold the group of an S-1-22-2-<gid> SID */
+static bool smb_sid_in_group(const struct mnt_idmap *idmap,
+			     const struct smb_sid *sid)
+{
+	kgid_t gid;
+
+	if (sid->num_subauth != 2 || compare_sids(sid, &sid_unix_groups))
+		return false;
+	gid = KGIDT_INIT(le32_to_cpu(sid->sub_auth[1]));
+	return in_group_p(from_vfsgid(idmap, &init_user_ns, VFSGIDT_INIT(gid)));
+}
+
+/*
+ * Rights the stored security descriptor of @dentry grants the caller, with
+ * the DACL evaluated in ACE order (MS-DTYP 2.5.3.2). Returns -ENODATA when
+ * there is no usable stored descriptor.
+ */
+static int smb_dacl_granted(struct ksmbd_conn *conn,
+			    const struct mnt_idmap *idmap,
+			    struct dentry *dentry, struct ksmbd_user *user,
+			    u32 *granted)
+{
+	bool authenticated = !user_guest(user) && !ksmbd_anonymous_user(user);
+	u32 allowed = 0, denied = 0, mask;
+	bool is_owner, owner_rights = false, applies;
+	unsigned int uid = user->uid;
+	int pntsd_size, aces_size, ace_size, i, rc = -EINVAL;
+	struct smb_ntsd *pntsd = NULL;
+	unsigned int dacl_offset;
+	struct smb_acl *pdacl;
+	struct smb_ace *ace;
+	struct smb_sid sid;
+	vfsuid_t vfsuid;
+
+	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap, dentry, &pntsd);
+	if (!pntsd_size || pntsd_size == -ENODATA ||
+	    pntsd_size == -EOPNOTSUPP || pntsd_size == -EINVAL)
+		return -ENODATA;
+	if (pntsd_size < 0)
+		return pntsd_size;
+
+	dacl_offset = le32_to_cpu(pntsd->dacloffset);
+	if (!dacl_offset) {
+		allowed = GENERIC_ALL_FLAGS;
+		goto out;
+	}
+	if (dacl_offset > pntsd_size ||
+	    pntsd_size - dacl_offset < sizeof(struct smb_acl))
+		goto err;
+	pdacl = (struct smb_acl *)((char *)pntsd + dacl_offset);
+	aces_size = le16_to_cpu(pdacl->size);
+	if (aces_size > pntsd_size - dacl_offset ||
+	    aces_size < sizeof(struct smb_acl))
+		goto err;
+	aces_size -= sizeof(struct smb_acl);
+
+	id_to_sid(uid, uid ? SIDOWNER : SIDUNIX_USER, &sid);
+	vfsuid = i_uid_into_vfsuid(idmap, d_inode(dentry));
+	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
+		if (aces_size < offsetof(struct smb_ace, sid) +
+				CIFS_SID_BASE_SIZE)
+			goto err;
+		ace_size = le16_to_cpu(ace->size);
+		if (ace_size > aces_size ||
+		    ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE +
+			       sizeof(__le32) * ace->sid.num_subauth)
+			goto err;
+		aces_size -= ace_size;
+
+		if (smb_sid_equal(&ace->sid, &sid_owner_rights)) {
+			if (!(ace->flags & INHERIT_ONLY_ACE))
+				owner_rights = true;
+			applies = is_owner;
+		} else {
+			applies = smb_sid_equal(&ace->sid, &sid) ||
+				  smb_sid_equal(&ace->sid, &sid_everyone) ||
+				  (authenticated &&
+				   smb_sid_equal(&ace->sid, &sid_authusers)) ||
+				  smb_sid_in_group(idmap, &ace->sid);
+		}
+		if (applies && !(ace->flags & INHERIT_ONLY_ACE)) {
+			mask = le32_to_cpu(smb_map_generic_desired_access(ace->access_req));
+			if (ace->type == ACCESS_ALLOWED_ACE_TYPE)
+				allowed |= mask & ~denied;
+			else if (ace->type == ACCESS_DENIED_ACE_TYPE ||
+				 ace->type == ACCESS_DENIED_CALLBACK_ACE_TYPE)
+				denied |= mask & ~allowed;
+		}
+		ace = (struct smb_ace *)((char *)ace + ace_size);
+	}
+
+	/* Unless OWNER RIGHTS applies, the owner may read and change the DACL */
+	if (is_owner && !owner_rights)
+		allowed |= READ_CONTROL | WRITE_DAC;
+out:
+	*granted = allowed;
+	rc = 0;
+err:
+	kfree(pntsd);
+	return rc;
+}
+
+/*
+ * Access check for a delete-on-close open of an existing file with a stored
+ * security descriptor. The file's DACL decides every right, and the parent's
+ * DACL can also grant DELETE through FILE_DELETE_CHILD and
+ * FILE_READ_ATTRIBUTES through FILE_LIST_DIRECTORY (MS-FSA 2.1.5.1.2.1).
+ * MAXIMUM_ALLOWED becomes the rights granted that POSIX also allows.
+ */
+int smb_check_perm_delete_on_close(struct ksmbd_conn *conn,
+				   const struct path *path, bool share_root,
+				   struct ksmbd_user *user, __le32 *pdaccess)
+{
+	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
+	__le32 requested = *pdaccess & ~FILE_MAXIMAL_ACCESS_LE, posix;
+	u32 granted, pgranted;
+	struct dentry *parent;
+	int rc;
+
+	rc = smb_dacl_granted(conn, idmap, path->dentry, user, &granted);
+	if (rc)
+		return rc == -ENODATA ? 0 : rc;
+
+	if (!share_root) {
+		parent = dget_parent(path->dentry);
+		if (!smb_dacl_granted(conn, idmap, parent, user, &pgranted)) {
+			if (pgranted & FILE_DELETE_CHILD)
+				granted |= DELETE;
+			if (pgranted & le32_to_cpu(FILE_LIST_DIRECTORY_LE))
+				granted |= FILE_READ_ATTRIBUTES;
+		}
+		dput(parent);
+	}
+
+	if (le32_to_cpu(requested) & ~granted)
+		return -EACCES;
+	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
+		ksmbd_vfs_query_maximal_access(idmap, path->dentry, &posix);
+		*pdaccess = (cpu_to_le32(granted) & posix) | requested;
+	}
+	return 0;
+}
+
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write, bool posix_open,
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 3342cebab333..d9b11bb06331 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -98,6 +98,9 @@ int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool strict);
+int smb_check_perm_delete_on_close(struct ksmbd_conn *conn,
+				   const struct path *path, bool share_root,
+				   struct ksmbd_user *user, __le32 *pdaccess);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write, bool posix_open,

base-commit: af8c72f6550744fe948ef2dbc7ab8739c149aab2
-- 
2.47.3

