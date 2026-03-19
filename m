Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE6136DA0B;
	Thu, 19 Mar 2026 16:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773938691; cv=none; b=phDmYtVF0iGRVVcoENWJ6zjm0XK77O5+vlf58MXlIOkIS0g3n+brFf6fo/dZ54TvZy2RdH9mR4jo/JlLNDTEkBYJRs91k07XCQmhhrnnPPayqB5C7dwfL27kTp0qiPs0bNLW6TTXazJBRnBBeGHfSpJVQV5ZVRjCz8MRONQX2ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773938691; c=relaxed/simple;
	bh=QX8XFc1m9wVmSpF8FGoalOLGdqXx7hpSirHPF59hujI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLaf6luI5D8nCOBV39iIxeE5LFUbDJyQalHqffCyXEupXcwr6zb6pS38DBptBgluD8YmZ7ql2Ilx2YY+B6ds8aK87ohkcFSsGQTtWnRjJlp2BWHM/E5Kk4blnRFSqTNV/vJh1ocxsOK3eJp+iL9dXj5w6j1DeUXMsFdjA3ZlHi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSIhfJRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSIhfJRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B9C19424;
	Thu, 19 Mar 2026 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773938691;
	bh=QX8XFc1m9wVmSpF8FGoalOLGdqXx7hpSirHPF59hujI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSIhfJRgnbrtDrfbVS+M8JJnCGz0Bce0tuX3MJOyckVfWF/sih8/Qg6V8/qmwyI9U
	 kfqXmWhIfzNYoWJDqH3ZAE6FM+JsPx9Gq3+Szl9mEyNhqzWIbKnwd8mITrZTs8MsIo
	 CQrlK7I0JU6tNQuuKARpPIVg2eQS2h9FhA7Am/nVNVuEC36i1tbY34f02OeDBcZm3n
	 vHI3Zbq7obW14hUBKi1SYmyZ0aIzsLbbnTUVCyGeHmX8DE6/f7WK1C6omcSQaOWS2G
	 08QM30d+daIbJiokG/nl9bbjUDDJ2N18yEn6PfQSIlgjvWVLVR8hVkhbULFoYH9uzR
	 Ix6NGTw3Kzv4g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y] smb: client: fix atomic open with O_DIRECT & O_SYNC
Date: Thu, 19 Mar 2026 12:44:48 -0400
Message-ID: <20260319164448.2729592-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2026031705-crafty-showman-4909@gregkh>
References: <2026031705-crafty-showman-4909@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4a7d2729dc99437dbb880a64c47828c0d191b308 ]

When user application requests O_DIRECT|O_SYNC along with O_CREAT on
open(2), CREATE_NO_BUFFER and CREATE_WRITE_THROUGH bits were missed in
CREATE request when performing an atomic open, thus leading to
potentially data integrity issues.

Fix this by setting those missing bits in CREATE request when
O_DIRECT|O_SYNC has been specified in cifs_do_create().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adapted file paths from fs/smb/client/ to fs/cifs/ ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 11 +++++++++++
 fs/cifs/dir.c      |  1 +
 fs/cifs/file.c     | 17 +++--------------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 68b9b382d44bf..7d044ce518f61 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
+#include <linux/fcntl.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
@@ -2050,4 +2051,14 @@ static inline bool cifs_ses_exiting(struct cifs_ses *ses)
 	return ret;
 }
 
+static inline int cifs_open_create_options(unsigned int oflags, int opts)
+{
+	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
+	if (oflags & O_SYNC)
+		opts |= CREATE_WRITE_THROUGH;
+	if (oflags & O_DIRECT)
+		opts |= CREATE_NO_BUFFER;
+	return opts;
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 83c929dd6ed59..7cb7db5c44128 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -293,6 +293,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		goto out;
 	}
 
+	create_options |= cifs_open_create_options(oflags, create_options);
 	/*
 	 * if we're not using unix extensions, see if we need to set
 	 * ATTR_READONLY on the create call
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 10bb1f9551887..0068c46cd0735 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -205,19 +205,13 @@ cifs_nt_open(const char *full_path, struct inode *inode, struct cifs_sb_info *ci
  *********************************************************************/
 
 	disposition = cifs_get_disposition(f_flags);
-
 	/* BB pass O_SYNC flag through on file attributes .. BB */
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
-	if (f_flags & O_SYNC)
-		create_options |= CREATE_WRITE_THROUGH;
-
-	if (f_flags & O_DIRECT)
-		create_options |= CREATE_NO_BUFFER;
+	create_options |= cifs_open_create_options(f_flags, create_options);
 
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
@@ -770,13 +764,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	}
 
 	desired_access = cifs_convert_flags(cfile->f_flags);
-
-	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
-	if (cfile->f_flags & O_SYNC)
-		create_options |= CREATE_WRITE_THROUGH;
-
-	if (cfile->f_flags & O_DIRECT)
-		create_options |= CREATE_NO_BUFFER;
+	create_options |= cifs_open_create_options(cfile->f_flags,
+						   create_options);
 
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
-- 
2.51.0

