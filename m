From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix default behaviour for empty domains and add domainauto option
Date: Thu, 24 Nov 2016 21:20:39 +0000
Message-ID: <1480022439-27875-2-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With commit 2b149f119 many things have been fixed/introduced.
However, the default behaviour for RawNTLMSSP authentication
seems to be wrong in case the domain is not passed on the command line.

The main points (see below) of the patch are:
 - It alignes behaviour with Windows clients
 - It fixes backward compatibility
 - It fixes UPN

I compared this behavour with the one from a Windows 10 command line
client. When no domains are specified on the command line, I traced
the packets and observed that the client does send an empty
domain to the server.
In the linux kernel case, the empty domain is replaced by the
primary domain communicated by the SMB server.
This means that, if the credentials are valid against the local server
but that server is part of a domain, then the kernel module will
ask to authenticate against that domain and we will get LOGON failure.

I compared the packet trace from the smbclient when no domain is passed
and, in that case, a default domain from the client smb.conf is taken.
Apparently, connection succeeds anyway, because when the domain passed
is not valid (in my case WORKGROUP), then the local one is tried and
authentication succeeds. I tried with any kind of invalid domain and
the result was always a connection.

So, trying to interpret what to do and picking a valid domain if none
is passed, seems the wrong thing to do.
To this end, a new option "domainauto" has been added in case the
user wants a mechanism for guessing.

Without this patch, backward compatibility also is broken.
With kernel 3.10, the default auth mechanism was NTLM.
One of our testing servers accepted NTLM and, because no
domains are passed, authentication was local.

Moving to RawNTLMSSP forced us to change our command line
to add a fake domain to pass to prevent this mechanism to kick in.

For the same reasons, UPN is broken because the domain is specified
in the username.
The SMB server will work out the domain from the UPN and authenticate
against the right server.
Without the patch, though, given the domain is empty, it gets replaced
with another domain that could be the wrong one for the authentication.

Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 14 +++++++++-----
 fs/cifs/cifsglob.h    |  2 ++
 fs/cifs/connect.c     |  7 +++++++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5eb0412..66bd7fa 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -699,11 +699,15 @@ static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
 
 	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED) {
 		if (!ses->domainName) {
-			rc = find_domain_name(ses, nls_cp);
-			if (rc) {
-				cifs_dbg(VFS, "error %d finding domain name\n",
-					 rc);
-				goto setup_ntlmv2_rsp_ret;
+			if (ses->domainAuto) {
+				rc = find_domain_name(ses, nls_cp);
+				if (rc) {
+					cifs_dbg(VFS, "error %d finding domain name\n",
+						 rc);
+					goto setup_ntlmv2_rsp_ret;
+				}
+			} else {
+				ses->domainName = kstrdup("", GFP_KERNEL);
 			}
 		}
 	} else {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1f17f6b..4f0d5a1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -514,6 +514,7 @@ struct smb_vol {
 	bool persistent:1;
 	bool nopersistent:1;
 	bool resilient:1; /* noresilient not required since not fored for CA */
+	bool domainauto:1;
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -827,6 +828,7 @@ struct cifs_ses {
 	enum securityEnum sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
+	bool domainAuto:1;
 #ifdef CONFIG_CIFS_SMB2
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4547aed..df7eed7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -88,6 +88,7 @@ enum {
 	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
 	Opt_persistent, Opt_nopersistent,
 	Opt_resilient, Opt_noresilient,
+	Opt_domainauto,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid, Opt_backupgid, Opt_uid,
@@ -176,6 +177,7 @@ enum {
 	{ Opt_nopersistent, "nopersistenthandles"},
 	{ Opt_resilient, "resilienthandles"},
 	{ Opt_noresilient, "noresilienthandles"},
+	{ Opt_domainauto, "domainauto"},
 
 	{ Opt_backupuid, "backupuid=%s" },
 	{ Opt_backupgid, "backupgid=%s" },
@@ -1499,6 +1501,9 @@ static int cifs_parse_security_flavors(char *value,
 		case Opt_noresilient:
 			vol->resilient = false; /* already the default */
 			break;
+		case Opt_domainauto:
+			vol->domainauto = true;
+			break;
 
 		/* Numeric Values */
 		case Opt_backupuid:
@@ -2548,6 +2553,8 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 		if (!ses->domainName)
 			goto get_ses_fail;
 	}
+	if (volume_info->domainauto)
+		ses->domainAuto = volume_info->domainauto;
 	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;
 
-- 
1.9.1
