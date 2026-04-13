Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24F3168EE;
	Mon, 13 Apr 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099114; cv=none; b=macTzG/7N9PI8gGsD0h6KdHwltJekJU57qVEEz7IwlFa+99zcU4lS0fWTcFeiqXe7Rlcx4GYUHnqICt5vFpbYWfx8tAKqsYv397OjNTcJ579cG6BCpxafhxQUE8FwzU66CPyR/lRjc199fJo4/pV5Ept+hGkTdialh6nRfFrlWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099114; c=relaxed/simple;
	bh=Frjx+S5VS6WH/wvR9USOxQ/yN2Do7Rkh1eX7STKNwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crOS2yPbQUfo/+G5L6R/c6MnB+pUNdvZgDXtqGDSexi0gmL9Zni16C5ik/OTSTRdQKBa0SUGiRcoju5wzVX498rI6Mq9WsBJLgaKPf/12h/oC9j/+G9c9Ccq+LttuYmUldYaGiAM5BYiPvChtFSINPcrBuGGZr5mGTALTpniOLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WscW2u3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WscW2u3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E5C2BCAF;
	Mon, 13 Apr 2026 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099114;
	bh=Frjx+S5VS6WH/wvR9USOxQ/yN2Do7Rkh1eX7STKNwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WscW2u3mFOu8xDWybQXOWdhFpOhCCnMP5Er23OxvcKOvIECRE5Vs8oznPiU0FnZg8
	 IGMGe+UUZyWrI3+Dh79Sq0EHkMXK4Cg0TjAlrn56vCutfzjWnBDCyBV89+JSmxkhh+
	 y8r0mIIfJHvVD4YxVioe9kK955oe3b3UrDwi3KUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/491] smb: client: fix atomic open with O_DIRECT & O_SYNC
Date: Mon, 13 Apr 2026 17:56:59 +0200
Message-ID: <20260413155825.564298981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |   11 +++++++++++
 fs/cifs/dir.c      |    1 +
 fs/cifs/file.c     |   17 +++--------------
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
+#include <linux/fcntl.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
@@ -2124,4 +2125,14 @@ static inline bool cifs_ses_exiting(stru
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
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -348,6 +348,7 @@ cifs_do_create(struct inode *inode, stru
 		goto out;
 	}
 
+	create_options |= cifs_open_create_options(oflags, create_options);
 	/*
 	 * if we're not using unix extensions, see if we need to set
 	 * ATTR_READONLY on the create call
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -216,19 +216,13 @@ cifs_nt_open(char *full_path, struct ino
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
@@ -750,13 +744,8 @@ cifs_reopen_file(struct cifsFileInfo *cf
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


