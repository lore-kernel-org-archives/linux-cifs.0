Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794162029;
	b=yHiR9qQHyLl7vuatRYyjecVCr3mLhG85dksEvhx8v8flAZvmyT6RAQ0NVmQt+Q2GVGiH
	 Zac8XoyovslqWB94XSNbVxdUncRmrkSYiacmdbLmgyb8lzES4WuFy4GHnOcMHQ5X7zx04
	 XITSlXgPqt1E0lkkNzMeO1pSqL4DFMz63L+OSZkMQOb1XPlALIQGNStwXK++6dBXBNM7t
	 2NsmT3KMVYwtUf+51LiagjdoTvMVVCnq17vT8JHj17QDz7pP6Ar/Y88VJWOqEzeQOVE2Q
	 oJZxkE7Tw4eNfCntjNldJP1ftxwsN0koQkOcH5WokQb8hCZzIfBSOOaaCIf6925b1Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162029;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=sWGRS28SHSydb7Ft4ivxXV0FeZDv8wPPrZXJsCIif5w=;
	b=QgCgT2PQhOe2gjRX1czcQxyp43/JXE6qBwoND2B5mzUCGDVJNqkwgZrqs7MoKCaopkrG
	 hF9/4dxUJH+qqzqHVP9Euet2EijCbYvo75EeiY0gmgiuC/6UDBTAHhVDkDaucwzt6einE
	 tJyIH8sJS4m+M3wblqjCw3lIOHnos1zbEl2rHUhiTSK7/dyuuwv2KbNggdSwbyRfKGwMM
	 Dpnru/ULkCJ7Xv44BiXV4g4r4KM9G+AT/7otvbr4k5Se7k4NQH0AiFfVR6OudgJly1xeI
	 +Vacv0dD0VsmVz9Yky2UVcXhPnSA2Id8wj+tdUaVLelPUZcDCw8yxIo8VaDK7SgBInA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=V6GQlvT+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=1KxoUTsG;
	arc=none smtp.remote-ip=202.12.124.157
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637CD606A326
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 18:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 637CD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=V6GQlvT+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=1KxoUTsG
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 82F437A0089
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 13:20:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 08 Nov 2026 13:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794162026; x=
	1794248426; bh=sWGRS28SHSydb7Ft4ivxXV0FeZDv8wPPrZXJsCIif5w=; b=V
	6GQlvT+/PC1gHaO3rPWQYjV4+IhJ5N+/P8h+XCB799qZVEhJduOgNiHVE9oMN22l
	FhSM0dFqOrY8WZpoUvYeD2GBXvRylAcAsIvyJeWiU/Y0zGG5Fx4S7OZcpD2sDNlD
	ElsaFYvbts5tO/oU3wdoWvkTx4Qpk+xQwU/G2pZm0oyMG0OabM4gcKZFZSKA8072
	2Vc/I+sDET/KLDw387YO8L1/p8UOQEu8L1XHDBeZvwYbRVA/GCtsqeL7hgRiOAnI
	uGCtLuWGqDYVvDo1OPJc1dmwFv0xsopX9Smhn5A4RzGUkszv3+hTlByTXW6l/eo8
	EnErfENwXm+94yPYkpRMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794162026; x=1794248426; bh=s
	WGRS28SHSydb7Ft4ivxXV0FeZDv8wPPrZXJsCIif5w=; b=1KxoUTsGJsYLZG9HR
	30vjItJSvRs/Gk7h9EkSfuVsm11t+zifyRf+cFqwVaQA9VXMP3BXScqgME3AIyW1
	rj3uC3rD/AISALo+S6DS7bIvGDrrEYEqj4GqWabvd9+5MHfjy42QKr6byzAcwuRr
	x1c2uEBvFP/xSeoXrfZEeaWt3FFNKJTIspJF7s/2SBMesLb85v7cPj56PXDABRWm
	XRwuFbbMSljaXrGtlmq22GRuItJ3JLXMYgSZnJNH9NBpl/UyXmVin7mSyu81s1BW
	UV6YMCUsXHCl/dFKjdaBY0J/deZ5ModHz7l0AIgBVUcExMk1AF0umYsmxFK9E9mf
	BqnSQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794162026; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:deH2KhGRXszAo+GxsbTV9n9lZ/3+v0FIrK7d72SpvrB+3OV
	xEE3oi2HRzSXYwoHMPdQg96Vf9UhGDd16pxj5CHEJ08JQlVb0ym3+tp7YjPgRHdj
	w3G56k1M1KW13trysMIW9sDrX0lqR3bUth8GDZLzkajgKeOTdTORL50rf2AMuwLX
	dNXcx4Q2lZBw2bQ5CIUC9RQaC1xwgrL+VtskMbwi3FZpKHk11u4qe90B+5stHc8V
	zVdgRhV5R0oNRSi4LE+wSSRw6kkfCvDn0OU1+lXxYw+St9mwCvtblblJsu2x6fWv
	BV5gqS99kjCABWbC9wXaOL8vZ3vWRzSCRggeY5A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Fd6sTZCTPzlzctgh1GIRzwXMwKdhDB4P3FSmQFrPoHE=:3YmgSWmc6wjSt7ZLLV1/n1MBpfVDDhI1qcOtVB3LJWM=;
