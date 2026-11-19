Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071083;
	b=Siatgo6Qv39Rb9HxP7/EN7Kf4+n32HiV4ViyRhhkcV1A2nYwuVEWs6f3Y9A1sj+LF+wi
	 gIR1N4c3gP49XmZ96jsXnOpMSuGhN0I62ysOqz16Zkrp94qVj9Uhd76jYllR3jGM0GMd0
	 YzCekdCygwqrt45FcpSwM0L0n3XFgIkzHbw4ORiPylD/QFJEImkRW3tH5hSS0SJCcd8YI
	 YNI/JIvP8jQj2rmOUgUDSG9wCYbpoDYnpEqtWYQ74xyCykXojeDbHbg8FDNcbtnOvQoJO
	 m8rEc3A9dTzCcNdfnmx+KrIMYcHjU0ueVp6G6RghQAmpKKXU9FCznrEnO6pnhS1L7Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071083;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GhgvklMDjk6zu2WsohNEaN8+xrIHn3P8GxKAAXqhfhU=;
	b=j8VnE1j0e46+GZ+6JuMZFt30Ijv5oLSsGjoUiKhy5iMvemSMCodvMhWuc0kM4KeXXosS
	 6L8M4PCc/C1Q6jnvod1WSmW56lRoOhivZEJ++7bSH5rVpOJY+qIAnVOUh0ZITVOAdnjQx
	 PDMerzIYMN3NYyl6arvAMWj8HfZCgmH59ffUqKsItPGW+x8jXyX7+22v+aNt9AzBQ38qm
	 ZxeIefTPaQbT4OiPZyuaafXIH5A3JHam0+N8aDOyqYkUQM6bYoljDJaI6tF3wAgv1JLGN
	 q00OE3esRHesuf/72HACTHuzrk+h+OfnfXaBg/QkAf6uwadlfeyA27mEa6NfnCfcfyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=GEjmeX3r;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LTGuFLnN;
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E69606A326
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 06:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99E69606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=GEjmeX3r;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LTGuFLnN
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 936E01D0026E
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 01:51:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 19 Nov 2026 01:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795071079; x=1795157479; bh=GhgvklMDjk6zu2WsohNEa
	N8+xrIHn3P8GxKAAXqhfhU=; b=GEjmeX3rzt7TKsjUoTp6okWCltuOnDpuyn9kM
	N7e7m9YMkhqVVH+Za/9xpywlrAncVZanHNzDeLFJcAYX12d820VWLDFwA0VAfQSF
	cd+n14XUAtbXS2ZSWFmFnVO7jAiX75jVTH+xWLAXIx7g7ESgUyk8KW8TIZU3Ko01
	ldeWYIPpxJrRG+f4+0dfMHOQda2fTn8N6QpxyZ/lx/Y02ZCF4NioHCH4TIwMP2wp
	w2ZIfLGOepgm1+aAbNCIdOgaNZhCkfecM45WIVt7o8UDsYYxDo8QkYDA160HITEz
	IWbYMmO6Qpwjb2sNH8fbdEZdbDdJtT3Svg2JZlj25bFaL0JOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795071079; x=1795157479; bh=GhgvklMDjk6zu2WsohNEaN8+xrIHn3P8GxK
	AAXqhfhU=; b=LTGuFLnNnUWRBTZCp4NOrsB8Nym3dP+THd7/vYNyCP71Me3LA2g
	WfaTy+ZAUqGkaCezQtlw6y+7wVu34f57bugQCifMwB/xQ5qVlGkgc2Rp1UpBZl6k
	Pt2W8msg7G1hozELbCh9x/OJFEvYGfhHJtyrDRR2oC4LIpEs9AVVZiOgc3kaCdEI
	bgyDyQLthjItVaqTUm4iqP8Cy4fT/HNC3bJlyGDLqKovdxCO2GJLgl/rM82KvUkS
	pI9Gt7vbA2nnBJRJNH88wN2gAahucH3hkJIbQ98VxvUZ+MeBLIVH/tf9V0Ydd5ma
	zp/ITRUup0X50tYFzmeEGf8jxlCHpdZksVA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795071079; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:jOaID1WniSjmbEVEH9IIXi+10w3t9ZYTffCfwLx5Goc9uyi
	98hB3qnZCP8PUqoQ9GrED437BsltB4vZEyyTVQbbW6aOmc8IeTTG5fHNVLnhQpyr
	BMqUpgik8kfTOXcO7RZUmEmbl3SU4RNm7p0El3+CVCXpsVN5q4DkYPeSb5+ANMQb
	pkPRDYO3rYIQUMiyC2gOKm/zE62QLkt/EF55NUxGhh04rwQsFKB/kuEiED2P3RC1
	HoIOyFlfhII449yDBGAGKVmMx2wu56KZ9TuZTmSFLJdKhSMT3eRqd4UtF0UvYEMS
	FSShe6oonDEjSpUW9YDh8TtsC8F0nQ2vdjbYrtQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:+iIXmIpFaGvDjtpixJ8r99a1kDCNsk568HiKsz8awhw=:7o8dBcksPc0H9i8th3cz0zuq9n1I2r6Y5JOzAJNUfaY=;
X-ME-Sender: <xms:Z5z-aoamnPOxCbHCdT1084c_AvX1L6_fgdkX6yGpqRhmvi8wzT0CGA>
    <xme:Z5z-avZIjw-x1Mo_VglGm_xvNZ7Nx5OIjr0F5Pg_eWgtlzq4UXa_ygFyXr7_BnziO
    CiG12u2yLz123aKlaWUnwUSdsFPTpXcl7KAr39ukV8egQOdrk1KZNzt>
