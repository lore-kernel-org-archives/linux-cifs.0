From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] Revert "[CIFS] Eliminate unused variable warning"
Date: Wed,  1 Sep 2010 21:37:32 -0400
Message-ID: <1283391455-6848-4-git-send-email-jlayton@redhat.com>
References: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283391455-6848-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit c89e5198b26a869ce2842bad8519264f3394dee9.
---
 fs/cifs/sess.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 795095f..4788e16 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -620,6 +620,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	bool first_time;
+	char *ntlmsspblob;
 
 	if (ses == NULL)
 		return -EINVAL;
@@ -867,8 +868,6 @@ ssetup_ntlmssp_authenticate:
 				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
 			} else if (phase == NtLmAuthenticate) {
 				int blob_len;
-				char *ntlmsspblob;
-
 				ntlmsspblob = kmalloc(5 *
 					sizeof(struct _AUTHENTICATE_MESSAGE),
 					GFP_KERNEL);
-- 
1.7.2.2
