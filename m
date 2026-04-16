Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE439A80E
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 20:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776369907; cv=none; b=nVRVjTyBK6kz5hFRxat71jYJdgjoYTMDLiZO2jAc3ldmQwFUX6m7lK3fkzsN7dJQlfWaQlADD1sw4WSjJExpVWGeGTsOa7Haf4tJf0DWTu+GoAy2EnWKRL9nkFL0Wyxv0iBwX5URbeH8AJr9R6x5Hskhqhbabnu0EURZvkxn3q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776369907; c=relaxed/simple;
	bh=A4WGfbNBFS+TdPdlv/yvtGkWO3BanuhGpctzicatogg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h6V8aZS5N+GF5JvMy6g+Eb7dDwwdAosp5nZcegXooRJjDpLUqxPK/fhbKYXjhsFId0lYezp3bDW4GYy+GqsvjCMD53EJkz3wxACOj96uBYCu64ohecZWOEhwTcrVZc9R6TMkBSTBiPMG2o+jcQmSBmP+igbSnaz75813TF+My5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eLNWkov4; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eLNWkov4"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7b186dfc1d0so17608057b3.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 13:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776369899; x=1776974699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AiiYXSwG5ruRWxUExLzY5qAI02mOLD9DcmFtQKqN3Hw=;
        b=eLNWkov4H05Og4pWFrsxQ/DAKPjhjqj2CgcKZRmNGVUU5niWTO80IsxxqsYkj+Y5sx
         0r6VpOl+pSbybxQDaBs3A+VplPsPGC+iBd8qfwgxMB/4697t51Q6EjQ46+957Vvezw3e
         uPzYjQYpnOJ3/VOS6cPVNDz3+LHdsrdqBqBOsfJx5FvbdB1ccGsZIV+uWEVByebV3tAi
         I8HXuclvegWdSHJR+3Mruhz45IJnaKGiu8glT0dtMVfrpq8Sj+VVFKQNS4RuXpajlYxD
         6kMrWk9a3e1Wx3jhzI4UijZRHFlglc3j7TKEb//m2R+aaB87jqJIJIiLi/hNCKutikPx
         xnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776369899; x=1776974699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiiYXSwG5ruRWxUExLzY5qAI02mOLD9DcmFtQKqN3Hw=;
        b=tDMaTK9419rer6wdJVvKVow3LnlRtH2dhCx28c0YRBuimNjFXdtLdnWQffLNRfHRHV
         P6xgH7xsGfHgFAb984muK8RVwvkuWS/QNfcb+gmcoRBhce1eefun0CGoZKBoPfofQSgx
         H4hLa80lTEs13xMNRfr3h1ckVh00gfC/63XiYH5qAF5mR94WzVZ1RL/56JVdzPa+TqLo
         4mY8hyPz3Cge1CUqLipBBcFNcxNptvpr8NvcX5BHJpH2TyJxUr78rPZGxFwmyNBuEyOz
         wJJtzMYjhofySrOJxRcbVXSAy26/I6ZE6SfOIrUPBdp4SniAka+0uXaBxRiUM933yFrW
         hsMA==
X-Forwarded-Encrypted: i=1; AFNElJ96LbMvRcLJXBq9Z5ezSZX3po6LrMlUKvrgxo9KHCU7MKdnokZzyud/wQM+8EbehKPhDCduAqpYInrb@vger.kernel.org
X-Gm-Message-State: AOJu0YzWC4a/NErliPdCRXT6xL5+u/s6EdxCsQcp8k2YG6S1qC5vJrq9
	rtGx5DyKVVHBvTYIJpheo7HHwgZVE92Er18l33OSXnOFnv02AJ6OUQ7Q
