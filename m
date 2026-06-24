Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1F3DA7C4
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316327; cv=none; b=DRJaPwkzDlQywWTsBVishQ5KWa/eYfTgtVFAAh9uJQ9kRcV/XaWJ0ARekcNxmPsyHfBUFm7mJw/8TrbCYixrE6+4veGQ73IZelEbxtFO4OMLCq4Xf/AaM/3OOCYDWNCqLMRvpZNik6g2mobgqcG6hwKf5gKGkdpjcj2VpBZi2RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316327; c=relaxed/simple;
	bh=3z47GEc6vuhs2Fbb03C5tIvk2B4yFoiHdtLVcwfJ3sI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fd6PtvUVSY+xXC7Jp/oVFbVNxmp3eVqR4L37Bx7rFmUr59SI/YUVtT2b+jtJMTe1gTIVvM/NzT8uGcrfdOBg/QY0LiierFRFRU5PQJ7YK1/gIcJFYdAqDHtE/Ne8CSPJTAH9/slk6+6kolPuUCeAX2vulewBd4MlnS1AiyjgyrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Veq0Wcv8; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Veq0Wcv8"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-69e46524711so846806eaf.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 08:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316325; x=1782921125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ohpu6B3vtN9gi73jmy44IymSXRN7/x+rvAG1OGlFlhA=;
        b=Veq0Wcv8yCpFz/gm/n/dagxceB4DjvEnARLq60Ow0pqM2ZcBEnpVWmbWG0lHyS8xiE
         N42Nj0Q5wTtyBh5KCaLZH5XZ28xQ6LDgQ0g9/4AFT1IQO494mQ8oAR64Gr/3nKVFlDE/
         DLff+zqNVDLcA/IG/DVIHmcVpr3rjfARSqPqY6CLByytiOcPq1UCGt5dyBwSfbaiyNd+
         LFa+tXPziDy47Ko6LQ8T2G1txrvzfS1JOF6p152kcpfjdEdT9D8zhrB6j9Pr4i5Yq4fo
         1YuxYg+gKcTQvB7Fvpwux3jWH6PeZ0apyRo+46f6Hko1zVjZvpdHiPdxBVcoQ4M1mCCv
         hq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316325; x=1782921125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ohpu6B3vtN9gi73jmy44IymSXRN7/x+rvAG1OGlFlhA=;
        b=HoabcPN+YRSm3+SiYSyPqC8QvhrnO/nZCvcxrebxtBeFT+ihnQyB4s0y1ZwN9uixzn
         IkW/AG2+eW59vxrtQmcpi1D+j5uMzuIvVNvPQnZJbNM41eZnhQnFNroMPKIiduYsxCCn
         B29zTfzdMvmFLivWpdT9gLxpp1tlnNctu3+Tm4VPtO+j2g2PfPok61dJVLdh85/csNng
         tqetixp4kcgKEWgrwmtC5dP7EhLoCLur+X8zrzlfR+vNYu1TdBbU8AG/YPmTCRV51GR9
         1EPF5a1+ikKpYDDoMqzcM2HCi74EjGT5C60T+wy1MHjtVtgrMzFbP9+MN72CAByhAGPy
         ke4A==
X-Gm-Message-State: AOJu0Yx20zx5P/aON6ylBsl8DRWEOsk/nmLl4zu6TETHsbBSQsT2BfCP
	hi/vLKg5liPxEA9A6/ePk5pH4UCbceMl8kbpZTNsyUbfq8GBnXeHT9mn7h0QslYY
X-Gm-Gg: AfdE7clntOLcborSpcgjHYWesSuoaN+L4pKydvAA6xvRjfmp37QtFwfTjTOLwfpfKec
	0RJ/eY9mMBnc00WPVj3mBaBUz6LP9OX5zBpxXTw/Wn7h18MOWxN3cRtvha9rG/76R6kl5lobOYf
	35mfKdTUfcBZq0E3yxxHXERz9Xf4zQpiWbqfyv1SFYcbby1r0iXHVGmwYbHgnTRHBZUsmKgTust
	1qbb1I+3PhA6bhILjFxlMYiGP0iO5qmCv/L47fjPr5vw0Dz/+Mluj0nWMekB7Oo2tSCaLtAnQdE
	watRhnpyO4r6TaO8rVanrHyye6pjx2C9jegEbCWSz175CSRmt9TA6bJaWlR1YrHvCmqwvJ3fVTR
	NeXq+e5bWLUr9BUWO5/zth/dNMZX16Ged/OI3572v89Q7gZcUa6ISs76i+vLy2iRV4WE6LWnnN3
	T/L5zCyDZVqB+quRrggqq1sTg6x6BVK9IqXqIDgG34/bhajMXNmks2IpB5lr9aRITBnvyNob0Sz
	L/QMER2MTJeRhgMFMd7ficsRXrK8pC+GWmAaTeYYg+PJcFfkr897RXBHnjHxk3wCRc4j024xrJ2
	X4c6JOHIPxNNUhMGF/mL/tWK
X-Received: by 2002:a05:6820:2222:b0:69e:9c80:2fa0 with SMTP id 006d021491bc7-6a1230575c0mr2414262eaf.17.1782316325393;
        Wed, 24 Jun 2026 08:52:05 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:bb6a:cc:8476:e810])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44778b6159fsm7236956fac.11.2026.06.24.08.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:52:04 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 1/2] smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()
Date: Wed, 24 Jun 2026 10:51:23 -0500
Message-ID: <20260624155124.4121786-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ralph Boehme <slow@samba.org>

Refactor the control flow in id_mode_to_cifs_acl() to reduce nesting and
prevent error code overwriting.

Instead of wrapping the call to ops->set_acl() in a conditional block,
introduce early exits (goto id_mode_to_cifs_acl_exit) when build_sec_desc()
fails or ops->set_acl is NULL. This ensures that any actual error returned
by build_sec_desc() is not overwritten with -EOPNOTSUPP.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifsacl.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 42a3115359da..5bbf73736358 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1834,14 +1834,18 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 
 	cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
 
-	if (ops->set_acl == NULL)
-		rc = -EOPNOTSUPP;
+	if (rc != 0)
+		goto id_mode_to_cifs_acl_exit;
 
-	if (!rc) {
-		/* Set the security descriptor */
-		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
-		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+	if (ops->set_acl == NULL) {
+		rc = -EOPNOTSUPP;
+		goto id_mode_to_cifs_acl_exit;
 	}
+
+	/* Set the security descriptor */
+	rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
+	cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+
 id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 
-- 
2.53.0

