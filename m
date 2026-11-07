Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794093591;
	b=lWIFM5cjFVxp4KT8CG/0nmrFB6l5lXfNEzw5J2yf+CuQOLg4yM+WOhVleC6NVewx7yXt
	 gpfqKKAMvwjhfvAnqWjOOiGgcTqqrlJt8HfM7uu03uZQLFu5S+vvLNkChFMZW1vLXZNRI
	 n88OjOE0r3iw4P151EVx4N+Bj1DHcWU47kNlsbcVmHcE+ACGWp8C0bMJy6odlpNcIlB6r
	 n/8L3recSyhLikbGvJ4iSjzWAnh8jZUHJHKd+dVLSDlNWqmf4CJm46x9fwo0KYQtbcK+K
	 xU+ymlxFDkrDX/bj6d7Vm5Biq2sV19/XgAM0rYe8yUp40euqsSDcg6+B5yMeO28dyIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794093591;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=U0kwmV66D0fa/q0TUmbkY0cbJnJlw/6+avpt9fMsArY=;
	b=psynT4zBJTa/f+fe7Dms6t+N0pfqV4JdbnwXM8B9wiZLibAU1k7K7G2p7nDR+tPgvUGx
	 x36O7MxET/Jxz4pqaRnkSxEBRCiX6MimKsCF56TPFPf2QA23RrR65waAdnUKUdnnOUQy2
	 RIJWzuhrnojNGp1bcTJb3RnSiVYHbxF+bQq783qxC4MjEcynicpuzkhfBf6xIyzJDO6VM
	 m758Sb+EVbTqXBQzcvQF56jJ1h3YCEK680aiaRdOFhFZOlFQMqUYSKTRSDW7LG6WeDbIg
	 RtMb6y9mlohuilr9zDpm7Uimm8cWkXA+ORcxIIPujY0zonKMWROLDE8L5RzAIlp5B2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=NayXQmVT;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lnTVoz9s;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA4C606A33F
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 23:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DA4C606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=NayXQmVT;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lnTVoz9s
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5F86C14000BA
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 18:19:50 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sat, 07 Nov 2026 18:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794093590; x=
	1794179990; bh=U0kwmV66D0fa/q0TUmbkY0cbJnJlw/6+avpt9fMsArY=; b=N
	ayXQmVTKGLZHKN53H/0MupEL/yzslwwTo8CztK2ObRc7wqEx3xfVN8pmIFNyE1cc
	snJok1rNnWgDiAc3ig+/sC4Rc6KppFiYCKPhMcBnc+CvvCFqRZ7BuEGva4O7k24Y
	18psRdEGGAvwq2c4PzIPpBVas/ejRY9F6wABxJZ0w6XjDMCTS3VJx0xItOByYN2K
	X/xrldbWuYlsV+83944MPICx/xaE9p8RirADMAD3UCxAkYnOJWpMwjeoVDtY/Hoi
	rMZx8DNWP0Z62F8j8DoxATTpmygCahNBFJIygsKGJqBm7zku79B2NdnB7RRyRKfw
	SxvRa8wQdWEIXMFWMV2ZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794093590; x=1794179990; bh=U
	0kwmV66D0fa/q0TUmbkY0cbJnJlw/6+avpt9fMsArY=; b=lnTVoz9si2Bm8y2zi
	B/MfChnE5La7yjV38K4/Qcf+DmgYzG9+V21jHWC8m1XWl905aMh+2qr9Rx9349KK
	xuh7+nudD0pAsqfZ146AmuMVFd+V2ql3cOW+N0U8FWUJWhS4C1Mn5WMoC6Qt0IUF
	W07ADL8yRYAFujKN1t2Ugslpl7K/EJjaoqyC4BV96m+GICj47ahXEEYTUCwR4YEp
	gA3bVWw76Cx15IXHDxzd8/M12GBR8vUrBcK6arpPHIC2XTX0E+0LC0+tvMANwMkN
	RJnw+yEG3OzZ0+dlwr7QEpjI++8WG2IJF3EriVjdDk/l6HErkNnujvsGTjXDpoCw
	pf8hQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794093590; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Mz01NRRN6k0/633zkF+yW0FTkIbsqWP6lnK+u+xbi/kFJbX
	RCUhiyo74N9cadbwt+WzzrDtX2eyY6TxrUM1JRfE0xwGdFOF9RWhJL4nNpSh+hex
	35wVg1zA5mQi9Smnj/hgN0ehD2hzxMSlkUsok2MykXvKa224KHTLuhywaO7wbqw3
	eLmuoN8zMExf39y5sq9yJobre3aUlF2Xm376zXNV4we96sdpCoYronRgeT1TS72J
	z2mwcTcRSJva7fxwQsVtE3mlQLKAP0+HGLWPFwHBKe7LC+a0zUBCK3Z1+v6Nzo4S
	w/UeOvS6y3C79R8vj5Q4Pd/BmFdL8u4gM/dacgw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:iaKkzif2oamvEkXPnEbYu+8QNF7Xg4338kdp1q1X7/c=:Jou2TuM6JzbQxZTUgMj63PxMq/x3fyWlY0WHfhl8+Eo=;