X-ME-Received: <xmr:Z5z-alJlGnVB9Glt9LTeeHj9oFQjBhHIO6UmDc_QMf1Gcjf5pv8GWt8uchc9sPHT>
X-ME-Proxy-Cause: dmFkZTFqWPrG66/2GIwqIe8I3RcDHcr0y4t8OAuwWc/zqQYvbhEyFEXrsvx94UzAyjWpRw
    +5nTAr6u/w6lVDp/6PO2Dhs/T81URQcSo5abMU6OjLv/Z3IHWsbUzSWIXV6Aqscysu8xK7
    +dKxL0CV39EV+lU8W8bpoGb9StGeHX+qQdUnULfyeAGGKxYFpYmUSYmxlZ8i2wgxs3n5T3
    G1N3YTQCkZY8rjkeOwozlGBlzusb75COgAUJLWkYXnOcWLA37aZHeXRb/Zf59dmZPLXWej
    aFiMskcMZRSoWoRrXc0SNwC/OiW18Gi5YAswivzsadZ4jOkVN8QU8N/NnHwhOjvRNplnEl
    mczwnUfFdoGv6P75+ieZ7rZxGCyMCCcZQEw/v/M5J6jhZsER8bUPOdfxaJADO7tQorkTVA
    KXUOQBKuSNwNEbhBBFvqRJZaBNAWglSD31UEWUeyTytlpXQw2bNxKcr3VQfzO+gdesMWFb
    smHUjnEIK/ZtEW29aob3cEN/7ewKeXi04pML9Y5lzugv1y5r+mZldDUEsBjXVIxDeg96Sf
    CEOeEdwyjCyXCCRz9B3OowHPwO1HmVZneWtlKYs13zkiMrxJQd2yAtIToAlFWAJ8h2Mu1g
    79sJ1XcGX3ZYdIJTOw9prEn0os2W9f7/2Pz/2qa9AuEk3JcYRBWW0oqwi0Zw
X-ME-Proxy: <xmx:Z5z-ajuwkEmCV-EZrJ24dlbS7vFtr0YHmWztueqCzQfx1tdy03yBzQ>
    <xmx:Z5z-ahXgcXgxPUfVKqfW2dbT6mvQ20Tjn6KXbu_x3JbHD9rMOUpXog>
    <xmx:Z5z-amj8t24Ec_SszbhtJ9-XDx9_4zq5lu6gHPhewnqc_Ao6kF5P8g>
    <xmx:Z5z-ahoYfNISqxjByk5ZX5fJqyAaFOb85XWf5Y3ZeIj1fVSRefGWHA>
    <xmx:Z5z-apBJvyYaZKYt65hyAwBS4mJtGKv1jzH5tcvR4y028-v1tEG4is5C>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 01:51:18 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: fail SET_INFO when the security descriptor cannot be stored
Date: Thu, 19 Nov 2026 00:51:07 -0600
Message-ID: <20261119065107.115679-1-icb@fastmail.org>
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

SET_INFO reports success even when ksmbd cannot store the new security
descriptor. The old descriptor has already been removed, so the file
falls back to POSIX permissions. Deny ACEs in the new descriptor are
lost. This can happen when the descriptor exceeds the filesystem's
xattr capacity.

Return the storage error to the client. Report -E2BIG as
STATUS_DISK_FULL, like -ENOSPC and -EFBIG, and report -ENOMEM as
STATUS_INSUFFICIENT_RESOURCES. Both errors previously fell through to
STATUS_INVALID_INFO_CLASS. These mappings apply to all SET_INFO
classes.

Preserve success for filesystems that do not support the xattr. Also
preserve the best-effort store for CREATE, where the file has already
been created.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Since v1
- Handle -ENOMEM and -E2BIG as requested by Namjae Jeon. Use
  STATUS_INSUFFICIENT_RESOURCES and STATUS_DISK_FULL, respectively.

A failed SET_INFO can still leave partial changes. The owner, group,
mode and POSIX ACL updates happen before the store, as does the removal
of the old descriptor. This patch reports the failure without rolling
back those changes.

Tested on ksmbd-for-next 267029b35ad1 with KASAN. A DACL too large for
the tested ext4 filesystem now produces STATUS_DISK_FULL. Injected
allocation failure produces STATUS_INSUFFICIENT_RESOURCES. A test
build that substitutes -E2BIG for the store's -ENOSPC also produces
STATUS_DISK_FULL. Small descriptors and filesystems without xattr
support behave as before. CREATE still succeeds if storing its
descriptor fails. smbtorture results match the base.

This patch was developed with LLM assistance.

v1: https://lore.kernel.org/linux-cifs/20261118155521.70611-1-icb@fastmail.org/

 fs/smb/server/smb2pdu.c | 4 +++-
 fs/smb/server/smbacl.c  | 9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 29750970f8da..3382974df8d1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9526,8 +9526,10 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 	else if (rc == -EMSGSIZE)
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
-	else if (rc == -ENOSPC || rc == -EFBIG)
+	else if (rc == -ENOSPC || rc == -EFBIG || rc == -E2BIG)
 		rsp->hdr.Status = STATUS_DISK_FULL;
+	else if (rc == -ENOMEM)
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 	else if (rc == -ESHARE)
 		rsp->hdr.Status = STATUS_SHARING_VIOLATION;
 	else if (rc == -ENOENT)
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index a87c22fa9a6e..3770dda2b3ed 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1984,7 +1984,14 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		/* Update WinACL in xattr */
 		ksmbd_vfs_remove_sd_xattrs(idmap, path);
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
+		rc = ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
+		/*
+		 * The CREATE context (type_check) stays best effort because
+		 * the file exists already. A filesystem without the xattr is
+		 * not an error either.
+		 */
+		if (type_check || rc == -EOPNOTSUPP)
+			rc = 0;
 	}
 
 out:
-- 
2.47.3

