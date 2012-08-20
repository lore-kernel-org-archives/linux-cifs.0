From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 10/10] CIFS: Add NTLMSSP sec type to defaults
Date: Mon, 20 Aug 2012 22:43:00 +0400
Message-ID: <1345488180-5942-11-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c76e5ec..42f6aa2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1354,7 +1354,7 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
 
-#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2)
+#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
 #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP)
 /*
-- 
1.7.1
