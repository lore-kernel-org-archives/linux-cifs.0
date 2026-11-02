Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600169;
	b=hc7q9x27/gpOLe6HADE0s0LZ1ptHllO/ATZxX1ObqqNidCyeN6SQXjpTOIimK3HRZHXM
	 0uFvRtbxnXQuCyjGT990IMd+RITuLHAYvoedW9WqhukLXaD1kA32VuWJ2wdA7He6knVRD
	 ItrZUqUqb9dIqWYCWrSlHkhj2jvZWz5VJftFSj9vPfvCdnlozevTST/x/p/X/NferDiv8
	 dnuhDrIgg2De4v9swsMduPBU8uBx3mSrjFRgMaM72ioZRjegtofpJ6b9ryTrcORfUFpDx
	 u2bvjSWhPZK/pJF2sIgCcLBYPE3KZgiuFVOS6jPjbkvKCilXkomYAjj27k+/YZA+5zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600169;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=sosDF1rU/7Wp1aBkxa/i7da3zLE4z8Guhsps9jNy6UE=;
	b=MPAx8OF2YfrrUSdcUP8segkthg+WHvRbB8c65+juZZcipep31paJqAAJrERQhqIDemtz
	 UewtiGn8YJvkVemxmgPfh9RaMFbC3YsqnwNFHRC7/MkOxdLVaG2W8xjgA8+tzHVi75iSV
	 L1D6y+HfCSsYjnv1Y3HyavZXmKuigifjXXlFw55IPE91shhXE36rYWcuIyco9Nqe/hW5F
	 a9Ye7SDzm6LXUShzQXDmUNxmHn+1JXNc962uaa6lui0cmcOhxBalqFlqoJCi72rW2hRZY
	 K92XYwNIz2qZHYkWS3riNoabjNYfdNPx8IPnLQ8CReLnQ5sXRIndBr6hlETBa2j7Rvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=mJHLAsaR;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=J5nXNTVf;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA0D606A324
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 06:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFA0D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=mJHLAsaR;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=J5nXNTVf
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 5B0EE1D001EB
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 01:16:08 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 02 Nov 2026 01:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793600167; x=
	1793686567; bh=sosDF1rU/7Wp1aBkxa/i7da3zLE4z8Guhsps9jNy6UE=; b=m
	JHLAsaRisYPxEH2s9LKYj15bEExh8aF/po3ggkekxFpgASHIVp+JymuZWEUdOjCW
	Y/jbsofRXb//f3No6QwGxf1456CMqHi4zY9ujhgV94BXcc62RMysFoHiMdfr2kVU
	yaLKLhsu1VIAu9waGBgRQNfZ0RZRMy0Klc41Z2ApcxOteNWSjLnLzPSedjBvdY/q
	3mGBL4rCOJA+9B+m0v6KmaZnPMV/ebENWj2lU26kA9IJe1wPG7JgWTjeOY8kbCSW
	1FCHnVZJDxI19im9ZbbwCJHHiMRDI9+Ey/M223na7cVp/DmLEY/kckAlEyDUtBSH
	qHyuRV567RX4/CdjnISNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793600167; x=1793686567; bh=s
	osDF1rU/7Wp1aBkxa/i7da3zLE4z8Guhsps9jNy6UE=; b=J5nXNTVfPjr62uHS3
	99uGlbgII1HWvBambT4V/S0MmJOAycJEQQqkZ0m3HWlLYxqv6nkPCG4cgW1FwwOc
	YXPPYcLospyq3E2DR/thdsnjkus0q+5MIUmBwN7Vt15xC15U+zXvJc+XumX1mmPp
	e4NQzlZCCvFeLP2KBnLFsBOonte/W7BJ0Z/edclZUKkFdWnZb5SjNpTTwXEIjCZz
	NvTGz1RUVpo/mD872ZFcVwAGqqcs/2gz0xPEsvzny8C/nPpzXVHSlpEiWXH3g5x4
	FYNReggFdMxF5OCX1abrCGVSM5lJd7p7nl1P2T3xBjcEHMj5giZUPnNuppcO4JMN
	SBAQg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793600167; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:BCgw57DX4Mv6oYXdJpuN6SKvQ0TQEAgaRsbFfgHSX8bbXgW
	0qQ11IBL+vHYgv+/aR1wfxHGa/PdQ/EfDUNTdLNFY+PiVLzxsoYSaPpNDPt9gUj1
	t6LseQmUSTkesL/+cWv28l4Bkdsew4fKRJfgtYzJNlMT9mF+3HWSiChI7te1Yox8
	eeV9AV4P2JCotPv0DzMygH4s958RYq7BM+3Wafkl8HenCKDn7fgbyLvpYksiYsVg
	RhseXyExcaKJI1GuqBoqg6oLbcgWRVTDxer/w/FUiQ5tZ8tgowjO9aM0iSXiYaC3
	0ABsZ+Oy9YIxKZi336/RLRvkv1D4iCFavUFDT8w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:QMSuHKtCdVDD7Z3D31kxx7aQWAUTMQhDq7IoNB97T54=:jjPoJMKzq+Mof7kNX9Cw8xyn8kYFngqSIACAaYsxrGk=;
