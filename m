Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4512D63E5;
	Mon,  7 Sep 2026 01:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788742990; cv=none; b=NRZjuuzImWeFoPmFsMXLe55oo0sY2pkqPKdB3QB/uvxWSCpSWYRU3YwA9+b+s6Dxpdy6wteIR9aOMwctUylQUCkeun+VClW87UqkkdzbDJdlsuTL9KIwDA2QcRuwUmpIUsYdZar7qZ2nE28i6l3o73N797sz09E9CKenscdQj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788742990; c=relaxed/simple;
	bh=htVJA7Xdst3DKhsQ+H7Z+xJVMBvtRmY2KDlGYxYd1K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhMu0pd71rKFcl1bBQEKaNAnZlHEFhY2jCGrLVlA4Kv5OIXSIlr4HcsW4M5ikg7LIHauzCapZMoKd8G623wwUq/UwqXNcLY0VhVrXjDs6HDiqJr4ewTqTmGwi39TJKXLI32eADekM/p/ETKULiHFnDFGmKpFlxM+pGa3y2924wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gW8yvW74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gW8yvW74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1BF1F00A3F;
	Mon,  7 Sep 2026 01:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788742988;
	bh=VAt75mmVa6Rv/fTMilrWmbij7UoDmnN2Izra4rU9t9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gW8yvW74pgGwWjJvl9yBJVdPyJx31t6ZpGflcjsQ9AmMOZbK2WEGJu8IeiBTUYGr9
	 3kz68aRWMPcVtMJgEgRB9Oo2cGk/NbTi7edURqpg45b72RJ2ivF7DVxqADzLl14Wm3
	 TtbRHKZEkueXx70AetqDWdOQOIv7mYpy65aHb3Yza0VM3m14ADdehhlWqqpCd7em+i
	 dMPkSov8wL5F4962wtFeiUZKrKe1K9P4rb7joOu2d4I9ArQQfv1ymcV+eHv9jlj5Vw
	 q4cEFBlxyyFIjjudDfeWa4EZHjaqzgGcj9Drn6HcFNrHEVOHsIq5dicHtyE9DUuZD5
	 C0S26b7GBJUKg==
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
Subject: [PATCH 6.18.y 4/5] cifs: Scripted clean up fs/smb/client/smb2proto.h
Date: Sun,  6 Sep 2026 21:03:01 -0400
Message-ID: <20260907010302.1949559-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907010302.1949559-1-sashal@kernel.org>
References: <2026090324-defraud-tremble-b3d8@gregkh>
 <20260907010302.1949559-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1e009e3346db230787685a3989fd9c346fb412fb ]

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

For the stable backport, drop the original smb2proto.h cleanup because the
stable header has gained and changed declarations that make the scripted
rewrite conflict, while the target does not touch or depend on the header.
Instead, carry only behavior-preserving context preparation in inode.c: use
the type-safe kmalloc_obj() spelling and the existing local sbflags snapshot,
and brace the adjacent else-if.  This allows both target hunks to apply
cleanly without pre-applying the target's behavioral change.

[ sashal: Reduced backport -- upstream 1e009e3346db touches 1 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/smb2proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

[ sashal: Reduced backport -- upstream 1e009e3346db2 touches 1 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/smb2proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 88307e6b48006..f5b0596442bac 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3187,7 +3187,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 		attrs->ia_valid &= ~ATTR_MODE;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
+	args = kmalloc_obj(*args);
 	if (args == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3380,9 +3380,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				goto cifs_setattr_exit;
 			}
 		}
-	} else
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
+	} else if (!(sbflags & CIFS_MOUNT_SET_UID)) {
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
+	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
-- 
2.53.0

