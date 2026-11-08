Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794162032;
	b=ifZTd5L5Lv1xn0w+K7HMh1xa0sAL4p8fqX6ssY13W4NMF1k+38+B6uxeCAAqG0m2rQw6
	 h1D6PViE5mBiw7ANOwBU705oqUlPDUj/INX5ROHxuTqfqFdUMjEqvkq3tztvlimEQOlPl
	 jhq8D4DrvVaD67RfboTjnXzyvI7iKa/j9X5ArdsQsua6frP51aUNU/+jIdQDNFmelYs1u
	 HUmlrHOq7E23iNbmQQP4o/8I+YGRzcxQiUms5Qn7gO+gagF3ybyaFcadpZGf2/QXdcJ6C
	 onAaeXCCYNiJrO0FxLuYrHco7uZI+r+GU3dEbWi2ioFrt8weqk15dM9+SyE5FuMylSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162032;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=aKjS59kYPvvrG04DHR/tX4+W2JMeIyYp/panggA/AqM=;
	b=UDxR36ruGGuNIb6t/sLKuu6aIXPeHkQ52GuT4bg+5KwmrSPB5Ht3trWAw2Ra1TDkUbTn
	 wg3cR1Ryuh9wvxib+t659QQeZlLB3Q3QxXFkYklFfgGRR5jyHC1LnNTZfBGlNBHpWdWqZ
	 lF8v5RIzF2wlkQI1H0PCNGoni1YLlLfyzYVzn3UGNoZAmW8Pllb52OOEQSJvFbn+rK4sD
	 h9ir1+nntssv0N8YISY6qzjg+2eEM1sRTrl/eM3t2+QIsI87LioBApp/mr9yCcTvQkuDM
	 DV9M6nUBne+mbMvZOvzv2BIJ16WGH9tY2LJrlY65qbImtlECfqkPIqvXiJT1JezKUCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=BYwgChLf;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EVMsFvYQ;
	arc=none smtp.remote-ip=202.12.124.157
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBEE606A326
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 18:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EBEE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=BYwgChLf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EVMsFvYQ
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 99A237A00E0
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 13:20:30 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 08 Nov 2026 13:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794162029; x=
	1794248429; bh=aKjS59kYPvvrG04DHR/tX4+W2JMeIyYp/panggA/AqM=; b=B
	YwgChLfDbpqrRwctJVvnbsTQ2JXr843sX86ngFaQPjzKA3RnEX0AXKFKruAS48Re
	oyB2zX4OnHIjpsO7n4Lv5WsZIrrmKIghwRcGs0NeUQwKgSRAtbsB6aNEg15yy3r0
	a2T+E93AbWWT+8xE+5waRBlclzCKX3eE0BtGL+VTpp3JRkbhJg9q5nnw9bqMrCX5
	6UYOxd8vXh5YD6WLGJF6R005yWQr1EO3ZqEmmg5YP5VRwjb4wT7f3imzavWCiPVS
	jeKH1zlNItAEM8RsRREeovb8qXK47U46XVF1lbIjdd9DhZ+1gDnmD1dXaD1Z1Xdl
	Bp5gvsmXh/Dq6alx0cR1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794162029; x=1794248429; bh=a
	KjS59kYPvvrG04DHR/tX4+W2JMeIyYp/panggA/AqM=; b=EVMsFvYQzUMPJmHc9
	5ZnOLFeH4ZHur6Ek2s0Mw6x5Mwg1MyxMQ1ncyj56efatrUeAt/4szwvcPPq85hcv
	T6JKLG7sqyKFDZCNO9ueYbXj2379E+Y22qk546WH+BA4HHzcvdgQgXXgQ1TlnDoA
	bGQ+X/rjJ9cnSX11krahiuZPyQqYACSV0LqdP5KVnmtzi9FwKgnmlvzjJMUsIMPh
	Jfau6khezBHBLr6pUAEmZRJhjS+3eROPs+HyI82HXA3dcMEbGr5ACNsTb4dXaEan
	4OSqgOaBHrUQGclei/Lf+PniWaByhKK70RFiKDgkxRiCp19QbkiMNxNb+12WV/Lm
	haEyA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794162029; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:zYxJn6oSijKwgzNKm3jvejEyw6EC0OnTRcONlbyFEPmci0p
	fpIVmNHnindl7HuwRYJcGe7jgTql8aerUzSQStJ5sAPNhIlWdGK7ll34DypSpJyy
	WD1lazKN95mznWnsnLFqhwmKdqJsw6LN0RIRnHtwNics3bdftlTp+cpmMP322nWb
	6xVWEv7lZHOJfdIkPKpOefXFhdTeWYq5cD+ZlS5Y/5I8HWqnaZ9/ABWKJOv0B9OE
	gecNkxweSMs2gbJf+nRWp/bgJsrcbgXt4tl0AiX/Nt+AJ3XUB+1uzzsrtZULtHje
	ltK/Sbk+RWoiL0P9aj2zuio/zIc2NUndxjyuqxQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:kEFm+x3UboNerN0T6yzx9yLpRqZJh/w4JWGQlw8Odxw=:uH9C/9CAOyH1GlLAVj+/7VG03R5pkCI7COTggUiJqFA=;
X-ME-Sender: <xms:bb3wauKDsR69lbH1FGvssj4jRz9FnTd7P6imlfuahIxEfLBuKwxNHg>
    <xme:bb3waiIxIv-CK0blB1oJNYn91c-CDxbrd6S7PgRLp5m_c5D5E3Un6ps2vnCyo9g7F
    xO5k6MTiwoLJn5JwHFdU9GNAR7H0TvEYASAO7NwpLUZ8gxhrj0FigQ>
