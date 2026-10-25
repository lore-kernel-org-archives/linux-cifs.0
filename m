Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887114;
	b=P990m3ZJ8Ps4jhzdHQaQ3l2V1kaCxg6aBEiaqz+PhRnt2BkeAZ23etYzbUEbDtIqOfEK
	 fT3TMlgn2ngEkQh51qrzct5pw9z0vFzJXT5P4ofSDNDayg3Z0qBFBSjdCi5XqsVlfawSQ
	 XKb1cyRYLrJ/1O2/6BuBqzI/oBtC7hSBKEfctasOCivWxBaG0V754QIxvQDkengyZQgQB
	 +yKWCJY/U4Q/hNWYvJkbehbBT1WjUPtYNNfK+1Enydoo1/jpX5vhb8QkVHX1GPHAK/jyX
	 AJwGYe4ZYB5vBpzV7aLI6aBeBhMbNlUaHmKoIC/yixPQTIq2gq2bJARQ3sczENfzoqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ixYsrcS47Q6Me2TtjEpHNH50KI+aO9TZVihgf9TNOE0=;
	b=qz9AhD0OO8QKndl3cUqiOzaluq21WKzi3Eib9SnZI9pzq7zCtbdR/dWKwVw8QKN/2/rR
	 gEw6kfDijNGZaZjkeLxfkUg040zpAlOLEzeP/6e24o04Ac6JCErP14PRIRyDBP3Psq8HP
	 8m6nVVUmMg22bn+SFtMPc+ny+X2kBOTNY89aj1jARb1xOUz9L/+suD6WZFS5BZVcBcB7h
	 OSm/oa8TeDvCbjNGT+pnYdaLyQC2nHjAoJggAfCf+G98Lc6PNEbo+a1WV40rE1Jn6vMM5
	 UFpG39Y/vU2zQ07C3lne/JWsNMAP1wzATKA0EX2KNFS6lOSSnwy0g8gBwFp3ijwNlfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TjI6A4f3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 77E31606A31A;
	Sun, 25 Oct 2026 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TjI6A4f3
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4862C1F01825;
	Sun, 25 Oct 2026 00:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887114;
	bh=ixYsrcS47Q6Me2TtjEpHNH50KI+aO9TZVihgf9TNOE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjI6A4f3KtclIMBaINOmlusAfhZNSinL6uIb/vUhH7/q+470s8Kw/0gO1qxBqv9H6
	 YSfD2DM8duHlZpbzOkrrW4hNiF9qCe0wrN0GdyS7UXJJ7cIj5wVpTT7JcuOsJN/F6R
	 ijqJ1ORFWgt5aVdEpwZUaaelqYairNCXhFKidz113W/qxXyMS/YBwCPfzpKYiYBasJ
	 P/HNpWlylnQ3WDKKUPcMuhEraO6xmZ2LY1hRzMOFJPtqEj3PD5ICJzjC87R6qizyAC
	 8Z71mzLf3cePv87hUzQ0rIHOAn1Nb6lgBKRRlUXTQ66ZDU3Dp81sSfX4pz/uU/87ty
	 nta80/ssS68vA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-cifs@vger.kernel.org (open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	linux-kernel@vger.kernel.org (open list),
	linux-crypto@vger.kernel.org (open list:RHASHTABLE)
Subject: [PATCH v3 1/6] KEYS: Expand key->{datalen,quotalen} to unsigned int
Date: Sun, 25 Oct 2026 03:10:09 +0300
Message-ID: <20261025001105.1824178-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025001105.1824178-1-jarkko@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In key_alloc() and key_payload_reserve(), key->quotalen and key->datalen
can receive values larger than USHRT_MAX.

Example:

  keyctl new_session >/dev/null
  owner=$(keyctl newring owner @s)
  keeper=$(keyctl newring keeper @s)

  for ((i=0; i<16384; i++)); do
      key=$(keyctl add user "k$i" x "$keeper")
      keyctl link "$key" "$owner"
  done

  awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users
  keyctl clear "$owner"
  awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users

Because key->datalen wraps around 65535, the quota refunded upon clearing
is truncated, causing quota bytes to leak in /proc/key-users.

Change the types of key->datalen and key->quotalen from unsigned short to
unsigned int so that they can carry the full payload length without
truncation.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-2-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/smb/client/cifsacl.c | 6 +++---
 include/linux/key.h     | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index d1a92bb4d9a5..e7f7ccf2a158 100644
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
-- 
2.47.3

