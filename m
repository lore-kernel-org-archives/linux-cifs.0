From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: small variable name cleanup
Date: Wed, 10 Apr 2013 14:43:00 +0300
Message-ID: <20130410114300.GB21419@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

server and ses->server are the same, but it's a little bit ugly that we
lock &ses->server->srv_mutex and unlock &server->srv_mutex.  It causes
a false positive in Smatch about inconsistent locking.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index edb2220..e3a0f81 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3826,7 +3826,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		cifs_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 	} else {
-		mutex_lock(&ses->server->srv_mutex);
+		mutex_lock(&server->srv_mutex);
 		if (!server->session_estab) {
 			server->session_key.response = ses->auth_key.response;
 			server->session_key.len = ses->auth_key.len;