X-ME-Sender: <xms:FrLvanb1NrgjEZcR4zMMKd9aTNzlxuX_-dSzOOAQBpwkJSXE1-kIag>
    <xme:FrLvaiaFbk0QtpQNkXeAeCc7BSPWr3YYBNxzJIqyMlCtW8orYA8bZ_pQkunJJ_OsT
    -R_lUj4_5bDoVSeoeRyHF0Ah_9m581Ky_ABVPuw__RBt_RVqpvrlBd9>
X-ME-Received: <xmr:FrLvasIlennnBA5zjXHlkZjavqLC06NkhjM6E0Odkt2MxvWjmGmNiycdLn4fJDUW>
X-ME-Proxy-Cause: dmFkZTF3A2RNYDSzppuLfJv23ZeZqdZGjyr5+tBcTjdHmcnhg1lhAuR3eU80W8lWp3/t4/
    28U5Ft9H89wUqxgNArx4xzHPGqFa/uTLcArDMuZejURvlfVcMJ7+2Sb2vI3dQTernsAfIM
    xijTQFmgCvqYqhM+8dCUDvrUVK1Td/1Zj1qlZ25QQ5MfYQybPKaJpZSu1SyP6m+v1SdZk4
    U3ob8VISlbglRKgsG3RRekDxTc+tSpCEs9rypv1SF8lV9q6R+t5ZeIH2K9jtMg3dndG88H
    mFVvmQ7mZe6iNtauJYapEySSpQu1mSTsHL+MeJ033nVKZYNhgvv43tEPQWXGdePMNytJMm
    yf/f4vhxHSy8iwiSIB0ie4+Yl5T9zWLnJR2PqLWXQenAH79qvYNcLTKJj2QidMbcBgQqQ+
    onzjnZpQDjwkZFN5Po0EZsChD1uVge1yJ0OKjgRnmaf3A8JBng6qbGDZqll34CALlwV7m0
    GVcC3ysek5yplIIkyuzaEQHwokRJFJxO7PT0EWKvz144MpNiUqj3eCgRq/qNHhbTOMu4YZ
    XDiS2+KN8OH5g6eKYI5V3PBUgMV3IneESr2C+5z7qaj5QmQRGc0cGO0yfJD2hA8exulnHu
    XFPTlx2tqm3x1uLQDG6XJEr9JmVMEbASuVfME5iD1FcprIeoOeRV0LqWAX0g
X-ME-Proxy: <xmx:FrLvaus_erT2ulPrODDG_7efJXcccE0kCy2h4z22dlg8qE_NfCe6Ig>
    <xmx:FrLvagUuPOtUV5P0OvKLHIVQM_8l20W4KR6ajXXaEGTzk2SyycGrxg>
    <xmx:FrLvapjLIAp35MCHVKwaq-mDxWb53ee1HRjWEzHX93Is5Zqd-K4Yyg>
    <xmx:FrLvaopvgchfFrR7bxykJjajauFbqJBHX8J9jmYF-lr53XvHduIFIA>
    <xmx:FrLvagDqqnxVp43Bn76jcUiX3MXuxmSI2PzkvJ4Ui_chOYl_K37MsDxG>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 18:19:49 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES
Date: Sat,  7 Nov 2026 17:19:41 -0600
Message-ID: <20261107231941.1824289-3-icb@fastmail.org>
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

A directory's FILE_DELETE_CHILD lets a caller delete the files in it,
and its FILE_LIST_DIRECTORY lets a caller list them with their
attributes. ksmbd checks only the file's DACL, so an open for DELETE
or FILE_READ_ATTRIBUTES can be refused even when the parent grants the
corresponding right. For example, this happens with an empty file DACL
under a parent that grants Everyone full access. Without DELETE on the
handle, the caller cannot rename the file or set its delete
disposition. A caller can also see a file's attributes in a directory
listing but be unable to open the file for FILE_READ_ATTRIBUTES.

