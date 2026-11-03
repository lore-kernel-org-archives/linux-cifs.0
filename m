Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718317;
	b=INWIjBRLZe7BB2rKjP83Qp2RLYhPVgmMqBRPuBA9XN/lwJy5FxpdlIg2PeqcBOJYHJye
	 xBn1cpLGOYLKxef2PobheF7BTlezgOqXDxu1hHJ5LKHUdMW4HX5I8/D97QCPA5tFFCo/S
	 Z/1tivKZyr6cz8OPJILw3F6CoV2gFF2tW/Wsib2/2jco3MpUxuE5M3qEWZlX7otrRHEIS
	 Ni/stiUxOB8JFzooWwwgP9xyigaw1FIfZJg2rXR33zuygnQJUGhklDuFC+xG2+viDVJB7
	 ZogmIRORtWIJ3N5iJmjV69+S7o+j1D+owy/bP+MAp43Drq6X+XW0tZ7M35pZIJpuIUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718317;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NuaHp9uosPhIJFvZX5gCYipqC32nrkNImWil1iY7jqU=;
	b=3Uw6ECuNT+oxC1qsuYWaKR+Kk9DL7Avwz0J/KHsr78G5wTyvhwNZI2ZSOLhM43WoimNk
	 cM8pi+cxEKzfPzBhWQACQqR6w1mQhaosgeZSIxVrbqCL8KFuvVAhKZAvYG7hiVvhhXPzp
	 CSKfoFk1dt9ti81MKIyp33SaVtkXaGLKgpsJOAYsm92uFGj0BreBHnBcHO3Yp6tKFCXGg
	 /Jf/gQnlQlWcX5Z7lo9Tj2rckN7fCpt3Imt9hJ5a4mfS9fgmDpCPuGNHECcDslv7Ri7Jr
	 /1GUXO8Gd3FLd7OtxpsvUKVfDH1/vPH6OCj26ImkPLVFGPCsoNRkM02tmoHX/fzr7Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Yx5Pypjd;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LvtLi9St;
	arc=none smtp.remote-ip=202.12.124.152
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48494606A33C
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48494606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Yx5Pypjd;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LvtLi9St
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7D64B7A025F
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 10:05:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 03 Nov 2026 10:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793718314; x=1793804714; bh=NuaHp9uosPhIJFvZX5gCY
	ipqC32nrkNImWil1iY7jqU=; b=Yx5PypjdGR2ddMGVw6TlL9kQRhL4OYekufENn
	4zKoB90XHKX05FhObGrRid8/5hSHrMiH97fNoRG7F3zdZtwhP653LPrG5l+f+SaM
	H1MQVPVCMMntJm1o4ZfWFwU2uABbn9T2QfzHVmug+wiQGzq9hHBwrVZ5nhjnI4MZ
	jY5gsTkcg6Yvp0WU/I47ZPQRf+t4vfybUJ/KSYqHyleJfk2eMNPnlNpuiyfHQTG1
	tERhFqinsgcGOENycmyIgR9VvZz3MycA5ZFwnGgVeXirMwXexwbDgbKc1HR20Ljz
	due2LpaB0sktzPE4OOiwzXEarUQ6VEMeq+NofjzZB8jjqGH0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793718314; x=1793804714; bh=NuaHp9uosPhIJFvZX5gCYipqC32nrkNImWi
	l1iY7jqU=; b=LvtLi9StaS0KFV+NpE2jO6hfSHsbLQIafq0GONK1m8poyYOb9yP
	MLb8FE084uZaTQrhLwR5nusMXpcNwREdzpHnFASyC6bvG4uq0ajNFBehapD97g80
	iNgFfjoXg1Ztv8q2wNoeMAXpP0Vj+jKt1xUoJNrQigg72gZkmOkOOwhFkejNPIcO
	sjc91uB1YUVTCo9J2GGCmEjIqPLUS9v/Det7+g/s4YwwvM5f4PCgbXmTT9npRenZ
	6KmZNTGpY6Y+3sFQGWNAZ6D7mc+2/4yxTV1AN48jXnyoS/7vSYHjTr0rQB0q0V1S
	fQwOvUD5NybNFzG4DJpvSAHgAb3p+dUSzlQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793718314; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:h+vXiK8iVlN3SYeIVD1irtD3esw8KGKiJSfJ0WawCx20CFF
	XZGCHD6nvLccM/5HOsCgaIyEmnYzIyJDtxhn27dkGfq5sq+ODYPL1Luvzqzq0heS
	IUdojcT0EMDQmzuqWLHBNFH5ycoQejpZPI05Uqz0prbrKsLlBAxhjb6BJN6N+FfW
	Q9jap5lOxndRfdD9R6GN5o6ZE3w0AGvKOX4wQTNbNZ3QL0gdybg5gZ/EtNr2btoC
	2GT/Ra8coKFui3v9dXjhSk59HvBiuqkt5zOAFlHU/j6PX3sP2HCJUjdkGFHFvOVe
	RjrhGY/qcRe91N3Fc4tPaJ6DSC4OVy86kf6hLMA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:GXZbFxsks6YN4t7uEI6A8Y+9bT9hk1GsqJby3FKz//s=:/vmWf7pd3xovjtKqSmqVYTOwZN+N2niluBf4KVU9QOI=;
