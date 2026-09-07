Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF061C69D;
	Mon,  7 Sep 2026 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788742986; cv=none; b=a08zw+gG5RDZiO/a18V3IUHzUBkX96ZtRu/k+Yw+NkqL8AqgF5qZwD1iy9tVPLYb4aRCOpRQP1XjCDHGtH4NoiTw7oq26UqTvRVjqnRtdC9bmJL57XCa42t7OBDH+fMNHHnbdoheUJfiltDlD3p9YpYPcsinKzGzTt8/yzD85oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788742986; c=relaxed/simple;
	bh=KKUPqOlYgJtU8/img3Am+mLwMd9fiVviOxLhsk1h2iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afj38v+OW/fxTZPTB1hbLI6USMsgihxO3w2eQKLGPtg1Xv52N9rmaO97h0rVtvA0QAU+qyZ7u3OoSVTurIYqVmwxbOTDzzlsvOaFUGpEO8eZv13bjhH8WoewlVYAmdNliI4KgAKi4p9LHIigo44sKpAslWx2cgQSuiu1frTJq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH5+PN5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH5+PN5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D021F00A3A;
	Mon,  7 Sep 2026 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788742985;
	bh=tSiNKOaWd0kGE4TaHFC/6HH1cBqoq/AO1cl2Gv4B9jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH5+PN5gBql3y3sMMAONNdUGjgTWLzLElIeB9EHpSS6niDuTqA2UCS9nqLA2wYQ/F
	 pAHmJTJe1UPXbwgZ3AUehpteuZcqBil7M3fmRfAOLPqg2WpYn1sSCoaDBD/aG3ggTj
	 k0dU8WFN3x6vfGAcxjg9sm3l7ZiK11m9mske8QKrunMnvXb0L18dAPnpsJd6CDfWQw
	 pLxI3YlqpPk/lC7Jzgu3t8tIMFBsqvwMlFK2rZXPykSQdfgylKlrT9klV1F6Qwr1gF
	 SJWyW7vx+9nnUtL32F6yd5IUmPO00Z+IOfCcZwic2XcfXWOjeUJbAP6Tfjtth5EL1s
	 zCsyCMda9vSUQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 1/5] cifs: Scripted clean up fs/smb/client/cifs_unicode.h
Date: Sun,  6 Sep 2026 21:02:58 -0400
Message-ID: <20260907010302.1949559-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090324-defraud-tremble-b3d8@gregkh>
References: <2026090324-defraud-tremble-b3d8@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 696ca7d95658224ba807813101d0d5714d1d8aa4 ]

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>

For the stable backport, drop the original header cleanup because the stable-only __KERNEL__ guard makes it conflict and the target does not touch or depend on those declarations. Instead, carry only a behavior-preserving local snapshot of mnt_cifs_flags in cifs_setattr_nounix(); the target patch refers to that snapshot in its new setuid/setgid condition.

cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org

[ sashal: Reduced backport -- upstream 696ca7d956582 touches 1 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/cifs_unicode.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c9e955d0d799e..88307e6b48006 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3292,6 +3292,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	kgid_t gid = INVALID_GID;
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifsFileInfo *cfile = NULL;
 	const char *full_path;
@@ -3306,7 +3307,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
-- 
2.53.0

