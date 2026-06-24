Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99C3DB303
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316332; cv=none; b=Te0bE5/VAdwr7EmcULCCrWxE8P2tWYjhsle5RgYfZQdknyPPC3348ynwSfsL+bcQrqWmZyE/cd7PxlYt5UiHvyQzoTmEbea3Ri6SFFrp0BxUxZgB+yuH1fS9rpZp61IjnJlU/6jpXxssqU8sXbWxKTr4xXhRpCnGji70tJwbVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316332; c=relaxed/simple;
	bh=G9z98vYPOk3D5FCPWDuKfsvwk1w7DHY2V8jSZCvm7fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNrLVbCGM2mu+eADgMqct9GObdLL9H3GlLvruD+Zko6yBEjI1boSoz9FEQVrla0ZMaWVgFPpVkZtvW3O2Sqj4BWi1tw/gJ5tIX+mxqz7jjs4fi++P63pAeM3gsF6J62d+y9KUG8cIphttXX/yp5G7C8rxtaCojS3MnrKGIwBqvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqpvBJr1; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqpvBJr1"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6a0b1edbe32so918834eaf.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 08:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316330; x=1782921130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5pBuPJKt7xlOcxOL/pObPY8PyN7Xoy7bhHvVNhyY3IM=;
        b=iqpvBJr1vokWx70QMAQxfhvjF5hJv4XUk4ycjX4z50wc2d0aG/XrrWc6xnYFm8eJMc
         IyE9iq89zLfUnq4cjcp7AJUWpdSGqDq5khuKQs0qkPx2ujVBOISxLjloOFebpmIS/TxP
         bi5ZYmaIWnktc3awyvsfA3liM8VgAVxnz2AsHK2xySj385kSTu8hoFsQ7DI70tB79DeK
         aZQVVVtb13ts0UrQyS47Gy+ji2SEsrjXP9Hh6KQwbh49nZwmLeBUYyuycCveAQ9/8Su9
         0GX3kWfgzaOAe3iBFesF7ko2IWFBqtMFsQvYsIUA7gtjv9FcHd54veYKdL7dBrGFGcuH
         gFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316330; x=1782921130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5pBuPJKt7xlOcxOL/pObPY8PyN7Xoy7bhHvVNhyY3IM=;
        b=ZA5xUZpiPoTQw1a2dv0Na+g1+CrfKYgA+vOs5JBFxUfy2e4H4YEn0ZdF1WrFZ2cXzN
         /EXmHrKh+ztEoYVglzGIrpjuUVkCZak891ic6fLYnTptNB5Kd0lZ3Mo6Q6u8hBGKRfMn
         KeNpFq2ELfOcVa0gayO2JLiIoqtLcGtKlF3UDQ08kqbo50xPiCVzSqhvkGvGaSVBGT2N
         D2An6eVTvJWKgAiAJRRIzJPuCf9uy12ljwpmQBwKJRMAFNeKPK8kNsTdT3cYo93fwPuB
         dbWSaMkEQ/P3ObI9Inh74A1YrePrEWgEBYGWPZtLf/OsKDaEYNE9FgfECIfNrdbda0hb
         RwBQ==
X-Gm-Message-State: AOJu0YyQQ90c2U3QO6TOyrlsioXxjIC+uOwhOWTUNWm/G+rD52/SNQgq
	FZpfIf1gdrMMO/FRJED/Q2bD57Oxl9B6TJwYkkLvklgdf281NQbjdwdNJ58AVcRV
X-Gm-Gg: AfdE7cmQKJMAsrqwnnQtk4B76WbnjCx7kZONiXqZbf4rUi9UzRlpe2l4AGkfPtqQihY
	hcXUFjnTDgfNS5y9xxCif+/DVJmGOyd2JJxcl+q5nZq6EE64jhDb4tNASMzlWmBG5rFdWQwdsGN
	6zv9JXYznIvUbZHw/Qa9N1QOt4G5EKW8sljEbBCEsOAetOYEzudiswen265OjLhkqKm3kyiYKMT
	E32I0dE0qu6lgc5i40uGb6640my0z4b8VhgwqkN+6FmQYnhduFkTGwLREFf/zk2Ty/Ntu+QcaBP
	jEfik4Ab1JPZ/bJBF9ixtXgWfNaGwQmR4wenTLo/4bWlaCjSsywxDcVRbvNfeBz56PvzzMgzOI4
	1TZKkikcOkv3OkBRw1qODPGSBl2clVobBQt2FiYGUdnOe+XJXY+iDVm3mqXaQNVYOUolwp1BM7u
	j5MJBaKLhZsOSD7Aob/9wVOobor+WRjkuhWQsXWcofNOwM5MD13vdCsFLLXSrTz9zvVCw8+1m/E
	5UOXIHnq+6ghkTse/f5RDOXV2FZRbF1RuSTsaW0ZlOF6EJ7dBkSqLMcyziSw4PeP0TqImJmBoH1
	owvKtaf7dZiKh1mIq/IvaJxI
