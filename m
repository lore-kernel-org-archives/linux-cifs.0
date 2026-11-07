Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794032571;
	b=V8xPQDtm9vAh2w7gWaDMFQcmtqT3H0i++ryi38007VTxyw/upuTsGt58ToerxLUtY9Gu
	 wKPSOUpQBn8mQ/90iMeCj3azFJPUaTtTDzBa1NX6xmLKYx8+xE+ogHdZ/6QzbPaXsmOuN
	 /GRlp9R8BEfgRv4A6UWs2aHyoUikcsuH7iz22+k/adABeOe+rjg/XIR0+amdmhJ+7dwmv
	 QpwGjtjwWMWPQBtgzAYl5+bFi04VHfog51DsTeilVGdG7+nedUzR1Zn2aud99nmeW+eEY
	 0uuKBPKeS+GgSao4q2JR5W+fcs0HaD+rkv1HpisWewHIQQJjNjwi7bRHvU8lyYziC8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794032571;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=qSJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=;
	b=1H/76ALVfqNyufBpsTSLTzW5qt5nj5KYN+wgYb6N06CWcx/+Vw7VS5ViUTE0M005qphV
	 P1WVUqk6ZZ/GT8KsQS+7ei3q2JRH3CecrNXtLbIBs0QTG7JfCbJt3YUJjtAyaCiNRTBAo
	 MXZSlUZDbAWKiJiWrt7tD6T8RZ+lWLh5w8QE1mEXdkMGwDysMpAzGvTJKqK5uoRFp2Kq1
	 HJyQDbaSnhHb2XJivCCvNW30Kj9QgxFbq1m1zvZUIiGoovUkA62gPMDJD0Ghl0l1FibBv
	 pa4yAGy3PjsCtYPzey0HQejVk4x+GgtxXiJvVRtRgNw21WB78h9T6Ty5EV6LAtRjxFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=i9tEsSEG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=4VlyjCX+;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE25606A33D
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 06:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DE25606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=i9tEsSEG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=4VlyjCX+
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 55A7D1D0018A
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 01:22:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 07 Nov 2026 01:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794032569; x=
	1794118969; bh=qSJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=; b=i
	9tEsSEGCOb9RW8iyCio4MerTeUucRAyCOZmz2GMlDQVPfFZ/mcTUCKM+CQcwQauU
	thwP0DEqZHel4llmoa/BD622h3AWj6Nn3coOwBNdT4hcMMGubecRSNfFSZzW57Hp
	libhqE1SXi6NdiS3wQ+xsUC+b1vIiJ0pPlPkBX9Dz23AC0bH8ngAQYcZHjuv1Mev
	ZO0IRLZmoXMnQFm5DQtmHk1hojlvRGCd0Dlg2ux7spZTeMwb8N7sJx5Nnz+Dc7Xg
	9hzslxezFOlUOdlnej982dsvkpkZY+WsASihXyd2IcNL4yVPnkJsedgARSxj/ZWo
	wFoS4vn/VX2gxk6uafvRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794032569; x=1794118969; bh=q
	SJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=; b=4VlyjCX+sfD8iJDa0
	mwA8pYlm91+nwR66RqpWB2Mlp7jD0AQv0bjECX7zqAj68hVpG7ZMWpOGU15Vpev8
	dfnhFui/YC5tBMopjI9hPaVMXPHQqqlQopeeGqqCJTH9blqUuyoeIzFAjpZfvd0P
	vPhQtowxduYBosTCWV4/S8+gxFUj6YJnzB1QTzA9eCG4XDq4nNXTTk/CxYtDjN/Q
	M8LfZM/C3UHx5TWopSx5ThjTmlCVIHT5drot4cncA5A1diuHRUkM64DMZyM2kAhn
	sZ3H0rMNKB4q0p5PNVSDdt5rAj6gPurZ0YS++WrTsKThwG3kC2lTxa1C5fC7ABYu
	RkqQw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794032569; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:GtcYQQEhdbFrRVlj1QpRNbTjuMlA+4GxY1p3Bj2kVX/735Q
	wi8kvxYbOXB2gZpEWBh6swaqz3ckX8bBYjod8cdLbjnucgLuiVQveWFlKYYf3Sd8
	FN43cWpelK7M9quhVljiPjjpWFAxmtGKxAPYDqsBFYjE5gPyWcNaT/NP9nbcAGLK
	ePsXeYSu70j3V7+fmV6/9unK+3p4RIwNJ27pngLlu5QmeYKmb3v0CtAJ1po0wf3x
	80aDLG7ZR0MWq0J3giPZsAERooXhWBVM3ztB13FMYSI7vbMSGFlUOXTvQWC+KYW/
	dfASUr+eyM9360EqjszSIYBDmXKjU0sSQRDcT3g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:IlJn4eJm0AN+t1Ijr1reWdHuu1265GeBcVgsfV0MLqQ=:3AVipOxupeCn0hZo5tw6pys6JMFGN9QV7mZ9dYnLezQ=;
X-ME-Sender: <xms:ucPuan1ffCk8BbVbsJpJtCjPFicZt6TKErEimXRebG22fPHvOJD4Ow>
    <xme:ucPuaiH0srWz4F4o4jpIwf6KNgsK4gJllL9yVtlFZAx8AkkxFCxyF94ekluNmr-qX
    dGBNgT7Kyu9ePrhuhHfAX5dNFMxDtpIEdOvKWZHQcVqijSbXCDYRhkk>
