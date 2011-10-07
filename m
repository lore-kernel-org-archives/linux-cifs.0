From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: patch to fix first time mount message re: upgrade for ntlmv2
Date: Thu, 6 Oct 2011 23:18:45 -0500
Message-ID: <CAH2r5msqJRT-bqJcn2V14zDYrTHZ_9EzSNg3Z_zHe+Cd_Fs-Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit f30ebabb47a89302c6c06795804838ec57622ad0
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Thu Oct 6 23:14:07 2011 -0500

    [CIFS] Fix first time message on mount, ntlmv2 upgrade delayed to 3.2

    Microsoft has a bug with ntlmv2 that requires use of ntlmssp, but
    we didn't get the required information on when/how to use ntlmssp to
    old (but once very popular) legacy servers (various NT4 fixpacks
    for example) until too late to merge for 3.1.  Will upgrade
    to NTLMv2 in NTLMSSP in 3.2

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f4af4cc..71beb02 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2018,7 +2018,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,
struct smb_vol *volume_info)
 		warned_on_ntlm = true;
 		cERROR(1, "default security mechanism requested.  The default "
 			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 3.1");
+			"ntlmv2 in kernel release 3.2");
 	}
 	ses->overrideSecFlg = volume_info->secFlg;

-- 
Thanks,

Steve
