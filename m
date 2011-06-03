From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix the kernel release version in the default security
 warning message
Date: Fri, 03 Jun 2011 12:06:19 +0530
Message-ID: <4DE880E3.8020502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


When ntlm security mechanim is used, the message that warns about the upgrade
to ntlmv2 got the kernel release version wrong (Blame it on Linus :). Fix it.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6d88b82..84c7307 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1976,7 +1976,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		warned_on_ntlm = true;
 		cERROR(1, "default security mechanism requested.  The default "
 			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 2.6.41");
+			"ntlmv2 in kernel release 3.1");
 	}
 	ses->overrideSecFlg = volume_info->secFlg;
 
-- 
1.7.1
