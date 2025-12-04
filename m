Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350903101DE
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 21:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764884360; cv=none; b=iiVA3lnn+mfkneHNuUrNKISnct2eS39Rse8jUi/CysT6wz/9ZLf+XxdmeD8iIqiAW/o7G3cqzvYuQUhhYe5lQKCAGQFD/EIS1G5v/hXGmDg5yOe2iTu7nL2XYKz9+ldZVetKUxsk8wUEiBwgB2LGlrEX4zCCIELOfQGftYMx9Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764884360; c=relaxed/simple;
	bh=ZqY5JezIXlhvEEzgV/wDr7jWcljZCYFA6DAyxy7V3D4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JC1N6a/13a/99mhl6TgMipqfw520NkTjuOLRzZAYKzMBM6gFySjv1S+lQ7FxnLc5/Uec1dUAQqqqCq6fsDn7C1VEPwgB1Ui+2pp882QKaZ7e1cPB4rcOP7u+j51ijkrT5neWP00vf4BM4OrzZ+CsOgzIHtzZ00JCZ9ILVo/QNZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vQvJTtEa; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vQvJTtEa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SsxDJ7vbVv5P6BflZHtKCNR51ifqXYhjJ50LQ3W5clw=; b=vQvJTtEa+exxhIQfPgT2w6CMH7
	pErtIChkXbA6TNzAiApG6nYNCsMDeRSi6jIwnL3d9INaW0ADPwixOOj6FLfB0XZaKQWV1yS5zWaTA
	V+Z59UPipv/Nlexezk37gdCMFjlL9iUT+VZch5LYVIl1e1Zuv5Cgu6luPreawaaXKTJhhUAdvJXqq
	qQdJXjJp02hiqCQQRig+4hapYo4uuk8VvU/mW1KjTCYPsPJSAAtKj/B3X/N3yw6cs1SgVjdGAp1B7
	XH1iAdocgvGM9S103lAKU01TVEaRPBXN49G8a3cMmdoiSxlCXpx1VvDDCTTGm8DwN4s7ZyTsTr8ix
	nm4EYK8g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vRH2g-00000000EDw-3vqo;
	Thu, 04 Dec 2025 18:39:14 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: Add tracepoint for krb5 auth
Date: Thu,  4 Dec 2025 18:39:14 -0300
Message-ID: <20251204213914.546291-1-pc@manguebit.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tracepoint to help debugging krb5 auth failures.

Example:

$ trace-cmd record -e smb3_kerberos_auth
$ mount.cifs ...
$ trace-cmd report
mount.cifs-1667 [003] .....  5810.668549: smb3_kerberos_auth: vers=2
host=w22-dc1.zelda.test ip=192.168.124.30:445 sec=krb5 uid=0 cruid=0
user=root pid=1667 upcall_target=app err=-126

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Pierguido Lambri <plambri@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
v1 -> v2: simplify trace function

 fs/smb/client/cifs_spnego.c |  1 +
 fs/smb/client/smb2pdu.c     |  2 --
 fs/smb/client/trace.c       |  1 +
 fs/smb/client/trace.h       | 43 +++++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index da935bd1ce87..3a41bbada04c 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -159,6 +159,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	cifs_dbg(FYI, "key description = %s\n", description);
 	scoped_with_creds(spnego_cred)
 		spnego_key = request_key(&cifs_spnego_key_type, description, "");
+	trace_smb3_kerberos_auth(server, sesInfo, PTR_ERR_OR_ZERO(spnego_key));
 
 #ifdef CONFIG_CIFS_DEBUG2
 	if (cifsFYI && !IS_ERR(spnego_key)) {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 0d2940808be6..599cdc6db46c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1691,8 +1691,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	spnego_key = cifs_get_spnego_key(ses, server);
 	if (IS_ERR(spnego_key)) {
 		rc = PTR_ERR(spnego_key);
-		if (rc == -ENOKEY)
-			cifs_dbg(VFS, "Verify user has a krb5 ticket and keyutils is installed\n");
 		spnego_key = NULL;
 		goto out;
 	}
diff --git a/fs/smb/client/trace.c b/fs/smb/client/trace.c
index 16b0e719731f..8a99b68d0c71 100644
--- a/fs/smb/client/trace.c
+++ b/fs/smb/client/trace.c
@@ -5,5 +5,6 @@
  *   Author(s): Steve French <stfrench@microsoft.com>
  */
 #include "cifsglob.h"
+#include "cifs_spnego.h"
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 252073352e79..b0fbc2df642e 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1692,6 +1692,49 @@ DEFINE_SMB3_CREDIT_EVENT(waitff_credits);
 DEFINE_SMB3_CREDIT_EVENT(overflow_credits);
 DEFINE_SMB3_CREDIT_EVENT(set_credits);
 
+TRACE_EVENT(smb3_kerberos_auth,
+		TP_PROTO(struct TCP_Server_Info *server,
+			 struct cifs_ses *ses,
+			 int rc),
+		TP_ARGS(server, ses, rc),
+		TP_STRUCT__entry(
+			__field(pid_t, pid)
+			__field(uid_t, uid)
+			__field(uid_t, cruid)
+			__string(host, server->hostname)
+			__string(user, ses->user_name)
+			__array(__u8, addr, sizeof(struct sockaddr_storage))
+			__array(char, sec, sizeof("ntlmsspi"))
+			__array(char, upcall_target, sizeof("mount"))
+			__field(int, rc)
+		),
+		TP_fast_assign(
+			__entry->pid = current->pid;
+			__entry->uid = from_kuid_munged(&init_user_ns, ses->linux_uid);
+			__entry->cruid = from_kuid_munged(&init_user_ns, ses->cred_uid);
+			__assign_str(host);
+			__assign_str(user);
+			memcpy(__entry->addr, &server->dstaddr, sizeof(__entry->addr));
+
+			if (server->sec_kerberos)
+				memcpy(__entry->sec, "krb5", sizeof("krb5"));
+			else if (server->sec_mskerberos)
+				memcpy(__entry->sec, "mskrb5", sizeof("mskrb5"));
+			else if (server->sec_iakerb)
+				memcpy(__entry->sec, "iakerb", sizeof("iakerb"));
+			else
+				memcpy(__entry->sec, "krb5", sizeof("krb5"));
+
+			if (ses->upcall_target == UPTARGET_MOUNT)
+				memcpy(__entry->upcall_target, "mount", sizeof("mount"));
+			else
+				memcpy(__entry->upcall_target, "app", sizeof("app"));
+			__entry->rc = rc;
+		),
+		TP_printk("vers=%d host=%s ip=%pISpsfc sec=%s uid=%d cruid=%d user=%s pid=%d upcall_target=%s err=%d",
+			  CIFS_SPNEGO_UPCALL_VERSION, __get_str(host), __entry->addr,
+			  __entry->sec, __entry->uid, __entry->cruid, __get_str(user),
+			  __entry->pid, __entry->upcall_target, __entry->rc))
 
 TRACE_EVENT(smb3_tcon_ref,
 	    TP_PROTO(unsigned int tcon_debug_id, int ref,
-- 
2.52.0

