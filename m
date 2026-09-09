Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F35867F1;
	Wed,  9 Sep 2026 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964781; cv=none; b=luy83Y3nBQruIwbbraJLvGMh9iHrfE9kYqN6y7S9NA6wzN1h916cjy/K4BhGO3MtGM/2O+e2yk12j0EHpEqzf6rj9BjzbPDEO3d+v8pfO85k8nQpebkkR3v8F6z5H86BQbicqKfOJbPIet6Ok9QVnB6S7QTEAnjCgEJZoF7Pir0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964781; c=relaxed/simple;
	bh=9OK5JlF+P65HPu13qL6Xiimdvbv69bBWrLTWsT0flUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlPDrMCEjvB3LzOjI/XSZUN7/kT8rOQFFXeQoaOR1qIDTmfzJ2sCqEJ+rm35RChvRmR1x5RcJbpfuvl/XFpFtgpob+rcOBway4ofDytuXcRcRjKubPA5e4OONhhMdq5RlRrf2zPQPfONPpW3S1mYj9UPKYgsbv3UZyof9ttM/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUrQZXFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUrQZXFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA51B1F00A3D;
	Wed,  9 Sep 2026 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964780;
	bh=Jt/ZLzMuioVM2lKFY41maX+aPGd1b/NQJUvMCiIQi1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUrQZXFwAR08P0pCMB8cC6M285Z0EXghdBCliSUfu9+r2e7385T4OX3ngZt5SJm6e
	 CgqcB5NGmHF1CBWisfH1LUwXOZKRx7bEmQdn+nhssjROEa96CpqFXglxkwZrJ+g9t8
	 yel7Y0KSHffNE6miwHUV5SnU52tEQK8NN2hXy1LU=
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
Subject: [PATCH 6.18 541/583] cifs: Scripted clean up fs/smb/client/smb2proto.h
Date: Wed,  9 Sep 2026 15:43:46 +0200
Message-ID: <20260909134256.502125121@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3202,7 +3202,7 @@ cifs_setattr_unix(struct dentry *direntr
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 		attrs->ia_valid &= ~ATTR_MODE;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
+	args = kmalloc_obj(*args);
 	if (args == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3395,9 +3395,9 @@ cifs_setattr_nounix(struct dentry *diren
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


