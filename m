Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4C321445
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 02:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779158185; cv=none; b=OgHZLJ1IqJ6niSefqfB9AghDJ5QopWmJFhvsVQbHo3l1MEmmDf4I2EXn21Jq/XsZ+zQMuROy2V6aovwYw4TSX/Fy/39NZQdXXt9iAX1+TJg8H+G16aCle0AoYl0ydvBVrQpqH3VLvcdKQp0tFt8kNpHZyOopyf9ItH0FsMmFpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779158185; c=relaxed/simple;
	bh=7pZcMxtxzu/bRg5te1nwynymGwXT/TI6ZsqMrqGcugo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VUNlYcA86VN3hecoP3cymTehgx5lkumgbI3w07FGDi4Bvn848I6a2vfrpb0FXj/2OdVYBaZ9rsODfbdow42e98OgjYSknj1iORF+8WQ7RYyIOYzKexe1g6imYcGyipZEkIheV5rAhGDQVy1weNXSQ9rbuWQLEh7cJBMM8Un+KDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVOZIPTp; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVOZIPTp"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-369372b3175so509915a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 19:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779158183; x=1779762983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lS9dH1OelCMRsVnf44bVJPX1fdqjrsY93PUhw+f8dko=;
        b=dVOZIPTpmtt4v1j1OloBkZyiJ4Auh+uA6YgA3zB8tx7eXj/NoUMPREELpIejw6xHI5
         7Zc4/k74InLWpSdr7bPO4cFRR6a+6dOX3MfhAEOU3Fsj7PcUma8tmleVysPiiiBGj45m
         2vp9Qd9WmpY+Qg4Gfw27SCSum3nGJRcjIR47zTnFHFakuyiT3afLt5ZL+aWHsqQAbkEf
         RuW3C3UCk+PWSJCfZDcUdfs6H8u+1RX96dRYuz8CKZkWXKQ5c08iT60aQJ+TLnlElqlY
         CnVNU/gCebQPtHdQFVvLXXFlJ/7sdPWXQmIGzJPhZLSJR8JR+BdKmUHLQFlvHjqIWLJu
         VMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779158183; x=1779762983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lS9dH1OelCMRsVnf44bVJPX1fdqjrsY93PUhw+f8dko=;
        b=IstK/gpn6IWWr9k9OxPbmpIKhebzNVBVSooji57taQTQCCV3F+4IWkXCfTW+r+UVzi
         Ns923cQew8cbrfwKvxVA/KhIeNroS+ofdG6pFU5eostopXP90f/KU032JAajgfo0FLmA
         TipSVKLCiMVxUrpq31wsbqdB6qihambgHHD5FF+fyyyTfWWvTLJvdtTlrtcSOruK7+6M
         llzKBxlY0Jyv17deGkRwFoVKYtbmdeTlevYrFBUEEr2G5ldmy2GC4ukvXBrXxpq3obip
         KedpoToHfJQ6AqwLx9Dln2wocRrfFYituKS5QeQGC8JSKxX8Xr45nlg+vedeDqHjhVhu
         +Gyg==
X-Gm-Message-State: AOJu0YzREmObpl9s0AQlCfKDl4d8wDb49zW2N9fnNp/2QN0c5u6tjYjW
	A6N4SUZNQv6+3lf8xqnjBO/d+qQrsEKOHSIPBaNuTNIqjYZUrrJF4iM2Kw5OmkT8OtE=
X-Gm-Gg: Acq92OFv1uqQAQDJ2vilJke2iH7Vd6xC+qoFjMybP28v8hhAAaWzZ1l9E5N/5hln4sJ
	syZWdOX8z9yTnuM57/BePSlnLK7AuPmjpHpp9gNgOz2hW8soiDHhesI7FFM5DMDua/lz37x/u0C
	NGgH4Q6e5MqHOcfhrsjOd+Y0+svlCUwFrOW0JYUE2H0a7zkqF9i/Ne36fwsRnRvbUCtv/aFJzCo
	4qxAbLP8QU/HtxPxP1N/0R15UtOdvpZliHUp6pU+RddBYyo1uLPHTWjMf1Vuoc8CqwzRZvByuZy
	BFlPPiVd/P8zep3G6MrX/Q+4DtnoHiQlH8hJdvG7u3PwXFhE4FuLdavq4Ska830Nbn15rt00Hdl
	452TZhBCMlukMN/Sv6a6gJ1BjxMoJSTcLB2Y32g0WwXrGEGqh0uWrBb2I42tbCz4nC38bA3fbIM
	J2KfX6LMpPuAp/MPomTyGUlgqLpEAYl6+bcbZRUPrYs8FWPcewHBFYXA==
