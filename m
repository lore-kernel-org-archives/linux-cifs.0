From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] Initialize number of credits to one
Date: Wed, 16 Mar 2011 15:20:24 -0500
Message-ID: <AANLkTinox4ot1D0r4AEOVVdnBtotXa=9RDy8Ohto6s8j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Before we send the first request, SMB2 Negotiate,
we need to initialize number of credits to its minimum
(one).

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 33e11a8..c19f00a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3202,6 +3202,7 @@ int cifs_negotiate_protocol(unsigned int xid,
struct cifs_ses *ses)

 #ifdef CONFIG_CIFS_SMB2
 	if (ses->server->is_smb2) {
+		atomic_set(&server->credits, 1); /* we have one credit to start with */
 		rc = SMB2_negotiate(xid, ses);
 		/* BB we probably don't need to retry with modern servers */
 		if (rc == -EAGAIN)

-- 
Thanks,

Steve
