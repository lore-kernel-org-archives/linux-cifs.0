From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] Warn on requesting default security (ntlm) on mount
Date: Wed, 16 Mar 2011 15:19:44 -0500
Message-ID: <AANLkTi=VmBDQm_1+6j0TzOuhrd+tkydkoJOWJbKsicsb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Warn once if default security (ntlm) requested. We will
update the default to the stronger security mechanism
(ntlmv2) in 2.6.41.  Kerberos is also stronger than
ntlm, but more servers support ntlmv2 and ntlmv2
does not require an upcall, so ntlmv2 is a better
default.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
CC: Shirish Pargaonkar <shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4066e3e..33e11a8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1888,6 +1888,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	cifs_put_tcp_session(server);
 }

+static bool warned_on_ntlm;  /* globals init to false automatically */
+
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
@@ -1962,6 +1964,15 @@ cifs_get_smb_ses(struct TCP_Server_Info
*server, struct smb_vol *volume_info)
 	}
 	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;
+
+	/* ntlmv2 is much stronger than ntlm security, and has been broadly
+	supported for many years, time to update default security mechanism */
+	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
+		warned_on_ntlm = true;
+		cERROR(1, "default security mechanism requested.  The default "
+			"security mechanism will be upgraded from ntlm to "
+			"ntlmv2 in kernel release 2.6.41");
+	}
 	ses->overrideSecFlg = volume_info->secFlg;

 	mutex_lock(&ses->session_mutex);

-- 
Thanks,

Steve
