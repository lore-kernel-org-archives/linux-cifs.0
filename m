From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 02/50] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Fri, 20 Jan 2012 12:34:23 +0400
Message-ID: <1327048511-2342-2-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/connect.c  |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1e1b54b..15c3a92 100644
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
@@ -292,6 +293,7 @@ struct TCP_Server_Info {
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	large_buf;		/* is current buffer large? */
+	bool	is_smb2;		/* smb2 not cifs protocol negotiated */
 	struct delayed_work	echo; /* echo ping workqueue job */
 	struct kvec *iov;	/* reusable kvec array for receives */
 	unsigned int nr_iov;	/* number of kvecs in array */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d64ab48..ccfcfbe 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/connect.c
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2009
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -1763,6 +1763,14 @@ static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
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
 
@@ -1887,6 +1895,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
+	/* BB should we set this unconditionally now, especially for SMB2 */
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	atomic_set(&tcp_ses->inFlight, 0);
 	init_waitqueue_head(&tcp_ses->response_q);
@@ -1930,6 +1939,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
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
