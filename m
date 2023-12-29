Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63E11C82
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XD7YT8yF"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7b7fdde8b26so306204039f.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 06:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703860538; x=1704465338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4z9gxsgEnfrjT/imE8RqKfC+If+9BhNv8bBqqRqT28=;
        b=XD7YT8yFqCP7M1C2C2YTkxYvJbLBAUyTWaL43R2awph/2D7PK2TpyQa4KcoU7vhrY/
         aaM/oqqI7+sdkg2tlUw0C1QoOzh7TURe/3gm+aharQk8PTWm2CINv/Wwl/LOz0+oIJo9
         rdrFtQfHoOiLRdYg1IKVCrcgdQZz45aQ3yPqonOlsVq7y1QylgAzwqHCyjCw/9gvWeC1
         S/Tc/hq7gxKe/blFo/+L7fP/lkj8TxThZ4tVHSKpso76FTrlCHp3TZjQ8oOF6Zme+1fa
         orG1QyQ8x4ztIVqnBiuP6EvKu8KfQo97Nv1yDn1eKHv016IYQM0eK7wGBGcB/5oioW09
         lbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703860538; x=1704465338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4z9gxsgEnfrjT/imE8RqKfC+If+9BhNv8bBqqRqT28=;
        b=wBG+8FuAlfT60M7BkeXYXX2FBnoV90apD7fWr02vHIoE60o7yWkILLhA/BAMb8opvx
         hdkZIWrgidplpJnnuQyHhWahD25FcfNPnl+q5hTMgExeAYSTTnJGRMCM4WI8dg/JHt9e
         RE+nNq6NjI7/17g0TlgUZt06wpswdCFuThQM/IlsHx9yyDfVbnPzpVbA723b5c3RFxJh
         JFdZgx96xskRyvPG6/33o6+gGrySSAs2xTE1e99n/rvNV3m24DiO0hDHvyMhZMuIc3jv
         BMQu9qNLAdn6nKtRH1lNIuu/Ol3tZ2x51Or2VWnYxR/1K9PL5DBFVO69O3AK4S2Fh1xE
         8xTQ==
X-Gm-Message-State: AOJu0YyU5IjQsQmsER6+da0quPgQlHffYDQLQGAwEJq7XE+aFAkegHhG
	VQuwKf2SZx3/iB/mLPkp1xc=
X-Google-Smtp-Source: AGHT+IFuwTWx0xEuAjHiHJYxg92qYH1u1e6seH2Bpb6VL+O5L3ekbc74M/8jO9WQmml/ZqbJadeN0g==
X-Received: by 2002:a05:6602:164a:b0:7ba:b9e5:194 with SMTP id y10-20020a056602164a00b007bab9e50194mr12242493iow.34.1703860538665;
        Fri, 29 Dec 2023 06:35:38 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.159.31])
        by smtp.gmail.com with ESMTPSA id h32-20020a63f920000000b005b9083b81f0sm14773082pgi.36.2023.12.29.06.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 06:35:38 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	samba-technical@lists.samba.org
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 2/2] smb: client: retry compound request without reusing lease
Date: Fri, 29 Dec 2023 09:35:21 -0500
Message-Id: <20231229143521.44880-2-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

There is a shortcoming in the current implementation of the file
lease mechanism exposed when the lease keys were attempted to be reused
for unlink, rename and set_path_size operations for a client. As per
MS-SMB2, lease keys are associated with the file name. Linux cifs client
maintains lease keys with the inode. If the file has any hardlinks,
it is possible that the lease for a file be wrongly reused for an
operation on the hardlink or vice versa. In these cases, the mentioned
compound operations fail with STATUS_INVALID_PARAMETER.
This patch adds a fallback to the old mechanism of not sending any
lease with these compound operations if the request with lease key fails
with STATUS_INVALID_PARAMETER. Resending the same request without lease
key should not hurt any functionality, but might impact performance
especially in cases where the error is not because of the usage of wrong
lease key and we might end up doing an extra roundtrip.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/smb2inode.c | 40 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 446433606a04..d3d7a4652a5b 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -121,6 +121,17 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* if there is an existing lease, reuse it */
+
+	/*
+	 * note: files with hardlinks cause unexpected behaviour. As per MS-SMB2,
+	 * lease keys are associated with the file name. We are maintaining lease keys
+	 * with the inode on the client. If the file has hardlinks associated with it,
+	 * it could be possible that the lease for a file be reused for an operation
+	 * on the hardlink or vice versa.
+	 * As a workaround, send request using an existing lease key and if the server
+	 * returns STATUS_INVALID_PARAMETER, which maps to EINVAL, send the request
+	 * again without the lease.
+	 */
 	if (dentry) {
 		inode = d_inode(dentry);
 		cinode = CIFS_I(inode);
@@ -907,10 +918,18 @@ int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
-	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
+	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
 				ACL_NO_MODE, NULL, &(int){SMB2_OP_DELETE}, 1,
 				NULL, NULL, NULL, NULL, NULL, dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
+				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
+				ACL_NO_MODE, NULL, &(int){SMB2_OP_DELETE}, 1,
+				NULL, NULL, NULL, NULL, NULL, NULL);
+	}
+	return rc;
 }
 
 static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
@@ -950,8 +969,14 @@ int smb2_rename_path(const unsigned int xid,
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
-	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
+	}
+	return rc;
 }
 
 int smb2_create_hardlink(const unsigned int xid,
@@ -979,11 +1004,20 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 	in_iov.iov_base = &eof;
 	in_iov.iov_len = sizeof(eof);
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
+	int rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				FILE_WRITE_DATA, FILE_OPEN,
 				0, ACL_NO_MODE, &in_iov,
 				&(int){SMB2_OP_SET_EOF}, 1,
 				cfile, NULL, NULL, NULL, NULL, dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				FILE_WRITE_DATA, FILE_OPEN,
+				0, ACL_NO_MODE, &in_iov,
+				&(int){SMB2_OP_SET_EOF}, 1,
+				cfile, NULL, NULL, NULL, NULL, NULL);
+	}
+	return rc;
 }
 
 int
-- 
2.39.2

