From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 03/53] CIFS: Check for smb2 vs. cifs in find_tcp_session
Date: Fri, 28 Oct 2011 23:54:14 +0400
Message-ID: <1319831704-3572-4-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org, Steve French <sfrench@us.ibm.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Steve French <sfrench@us.ibm.com>

Also set ses->is_smb2 when smb2 session initialized.

Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/connect.c  |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6dfc7ef..179b784 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -172,6 +172,7 @@ struct smb_vol {
 	mode_t file_mode;
 	mode_t dir_mode;
 	unsigned secFlg;
+	bool use_smb2:1; /* use SMB2 protocol rather that CIFS */
 	bool retry:1;
 	bool intr:1;
 	bool setuids:1;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f70d87d..6743558 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/connect.c
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2009
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -1760,6 +1760,14 @@ static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
 			   (struct sockaddr *)&vol->srcaddr))
 		return 0;
 
+#ifdef CONFIG_CIFS_SMB2
+	if ((server->is_smb2 == true) && (vol->use_smb2 == false))
+		return 0;
+
+	if ((server->is_smb2 == false) && (vol->use_smb2 == true))
+		return 0;
+#endif /* CONFIG_CIFS_SMB2 */
+
 	if (!match_port(server, addr))
 		return 0;
 
@@ -1884,6 +1892,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
+	/* BB should we set this unconditionally now, especially for SMB2 */
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	atomic_set(&tcp_ses->inFlight, 0);
 	init_waitqueue_head(&tcp_ses->response_q);
@@ -1927,6 +1936,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err_crypto_release;
 	}
 
+#ifdef CONFIG_CIFS_SMB2
+	if (volume_info->use_smb2)
+		tcp_ses->is_smb2 = true;
+#endif /* CONFIG_CIFS_SMB2 */
+
 	/*
 	 * since we're in a cifs function already, we know that
 	 * this will succeed. No need for try_module_get().
-- 
1.7.1

