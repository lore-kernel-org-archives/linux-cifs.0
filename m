Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D7292918
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776696484; cv=none; b=F9EeQaAJXrxrbPbT0WKcSsGEU6iPnZLP/M6WJCJtsqoO8AvhJ8BKo5xRikWdhF/m1X0DULr38ZeJn96HM8aE/Hy1UfHzWieYKRoarqRKQx9jB1FcgB2pz5iC/7PrXSv5KSA7UCyj6o9LU1PbShqzzT9edp4x664a0KITL18/L9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776696484; c=relaxed/simple;
	bh=248LEv+sRvAPKQEXTiDFIqrD1Z8GTMB8AFG3XTGI1w8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aG7eHBFgI8hS9hGQhCsZG4yJ8+0uXra/mis97+zqiRw1C3iviwkRtIUNuUlrWx1Eq4XrrlZ5/r+b67p9VBGqcfJIrfBjZBNvSS0VS/8d7wnJvDIu5LwLFlAdk1ntvUWHpTFp8vjSY85HOAZm21kcBJPmv39Mpnb1seCTwUUparE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJtZKKAh; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJtZKKAh"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50baafd6c4aso37011831cf.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776696482; x=1777301282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gONB6BslV1gZB8sBPqe9TWmoGjs9CoGOCXEnrliVxGA=;
        b=hJtZKKAh4HinATYR9azugKKRHDVQVJIkh+8ggcFCTpetQxrZa0/tquKBacNPzjgXSM
         EBHYfW8rZOBYqn2UMDxMyVUMqJavPneL6HTlFC9FYi4ppt2bQHF0enOvYh1aOZSfhUfu
         w6fgsq4qlL411VoRhFGI7UXeKz4WsoMn9crsxxtFRspeFQSTsZERMNZ8sqFTTnYhnFN/
         pCWGhecZmsh2NqxC2buX0ZKqtfM6M8AFMlqVHifaZH2DJ6EdJuKtJpyn7wzADFnd0mx6
         5SiQXTfTbZywd9RvTmvAL6UgA4ZTFfyou93F7w+GUBaoBYaKn8RKSjOz3XGdo6YjiiO4
         6+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776696482; x=1777301282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gONB6BslV1gZB8sBPqe9TWmoGjs9CoGOCXEnrliVxGA=;
        b=JQgCPA4Lw8mWf0VRPEelwC8w07gcmWvxpQoeBvljD/INSw5WDFexVvM3EPJxu9OSla
         vnR2uiDZ9pryHOK9TRr1DJ20RetfbNcTW/oWbjcRdHqJDtJnQnqCQKhbU9tJuKGX4IG2
         j3P2VXExYdmym6TUaXdS8sGiMuN4BYqDOiVu6SkpJwZW31SkwuNvI00Hg8Uu849ZVcp2
         2ft7xqxlhrPkXPutH6zJ9/SjZWgN704MEsnnsL1E9iwfu4ag+x0yexBNFD8goa2Q8cCH
         MgEJ64GtDq5rqhlufjWwDpZ6Jw9DV/1+Csm5+zjVW3KGkxRSY+Sj1eh/r29eW7FOz1CP
         ZOwQ==
X-Forwarded-Encrypted: i=1; AFNElJ877pwTHHzi0mQU7Adzzch0Mdvh7wi2D1DB3bUD51Py4fxdfsLSmSaMDzBW1IVwxwV2PBA/sBSl2koi@vger.kernel.org
X-Gm-Message-State: AOJu0YysFEJGXR5uvKmLdBrxRvdJYQuGSzmIomrdGJ2FBp6FbYd+4eKW
	8JbBJv/ms+/FjAgSBvHWN2NtQsZkmxodWFhKfHZl5BfCuJtAVBN4IFwA