X-ME-Sender: <xms:ar3wajf5uuZmrSMFZm9C709fucZGwpz57VMKMfia4j4Sx0wQ3-47Gw>
    <xme:ar3walOE74rakmBMwds86of59XKN45vqfcm16TTTWC9v0LVBOmU2EwIr7gR5bR94_
    zP1NJtE-NDeGBWOOvNgEokqaqHWPGkVkzYIjjS-0Ngt7apxj5GKweQ>
X-ME-Received: <xmr:ar3waus5JdKmQc9825h10PZIEWlI672ZYkKQ67Mk2mkX6SMLsJRxwrQrbgkFFDC3>
X-ME-Proxy-Cause: dmFkZTF9p8/wjD7nNAjsEG9BG3lBZhFZie2Yvv/V2kNoAm2vb/uDh8K7U91JxMdwVksDK+
    f1QfiWDeUaweODhShT3zmpym0u5ZL0InJck3o/ldZnfpqsDbT1Xd7Q7LhM64qO3AZW20Ih
    PkCHr4q4lFj1MYDMotmjVyLDCbYQlWrlSMZk1Ldk746IoMasqiJ2ODLWQgQAia4zYukkSa
    eyEkjPg5dn8NLKd+U1IxR7Zx3YPMBISW/nGVRX4AK8Dwgaxtm9hwCne/h72ILoHBgGtQgT
    rwV7+yBb54JJYwdTTeYzMCuHbO8iRsQKMcb0+S7+c3hTz4MzUlR9sDF1Tvb8qE1RNMMMBF
    PY4Ra/MhQiljsbh0giIHcmZ0QtO6xIMClz8RrC9MztXRSwQV0RYrYrf6os1HjUV32Wh7W/
    TSwvc0fQCHV4Lykl363NC2vkGeRdZ4oxYLAYmKDCnlQhLPSjjGrX0EFc3wP6c/m+htO9Md
    J7Ummk6hrpuhi9JFEMfLkPswZ+HxJJjhVLmrqRNX9+rA6Ic9HvdBIEso44FiUNMC9FTYbb
    0QvCYsP2oP8ZU4jtpFnAhmuYFQaaibGUb5G5P+VMALIxfdkUjjGxVYlwCctStkkeRyJTaW
    UIqh3Q6Nbky8YIOLsxo5JmKV/aJcvqCVK9jlPhtpnQLL1VQMOe6e3rCAM7fA
X-ME-Proxy: <xmx:ar3wamCrOk2_dOygvqld-LFbcAPR2VGNcjkQFWvqWEzSqvgopx1MXA>
    <xmx:ar3watYMkVtaXKpVFKNl36LCyn7-CawS4Jr2X6nSEn6XzXh1npJecA>
    <xmx:ar3wapVwH8XEDbSSj_3Gd-FVCWQeWdyWWCadVO_aTH9bmuBf9MIOHg>
    <xmx:ar3wakP9ZK5vm7x3pX4eWsbiavbkHy8cmQv-f4nfYdEXgasb0HIxpw>
    <xmx:ar3waimg9NEj4Hka5lQHEb6ECQNJKQBw0SnqlKB01smG09h_5_rJc7Pv>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 13:20:25 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] ksmbd: evaluate the DACL in order for explicit access requests
Date: Sun,  8 Nov 2026 12:20:10 -0600
Message-ID: <20261108182011.1888520-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108182011.1888520-1-icb@fastmail.org>
References: <20261108182011.1888520-1-icb@fastmail.org>
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

For requests without MAXIMUM_ALLOWED, smb_check_perm_dacl() selects one
ACE instead of evaluating the DACL in order. When the selected ACE is a
deny ACE, the function grants the complement of its mask, and deny ACEs
before it are ignored. The selected ACE can also be inherit-only,
unsupported, or an NFS mode ACE.

Guest and anonymous sessions also match Authenticated Users. These bugs
can grant read or write access that the stored DACL does not grant. For
example, a deny of FILE_READ_DATA grants FILE_WRITE_DATA, and guests can
read files granted only to Authenticated Users.

