Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12675455173;
	Fri, 16 Oct 2026 21:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792187631; cv=none; b=qxpkdoRA6u02C+V2xqhk3fV5jEV+FYm+X0AMzd+eWj53LzJaFtzb24wym/7tkXAJE8ksKQ3WymOYMBDwgHw8E0oXaoW5iFj4cz0bmB9RAxlbUJFWIgqkVbTfh/x2GiGQtOn1zve0PLmuSHTnt9VIPshQ9K8mUk5wt7miZXc39m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792187631; c=relaxed/simple;
	bh=ZK7azRDiS9PvC6iZGVPB6px13u1Gw01tOdsHuvz3mwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rItQP9E5Pfu/gm+bH31Dkr1uxuLQpjLM3r4vtqLLWlD5OHu1X8dtRgdBUmvHTWX4E2yWu77Y8isi8LgHSJ1k0uyGufHJwkWG+UCaVhKPzVmSYv1uhTqdXmVTaIZIwUVdk6/afZ9N5qJdeDTJL/45BrR+27PBbIhv+vuQf5mnT88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+s0sxKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+s0sxKA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F29E1F000C4;
	Fri, 16 Oct 2026 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792187629;
	bh=bCMwZ8mQei7EDDTNVs6DlPqXteYgikRw7RDXBv3wkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+s0sxKA15LzpHP1KuWt5AxRcy/KHUT7ToKU5j3WjtfMR+5+pFgPQ0v9oiWa3PLE1
	 mNsAKNcdf+/MPcV0G2FZOsSLH1hZBTBashII1hMH8hKJePofybTaxFqe1jzrdnIh7/
	 CpOFAFh8AAjenjNMf1tICp62HXQtF07uqnN8TKz5YVgGi5aBrRM6/ykf/gMHwWihUp
	 17TdB6BCfE+muKJweyGRtG8yMZ/HAFV2TFqY3yoDbQtE8Nuy0PZUVa5yh7Na7zlFbm
	 WdaTmQOQ0omdyAvMKj62EHgpHj3XXJmAUmh3nXYkb2kyoG2sfjW1rkIKe1eMEPksig
	 CF2FBgRxMFVMA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-cifs@vger.kernel.org (open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	linux-kernel@vger.kernel.org (open list),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [RFC PATCH 1/6] keys: prevent quota overflow and widen quotalen and datalen to 32 bits
Date: Sat, 17 Oct 2026 00:52:59 +0300
Message-ID: <20261016215326.4110064-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016215326.4110064-1-jarkko@kernel.org>
References: <20261016215326.4110064-1-jarkko@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In struct key, quotalen and datalen are 16-bit unsigned shorts, limiting
payload and quota tracking to 64 KiB. With large descriptions or payload
updates, addition and difference calculations can truncate or overflow,
corrupting user quota accounting.

Additionally, existing quota checks rely on undefined signed overflow
checks (e.g. user->qnbytes + quotalen < user->qnbytes) and do not guard
against user->qnkeys or user->qnbytes reaching INT_MAX.

Widen quotalen and datalen to unsigned 32-bit integers in struct key.
Validate description lengths against INT_MAX in key_alloc(), and check
quota headroom using safe subtraction across key_alloc(),
key_payload_reserve(), and keyctl_chown_key().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/smb/client/cifsacl.c |  6 +++---
 include/linux/key.h     |  4 ++--
 security/keys/key.c     | 25 ++++++++++++++++++++-----
 security/keys/keyctl.c  |  9 +++++----
 4 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index c5e47a835f99..de2acc7234be 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -385,7 +385,7 @@ id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
 		goto out_revert_creds;
 	} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
 		rc = smb_EIO1(smb_eio_trace_malformed_sid_key, sidkey->datalen);
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u)\n",
 			 __func__, sidkey->datalen);
 		goto invalidate_key;
 	}
@@ -403,7 +403,7 @@ id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid)
 	if (ksid_size > sidkey->datalen) {
 		rc = smb_EIO2(smb_eio_trace_malformed_ksid_key,
 			      ksid_size, sidkey->datalen);
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu, ksid_size=%u)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u, ksid_size=%u)\n",
 			 __func__, sidkey->datalen, ksid_size);
 		goto invalidate_key;
 	}
