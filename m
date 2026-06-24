Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739126ED40
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782315658; cv=none; b=hvFdmMaFDFbLdbmO6zX/gZ+jtJsgCt1aDfsXl9LrDprl4SNCLNmTVqIm89ZfyikvNBKXn7ahuqdbg5hywViarxxOOUa3HSokvaTRGhNAH8NXdJ7xx2Mj6QBt1+G0xjQ/1bhPzeEliv4aSBTH+EQsqs60OutZOwXnlakgywl2RpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782315658; c=relaxed/simple;
	bh=RkhFzjZ1KDcJGmZnaXU0DUenHaNwBdcog1tOqKNmSvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RbZ53ceiefHVq/E8LkH38MPqiOg365xa0054tCPIIobeJE69SNvpvktxaK3n6llbekQIjmyKORqQfdBV8T1HOHe0/RVufOK6xF/ikObZ6GXFrlACZVLFVJoOHWe5vCofMT0hQks+Xlnd2ORwhu1SbRMVQZ8RF6DaCKsIpcF9Bpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hp+wYz1v; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hp+wYz1v"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43d3a0dabb0so869558fac.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782315656; x=1782920456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=78mRdh1mEx61ytzaAK9I7LUczYicHaKCWwTKpTIR4e8=;
        b=hp+wYz1vTV3F6z611t8FzP6V0V4FAsN3kPzBjA5HAw/Hw12uNeOraPWLwFkHXCjQ97
         1jMGC1q/Z7sxxr1jWrRp1MlrjlVEgDKlqG/pspKUB+oDlr1ihTTZhYadnFcmBfrEmzf+
         d4TOJLucTwfhCXCswecjkxBmPd4kSX262QoTIB27M0AohBZlSM4aRPU7pfF7+z+aQ7St
         msx2a+/TKdHbJDuRcbXPiou6SDVKw/DxeyWVMTcQ9WCDut6uF9jFHok+sUQhKHwiCBDc
         aZdUf9GW8StdCy2Lu99SJ8KPCroP+1hiNC9YKesSN6x6lPQBfxs1/FYmrr2xrX/hOoWy
         q+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782315656; x=1782920456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78mRdh1mEx61ytzaAK9I7LUczYicHaKCWwTKpTIR4e8=;
        b=jY0Rv7tOR1nBmec3uSH+aqDriQSV2BSqmRyjEuquXTxKSCGffG9D/4dmqqbfhnTOpf
         lMgKQ0hJ0GvUkw10u+yQsd8qFgJFd5JHTmLVl/w+cmryg9QLOS8+d3mM3C65pooyainA
         oYdwEiwabbMjPmD52GSeJYZQNyThm0MNLdRix507jXazyePqEcTvZ2NfEpIXiF6WSv+v
         hIgT/Q5OsJI7Z0V1NHH5BC4FipJSC+jeVe14ucR3ZGM54N3gNLJGMj/bRbqtaFD+2ABK
         DjKzcotvxOnTYvQT/eQdx2nLfU2n0Fh8YuIhXjN8+DWi7KqwIgEo+BTw69HyI+OM8GdX
         TCpQ==
X-Gm-Message-State: AOJu0Yx8fWdb/EFOewM974hC5zNZl5bykjVmkb1ehQnyy1MqvUt2vRWu
	MOmzpH+w6e+F6abnS5Zo2CgwQqxTNOBz7/pm6kGs0gMboHJqBMcRj2rRvMD/hpRF
X-Gm-Gg: AfdE7ckBuHuKi//xzyP2rPmjJtdQhbYUoDre+H+chmZ+CvostnX5Gdw+R2/flXQeXjq
	RZiBRe4u+z1YZmQVPguJoJ4terbLBUTPykPGYsvcGjX+4xF95jO/pg18bOxweLX99t63eUWrgt4
	/CdjGQiYBysJ77i0lcZGonPNMwQbYjxQGFrRm5T5NhKfO3mwDWB1AiwpM0qmFIbnLx7m3pgnR0P
	Ei4IuFG3c5260NNJuK2UIww10aG8+EvE4hvcNbxF0HVn187pidTnFkuiBe3nJ6wdVHJsWDYYTzU
	Xok1hfDtwv5XHD9oJJRAosWUyvLJw8cAyiU4NQP/EgECNl142wPWtGUCpfi8R4KCkojJorN/ao8
	97QHFMwcJMwHQJrzeFHRHt0/PApWbgfdr0CWJ+RzMJBuy63ctVIHvoW25bgeHatC8Zbv83VDWpj
	PKZtcPeGFmUJA76o3KOGzXuEv/ClkxQW1+Is2k+WtgrzXbOTUhWw1ViJSWDYlBBzi5viUb+8BC4
	tNxw1l3PaUi9tYiS3yA07T+yPcD0S4Dqi7Yq0lB8VqQO9z0HmM9oBKpEcnCCmAEKDMgoJ962+lx
	tQ3AAD2vJy+VMa+aR2GY2SsL
X-Received: by 2002:a05:6870:f28d:b0:42f:d3f1:6b7b with SMTP id 586e51a60fabf-447dc9b8d2dmr2725471fac.21.1782315656112;
        Wed, 24 Jun 2026 08:40:56 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:bb6a:cc:8476:e810])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ec5fd4csm11024511fac.2.2026.06.24.08.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:40:55 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Subject: [PATCH] smb/client: fix security flag calculation when setting security descriptors
Date: Wed, 24 Jun 2026 10:40:48 -0500
Message-ID: <20260624154048.4119379-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
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
---
 fs/smb/client/cifsacl.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index d90b3ac45ce4..0856c7da2054 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1112,7 +1112,8 @@ static void populate_new_aces(char *nacl_base,
 
 static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
 		struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		struct smb_sid *pnownersid, struct smb_sid *pngrpsid)
+		struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
+		int *aclflag)
 {
 	int i;
 	u16 size = 0;
@@ -1136,12 +1137,15 @@ static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *p
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
@@ -1461,7 +1465,8 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 			/* Replace ACEs for old owner with new one */
 			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
 					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr);
+					nowner_sid_ptr, ngroup_sid_ptr,
+					aclflag);
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 
@@ -1676,7 +1681,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 			kuid_t uid, kgid_t gid)
 {
 	int rc = 0;
-	int aclflag = CIFS_ACL_DACL; /* default flag to set */
+	int aclflag = 0;
 	__u32 secdesclen = 0;
 	__u32 nsecdesclen = 0;
 	__u32 dacloffset = 0;
@@ -1775,6 +1780,11 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
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
2.54.0

