From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Upgrade default authentication to NTLMv2/NTLMSSP (try #2)
Date: Sun, 25 Nov 2012 00:10:32 -0600
Message-ID: <CAH2r5msFoAqT4-ec1SbeVfnTD5=OeXawyx4GgvqdZ1CcZ+4VEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Incorporating Jeff's feedback

commit e6104c75c0e3158d39356591955f2aff7f3558c3
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Sun Nov 25 00:07:44 2012 -0600

    [CIFS] default authentication needs to be at least ntlmv2 security
for cifs mounts

    We had planned to upgrade to ntlmv2 security a few releases ago,
    and have been warning users in dmesg on mount about the impending
    upgrade, but had to make a change (to use nltmssp with ntlmv2) due
    to testing issues with some non-Windows, non-Samba servers.

    The approach in this patch is simpler than earlier patches,
    and changes the default authentication mechanism to ntlmv2
    password hashes (encapsulated in ntlmssp) from ntlm (ntlm is
    too weak for current use and ntlmv2 has been broadly
    supported for many, many years).

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f5af252..2cd5ea2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1362,7 +1362,7 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */

-#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM |
CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
+#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMSSP)
 #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 |
CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 |
CIFSSEC_MAY_NTLMSSP)
 /*
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c670b9..32fb50e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2397,8 +2397,6 @@ cifs_set_cifscreds(struct smb_vol *vol
__attribute__((unused)),
 }
 #endif /* CONFIG_KEYS */

-static bool warned_on_ntlm;  /* globals init to false automatically */
-
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
@@ -2475,14 +2473,6 @@ cifs_get_smb_ses(struct TCP_Server_Info
*server, struct smb_vol *volume_info)
 	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;

-	/* ntlmv2 is much stronger than ntlm security, and has been broadly
-	supported for many years, time to update default security mechanism */
-	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
-		warned_on_ntlm = true;
-		cERROR(1, "default security mechanism requested.  The default "
-			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 3.3");
-	}
 	ses->overrideSecFlg = volume_info->secFlg;

 	mutex_lock(&ses->session_mutex);

-- 
Thanks,

Steve
