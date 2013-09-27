From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Allow LANMAN auth method for servers supporting unencapsulated authentication methods
Date: Fri, 27 Sep 2013 18:35:42 +0100
Message-ID: <1380303342-27160-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Panos Kavalagios <Panagiotis.Kavalagios-E+QESPr5TdxBDgjK7y7TUQ@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This allows users to use LANMAN authentication on servers which support
unencapsulated authentication.

The patch fixes a regression where users using plaintext authentication
were no longer able to do so because of changed bought in by patch
3f618223dc0bdcbc8d510350e78ee2195ff93768

https://bugzilla.redhat.com/show_bug.cgi?id=1011621

Reported-by: Panos Kavalagios <Panagiotis.Kavalagios-E+QESPr5TdxBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5f99b7f..e1e74d0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -582,9 +582,9 @@ select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
 				return NTLMv2;
 			if (global_secflags & CIFSSEC_MAY_NTLM)
 				return NTLM;
-			/* Fallthrough */
 		default:
-			return Unspecified;
+			/* Fallthrough to attempt LANMAN authentication next */
+			break;
 		}
 	case CIFS_NEGFLAVOR_LANMAN:
 		switch (requested) {
-- 
1.8.3.1
