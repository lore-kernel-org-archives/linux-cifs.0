Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F6E281368
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754664819; cv=none; b=tfbI2oTx6EQkO5L5yZhFrIhglDHWdrV+EJLzZg3y8RCsOPRz9Y0hLJ7DfZ3sQagym09jMBAkDzCl9jmVqWgJ5iowmNeJ577SJY6iMj7p1AhNtygrAX59wNgXbAfle17aSSfIzk7Tt9ez54rCj6L7z6Nq7SzK8yIjnNRwEkHk1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754664819; c=relaxed/simple;
	bh=ANR1Ch4DsPV4p2L9xFs1Qv5CXlWR2b0+4aqsA+1H2z8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aOVLVksAx/d/f/SwEIPoZvNQZhDA9iIRhPtskambcZndRmPSL1QXMevCac7JQ0SoBPf8szWwNRNkTzfBgtsxaDdbZYfvt5sw7ZkoAlO1r8w80NvxYir4ttYe1l5B/hb0QpgVL9QMDuLadhBHIGzLUEuw7q73fS4MfDGFDxvT9rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ecu4cOkQ; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ecu4cOkQ"
Received: from mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net [IPv6:2a02:6b8:c10:2987:0:640:47b0:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id CDC20C0137;
	Fri, 08 Aug 2025 17:53:25 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id OrktRgSFpeA0-v2dDoGBO;
	Fri, 08 Aug 2025 17:53:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1754664805; bh=d0I9Nnfov1UEVBQYlNPT5GY7AP+Mq1yY9ehJI0Z8MAg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ecu4cOkQP6eNFnXqn8pY2n2hdtaqfONU4lRZ7pyF++HdMK0O8nwgq6cmA1P8waY9/
	 10YnGoSC9+jEzPrkmhPQDvFHcrG4HYU20qasDlcd0k6Bjlb+g1vIYBLS/fxfcxsvB+
	 WilI08Wv5GUJQwwjS1Jaef8J9+ruI3GJW2z+FERQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-73.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] cifs: avoid extra calls to strlen() in cifs_get_spnego_key()
Date: Fri,  8 Aug 2025 17:52:21 +0300
Message-ID: <20250808145221.479993-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'snprintf()' returns the number of characters emitted, an
output position may be advanced with this return value rather
than using an explicit calls to 'strlen()'. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/smb/client/cifs_spnego.c | 47 ++++++++++++++-----------------------
 kernel/bpf/verifier.c       |  3 +++
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index bc1c1e9b288a..43b86fa4d695 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -124,55 +124,44 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	dp = description;
 	/* start with version and hostname portion of UNC string */
 	spnego_key = ERR_PTR(-EINVAL);
-	sprintf(dp, "ver=0x%x;host=%s;", CIFS_SPNEGO_UPCALL_VERSION,
-		hostname);
-	dp = description + strlen(description);
+	dp += sprintf(dp, "ver=0x%x;host=%s;", CIFS_SPNEGO_UPCALL_VERSION,
+		      hostname);
 
 	/* add the server address */
 	if (server->dstaddr.ss_family == AF_INET)
-		sprintf(dp, "ip4=%pI4", &sa->sin_addr);
+		dp += sprintf(dp, "ip4=%pI4", &sa->sin_addr);
 	else if (server->dstaddr.ss_family == AF_INET6)
-		sprintf(dp, "ip6=%pI6", &sa6->sin6_addr);
+		dp += sprintf(dp, "ip6=%pI6", &sa6->sin6_addr);
 	else
 		goto out;
 
-	dp = description + strlen(description);
-
 	/* for now, only sec=krb5 and sec=mskrb5 and iakerb are valid */
 	if (server->sec_kerberos)
-		sprintf(dp, ";sec=krb5");
+		dp += sprintf(dp, ";sec=krb5");
 	else if (server->sec_mskerberos)
-		sprintf(dp, ";sec=mskrb5");
+		dp += sprintf(dp, ";sec=mskrb5");
 	else if (server->sec_iakerb)
-		sprintf(dp, ";sec=iakerb");
+		dp += sprintf(dp, ";sec=iakerb");
 	else {
 		cifs_dbg(VFS, "unknown or missing server auth type, use krb5\n");
-		sprintf(dp, ";sec=krb5");
+		dp += sprintf(dp, ";sec=krb5");
 	}
 
-	dp = description + strlen(description);
-	sprintf(dp, ";uid=0x%x",
-		from_kuid_munged(&init_user_ns, sesInfo->linux_uid));
+	dp += sprintf(dp, ";uid=0x%x",
+		      from_kuid_munged(&init_user_ns, sesInfo->linux_uid));
 
-	dp = description + strlen(description);
-	sprintf(dp, ";creduid=0x%x",
+	dp += sprintf(dp, ";creduid=0x%x",
 		from_kuid_munged(&init_user_ns, sesInfo->cred_uid));
 
-	if (sesInfo->user_name) {
-		dp = description + strlen(description);
-		sprintf(dp, ";user=%s", sesInfo->user_name);
-	}
+	if (sesInfo->user_name)
+		dp += sprintf(dp, ";user=%s", sesInfo->user_name);
 
-	dp = description + strlen(description);
-	sprintf(dp, ";pid=0x%x", current->pid);
+	dp += sprintf(dp, ";pid=0x%x", current->pid);
 
-	if (sesInfo->upcall_target == UPTARGET_MOUNT) {
-		dp = description + strlen(description);
-		sprintf(dp, ";upcall_target=mount");
-	} else {
-		dp = description + strlen(description);
-		sprintf(dp, ";upcall_target=app");
-	}
+	if (sesInfo->upcall_target == UPTARGET_MOUNT)
+		dp += sprintf(dp, ";upcall_target=mount");
+	else
+		dp += sprintf(dp, ";upcall_target=app");
 
 	cifs_dbg(FYI, "key description = %s\n", description);
 	saved_cred = override_creds(spnego_cred);
-- 
2.50.1

