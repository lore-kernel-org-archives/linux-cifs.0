Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818699;
	b=yF3UvjuBYJVNSQWUspX+V1zKF/02/wzXFvgjm9vsVP7MDBAZkdnm1LQAaR9T4q/G+ZCx
	 HeCL0cCsDejwXxv6suMCSKZ/AIXQa+gzK+1D7ajxgMUpInIo+Tw+wkcHa8pk2P9PjVTf6
	 JeGQVbnVbXuVDYRtIvGY5WAda47TipgNB+PGqARInUPO2uScZ8YAQ4taGrCXot/Mxlk8Q
	 7vDmXzADpFRTpraVuiTD8gxOntKMdFu4kQPb/1Wz4zVo3vg+2uu6gOzlVBACz+A2Z1gYa
	 xQ36bwbPh12bqaw7dRGUBvAwfOkwIya82i++LDeIlnEAmUBLgQH/SSHmAzrSZTui7mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818699;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PDnB87zqXJgVJsuOvrO1H7iIUHbjGjYAfANJC/HOKlc=;
	b=UdPofWOlrlF+3W38pJ+MHWUIHVRNgsHGlXg1BznGTID5gv3jwoMe3bCwLDdhr6EwQJ0X
	 gsKk8YXZ/m2BF8V/oXz5/ztB1xfYFLdHRi3bnJrpBF09ZBGzKs/ZS4OoMgso2+erff5Eh
	 EuZtEuwAAL5Ad2cUpB6zQRo1SZW0LhYHvdamonR0xMMxo20L10ijjjBP5TALOg5MpktWP
	 u0KUXhg0mZIDXPdPoFCFLTHdeAsB8vMi9GunzoivQka7GCJ1LU/nswC+4NsUlHcvKzYdV
	 xg/DmaApbOLCzyZUtU3bzPJeOP9aJ6nY/zD12aQ6mSDDlV6Atjn18HfUHEOzYCQb9GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Nh+1EBrw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0bB8rbN5;
	arc=none smtp.remote-ip=103.168.172.148
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0D606D817
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 18:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBF0D606D817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Nh+1EBrw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=0bB8rbN5
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 01670EC24F2
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 13:58:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 04 Nov 2026 13:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793818697; x=1793905097; bh=PDnB87zqXJgVJsuOvrO1H
	7iIUHbjGjYAfANJC/HOKlc=; b=Nh+1EBrwMhUWUB5s8dpl3hJetC3N/ywoAbl6z
	HQtDYUel0g0lzjRuh2FlI3ozSajaNG0Ur68zeAF4FD/lkZVSmAwtth4GjnC4kIJ0
	fYZFUs0gagsKhTcC0ut6gvyJw/H/DWrm7WEqrWOSBAXA+71nNWD2z7ZYmnVD3gmm
	Qe15BSK8Y/cqvznRa4GbvnYAxNumZEgsZgoRj9ulnXS9zi3rGPZyer1eBbbfSPb/
	Ob+f8avnOKcwoQgwTVHxhujRDJUZipomkbsb8mMnG1+vqGTNj5SqISjRF8hvYEHL
	181qsNWwZ0vl5iRdJKj15xVydeFzZJwOp5Zm4ewIR+IhWLIow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793818697; x=1793905097; bh=PDnB87zqXJgVJsuOvrO1H7iIUHbjGjYAfAN
	JC/HOKlc=; b=0bB8rbN5+N3eO8saiK7kT2zzbfm0unFXD9/tajbF+nm+b6B5qDy
	BlWrRdBdfoqtO40Mta/uqXF/C0ohhcoTUjgUa7Zm2C0Y/kKJ4hlWjy7dCadcx4nE
	Z06Q+uRCfEaQ2YUGlyB7LAaOGeGvOC2FKogr/9nqpDG1YRn8Qd0C+P9A+M31UjK9
	iBf4STJt8JU5ikpxrp6t+oD0hqwDhFruLSYdHSI6hGAXQAAT4bcgbixJfTNcZuDV
	O4SobTEk83JW0mXcvsq7NMmyF7J+Uw/7YVR0O63HpAq4bVd7DAk12grAUVgTVBqc
	jpUGVE9scfICDQhorKKQ6jq3sGwbwd+8pBw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793818697; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:p+xSMPBYv5BPknbuDNsOkTYbL449/I8GM6QdfqbKwIzf4n+
	XemxBPSHFPq//A2oPZsa5zrzcS99T4mGvDa3uAbN3D4KS/juBMT9fKP5ikUsxR9z
	mRryt8q4obzIk5wWUBTk8KbIg63A9tezFzdLkf1V4DvL9xris/ufNMJFHl5L9xwT
	GdIS5oE9vZ39q2Fptk9dr/Am6fO93Gxj5n7ipQXq6I/ePddp9Bcsq24wxumqiS+q
	p/VAKkXjXhsObwti8R1SVoMDKV55eA4DbGDQB9Jpnm0yRzVEazLqyx2OI928YGe4
	LP2ZoEYkcCPlaqDo91vg9bV3w6yJnnq/y3ymbfw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:GOQc9oEL9CRL4VZ1M+IEcRc2iyWqZPEnulBWE/pSN7s=:ZV9mob9oFvahRr0psn0UmQT1ggxEltVrOymnMfkUmU0=;
