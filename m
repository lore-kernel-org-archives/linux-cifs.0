Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60945336884;
	Mon,  7 Sep 2026 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781640; cv=none; b=lstGOS+kji50ZcZs+gvZ29XlIQ1Hhd3wFbbwvmjxlVIZkbKu89gLGtI3nw0Pzb70wd24Ame/Djsvj5m9+Dx3xvbPz+KK6wS66+BkxqaP9bvYAGUYrbmnmM01w2uWfnw1fot/FisQrBq0Es0WzsKzENymv1Xi2sk8lbwVyGpbIds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781640; c=relaxed/simple;
	bh=9FIWGwMJkZ/9DvqJbtl3Fuu2cQQXTPiOcgSLmXLVNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHDTWkIisgh1ZOjt+XKLeUqnE4Nw+X3aTcZJ0r7e3jn3AGENXWCo7420iufqMk3fNdvxdytRDSCjA9+N8cMkORwIR7BGwWYwpKMx/bT2Wq+rWdfNRd5t4JNHGChCH2Pavdn5CYyNukWSREoGYcVR9Vt0zwd7VjEpLzvnf+1Zr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V00p2QJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V00p2QJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062C1F00AC4;
	Mon,  7 Sep 2026 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781639;
	bh=gwhPhcKtPCCeAsMUccSwVUZHKPYlpVmAopTKyEWCjgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V00p2QJnEUFxCmrL8GHrqjz8yR0C6hkf8TvcKFXYHsO0a20lL8C5F7FRQclSay5qt
	 EhgL/OFnJDPnDV1A8B6q1wKP6qLQn7T0R5LminiLi4oBvhENxS2JYjMseCgN0EwWd5
	 qs/zs6RHlsRInZ3uYnliyDMYqQ04C8UcFQ+h4x9FErZmCKb5q1xOPJbPLXeOkwrVPV
	 VhXc969JtmSeQzUzQAFOZxnKRSFu85eLGwA8PWv1abSguVdimv8ulcVZjOXnDG8qHo
	 MsQko1cKQmmA4YIKrW07tqHZ5tw3yX4+5jkZByoItHJODgddbAQCp9G0MF35XlLVVj
	 nQMLXr/Tpz/kA==
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
Date: Mon,  7 Sep 2026 07:47:11 -0400
Message-ID: <20260907114714.2870258-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907114714.2870258-1-sashal@kernel.org>
References: <2026090302-harddisk-sinless-6dc1@gregkh>
 <20260907114714.2870258-1-sashal@kernel.org>
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

