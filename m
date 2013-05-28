From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 11/19] cifs: add new "Unspecified" securityEnum value
Date: Tue, 28 May 2013 08:11:52 -0400
Message-ID: <1369743120-18941-12-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a new securityEnum value to cover the case where a sec= option
was not explicitly set.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 874b29b..a858037 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -101,11 +101,11 @@ enum statusEnum {
 };
 
 enum securityEnum {
-	LANMAN = 0,			/* Legacy LANMAN auth */
+	Unspecified = 0,	/* not specified */
+	LANMAN,			/* Legacy LANMAN auth */
 	NTLM,			/* Legacy NTLM012 auth with NTLM hash */
 	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
 	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
-/*	NTLMSSP, */ /* can use rawNTLMSSP instead of NTLMSSP via SPNEGO */
 	Kerberos,		/* Kerberos via SPNEGO */
 };
 
-- 
1.8.1.4
