From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 40/53] CIFS: Add NTLMSSP sec type to defaults
Date: Fri, 28 Oct 2011 23:54:51 +0400
Message-ID: <1319831704-3572-41-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b71c3fc..c05b4c0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -998,7 +998,7 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
 
-#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2)
+#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
 #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP)
 
-- 
1.7.1
