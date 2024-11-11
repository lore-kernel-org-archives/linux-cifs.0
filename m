Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F5019D078
	for <linux-cifs@vger.kernel.org>; Mon, 11 Nov 2024 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332475; cv=fail; b=UZmFrunCRqkoDQHQB9OxpLx4Yx+H1znCjtSU11zhoR0Z+0rIFOWLGVQrRtEUFSJ+2QwRongtJn/gKAeFF8rB6vD5mhX54F4L+EpuDbue1cPI6sSRthp9Mg0NDXJCO8siAUAaD0S8r+mcdoiZqgQOilbGboL9ewLsfgmt/TrwM/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332475; c=relaxed/simple;
	bh=XtPh3A6GY7tGq7IiW+ISg02szZ0LKbHlsMSrsKqgKQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mkvl0czG8owAJKDLImc/pGAKEYOHkw5MZZ4st5HROFFczS2/s4WTCgYBfwxRQhBVKamU0WdD+7EqsMsK3swvYXGB1vpKNMaJFQgjAtUouZEV6mG0jjrZ3Oqx2NqHhlAurUSfKvbet+VjHc1aZuew3aTam1Hi8BY0Xzii1O0LH4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=aKyHvG3m; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="aKyHvG3m"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731332471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nk1zr3IOKgZkalXZrKJKIHqUk7AWBPllVW3rnGiSq20=;
	b=aKyHvG3mwWoWYWG9FyApczdZLJHkJcaEWWTCfFfB2sEEbYMuE1QBIfZLoxfOn5ggyIdk4v
	aC9Livw2erIzvSthWGHBdfFWEKbpk7Aw0xyCeGZvH7zrB6NHrVmO0lf/03eoEJfcEFGRcx
	iKCLGmDe4i7+ROxUwXrLzlIZ4k/Kf1JMiDZWKZj4ke5uzLEbEsRMXaLssZkcugqpX2EH0n
	kds4YP9+PAVr3bBHEkae+VC5j//ptAs89CU+K80tvJxEukBist7DJpSC8XUI9gVJykOk13
	AfVdMUgzLQgt4wyG2eupbBBnsPwYpEkKPeX/C7LVxmYUye5/BuRMMBoQQHIevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731332471; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Nk1zr3IOKgZkalXZrKJKIHqUk7AWBPllVW3rnGiSq20=;
	b=Q1s1g0Xlr5a0Zzjqfc7KoiO/fFeINLltKBHqYp98fC6r5NV0MSf3ccgoSjN9A7+93Nawa/
	lyosIkFVFOxBfgIQRXrHkKT6Ewei5TyyuTjaPlD2vxVAL9q9qV8yP25iJ/slaDU/Adm4X9
	I1VaTyEhC9mEHB09wdgFXj6okcsO0QyBzYHw0oZ0A8cUiYV9Ylec/w0tlnd6y458BajnEd
	Jgp28AESUQFnJa71cx/dTUVDapDUmiVFFDu5czbv5V1xvkKOomM62xrYA06OMSNrptHLQE
	LROx6FeeYhz/scmL0IzOh9qHCv26OK6chUg39DNIxyd3KxAy3y9wpOtZwFHtYw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731332471; a=rsa-sha256;
	cv=none;
	b=h+GVeXOJG2ESmynOHW9keDNtDTNluAHmBOGFzVIC/9SLHJWMiWZeXYUvaXtZ+mZ5eb0RJm
	+hlZ+oRyleb00xsdEj3fuilynVC7WC+GMC1vyPjTcTpzW9pkWl26b0ZWbGu3OaMUAH8+Yr
	ZqMlcbKOUBSW6dzhR7qwRfLOYGanLFGnRKRQ7oStYDPtaWWASa4fDxXTgNTAvHk46D+qvP
	Ompkhod6JPUn/vjgGIL6kPWGjQzJI5moavkYhhFI8Wl8qWjaOAtqCO/xmkqa+qlXD2VzHr
	StQ1d0Ex4KEKLjI+mY3vvyK3C88VEyde48f+MlC7Ng/lC+Gp14EkgG3NtRiqrA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Jay Shin <jaeshin@redhat.com>
