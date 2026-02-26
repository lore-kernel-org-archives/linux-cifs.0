Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7646BF
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066106; cv=none; b=swV3GHY3mhbu2b5sEnwH32J2HBzCgUZnMEAq5B+9UL/KfeAi8idVPfr3SlEXLVetv2uDLtYTDiCCX4ADp/wGmJnXqHJtZdUy72aw+X9iUVil+oxHbVz+utxkxehuW+gK47kCEeXBCB2eMCYe6i9+99/sqwQwLZ3A9TYF2NW7/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066106; c=relaxed/simple;
	bh=XGKUDsPOl9as3tiOowXkWTjAjP/AsKmQKJwG5Th+c0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aCwHNfku8SBykg+foVhIsz8ifUymXQh1zv1EejCzkbK7QQHJlkf+zSCSYMll8+E6vQegeBi0alMQCbj8DRIJYwFRlKLjKHxCTj+1gkGnqvPeRd3gck8Bh0Ep2f3OwrWbHywEhUBgFGT4CK/A0gINR/Seb1G4en3HtswY6Km56lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=lEZQ8Nle; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="lEZQ8Nle"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=dagXK1ZKwMbMHXC7wWItm0VOoo33AapfcOGvsneSdJ0=; b=lEZQ8Nlezcmf3yn725/Cq1/SrL
	RsgANXK3oX7iI4PhmA8MFV+D1xaCEQrYJCzv0KhbC0+hOKu1SnMYDmA1ii4os8PnP5u350fzxtfcl
	EcymSSWw2nSkrRmI1O4uPscsga+4J6vXrl376br1bYdbHbOKs4OZO28YLG2jdoo6Ecg0u4rRK9MRH
	uUwZ1fgVHJ34yKuJgRGG1IIsjvGMuILgE+uA1HQIRC5X/dMLWh4+570Eljdu0suESTIhxydztPpr4
	17+Fkxero3WV2NtaPsY7W71hwgSJmrU27NZsnwUXL4KAI0mKVR+Eob1mxDLJgrQ1ZwnCyhtcasRWJ
	hCXB67BA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vvPLD-00000000nhr-1DDg;
	Wed, 25 Feb 2026 21:34:55 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Xiaoli Feng <xifeng@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix broken multichannel with krb5+signing
Date: Wed, 25 Feb 2026 21:34:55 -0300
Message-ID: <20260226003455.1699030-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a share with 'multichannel,max_channels=n,sec=krb5i',
the client was duplicating signing key for all secondary channels,
thus making the server fail all commands sent from secondary channels
due to bad signatures.

Every channel has its own signing key, so when establishing a new
channel with krb5 auth, make sure to use the new session key as the
derived key to generate channel's signing key in SMB2_auth_kerberos().

Repro:

$ mount.cifs //srv/share /mnt -o multichannel,max_channels=4,sec=krb5i
$ sleep 5
$ umount /mnt
$ dmesg
  ...
  CIFS: VFS: sign fail cmd 0x5 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13
  CIFS: VFS: sign fail cmd 0x5 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13
  CIFS: VFS: sign fail cmd 0x4 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a2a96d817717..04e361ed2356 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1714,19 +1714,17 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	is_binding = (ses->ses_status == SES_GOOD);
 	spin_unlock(&ses->ses_lock);
 
-	/* keep session key if binding */
-	if (!is_binding) {
-		kfree_sensitive(ses->auth_key.response);
-		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
-						 GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
-				 msg->sesskey_len);
-			rc = -ENOMEM;
-			goto out_put_spnego_key;
-		}
-		ses->auth_key.len = msg->sesskey_len;
+	kfree_sensitive(ses->auth_key.response);
+	ses->auth_key.response = kmemdup(msg->data,
+					 msg->sesskey_len,
+					 GFP_KERNEL);
+	if (!ses->auth_key.response) {
+		cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
+			 __func__, msg->sesskey_len);
+		rc = -ENOMEM;
+		goto out_put_spnego_key;
 	}
+	ses->auth_key.len = msg->sesskey_len;
 
 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
 	sess_data->iov[1].iov_len = msg->secblob_len;
-- 
2.53.0