X-ME-Sender: <xms:SYDraod1MJb-WaL8UGdgRUAxJjyaXhZfYhOBIMOZisEcJpCajISjyg>
    <xme:SYDramw7eV7M6T6hdC2wr1OXWMH66rtISbfrGt_DWTQJv29HV9JEZEVkjvTu3I1yS
    IMDcqGwS0IH617Zm7p3KVvZE72pIdP5_VARFHibxpYhw8GTfzX-hhDc>
X-ME-Received: <xmr:SYDrat-NNwjf71D4F0U5ecEFdH4UW095_LdJ_fi28bSpRuOyKD-VAr1_ZY_Gu6ka>
X-ME-Proxy-Cause: dmFkZTF6DLgba7+YTaPdYRXZytzB5/UWwePilYiC8EG2tBskM+S36PTfQVDlbsS1tAymfA
    Fsr0J/TuxlZyvPEL+/BBoEvz/JkiofCUgnzIo0wimp1j5J6GHrMaBW0msUdeB493DayJ10
    n6QXoxADZPIs11g2m19IexIBbummS26Iakx+FRSSsXUJlieuPL+8c1onlVSm7msmHQ+JSO
    0x5Y6eGk9MJBFgoHATJ1QKjyGM044wc2rIe35Dlg728F79bovt7hQbFQlx3WWN+Ysj52kD
    QnMCjREMUtYBippGsR+n/KNq7vNjSpVGgaicg6xMfRccJIbpXGeO4gBpMME1SKC4VNeIOP
    kirohG/4gR1NcKN0/ePOuP2bypuszCOBG7sckv5PIPVZ5BXPwPAZDkLRTPpkRtrpTROcLg
    GHVLJdObEDHkmzsZuAxEHsKdUzADNBrjKmXGyn38w02Q6nlHFWbuwTI9Ampm+bBMtuT9M0
    pv3TD6unNn/+pFAzHD5Ky4VYBff2n2ylenUhbS2Q9jZm0Mg5bfOnRBEXs9f9luPsxNP/ka
    0st/xKjPcI9cKBgKiFsm+cVxdwtZewQg7HV+ejz2mbUX6CS0JO8h91KXEcrj5Lz2HbTveD
    XfTXMXCb5w/3GZticqTy+dJWBUJkbuRq4aeIpxW0aXQi+h7mcPdGD6NIALWw
X-ME-Proxy: <xmx:SYDrakzDJsUPrQFn9wuVXaSzdPYlghbJI5ch7bCUwXrcTw4R2MuspA>
    <xmx:SYDralpHJRPKMbOh_zueGNaoKN0lpXeC-PmnXP3FUYM4EtMHi8HpHw>
    <xmx:SYDratq09FDLBb7VhkWaD69wg9goq8Z8xkdIjLwBGY-JRo11XT5RuQ>
    <xmx:SYDratBFZatfg3JaZF-upVkVD2Z1_Uf7Y_U2QQv3fxb7_wmOjuP9Zw>
    <xmx:SYDraudfZ2eXDFh38V7f6YVHOkrSdZdPmTobARQYXASerGW7R4OEOuLK>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 13:58:16 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v4] ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
Date: Wed,  4 Nov 2026 12:58:04 -0600
Message-ID: <20261104185804.195058-1-icb@fastmail.org>
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

smb_check_perm_dacl() does not match ACEs for the caller's Unix
groups and refuses an owner named only by OWNER RIGHTS. These callers
cannot use rights the DACL grants them under MS-DTYP 2.5.3.2.

Match Unix group SIDs (S-1-22-2) against the caller's credentials. Use
the ordered DACL result when the existing SID lookup and POSIX ACL
fallback do not decide access. In that result, deny ACEs for the
caller's groups limit what it grants, also for MAXIMUM_ALLOWED. Count
only the exact OWNER RIGHTS SID in that result, since compare_sids()
also matches shorter and longer SIDs, and return only file access
rights. Preserve the refusal for non-inherit-only object deny ACEs,
which ksmbd does not parse.

