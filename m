Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A633E3D94;
	Thu, 23 Apr 2026 09:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776937846; cv=none; b=ftE41pUYOslkGyQtBsOhn/i00qG55RVsITxDK2nkLMUgBAhhZDaAx8lxJBhoaejNgzgjmCXH/o0tiv9WaICG7M7sISzRBP7J4nCynPYBfHUzxPfKkVsXnWAOegZACdzxO4WFqcVdfOZRvPEqrmJyZOraSS9mZTiJm0LF/DB+8JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776937846; c=relaxed/simple;
	bh=yj1mvqHfxDhS9XGWQSouIxGCA9J6VRFxay8XYj4KAqI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EgrS9sDE8FbgAjjYIXEIFIC7/IQ8XFzXlXudvw6R4tWKhfoDu8cP0cLD2qkjUqk0R6MfPOqAdgTRXKHCLDFv+JNIjpFktzPCcM2ioTbhfusUny9We8eAlAdy6Hw6SN9+jueCOk9MA/JRjRz9pJB5leuqLxiJbhNIANz0+ue3dI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itpdcWi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itpdcWi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47362C2BCAF;
	Thu, 23 Apr 2026 09:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776937845;
	bh=yj1mvqHfxDhS9XGWQSouIxGCA9J6VRFxay8XYj4KAqI=;
	h=From:To:Cc:Subject:Date:From;
	b=itpdcWi+xx66WCNUeTN77cxm6srGySF4tJWs3DvG1M01rRsaK3527GL5gAyasSYSK
	 kYbvFIUC4HWxkBNf/CE26YOfHBb1Yf3G0c7u56tsB3yzBptVdtNMAe8CuC3GqPtS8a
	 DnFSKEr66p6GwiPIV6n/233sojftldOeFGu2JDTsu/ImSO9VNf6wfk7LKZyuaz9twP
	 7BLnHBd5prsV1y6uDuxkv8Ah5XOeTibvJvqJ7H/vavXfYEo8WT+55jbFkLiqUoHRby
	 dTYNMxCCa6HjayI/cKkFYS94EN2hiybQzbAnms7bUfi5f8wVvj8exLW0QzWMyfDBJb
	 50PXF5xulqP2A==
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
Subject: [PATCH] [v2] smb: client: hide unused cifs_debug_dirs_proc_ops
Date: Thu, 23 Apr 2026 11:50:33 +0200
Message-Id: <20260423095040.3169763-1-arnd@kernel.org>
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

Since the operations are now protected by CONFIG_CIFS_DEBUG, change
the reference to use the same one instead of the DEBUG2 version.

Fixes: 63bff18d4aa0 ("smb: client: fix (remove) drop_dir_cache module parameter")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/smb/client/cifs_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index f55e5cabdaee..1b5139a5e1f4 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -933,11 +933,11 @@ cifs_proc_init(void)
 	proc_create_single("open_files", 0400, proc_fs_cifs,
 			cifs_debug_files_proc_show);
 
-#ifdef CONFIG_CIFS_DEBUG2
+#ifdef CONFIG_CIFS_DEBUG
 	proc_create("open_dirs", 0644, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
-#else /* CONFIG_CIFS_DEBUG2 */
+#else /* CONFIG_CIFS_DEBUG */
 	proc_create_single("open_dirs", 0400, proc_fs_cifs, cifs_debug_dirs_proc_show);
-#endif /* !CONFIG_CIFS_DEBUG2 */
+#endif /* !CONFIG_CIFS_DEBUG */
 	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
 	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
 	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
-- 
2.39.5

