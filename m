From: Luis de Bethencourt <luisbg-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH] cifs: check hash calculating succeeded
Date: Wed,  8 Jun 2016 17:02:32 +0100
Message-ID: <1465401752-11290-1-git-send-email-luisbg@osg.samsung.com>
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Luis de Bethencourt <luisbg-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

calc_lanman_hash() could return -ENOMEM or other errors, we should check
that everything went fine before using the calculated key.

Signed-off-by: Luis de Bethencourt <luisbg-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 fs/cifs/sess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index a42e99c..538d9b5 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -710,6 +710,8 @@ sess_auth_lanman(struct sess_data *sess_data)
 		rc = calc_lanman_hash(ses->password, ses->server->cryptkey,
 				      ses->server->sec_mode & SECMODE_PW_ENCRYPT ?
 				      true : false, lnm_session_key);
+		if (rc)
+			goto out;
 
 		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
-- 
2.5.1
