Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990F236A01F
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764871598; cv=none; b=RSUJTb95wpf1iNwlfjhHDszNwk+wDKIe7dR9zG9HnA31OtMFdCQKY+jDa3rMs9/vLgScYnjF/oGExZMcTQ/TXd1uH3253c+axps0pnAExRv2P9ZcH3G9GD4lEaE6J63n1arkxZrLRb30ebIVpzlRjbMqTdf79LKwIKSjyVt5pE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764871598; c=relaxed/simple;
	bh=p3Ef8YjpFzUkf0lakBtEGhbxe+MCiWLYbB2yai8rnJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa7X7su5d9Ci+Tf6DLs0LvFvKGk3a9L6wsCUOVx0WGfhkC71VOeJ4YrNQv/ahFx75Bt4N/8AXR9YNR41RbjMHp2dXlSH+jZoJpJAWWtswrWr1gpjacJyDk82WLHRm9jR8itAlnJAtXEOwAFCry0mj+uxb3kCWmJAtTJLu3BBjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=6W9yuDaX; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="6W9yuDaX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=o6V/OwSd+NhygMB7t6/bN9/+lHSV9lflyWkuxkqZpfc=; b=6W9yuDaXiIVGzhxV5/N9gBNbmE
	BeTRsy652M05chv9lK9KSEEih95e9iFqNpJGCYH8fWCzFHTAHPiud1NzEttCdTWQxxHD6VJJ5jRDy
	s57CKL63pyBEglL9rFRJhR1Xok0SknElLmU2bH/TaCssO5pn05hPg+ZWik8XLHnDGWQePbwyY48ls
	x4IBbKM0ef6YYldHxwtd9hg2He0S3nubMmBLisYui8g1mf+wMFN8Q8bjeY5bdClUEHSJjbeq3BV6e
	Nxp0va8Lw/D1rUD3piCQQTeKkao051cVezJYWOOUEqlCttL7NtL/W0c8fhtqb9+k47epczhfuBOVq
	cRo6KUKw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vRDik-00000000Dfr-1i0H;
	Thu, 04 Dec 2025 15:06:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Pierguido Lambri <plambri@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/3] smb: client: Add tracepoint for krb5 auth