X-ME-Sender: <xms:KvjpapWOcP4YywiDmecg74_4pigs5Na-Ygfdtkp1kRWhQLmTHi2FQw>
    <xme:KvjpamJ6LpVpx-iO08vGprbbh8utDK8aIxuFMVDkjCaGIVa4OrFKRWFgeGLGjRUCU
    4b5vq3JLzu4tAxUOVCLA0zPQN0fXezUU_MIgrZqp7bIhwk078_kcRI>
X-ME-Received: <xmr:Kvjpap1gvIjostKhqmNSDF7J2ucdR6g-FWlpYQFDFdEtQpUqIKx7nXDp4FCoZoUJ>
X-ME-Proxy-Cause: dmFkZTEZaxs/DnHo9E/Pj5ZB+Z0bxAKDwg+7G8Of60PzqbvrqxR0qWoR8FsUllP9WxER3d
    XWpil5L0oc3xZwKiOt7e8IKcoFg51qvtEf1DuPzR+NkKamUuy6QH1dDqH3wLu3C8Mp+8mr
    xx3tm4OsOBkMpGpfqY/TeJpeg+VvLOJJFtBKRLOvNBbAn0dnMRg9Eh1rt2/CHsvmFK/+Ai
    7/SSCt+X1NsWeJw1QnEn8TflfSo1/+px9AD6c5eeNt1Ch8hDq7ariF4fAXbrejzxgQMvos
    pgZNV6Jy8DDr2E7UM9Us8IzFoKL0s1uVpXy1umlv3evW9SfKafNuno0miS3VxNXNcu62ky
    7Srgpr+KjJM7Ni1XJe3IJIse2x6TzDeBF1zHorFAKsUv2hvRqVVTcEte0faTXiudvMwrCp
    Tdmb28RlX28W06/aWtCBmhcsfsb72e2tlXsCa/ZLMTCdAbNk8+3O+iq6kFWyrzuQKtifKD
    XjUvUq+rrKis0Y1HSe+jii5DTixQApRsU1PefJdQXjEbmGmefTUbmGXUrpgA6+5L9YedeH
    LzLva5tYD4WEIWvWh7U7LYt4lLmZRzJHhmyIyYmrFtRIJa8w5vpSUCm+MiePoRO3mTCPKh
    vfL8mUvHC6ZtTpvnsdC+DHcxPl1803nYfYRorwTu/VcFImBOBLDnpL71yVxQ
X-ME-Proxy: <xmx:KvjpajIyM96WcoVBRvfWN80PXQbYOBUfZsKQ_vGEniMpuD5Oc_sQUw>
    <xmx:KvjpakgjG5l1BTufoRek3j5pSuLYuK49buc6DfVgbVTKhnU5cSWpWg>
    <xmx:KvjpajAto2GSdhpV7t8-vxJ4ZqHn6jMsoYlfYT3YaxMYNoxd-47KWg>
    <xmx:Kvjpam7GEwlahlDO4CDkzhKBU8mFEHsiVY8XgbDK1bMKysgH-hStWg>
    <xmx:Kvjpav1YqhVEskodTRGYnA6Z4_PWJ3gH_ocdhtLtVdnhtIHjAHhrcRlL>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 10:05:13 -0500 (EST)
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
Subject: [PATCH v3] ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
Date: Tue,  3 Nov 2026 09:04:58 -0600
Message-ID: <20261103150458.11591-1-icb@fastmail.org>
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
caller's groups limit what it grants, also for MAXIMUM_ALLOWED. Match
OWNER RIGHTS exactly, since compare_sids() also matches longer SIDs,
and return only file access rights. Preserve the refusal for
non-inherit-only object deny ACEs, which ksmbd does not parse.

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
    Since v2
    - Honor deny ACEs for the caller's groups in the new MAXIMUM_ALLOWED
      fallback (Namjae Jeon [2]).
    - Match OWNER RIGHTS exactly and return only file access rights.
    - Keep the existing refusal for non-inherit-only object deny ACEs.

    Since v1
    - Clear access_bits for explicit requests, preserving refusals for
      ACE types the existing lookup does not handle (Sashiko [1]).

    The hide unreadable listing and the app instance check use the same
    answer and change with it.

    Tested on ksmbd-for-next e49296d51ccb with KASAN, with no reports or
    warnings. A reproducer is available on request.

    v2: https://lore.kernel.org/linux-cifs/20261102200353.884509-1-icb@fastmail.org/
    v1: https://lore.kernel.org/linux-cifs/20261102061537.830714-3-icb@fastmail.org/
    [1] https://sashiko.dev/#/patchset/20261102061537.830714-1-icb%40fastmail.org
    [2] https://lore.kernel.org/linux-cifs/CAKYAXd-s-g2V4LNY8e5SsH=+0r3qLY+AeOa5Lp9K0T5p_tnA8A@mail.gmail.com/

    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 94 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index ab76c5c9e0ea..acb80cf0f2ca 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1459,6 +1459,29 @@ bool smb_inherit_flags(int flags, bool is_dir)
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
+/* compare_sids() also matches a longer SID, such as S-1-3-4-777 */
+static bool smb_sid_is_owner_rights(const struct smb_sid *sid)
+{
+	return sid->num_subauth == sid_owner_rights.num_subauth &&
+	       !compare_sids(sid, &sid_owner_rights);
+}
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool strict)
@@ -1475,13 +1498,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int granted = requested;
 	struct smb_ace *ace;
 	int i, found = 0;
