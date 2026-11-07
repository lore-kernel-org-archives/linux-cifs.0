Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794032575;
	b=XiSFbt3D9J9QiMpcov+uRrwRXeiN5ji2+GtP93GdLxGCNpOKWsZ3giUDPgu1F7i8D3rF
	 QSUqFVnjtP87md9hcGh3T2vx6MdpeqSmZrSSSuhc+AGPBM2zPHxSe2gUhp45yvmEA3+5R
	 GFWvW12+xEHVLk8Tl3pjkT4ij0x/WkL7ia/zv8rC8BQoG+yyo0icMQoxyzM9kWlSZdYZ+
	 YVDlfU9PCAPIsQyebWAIANhPuFQYiUM8ndfVYlIo66IoR/cehGMZF9/dDJCoBEnqNgqoY
	 y6sM46x+CEdPUjK+Hvhi+4p4PXsYfIOIFUeEKKu+4hxUMpb+BjdlV14tIbjZ64mfLxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794032575;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=L5ENHe2x5phfWJBzadltU8vxVUhyMZni2kzieja6K0o=;
	b=3+oIIYsuckCRLGZkqYdYFII832wb5Ddbv2mN4HQgXr2uf8hs+2VrQAQ/Gn7eUsCdXjEo
	 5oMWKQDEu2NWaxG0v0J9LeplNZ7wgX9Yqql6xhMA7qhv0NZMLaBEuX+Z4zq/2zOSV5QqK
	 9rTkDU0XjFVdgohuZoxZYW1EFLtHQxnRPdDTsOneBZQyCz9QSEPK7S9BGrldMbHUbIp5s
	 5SbwyTuQNd6k46EzgW4/O1aBLA3yorvomMC9o5tiouYvktkiquk7hAxL6bCm4UxoaB85g
	 kvCQYpndaB1KFUdfbBBemCvuGfYoeLvyLh/v/a4X3qqNA6BXxZ0bTqridAdqeV7y8Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=y1KHvAX5;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=o9PTY1pG;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C08606A33E
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 06:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83C08606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=y1KHvAX5;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=o9PTY1pG
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CCC337A017E
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 01:22:53 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 07 Nov 2026 01:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794032573; x=
	1794118973; bh=L5ENHe2x5phfWJBzadltU8vxVUhyMZni2kzieja6K0o=; b=y
	1KHvAX5pLLcE+urVuVdWmm8I5CfVrWq1sO4X7iR81M/EXqaPj6DfPto2YPCKtEf5
	FLd8c+8YFD/apfUVujcL1wCyOildeeH2IN+zCO7iguLxeJ5w+yZ+TqxMkE36FGu1
	kRuV/ABK7m0r1gjTfSnrjYy6XHV+JQqfF1Fd+oh50T7EsbHBhWWHWtzPRRGpA3I+
	XxYasM04svxkBGlujPffO35/rSDRpeZT8OK1HDkaaRGCeF+sJLQ7PGsZDF8ZiGee
	sVeh3wW4u3BptgbT1lsGoK8fJiVu2dTKvWSvSl6lCPKAWl5NTmmU3A9SHocep8Ff
	2IFs5uLZdm70r2v5fDnQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794032573; x=1794118973; bh=L
	5ENHe2x5phfWJBzadltU8vxVUhyMZni2kzieja6K0o=; b=o9PTY1pG4G0+MQ8Qq
	yonNx3F3cwNzlB+VDCieUknGX7FQ13bh31VTtVycW2ubkPXkNmwVEIKI0a/tl5ow
	JJHoijvnwa1ArS6TpxYffhkbJtGD/7qN87RN4s64mPWU64cCwjSsDUETR4TQw+J8
	U9QLwdF3Og//cClEiuUMHNGBO59cb1k3NiEpWwC8X5Y1/ufukk5P6UPwmFOukoq9
	qTZg2gSP3jxdHt3Y7QxvmpLw5UTPiriekmMSq+aJSm/5Zfawk3QzJjy31/h8PXnc
	guM5yH6udSWsM53hPME4hoC9liMKZkNGoOKV4gMk3uIJZJYsAfnIqDB54MDYce6W
	Id9ZQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794032573; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:vntzNnwW5xWM8xZcZTW4CWpApqS1wzt6ghLx1wNg8/FmJJs
	zLDYSq+i46/Hp/SN5YcbXtZBa6FDKL22HmRunGzSK5z83DMfziE89rWw9T2lJ56M
	BtvpnFeKaOeIHDNAS6iM0J8940ja6uL8Xv4JBl6TOTu97oeeAm40s6pDBDR16xpK
	CRw9NFnJ3Y9o2Airenc2gdHFAGIcTHVUHa4nnmPWQKynsd39GrumlOH2Vtpvd09D
	j/zwSCcgSZU5KHyPCsnbqw329Oo5uIe6JiVxI1Mif8fbA4uiB2PlySCnpYEEYyof
	/fEXW6e4FepBbxG+7i2dsEbrCLMbRbRRjTWDi8w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Kw4O3go4PabEeRmN96kTAnz/5Fe9hxGHeKALVuol+Uo=:LUC04pwB2VujeUjxktsULFexj0ZW+Ah9fCtKnmhKFOY=;
