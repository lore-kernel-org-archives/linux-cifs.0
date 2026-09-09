Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58DE583ADC;
	Wed,  9 Sep 2026 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964773; cv=none; b=pGXbQIqSxIUBg2x24Ui+kQBj/U3o+aze7TXvHmJEXgppFuZcZPitnLNs5KEO1vleqP3lnENvFbey1tesnUmcRK4m/oye5x935Bi9ZWMno1GqHZT/gCVXTIX8CPNBeLQQ7RH/M9J1pjyatFHLVokdnAGSrjbdmdB+WTWrNFFabqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964773; c=relaxed/simple;
	bh=COqaeepJ34UP9JkjD+7E0BGwfxYsZJeDT4TvX3LXCUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojXh1gIKCC5zpHJDRCVBGgpB8aSVT+yYD6KGmic+ldiFw4ZYdLnEp9IOKErvCXG++moppqzTyXlvmKe01hSWwfKP4hQIOt0dg6PfAwG/jr5NHmxdKuWHD+8PP3Vg35XVOEHbTTii9P+d+6dups4y+HbJXX3VOpTASPkB1LIBD5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6d8BOJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6d8BOJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E22D1F00A3F;
	Wed,  9 Sep 2026 14:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964771;
	bh=krXnjg6Pwz8O/sUpJFYknubsldGm0fpI+pROTsHvcUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6d8BOJ4LY7ycfGSICfj78vSLTkMh8siSng7seWwonXZVXKx/NvkhnlUBTWr4jHyL
	 BzEdy5ru2P8b/ytPK3ylezVV4ilJ2I5zdCe9v8knYu1eStbOZNx+Zhl2X0qoHyybkM
	 kGvmNFZR/WaL7toWAzLu5AEXaUdcCJLgK5z1VUzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/583] cifs: Scripted clean up fs/smb/client/cifs_unicode.h
Date: Wed,  9 Sep 2026 15:43:43 +0200
Message-ID: <20260909134256.410787177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3307,6 +3307,7 @@ cifs_setattr_nounix(struct dentry *diren
 	kgid_t gid = INVALID_GID;
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifsFileInfo *cfile = NULL;
 	const char *full_path;
@@ -3321,7 +3322,7 @@ cifs_setattr_nounix(struct dentry *diren
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);


