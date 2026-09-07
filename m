Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F9286A4;
	Mon,  7 Sep 2026 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788742987; cv=none; b=ptdZBFgPMF/y4kBDac/MYP0jXO7fqJ1O1wfXQk4k3mVA692KBvHgGPTw0JSdIMOYW3Txks92BGDT3c4WqFw6N0J+PWU0nPbdDyDZSN1J8oh7/ZLjDQ7YVTExlrkDeCzdIZB3HXmMqklKsFtcMRHS4Todyc5ovMZRq2rnvapI3Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788742987; c=relaxed/simple;
	bh=SwiJvY7841r6HZHeU3Kbv2XYqlZY16xDqfek92Kbfqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=benCM5GE+X24obu9DV9kBH9EWqU89bLIkD9HTdj6Wa9cmq3XakBEPMRQZraxW/s/pHEUdg1Fsu6vfl2+PJtqW4SaP+GE7AIVoED6tRcEFLnaj0pLr3x0E5dtkMnOQKO/WAivItENrR1hw207yI4s1p0/PiqdpQn68ALWkEZYghw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNm1iMUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNm1iMUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447271F00A3D;
	Mon,  7 Sep 2026 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788742986;
	bh=DpVjTYzqKoBwjxX/qPfSlinhE5TBflVi14T5Md5AzCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNm1iMUCWwab2oBHl1hUlMIQ78luuvHSVDja1tXXaQmLRjIuA01I00QrJQhYduxp4
	 EaTqRPy299MHf2Y0BjAisMCYNVgsrjaw5iv5qvFtoOH4mBZJryGUNEPstaGpvuU9eY
	 /UjvAMngPKe7JJRr3TlteGdxW2vae2xXNscUH+jVVL4zRFpKeyB3FXhdYXP1SEdlPH
	 8XtPyfSSGqqeQgMIKVg5z7oFdnGuI0uWXu955gQjdpa2q5rqNMRCTQWtkzedEw0tbI
	 XGE5EIcaX2fs5T5jw1sgWPCVgTj79Mi6+RzrV2Ci6lkzI37j3EhUzL1iPfcVQM+DXO
	 gLs9I4LbMOOUA==
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
Subject: [PATCH 6.18.y 2/5] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Sun,  6 Sep 2026 21:02:59 -0400
Message-ID: <20260907010302.1949559-2-sashal@kernel.org>
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

[ Upstream commit bc3de356aae666de5d8b5131545be87cf7754431 ]

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
Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index f06cb24f5f3cf..b6c94db5edb94 100644
--- a/fs/smb/client/fscache.h
+++ b/fs/smb/client/fscache.h
@@ -38,12 +38,12 @@ struct cifs_fscache_inode_coherency_data {
 /*
  * fscache.c
  */
-extern int cifs_fscache_get_super_cookie(struct cifs_tcon *);
-extern void cifs_fscache_release_super_cookie(struct cifs_tcon *);
+int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon);
+void cifs_fscache_release_super_cookie(struct cifs_tcon *tcon);
 
-extern void cifs_fscache_get_inode_cookie(struct inode *inode);
-extern void cifs_fscache_release_inode_cookie(struct inode *);
-extern void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
+void cifs_fscache_get_inode_cookie(struct inode *inode);
+void cifs_fscache_release_inode_cookie(struct inode *inode);
+void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
 
 static inline
 void cifs_fscache_fill_coherency(struct inode *inode,
-- 
2.53.0