When the file's DACL does not grant a requested DELETE or
FILE_READ_ATTRIBUTES, check the parent's DACL for FILE_DELETE_CHILD or
FILE_LIST_DIRECTORY respectively. Use exact SID matching, include group
allows and denies, exclude guest and anonymous sessions from
Authenticated Users, and fail closed on non-inherit-only object deny
ACEs. Do not look above the mount root. A missing or unreadable parent
DACL grants nothing.

In the parent check, ACEs for the caller's groups and OWNER RIGHTS
decide before the parent's POSIX ACL. Otherwise a POSIX ACL entry for
the caller decides whenever no ACE names the caller, Everyone or
Authenticated Users, and the rights that entry maps to never include
FILE_DELETE_CHILD.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Plain MAXIMUM_ALLOWED requests and maximal-access replies get
    neither right from the parent. Deriving DELETE for them can make
    smb2_open() refuse opens that succeed today when POSIX denies the
    caller write access to the parent. FILE_READ_ATTRIBUTES is left
    out there too, so that both rights come from the parent only when
    the request names them.
    
    Because smb2_open() fails an open whose maximal-access reply is
    refused, a DELETE open requesting that reply can still fail when
    the file DACL grants nothing, as on the base. A DELETE open also
    still requires POSIX read access to the file.
    
    Other checks keep the POSIX ACL's precedence over ACEs for the
    caller's groups and OWNER RIGHTS, as on the base.

 fs/smb/server/smbacl.c | 100 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 83 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f773ab8efb3f..b9a7fed33a66 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1494,6 +1494,11 @@ static bool smb_sid_is_owner_rights(const struct smb_sid *sid)
 	       !compare_sids(sid, &sid_owner_rights);
 }
 
+static unsigned int smb_parent_derived_rights(struct ksmbd_conn *conn,
+					      const struct path *path, int uid,
+					      bool authenticated,
+					      unsigned int want);
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool authenticated, bool strict)
@@ -1514,16 +1519,19 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	unsigned int grp_allowed = 0, grp_denied = 0, bits;
 	struct smb_ace *others_ace = NULL;
 	bool or_ace = false, obj_deny = false, member, counted;
+	bool grp_ace = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
 	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	/*
-	 * MAXIMUM_ALLOWED requests match every session against
-	 * Authenticated Users.
+	 * MAXIMUM_ALLOWED requests that are not strict match every session
+	 * against Authenticated Users and do not count ACEs for the
+	 * caller's groups. Strict ones match SIDs as explicit requests do.
 	 */
-	bool authusers = authenticated || maximal;
+	bool open_max = maximal && !strict;
+	bool authusers = authenticated || open_max;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1557,13 +1565,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		/*
 		 * An empty (present, zero-ACE) DACL grants no access to
 		 * anyone except the object owner's implicit READ_CONTROL
-		 * and WRITE_DAC (MS-DTYP 2.4.5). Deny every other caller,
-		 * deny the owner any access beyond those two bits, and do
-		 * not let trailing bytes after a zero-ACE DACL become an
-		 * implicit grant.
+		 * and WRITE_DAC (MS-DTYP 2.5.3.2), besides what the parent
+		 * grants. Deny every other right, and do not let trailing
+		 * bytes after a zero-ACE DACL become an implicit grant.
 		 */
 		if (is_owner)
 			allowed = READ_CONTROL | WRITE_DAC;
+		if (!strict)
+			allowed |= smb_parent_derived_rights(conn, path, uid,
+							     authenticated,
+							     requested & ~allowed);
 		if (maximal)
 			requested |= allowed;
 		if (!allowed || requested & ~allowed)
@@ -1576,9 +1587,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	/*
 	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2). access_bits collects
 	 * the result for the ACEs that apply to the caller, without its groups
-	 * for MAXIMUM_ALLOWED. grp_granted collects what ACEs for the caller's
-	 * groups, or OWNER RIGHTS for the owner, grant. It is used when the
-	 * SID lookup and POSIX ACL fallback below do not decide.
+	 * for a MAXIMUM_ALLOWED request that is not strict. grp_granted
+	 * collects what ACEs for the caller's groups, or OWNER RIGHTS for the
+	 * owner, grant. It is used when the SID lookup and POSIX ACL fallback
+	 * below do not decide.
 	 */
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = pdacl_size - sizeof(struct smb_acl);
@@ -1623,8 +1635,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     compare_sids(&sid_owner_rights, &ace->sid) &&
 		     !member))
 			goto next_ace;