X-ME-Sender: <xms:pyroasCwn_FibyolRvhHPO4QGd-TrT-ai353yZifNqwFwm_xS8jHtw>
    <xme:pyroarGolkJjPR5_feP5hXUtxHS1ecQwK1e4Y8VVIjXGPCEyhsQc1ZV9JMS_EJn9v
    -qRyxG9J2h4bPtRv1GyHaf3r8Ng_XvByug5frnngTcFvYmA-bBUgo8>
X-ME-Received: <xmr:pyroakAShyogV1Z-HknPyPPQcPnUhKeoOrklOftS3epPVyKQtliC5R0aX-aI-ne3>
X-ME-Proxy-Cause: dmFkZTFGKk/WNkmd39cyK5kg4BSYFhiJducBg0q1Dxb/yw6McJPeF1k53VrIA8oFQ5r40l
    efUL3sv/8CAXT8lgRt8Iz7IjTiWfVT2ebK2NwBpvdLS8Pjffu/hHGhn+gqv/rBNe83ITNx
    isYSXwB5NsSv+wIZUQnX2Twt2UHiwYUdH9okdl+Tcoof6j+mv1wOcVdaGK1nzN5QxMHC34
    691NClNUMb4l54cR295xvnobYFBPXHIPXvC13rnrhOZuAA3zMtBCYTUL1GH1N1scDmrvCU
    NsduhI/xR7REwD8kOsukMODjx2QIz+iv5MoEUnKw+1TXCUDQretHLbYHKiCh6sRN4WCpR0
    l2FdwUALw4f65Z8PaWb9U3j5U15utHMPIUAj75ldGOjEKmJfxkjGqJHEOE7a/F7G5+g4EA
    mp5GVpgn8GQlFr6pbyDDGgncU0p3nVB5i3h0+k9wS9bWXw8LOiQsX1b6wQFUKVleWsWn7V
    G3Ir5XFQMixMM9HHJTaC74DW0VCvqDkC3obtIQSkiK6JbdzigyRSosdwpBLP2w5I/a7MXH
    IoB2utETn6oJKYqAdKfBswvA5JlZE0J4HU9iKjeV9eQOYJ+CyJdWDyX3a2AhC/RcIF6SV0
    l0xkwD5+WooUm1gJYdITpaYYJ9RRnEH1PhXCiT1O+nAe/9Qkpav6uzwqrqzw
X-ME-Proxy: <xmx:pyroaplGXfkytQfPmZCH1S2LTE1lyPAu2y7IR1xsYk5CzxweCFWFPA>
    <xmx:pyroaiNdThk30EaLGZP94VH-ALQvT-7N1LfRn2fy2u8Y2ZBus_5T0w>
    <xmx:pyroam-RUT0CHnX6xunX0zrQCQt-M_JvH7M_VNLBPPABcHDKC6N9VA>
    <xmx:pyroakEPeUxaCdhxL2zlfxsBRwLHY7tzkAvED0DOvg0jJCXxQJm_4g>
    <xmx:pyroap3M6DvtbKFOUK8pnoVLmTamtXSmne1xOhvsNktr_NSWvFSih7pB>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 01:16:06 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
Date: Mon,  2 Nov 2026 00:15:37 -0600
Message-ID: <20261102061537.830714-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102061537.830714-1-icb@fastmail.org>
References: <20261102061537.830714-1-icb@fastmail.org>
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

smb_check_perm_dacl() does not match ACEs for the caller's groups. It
also refuses an owner named only by an OWNER RIGHTS ACE, although its
MAXIMUM_ALLOWED walk already counts that ACE. These callers cannot use
rights the DACL grants them under MS-DTYP 2.5.3.2.

Run the existing ordered walk for every request and match Unix group
ACEs (S-1-22-2) against the caller's credentials. Use its result when
the existing SID lookup and POSIX ACL fallback do not decide the open.

