From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 20 Jan 2012 15:25:53 -0500
Message-ID: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and just make it always turned on. In practice almost everyone
enables this option, and as the Kconfig option says, it needs to be
enabled at runtime anyway. I see no need to make this disableable
via Kconfig option as well, and removing the option simplifies the
testing matrix and reduced ifdef clutter in the code.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Kconfig       |   27 ---------------------------
 fs/cifs/cifs_debug.c  |    2 --
 fs/cifs/cifsencrypt.c |    2 --
 fs/cifs/cifsglob.h    |   17 +----------------
 fs/cifs/cifspdu.h     |    4 ----
 fs/cifs/cifsproto.h   |    2 --
 fs/cifs/cifssmb.c     |   24 ------------------------
 fs/cifs/connect.c     |    8 ++------
 fs/cifs/sess.c        |   10 ----------
 9 files changed, 3 insertions(+), 93 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 0554b00..ee7ac6b 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -49,33 +49,6 @@ config CIFS_STATS2
 	  Unless you are a developer or are doing network performance analysis
 	  or tuning, say N.
 
-config CIFS_WEAK_PW_HASH
-	bool "Support legacy servers which use weaker LANMAN security"
-	depends on CIFS
-	help
-	  Modern CIFS servers including Samba and most Windows versions
-	  (since 1997) support stronger NTLM (and even NTLMv2 and Kerberos)
-	  security mechanisms. These hash the password more securely
-	  than the mechanisms used in the older LANMAN version of the
-	  SMB protocol but LANMAN based authentication is needed to
-	  establish sessions with some old SMB servers.
-
-	  Enabling this option allows the cifs module to mount to older
-	  LANMAN based servers such as OS/2 and Windows 95, but such
-	  mounts may be less secure than mounts using NTLM or more recent
-	  security mechanisms if you are on a public network.  Unless you
-	  have a need to access old SMB servers (and are on a private
-	  network) you probably want to say N.  Even if this support
-	  is enabled in the kernel build, LANMAN authentication will not be
-	  used automatically. At runtime LANMAN mounts are disabled but
-	  can be set to required (or optional) either in
-	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
-	  option on the mount command. This support is disabled by
-	  default in order to reduce the possibility of a downgrade
-	  attack.
-
-	  If unsure, say N.
-
 config CIFS_UPCALL
 	bool "Kerberos/SPNEGO advanced session setup"
 	depends on CIFS && KEYS
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 24b3dfc..589774f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -126,9 +126,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_CIFS_FSCACHE
 	seq_printf(m, " fscache");
 #endif
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 	seq_printf(m, " lanman");
-#endif
 #ifdef CONFIG_CIFS_POSIX
 	seq_printf(m, " posix");
 #endif
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 63c460e..96997cc 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -242,7 +242,6 @@ int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	return rc;
 }
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 			char *lnm_session_key)
 {
@@ -279,7 +278,6 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 
 	return rc;
 }
-#endif /* CIFS_WEAK_PW_HASH */
 
 /* Build a proper attribute value/target info pairs blob.
  * Fill in netbios and dns domain name and workstation name
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 76e7d8b..0e56b1e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -853,13 +853,8 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFSSEC_MAY_NTLM	0x00002
 #define   CIFSSEC_MAY_NTLMV2	0x00004
 #define   CIFSSEC_MAY_KRB5	0x00008
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 #define   CIFSSEC_MAY_LANMAN	0x00010
 #define   CIFSSEC_MAY_PLNTXT	0x00020
-#else
-#define   CIFSSEC_MAY_LANMAN    0
-#define   CIFSSEC_MAY_PLNTXT    0
-#endif /* weak passwords */
 #define   CIFSSEC_MAY_SEAL	0x00040 /* not supported yet */
 #define   CIFSSEC_MAY_NTLMSSP	0x00080 /* raw ntlmssp with ntlmv2 */
 
@@ -870,23 +865,13 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_NTLM	0x02002
 #define   CIFSSEC_MUST_NTLMV2	0x04004
 #define   CIFSSEC_MUST_KRB5	0x08008
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 #define   CIFSSEC_MUST_LANMAN	0x10010
 #define   CIFSSEC_MUST_PLNTXT	0x20020
 #ifdef CONFIG_CIFS_UPCALL
 #define   CIFSSEC_MASK          0xBF0BF /* allows weak security but also krb5 */
-#else
+#else /* UPCALL */
 #define   CIFSSEC_MASK          0xB70B7 /* current flags supported if weak */
 #endif /* UPCALL */
-#else /* do not allow weak pw hash */
-#define   CIFSSEC_MUST_LANMAN	0
-#define   CIFSSEC_MUST_PLNTXT	0
-#ifdef CONFIG_CIFS_UPCALL
-#define   CIFSSEC_MASK          0x8F08F /* flags supported if no weak allowed */
-#else
-#define	  CIFSSEC_MASK          0x87087 /* flags supported if no weak allowed */
-#endif /* UPCALL */
-#endif /* WEAK_PW_HASH */
 #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
 
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 3fb03e2..ef28614 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -26,13 +26,9 @@
 #include <asm/unaligned.h>
 #include "smbfsctl.h"
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 #define LANMAN_PROT 0
 #define LANMAN2_PROT 1
 #define CIFS_PROT   2
