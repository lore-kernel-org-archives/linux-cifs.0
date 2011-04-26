From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] cifs: check for bytes_remaining going to zero in CIFS_SessSetup
Date: Tue, 26 Apr 2011 08:03:18 -0400
Message-ID: <1303819401-14789-3-git-send-email-jlayton@redhat.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible that when we go to decode the string area in the
SESSION_SETUP response, that bytes_remaining will be 0. Decrementing it at
that point will mean that it can go "negative" and wrap. Check for a
bytes_remaining value of 0, and don't try to decode the string area if
that's the case.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2e2c911..645114a 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -916,7 +916,9 @@ ssetup_ntlmssp_authenticate:
 	}
 
 	/* BB check if Unicode and decode strings */
-	if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
+	if (bytes_remaining == 0) {
+		/* no string area to decode, do nothing */
+	} else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
 		/* unicode string area must be word-aligned */
 		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
 			++bcc_ptr;
-- 
1.7.4.4