X-Received: by 2002:a17:90b:1dc2:b0:364:6f0d:c0fc with SMTP id 98e67ed59e1d1-36951dd052cmr10175582a91.7.1779158183069;
        Mon, 18 May 2026 19:36:23 -0700 (PDT)
Received: from localhost.localdomain ([139.159.170.72])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3695155b2c4sm12470390a91.3.2026.05.18.19.36.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 May 2026 19:36:22 -0700 (PDT)
From: Qihang <q.h.hack.winter@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	smfrench@gmail.com,
	gregkh@linuxfoundation.org
Subject: [RFC PATCH] cifs: validate full SID length in security descriptors
Date: Tue, 19 May 2026 10:36:18 +0800
Message-Id: <20260519023618.73569-1-q.h.hack.winter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_sid() only verified that the fixed SID header fit in the
returned security descriptor, but did not verify that the full SID
body described by num_subauth was present.

A malicious server can return a truncated owner or group SID whose
header lies within the descriptor buffer while sub_auth[] extends
past the end of the allocation, leading to an out-of-bounds read
when the client later parses or copies that SID.

Validate the full SID body in parse_sid(), centralize owner/group SID
lookup and bounds checking in sid_from_sd(), and use that validation
in parse_sec_desc(), build_sec_desc(), and copy_sec_desc() before
sub_auth[] is accessed.

Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
---
 fs/smb/client/cifsacl.c | 196 ++++++++++++++++++++++++++--------------
 1 file changed, 129 insertions(+), 67 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 786dbbc43c5b..42a3115359da 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -275,6 +275,73 @@ cifs_copy_sid(struct smb_sid *dst, const struct smb_sid *src)
 	return size;
 }
 
+static int parse_sid(const struct smb_sid *psid, const char *end_of_acl)
+{
+	unsigned int sid_len;
+
+	/* SID must contain the fixed header before num_subauth is trusted. */
+	if (end_of_acl < (const char *)psid + CIFS_SID_BASE_SIZE) {
+		cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
+		return -EINVAL;
+	}
+	if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES) {
+		cifs_dbg(VFS, "SID contains too many subauthorities %u\n",
+			 psid->num_subauth);
+		return -EINVAL;
+	}
+
+	sid_len = CIFS_SID_BASE_SIZE + psid->num_subauth * sizeof(__le32);
+	if (end_of_acl < (const char *)psid + sid_len) {
+		cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
+		return -EINVAL;
+	}
+
+#ifdef CONFIG_CIFS_DEBUG2
+	if (psid->num_subauth) {
+		int i;
+
+		cifs_dbg(FYI, "SID revision %d num_auth %d\n",
+			 psid->revision, psid->num_subauth);
+
+		for (i = 0; i < psid->num_subauth; i++) {
+			cifs_dbg(FYI, "SID sub_auth[%d]: 0x%x\n",
+				 i, le32_to_cpu(psid->sub_auth[i]));
+		}
+
+		cifs_dbg(FYI, "RID 0x%x\n",
+			 le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]));
+	}
+#endif
+
+	return 0;
+}
+
+static int sid_from_sd(const struct smb_ntsd *pntsd, __u32 secdesclen,
+		       __u32 sid_offset, struct smb_sid **sid)
+{
+	struct smb_sid *psid;
+	char *end_of_acl;
+
+	if (secdesclen < sizeof(struct smb_ntsd)) {
+		cifs_dbg(VFS, "ACL too small to parse security descriptor\n");
+		return -EINVAL;
+	}
+	end_of_acl = (char *)pntsd + secdesclen;
+
+	if (sid_offset < sizeof(struct smb_ntsd) ||
+	    sid_offset > secdesclen - CIFS_SID_BASE_SIZE) {
+		cifs_dbg(VFS, "Server returned illegal SID offset\n");
+		return -EINVAL;
+	}
+
+	psid = (struct smb_sid *)((char *)pntsd + sid_offset);
+	if (parse_sid(psid, end_of_acl))
+		return -EINVAL;
+
+	*sid = psid;
+	return 0;
+}
+
 static int
 id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
 {
@@ -515,14 +582,14 @@ exit_cifs_idmap(void)
 }
 
 /* copy ntsd, owner sid, and group sid from a security descriptor to another */