Subject: [PATCH] smb: client: fix use-after-free of signing key
Date: Mon, 11 Nov 2024 10:40:55 -0300
Message-ID: <20241111134055.66981-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customers have reported use-after-free in @ses->auth_key.response with
SMB2.1 + sign mounts which occurs due to following race:

task A                         task B
cifs_mount()
 dfs_mount_share()
  get_session()
   cifs_mount_get_session()    cifs_send_recv()
    cifs_get_smb_ses()          compound_send_recv()
     cifs_setup_session()        smb2_setup_request()
      kfree_sensitive()           smb2_calc_signature()
                                   crypto_shash_setkey() *UAF*

Fix this by ensuring that we have a valid @ses->auth_key.response by
checking whether @ses->ses_status is SES_GOOD or SES_EXITING with
@ses->ses_lock held.  After commit 24a9799aa8ef ("smb: client: fix UAF
in smb2_reconnect_server()"), we made sure to call ->logoff() only
when @ses was known to be good (e.g. valid ->auth_key.response), so
it's safe to access signing key when @ses->ses_status == SES_EXITING.

Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2proto.h     |  2 --
 fs/smb/client/smb2transport.c | 56 +++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 6f9885e4f66c..71504b30909e 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -37,8 +37,6 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
-extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
-					   __u64 ses_id);
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index b486b14bb330..475b36c27f65 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -74,7 +74,7 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 
 static
-int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
+int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
 	struct TCP_Server_Info *pserver;
@@ -168,16 +168,41 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 	return NULL;
 }
 
-struct cifs_ses *
-smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
+static int smb2_get_sign_key(struct TCP_Server_Info *server,
+			     __u64 ses_id, u8 *key)
 {
 	struct cifs_ses *ses;
+	int rc = -ENOENT;
+
+	if (SERVER_IS_CHAN(server))
+		server = server->primary_server;
 
 	spin_lock(&cifs_tcp_ses_lock);
-	ses = smb2_find_smb_ses_unlocked(server, ses_id);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->Suid != ses_id)
+			continue;
+
+		rc = 0;
+		spin_lock(&ses->ses_lock);
+		switch (ses->ses_status) {
+		case SES_EXITING: /* SMB2_LOGOFF */
+		case SES_GOOD:
+			if (likely(ses->auth_key.response)) {
+				memcpy(key, ses->auth_key.response,
+				       SMB2_NTLMV2_SESSKEY_SIZE);
+			} else {
+				rc = -EIO;
+			}
+			break;
+		default:
+			rc = -EAGAIN;
+			break;
+		}
+		spin_unlock(&ses->ses_lock);
+		break;
+	}
 	spin_unlock(&cifs_tcp_ses_lock);
-
-	return ses;
+	return rc;
 }
 
 static struct cifs_tcon *
@@ -236,14 +261,16 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct cifs_ses *ses;
 	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
+	__u64 sid = le64_to_cpu(shdr->SessionId);
+	u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
 
-	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
-	if (unlikely(!ses)) {
-		cifs_server_dbg(FYI, "%s: Could not find session\n", __func__);
-		return -ENOENT;
+	rc = smb2_get_sign_key(server, sid, key);
+	if (unlikely(rc)) {
+		cifs_server_dbg(FYI, "%s: [sesid=0x%llx] couldn't find signing key: %d\n",
+				__func__, sid, rc);
+		return rc;
 	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
@@ -260,8 +287,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		shash = server->secmech.hmacsha256;
 	}
 
-	rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
-			SMB2_NTLMV2_SESSKEY_SIZE);
+	rc = crypto_shash_setkey(shash->tfm, key, sizeof(key));
 	if (rc) {
 		cifs_server_dbg(VFS,
 				"%s: Could not update with response\n",
@@ -303,8 +329,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 out:
 	if (allocate_crypto)
 		cifs_free_hash(&shash);
-	if (ses)
-		cifs_put_smb_ses(ses);
 	return rc;
 }
 
@@ -570,7 +594,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
+	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
 		cifs_server_dbg(FYI, "%s: Could not get signing key\n", __func__);
 		return rc;
-- 
2.47.0