Evaluate explicit requests in DACL order. Use exact SID matching for the
caller, Everyone, Authenticated Users, OWNER RIGHTS and the caller's
groups. Match Authenticated Users only for authenticated sessions, and
ignore the NFS mode SID.

An Authenticated Users ACE must still prevent the POSIX ACL fallback
from replacing the DACL result for guest and anonymous sessions. The ACE
does not grant them access.

Keep the existing single-ACE behavior when a non-inherit-only object
deny ACE is present because ksmbd does not parse those ACEs. Guest and
anonymous sessions do not match Authenticated Users there either.
MAXIMUM_ALLOWED behavior is unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    This patch changes explicit requests only. MAXIMUM_ALLOWED and
    maximal-access replies still treat guest and anonymous sessions as
    Authenticated Users.
    
    The NFS mode ACE carries the POSIX mode but names no caller.
    inode_permission() continues to enforce that mode.
    
    DACL-order evaluation keeps a right granted by an allow ACE before a
    later deny ACE.

 fs/smb/server/mgmt/user_config.h   |  5 +++
 fs/smb/server/smb2pdu.c            | 11 ++++--
 fs/smb/server/smbacl.c             | 58 +++++++++++++++++++++++-------
 fs/smb/server/smbacl.h             |  2 +-
 fs/smb/server/tests/smbacl_kunit.c |  4 +--
 5 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index cc460b4ff7d3..e116b2ee9917 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -67,4 +67,9 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 void ksmbd_free_user(struct ksmbd_user *user);
 bool ksmbd_anonymous_user(struct ksmbd_user *user);
 bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2);
+
+static inline bool ksmbd_user_authenticated(struct ksmbd_user *user)
+{
+	return user && !user_guest(user) && !ksmbd_anonymous_user(user);
+}
 #endif /* __USER_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5bbc33d5a3a8..72981756ee23 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4338,7 +4338,8 @@ static int smb2_handle_app_instance_id(struct ksmbd_work *work,
 	/* Authorize the referenced open even if its name changes meanwhile. */
 	old_path = &old_fp->filp->f_path;
 	rc = smb_check_perm_dacl(conn, old_path, &maximal_access, 0,
-				 work->sess->user->uid, false);
+				 work->sess->user->uid,
+				 ksmbd_user_authenticated(work->sess->user), false);
 	if (rc) {
 		/* Access denial prevents takeover, not the CREATE itself. */
 		ksmbd_put_durable_fd(old_fp);
@@ -4860,14 +4861,17 @@ int smb2_open(struct ksmbd_work *work)
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
-					 sess->user->uid, false);
+					 sess->user->uid,
+					 ksmbd_user_authenticated(sess->user), false);
 		if (rc)
 			goto err_out;
 
 		if (maximal_access_ctxt) {
 			maximal_access = FILE_MAXIMAL_ACCESS_LE;
 			rc = smb_check_perm_dacl(conn, &path, &maximal_access,
-						 0, sess->user->uid, false);
+						 0, sess->user->uid,
+						 ksmbd_user_authenticated(sess->user),
+						 false);
 			if (rc)
 				goto err_out;
 
@@ -6347,6 +6351,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			rc = smb_check_perm_dacl(priv->work->conn, &path,
 						 &daccess, daccess,
 						 priv->work->sess->user->uid,
+						 ksmbd_user_authenticated(priv->work->sess->user),
 						 true);
 			if (rc) {
 				dput(dent);
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 32feafe9f73b..50a03101cd8a 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1478,6 +1478,12 @@ static bool smb_sid_in_group(const struct smb_sid *sid)
 	return in_group_p(make_kgid(&init_user_ns, gid));
 }
 
