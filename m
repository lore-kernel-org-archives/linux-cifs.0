Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758498;
	b=IHkGNR0jMsc/XL1nPq1PMQ8PSA++1h9FEd+IOMR+uTYIQzghrWP0QQfPhC74qGfO+O+Y
	 MvNmnNw3tH0atZsseInoWYyR2aneECbmXORw/l9B4IMj+KTH0ZLUu5R0CfoscqdQKnrBA
	 DZTK7PgUFlB6FkO+EmK5q6xtwprRbWTA25tHl61bZ/jaQqVtU+rtbvS19idJ4OHYLIths
	 to/rw2lM1Wc3KaDd0EsD2k8syNtJFKjRQfGJOE7x7+q1SD543Ra433304WB+aPRqSza7y
	 5UdOsVpxZMsTdeuLoavcLLhUKpzDC+ZNW8X2EZNILcL3G4007Gr6u+IOEtB2BeXxUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zUW3Juk3Hv6ps05jq02d6vrsuj33+so61Tv4SlB/J4w=;
	b=4/uAi97ygKbKodPklNFyh954eCC11XPxSEQP3FIqqdjAxCuilBASNmU5w2OFFdFsm92s
	 PX1xdfJRWliCohhZ/b0/F3MBKd4d/87Xa7sjoPdukuJvA6NUc8+jHp4mwKSDgA6t5UrLZ
	 nKqzELzcjcc2msuJo95UsR7w5D6k5gJa7xAcK5DsgIXw3m2nRbwgu8lYGpitW7luPYqIK
	 F14DSwNQYz+KLW+mjfaldqCuZoGQEBdh5UySNVD/zWxgMFdUd8MJxp56P5Q2a6kldnUBq
	 slcfuqYllLw0WCdVqeq0E/xQIwOGDustCl0+2VF5LkIr/8GduGMrxoemduP6UEm+HOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJTs4yR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 055CF606A31B;
	Fri, 23 Oct 2026 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJTs4yR7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 50B0A1F01828;
	Fri, 23 Oct 2026 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792758497;
	bh=zUW3Juk3Hv6ps05jq02d6vrsuj33+so61Tv4SlB/J4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJTs4yR77oNxlIeDarm7ZYFqHGMjM6njRL20Rb6g5oyO0eFFFaTYvgNpkfWYWiU5l
	 ScVkHXcShqV2Q8/tn9UR1TBuFTwXs3Sb6dmA8yqW2YOzwp83R3MAeQTB8cL+kCG4Jf
	 wfKAs5Iete4G7b6syjMM8/FPMaJIUmoRK6Ec081YZgqKxDZ3GcDcqaP4f/OxWWyeu8
	 dZdC6aiBX0oj8UZG9Ant3u6J9dyGi9G/6439qJuZoiq81giKFxoZh+OeZo1zY6viFo
	 CVd/E/SHqhNuZN+GrC8eMG6uTV8woIryNgk0+SCVTHF5p9PVhfyjVvq0Z32yhYNHM1
	 heoT57kP8HPvQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-cifs@vger.kernel.org (open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/6] KEYS: Expand key->{datalen,quotalen} to unsigned int
Date: Fri, 23 Oct 2026 15:09:21 +0300
Message-ID: <20261023120953.1206778-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023120953.1206778-1-jarkko@kernel.org>
References: <20261023120953.1206778-1-jarkko@kernel.org>
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
Assisted-by: LLM
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

