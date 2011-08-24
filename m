From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Default auth method needs to be ntlmv2
Date: Tue, 23 Aug 2011 22:18:48 -0500
Message-ID: <CAH2r5mv6voBWygoNnznOjNAMmDmNnt=FBssZ4feRMG+yCM8juQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This and previous patch (fixing ls to WinCE) should go in fairly quickly
if possible.  Waiting to include this until Shirish's investigation of
raw ntlmv2 mount to Samba 3.6

>From 0041b8d78949576f2a3fcfc1098fb3c919bacc96 Mon Sep 17 00:00:00 2001
From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date: Tue, 23 Aug 2011 22:13:07 -0500
Subject: [CIFS] Default auth method needs to be ntlmv2

As warned in last two kernel releases on default cifs mounts, upgrading
default security to ntlmv2.

ntlmv2 is much stronger than ntlm and is minimum acceptable level
these days.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c |    7 +++++--
 fs/cifs/connect.c |   10 ----------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a80f7bd..5b53ca9 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -538,16 +538,19 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 			cERROR(1, "Server requests plain text password"
 				  " but client support disabled");

+	/* NTLMv2 is the strongest, most broadly supported mechanism,
+	   try to avoid NTLM unless no alternative.  We may have
+	   to default to rawNTLMSSP */
 	if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
 		server->secType = NTLMv2;
-	else if (secFlags & CIFSSEC_MAY_NTLM)
-		server->secType = NTLM;
 	else if (secFlags & CIFSSEC_MAY_NTLMV2)
 		server->secType = NTLMv2;
 	else if (secFlags & CIFSSEC_MAY_KRB5)
 		server->secType = Kerberos;
 	else if (secFlags & CIFSSEC_MAY_NTLMSSP)
 		server->secType = RawNTLMSSP;
+	else if (secFlags & CIFSSEC_MAY_NTLM)
+		server->secType = NTLM;
 	else if (secFlags & CIFSSEC_MAY_LANMAN)
 		server->secType = LANMAN;
 	else {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..1f8af63 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1935,8 +1935,6 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	cifs_put_tcp_session(server);
 }

-static bool warned_on_ntlm;  /* globals init to false automatically */
-
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
@@ -2012,14 +2010,6 @@ cifs_get_smb_ses(struct TCP_Server_Info
*server, struct smb_vol *volume_info)
 	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;

-	/* ntlmv2 is much stronger than ntlm security, and has been broadly
-	supported for many years, time to update default security mechanism */
-	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
-		warned_on_ntlm = true;
-		cERROR(1, "default security mechanism requested.  The default "
-			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 3.1");
-	}
 	ses->overrideSecFlg = volume_info->secFlg;

 	mutex_lock(&ses->session_mutex);

-- 
Thanks,

Steve