MAXIMUM_ALLOWED still excludes group allow ACEs. Including them
requires corresponding changes in smb2_open() to avoid breaking
existing opens. An open relying on group grants can therefore still
fail when it requests a maximal access reply. For the owner, that
reply leaves out the rights of its groups.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Since v3
    - Remove the redundant braces around the ordered DACL walk (Namjae
      Jeon [3]).
    - Handle MAXIMUM_ALLOWED after the walk in one branch, drop the
      redundant in_group flag, use maximal throughout and rename the
      group masks.
    - Note that compare_sids() also matches shorter SIDs, and reword the
      comments.
    
    Since v2
    - Honor deny ACEs for the caller's groups in the new MAXIMUM_ALLOWED
      fallback (Namjae Jeon [2]).
    - Count only the exact OWNER RIGHTS SID in the ordered result and
      return only file access rights.
    - Keep the existing refusal for non-inherit-only object deny ACEs.
    
    Since v1
    - Clear access_bits for explicit requests, preserving refusals for
      ACE types the existing lookup does not handle (Sashiko [1]).
    
    The hide unreadable listing and the app instance check use the same
    answer and change with it.
    
    Tested on ksmbd-for-next e49296d51ccb with KASAN, with no reports or
    warnings. A reproducer is available on request.
    
    v3: https://lore.kernel.org/linux-cifs/20261103150458.11591-1-icb@fastmail.org/
    v2: https://lore.kernel.org/linux-cifs/20261102200353.884509-1-icb@fastmail.org/
    v1: https://lore.kernel.org/linux-cifs/20261102061537.830714-3-icb@fastmail.org/
    [1] https://sashiko.dev/#/patchset/20261102061537.830714-1-icb%40fastmail.org
    [2] https://lore.kernel.org/linux-cifs/CAKYAXd-s-g2V4LNY8e5SsH=+0r3qLY+AeOa5Lp9K0T5p_tnA8A@mail.gmail.com/
    [3] https://lore.kernel.org/linux-cifs/CAKYAXd9xNLn1Nk1QzD_Kep1TcgJmGNsT+UTg6Ed0DjjmRRW4+Q@mail.gmail.com/
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 162 +++++++++++++++++++++++++++++------------
 1 file changed, 117 insertions(+), 45 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index ab76c5c9e0ea..32feafe9f73b 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1459,6 +1459,35 @@ bool smb_inherit_flags(int flags, bool is_dir)
 	return false;
 }
 
+/* Whether the caller's credentials hold the group of an S-1-22-2-<gid> SID */
+static bool smb_sid_in_group(const struct smb_sid *sid)
+{
+	gid_t gid;
+
+	if (sid->num_subauth != sid_unix_groups.num_subauth + 1 ||
+	    compare_sids(sid, &sid_unix_groups))
+		return false;
+	gid = le32_to_cpu(sid->sub_auth[sid->num_subauth - 1]);
+	/*
+	 * ksmbd_override_fsids() builds the caller's credentials with
+	 * make_kgid(&init_user_ns, ...), so the group membership test must
+	 * compare in that space. Applying the mount idmap here (as when
+	 * resolving a SID to an on-disk gid) would mismatch on idmapped
+	 * mounts.
+	 */
+	return in_group_p(make_kgid(&init_user_ns, gid));
+}
+
+/*
+ * compare_sids() compares only the sub-authorities both SIDs have, so it
+ * also matches a shorter or longer SID, such as S-1-3 or S-1-3-4-777
+ */
+static bool smb_sid_is_owner_rights(const struct smb_sid *sid)
+{
+	return sid->num_subauth == sid_owner_rights.num_subauth &&
+	       !compare_sids(sid, &sid_owner_rights);
+}
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool strict)
@@ -1475,13 +1504,15 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int granted = requested;
 	struct smb_ace *ace;
 	int i, found = 0;
-	unsigned int access_bits = 0, denied = 0;
+	unsigned int access_bits = 0, denied = 0, grp_granted = 0;
+	unsigned int grp_allowed = 0, grp_denied = 0, bits;
 	struct smb_ace *others_ace = NULL;
-	bool or_ace = false;
+	bool or_ace = false, obj_deny = false, member, counted;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
+	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1522,7 +1553,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 */
 		if (is_owner)
 			allowed = READ_CONTROL | WRITE_DAC;
-		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+		if (maximal)
 			requested |= allowed;
 		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
@@ -1531,53 +1562,83 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		goto err_out;
 	}
 
-	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
-		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = pdacl_size - sizeof(struct smb_acl);
-		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (aces_size < offsetof(struct smb_ace, sid) +
-			    CIFS_SID_BASE_SIZE)
-				break;
-			ace_size = le16_to_cpu(ace->size);
-			if (ace_size > aces_size ||
-			    ace_size < offsetof(struct smb_ace, sid) +
-				       CIFS_SID_BASE_SIZE)
-				break;
-			aces_size -= ace_size;
+	/*
+	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2). access_bits collects
+	 * the MAXIMUM_ALLOWED result. grp_granted collects what ACEs for the
+	 * caller's groups, or OWNER RIGHTS for the owner, grant. It is used
+	 * when the SID lookup and POSIX ACL fallback below do not decide.
+	 */
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	aces_size = pdacl_size - sizeof(struct smb_acl);
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
+		if (aces_size < offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE)
+			break;
+		ace_size = le16_to_cpu(ace->size);
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE)
+			break;
+		aces_size -= ace_size;
 