X-ME-Sender: <xms:vMPuarqrw9kjVaRNWLW3LQCNmMjFP7cpZWEIiDIPuHofwvCLJUqiKw>
    <xme:vMPuaho4yQDkBUtoCzFE7z1BboyUm4TbfUiPL2JMzpZHSzAn7L6JsCKzMURe4sTO4
    gfVrUKcuu4wCqql8lul5_a6m7aQu_c5kCDIjuwYfdqpD_pMWmhuKNWHHg>
X-ME-Received: <xmr:vMPuaqaPz-SG2XJm5Yjtc5KazOtaj-fZn99IQZkXQmjR056EI6VoKFA2pSqVXnEF>
X-ME-Proxy-Cause: dmFkZTF+ZYfouUF5xRJs7vVxvG7U3oNeEMUxMjRA+2f1TMICIIFaxboN5AN93l7zFUbVay
    4lqqBbQdBaDa9UXFGuopVH46zxkc7rywOx8pkRKsA2NbBaWn9O82fPndHDyHwyEC4pp5rN
    9BCrOAQXGpn2sAYDnpRorXWGg4lFTjKeTQru2rdHdZkAJpAT/N77oeX66OMNpMh7B/NaDw
    2ujGLdjrqc9ggFS1ZxFkQvpBCMuj7dS9mFEenLsjQtqmnCEP5/14KFGgfOt7pydS9YETj6
    EXa2jYk5wyqxm7V+Sr+J4mR8e4ie6yU7lpIejJ1ox98x8iZe9PpiqvQXYfxUlmJVdqerkX
    fjdf5gkTbBiIZ/az3b87+QvnGkRTPGtDXqsRQ6MaDS2oNqT/b/CPfmWbAWcvTsRiTLJ1EL
    eUy8fwvXtA77ZEDX5LlQaLisvvD9MUSH5Ji6qiyLi8hTUutm5oAL3x7b78ZikdpQwUPgE4
    hHUnAov77yaGRoAEgenoOJ6ZqazKyf/g/XgTmwgwhmFduCaMcNUpWs/z9NzMz7K81lod1/
    2yZQOKzo9qfaNQl1aPocVRrOMgkWxBbBVv9EsIY1qjNKCj7dET60Lx5vVzNFeNeBXeKRAs
    jV0a6c69WbDx1ipI7t1E2G5LmKiE9XCCV59znOT/kRlSw+FhsECne+NB8tvA
X-ME-Proxy: <xmx:vMPuav8tK3t5tNTORaWWH54uSsRY4TDt1O-MOowLgjez8SS54MNAOg>
    <xmx:vMPuaomE50xqEMsHDymRg4KqL7u3TTjgzvx_lPvb0I9jv9W5WXA3QQ>
    <xmx:vMPuasw5f8kJpzG-GPu6brjU3ipDeCy0-JcOz-b8XAwiz-ZwcLx8sQ>
    <xmx:vMPuaq4TqcoYRlLNRoYIb6GIWRkKF47y065Jib1GV2Q6tKdiDNQ0fw>
    <xmx:vcPuauRbcdnD7ANdios5J1FvyFRfHfOzH1hVxkenxVNGOL89TTQHwT2o>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 01:22:52 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES
Date: Sat,  7 Nov 2026 00:22:33 -0600
Message-ID: <20261107062233.1579198-3-icb@fastmail.org>
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

 fs/smb/server/smbacl.c | 82 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f773ab8efb3f..89a03cbbdbb9 100644
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
@@ -1520,10 +1525,12 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1557,13 +1564,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1623,8 +1633,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1636,8 +1646,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		case ACCESS_ALLOWED_ACE_TYPE:
 			if (counted)
 				grp_allowed |= bits;
-			/* MAXIMUM_ALLOWED takes no group grants */
-			if (maximal && member)
+			/* An open's MAXIMUM_ALLOWED takes no group grants */
+			if (open_max && member)
 				break;
 			if (counted)
 				grp_granted |= bits;
@@ -1647,8 +1657,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
 			if (counted)
 				grp_denied |= ~grp_allowed & bits;
-			/* MAXIMUM_ALLOWED takes no group denials either */
-			if (!(maximal && member))
+			/* nor group denials */
+			if (!(open_max && member))
 				denied |= ~access_bits & bits;
 			break;
 		}
@@ -1663,6 +1673,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
 		access_bits &= ~denied;
+		/* An object deny ACE could deny the parent's rights */
+		if (!open_max && obj_deny)
+			access_bits = 0;
 		if ((raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
 		    S_ISREG(d_inode(path->dentry)->i_mode) &&
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
@@ -1767,6 +1780,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1813,6 +1830,45 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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

