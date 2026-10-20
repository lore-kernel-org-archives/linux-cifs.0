Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518235;
	b=MJ6FupHQ8OPghN95m66kXHQwkJQHQV1O2QiJHG+R4ahOrAOG9La5v9gDoV0K8vHwVkLf
	 rkziB+fiJq2wa4JvrbBwUp+8DBOk2ao4AHty9FwSDMb985/VC5ZXS2nuH0wNjPfmuiuiB
	 PD68GXidRQhO49aul3xCNWa4NnbT23og/4HML8a05n39jXMI4U18Lm/b+pFNkVfwkneZK
	 Vfh85xpgcO0mkDaBhaJuMSozQm06K0XepLdUWMCi5U6ODxAGyc1EIdm7pYKfPZiEA5mAG
	 Eah1p4jvSMk8gTxijPDaMcGfk1ZH5OTQut3GmqIoSz4TvnKBcRwam9utdDfbC7eiMew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518235;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=TlN3mE3/c48832czriQe1Idk0ezZ/r65jKH/VR/24qY=;
	b=SwKMOgSyLyoKkjkQwff1eOP1CMgckyjWkAYFuG4A8+mIuh71g/2Lpz0hH5mCZ3LooRnn
	 ssUTVQv+TJ1EWAC0y334uuBIWS3TwLpgc6hRxhdc2RVk1UJeu+Yo78V6qWPie8ZViQnyd
	 lFUqAMcKHyg+9QoCxCSa6htQtej83BbIdRTSAeDjDHomkuPYf7o09dvUammQfUeoP3Ubq
	 4PvJewUVFdFMXM2Ppzu8aP6mpkPcugjCkwlTpqLgC5I7eqoFlcai0QJGl0ODXOwTB2zaN
	 hNa0zEWOsnqH1CR46AysozHo8iUzltdq41MYM53x1bL+UqwD+xTXw/vpF2a0cAwpuxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 32BF9606A31A;
	Tue, 20 Oct 2026 17:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F7E21F000CA;
	Tue, 20 Oct 2026 17:43:54 +0000 (UTC)
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.org,
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
Subject: [PATCH v4 1/3] KEYS: Expand key->{datalen,quotalen} to unsigned int
Date: Tue, 20 Oct 2026 20:43:19 +0300
Message-ID: <20261020174325.2229448-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020174325.2229448-1-jarkko@kernel.org>
References: <20261020174325.2229448-1-jarkko@kernel.org>
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
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/smb/client/cifsacl.c | 6 +++---
 include/linux/key.h     | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

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
-- 
2.47.3

