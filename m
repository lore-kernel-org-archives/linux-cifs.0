Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F7C224F0;
	Thu,  2 Jan 2025 23:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858972; cv=none; b=NoAiCl+aIEgObVfOeWNG0R+Zmvd6IFeIyRGo6e3Kb5on8sT1krlW/9SuocnKQNzyB0BN1dlvoLClbPHObyi9JtOciFPQytyz7lmc+USiSVdUmI0JMW1q96cutYbexe+Pgy7APeTeyXWSLHGMOjAeAaRBqP+ZfVy2YcE5ntMHIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858972; c=relaxed/simple;
	bh=ahvk4LVsYkqKmffLJxBdrMC4LBoOnKNZmoLOiVRK+nk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=NXduhpx4e5u+qs0e3xRDxU/CuvucA4ynGRo3RQwAp2OM3ZL9zYsGKqzPzUaKeN8dBDuv6ng1gGTMTmozl310m5o0R2HypYq66/2018Ii2hMYL4oF5JTiVOzfh0CJPPREIbZDPFuqAdXE+RhIoL2YUuY5Pnt+AAt/UNd22NbjO9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itTXZT9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itTXZT9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF09C4CED0;
	Thu,  2 Jan 2025 23:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735858972;
	bh=ahvk4LVsYkqKmffLJxBdrMC4LBoOnKNZmoLOiVRK+nk=;
	h=From:To:Cc:Subject:Date:From;
	b=itTXZT9EyH5vxHuaVlFOirFsAijmg/LlzEyHj41/A6zv7mkH3jj9k/31XpwZsWoN5
	 OuKfkFpFAgibtx3ndHH7zDanojlEWTPwuU3If9PKdM1txRETBjKo63HetcfP24mBrw
	 BRxIBYncm5CUIqIBsL62S/3lh5lNgZdZC7sjHSjXu03Dg6ivC7LZmKvIRR6tw3AyAG
	 6xfp0R5+2wjb0yewmFYbYCKFpL0U+eZymrZjI1aVgSXEx5u9upHPV0NchHonUA0cCS
	 XKt9HT9wTQGyISsgFIAxpATOWCL/CopTwGal2rsvYq3gJ+IC3ZuMqaLoETT68Ay/D/
	 KEf+OXiGOK7YA==
Received: by pali.im (Postfix)
	id CEA96812; Fri,  3 Jan 2025 00:02:41 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Use cifs_autodisable_serverino() for disabling CIFS_MOUNT_SERVER_INUM in readdir.c
Date: Fri,  3 Jan 2025 00:02:31 +0100
Message-Id: <20250102230231.28026-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In all other places is used function cifs_autodisable_serverino() for
disabling CIFS_MOUNT_SERVER_INUM mount flag. So use is also in readir.c
_initiate_cifs_search() function. Benefit of cifs_autodisable_serverino()
is that it also prints dmesg message that server inode numbers are being
disabled.

Fixes: ec06aedd4454 ("cifs: clean up handling when server doesn't consistently support inode numbers")
Fixes: f534dc994397 ("cifs: clear server inode number flag while autodisabling")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 273358d20a46..50f96259d9ad 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -413,7 +413,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 		cifsFile->invalidHandle = false;
 	} else if ((rc == -EOPNOTSUPP) &&
 		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		cifs_autodisable_serverino(cifs_sb);
 		goto ffirst_retry;
 	}
 error_exit:
-- 
2.20.1