X-Received: by 2002:a4a:ee84:0:b0:69e:3e2a:a838 with SMTP id 006d021491bc7-6a114cc9513mr5090021eaf.52.1782316329917;
        Wed, 24 Jun 2026 08:52:09 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:bb6a:cc:8476:e810])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44778b6159fsm7236956fac.11.2026.06.24.08.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:52:09 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 2/2] smb/client: fix security flag calculation when setting security descriptors
Date: Wed, 24 Jun 2026 10:51:24 -0500
Message-ID: <20260624155124.4121786-2-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624155124.4121786-1-stfrench@microsoft.com>
References: <20260624155124.4121786-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ralph Boehme <slow@samba.org>

In id_mode_to_cifs_acl(), aclflag was initialized to CIFS_ACL_DACL by default.
This forced the client to request setting the DACL even when only an ownership
(chown) or group (chgrp) change was being performed.

Let build_sec_desc() do the proper flag calculation by initializing aclflag
to 0. build_sec_desc() sets the appropriate bits (CIFS_ACL_OWNER, CIFS_ACL_GROUP,
or CIFS_ACL_DACL) depending on what actually changed. During ownership transfer,
CIFS_ACL_DACL is only set if replace_sids_and_copy_aces() actually replaces the
SIDs inside any of the DACL's ACEs.

If build_sec_desc() results in aclflag being 0 (meaning no changes were mapped),
exit early to avoid sending an empty security descriptor update to the server.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifsacl.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 5bbf73736358..07cf0e578233 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1185,7 +1185,8 @@ static void populate_new_aces(char *nacl_base,
 
 static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
 		struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		struct smb_sid *pnownersid, struct smb_sid *pngrpsid)
+		struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
+		int *aclflag)
 {
 	int i;
 	u16 size = 0;
@@ -1209,12 +1210,15 @@ static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *p
 		pntace = (struct smb_ace *) (acl_base + size);
 		pnntace = (struct smb_ace *) (nacl_base + nsize);
 
-		if (pnownersid && compare_sids(&pntace->sid, pownersid) == 0)
+		if (pnownersid && compare_sids(&pntace->sid, pownersid) == 0) {
 			ace_size = cifs_copy_ace(pnntace, pntace, pnownersid);
-		else if (pngrpsid && compare_sids(&pntace->sid, pgrpsid) == 0)
+			*aclflag |= CIFS_ACL_DACL;
+		} else if (pngrpsid && compare_sids(&pntace->sid, pgrpsid) == 0) {
 			ace_size = cifs_copy_ace(pnntace, pntace, pngrpsid);
-		else
+			*aclflag |= CIFS_ACL_DACL;
+		} else {
 			ace_size = cifs_copy_ace(pnntace, pntace, NULL);
+		}
 
 		size += le16_to_cpu(pntace->size);
 		nsize += ace_size;
@@ -1521,7 +1525,8 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 			/* Replace ACEs for old owner with new one */
 			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
 					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr);
+					nowner_sid_ptr, ngroup_sid_ptr,
+					aclflag);
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 
@@ -1738,7 +1743,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 			kuid_t uid, kgid_t gid)
 {
 	int rc = 0;
-	int aclflag = CIFS_ACL_DACL; /* default flag to set */
+	int aclflag = 0;
 	__u32 secdesclen = 0;
 	__u32 nsecdesclen = 0;
 	__u32 dacloffset = 0;
@@ -1837,6 +1842,11 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	if (rc != 0)
 		goto id_mode_to_cifs_acl_exit;
 
+	if (aclflag == 0) {
+		cifs_dbg(FYI, "set_cifs_acl aclflag=0, no change mapped\n");
+		goto id_mode_to_cifs_acl_exit;
+	}
+
 	if (ops->set_acl == NULL) {
 		rc = -EOPNOTSUPP;
 		goto id_mode_to_cifs_acl_exit;
-- 
2.53.0

