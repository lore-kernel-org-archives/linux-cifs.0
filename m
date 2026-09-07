Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967483F44E4;
	Mon,  7 Sep 2026 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811223; cv=none; b=g1Nte5fvaROyaPkDlUR/RnT0n6CI1wHxX85nZ6u7FnXOOQTrKGKYZCRbAnjiHc2aozpl2r7em3ZXoawgfhv3CriVLexMGmpRieSys9/492ToImY5TcpZE+IG5BXDsd8mBbmQ3J5enmi4uPWPw1F1OrN5GBl2q78dlFcMH0FzVoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811223; c=relaxed/simple;
	bh=dgxsJopgTj5wBot0SXP5pQPNNnJcDf4YEHZSuLZHtcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMmc67iR1BA525XXs/5Qv5TA0gyRBFgjVjOncT84VSRw9XQbTC+7jl0OlnDDxMy3T3szaKS4CIYHydYmdzXJE+tlqxMCpBotfYWyeKN3gFEF2CAeE89SAK4QPZRIu0FfoF6ygWC7PYRyal/H3VSLScMz43KqaQmSWC7nMgGJLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOsxdECu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOsxdECu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAA71F00A3D;
	Mon,  7 Sep 2026 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811222;
	bh=1SFDvVYmxlrLLWD8mX9hRNEALJYTpyJAIxl0gRU/Myo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOsxdECuGUvN/Ez5FFHxQ3RuXntKy7xCtJxxQlH/NtzGs5Fw++7P0yBaUDXpAi6gz
	 b90XdCJxw+QMyKABi7y71WuYDwbVGZ45uWOo9zgVseByqRE8PE4zE6+XSA3R3uW8GF
	 pK+MXfVJxI26xUqzc6A+sKfRAM+8/4Yck8O1fPjByJIRhQn077/3SB/CVqRAOydCzt
	 Y5Mv5qRicGCj5sI8s6FXSDtolnjSX4Tl6vmiXljH0gZilVCTyBNv1jGX5ZB0qndgrB
	 ifkmKZS+1R/VfNDu+6vdeK4Cp9VmLf4t85MDdGPVgvVAYYAdUS+wiQWJMohBj/vRAj
	 X2AggbH1H5sdQ==
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
Subject: [PATCH 6.6.y 2/4] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 16:00:16 -0400
Message-ID: <20260907200018.326904-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907200018.326904-1-sashal@kernel.org>
References: <2026090303-fiddling-giant-6389@gregkh>
 <20260907200018.326904-1-sashal@kernel.org>
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
index 1f2ea9f5cc9a8..4c2e269a268ed 100644
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

