Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7257B34F46F;
	Mon,  7 Sep 2026 22:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821160; cv=none; b=XU58YPPiOfCIVP98QdtTUXq0TrjLmQKj2HibXJ4MQ6bDlsZq/218gann2JNEWBgZmgC3oLBRfqkmlwMZPqzzJw7389WsAaEjFUqb01E8eOJvHzHOJsM/iZjKEBdIvVOAS6M7IsSCdSTuS0p0R/8rTKauWeYqCBx4GSRTjwacAAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821160; c=relaxed/simple;
	bh=yMPnLwqi8orMdx/2L1GXXUrda8ZLSoalzN1KB8/7H08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAr2QOG7wIIySQQhzYqF4VAbIdqMpL3BhxFEANfBISja4taFk5xIE3QTOAUBfNlsH5P0jsSlSGdYNaK8F94LFcMbhJkRoLyNE6nilCq72eIldHZdOqUMhhsCaj0XjuEwcKVMlYIP1GMH5VjWpVRa1F3M4NwNRr0WIjuTftNCflE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkwddwFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkwddwFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305731F00A3D;
	Mon,  7 Sep 2026 22:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821159;
	bh=hr1zb6ZX7LnLNLAOee27fODP9czrrJw0+4bGgwzJMhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkwddwFgFgmjMa1jW4U5X8O2CkOICrtspwPfUUY3fvczFVtuOpiRk8WF67cLINcRZ
	 shtjmQkisIba1afq2f03TDhmauVP1S4jeI8Tgc0HBEw0hkfyXqKeSL8IUZXeSECuwp
	 PPUpKRgO+ZUwhDVd/F5pLqtIfn0l443TtAuuufH8l7hookYbWLYJpyFq0ciUvZtxZQ
	 9xivM120NccneTsbVBHtswgxqawUQCnRSWatlZjiRX4nbbY3UWoB5dxyPser4U19GN
	 L5F/GE0asnzwyTMPs6zXc6RG4O0wMcocaSt/8dGNTZIaiSXbAUqkGLMmfdMwrXVk8C
	 9kikiUaCm3+jw==
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
Subject: [PATCH 6.1.y 2/4] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 18:45:53 -0400
Message-ID: <20260907224555.689206-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907224555.689206-1-sashal@kernel.org>
References: <2026090304-drowsily-unread-e280@gregkh>
 <20260907224555.689206-1-sashal@kernel.org>
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
Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index c691b98b442a6..e89d26c6e0862 100644
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

