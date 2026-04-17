Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4884130DED1
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776451579; cv=none; b=nvDTtO/X6YTA1Vdmx37Mbmjy+lKNoKZrZvmINm1JMbTPLz8fGVKBLuLEM4x3jpDy0xUrjdV3BppRLn/2w8HOA0TYhHY+/6MnhVPqnrBwc712J0SL6j42L4hDGLTnIvYqn+iYbCFAWrswnt/yzj/954DXei8ZQJvifXSsLEvxvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776451579; c=relaxed/simple;
	bh=qPmRyp0y7PzlYMI7mL0qWLI7uB0ZnmAn0J9PDgiv6ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObTL1oqS2kZfYZC6lzxG/3mE95fW5oQL5X42vDoKwyoaHwpr1roDvNgFrZrvV2XorWcwCTbLPVej8VttFcGlGR/uWEgOC7iwH7nu8cxFRLypZtO71+PfGpUEH4iB1isv9tCeLhfiWhhMXmDZOD8rJD41o17nSGL/Sss5eerAGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSYI0g4n; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSYI0g4n"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506251815a3so8897091cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 11:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776451577; x=1777056377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnB324ImcM1acsbVZKl+4DrPTQ21/FeCKs/oLsdwvJ8=;
        b=FSYI0g4nETrAvo1zQfhGxZ/e+vLE49iiY157/HXbniljyznYXELmem32kWx35zqhV4
         q7dug+ELSu7DDqRhkouvQj1Mz6LqsTafgfr0UFpw0iEm43/ntfAaRPgTTtiPoypYzipk
         +HJEaiZGHJH43vmkHbyvEiJ/k6XKRq3VfLl6ka1GfcUkRtPUgrSrG5AwiazeeHtVFdv4
         8vPD+VkPq4knffgujr/9/utlFuy3K5CBXofhVTtcrJ9p3WY1fFgut8kSlEHxuBsnnLiw
         m15sKuZ6OhIvOMknRFDB3sXaly1AbjpaJS+xk4phRQ1Ey8Vh8pxMv1EBcl+K1jJD9Hac
         gDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776451577; x=1777056377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wnB324ImcM1acsbVZKl+4DrPTQ21/FeCKs/oLsdwvJ8=;
        b=QiQghniwoTvXUtTRzLWf0Wl2G4SKfdsg7vZNaU9opW9BpyPtzh2f9fgZs7mtmQEnBq
         gSQJRpH93eDLg/JC04H3i6Tuc3piafGDQb1gkYHYnt0K68D64unC5Rcb/donVC8EyAIC
         4EpcR7SFbqVpScP6ePWpAwZvRcQpAZFRNArMDUKyhJMR7jJOBoWneu2nyhb+pWGLO2YV
         +wOGH/9vVJMrKz9Tt5Po0DjnRSeCaiOqJ0Yttv2BDs7iNra7qFd3/Ow4rPnW6sjyUQrj
         VDU+N2Lm5R2ADNMNuTInM59WJVnugEVkQ68t/s3noFvjqjH/37MfXwftKxVy6wh/7w9O
         2uBQ==
X-Forwarded-Encrypted: i=1; AFNElJ/uX4CIXc2VqbQoqiT6H9+NqS3b1wLGQXrm2nJ1zYY3sA5hciSgiu1L1+VkWI5Sp+Qyy/JpTkR0Q2gE@vger.kernel.org
X-Gm-Message-State: AOJu0YwaP+7pM0dvAL8QJuQOSzN4QQUJOD4Ol/uf91ioLdta1oOeilc4
	TIb7l+OVxGB7HBNylfokuSF7ijjQ747NEJxXHt/Mw/z0O4l3FXlguKRDzfJVDoRb
X-Gm-Gg: AeBDieslhcdoI7ZLbJou3auV1guT4U6IeckyZZChPs7kgX+RcB33uChTCbDMvVEqbo0
	mYFNJe9t+Oz6nk6DUr+4c5r901WTLSWrJw0M8oURLf6/84t6nWQRqte9QtCzNw/zFXWLTdYv+vq
	jUiIS3ILvz8vwKkjON3+TuYRK8QSTbX2pfCwvZ5vYMj3A2mQrMwvknUgISW5SB5WmdzJr0a1K2+
	GvosZDkxTldQOX71WdxPk9uUwj5s05RLIuUg17aLafwPbliEBeNw/jo8XyGnjMuK+y0xSDFPKYW
	syZyPF8BtKREB+v6FznJnxHiFMZPWyMzi7R2ohqZbNnoWAwklhLzbevrLs0Y4IjwePK3+vygKtU
	QDeSbP+uFNtI+xKEeTP4UxmjME8k/bglPZnbeOll32+QvtAV7pykYE/L0ZCC2engQQWtELp1zPw
	ULhVsVPCSUv13ypFSkl3dJe/y0l2suKQRQtM83wYTkY701oC4wKkujtvz3YauWDOtR+o0xdES4c
	HuBXWYaXvpa/xy85xlMW9vkX1RnQ68I2BeyM6CVWvwUzV2iJI9pjA==
X-Received: by 2002:a05:622a:2615:b0:50d:8792:b6d1 with SMTP id d75a77b69052e-50e36c122efmr55258341cf.38.1776451577116;
        Fri, 17 Apr 2026 11:46:17 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e39449e36sm22631771cf.21.2026.04.17.11.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 11:46:16 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
