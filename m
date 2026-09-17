Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE5A4FB9CB;
	Thu, 17 Sep 2026 12:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649381; cv=none; b=AoH3Ljx8tFNYszX9XXl64l9ARKE8/3rIaxinKY9Q03ig9DqZqUw8DyqGU7oJ8+8pK2LFrkTlgVAq60g9cYKGIX85fsjKhn6z/s4zuOIO/LcM7Wuruf9htS6nhy01GrI+z8pHPvV4xUpMxYN8IsYi3G8eR/oXJfo2b4eLedBUp/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649381; c=relaxed/simple;
	bh=OrNMJlX1zxuaS6wi1UTSDsENeYQ81C8iH26bCgTtgdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByH+jSv4vUKECDVv8lsM+UaZpcMPj9rhBB5lB7c76ugdcYWFcb0TGUcjakyy0LzlHLtdSn1/dEmBAPmW0kVmK8zeP9U1L5rHdr1vhgzuwKh0DloOLJ7zqHy0RTXlhAyCH2q/0qcM0DCbNkVYEkbZOSkM7etfvWap2TzkLe+SCkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+ke1tZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+ke1tZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE3F1F00893;
	Thu, 17 Sep 2026 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649348;
	bh=aveD6KBd5uycTuODNpq8u+oRlcvnuITAB+fLcDHm9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+ke1tZNskd0x+LqfWzv5tQtvpd2/omKwfj7z01+95bbEmVNm2lDoauIW79RC892u
	 TqOH0mOBFZ0oFcMASJJQaXqAYXIpbG9AR6m9xpmJuEAda1C76BtkeoRiRRnzcf1PNo
	 01wNvU+Hbvxg+1G51HBVTgwxoImUtt/+XtsHM1BU+/kLCXU9F/JfHNHOl5UQZ+MWk7
	 p7/vM47LbhPtR4xlj6eQke0ZhAocGtGCL+O+CzaW8pLZMrIZg9fWE6rCsPuJfJoVMw
	 r8Fz6JoFEXLdKE5wlW8pjiMt2Jenk7mFBrMlieojgvNi9lTAZlK9AAdr8BVvjyGDDI
	 s1q/3K07zplWw==
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
Date: Thu, 17 Sep 2026 08:49:04 -0400
Message-ID: <20260917124906.224368-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091634-strongman-causation-bca7@gregkh>
References: <2026091634-strongman-causation-bca7@gregkh>
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

