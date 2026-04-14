Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E7328B7DA
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776194142; cv=none; b=jY5DiWGw3SOmZMK+vQbX8zYMwVgQnyHGPg3O7CMqSvHz3SDeh4QA53plamRyqHGWtUjP3AvxvlKqL2l0yy/fEu5KteXV47Bto8rDqQg1dDiiRwx5q4b3A2cLWznTdgpP+gsXQjxVCOABq4dZ3zIguGJs5JPu/D2RlbxDBBs90Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776194142; c=relaxed/simple;
	bh=0V678CI/bTL105QQk2LrBJXTTCkcQ43Nj6FSGsr09bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlY+blTIt/JJGX4jhCl1ra6vrYV8axyDd4fjJfR9Na7M+4g+0aR/uhMQdI4bJI/mKFLVC45zobCIQMDtA3fG2MQJ7nhhYH84JShpUitV9F15rs9uaaqUo0TpV02tclwweWYaZwKzLGWyWvLb0EHWkr7/7gPMrslQ2Y/7nLqcrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWSEAA78; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWSEAA78"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso68225466d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 12:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776194140; x=1776798940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgctrOw+fTa9HS4kEjyzcX1BTeKi0lvTfjC5zn/MPTk=;
        b=AWSEAA78E2dCwd1o8hO9Bo4k1B4oIc8Prs8JJWJb/K/mniBK91sPSoijbdL4n2WQJ+
         r3K2kRTOF4/CDgJfPNqssh+2D1ESD2jy0ldN2Knp7fD5kBwYLddtYGLd7yT8SUo+aLXr
         yDjQr8SfvI7m/zHLUr0GkBjtltihdVl4bBLCnHX/Lpm7RYbFh6KRdkHLbWHxLwVJGEFl
         nGnlJFBF7g8BlUceLvKco1to8Cad1uN9wa4zh1cWdj1WHwGn5321p/BZB5NauMF3Z4Fv
         dQL48ZiLpMCWAY+Al3iPIWoBssVquHmogFve/0Bk/KbjLoekyY36jkKTeipREqV18Zfc
         F21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194140; x=1776798940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AgctrOw+fTa9HS4kEjyzcX1BTeKi0lvTfjC5zn/MPTk=;
        b=eG/40mlrzwyLFVJ6jX3APvp9DMX3O7uYoMkrliFMZsrhO93InDIqV9qGT6WdugiPiz
         fYtn0oTU/XqAAxvymcdtHiCMTLF2J24/Qy+ljemWdecF3L0XDZDUMbvLs4geAHfTdzSe
         AkMq+VpG4ZXqGN895GKk3TlYgILziqNwCm2M5b+OnMqNdScz11IfP8J1imPQxtSA6H1/
         9+LONTKE7eucNZ674qya3YxsbDYN+czULwy8m8LtzA58llBOBfajzCR3hwusmcX8a/ky
         F+afzAsCHRf9NnTsO4xVa+YTnrC41GVHtNRWHjasLrInKhgKsUef0kYBzXwHIVz2aPsp
         Cpqg==
X-Gm-Message-State: AOJu0Yw5RKgjs4YkZc85croDProLBpDO1K+ztpSjjZWH7h5yhy1XE6y9
	0VxSEdiLho93+ic3RWZbWUmIigDFeAxQpypkxz0L18KxS3U8ffN2CS+HKY7P04BD
X-Gm-Gg: AeBDiesV8wFhqHK5L/tcRFExt41rgS/2LxIyJCLKHcQQlAP5od/ytbfINpGQj0i/wXd
	iuJEXUIC+wkZ/YKCSZwdzLvW9HqdrfKoTJBZlv3YSQno6cauycGVFqCxNvrGs84Vxlc7XvRggQs
	82W0QZJDhLIBGdWw1wwpiUZD7y4/Zvcvn47cbAcDsYTCgm0FHdl6eEs9qyzLviDM5TXKOm/MlWl
	ZfZZVTT+YdbxXIFFwwesznt7WXCWxtUEvTVcEqsBPd+TOXXrXcFnUvCurPFPBZEHTt8CxlRA5LF
	q5GxSO0D8FaAgk9Fz4GEy7/Cti7GOx/ni21ph3ic7o/JSzo0Uz+lf/xHrF452yMIzQn+PWjIX0G
	s1qZnGMeCAsjb6M4F8b5ufVWIZdkR5O11FRU2G1I3d8I6rMqsro2sOs5QRDy1Dp8ulIeJOlKzV9
	FEMb1/MxoaLiM1UNNLKjGXippN4WkIjpFXyQZ3p9sOi9NH4L9ev1dw+JMluWtbgPkSknldxo2ql
	n/zOP/iPB6f7PrIzSeo/vXCJPZkVRY=