-			if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-			    ace_size < offsetof(struct smb_ace, sid) +
-				      CIFS_SID_BASE_SIZE +
-				      sizeof(__le32) * ace->sid.num_subauth)
-				break;
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			      CIFS_SID_BASE_SIZE +
+			      sizeof(__le32) * ace->sid.num_subauth)
+			break;
 
-			if (!compare_sids(&sid_owner_rights, &ace->sid)) {
-				owner_rights = true;
-				if (!is_owner)
-					goto next_ace;
-			}
+		if ((ace->type == ACCESS_DENIED_OBJECT_ACE_TYPE ||
+		     ace->type == ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE) &&
+		    !(ace->flags & INHERIT_ONLY_ACE))
+			obj_deny = true;
 
-			if (ace->flags & INHERIT_ONLY_ACE ||
-			    (compare_sids(&sid, &ace->sid) &&
-			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
-			     compare_sids(&sid_everyone, &ace->sid) &&
-			     compare_sids(&sid_authusers, &ace->sid) &&
-			     compare_sids(&sid_owner_rights, &ace->sid)))
+		if (!compare_sids(&sid_owner_rights, &ace->sid)) {
+			owner_rights = true;
+			if (!is_owner)
 				goto next_ace;
+		}
 
-			switch (ace->type) {
-			case ACCESS_ALLOWED_ACE_TYPE:
-				access_bits |= le32_to_cpu(ace->access_req);
-				break;
-			case ACCESS_DENIED_ACE_TYPE:
-			case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-				denied |= ~access_bits &
-					le32_to_cpu(ace->access_req);
+		member = smb_sid_in_group(&ace->sid);
+		/* The grp_ masks count groups and OWNER RIGHTS only */
+		counted = member ||
+			  (is_owner && smb_sid_is_owner_rights(&ace->sid));
+		if (ace->flags & INHERIT_ONLY_ACE ||
+		    (compare_sids(&sid, &ace->sid) &&
+		     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
+		     compare_sids(&sid_everyone, &ace->sid) &&
+		     compare_sids(&sid_authusers, &ace->sid) &&
+		     compare_sids(&sid_owner_rights, &ace->sid) &&
+		     !member))
+			goto next_ace;
+
+		bits = le32_to_cpu(ace->access_req);
+		switch (ace->type) {
+		case ACCESS_ALLOWED_ACE_TYPE:
+			if (counted)
+				grp_allowed |= bits;
+			/* MAXIMUM_ALLOWED takes no group grants */
+			if (maximal && member)
 				break;
-			}
-next_ace:
-			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
+			if (counted)
+				grp_granted |= bits;
+			access_bits |= bits;
+			break;
+		case ACCESS_DENIED_ACE_TYPE:
+		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
+			if (counted)
+				grp_denied |= ~grp_allowed & bits;
+			/* access_bits takes no group denials either */
+			if (!member)
+				denied |= ~access_bits & bits;
+			break;
 		}
+next_ace:
+		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
+	}
+
+	/* Keep only file rights, not MAXIMUM_ALLOWED or generic bits */
+	grp_granted &= GENERIC_ALL_FLAGS & ~grp_denied;
+	if (maximal) {
 		if (is_owner && !owner_rights)
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
@@ -1587,6 +1648,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
 			access_bits |= FILE_EXECUTE;
 		granted = requested | access_bits;
+	} else {
+		/* An explicit request uses only grp_granted and obj_deny */
+		access_bits = 0;
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
@@ -1668,7 +1732,15 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			 */
 			if (is_owner && !or_ace)
 				allowed = READ_CONTROL | WRITE_DAC;
-			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			/*
+			 * Add what ACEs for the caller's groups, or OWNER
+			 * RIGHTS for the owner, grant in DACL order, unless an
+			 * object deny ACE, which ksmbd does not parse, could
+			 * apply.
+			 */
+			if (!obj_deny)
+				allowed |= grp_granted;
+			if (maximal)
 				requested |= allowed;
 			if (!allowed || requested & ~allowed) {
 				ksmbd_debug(SMB, "Can't find corresponding sid\n");
@@ -1680,7 +1752,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		}
 	}
 
-	if (!(*pdaccess & FILE_MAXIMAL_ACCESS_LE)) {
+	if (!maximal) {
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
 			access_bits = le32_to_cpu(ace->access_req);

base-commit: e49296d51ccbf2ad0ed0484db1382f1d7217bd6e
-- 
2.47.3