X-ME-Received: <xmr:ucPuaqHotlPuKL-WWA2edR-JLcZkL_3tFazM3ApAqZA8_COeqYH-9sBfCvA7KsL->
X-ME-Proxy-Cause: dmFkZTF+ZYfouUF5xRJs7vVxvG7U3oNeEMUxMjRA+2f1TMICIIFaxboN5AN93l7zFUbVay
    4lqqBbQdBaDa9UXFGuopVH46zxkc7rywOx8pkRKsA2NbBaWn9O82fPndHDyHwyEC4pp5rN
    9BCrOAQXGpn2sAYDnpRorXWGg4lFTjKeTQru2rdHdZkAJpAT/N77oeX66OMNpMh7B/NaDw
    2ujGLdjrqc9ggFS1ZxFkQvpBCMuj7dS9mFEenLsjQtqmnCEP5/14KFGgfOt7pydS9YETj6
    EXa2jYk5wyqxm7V+Sr+J4mR8e4ie6yU7lpIejJ1ox98x8iZe9PpiqvQXYfxUlmJVdqerWG
    BrzjDJ5Yb07MFVk7k1Qi9qdSaQC0jplel4JNrEdgdbJUJdr7MGkbPs6NGH0PPfvF0Mswwu
    DqH239IxsyYEi4gyCOaU5wOABn7ethNrjaF+PQqEzyF0Ei0ySWAshzmzrYDr5xU39KVDdQ
    sZWWOgIDZTHefVFFp5rBLqlept9MwOOyVtC9iY5q2iHbQSW/cH3RTNYBuTYrI//1TR1DaD
    6nmn9bB5ITtUqKUCiGHUail0RQUUqBRAe1dFHByWeQkhnETzWym2mBg4UXkNQrFtSZMUnh
    BfYf1KB5wwp8CAyMSrvzJ/EUe+1NGXKNguuMxZbuietL8G8AmNZvp6QtVYkw
X-ME-Proxy: <xmx:ucPuat6SAT_onCrdZzPrASPvQHxhqJ61Yfi6_p6PXVv-_tzS6EtfjA>
    <xmx:ucPuanzRZK3WOH7g-7cNSi-9YBZ-lX_eXO2dC80j2VGEovUA-X0gvQ>
    <xmx:ucPuakNP_xtDzlzO-d3IbdJCD1mBLQKyOLHW_UTklcJ9njgz_3tSPQ>
    <xmx:ucPualkhL_q8yK303BmInbUGzrxOn-BL1usrLKNeOAJli1Fih-CqUw>
    <xmx:ucPuah0r82vbpUgq6WlhIWNfrCsmU7HuYTCCB9Xc75aKttlvKcUvbrbG>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 01:22:48 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: evaluate the DACL in order for explicit access requests
Date: Sat,  7 Nov 2026 00:22:32 -0600
Message-ID: <20261107062233.1579198-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107062233.1579198-1-icb@fastmail.org>
References: <20261107062233.1579198-1-icb@fastmail.org>
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
ACE: the first for the caller or the last Everyone or Authenticated
Users ACE. When that ACE is a deny ACE, the function allows the
complement of the ACE's mask, so the deny grants every right it does
not name. Deny ACEs before the selected ACE are ignored. The selected
ACE can also be an inherit-only ACE, an ACE of an unsupported type, or
an NFS mode ACE. Guest and anonymous sessions also match Authenticated
Users, although they are not authenticated.

These bugs give real SMB access on acl_xattr shares. A deny of
FILE_READ_DATA can grant FILE_WRITE_DATA, and a deny of FILE_WRITE_DATA
can grant FILE_READ_DATA. A deny ACE for Everyone does the same for
every caller, including guests. Guest and anonymous sessions can also
read files granted only to Authenticated Users.

Use the ordered DACL walk for explicit requests. Match, by exact SID,
the caller, Everyone, Authenticated Users for authenticated sessions,
OWNER RIGHTS for the owner and the caller's groups. Ignore the NFS
mode SID.

Keep the single-ACE evaluation when a non-inherit-only object deny ACE
is present, as ksmbd does not parse those ACEs. Guest and anonymous
sessions do not match Authenticated Users there either.
MAXIMUM_ALLOWED remains unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    This patch changes explicit requests only. MAXIMUM_ALLOWED and
    maximal-access replies still treat guest and anonymous sessions as
    Authenticated Users.
    
    The NFS mode ACE carries the POSIX mode but names no caller, so the
    DACL check ignores it. inode_permission() still enforces the mode.
    
    Ordered evaluation now allows a right that an allow ACE grants
    before a later deny ACE names it. A reproducer is available on
    request.

 fs/smb/server/mgmt/user_config.h   |  5 ++++
 fs/smb/server/smb2pdu.c            | 11 +++++--
 fs/smb/server/smbacl.c             | 47 +++++++++++++++++++++++-------
 fs/smb/server/smbacl.h             |  2 +-
 fs/smb/server/tests/smbacl_kunit.c |  4 +--
 5 files changed, 53 insertions(+), 16 deletions(-)

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
index 32feafe9f73b..f773ab8efb3f 100644
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
@@ -1513,6 +1519,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
 
@@ -1680,7 +1706,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			or_ace = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
-		    !compare_sids(&sid_authusers, &ace->sid))
+		    (authusers &&
+		     !compare_sids(&sid_authusers, &ace->sid)))
 			others_ace = ace;
 
 		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
@@ -1752,7 +1779,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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

