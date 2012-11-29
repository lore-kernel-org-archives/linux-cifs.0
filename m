From: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
Subject: [RFQ PATCH] cifs: Change default security error message
Date: Thu, 29 Nov 2012 18:30:53 +0100
Message-ID: <20121129173053.GQ27196@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

Connecting with a default security mechanism prompts an KERN_ERROR
output warning to the user that the default mechanism will be changed
in Linux 3.3.

We're now at 3.7, so we either could remove the warning completely
(if the default has been changed), or we could bump the number to
what our current target for the change is.


The below patch changes the cERROR (which turns into a printk with KERN_ERROR)
into a straight printk with KERN_WARNING and changes the text to indicate
that it was changed in 3.3.

I expect that the patch is incorrect and that we should choose
another of the alternative solutions above, but I'd like to get
some input on this.

Not-Signed-off-by: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
---
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c83f5b65..968456f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2480,9 +2480,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	supported for many years, time to update default security mechanism */
 	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
 		warned_on_ntlm = true;
-		cERROR(1, "default security mechanism requested.  The default "
-			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 3.3");
+		printk(KERN_WARNING "default security mechanism requested.  "
+			"The default security mechanism was changed "
+			" from ntlm to ntlmv2 in kernel release 3.3");
 	}
 	ses->overrideSecFlg = volume_info->secFlg;
 


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson-VrBV9hrLPhE@public.gmane.org
