Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323E13D332A;
	Thu, 23 Apr 2026 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776927048; cv=none; b=P6X1c5BRtSUiCVT7kh1qudcCJZ30oU3xXKw5eDXKIERtFdPXTWeujn0Clt+qWOmh3T3EOKRAOYSDkzabbC8U5vhKQCSA5Qq+rItAQLiQgi+aubMFrQXP5PuMNXc8TvK43ck17EeooPMif7rRCz3tA88nnAdNsKv5OjEeRYbekMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776927048; c=relaxed/simple;
	bh=7H9ZOp6CnJc9xQUSM5oTTtu+rtc+Stelre6nEGmKuto=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rGpEol09s5Ykl+t0YzHoIIVicGBLat55DaG4O4U1KVT/xzEy2HHezJYYXlAWPUlhBZOIGZtTl6QSK80pnIYEBFOolqPAABqk32oons7ew/L876BzjygSnjGp7ZdGUxSDQx7ua1XfzUuDt80h5K0NG+StsFbaE3WOMS7+zxvJmUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnMa2Fmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnMa2Fmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13214C2BCB5;
	Thu, 23 Apr 2026 06:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776927047;
	bh=7H9ZOp6CnJc9xQUSM5oTTtu+rtc+Stelre6nEGmKuto=;
	h=From:To:Cc:Subject:Date:From;
	b=BnMa2Fmz/xve5din6HaUrbn6/WbFZzP9eBNb8kIxDzul5wqlmdJEQ5vJdMzTPUXc4
	 loFqmghwQcAeACNsVAv6CEf/jLiT7892hLZTjP5LbowY5MqK9G29nw+/9zU6DgyWiM
	 KyOGySsw/YiiJdBOe0ND1Hd1b1pUNjCqA9oSWCoCVir92BBgGq2dA4R1CflVt2fCJY
	 jTZNzt3O61WbFypwTbB/2H3dZfbGZn5J+2VsfT/fG7fVp3g/OATuB6D7YoHGXcdUzD
	 GvMeYL4oQDjsbDX3lrIv6yUgZLuZYu2DEI6S81g8ZF/iK5pUUO1pgOaolr2hnkjJgn
	 UqG1a0jhWnsxw==
From: Arnd Bergmann <arnd@kernel.org>
To: Steve French <sfrench@samba.org>,
	Enzo Matsumiya <ematsumiya@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
Date: Thu, 23 Apr 2026 08:50:30 +0200
Message-Id: <20260423065042.1898971-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_CIFS_DEBUG2 is disabled, the only reference to this
function is hidden, causing a harmless warning:

fs/smb/client/cifs_debug.c:395:30: error: 'cifs_debug_dirs_proc_ops' defined but not used [-Werror=unused-const-variable=]
  395 | static const struct proc_ops cifs_debug_dirs_proc_ops = {
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~

Make the #ifdef checks around them consistent by always using
the DEBUG2 variant.

Fixes: 63bff18d4aa0 ("smb: client: fix (remove) drop_dir_cache module parameter")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/smb/client/cifs_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index f55e5cabdaee..9a2e796161d0 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -306,7 +306,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 	LIST_HEAD(entry);
 
 	seq_puts(m, "# Version:1\n");
-#ifdef CONFIG_CIFS_DEBUG
+#ifdef CONFIG_CIFS_DEBUG2
 	seq_puts(m, "# Write 0 to this file to drop all cached directory entries\n");
 #endif /* CONFIG_CIFS_DEBUG */
 	seq_puts(m, "# Format:\n");
@@ -356,7 +356,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-#ifdef CONFIG_CIFS_DEBUG
+#ifdef CONFIG_CIFS_DEBUG2
 static int cifs_debug_dirs_proc_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, cifs_debug_dirs_proc_show, NULL);
-- 
2.39.5

