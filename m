Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EE672621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046185; cv=none; b=UnxOQHINxpsPy/ruTNwIK5ZuKbXb+NIqwjl0erVQJtBN7IerLHTJ1kzcOy3rVJIrbcnVLKZc3REVhRhPqUSjOZIk/yZTUBSz4cOBSIYBXmUe3wb1GirLt2hmKGxfGn5lWMWFh/guk302Nc+U19DMUkd7JkPduSXKcYQy+PDKRS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046185; c=relaxed/simple;
	bh=rs2FrHfMjcimhK9z7nuIiRx6bXTo7QCoIRxKdfxUnXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gXXSUnTD40EeV3gVbI0tDgEfNOnMic5mconw9jDYeGPhLbXaeNxfs6m0IznIC5LEwX0wZU5oeqhC2yIbelfUJdicmlnXrvAszNi9eOEbIkFCl4w+03fH0ivyXzNGkBWczmCA2ZdQS1SoLJY6oUboaMNe4uW6InOl2Gcby4oIctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mctbseV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mctbseV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7156E1F00A3A;
	Sun, 21 Jun 2026 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046184;
	bh=EVRIbnZbiENhSfakG+CxjRi3YrmvZTovOfKQX6lKU7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mctbseV1BSyYpOI2pQ5gI4BKw/NDMtQ9ws6PQLxyeAGgMN5xEShs9x/Z/i5/iXVpZ
	 DJLkNBZdT9YDQqdIru2T62jr6a6PWbc5Us8TJP2RgAATEw/j8wb/oo5U5UTU2YMA9k
	 UUeD8Uir3BAO5QQMHokrVYNgPKEUGK5ZjXT82nEC0zT9TI9k6T+UcXoUhoB0o9RKWs
	 1rC7sHPevGE9ZXkTmrbP3oE4cMhE7JqINsANH+pZnTz31jcpcOdK7RE+JveQ3Wskf5
	 2VfV0fQT27zEathSJPV0AhyOHkgQrr2NkQL7SO4KSFdhj7eQCTItu56Vblvk+6UAYZ
	 BfTSJ90xlxyBg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 27/29] ksmbd: start file id allocation at 1
Date: Sun, 21 Jun 2026 21:48:42 +0900
Message-Id: <20260621124844.6235-27-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd allocates both the volatile id (per-session file table) and the
persistent id (global file table) with idr_alloc_cyclic() starting at 0.
The first open after the module loads therefore gets volatile id 0 and
persistent id 0, and ksmbd returns an SMB2 FileId of {0, 0} in the create
response.

Clients treat an all-zero FileId as a null handle. smbtorture's
smb2_util_handle_empty() considers {0, 0} empty, so tests that guard the
close with it (e.g. smb2.oplock.statopen1, smb2.lease.statopen*) never
close that first handle. The leaked open keeps the inode's oplock count
non-zero, so a later batch oplock request on the same file is downgraded
to level II and the test fails.

Start the id allocation at 1 (KSMBD_START_FID) so no handle is ever
assigned a {0, 0} FileId, matching the behaviour of other SMB servers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 3 ++-
 fs/smb/server/vfs_cache.h | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 11b51320b96e..7495166b0262 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -992,7 +992,8 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 
 	idr_preload(KSMBD_DEFAULT_GFP);
 	write_lock(&ft->lock);
-	ret = idr_alloc_cyclic(ft->idr, fp, 0, INT_MAX - 1, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, INT_MAX - 1,
+			       GFP_NOWAIT);
 	if (ret >= 0) {
 		id = ret;
 		ret = 0;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index f85021c11d6e..287f3e675cd3 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -23,7 +23,12 @@
 #define	FILE_GENERIC_WRITE	0x120116
 #define	FILE_GENERIC_EXECUTE	0X1200a0
 
-#define KSMBD_START_FID		0
+/*
+ * Start volatile/persistent file id allocation at 1. A file id of 0 yields an
+ * SMB2 FileId of {0, 0}, which clients (e.g. Windows, Samba) treat as a null
+ * handle and never close, leaking the open on the server.
+ */
+#define KSMBD_START_FID		1
 #define KSMBD_NO_FID		(INT_MAX)
 #define SMB2_NO_FID		(0xFFFFFFFFFFFFFFFFULL)
 
-- 
2.25.1