X-Gm-Gg: AeBDieuhq3xUg5ZKRsmFEAt3aAp0lmoV+vZ7Ih0jQrODJPzK+dKpb3RCVkDQskvaZFi
	s0fnc369xH80I8jiHJ6VDoBiRjLjYdVguJc6jsiJNiIMH4pNn3BwgBLyVXr8BYM6gd66kYXN/CG
	8QQeauFbfC0ArN1FSBGndMfdwzFaCsRPldUrT8RiK07QSHPzDjPC3kSra0xyMT9b1uoVGZqET2w
	XzqhPHWLf50/6Ol6p8r3nJNrd79dzgHM4TrkGYrWbvDzRamAcwJKMOgyEVZ2TXK6QoVCxLBm75H
	QyOazeR8ksBlSQYmXKg6dI7excJVLziBrN58r/veRdb5m0Ubp6dkvJyGu/XjZWn7tFUITGJYIw/
	ihfSnvlDkep9MI9LFsEgGmlkap2BCDiq8DUGVqNx2IOFwnGkRRQarpyChzTLj1STK4qN+lD80h3
	p2HDBu/JH8tc3piMKiDW0t6S3NptFHcyAziKbbn2CIJjz/Zjg/clUQ6tKkg27AfbIzPaK6J2/Hb
	szXru0M5FdopwHhTh7pj7WNg38/Wx8=
X-Received: by 2002:a05:622a:8404:10b0:50e:57de:40d7 with SMTP id d75a77b69052e-50e57de4894mr54079011cf.19.1776696482038;
        Mon, 20 Apr 2026 07:48:02 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e39495192sm85384781cf.27.2026.04.20.07.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:48:01 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: validate dacloffset before building DACL pointers
Date: Mon, 20 Apr 2026 10:47:47 -0400
Message-ID: <20260420144747.662761-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_sec_desc(), build_sec_desc(), and the chown path in
id_mode_to_cifs_acl() all add the server-supplied dacloffset to pntsd
before proving a DACL header fits inside the returned security
descriptor.

On 32-bit builds a malicious server can return dacloffset near
U32_MAX, wrap the derived DACL pointer below end_of_acl, and then slip
past the later pointer-based bounds checks. build_sec_desc() and
id_mode_to_cifs_acl() can then dereference DACL fields from the wrapped
pointer in the chmod/chown rewrite paths.

Validate dacloffset numerically before building any DACL pointer and
reuse the same helper at the three DACL entry points.

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
This applies on top of

  [PATCH v2] smb: client: validate the whole DACL before rewriting it
  in cifsacl
  https://lore.kernel.org/linux-cifs/20260420001131.2865776-1-michael.bommarito@gmail.com/

so that the new dacl_offset_valid() numeric precheck sits upstream of
that series' validate_dacl() structural check at all three call sites.
The two patches are independent fixes for different bug classes on the
same three entry points; applying this one without the KCIFS2 v2 patch
first will fail on the build_sec_desc() hunk because the trailing
context line "rc = validate_dacl(dacl_ptr, end_of_acl)" only exists
after v2.  If you prefer a different ordering, happy to reroll on a
plain mainline base instead.

 fs/smb/client/cifsacl.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index cb4060ba5e31..87d2a58fc8b4 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1263,6 +1263,17 @@ static int parse_sid(struct smb_sid *psid, char *end_of_acl)
 	return 0;
 }
 
+static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
+{
+	if (acl_len < sizeof(struct smb_acl))
+		return false;
+
+	if (dacloffset < sizeof(struct smb_ntsd))
+		return false;
+
+	return dacloffset <= acl_len - sizeof(struct smb_acl);
+}
+
 
 /* Convert CIFS ACL to POSIX form */
 static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
@@ -1283,7 +1294,6 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
@@ -1314,11 +1324,18 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		return rc;
 	}
 
-	if (dacloffset)
+	if (dacloffset) {
+		if (!dacl_offset_valid(acl_len, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
+		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
 			   group_sid_ptr, fattr, get_mode_from_special_sid);
-	else
+	} else {
 		cifs_dbg(FYI, "no ACL\n"); /* BB grant all or default perms? */
+	}
 
 	return rc;
 }
@@ -1341,6 +1358,11 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
+		if (!dacl_offset_valid(secdesclen, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
 		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		rc = validate_dacl(dacl_ptr, end_of_acl);
 		if (rc)
@@ -1709,6 +1731,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct smb_sid) * 2);
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
+			if (!dacl_offset_valid(secdesclen, dacloffset)) {
+				cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+				rc = -EINVAL;
+				goto id_mode_to_cifs_acl_exit;
+			}
+
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 			rc = validate_dacl(dacl_ptr, (char *)pntsd + secdesclen);
 			if (rc) {
@@ -1751,6 +1779,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
 		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
+id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 
 	kfree(pnntsd);
-- 
2.53.0

