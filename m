From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] cifs: match secType when searching for existing tcp session
Date: Sun, 20 Jun 2010 17:10:48 -0400
Message-ID: <1277068251-16344-4-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The secType is a per-tcp session entity, but the current routine doesn't
verify that it is acceptible when attempting to match an existing TCP
session.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 +-
 fs/cifs/connect.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a88479c..1cb7c32 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -80,8 +80,7 @@ enum statusEnum {
 };
 
 enum securityEnum {
-	PLAINTXT = 0, 		/* Legacy with Plaintext passwords */
-	LANMAN,			/* Legacy LANMAN auth */
+	LANMAN = 0,			/* Legacy LANMAN auth */
 	NTLM,			/* Legacy NTLM012 auth with NTLM hash */
 	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
 	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 665ee37..6440b79 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1411,8 +1411,56 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
 	return true;
 }
 
+static bool
+match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
+{
+	unsigned int secFlags;
+
+	if (vol->secFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
+		secFlags = vol->secFlg;
+	else
+		secFlags = global_secflags | vol->secFlg;
+
+	switch (server->secType) {
+	case LANMAN:
+		if (!(secFlags & (CIFSSEC_MAY_LANMAN|CIFSSEC_MAY_PLNTXT)))
+			return false;
+		break;
+	case NTLMv2:
+		if (!(secFlags & CIFSSEC_MAY_NTLMV2))
+			return false;
+		break;
+	case NTLM:
+		if (!(secFlags & CIFSSEC_MAY_NTLM))
+			return false;
+		break;
+	case Kerberos:
+		if (!(secFlags & CIFSSEC_MAY_KRB5))
+			return false;
+		break;
+	case RawNTLMSSP:
+		if (!(secFlags & CIFSSEC_MAY_NTLMSSP))
+			return false;
+		break;
+	default:
+		/* shouldn't happen */
+		return false;
+	}
+
+	/* now check if signing mode is acceptible */
+	if ((secFlags & CIFSSEC_MAY_SIGN) == 0 &&
+	    (server->secMode & SECMODE_SIGN_REQUIRED))
+			return false;
+	else if (((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) &&
+		 (server->secMode &
+		  (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED)) == 0)
+			return false;
+
+	return true;
+}
+
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr)
+cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 {
 	struct TCP_Server_Info *server;
 
@@ -1430,6 +1478,9 @@ cifs_find_tcp_session(struct sockaddr *addr)
 		if (!match_address(server, addr))
 			continue;
 
+		if (!match_security(server, vol))
+			continue;
+
 		++server->srv_count;
 		write_unlock(&cifs_tcp_ses_lock);
 		cFYI(1, "Existing tcp session with server found");
@@ -1498,7 +1549,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 
 	/* see if we already have a matching tcp_ses */
-	tcp_ses = cifs_find_tcp_session((struct sockaddr *)&addr);
+	tcp_ses = cifs_find_tcp_session((struct sockaddr *)&addr, volume_info);
 	if (tcp_ses)
 		return tcp_ses;
 
-- 
1.6.6.1
