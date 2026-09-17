Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD3C5519B0;
	Thu, 17 Sep 2026 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658275; cv=none; b=OynIga36ensEY6/iRtl+apLOZWdbInw7T0GXaph46JwF8mxJ2p55eNHCpmt+7LOmGRi0l0DZGOpZ1ajZckZkrFhFUhjNB7TymIR+l7CSCTTJucJgV+j+JnrR6hucz4aPX2QTw/qGmKilSrW942NxNVHRmGE5a+Wavr5Gibas1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658275; c=relaxed/simple;
	bh=rvt5CIJrbHWd4sAELtIQYAu7Ai57ZGbhmp3jblOMiF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPdqQNbeAlR7BVRguPQivFtt4ZCB9h3bIdYiuzapuIJ+tjibqMKCKvccJ/8CV8rXyr9p/INnHE8nfpzzdpFi07hkI3p0U1+RPdT2hewi7DN6rCSTV3MMoaSZYI2ejiJnUaorgh6xQ4k5aApzEaylfzaH9tqQdXkqabuvCW4l4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R71uWnyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R71uWnyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0021F0089B;
	Thu, 17 Sep 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658238;
	bh=ZmdxHkFnLeNovaDlMjskd3RcaNWFmWcNEgKv1LFLFLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R71uWnyyuQkmN1/3pjxhHb0mi9GhS3rTmMlbCu5LtHvlLesdIyvOX5yW58WC1CyiI
	 4uxOjqJ7FFSABz2LvqPbDw7IPyoxHTnzl08+AAhRN27NeQ0dTwxrohLkubV0YWqGUW
	 thb8G7CXhdX4daEsF9Jz/i3G43zTvL8aN3Y1EcFkAPZ2Q5gyeh5OYpizQ8C/EpoQu8
	 OuWt3k+qFuEzXwJ3UXN0oEI4l/cEtL7XTQqCCHZoe56zoZAG8vUi+CYeDrN8sxl18S
	 6rpYltMCXT3qJNLfjvEwJ3f0Ha28eMmqiSMQ8J6z7HQhxNv7y+BcWivm9gb2gn7ala
	 u/zcJ9MnbV0rg==
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
Subject: [PATCH 6.1.y 1/3] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Thu, 17 Sep 2026 11:17:14 -0400
Message-ID: <20260917151716.693532-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091635-bolt-hunchback-845c@gregkh>
References: <2026091635-bolt-hunchback-845c@gregkh>
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
Stable-dep-of: cf4d35896621 ("smb: client: fix uid/gid override in getattr with posix extensions")
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