X-ME-Received: <xmr:bb3wag7IzqMhEtj1PC99gFJDR0JIVqSSkQLeMVgglikj8JzEetn8DmK8W_sySMmY>
X-ME-Proxy-Cause: dmFkZTFsL2SV/UfmBPGlbC6skK2LU+RDRXw1PWK/eGZQguio/heWATNaABV3YuQcJ/fozp
    a1SvEGCPDs9/W+ngH67dJ+MClSdRr06S1TKjOM2NHmvmJrJQ5NQpcnjLPT0RaapW88PiYh
    BMtBv0FQBOiFnC8/EU1DRVPhmMh6MFmCk3hcdb4oFLZ8jRnXM32vHCh6GHPFJ8I/2OC2u+
    1BYKsTrebUGb2l11LEa4vkwrEZpQJaHpornu7xWBUrdV8dLLpVdd/sG915LRVEWIMKFNF3
    lO/ie5N+6aQ0SIDOO+vgLrcYj0Htimg7gouGL0GobK3lRlunrlFPRWKb1QVxeSV3b94rsg
    2OIehN90aD769IhygtzHuA1c5RFzKcDqXWBR/SnnlYjqMC1fv+SuLU34MpiZbY1mV5mQO9
    8RDHJS6R+UhpfLMpF3P+WB3fBtJlwpqKclwLY+YVfBrLh6e/h5gRZiqe95/oJpFsxQXtei
    pL9ayCcbHz14kkEmM3RsgKYx+U7pt2Xx6Pz/qSykW2hOKcbhygqnFDr7TH3zN3/4fAQFSl
    Np8A368IrRUsRsB1MXu8oP56ZSDuJBOJARcLtCwYgDzwpG0MZ5gnHPt9APlIs0ESKHVMAp
    y1acyxZiITXOnSbm2z0dsyqq0jmxn4F7gVzG63T20gCa8/5OWNiDoifiOfsQ
X-ME-Proxy: <xmx:bb3wakeiY0pa9Uf13sUYYtG5lCrldhRzAeDH1cehW22C_rZ7c6xq6A>
    <xmx:bb3wajG3yeLee59kyaTvpjdWASgrSsEFVDRzzDYKCpVDuMtFpWY_Eg>
    <xmx:bb3walS7MTdloIlga7k5hfOo4HMrJPf6qCyJU2ekS_OsDeyShgWupg>
    <xmx:bb3wapZqajmIaCkmq54LFY1bkxoRV3a0bkAZFeRdAir9Y0HTslbaTw>
    <xmx:bb3wakzk_dGRM9gp1de5-Q7PpyP9kVlavzP-CftrpWFvlhYLmMItxdwd>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 13:20:29 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES
Date: Sun,  8 Nov 2026 12:20:11 -0600
Message-ID: <20261108182011.1888520-3-icb@fastmail.org>
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

FILE_DELETE_CHILD on a directory can grant DELETE on its children.
FILE_LIST_DIRECTORY can similarly grant FILE_READ_ATTRIBUTES. Because
ksmbd checks only the child's DACL, it can refuse rename, deletion and
attribute opens that the parent permits.

When the child does not grant an explicitly requested DELETE or
FILE_READ_ATTRIBUTES, check the parent for FILE_DELETE_CHILD or
FILE_LIST_DIRECTORY. Use exact SID matching, evaluate group allows and
denies, and exclude guest and anonymous sessions from Authenticated
Users. Fail closed on non-inherit-only object deny ACEs, missing or
unreadable parent DACLs and the mount root.

For the strict parent check, let applicable group and OWNER RIGHTS ACEs
decide before the POSIX ACL fallback. Otherwise a POSIX ACL entry can
hide a FILE_DELETE_CHILD grant.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Parent-derived rights apply only when the request names DELETE or
    FILE_READ_ATTRIBUTES. Plain MAXIMUM_ALLOWED requests and
    maximal-access replies remain unchanged. Deriving DELETE there can
    make an existing open fail when POSIX denies write access to the
    parent.
    
    An open that requests both DELETE and a maximal-access reply can
    still fail when the child DACL grants nothing. DELETE also continues
    to require POSIX read access to the child.
    
    Other permission checks retain the existing POSIX ACL precedence
    over group and OWNER RIGHTS ACEs.

 fs/smb/server/smbacl.c | 99 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 81 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 50a03101cd8a..1b387c262d59 100644
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
 	bool or_ace = false, obj_deny = false, au_ace = false, member, counted;
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
@@ -1719,10 +1736,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);
 		/*
 		 * An Authenticated Users ACE keeps the POSIX ACL from deciding,
-		 * also for sessions that it does not match.
+		 * also for sessions that it does not match. For a strict
+		 * MAXIMUM_ALLOWED request, ACEs for the caller's groups or
+		 * OWNER RIGHTS decide before the POSIX ACL, unless the DACL has
+		 * an object deny ACE, which ksmbd does not parse.
 		 */
 		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace &&
-		    !au_ace) {
+		    !au_ace && !(strict && maximal && grp_ace && !obj_deny)) {
 			unsigned int id = -1;
 
 			pa_entry = posix_acls->a_entries;
@@ -1774,6 +1794,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1820,6 +1844,45 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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

