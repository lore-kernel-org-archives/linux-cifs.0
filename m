Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E6D1A6836;
	Sun,  6 Sep 2026 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721687; cv=none; b=EM6QJKIPRYcxcRPea79PAP28oKccYA79FnOCJR1e9hTjw17hpnB6Ose6fOxN2IlGSPEkuMMDDY0u1uP/8k/SmJLrmT4wP/P7P5pxE/vvKZsldaRC0XVZ39g7Lx4/e3abawdsTEAqfECth4eKoAlVxvttl82LolBh0w2Y53eO3SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721687; c=relaxed/simple;
	bh=73hW/ojDP8QUzwM/c2MQvta7xy4nuakxkwR2wIKXCQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VeciQ6pnCjHVzMQ0S8r+K+yaLgcnO7YsKJzoO2tWblL6HM9ER0Vjvztw2GrD3BZEixHrwGlkSnlbPhw6qvzqY1R29Y862boH8IJNg7m58ZmH8xCzn2E/JkQd7MXZPHNDooFI7a8KEG30k6WP60mAf3JKxsBXBWa9/3tpJqyni8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=b6NG2Y6d; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="b6NG2Y6d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=KK8JPDdyPpMg5VDkfRB8LYWcfgfH3UrRsjFE/UBZu9M=; b=b6NG2Y6dFYu12rAwb9NnmSLuJx
	/S+3hMO6r2MInK+vME4xRitt9Q3Hkwtha/+Pbq2woLwQyf8+SQ3958AsRarvKRcZ2IH+wB0mmMFwH
	TaltNyk6yCm/00MnQd90gouOnfmutM5lVJ1Zyjm/k5+9DLtt6a6xlvbkp5M+7jXZ0FNVQhWGB+F4b
	ng0Rui/jWXAf8Vw3pJBHd4rKFoLS7nfaC2juMqN7IYr89t+Z82HMC75U9AWOWZDehkY4IwGKYq1hy
	hVp2UR0vTwa9mCUHdM3rbzeZFae7KbFloOxniyVb2qOMzvcxojHrUcBkwfCoCpKsqgOWdOWiUsTWJ
	DU9JtC3Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3IDj-00000000o5c-417A;
	Sun, 06 Sep 2026 16:08:03 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Arthur Lesuisse <arthur.lesuisse@ulb.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/7] smb: client: fix uid/gid override in getattr with posix extensions
Date: Sun,  6 Sep 2026 16:07:57 -0300
Message-ID: <20260906190803.667489-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting with 'multiuser,posix' options, cifs_getattr() overrides
the server-provided uid/gid with the current process's fsuid/fsgid.
This is because the condition only checks for unix extensions
(tcon->unix_ext) but not posix extensions (tcon->posix_extensions).

With SMB3 POSIX extensions, the server provides real uid/gid values
just like with unix extensions, so they should be preserved rather
than replaced with the caller's credentials.

Add a tcon->posix_extensions check to the condition so that uid/gid
from the server are properly reported in stat results.

Reported-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Closes: https://lore.kernel.org/r/DB9P190MB2012266F6B8DECBE5D26A1798DB52@DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
Suggested-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 12ed8db10e00..49f9993ad567 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2992,14 +2992,14 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	/*
-	 * If on a multiuser mount without unix extensions or cifsacl being
-	 * enabled, and the admin hasn't overridden them, set the ownership
-	 * to the fsuid/fsgid of the current process.
+	 * If on a multiuser mount without unix extensions, posix extensions
+	 * or cifsacl being enabled, and the admin hasn't overridden them,
+	 * set the ownership to the fsuid/fsgid of the current process.
 	 */
 	sbflags = cifs_sb_flags(cifs_sb);
 	if ((sbflags & CIFS_MOUNT_MULTIUSER) &&
 	    !(sbflags & CIFS_MOUNT_CIFS_ACL) &&
-	    !tcon->unix_ext) {
+	    !tcon->unix_ext && !tcon->posix_extensions) {
 		if (!(sbflags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
 		if (!(sbflags & CIFS_MOUNT_OVERR_GID))
-- 
2.55.0