+/* Whether two SIDs are the same SID */
+static bool smb_sid_equal(const struct smb_sid *a, const struct smb_sid *b)
+{
+	return a->num_subauth == b->num_subauth && !compare_sids(a, b);
+}
+
 /*
  * compare_sids() compares only the sub-authorities both SIDs have, so it
  * also matches a shorter or longer SID, such as S-1-3 or S-1-3-4-777
@@ -1490,7 +1496,7 @@ static bool smb_sid_is_owner_rights(const struct smb_sid *sid)
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
-			bool strict)
+			bool authenticated, bool strict)
 {
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
@@ -1507,12 +1513,17 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	unsigned int access_bits = 0, denied = 0, grp_granted = 0;
 	unsigned int grp_allowed = 0, grp_denied = 0, bits;
 	struct smb_ace *others_ace = NULL;
-	bool or_ace = false, obj_deny = false, member, counted;
+	bool or_ace = false, obj_deny = false, au_ace = false, member, counted;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
 	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
+	/*
+	 * MAXIMUM_ALLOWED requests match every session against
+	 * Authenticated Users.
+	 */
+	bool authusers = authenticated || maximal;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1564,9 +1575,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	/*
 	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2). access_bits collects
-	 * the MAXIMUM_ALLOWED result. grp_granted collects what ACEs for the
-	 * caller's groups, or OWNER RIGHTS for the owner, grant. It is used
-	 * when the SID lookup and POSIX ACL fallback below do not decide.
+	 * the result for the ACEs that apply to the caller, without its groups
+	 * for MAXIMUM_ALLOWED. grp_granted collects what ACEs for the caller's
+	 * groups, or OWNER RIGHTS for the owner, grant. It is used when the
+	 * SID lookup and POSIX ACL fallback below do not decide.
 	 */
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = pdacl_size - sizeof(struct smb_acl);
@@ -1606,10 +1618,18 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		    (compare_sids(&sid, &ace->sid) &&
 		     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
 		     compare_sids(&sid_everyone, &ace->sid) &&
-		     compare_sids(&sid_authusers, &ace->sid) &&
+		     (!authusers ||
+		      compare_sids(&sid_authusers, &ace->sid)) &&
 		     compare_sids(&sid_owner_rights, &ace->sid) &&
 		     !member))
 			goto next_ace;
+		/* An explicit request counts only SIDs that match exactly */
+		if (!maximal && !member &&
+		    !smb_sid_equal(&sid, &ace->sid) &&
+		    !smb_sid_equal(&sid_everyone, &ace->sid) &&
+		    !(authusers && smb_sid_equal(&sid_authusers, &ace->sid)) &&
+		    !smb_sid_is_owner_rights(&ace->sid))
+			goto next_ace;
 
 		bits = le32_to_cpu(ace->access_req);
 		switch (ace->type) {
@@ -1627,8 +1647,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
 			if (counted)
 				grp_denied |= ~grp_allowed & bits;
-			/* access_bits takes no group denials either */
-			if (!member)
+			/* MAXIMUM_ALLOWED takes no group denials either */
+			if (!(maximal && member))
 				denied |= ~access_bits & bits;
 			break;
 		}
@@ -1648,8 +1668,14 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
 			access_bits |= FILE_EXECUTE;
 		granted = requested | access_bits;
+	} else if (!obj_deny) {
+		/* An explicit request takes the ordered result */
+		access_bits &= ~denied;
 	} else {
-		/* An explicit request uses only grp_granted and obj_deny */
+		/*
+		 * ksmbd does not parse object deny ACEs, so with one present an
+		 * explicit request keeps the answer of the ACE found below
+		 */
 		access_bits = 0;
 	}
 
@@ -1680,15 +1706,23 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			or_ace = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
-		    !compare_sids(&sid_authusers, &ace->sid))
+		    (authusers &&
+		     !compare_sids(&sid_authusers, &ace->sid)))
 			others_ace = ace;
+		if (!compare_sids(&sid_authusers, &ace->sid))
+			au_ace = true;
 
 		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 	}
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 		posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);
-		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace) {
+		/*
+		 * An Authenticated Users ACE keeps the POSIX ACL from deciding,
+		 * also for sessions that it does not match.
+		 */
+		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace &&
+		    !au_ace) {
 			unsigned int id = -1;
 
 			pa_entry = posix_acls->a_entries;
@@ -1752,7 +1786,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		}
 	}
 
-	if (!maximal) {
+	if (!maximal && obj_deny) {
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
 			access_bits = le32_to_cpu(ace->access_req);
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 3342cebab333..bbd35948a379 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -97,7 +97,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
-			bool strict);
+			bool authenticated, bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write, bool posix_open,
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 33496b4d31a3..bf28439a7696 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -229,7 +229,7 @@ static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
 		goto out;
 
 	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
-				 cpu_to_le32(FILE_READ_DATA), 0, false);
+				 cpu_to_le32(FILE_READ_DATA), 0, true, false);
 
 	/*
 	 * The post-boundary ACE (ACE #2, beyond pdacl->size) grants
@@ -271,7 +271,7 @@ ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
 		goto out;
 
 	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
-				 FILE_MAXIMAL_ACCESS_LE, 0, false);
+				 FILE_MAXIMAL_ACCESS_LE, 0, true, false);
 	KUNIT_EXPECT_EQ(test, 0, rc);
 	if (rc)
 		goto out;
-- 
2.47.3

