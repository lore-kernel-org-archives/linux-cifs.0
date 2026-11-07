Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794093590;
	b=whOlUdicR8/2cB61P9nJHnBYPY6CezYY6i1u1KfgI3AsVP/Vh6HI6lg3Ybe5izMTfyo9
	 S6w1mGAu55GnIClhdk1Lv9lYYIc6ngqBCOer8nFbooS7bK8ZK/cpvHRsxa5HkMMJV6N6h
	 c+Kj1fLLHZk6n93E9ZOFH1Yd2WMgFy5uD+GvcTKHkYHSuS2yr0tZ029Vn1Gcq+wybjKkl
	 F4ura8OK0cGAWnQPVvKIF+m+gFFRNvvBXtA9Q03dzZFShYGSNfh955eeob3+HirjvNnzW
	 6XRdurg3yQzuacrKiZ3dVHZlt7wOaH8ZaZrYmpqQrBSRpu3cd4ngl7AhEpWuFj0dbfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794093590;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=qSJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=;
	b=NzPG0OJLy9LAHW3JUgpD3W+KcggirCRW7P5fqzRIBpCXZYZkDMtqllUEMfDfA7E9iRrr
	 1az4xbOlxBmHIwRlrX2ouSKm8dnJb9K7FEWCa+KCExyfqNCD9bWS8dna1eSoDrVJx6uDC
	 DbItqwwRSbbIBCswbtPL9RduB/D+DiLcuqPNX9cjuMOWmd1+PPuIj7G7/BcKWYmE1i/Is
	 /wvY1q112IN4hqS3W73b6w1xThUD/3qcPJiCDRkp+AyKyKqCD7/K/jFiTfB4Oe31HN5F3
	 wY5E5j/7wCkwg1N4kHGSIlf2Roagl8kCIO+ko4Ijy/Ur6ScELGFXRCQZcayxD6ySRvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=o1eDqJEZ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hxD4Evgc;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84438606A33C
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 23:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84438606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=o1eDqJEZ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hxD4Evgc
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id A53B4EC013B
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 18:19:48 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sat, 07 Nov 2026 18:19:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794093588; x=
	1794179988; bh=qSJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=; b=o
	1eDqJEZMofF57phlyTlyDBXpDXViOvcQH1x24iO5KLy7nmhZla5VAog/f0WRhEKe
	iRAqMeu/al60e3IB7mcumccnaggWaJbpvNF2PQ9u2ZEgGJEmwh7h6KHywpeJyF2c
	CJfXRtKP3t+InSxQtxmA86TNkm7geniVcBRJEFvdPL+tdfhcgskJLvZFAdXJhLtO
	YmEp1VFFva9N3tbPjWD/o81zGWjtsebQOTige6Umowkv05cvgAmP4hunNWlPImO6
	X4tnBq4Onfl55w2cn+9mZvivebkoe+27yH/DRHFzLUBFiH4nv8nRwPaT+/I4sNQA
	qQSn/VQGUb17HwK/Hu/Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794093588; x=1794179988; bh=q
	SJOzOej/lzgd23kvJOtZKXZtncGpnK0ntNc95PAhyg=; b=hxD4EvgcqAlQhheK8
	gLCpXd3BwbLDVyV+QOah4V0gB3CsnurEVT7By/rKpOwDp+srYuqC8632S+rc0Kau
	qnqsLr30xbKcXIVeal3DbFjYjLn/UquuEbrk9tv/jBtCu5//lZ/gIEDsTmuy3gv5
	w19VDkmeCxSWu+TnrDKdiT3nJj74crlw9GqCjeQ5TVf2ANT4nBH7/F/bZ/2T6qH1
	mCkfdjea2EQzOwGF/plSbbOUdumpx0yX+q+9/HOyUsaRtO743cIc4aVOVCVCusW9
	dE/DytAyutMOfO99mTLTEop17wj/A2NkYhJ5PfsJM3Fp4RjMFQvNpQVnBg3DKARP
	7ZzvA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794093588; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:K+PtfDt2ck07fbkPuylvNL7A0BocT5wXdebWHw715nVbkG4
	kmcSix/tJXg0GL/ppqmvtshV0Ckwg++wOy95T7Pm6RxC9O2ltxIw6Fk6vkh5YlIX
	DCkOGdxixwow3z+ud0V41wzrLurVjtjLZHiIN4qXPplDedfVKdY+FWX309zLpBfU
	rASvJ7xWag/eBs5NNS1kqBy73OZ12OcrMRKFq2eD4Jb5Xlp7do5aPIijEZIF3qyg
	V3tGPakYoEeHorQwA9eDQtqNr8OhxM6fkVEFUe72BwkBmqZwshsOBeNvH25gfm6r
	qdfXYUz1+VHjkynl3RTm6NTvc6mDoh7DkHrzQbw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:QQqNpo3/PcQdDbfaWXYr0KUSFElQDjD7GBBMBzoZqxI=:3AVipOxupeCn0hZo5tw6pys6JMFGN9QV7mZ9dYnLezQ=;
