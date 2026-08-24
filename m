Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63C22931F5;
	Mon, 24 Aug 2026 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601559; cv=none; b=kUDMud7sdfJqjVEgEIkV+ZuVoJ8nB4vYvXmxvsPffosDvK6gRZfnkmTsLOhg+ZnfEbyptY5p5oeATvb9HuMOCOW4Nr2jJ4XwxMcNt6in/RUfW0uh8PLHG4gd+vKupviDCQfaxCSHsV/L3rVnuiznQFDiLuXkw2RP1G5y7Cl9yz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601559; c=relaxed/simple;
	bh=EkhwzndBhH4YFqf6UroCHaPB1xikcSb0q8FsUSBuxIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pyzDgfCyCYPWyfGUdYLrXn0wHqO3RhEZNX0fCdoi/yNszKeXlxWxYNECBTACYePi09CnCcFwqXgHL217iLvrQw7PNdaqUahpwgPJaILeGyRRUR/qfJ4CuipYUzKPN+vBdlLyWNB5B9w1GiCNoW3PyhjFdDzHWMJ+esNKZNVRzAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Jugmt6AM; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Jugmt6AM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=A1Dv5NPcz3w7cNz6A3lccZTHUQhM8nNWR0gWxzKUraY=; b=Jugmt6AMeZrQlCfvm9lC3vtJlE
	rgT3wFrjMhFyZ+fQH9iLVQ7WoXj0dS7pwgJDr8NXQ6YkhgzzYOK3pQNILUHfsFy635Dgd+EDIv7xZ
	wIaFFE3pM53rJDCj1Wlw2M4MNtt7eoW+SXBjCPaEC5B10SNcX11mMTjTVfydFpNKrWabCFNSFHZqm
	CHLdD89Hey6r29XLlIpO1amSgWiFHv9365uJmkKJVAq31JW5rryjijbwFcMk/DbJFaegLu8two8i2
	OTQzfHUd4sJpOmtx0crgmz+1ezqq7Sx5J4j52R9yZe4kqEYfQYs3vfZpQTPIFK7bPo9wCZN7aV6zp
	bCu9daXw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wyap7-00000000asH-1IKJ;
	Mon, 24 Aug 2026 16:59:13 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Jacob Shivers <jshivers@redhat.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix multiuser mount with krb5
Date: Mon, 24 Aug 2026 16:59:12 -0300
Message-ID: <20260824195912.634526-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customer reported that they could no longer mount their SMB shares
with multiuser mount option and krb5.  Turned out that the client
wasn't duplicating username option when creating multiuser
connections, therefore failing to retrieve credentials as
cifs.upcall(8) couldn't find them in keytab.

Fix this by duplicating username option (if set) from original fs
context before creating multiuser connections with krb5.

Reproducer:

  ```
  $ ktutil
  ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
  Password for testuser@ZELDA.TEST:
  ktutil:  write_kt /etc/krb5.keytab
  ktutil:  quit
  $ klist -ke
  Keytab name: FILE:/etc/krb5.keytab
  KVNO Principal
   ---- ----------------------------------------------------------------
     1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
  $ mount.cifs //w22-root2/scratch /mnt/1 -o \
      	uid=1000,sec=krb5,username=testuser@ZELDA.TEST,multiuser
  mount error(13): Permission denied
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
  kernel log messages (dmesg)
  ```

Reported-by: Jacob Shivers <jshivers@redhat.com>
Fixes: 12b4c5d98cd7 ("smb: client: fix krb5 mount with username option")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index bcd7f1ae99ba..b6e98eb31673 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4189,14 +4189,25 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-static int
-cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
+static int set_fs_context_auth(struct smb3_fs_context *ctx,
+			       struct cifs_ses *ses)
 {
 	ctx->sectype = ses->sectype;
 
-	/* krb5 is special, since we don't need username or pw */
-	if (ctx->sectype == Kerberos)
+	/*
+	 * krb5 is special as we might need to pass username (passwordless) down
+	 * to cifs.upcall(8) for keytab.
+	 */
+	if (ctx->sectype == Kerberos) {
+		if (ses->user_name && ses->user_name[0]) {
+			ctx->username = kstrndup(ses->user_name,
+						 CIFS_MAX_USERNAME_LEN,
+						 GFP_KERNEL);
+			if (!ctx->username)
+				return -ENOMEM;
+		}
 		return 0;
+	}
 
 	return cifs_set_cifscreds(ctx, ses);
 }
@@ -4236,7 +4247,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 	ctx->unicode = master_tcon->ses->unicode;
 
-	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
+	rc = set_fs_context_auth(ctx, master_tcon->ses);
 	if (rc) {
 		tcon = ERR_PTR(rc);
 		goto out;
-- 
2.55.0