Group ACEs remain excluded from MAXIMUM_ALLOWED. Adding them requires
corresponding changes in smb2_open(), which derives open flags and the
maximal access reply from that answer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr", for example on a
    file whose DACL only has ACEs for Unix groups (S-1-22-2) or OWNER
    RIGHTS.
    
    MAXIMUM_ALLOWED does not count groups here because smb2_open() also
    builds the open flags and the maximal access reply from that answer.
    Counting them there makes some MAXIMUM_ALLOWED opens fail that work
    today.
    
    Tested on ksmbd-for-next d13da43938d1 with KASAN, on top of the earlier
    patch of this series. Results change for members of the file's group and
    of other groups the DACL names, and for the owner. A member of a group
    that the DACL grants full access now reads the file. An owner that only
    an OWNER RIGHTS ACE names now gets what that ACE allows. Its
    MAXIMUM_ALLOWED opens, refused before, now succeed with the rights in
    the maximal access reply. DACLs with no ACE give the same results as
    before.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 55 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 83974643aa88..2abb7ead9948 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1459,6 +1459,22 @@ bool smb_inherit_flags(int flags, bool is_dir)
 	return false;
 }
 
+/* Whether the caller's credentials hold the group of an S-1-22-2-<gid> SID */
+static bool smb_sid_in_group(const struct smb_sid *sid)
+{
+	if (sid->num_subauth != 2 || compare_sids(sid, &sid_unix_groups))
+		return false;
+	/*
+	 * ksmbd_override_fsids() builds the caller's credentials with
+	 * make_kgid(&init_user_ns, ...), so the group membership test must
+	 * compare in that space.  Applying the mount idmap here (as when
+	 * resolving a SID to an on-disk gid) would mismatch on idmapped
+	 * mounts.
+	 */
+	return in_group_p(make_kgid(&init_user_ns,
+				    le32_to_cpu(sid->sub_auth[1])));
+}
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool strict)
@@ -1475,13 +1491,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int granted = requested;
 	struct smb_ace *ace;
 	int i, found = 0;
-	unsigned int access_bits = 0, denied = 0;
+	unsigned int access_bits = 0, denied = 0, ordered = 0;
 	struct smb_ace *others_ace = NULL;
-	bool or_ace = false;
+	bool or_ace = false, in_group = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
+	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
+	/* The answer to MAXIMUM_ALLOWED stays without the caller's groups */
+	bool groups = !maximal;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1522,7 +1541,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 */
 		if (is_owner)
 			allowed = READ_CONTROL | WRITE_DAC;
-		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+		if (maximal)
 			requested |= allowed;
 		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
@@ -1531,7 +1550,12 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		goto err_out;
 	}
 
-	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
+	/*
+	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2). MAXIMUM_ALLOWED takes
+	 * its result, and so does a caller that only group or OWNER RIGHTS
+	 * ACEs name.
+	 */
+	{
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1562,7 +1586,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
 			     compare_sids(&sid_everyone, &ace->sid) &&
 			     compare_sids(&sid_authusers, &ace->sid) &&
-			     compare_sids(&sid_owner_rights, &ace->sid)))
+			     compare_sids(&sid_owner_rights, &ace->sid) &&
+			     !(groups && smb_sid_in_group(&ace->sid))))
 				goto next_ace;
 
 			switch (ace->type) {
@@ -1578,15 +1603,17 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 next_ace:
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-		if (is_owner && !owner_rights)
+		ordered = access_bits & ~denied;
+		if (maximal && is_owner && !owner_rights)
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
 		access_bits &= ~denied;
-		if ((raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
+		if (maximal && (raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
 		    S_ISREG(d_inode(path->dentry)->i_mode) &&
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
 			access_bits |= FILE_EXECUTE;
-		granted = requested | access_bits;
+		if (maximal)
+			granted = requested | access_bits;
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
@@ -1615,6 +1642,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			or_ace = true;
+		if (!(ace->flags & INHERIT_ONLY_ACE) &&
+		    (smb_sid_in_group(&ace->sid) ||
+		     (is_owner && !compare_sids(&sid_owner_rights, &ace->sid))))
+			in_group = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
 		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
@@ -1665,7 +1696,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			 */
 			if (is_owner && !or_ace)
 				allowed = READ_CONTROL | WRITE_DAC;
-			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			/*
+			 * A group the caller is in, or OWNER RIGHTS for the
+			 * owner, gives what the DACL grants it in order.
+			 */
+			if (in_group)
+				allowed |= ordered;
+			if (maximal)
 				requested |= allowed;
 			if (!allowed || requested & ~allowed) {
 				ksmbd_debug(SMB, "Can't find corresponding sid\n");
-- 
2.47.3

