From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH][Trivial] CIFS: Don't free volume_info->UNC until we are
 entirely done with it.
Date: Sat, 27 Aug 2011 18:58:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108271851470.27813@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In cleanup_volume_info_contents() we kfree(volume_info->UNC); and then 
proceed to use that variable on the very next line.
This causes (at least) Coverity Prevent to complain about use-after-free 
of that variable (and I guess other checkers may do that as well).
There's not any /real/ problem here since we are just using the value of 
the pointer, not actually dereferencing it, but it's still trivial to 
silence the tool, so why not?
To me at least it also just seems nicer to defer freeing the variable 
until we are entirely done with it in all respects.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..9bb4b10 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2877,9 +2877,9 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
-	kfree(volume_info->UNC);
 	if (volume_info->UNCip != volume_info->UNC + 2)
 		kfree(volume_info->UNCip);
+	kfree(volume_info->UNC);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
-- 
1.7.6.1


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
