From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Upgrading security default
Date: Fri, 23 Nov 2012 17:36:45 -0600
Message-ID: <CAH2r5mtPAwURZxTeRBfn+c=hNyeaDbmKbYXt=w3VkUu5i1cxNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch to upgrade the default security mechanism to ntlmv2/ntlmssp
(which is broadly supported for years now, and a reasonable minimum,
far better than ntlm) is overdue, but I had to rework it to simplify
it.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c670b9..3bca289 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1103,6 +1103,7 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,
 	bool uid_specified = false;
 	bool gid_specified = false;
 	bool sloppy = false;
+	bool sec_explicitly_set = false;
 	char *invalid = NULL;
 	char *nodename = utsname()->nodename;
 	char *string = NULL;
@@ -1763,6 +1764,7 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,

 			if (cifs_parse_security_flavors(string, vol) != 0)
 				goto cifs_parse_mount_err;
+			sec_explicitly_set = true;
 			break;
 		case Opt_cache:
 			string = match_strdup(args);
@@ -1799,6 +1801,8 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname,
 		goto cifs_parse_mount_err;
 	}
 #endif
+	if (sec_explicitly_set == false)
+		vol->secFlg |= CIFSSEC_MAY_NTLMSSP;

 	if (vol->UNCip == NULL)
 		vol->UNCip = &vol->UNC[2];
@@ -2397,8 +2401,6 @@ cifs_set_cifscreds(struct smb_vol *vol
__attribute__((unused)),
 }
 #endif /* CONFIG_KEYS */

-static bool warned_on_ntlm;  /* globals init to false automatically */
-
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
@@ -2475,14 +2477,6 @@ cifs_get_smb_ses(struct TCP_Server_Info
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
