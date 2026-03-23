Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E853B38BC;
	Mon, 23 Mar 2026 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278565; cv=none; b=jOyltN70ZtK1KkcpWnWP7G+NEeoc8SeIPolOU6R+n+ZxKZUw6jTSVUG1PeFoMe82aSRVOGfVMbI4eq+C+vYguL76mlGtxVx5aoxshqJ6KfveC3nXi6Xyfbewysrjfl04UiClYvjVXatZHSGi6vhLCo+M3S0G2FgKMesMpT5l6U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278565; c=relaxed/simple;
	bh=+PPZewh7xgbfrkahx/fUymZmQXyBbwQTCfZ9IR2KjnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLjh+dcOfmh1Aw4mIcER7EZjaqxJ2yyEbvTszQhPLoMTe4RetI4/b45le0spfckJn/93VAYI4I6p524d2OHvIvHjY7qJnPg+RQ0KprDUvSGbtjk55gR2yXkFUemgtW3Ire4wAEKWWR4KPi27cA/ZnaOkJquhKTF5lvFvJYWGZp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+sgwnBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+sgwnBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D5AC4CEF7;
	Mon, 23 Mar 2026 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278565;
	bh=+PPZewh7xgbfrkahx/fUymZmQXyBbwQTCfZ9IR2KjnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+sgwnBTNfkZlyCuSHAZzDYBUzTjM8WTvh0FKoFJYYzHD8GtoOpvtFS9svCWGefGj
	 STmx9/1qIDDiKq9+RcpK3+D9j/hRx61LUfU7ZzQXrlDwO17z7/3yDbWzurTs5qBtpb
	 LG51nF+E3/HOujlPm0LxC8Gb0IQA2d73YKD2OKPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 348/567] smb: client: fix atomic open with O_DIRECT & O_SYNC
Date: Mon, 23 Mar 2026 14:44:28 +0100
Message-ID: <20260323134542.445302689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 4a7d2729dc99437dbb880a64c47828c0d191b308 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |   11 +++++++++++
 fs/smb/client/dir.c      |    1 +
 fs/smb/client/file.c     |   18 +++---------------
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -20,6 +20,7 @@
 #include <linux/utsname.h>
 #include <linux/sched/mm.h>
 #include <linux/netfs.h>
+#include <linux/fcntl.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
@@ -2354,4 +2355,14 @@ static inline bool cifs_ses_exiting(stru
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
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -304,6 +304,7 @@ static int cifs_do_create(struct inode *
 		goto out;
 	}
 
+	create_options |= cifs_open_create_options(oflags, create_options);
 	/*
 	 * if we're not using unix extensions, see if we need to set
 	 * ATTR_READONLY on the create call
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -459,15 +459,8 @@ static int cifs_nt_open(const char *full
  *********************************************************************/
 
 	disposition = cifs_get_disposition(f_flags);
-
 	/* BB pass O_SYNC flag through on file attributes .. BB */
-
-	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
-	if (f_flags & O_SYNC)
-		create_options |= CREATE_WRITE_THROUGH;
-
-	if (f_flags & O_DIRECT)
-		create_options |= CREATE_NO_BUFFER;
+	create_options |= cifs_open_create_options(f_flags, create_options);
 
 retry_open:
 	oparms = (struct cifs_open_parms) {
@@ -1117,13 +1110,8 @@ cifs_reopen_file(struct cifsFileInfo *cf
 		rdwr_for_fscache = 1;
 
 	desired_access = cifs_convert_flags(cfile->f_flags, rdwr_for_fscache);
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


