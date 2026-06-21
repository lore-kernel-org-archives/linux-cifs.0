Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF572621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046183; cv=none; b=teMOSe00ume9O4T8u4OAZfgHIiWndHl0bIDIRl4tlRcsCSG/25TdVWYhzcJ2zBAMgwVkeGlr4G4cnaNu9naFT8QnT6VBXd0e5cft+tuBBvl7R0Cvn4qZt38fJ/zccJ5QBprY7k1+mQxPX3e+pkRLIlOBdk7Qb9761mptwMJLf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046183; c=relaxed/simple;
	bh=bKP6AH05klnWZcTj+qsoOwupVFcUKuLZpnhHjIxM5rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkzEHS5qBQ6S5MF+hqx+4Wo/oX9TcDqi4nyUwjptE2SyPHmLTC0guE5djSSTYQEiK8y3M+oIfN6af8M9SBR9BHZSNoKQ5BG8MYYBptDDxe639mMV7ouy7b93F9aG0BGh+6RBTJORnaKlDBfOIlaoJ/Bt2Ofa/mseTOlYOiKi5MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0qf8kpo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0qf8kpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8151F000E9;
	Sun, 21 Jun 2026 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046182;
	bh=FSqUy5JSrm6LxFCcHs0CnpZ5wgTqH1tYa1OJdmvLtj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0qf8kpoQjvwJYzxsVZb1sEeQgCxxzZHDVpupfGoOlKpx+vqjUlv8QOH0Zqh501Bs
	 cNgLqWduRgP/BG86WyIrxSI0GeqIdhIuCMshMbw0Fqm08IuWQRAG/ymjJ4l1p5anUb
	 fKJKlFwVYn+0bx7CfEVGzAPJ96W791C0Wi6L18MKuYWSmb539BFh2QEKwPyOVvVXzB
	 OdLJi4eWDd0sN5JrzRLyrYZoZPaTshgGB+6addC3vEfkwrrmGKNJpa8tsIGSsUrNZn
	 pua+VVJ07J6kDDBMmIxHknX3+niQ1UzscC1POY6A52/ZJ4+ZxcKmM7RNnAMLuBqXox
	 VYcjN3s3BelUQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 26/29] ksmbd: treat read-control opens as stat opens only for leases
Date: Sun, 21 Jun 2026 21:48:41 +0900
Message-Id: <20260621124844.6235-26-linkinjeon@kernel.org>
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

A second open that requests only metadata-level access must not break
the existing caching state. ksmbd already skips the break for such opens
via fp->attrib_only (FILE_READ_ATTRIBUTES,
FILE_WRITE_ATTRIBUTES and FILE_SYNCHRONIZE).

An open requesting only READ_CONTROL (reading the security descriptor)
must be treated differently depending on the existing caching state.
smbtorture smb2.lease.statopen4 expects a read-control open NOT to break
a caching lease, while smb2.oplock.statopen1 expects the same open to
break a batch oplock. So READ_CONTROL is a stat open for leases but not
for oplocks.

Extend the stat-open break-skip in smb_grant_oplock() to also cover a
read-control-only open, but only when the existing holder is a lease.
The global fp->attrib_only flag (used for share-mode, rename and truncate
decisions) is left unchanged so oplock behaviour is preserved.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index fa7efd45b8e5..5b5783d75389 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -312,6 +312,18 @@ void opinfo_put(struct oplock_info *opinfo)
 	free_opinfo(opinfo);
 }
 
+static bool ksmbd_inode_has_lease(struct ksmbd_inode *ci)
+{
+	struct oplock_info *opinfo = opinfo_get_list(ci);
+	bool is_lease;
+
+	if (!opinfo)
+		return false;
+	is_lease = opinfo->is_lease;
+	opinfo_put(opinfo);
+	return is_lease;
+}
+
 static void opinfo_add(struct oplock_info *opinfo, struct ksmbd_file *fp)
 {
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1402,10 +1414,22 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (!opinfo_count(fp))
 		goto set_lev;
 
-	/* grant none-oplock if second open is trunc */
-	if (fp->attrib_only && fp->cdoption != FILE_OVERWRITE_IF_LE &&
+	/*
+	 * A stat open that only requests metadata access must not break the
+	 * existing caching state. READ_CONTROL (reading the security
+	 * descriptor) does not conflict with a lease, but it does conflict
+	 * with an oplock, so only treat a read-control-only open as a stat
+	 * open when the existing holder is a lease.
+	 */
+	if (fp->cdoption != FILE_OVERWRITE_IF_LE &&
 	    fp->cdoption != FILE_OVERWRITE_LE &&
-	    fp->cdoption != FILE_SUPERSEDE_LE) {
+	    fp->cdoption != FILE_SUPERSEDE_LE &&
+	    (fp->attrib_only ||
+	     (!(fp->daccess & ~(FILE_READ_ATTRIBUTES_LE |
+				FILE_WRITE_ATTRIBUTES_LE |
+				FILE_SYNCHRONIZE_LE |
+				FILE_READ_CONTROL_LE)) &&
+	      ksmbd_inode_has_lease(ci)))) {
 		req_op_level = SMB2_OPLOCK_LEVEL_NONE;
 		goto set_lev;
 	}
-- 
2.25.1