-static __u32 copy_sec_desc(const struct smb_ntsd *pntsd,
-				struct smb_ntsd *pnntsd,
-				__u32 sidsoffset,
-				struct smb_sid *pownersid,
-				struct smb_sid *pgrpsid)
+static int copy_sec_desc(const struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
+			 __u32 sidsoffset, __u32 secdesclen,
+			 __u32 *pnsecdesclen, struct smb_sid *pownersid,
+			 struct smb_sid *pgrpsid)
 {
 	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
 	struct smb_sid *nowner_sid_ptr, *ngroup_sid_ptr;
+	int rc;
 
 	/* copy security descriptor control portion */
 	pnntsd->revision = pntsd->revision;
@@ -533,28 +600,34 @@ static __u32 copy_sec_desc(const struct smb_ntsd *pntsd,
 	pnntsd->gsidoffset = cpu_to_le32(sidsoffset + sizeof(struct smb_sid));
 
 	/* copy owner sid */
-	if (pownersid)
+	if (pownersid) {
 		owner_sid_ptr = pownersid;
-	else
-		owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->osidoffset));
+	} else {
+		rc = sid_from_sd(pntsd, secdesclen,
+				 le32_to_cpu(pntsd->osidoffset), &owner_sid_ptr);
+		if (rc)
+			return rc;
+	}
 	nowner_sid_ptr = (struct smb_sid *)((char *)pnntsd + sidsoffset);
 	cifs_copy_sid(nowner_sid_ptr, owner_sid_ptr);
 
 	/* copy group sid */
-	if (pgrpsid)
+	if (pgrpsid) {
 		group_sid_ptr = pgrpsid;
-	else
-		group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->gsidoffset));
+	} else {
+		rc = sid_from_sd(pntsd, secdesclen,
+				 le32_to_cpu(pntsd->gsidoffset), &group_sid_ptr);
+		if (rc)
+			return rc;
+	}
 	ngroup_sid_ptr = (struct smb_sid *)((char *)pnntsd + sidsoffset +
 					sizeof(struct smb_sid));
 	cifs_copy_sid(ngroup_sid_ptr, group_sid_ptr);
 
-	return sidsoffset + (2 * sizeof(struct smb_sid));
+	*pnsecdesclen = sidsoffset + (2 * sizeof(struct smb_sid));
+	return 0;
 }
 
-
 /*
    change posix mode to reflect permissions
    pmode is the existing mode (we only want to overwrite part of this
@@ -1232,38 +1305,6 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	return 0;
 }
 
-static int parse_sid(struct smb_sid *psid, char *end_of_acl)
-{
-	/* BB need to add parm so we can store the SID BB */
-
-	/* validate that we do not go past end of ACL - sid must be at least 8
-	   bytes long (assuming no sub-auths - e.g. the null SID */
-	if (end_of_acl < (char *)psid + 8) {
-		cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
-		return -EINVAL;
-	}
-
-#ifdef CONFIG_CIFS_DEBUG2
-	if (psid->num_subauth) {
-		int i;
-		cifs_dbg(FYI, "SID revision %d num_auth %d\n",
-			 psid->revision, psid->num_subauth);
-
-		for (i = 0; i < psid->num_subauth; i++) {
-			cifs_dbg(FYI, "SID sub_auth[%d]: 0x%x\n",
-				 i, le32_to_cpu(psid->sub_auth[i]));
-		}
-
-		/* BB add length check to make sure that we do not have huge
-			num auths and therefore go off the end */
-		cifs_dbg(FYI, "RID 0x%x\n",
-			 le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
-	}
-#endif
-
-	return 0;
-}
-
 static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
 {
 	if (acl_len < sizeof(struct smb_acl))
@@ -1284,23 +1325,25 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 	int rc = 0;
 	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
-	char *end_of_acl = ((char *)pntsd) + acl_len;
-	__u32 dacloffset;
+	char *end_of_acl;
+	__u32 dacloffset, osidoffset, gsidoffset;
 
 	if (pntsd == NULL)
 		return smb_EIO(smb_eio_trace_null_pointers);
+	if (acl_len < (int)sizeof(struct smb_ntsd)) {
+		cifs_dbg(VFS, "ACL too small to parse security descriptor\n");
+		return -EINVAL;
+	}
+	end_of_acl = ((char *)pntsd) + acl_len;
 
-	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->gsidoffset));
+	osidoffset = le32_to_cpu(pntsd->osidoffset);
+	gsidoffset = le32_to_cpu(pntsd->gsidoffset);
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
-		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
-		 le32_to_cpu(pntsd->gsidoffset),
+		 pntsd->revision, pntsd->type, osidoffset, gsidoffset,
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
-	rc = parse_sid(owner_sid_ptr, end_of_acl);
+	rc = sid_from_sd(pntsd, acl_len, osidoffset, &owner_sid_ptr);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
@@ -1312,9 +1355,9 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		return rc;
 	}
 