-	unsigned int access_bits = 0, denied = 0;
+	unsigned int access_bits = 0, denied = 0, ordered = 0;
+	unsigned int any_allowed = 0, any_denied = 0, bits;
 	struct smb_ace *others_ace = NULL;
-	bool or_ace = false;
+	bool or_ace = false, in_group = false, member, counted;
+	bool obj_deny = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
+	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1522,7 +1548,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 */
 		if (is_owner)
 			allowed = READ_CONTROL | WRITE_DAC;
-		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+		if (maximal)
 			requested |= allowed;
 		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
@@ -1531,7 +1557,12 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1551,42 +1582,69 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				      sizeof(__le32) * ace->sid.num_subauth)
 				break;
 
+			if (ace->type == ACCESS_DENIED_OBJECT_ACE_TYPE ||
+			    ace->type == ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE)
+				obj_deny |= !(ace->flags & INHERIT_ONLY_ACE);
+
 			if (!compare_sids(&sid_owner_rights, &ace->sid)) {
 				owner_rights = true;
 				if (!is_owner)
 					goto next_ace;
 			}
 
+			member = smb_sid_in_group(&ace->sid);
+			/* ordered counts groups and OWNER RIGHTS only */
+			counted = member;
+			if (is_owner && smb_sid_is_owner_rights(&ace->sid))
+				counted = true;
 			if (ace->flags & INHERIT_ONLY_ACE ||
 			    (compare_sids(&sid, &ace->sid) &&
 			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
 			     compare_sids(&sid_everyone, &ace->sid) &&
 			     compare_sids(&sid_authusers, &ace->sid) &&
-			     compare_sids(&sid_owner_rights, &ace->sid)))
+			     compare_sids(&sid_owner_rights, &ace->sid) &&
+			     !member))
 				goto next_ace;
 
+			bits = le32_to_cpu(ace->access_req);
 			switch (ace->type) {
 			case ACCESS_ALLOWED_ACE_TYPE:
-				access_bits |= le32_to_cpu(ace->access_req);
+				if (counted)
+					any_allowed |= bits;
+				/* MAXIMUM_ALLOWED takes no group grants */
+				if (maximal && member)
+					break;
+				if (counted)
+					ordered |= bits;
+				access_bits |= bits;
 				break;
 			case ACCESS_DENIED_ACE_TYPE:
 			case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-				denied |= ~access_bits &
-					le32_to_cpu(ace->access_req);
+				if (counted)
+					any_denied |= ~any_allowed & bits;
+				/* access_bits still ignores group denials */
+				if (!member)
+					denied |= ~access_bits & bits;
 				break;
 			}
 next_ace:
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-		if (is_owner && !owner_rights)
+		/* Keep only file rights, not MAXIMUM_ALLOWED or generic bits */
+		ordered &= GENERIC_ALL_FLAGS & ~any_denied;
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
+		/* An explicit request takes only ordered from this walk */
+		if (maximal)
+			granted = requested | access_bits;
+		else
+			access_bits = 0;
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
@@ -1615,6 +1673,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
 		    !(ace->flags & INHERIT_ONLY_ACE))
 			or_ace = true;
+		if (!(ace->flags & INHERIT_ONLY_ACE) &&
+		    (smb_sid_in_group(&ace->sid) ||
+		     (is_owner && smb_sid_is_owner_rights(&ace->sid))))
+			in_group = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
 		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
@@ -1668,7 +1730,15 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			 */
 			if (is_owner && !or_ace)
 				allowed = READ_CONTROL | WRITE_DAC;
-			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			/*
+			 * A group the caller is in, or OWNER RIGHTS for the
+			 * owner, gives what the DACL grants it in order. An
+			 * object deny ACE is not parsed, so it keeps the
+			 * refusal.
+			 */
+			if (in_group && !obj_deny)
+				allowed |= ordered;
+			if (maximal)
 				requested |= allowed;
 			if (!allowed || requested & ~allowed) {
 				ksmbd_debug(SMB, "Can't find corresponding sid\n");

base-commit: e49296d51ccbf2ad0ed0484db1382f1d7217bd6e
-- 
2.47.3