@@ -498,7 +498,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 	 */
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u)\n",
 			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
 		goto out_key_put;
diff --git a/include/linux/key.h b/include/linux/key.h
index e40b5267658f..26139c3adf62 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -216,8 +216,8 @@ struct key {
 	kuid_t			uid;
 	kgid_t			gid;
 	key_perm_t		perm;		/* access permissions */
-	unsigned short		quotalen;	/* length added to quota */
-	unsigned short		datalen;	/* payload data length
+	unsigned int		quotalen;	/* length added to quota */
+	unsigned int		datalen;	/* payload data length
 						 * - may not match RCU dereferenced payload
 						 * - payload should contain own length
 						 */
diff --git a/security/keys/key.c b/security/keys/key.c
index 6ebb8691551f..144745684334 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -245,6 +245,10 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	}
 
 	desclen = strlen(desc);
+	if (desclen >= INT_MAX || type->def_datalen > INT_MAX - desclen - 1) {
+		key = ERR_PTR(-EINVAL);
+		goto error;
+	}
 	quotalen = desclen + 1 + type->def_datalen;
 
 	/* get hold of the key tracking for this user */
@@ -261,10 +265,14 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 			key_quota_root_maxbytes : key_quota_maxbytes;
 
 		spin_lock_irqsave(&user->lock, irqflags);
+		if (user->qnkeys == INT_MAX ||
+		    quotalen > INT_MAX - user->qnbytes)
+			goto no_quota;
+
 		if (!(flags & KEY_ALLOC_QUOTA_OVERRUN)) {
 			if (user->qnkeys + 1 > maxkeys ||
-			    user->qnbytes + quotalen > maxbytes ||
-			    user->qnbytes + quotalen < user->qnbytes)
+			    quotalen > maxbytes ||
+			    user->qnbytes > maxbytes - quotalen)
 				goto no_quota;
 		}
 
@@ -373,11 +381,16 @@ EXPORT_SYMBOL(key_alloc);
  */
 int key_payload_reserve(struct key *key, size_t datalen)
 {
-	int delta = (int)datalen - key->datalen;
+	int delta;
 	int ret = 0;
 
 	key_check(key);
 
+	if (datalen > INT_MAX)
+		return -EINVAL;
+
+	delta = (int)datalen - (int)key->datalen;
+
 	/* contemplate the quota adjustment */
 	if (delta != 0 && test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
 		unsigned maxbytes = uid_eq(key->user->uid, GLOBAL_ROOT_UID) ?
@@ -387,8 +400,10 @@ int key_payload_reserve(struct key *key, size_t datalen)
 		spin_lock_irqsave(&key->user->lock, flags);
 
 		if (delta > 0 &&
-		    (key->user->qnbytes + delta > maxbytes ||
-		     key->user->qnbytes + delta < key->user->qnbytes)) {
+		    (delta > INT_MAX - key->user->qnbytes ||
+		     delta > INT_MAX - key->quotalen ||
+		     delta > maxbytes ||
+		     key->user->qnbytes > maxbytes - delta)) {
 			ret = -EDQUOT;
 		}
 		else {
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5a5efa26ed0e..6b528faab1a7 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1014,10 +1014,11 @@ long keyctl_chown_key(key_serial_t id, uid_t user, gid_t group)
 				key_quota_root_maxbytes : key_quota_maxbytes;
 
 			spin_lock_irqsave(&newowner->lock, flags);
-			if (newowner->qnkeys + 1 > maxkeys ||
-			    newowner->qnbytes + key->quotalen > maxbytes ||
-			    newowner->qnbytes + key->quotalen <
-			    newowner->qnbytes)
+			if (newowner->qnkeys == INT_MAX ||
+			    newowner->qnkeys + 1 > maxkeys ||
+			    key->quotalen > INT_MAX - newowner->qnbytes ||
+			    key->quotalen > maxbytes ||
+			    newowner->qnbytes > maxbytes - key->quotalen)
 				goto quota_overrun;
 
 			newowner->qnkeys++;
-- 
2.47.3

