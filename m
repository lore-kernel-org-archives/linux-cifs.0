From: shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH] cifs: release auth_key.response for reconnect.
Date: Fri,  8 Sep 2017 18:48:33 +0800
Message-ID: <20170908104833.7701-1-shuwang@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

There is a race that cause cifs reconnect in cifs_mount,
- cifs_mount
  - cifs_get_tcp_session
    - [ start thread cifs_demultiplex_thread
      - cifs_read_from_socket: -ECONNABORTED
        - DELAY_WORK smb2_reconnect_server ]
  - cifs_setup_session
  - [ smb2_reconnect_server ]

auth_key.response was allocated in cifs_setup_session, and
will release when the session destoried. So when session re-
connect, auth_key.response should be check and released.

Tested with my system:
CIFS VFS: Free previous auth_key.response = ffff8800320bbf80

A simple auth_key.response allocation call trace:
- cifs_setup_session
- SMB2_sess_setup
- SMB2_sess_auth_rawntlmssp_authenticate
- build_ntlmssp_auth_blob
- setup_ntlmv2_rsp

Signed-off-by: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 83a8f52cd879..5a97744161c1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4143,6 +4143,14 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
+	if (ses->auth_key.response) {
+		cifs_dbg(VFS, "Free previous auth_key.response = %p\n",
+			 ses->auth_key.response);
+		kfree(ses->auth_key.response);
+		ses->auth_key.response = NULL;
+		ses->auth_key.len = 0;
+	}
+
 	if (server->ops->sess_setup)
 		rc = server->ops->sess_setup(xid, ses, nls_info);
 
-- 
2.13.5