X-Received: by 2002:a05:6214:4c8f:b0:8a6:1545:41ae with SMTP id 6a1803df08f44-8ac860ef7b0mr284828526d6.15.1776194139885;
        Tue, 14 Apr 2026 12:15:39 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca478a70csm77229126d6.27.2026.04.14.12.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 12:15:39 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] ksmbd: require minimum ACE size in smb_check_perm_dacl()
Date: Tue, 14 Apr 2026 15:15:33 -0400
Message-ID: <20260414191533.1467353-4-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414191533.1467353-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both ACE-walk loops in smb_check_perm_dacl() only guard against an
under-sized remaining buffer, not against an ACE whose declared
`ace->size` is smaller than the struct it claims to describe:

  if (offsetof(struct smb_ace, access_req) > aces_size)
      break;
  ace_size = le16_to_cpu(ace->size);
  if (ace_size > aces_size)
      break;

The first check only requires the 4-byte ACE header to be in bounds;
it does not require access_req (4 bytes at offset 4) to be readable.
An attacker who has set a crafted DACL on a file they own can declare
ace->size == 4 with aces_size == 4, pass both checks, and then

  granted |= le32_to_cpu(ace->access_req);               /* upper loop */
  compare_sids(&sid, &ace->sid);                         /* lower loop */

reads access_req at offset 4 (OOB by up to 4 bytes) and ace->sid at
offset 8 (OOB by up to CIFS_SID_BASE_SIZE + SID_MAX_SUB_AUTHORITIES
* 4 bytes).

Tighten both loops to require

  ace_size >= offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE

which is the smallest valid on-wire ACE layout (4-byte header +
4-byte access_req + 8-byte sid base with zero sub-auths).  Also
reject ACEs whose sid.num_subauth exceeds SID_MAX_SUB_AUTHORITIES
before letting compare_sids() dereference sub_auth[] entries.

parse_sec_desc() already enforces an equivalent check (lines 441-448);
smb_check_perm_dacl() simply grew weaker validation over time.

Reachability: authenticated SMB client with permission to set an ACL
on a file.  On a subsequent CREATE against that file, the kernel
walks the stored DACL via smb_check_perm_dacl() and triggers the
OOB read.  Not pre-auth, and the OOB read is not reflected to the
attacker, but KASAN reports and kernel state corruption are
possible.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---

fs/smb/server/smbacl.c | 17 +++++++++++++----
1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c30d01877c41..d5943256c071 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1341,10 +1341,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (offsetof(struct smb_ace, access_req) > aces_size)
+			if (offsetof(struct smb_ace, sid) +
+			    CIFS_SID_BASE_SIZE > aces_size)
 				break;
 			ace_size = le16_to_cpu(ace->size);
-			if (ace_size > aces_size)
+			if (ace_size > aces_size ||
+			    ace_size < offsetof(struct smb_ace, sid) +
+				       CIFS_SID_BASE_SIZE)
 				break;
 			aces_size -= ace_size;
 			granted |= le32_to_cpu(ace->access_req);
@@ -1359,13 +1362,19 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (offsetof(struct smb_ace, access_req) > aces_size)
+		if (offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE > aces_size)
 			break;
 		ace_size = le16_to_cpu(ace->size);
-		if (ace_size > aces_size)
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE)
 			break;
 		aces_size -= ace_size;
 
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+			break;
+
 		if (!compare_sids(&sid, &ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
 			found = 1;
--
2.53.0
