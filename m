Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFF026B942;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=VCDXENep3TK6dkWIVwEVmMo7CVHwC+pNCspr3fwaxslejPiCpJJBz22ZB7py0Vi3PKLd0NX6tAY9z3rVGZ6NaHX6MeJZhrZQHJTvaS9+ug6qM2qJ7nUoY/pndYDntoMW6hVJHziPBP88JgQxb0HxtODvHll4M7mK1e85w1yY3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=BndpzTZJgGQ5KAp6GobzpPt6z1nG2dr2yHF9QYRGqmo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pE8Z8UH+WFs9jb6HuVUFzyNbbvDizc5MvbQxr05Hk/BPNreHGs79drUpu5yBz3/oIRu3lG1eb/LDy5LXSmXFIiMk9ZOrNUrQVxKZMs9NR4yjxw59s8GfZ5MK704UxBQCGiIXKfZhod4FMFIZgYuO5hQw/31Ht6LvDWZ02Vk3his=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pk5HlR9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pk5HlR9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82794C4CEED;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=BndpzTZJgGQ5KAp6GobzpPt6z1nG2dr2yHF9QYRGqmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk5HlR9a3ZewV0KhjQxW0El0EfA02bYCIaaQE6m2cMlHR3Fk7D8gQQqUcqEmrVr+v
	 0GzvPJJ3nBv+HBziEMURGVXiLp15Bx1Ohk3/H/lWk5CJbnya+9NCoaBo8ajZkL+0d2
	 otFD8GkLihydpkJrsU7iWD6xRk9G2HySxz3C7lczg4L8Q0wsRJLJHaX2gpJj5e+sNy
	 ATuzhXUsRz0IdoDIlwV49UNK9VvFbNF5kgIuI3gVZb+Z4J6KBh8zyxISVj0oYVdeEI
	 yMYNJFUce/W1OaSvf3kYe4RPkaqg1JWMTpK5fayPYaE6y/Z5w7+sx7Pe7VC8wzQyME
	 bIXV3L39WdtzQ==
Received: by pali.im (Postfix)
	id C97641857; Sun, 31 Aug 2025 14:36:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 35/35] cifs: Use CREATE_OPTION_EXCLUSIVE when doing SMB1 rmdir on NT server
Date: Sun, 31 Aug 2025 14:36:02 +0200
Message-Id: <20250831123602.14037-36-pali@kernel.org>
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

Windows NT servers just set the DELETE_PENDING flag when executing the SMB1
SMB_COM_DELETE_DIRECTORY command. This is opposite of the SMB_COM_DELETE
command (can be used only on files) which completely removes the file and
not just transition it into DELETE_PENDING state.

This means that the SMB1 rmdir against Windows NT servers has same issues
as SMB2+ rmdir and silly rename needs to be used. As in SMB2+ rmdir, use
the CREATE_OPTION_EXCLUSIVE logic for issuing SMB1 rmdir when communicating
with NT-based SMB1 server.

With this change Linux rmdir() syscall called on SMB1 mounts from Windows
NT servers cause that on success the path would not exist anymore and new
file or directory with that path can be created.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 37bc0541bc21..31638b71ee0c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -823,8 +823,53 @@ CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int bytes_returned;
 	int name_len;
 	int remap = cifs_remap(cifs_sb);
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
+	int oplock;
 
 	cifs_dbg(FYI, "In CIFSSMBRmDir\n");
+
+	/*
+	 * Do not send SMB_COM_DELETE_DIRECTORY to NT servers. NT servers just
+	 * sets the DELETE PENDING state on the directory and in case that
+	 * directory is opened by some other client, it stay in this state and
+	 * direntry stay present in the parent directory.
+	 *
+	 * So for NT servers use NT OPEN in exclusive mode. It fails when some
+	 * other SMB client has the directory opened, and it triggers the
+	 * sillyrename code path. After successful NT OPEN in exclusive mode,
+	 * sets the DELETE PENDING state and close the directory.
+	 *
+	 * Servers with UNIX extensions should support SMB_COM_DELETE_DIRECTORY
+	 * with correct UNIX semantics, so use this NT OPEN + DELETE PENDING
+	 * only against non-UNIX NT servers.
+	 */
+	if ((tcon->ses->capabilities & CAP_NT_SMBS) &&
+	    !(cap_unix(tcon->ses) &&
+	      (le64_to_cpu(tcon->fsUnixInfo.Capability) & CIFS_UNIX_POSIX_PATH_OPS_CAP))) {
+		oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE, FILE_OPEN,
+				     CREATE_OPTION_EXCLUSIVE | CREATE_NOT_FILE | OPEN_REPARSE_POINT,
+				     ACL_NO_MODE);
+		oparms.fid = &fid;
+		oplock = 0;
+		rc = CIFS_open(xid, &oparms, &oplock, NULL);
+		if (rc)
+			return rc;
+		rc = CIFSSMBSetFileDisposition(xid, tcon, true, fid.netfid, current->tgid);
+		/*
+		 * some samba versions return -ENOENT when we try to set the
+		 * file disposition here. Likely a samba bug, but work around
+		 * it for now. This means that some cifsXXX files may hang
+		 * around after they shouldn't.
+		 *
+		 * BB: remove this hack after more servers have the fix
+		 */
+		if (rc == -ENOENT)
+			rc = 0;
+		CIFSSMBClose(xid, tcon, fid.netfid);
+		return rc;
+	}
+
 RmDirRetry:
 	rc = smb_init(SMB_COM_DELETE_DIRECTORY, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
-- 
2.20.1