Date: Thu,  4 Dec 2025 15:06:25 -0300
Message-ID: <20251204180626.244415-3-pc@manguebit.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251204180626.244415-1-pc@manguebit.org>
References: <20251204180626.244415-1-pc@manguebit.org>
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
Cc: Pierguido Lambri <plambri@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifs_spnego.c | 25 ++++++++++------
 fs/smb/client/smb2pdu.c     |  2 --
 fs/smb/client/trace.h       | 60 +++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index da935bd1ce87..48e90773462c 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -84,12 +84,13 @@ struct key *
 cifs_get_spnego_key(struct cifs_ses *sesInfo,
 		    struct TCP_Server_Info *server)
 {
-	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
 	struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
+	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
+	const char *hostname = server->hostname;
+	const char *sec = "krb5";
 	char *description, *dp;
-	size_t desc_len;
 	struct key *spnego_key;
-	const char *hostname = server->hostname;
+	size_t desc_len;
 
 	/* length of fields (with semicolons): ver=0xyz ip4=ipaddress
 	   host=hostname sec=mechanism uid=0xFF user=username */
@@ -130,15 +131,14 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 
 	/* for now, only sec=krb5 and sec=mskrb5 and iakerb are valid */
 	if (server->sec_kerberos)
-		dp += sprintf(dp, ";sec=krb5");
+		sec = "krb5";
 	else if (server->sec_mskerberos)
-		dp += sprintf(dp, ";sec=mskrb5");
+		sec = "mskrb5";
 	else if (server->sec_iakerb)
-		dp += sprintf(dp, ";sec=iakerb");
-	else {
+		sec = "iakerb";
+	else
 		cifs_dbg(VFS, "unknown or missing server auth type, use krb5\n");
-		dp += sprintf(dp, ";sec=krb5");
-	}
+	dp += sprintf(dp, ";sec=%s", sec);
 
 	dp += sprintf(dp, ";uid=0x%x",
 		      from_kuid_munged(&init_user_ns, sesInfo->linux_uid));
@@ -159,6 +159,13 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	cifs_dbg(FYI, "key description = %s\n", description);
 	scoped_with_creds(spnego_cred)
 		spnego_key = request_key(&cifs_spnego_key_type, description, "");
+	trace_smb3_kerberos_auth(CIFS_SPNEGO_UPCALL_VERSION,
+				 hostname, &server->dstaddr, sec,
+				 from_kuid_munged(&init_user_ns, sesInfo->linux_uid),
+				 from_kuid_munged(&init_user_ns, sesInfo->cred_uid),
+				 sesInfo->user_name, current->pid,
+				 sesInfo->upcall_target == UPTARGET_MOUNT ? "mount" : "app",
+				 IS_ERR(spnego_key) ? PTR_ERR(spnego_key) : 0);
 
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
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 252073352e79..0d0261777aa9 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1692,6 +1692,66 @@ DEFINE_SMB3_CREDIT_EVENT(waitff_credits);
 DEFINE_SMB3_CREDIT_EVENT(overflow_credits);
 DEFINE_SMB3_CREDIT_EVENT(set_credits);
 
+DECLARE_EVENT_CLASS(smb3_kerberos_class,
+		    TP_PROTO(int vers,
+			     const char *host,
+			     const struct __kernel_sockaddr_storage *addr,
+			     const char *sec,
+			     uid_t uid,
+			     uid_t cruid,
+			     const char *user,
+			     pid_t pid,
+			     const char *upcall_target,
+			     int rc),
+		    TP_ARGS(vers, host, addr, sec, uid, cruid, user, pid, upcall_target, rc),
+		    TP_STRUCT__entry(
+			    __field(int, vers)
+			    __string(host, host)
+			    __array(__u8, addr, sizeof(struct sockaddr_storage))
+			    __string(sec, sec)
+			    __field(uid_t, uid)
+			    __field(uid_t, cruid)
+			    __string(user, user)
+			    __field(pid_t, pid)
+			    __string(upcall_target, upcall_target)
+			    __field(int, rc)
+		    ),
+		    TP_fast_assign(
+			    struct sockaddr_storage *pss = NULL;
+
+			    __entry->vers = vers;
+			    __assign_str(host);
+			    pss = (struct sockaddr_storage *)__entry->addr;
+			    *pss = *addr;
+			    __assign_str(sec);
+			    __entry->uid = uid;
+			    __entry->cruid = cruid;
+			    __assign_str(user);
+			    __entry->pid = pid;
+			    __assign_str(upcall_target);
+			    __entry->rc = rc;
+		    ),
+		    TP_printk("vers=%d host=%s ip=%pISpsfc sec=%s uid=%d cruid=%d user=%s pid=%d upcall_target=%s err=%d",
+			      __entry->vers, __get_str(host), __entry->addr,
+			      __get_str(sec), __entry->uid, __entry->cruid,
+			      __get_str(user), __entry->pid, __get_str(upcall_target),
+			      __entry->rc))
+
+#define DEFINE_SMB3_KERBEROS_EVENT(name) \
+DEFINE_EVENT(smb3_kerberos_class, smb3_##name, \
+	TP_PROTO(int vers, \
+		 const char *host, \
+		 const struct __kernel_sockaddr_storage *addr, \
+		 const char *sec, \
+		 uid_t uid, \
+		 uid_t cruid, \
+		 const char *user, \
+		 pid_t pid, \
+		 const char *upcall_target, \
+		 int rc), \
+	TP_ARGS(vers, host, addr, sec, uid, cruid, user, pid, upcall_target, rc))
+
+DEFINE_SMB3_KERBEROS_EVENT(kerberos_auth);
 
 TRACE_EVENT(smb3_tcon_ref,
 	    TP_PROTO(unsigned int tcon_debug_id, int ref,
-- 
2.52.0