X-ME-Sender: <xms:FLLvaqAeto4urpbpAiyo9vNsaWa70tR-VSyOgtZTWBuKzxrWV6ySqg>
    <xme:FLLvagjIRj_LPbIFWq5prLETdy4gDCcDZi6k-1SuD-RSrSp4-_BEPxpDmigNh27-T
    8zGOXNKXVzx1w5gQ9FkC1yjY_M5MKieW7g3f3HjCP9JxYEBfoQ7q_81>
X-ME-Received: <xmr:FLLvavyr_WKCvPeCcYOnu5mmGsSSuVq1Zpx816LYZfj66tFeRpGU_WhiQr-ARuJ->
X-ME-Proxy-Cause: dmFkZTF3A2RNYDSzppuLfJv23ZeZqdZGjyr5+tBcTjdHmcnhg1lhAuR3eU80W8lWp3/t4/
    28U5Ft9H89wUqxgNArx4xzHPGqFa/uTLcArDMuZejURvlfVcMJ7+2Sb2vI3dQTernsAfIM
    xijTQFmgCvqYqhM+8dCUDvrUVK1Td/1Zj1qlZ25QQ5MfYQybPKaJpZSu1SyP6m+v1SdZk4
    U3ob8VISlbglRKgsG3RRekDxTc+tSpCEs9rypv1SF8lV9q6R+t5ZeIH2K9jtMg3dndG88H
    mFVvmQ7mZe6iNtauJYapEySSpQu1mSTsHL+MeJ033nVKZYNhgvv43tEPQWXGdePMNytJZs
    tbFJgJZhua2VyHCpJU6EdhK+9R8c1JK/45XF9Wh2Wwpg8LDW1AcWfIkYjYqZll94rC/9ML
    mvhYm6Rp2MCpQu6GSCxa5CkBuiXAuadGPZCbko/j3PYQagwcH6AkHXm581IQ3MGpVi1h/4
    rIvakyIgBdnpNHrtYwIuCHN5HLzDYJoFvB5qh3O8P/ZLJX7PkRWThHoTXcQ0/nk0ckNn0v
    /w9SLGsRzXWT2FGPgMx1soZaCG8UUFFjkpQ9POBCeBOpiiBJYugm+yvoa4pPff1RyyJL44
    4W3Qe3QNbPHBb+y8SA7w260ts37cjWiuaY8N9dMYSj6GfHl2Jv++q1WnG04w
X-ME-Proxy: <xmx:FLLvap2CilXIFKeyzbWfg7a8MikhTslAn0T7S5KUOUjZsVo3A5Szbg>
    <xmx:FLLvas9_LPNbacbp5NEJVZy9ULbX0ndjpC9O6SGdXMXJKsOOqaI3lg>
    <xmx:FLLvapoaJ-fYGeKv9OdeqoOtlh_R5EpdNvci6F8ixZbxtgM-Un3Ajg>
    <xmx:FLLvamTfBCExPNfYDIbg0Z7WMJqQigtNtJYkzyTBc4KDi7R-9P-F0A>
    <xmx:FLLvajoEPFuxi-a1dKCKcDTwOA6IzfOH9E8p-MspiFSO_5vqwt3LGQCV>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 18:19:47 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] ksmbd: evaluate the DACL in order for explicit access requests
Date: Sat,  7 Nov 2026 17:19:40 -0600
Message-ID: <20261107231941.1824289-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107231941.1824289-1-icb@fastmail.org>
References: <20261107231941.1824289-1-icb@fastmail.org>
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

