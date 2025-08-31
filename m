Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3340A26981E;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=QL3yuKB6dceePquex0mjhKnZcHMPXNkaxyFpaQO5/OFry6dhDKmmixxSv4qK00k0174M22Q28a3iQr0r6ZgNGyUwUUnHWoZM/yUHMnv4miEwmMnOileLEOaj9voXxMHnga9ulWYgHXaM3rN2ePEnzSdSdGOcNBGXYgSLiatJNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=j/DaCTz6Vnq2DWJalAYLoPLGNEyRjSFNsogDPZjeMB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/WRAlP8igIC9ndX1OH5W3WLSl9KtQBB2HDjxsePc2Zvh87NnK9g18SjpYhI3Zk1UsEUxlKHCulDlNClzOEBv8cW8MnOEK0e3ffh5cd4U3+uv5x35v1JiYlkKeInIERin4UL6xFWnBa45Vo4nUHk5sHUxgnJnXHI4stPAWbXVT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WI0Hib0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WI0Hib0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5CEC4CEFB;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=j/DaCTz6Vnq2DWJalAYLoPLGNEyRjSFNsogDPZjeMB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI0Hib0N0EVd0e1DcfwmgKj34JvV6OVxhPopYNeaNbEKBVeqD8Uofzd8PAtPzSIen
	 3Z9wxVDolZ4UX78Ifs0fwoUCy+9IVxilM/mZzGYRmRZT1WmFrSUV34rVjAm/MjpuZq
	 p/8Uo4vznmaOJNX+infVmrbPtVdSrp61g2cbKSVseX+IGdZCR/+NmS1nEIrIXH4EJh
	 TL/6uFcZYnndGoO3RMYhwo2iznpUx4vFWohtM8gW2edzgGu7SoZqAv44/RSWwlMZMb
	 5VbXV2KDSYx+2uKjxoLifgOyLXaEI0Eu+lefhjzchV7eg+0wJl3iSC7Xau0RJ2Vj2J
	 gI3mzkvHpug2w==
Received: by pali.im (Postfix)
	id 5352511D8; Sun, 31 Aug 2025 14:36:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 27/35] cifs: Move SMB1 usage of CIFSPOSIXDelFile() from inode.c to cifssmb.c
Date: Sun, 31 Aug 2025 14:35:54 +0200
Message-Id: <20250831123602.14037-28-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Special case of unlinking file via SMB1 UNIX extension is currently in the
dialect agnostic function cifs_unlink() and hidden under the #ifdef
CONFIG_CIFS_ALLOW_INSECURE_LEGACY.

Cleanup the code and move this functionality into the SMB1 ->unlink()
callback, which removes one #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
code block from inode.c

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 12 ++++++++++++
 fs/smb/client/inode.c   | 20 +++-----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c09713ebdc7c..3a0452479a69 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -768,6 +768,18 @@ CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int name_len;
 	int remap = cifs_remap(cifs_sb);
 
+	/* If UNIX extensions are available then use UNIX UNLINK call. */
+	if (cap_unix(tcon->ses) &&
+	    (le64_to_cpu(tcon->fsUnixInfo.Capability) & CIFS_UNIX_POSIX_PATH_OPS_CAP)) {
+		rc = CIFSPOSIXDelFile(xid, tcon, name,
+				      SMB_POSIX_UNLINK_FILE_TARGET,
+				      cifs_sb->local_nls,
+				      cifs_remap(cifs_sb));
+		cifs_dbg(FYI, "posix del rc %d\n", rc);
+		if (rc == 0 || rc == -ENOENT)
+			return rc;
+	}
+
 DelFileRetry:
 	rc = smb_init(SMB_COM_DELETE, 1, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c3f101d10488..545964cac9cd 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1947,27 +1947,13 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 
 	netfs_wait_for_outstanding_io(inode);
 	cifs_close_deferred_file_under_dentry(tcon, full_path);
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
-				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
-			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
-			cifs_remap(cifs_sb));
-		cifs_dbg(FYI, "posix del rc %d\n", rc);
-		if ((rc == 0) || (rc == -ENOENT))
-			goto psx_del_no_retry;
-	}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 retry_std_delete:
-	if (!server->ops->unlink) {
+	if (!server->ops->unlink)
 		rc = -ENOSYS;
-		goto psx_del_no_retry;
-	}
-
-	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
+	else
+		rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
 
-psx_del_no_retry:
 	if (!rc) {
 		if (inode) {
 			cifs_mark_open_handles_for_deleted_file(inode, full_path);
-- 
2.20.1