X-Gm-Gg: AeBDiestdHhTDgeCJjLN4bvoePxp2rI9D34x2kNmrQfTPwDhF1AjouXqKFVbVQN5zdd
	2Yze6Z894bCNOTaTQmVhXxLYNycvjTkT+kY9wQrj8eGhoOwz6o92TadTJcRRb1yIhjIp8CRF0QL
	EJ7VvQgnrrH1YINH9BGwV3lSsE2u1CXfT1kaKLR40t+rtadCakko09rQKRJoNQ+XCT+O6n8Rpk/
	6Hu1AlZVXl5BNXFf71NFKUSUCTzNbw7IkJ4GwvOf4LDPiN4TQ0BJZMurz+V7J2Zda0pE93p4ja3
	oyGnSVpXuSFaFGND7oo2PvxQlGGqscaz1RhijiUgCfeECCKx3/GKVde7DWuoE+i69vNJnAVxSiP
	wC/cWnuJwJfxw5hFanU4hbiYjftwD5vgXSIIiDSmjwomvzS30ZOwac3Y5zg56WV98pfZ6qSymoe
	ekzmH1nUjPimNqlRr8TIIRzLHUZMnjB7PXYFu61jMOPbZmXpnx1oI4AVJEy3bSKKT8ViDvFMrsD
	xG3FsV9mN1uXtHikhZXb6O+6CsdTI/9+mSq6WInRkH6h7wZ5V5lPU3NKsC0d1is
X-Received: by 2002:a05:690c:86:b0:7b0:3180:e827 with SMTP id 00721157ae682-7b9d8195b11mr5990557b3.22.1776369899204;
        Thu, 16 Apr 2026 13:04:59 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e640504254sm208810585a.28.2026.04.16.13.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:04:58 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
Date: Thu, 16 Apr 2026 16:04:39 -0400
Message-ID: <20260416200439.2987930-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another one on the smbd side this time. smb_inherit_dacl() trusts
the on-disk num_aces value from the parent directory's DACL xattr
and uses it to size a heap allocation:

  aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2, ...);

num_aces is a u16 read from le16_to_cpu(parent_pdacl->num_aces)
without checking that it is consistent with the declared pdacl_size.
An authenticated client that can set a crafted DACL on a parent
directory can declare num_aces = 65535 while providing minimal actual
ACE data.  This causes a ~2.6 MB allocation (not kzalloc, so
uninitialized) that the subsequent loop only partially populates, and
may also overflow the three-way size_t multiply on 32-bit kernels.

Additionally, the ACE walk loop uses the weaker
offsetof(struct smb_ace, access_req) minimum size check rather than
the minimum valid on-wire ACE size, and does not reject ACEs whose
declared size is below the minimum.

Reproduced the ACE walk OOB under UML + KASAN by constructing a
12-byte DACL (smb_acl(8) + 4-byte undersized ACE with size=4,
num_aces=1).  The old 4-byte guard passes, then reading
ace->access_req at offset 4 within the ACE triggers:

  BUG: KASAN: slab-out-of-bounds in kcifs3_test_inherit_dacl_old
  Read of size 4 at addr ... by task mount.nfs4/220

Confirmed clean exit without splat after patch applied: the new
16-byte minimum (offsetof(smb_ace, sid) + CIFS_SID_BASE_SIZE)
rejects the undersized ACE before any field read.

Fix by:

  1. Validating num_aces against pdacl_size using the same formula
     applied in parse_dacl() by commit 1b8b67f3c5e5169535e2
     ("ksmbd: fix incorrect validation for num_aces field of
     smb_acl").

  2. Replacing the raw kmalloc(sizeof * num_aces * 2) with
     kmalloc_array(num_aces * 2, sizeof(...)) for overflow-safe
     allocation.

  3. Tightening the per-ACE loop guard to require the minimum valid
     ACE size (offsetof(smb_ace, sid) + CIFS_SID_BASE_SIZE) and
     rejecting under-sized ACEs, matching the hardening in
     smb_check_perm_dacl() and parse_dacl().

Let me know if you want 2/2 instead of this single patch.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/smbacl.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d5943256c071..fc4fcd48d6c9 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1105,8 +1105,25 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
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
+	 * divided by the minimum ACE size.  This mirrors the check in
+	 * parse_dacl() added by commit 1b8b67f3c5e5 ("ksmbd: fix
+	 * incorrect validation for num_aces field of smb_acl").
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
@@ -1115,7 +1132,6 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	aces = (struct smb_ace *)aces_base;
 	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
 			sizeof(struct smb_acl));
-	aces_size = acl_len - sizeof(struct smb_acl);
 
 	if (pntsd_type & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
@@ -1123,11 +1139,14 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
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