Date: Fri, 17 Apr 2026 14:45:57 -0400
Message-ID: <20260417184557.1138554-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416200439.2987930-1-michael.bommarito@gmail.com>
References: <20260416200439.2987930-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb_inherit_dacl() trusts the on-disk num_aces value from the parent
directory's DACL xattr and uses it to size a heap allocation:

  aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2, ...);

num_aces is a u16 read from le16_to_cpu(parent_pdacl->num_aces)
without checking that it is consistent with the declared pdacl_size.
An authenticated client whose parent directory's security.NTACL is
tampered (e.g. via offline xattr corruption or a concurrent path that
bypasses parse_dacl()) can present num_aces = 65535 with minimal
actual ACE data.  This causes a ~8 MB allocation (not kzalloc, so
uninitialized) that the subsequent loop only partially populates, and
may also overflow the three-way size_t multiply on 32-bit kernels.

Additionally, the ACE walk loop uses the weaker
offsetof(struct smb_ace, access_req) minimum size check rather than
the minimum valid on-wire ACE size, and does not reject ACEs whose
declared size is below the minimum.

Reproduced on UML + KASAN + LOCKDEP against the real ksmbd code path.
A legitimate mount.cifs client creates a parent directory over SMB
(ksmbd writes a valid security.NTACL xattr), then the NTACL blob on
the backing filesystem is rewritten to set num_aces = 0xFFFF while
keeping the posix_acl_hash bytes intact so ksmbd_vfs_get_sd_xattr()'s
hash check still passes.  A subsequent SMB2 CREATE of a child under
that parent drives smb2_open() into smb_inherit_dacl() (share has
"vfs objects = acl_xattr" set), which fails the page allocator:

  WARNING: mm/page_alloc.c:5226 at __alloc_frozen_pages_noprof+0x46c/0x9c0
  Workqueue: ksmbd-io handle_ksmbd_work
   __alloc_frozen_pages_noprof+0x46c/0x9c0
   ___kmalloc_large_node+0x68/0x130
   __kmalloc_large_node_noprof+0x24/0x70
   __kmalloc_noprof+0x4c9/0x690
   smb_inherit_dacl+0x394/0x2430
   smb2_open+0x595d/0xabe0
   handle_ksmbd_work+0x3d3/0x1140

With the patch applied the added guard rejects the tampered value
with -EINVAL before any large allocation runs, smb2_open() falls back
to smb2_create_sd_buffer(), and the child is created with a default
SD.  No warning, no splat.

Fix by:

  1. Validating num_aces against pdacl_size using the same formula
     applied in parse_dacl().

  2. Replacing the raw kmalloc(sizeof * num_aces * 2) with
     kmalloc_array(num_aces * 2, sizeof(...)) for overflow-safe
     allocation.

  3. Tightening the per-ACE loop guard to require the minimum valid
     ACE size (offsetof(smb_ace, sid) + CIFS_SID_BASE_SIZE) and
     rejecting under-sized ACEs, matching the hardening in
     smb_check_perm_dacl() and parse_dacl().

v1 -> v2:
  - Replace the synthetic test-module splat in the changelog with a
    real-path UML + KASAN reproduction driven through mount.cifs and
    SMB2 CREATE; Namjae flagged the kcifs3_test_inherit_dacl_old name
    in v1 since it does not exist in ksmbd.
  - Drop the commit-hash citation from the code comment per Namjae's
    review; keep the parse_dacl() pointer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/smbacl.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d5943256c071..4a341c1f6630 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1105,8 +1105,24 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		goto free_parent_pntsd;
 	}
 
-	aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2,
-			    KSMBD_DEFAULT_GFP);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
+
+	/*
+	 * Validate num_aces against the DACL payload before allocating.
+	 * Each ACE must be at least as large as its fixed-size header
+	 * (up to the SID base), so num_aces cannot exceed the payload
+	 * divided by the minimum ACE size.  This mirrors the existing
+	 * check in parse_dacl().
+	 */
+	if (num_aces > aces_size / (offsetof(struct smb_ace, sid) +
+				    offsetof(struct smb_sid, sub_auth) +
+				    sizeof(__le16))) {
+		rc = -EINVAL;
+		goto free_parent_pntsd;
+	}
+
+	aces_base = kmalloc_array(num_aces * 2, sizeof(struct smb_ace),
+				  KSMBD_DEFAULT_GFP);
 	if (!aces_base) {
 		rc = -ENOMEM;
 		goto free_parent_pntsd;
@@ -1115,7 +1131,6 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	aces = (struct smb_ace *)aces_base;
 	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
 			sizeof(struct smb_acl));
-	aces_size = acl_len - sizeof(struct smb_acl);
 
 	if (pntsd_type & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
@@ -1123,11 +1138,14 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	for (i = 0; i < num_aces; i++) {
 		int pace_size;
 
-		if (offsetof(struct smb_ace, access_req) > aces_size)
+		if (aces_size < offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE)
 			break;
 
 		pace_size = le16_to_cpu(parent_aces->size);
-		if (pace_size > aces_size)
+		if (pace_size > aces_size ||
+		    pace_size < offsetof(struct smb_ace, sid) +
+				CIFS_SID_BASE_SIZE)
 			break;
 
 		aces_size -= pace_size;
-- 
2.53.0

