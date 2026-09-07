Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC0C526A9A;
	Mon,  7 Sep 2026 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811226; cv=none; b=P0CbLGozKZPhQTUcjNBkFcw7QQ2lWRJ728pxfyhcrD2O3UQ+GGUUdF9sc4INeF06D9647WtGjh61ZO9z6syMNFHgLSoS/6zAgSybpVMRIV3mpJkdbVfC47PNu89fweaOYPR1OVBllJ6uUUA9/iMtceZkqB2ZfEjDO+vcXOy6IGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811226; c=relaxed/simple;
	bh=UE3DvX9k8x91jIsR3T7WdH/vrR1IFqo7ESsc1dwiytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLQ1I0/+hDdRUzWm/DCUUMgTxn8eSl6f170ScJL7DV5KE8RzYlSfNKMnQKjIh+tAxvMm4Ci+GkO3DYLU960NoP0hB++BBNYT1a7RPIW+EMDhikywa8H0LvEBANLfJHiS5wxJaAIODfJQrK9favWma7JcaE5nu0rptGTIHnaBWUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqlpQ23S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqlpQ23S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6061F00AC4;
	Mon,  7 Sep 2026 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811224;
	bh=L3r8c6+2/cREJq285zS5xtPxoOkK62q7YUlNvEziciQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqlpQ23SM/ZXGmyaTCy6oS6Eaof1OYm4GhtxpuXHzC9bJXShkw8A0ZJXpT+5JDe9X
	 s8duvyPFr/LOQ7/RAmo/lBILWFBBIWLWivkH8DZ69Omogf+2GvQJE2AlNXzwquK9bC
	 e4PUVKX7k4doIOT3X0af+XZCR1wJxojAnzjSwsLCT6EFvFd65D86vaxsBdxMbwJmxW
	 hhs7k3Eww7pwViZZhBUFhmDx6jDQIj70CB+5DzlaDfkkx2ii8CorAOneDqJMON+Hsr
	 oJnLNYdoApICRkWoa03ouFCtRQu6RxmN/BzJKZ9klvFPHEVIweFVpYErBFWJTFyTuE
	 dIVhoPml5A2vg==
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
Subject: [PATCH 6.12.y 1/3] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Mon,  7 Sep 2026 16:00:20 -0400
Message-ID: <20260907200022.327035-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090336-rising-foyer-5fb8@gregkh>
References: <2026090336-rising-foyer-5fb8@gregkh>
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
Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
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