-#else
-#define CIFS_PROT   0
-#endif
 #define POSIX_PROT  (CIFS_PROT+1)
 #define BAD_PROT 0xFFFF
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..a81549d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -403,10 +403,8 @@ extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern int calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
-#endif /* CIFS_WEAK_PW_HASH */
 #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
 extern int CIFSSMBNotify(const int xid, struct cifs_tcon *tcon,
 			const int notify_subdirs, const __u16 netfid,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8b7794c..cf12c0c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -49,10 +49,8 @@ static struct {
 	int index;
 	char *name;
 } protocols[] = {
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 	{LANMAN_PROT, "\2LM1.2X002"},
 	{LANMAN2_PROT, "\2LANMAN2.1"},
-#endif /* weak password hashing for legacy clients */
 	{CIFS_PROT, "\2NT LM 0.12"},
 	{POSIX_PROT, "\2POSIX 2"},
 	{BAD_PROT, "\2"}
@@ -62,10 +60,8 @@ static struct {
 	int index;
 	char *name;
 } protocols[] = {
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 	{LANMAN_PROT, "\2LM1.2X002"},
 	{LANMAN2_PROT, "\2LANMAN2.1"},
-#endif /* weak password hashing for legacy clients */
 	{CIFS_PROT, "\2NT LM 0.12"},
 	{BAD_PROT, "\2"}
 };
@@ -73,17 +69,9 @@ static struct {
 
 /* define the number of elements in the cifs dialect array */
 #ifdef CONFIG_CIFS_POSIX
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 #define CIFS_NUM_PROT 4
-#else
-#define CIFS_NUM_PROT 2
-#endif /* CIFS_WEAK_PW_HASH */
 #else /* not posix */
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 #define CIFS_NUM_PROT 3
-#else
-#define CIFS_NUM_PROT 1
-#endif /* CONFIG_CIFS_WEAK_PW_HASH */
 #endif /* CIFS_POSIX */
 
 /* Forward declarations */
@@ -441,7 +429,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		could not negotiate a common dialect */
 		rc = -EOPNOTSUPP;
 		goto neg_err_exit;
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 	} else if ((pSMBr->hdr.WordCount == 13)
 			&& ((server->dialect == LANMAN_PROT)
 				|| (server->dialect == LANMAN2_PROT))) {
@@ -519,13 +506,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		/* we will not end up setting signing flags - as no signing
 		was in LANMAN and server did not return the flags on */
 		goto signing_check;
-#else /* weak security disabled */
-	} else if (pSMBr->hdr.WordCount == 13) {
-		cERROR(1, "mount failed, cifs module not built "
-			  "with CIFS_WEAK_PW_HASH support");
-		rc = -EOPNOTSUPP;
-#endif /* WEAK_PW_HASH */
-		goto neg_err_exit;
 	} else if (pSMBr->hdr.WordCount != 17) {
 		/* unknown wct */
 		rc = -EOPNOTSUPP;
@@ -537,9 +517,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		cFYI(1, "share mode security");
 
 	if ((server->sec_mode & SECMODE_PW_ENCRYPT) == 0)
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
-#endif /* CIFS_WEAK_PW_HASH */
 			cERROR(1, "Server requests plain text password"
 				  " but client support disabled");
 
@@ -627,9 +605,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	} else
 		server->capabilities &= ~CAP_EXTENDED_SECURITY;
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 signing_check:
-#endif
 	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
 		/* MUST_SIGN already includes the MAY_SIGN FLAG
 		   so if this is zero it means that signing is disabled */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index aa687c8..5aeca5e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1153,10 +1153,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			} else if (strnicmp(value, "nontlm", 6) == 0) {
 				/* BB is there a better way to do this? */
 				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 			} else if (strnicmp(value, "lanman", 6) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_LANMAN;
-#endif
 			} else if (strnicmp(value, "none", 4) == 0) {
 				vol->nullauth = 1;
 			} else {
@@ -3611,7 +3609,6 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 		   weaker LANMAN (which we do not send by default) is accepted
 		   by Samba (not sure whether other servers allow
 		   NTLMv2 password here) */
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
 		    (ses->server->secType == LANMAN))
 			calc_lanman_hash(tcon->password, ses->server->cryptkey,
@@ -3619,9 +3616,8 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 					    SECMODE_PW_ENCRYPT ? true : false,
 					 bcc_ptr);
 		else
-#endif /* CIFS_WEAK_PW_HASH */
-		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
-					bcc_ptr, nls_codepage);
+			rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
+						bcc_ptr, nls_codepage);
 
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d85efad..1cce63b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -592,14 +592,6 @@ ssetup_ntlmssp_authenticate:
 		phase = NtLmAuthenticate; /* if ntlmssp, now final phase */
 
 	if (type == LANMAN) {
-#ifndef CONFIG_CIFS_WEAK_PW_HASH
-		/* LANMAN and plaintext are less secure and off by default.
-		So we make this explicitly be turned on in kconfig (in the
-		build) and turned on at runtime (changed from the default)
-		in proc/fs/cifs or via mount parm.  Unfortunately this is
-		needed for old Win (e.g. Win95), some obscure NAS and OS/2 */
-		return -EOPNOTSUPP;
-#endif
 		wct = 10; /* lanman 2 style sessionsetup */
 	} else if ((type == NTLM) || (type == NTLMv2)) {
 		/* For NTLMv2 failures eventually may need to retry NTLM */
@@ -643,7 +635,6 @@ ssetup_ntlmssp_authenticate:
 	iov[1].iov_len = 0;
 
 	if (type == LANMAN) {
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 		char lnm_session_key[CIFS_AUTH_RESP_SIZE];
 
 		pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
@@ -674,7 +665,6 @@ ssetup_ntlmssp_authenticate:
 		cFYI(1, "Negotiating LANMAN setting up strings");
 		/* Unicode not allowed for LANMAN dialects */
 		ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
-#endif
 	} else if (type == NTLM) {
 		pSMB->req_no_secext.Capabilities = cpu_to_le32(capabilities);
 		pSMB->req_no_secext.CaseInsensitivePasswordLength =
-- 
1.7.7.5
