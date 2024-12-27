Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D11F8694;
	Fri, 27 Dec 2024 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321154; cv=none; b=trHEUxsPkZmowtKfju9XGvpr+bM54/0NYAF6G5bV4hGyP/Aba3XhPpPgAdLYIlxbOso6L82vf90pQJWC3+ozPSANfb1CVmYAyq1pJzg0gGDfRj2sob9Y9oncL6jooZUft5MgKM0DpXfM4j1a9Lb2FOQxfZcRhwV/XiDydm/BOug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321154; c=relaxed/simple;
	bh=9RTNpJ8xTPExKH3XWGSwmzIJeLjvgQ22UjgGgcVzCZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aWdsUPkmuJL3JD7s8fYaROO1ipp9dwdVUfjgsG+LzmGkeYDnzJeLHgAFRfpOpxMP5iqLQ9vZjjOfgc/N829LkJJMCkVnzah6Ifyq4fX9IntuP343MK8wH5nXxdCHqISqK+Mgq1D28DFXN1g0+1d2oQVMvZCwnJlZkGc/z3GTKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPc6XoAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPc6XoAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260B4C4CED0;
	Fri, 27 Dec 2024 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321154;
	bh=9RTNpJ8xTPExKH3XWGSwmzIJeLjvgQ22UjgGgcVzCZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPc6XoACvgSsU1Qmf/agA/3TuRNHdGoh8a2TvROpP2hmcvxhz3ZBR/zSq/vhvgJl9
	 J5JC57PmBNSD9E8SNPI17WrIplNEaRDE1/gCBX0b5Q03tD5zAxhm4ca3v22MurfrNJ
	 HZlBo9NjzV4tKGfb7FXff9vkkZ8rB6gNrEUfRwO+zZOxVJLEqZOYZZGJN8UChFLe86
	 vYt2e1acI1//zmkzTbzpq6EFhIR8AaiHbWElmRx5IRYWfea11Jzad3l8cSAWPUbTOA
	 R9ZjrLbeDA4z7lUDpwZlyJGKqd7TYwuilQD7H++2uFn2a3RqEQTYZTrHIzBciEWTsH
	 UDaf/xrYkMKyQ==
Received: by pali.im (Postfix)
	id 794AFB9A; Fri, 27 Dec 2024 18:39:04 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: Fix querying of WSL CHR and BLK reparse points over SMB1
Date: Fri, 27 Dec 2024 18:38:41 +0100
Message-Id: <20241227173841.22949-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227173841.22949-1-pali@kernel.org>
References: <20241227173841.22949-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When reparse point in SMB1 query_path_info() callback was detected then
query also for EA $LXDEV. In this EA are stored device major and minor
numbers used by WSL CHR and BLK reparse points. Without major and minor
numbers, stat() syscall does not work for char and block devices.

Similar code is already in SMB2+ query_path_info() callback function.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 3af3f64b0cba..c52fc4c1557c 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -568,6 +568,42 @@ static int cifs_query_path_info(const unsigned int xid,
 		data->reparse_point = le32_to_cpu(fi.Attributes) & ATTR_REPARSE;
 	}
 
+#ifdef CONFIG_CIFS_XATTR
+	/*
+	 * For WSL CHR and BLK reparse points it is required to fetch
+	 * EA $LXDEV which contains major and minor device numbers.
+	 */
+	if (!rc && data->reparse_point) {
+		struct smb2_file_full_ea_info *ea;
+
+		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_DEV,
+				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
+				    SMB2_WSL_XATTR_DEV_SIZE, cifs_sb);
+		if (rc == SMB2_WSL_XATTR_DEV_SIZE) {
+			ea->next_entry_offset = cpu_to_le32(0);
+			ea->flags = 0;
+			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
+			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
+			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
+			data->wsl.eas_len = sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+					    SMB2_WSL_XATTR_DEV_SIZE;
+			rc = 0;
+		} else if (rc >= 0) {
+			/* It is an error if EA $LXDEV has wrong size. */
+			rc = -EINVAL;
+		} else {
+			/*
+			 * In all other cases ignore error if fetching
+			 * of EA $LXDEV failed. It is needed only for
+			 * WSL CHR and BLK reparse points and wsl_to_fattr()
+			 * handle the case when EA is missing.
+			 */
+			rc = 0;
+		}
+	}
+#endif
+
 	return rc;
 }
 
-- 
2.20.1