-		/* An explicit request counts only SIDs that match exactly */
-		if (!maximal && !member &&
+		/* Other requests count only SIDs that match exactly */
+		if (!open_max && !member &&
 		    !smb_sid_equal(&sid, &ace->sid) &&
 		    !smb_sid_equal(&sid_everyone, &ace->sid) &&
 		    !(authusers && smb_sid_equal(&sid_authusers, &ace->sid)) &&
@@ -1634,10 +1646,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		bits = le32_to_cpu(ace->access_req);
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
+			grp_ace |= counted;
 			if (counted)
 				grp_allowed |= bits;
-			/* MAXIMUM_ALLOWED takes no group grants */
-			if (maximal && member)
+			/* An open's MAXIMUM_ALLOWED takes no group grants */
+			if (open_max && member)
 				break;
 			if (counted)
 				grp_granted |= bits;
@@ -1645,10 +1658,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			break;
 		case ACCESS_DENIED_ACE_TYPE:
 		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
+			grp_ace |= counted;
 			if (counted)
 				grp_denied |= ~grp_allowed & bits;
-			/* MAXIMUM_ALLOWED takes no group denials either */
-			if (!(maximal && member))
+			/* nor group denials */
+			if (!(open_max && member))
 				denied |= ~access_bits & bits;
 			break;
 		}
@@ -1663,6 +1677,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
 		access_bits &= ~denied;
+		/* An object deny ACE could deny the parent's rights */
+		if (!open_max && obj_deny)
+			access_bits = 0;
 		if ((raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
 		    S_ISREG(d_inode(path->dentry)->i_mode) &&
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
@@ -1715,7 +1732,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 		posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);
-		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace) {
+		/*
+		 * For a strict MAXIMUM_ALLOWED request, ACEs for the caller's
+		 * groups or OWNER RIGHTS decide before the POSIX ACL, unless
+		 * the DACL has an object deny ACE, which ksmbd does not parse.
+		 */
+		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace &&
+		    !(strict && maximal && grp_ace && !obj_deny)) {
 			unsigned int id = -1;
 
 			pa_entry = posix_acls->a_entries;
@@ -1767,6 +1790,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			 */
 			if (!obj_deny)
 				allowed |= grp_granted;
+			if (!strict)
+				allowed |= smb_parent_derived_rights(conn, path, uid,
+								     authenticated,
+								     requested & ~allowed);
 			if (maximal)
 				requested |= allowed;
 			if (!allowed || requested & ~allowed) {
@@ -1813,6 +1840,45 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 }
 EXPORT_SYMBOL_IF_KUNIT(smb_check_perm_dacl);
 
+/*
+ * Return the rights in @want that @path gets from its parent directory:
+ * DELETE if the parent's DACL grants FILE_DELETE_CHILD, and
+ * FILE_READ_ATTRIBUTES if it grants FILE_LIST_DIRECTORY
+ * (MS-FSA 2.1.5.1.2.1). A parent with no DACL, or with one that ksmbd
+ * cannot read, gives nothing. Callers pass only rights that the request
+ * names.
+ */
+static unsigned int smb_parent_derived_rights(struct ksmbd_conn *conn,
+					      const struct path *path, int uid,
+					      bool authenticated,
+					      unsigned int want)
+{
+	struct path parent = { .mnt = path->mnt };
+	__le32 granted = FILE_MAXIMAL_ACCESS_LE;
+	unsigned int rights = 0;
+	int rc;
+
+	if (!(want & (DELETE | FILE_READ_ATTRIBUTES)))
+		return 0;
+
+	/* The root of the mount, or a disconnected dentry, has no parent */
+	if (path->dentry == path->mnt->mnt_root || IS_ROOT(path->dentry))
+		return 0;
+
+	parent.dentry = dget_parent(path->dentry);
+	/* Strict, so the parent's own parent is not consulted */
+	rc = smb_check_perm_dacl(conn, &parent, &granted, 0, uid,
+				 authenticated, true);
+	dput(parent.dentry);
+	if (rc || granted == FILE_MAXIMAL_ACCESS_LE)
+		return 0;
+	if (granted & FILE_DELETE_CHILD_LE)
+		rights |= DELETE;
+	if (granted & FILE_LIST_DIRECTORY_LE)
+		rights |= FILE_READ_ATTRIBUTES;
+	return rights & want;
+}
+
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write, bool posix_open,
-- 
2.47.3

