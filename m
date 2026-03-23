Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7FA3AE19E;
	Mon, 23 Mar 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282723; cv=none; b=mlPspKewUgDL5iyG+cha9sMGo6fidPcVMGuDwaV4U6G0YUzL/6XrC7dFcuipkLyZE5aM3Ph6HQepUKHDgAsjgEodFB4XRRZh2t3XReKvKkvyD+CAS+gh8V3rK8Ib9+997uvSFwU40iIv2KHxpkrHpeqe+DiTgABYhA0ckBzXV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282723; c=relaxed/simple;
	bh=kB1AeSCer8Bo2OQ5B88q6bhA0d+BByYFnQ4t6U9cgFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNxbB9iA1JNh/8l8KjLuk0ylhc9uW7TcEyAT2jzqDX+ztVzoHg6qFDD/jIktWUj9aPTTrDLXXiWPhxweyRzZUXr3meRjI58lrdVY5FC0zq5RqZnEFlEDC0K0fJ7NYFVNUAKjTygcnjNIlaAw68H3O9eoIzUjQGUPtg7w8ZWDZQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nl2EmqQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nl2EmqQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39ABC4CEF7;
	Mon, 23 Mar 2026 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282723;
	bh=kB1AeSCer8Bo2OQ5B88q6bhA0d+BByYFnQ4t6U9cgFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nl2EmqQkVGgXMTsih0myU5aw/glwgmR68eVihZqEmfcuguWFDmLamJeFZdAoF8lex
	 4kM6h5zn24IdGGkk54GmVQvp8Rgo75Tg9dOWbzaQEI8eA+C/zIypvQkZTszYsV7RHF
	 6oQRYi073qWaQW408EglMnHf74P/tKI1R9RkNyXs=
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
Subject: [PATCH 6.1 261/481] smb: client: fix atomic open with O_DIRECT & O_SYNC
Date: Mon, 23 Mar 2026 14:44:03 +0100
Message-ID: <20260323134531.508517941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2194,4 +2195,14 @@ static inline bool cifs_ses_exiting(stru
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
@@ -255,15 +255,8 @@ static int cifs_nt_open(const char *full
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
@@ -913,13 +906,8 @@ cifs_reopen_file(struct cifsFileInfo *cf
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


