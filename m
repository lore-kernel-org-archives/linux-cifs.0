Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1933C09E3
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756833; cv=none; b=bfaDws2Xm+rVq9VHNkg+MUUYCmaP1j3xQYumWz0MMa4wlpYv7OvLKM1J74ii7ZMT1L9yBKOMqbWRHaKLbqT7Ezm+EWi5NFbLSowpGCuDX0gqCl0FhNCxusk28gWVCFIMTJz890lQfCvEVIaf6KzhKUmVx0l4YgMCPmaJlNGwoH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756833; c=relaxed/simple;
	bh=hEY2HRreamE/YA2RX0wgyIgP1LV/LrBrlpnazREm/jU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aSm/5zATBB4PtlOxvnbA2LDDvXlZ0lnQfZZ+ZxTK+c8M3XrYDSCgpvic7DrS4g6bdHVvhY5eoi5mGF+UqeCnn9OacbJAnlkoUPYnQ5FOIBVRgaxiP9vnufsY/cnYOGCSxo4R6PQeRdopmGkjDZgYQhHf+hkRVREqv6cFJuwEMU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRSBpsdt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lGteJy58; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRSBpsdt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lGteJy58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787756830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=M9X3mqmMZZCgAFI5YZpLmbFBmE4E/5EF49kLTlE8ThQ=;
	b=FRSBpsdtN+kvkraHGKbTFPmg2PX97fGArd6jqpwH8WNBdElgXV36GfCrGFxeacR6EcFhE/
	lcYi31qF+ffbKrLPCW7i7jp+G7sbDfePR/kpuM+0fQ6QjguovHlmU3+rrFIryjMCyFI/0I
	Ek8w7xOgcg1NdF59tdU13LGWrIAI3ds=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-Kl9eKyOPP16ffcHH8nZM5Q-1; Wed, 26 Aug 2026 11:07:08 -0400
X-MC-Unique: Kl9eKyOPP16ffcHH8nZM5Q-1
X-Mimecast-MFC-AGG-ID: Kl9eKyOPP16ffcHH8nZM5Q_1787756828
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-857d9ee8a5dso31230837b3.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787756828; x=1788361628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M9X3mqmMZZCgAFI5YZpLmbFBmE4E/5EF49kLTlE8ThQ=;
        b=lGteJy58z9Pc4NiH6tIGc/lmwl5ZGin8U3VjY0gJd8E4nKZKQFIPzQs3iWCBNx6I3r
         Y8ksI2ON7l+/PLcxuwPLf3vmyjLPnTzt4CIHDFV0ysCEVw/AFeo57dClkcC7x0aSNoKb
         0Ubvk4Po8zbbRJHvhJfNdciJ5pJLHd9fbEIFMBdkfDxhL+2US4hf6Ly1Q+H4THY5f3/R
         M/0488lRn2/6dAr0gFR9jzUjx46VSW5CEpEUvG0CUvZRH+Vf63pP7GbH5/RNxQw3Ztig
         HZLWbdPWLAP1DF/40yggWTQj6tRhftAbYJcU3a5RKn5zge7O8Bo16pFmfyRHgoIrtaxG
         1fFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787756828; x=1788361628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M9X3mqmMZZCgAFI5YZpLmbFBmE4E/5EF49kLTlE8ThQ=;
        b=T0xkNbgbRuVTN8J4ZTJSx1IZ1S4/ljDFbQCogD7v91DWI5IkgH8omM9X0AFEcM7NK2
         fnQ0V/pzQ67V20TaQS4IA7ZYvigaz3SU+y+TpyTnslaLGU98cgAGxv2T5gwwzJxlvwhH
         UwXQf4WIqhsWuBfeYhEssL5flpGTWF6eBK3BmEXTiipVv8dH8CXm5P8ND8fdWL2NWHPS
         ZOwe/GDUlidwlxUkWyXEpI+chohP2KEkP5ByI/vpNHEg1jpD7clu6Ur46V81WrpTtNQb
         4dtEUPEoXzxe+JXIYMeqCyq0Xqg0bLRsyubgFTRFvEJ1mSPmY5yT9eVUejMehPO/6TuC
         SUgw==
X-Gm-Message-State: AFuF++l2SJ17gVycP97Uxr13G73tGS1Z5j9vdZfOHD5/wPj/OR5AxiQj
	4IyR8Dc8NyW6COt/+6ZP6gpjJCI14XC1fKouDh8w3ho4AloGTSCdYI18IEyF/nZCvPCHLnBdpVq
	1Ha6mywZzHXECPbNkG/Cld+oM2kcqlGAG5hCMGS1eUbQ6U2qvHz8Dln9+nEjj7Rsv2Z1aTl/UWz
	k9rUSc4qGZoSK3Y6R+eHxP8gthb/MCjCRKRWLH6KsnYRva4Aw=
X-Gm-Gg: AR+sD12T15JCgVSX++iC+zfJ9OxTHovDyQ2isjaRdOMrKA538ZgqJfqsX3IkJkkCBZQ
	Dh6U7na41qKa7i1xv5g54zeTROJNtTaTYjHInIWpK7E1L/fks2uX3fQ0TXFlDPlEHehBO7SMcgM
	MR/8tra+RjTamcaP+fwnAIXN/W7X1C7r2aBd/hZ5lTlsJN4N3FXWJCNK0BEC2Hu/rkvC2G7BPnV
	ZLd5DCltYNPUBNXc/Eut5cOs+Cb4kdmtmcb1UnsYiZaXYlExZXJm+vIUkc5A1iykspzxxaJ0K4H
	N7dXSsdVsnS5ZPDpN4Mt8p9vglCUWLoE7GcwdFj3BJ5k71UR+zPD9RWYQttjjSpsQDHo8FEInof
	nDY9LQo22RHD/1FqoOnaWDkbYG6SD0JAqYgcJoLnAHIkrV/tau6r5YyiFkMrSy/EQIA==
X-Received: by 2002:a05:690c:4026:b0:836:ec9b:b468 with SMTP id 00721157ae682-85741d088damr27003487b3.34.1787756826999;
        Wed, 26 Aug 2026 08:07:06 -0700 (PDT)
X-Received: by 2002:a05:690c:4026:b0:836:ec9b:b468 with SMTP id 00721157ae682-85741d088damr27002427b3.34.1787756826196;
        Wed, 26 Aug 2026 08:07:06 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-857069009b3sm17968927b3.18.2026.08.26.08.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:07:05 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Wed, 26 Aug 2026 10:06:43 -0500
Message-ID: <20260826150643.4106838-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_set_acl() validates ACL size using posix_acl_xattr_size():

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

An ACL that passes the xattr-based check in cifs_set_acl() can
overflow the heap when posix_acl_to_cifs() writes the larger CIFS
format.

Validate the CIFS format size against the remaining buffer space and
USHRT_MAX before converting--data_count is __u16, so sizes above
USHRT_MAX truncate the on-wire packet length, causing the server to
apply a partial ACL.  Replace MaxDataCount = 1000 with
min(CIFSMaxBufSize, USHRT_MAX).

Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
v3 changes:
 - change header size to use MAX_HEADER_SIZE helper

v2 changes:
 - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
   with more than 6553 entries, which would cause a partial ACL to be
   silently applied on the server
 - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)

 fs/smb/client/cifssmb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..230af243247c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	parm_data = ((char *)pSMB) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_HEADER_SIZE(tcon->ses->server)) - offset;
+	if (cifs_acl_size > bytes_available || cifs_acl_size > USHRT_MAX) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 
-- 
2.55.0