-	rc = parse_sid(group_sid_ptr, end_of_acl);
+	rc = sid_from_sd(pntsd, acl_len, gsidoffset, &group_sid_ptr);
 	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to gid\n",
+		cifs_dbg(FYI, "%s: Error %d parsing Group SID\n",
 			 __func__, rc);
 		return rc;
 	}
@@ -1354,8 +1397,15 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 	struct smb_sid *nowner_sid_ptr = NULL, *ngroup_sid_ptr = NULL;
 	struct smb_acl *dacl_ptr = NULL;  /* no need for SACL ptr */
 	struct smb_acl *ndacl_ptr = NULL; /* no need for SACL ptr */
-	char *end_of_acl = ((char *)pntsd) + secdesclen;
+	char *end_of_acl;
 	u16 size = 0;
+	__u32 osidoffset, gsidoffset;
+
+	if (secdesclen < sizeof(struct smb_ntsd)) {
+		cifs_dbg(VFS, "ACL too small to parse security descriptor\n");
+		return -EINVAL;
+	}
+	end_of_acl = ((char *)pntsd) + secdesclen;
 
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
@@ -1370,10 +1420,18 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 			return rc;
 	}
 
-	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->gsidoffset));
+	osidoffset = le32_to_cpu(pntsd->osidoffset);
+	gsidoffset = le32_to_cpu(pntsd->gsidoffset);
+	rc = sid_from_sd(pntsd, secdesclen, osidoffset, &owner_sid_ptr);
+	if (rc) {
+		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
+		return rc;
+	}
+	rc = sid_from_sd(pntsd, secdesclen, gsidoffset, &group_sid_ptr);
+	if (rc) {
+		cifs_dbg(FYI, "%s: Error %d parsing Group SID\n", __func__, rc);
+		return rc;
+	}
 
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
 		ndacloffset = sizeof(struct smb_ntsd);
@@ -1389,8 +1447,10 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 
 		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
 		/* copy the non-dacl portion of secdesc */
-		*pnsecdesclen = copy_sec_desc(pntsd, pnntsd, sidsoffset,
-				NULL, NULL);
+		rc = copy_sec_desc(pntsd, pnntsd, sidsoffset, secdesclen,
+				   pnsecdesclen, NULL, NULL);
+		if (rc)
+			return rc;
 
 		*aclflag |= CIFS_ACL_DACL;
 	} else {
@@ -1467,8 +1527,10 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 
 		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
 		/* copy the non-dacl portion of secdesc */
-		*pnsecdesclen = copy_sec_desc(pntsd, pnntsd, sidsoffset,
-				nowner_sid_ptr, ngroup_sid_ptr);
+		rc = copy_sec_desc(pntsd, pnntsd, sidsoffset, secdesclen,
+				   pnsecdesclen, nowner_sid_ptr, ngroup_sid_ptr);
+		if (rc)
+			goto chown_chgrp_exit;
 
 chown_chgrp_exit:
 		/* errors could jump here. So make sure we return soon after this */
-- 
2.39.5 (Apple Git-154)

