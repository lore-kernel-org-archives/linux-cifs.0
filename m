Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168414;
	b=UjsgtLO+BiNOw/OESGPnxsjRvrdbx+3CMjL8hCThlBCP8XOGtEcjK27JJrJFuWCmuH+i
	 ANxSqpZ2LQ6f3xWwl8NLQWArASEtUvn6r2LjCWfh2asx5q7QMLOcsMXKulDF4a25/zhoK
	 OMu+53eayx8Uw/J/Cov1VQ5azCTwdL7qxl7z+mgljXbzw8kQcVbzqjXbhe4xp/1WUjLYM
	 +JSUx2yNksI6IQQA9bzcJZztRHoeipO7IupgEK4A9Cj+V/vHwfeLHuhjJWGTmitESza7S
	 D0QzMQNnLhP2tskDyEQt8Eb3M2cRr3huhNr2K7Szb6AYZHb3VCi6KlQJuh6/ltp//hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168414;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:In-Reply-To:
	 References:From:Subject:To:Cc:Date;
	bh=Pe8NsLN7WqTqkzXTXDhASnGwHTGgkud8CSCPEuEBpxM=;
	b=srUqkVZp9jxhQILp+i76TQR+nEXtIyTt8zUcd7QrJUgejANz1eqZIZmovZ0n5zCXO6Sz
	 WX6aKfWyVlHqn/Xp5d9dGR/mvtIv1GbRTWUhjV8vhCP3ML1/6/cS0PtiBKhiYQLC2Ou2K
	 Fp0GtrR3Onc4WIXKlsKTkfNbOTgSrZYyJDPdkv6aVnnlDl86OgStIA8xW73bc2CWmsv0C
	 uxNqqENxMV+NAbX4wfVnyw3nL97TPTQfl9DhHHzEk0mf0H/VXwO9tF1oS/o+Zzl/msPVG
	 KojgmS826mn15zu6vK03F9aC0biS/oXUpIz3SfKV97oCAmMUvMis4O0GDZI3Yu2RqjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=Ffpl+a64;
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712D5606A335;
	Wed, 28 Oct 2026 06:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 712D5606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=Ffpl+a64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168411; bh=BTX43lVHdo2xP3iJWvF0vPPoN1NsaK6nTKd5dLe/cLE=;
	h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
	b=Ffpl+a64zbzFSf4qNZ/Rvmk3j1X3ssk+v11VgD4tcpfHiuF9MVZCXtoAILYV1HEMx
	 kxKCf10cUlhmstOaUprxzCK9hTofV/dDacdxGaSsgoa3dygl/2aX5WSFuTAvMcDLze
	 jdnENu/9LJzDtIQ5cM86Zxi3ADGwiRkFNXKwVev7mhRUHL3IPpmG8a023bqHywJgRw
	 PkSujlLIYewPcmC6H0lzozD/NuVwDUU/F29eQxbpOfGvS/2Bo1OXScB2c6wsgG3kYv
	 hcK5ZVy+dyTaXvtjG3oizIcTZId0UAmWdzyYpOtMvqll4A8BpQCzS0PC85g245N3ZM
	 PMVuzj8kF0K/g==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id 9E1E68A098B;
	Wed, 28 Oct 2026 07:20:11 +0100 (CET)
Message-ID: <078b688dd8fe49011c99d8c76abfaef3bf5d9a97.1793168155.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1793168155.git.jan.koester@tuxist.de>
References: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 5/6] ksmbd: show classic users as S-1-22-1-<uid> on every
 server
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:20:02 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

A classic uid appeared in security descriptors as the server's own
domain SID + uid. That domain SID comes from user space and differs from
server to server (ksmbd-tools and sharedd derive it per machine), so
the same owner had a different SID on every file server, and the RID
looked like a domain account's.

Show them as S-1-22-1-<uid>, the SID ksmbd already used for root and
that S-1-22-2-<gid> pairs with for groups. Keep taking the old form when
a client sets it, and keep it in the session's SIDs, so descriptors
stored before still match.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/smbacl.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d6be65e3a9..769864d64e 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -300,14 +300,16 @@ static u32 sid_to_id_r(const struct smb_sid *psid, u8 *id)
 }
 
 /*
- * The SID ksmbd itself gives an id: a classic one the usual SIDs, a UUID
- * or GUID S-1-22-<kind>-w0-w1-w2-w3.
+ * The SID ksmbd itself gives an id: a classic uid S-1-22-1-<uid>, the same
+ * on every server (it used to be the server's own domain SID + uid), a
+ * classic gid S-1-22-2-<gid>, a UUID or GUID S-1-22-<kind>-w0-w1-w2-w3.
  */
 static void native_uid_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid)
 {
-	if (uid_is_legacy(uid) || sidtype == SIDCREATOR_OWNER ||
-	    sidtype == SIDCREATOR_GROUP)
+	if (sidtype == SIDCREATOR_OWNER || sidtype == SIDCREATOR_GROUP)
 		id_to_sid(from_kuid_munged(&init_user_ns, uid), sidtype, ssid);
+	else if (uid_is_legacy(uid))
+		id_to_sid(from_kuid_munged(&init_user_ns, uid), SIDUNIX_USER, ssid);
 	else if (uid.type == KID_UUID)
 		id_r_to_sid(SID_UNIX_UUID_USER, uid.uuid.b, ssid);
 	else
@@ -373,13 +375,14 @@ static bool sid_equal(const struct smb_sid *a, const struct smb_sid *b)
 /*
  * The SIDs a user's ACL entries may name, like a Windows access token: the
  * user's and its groups', each the account's own SID (if user space maps
- * one) and ksmbd's. Built at login; a
+ * one) and ksmbd's -- for a classic uid also the server's domain SID + uid
+ * of older ksmbd, which stored descriptors may hold. Built at login; a
  * mapping user space couldn't give then is missing for the session (its
  * ACL entries don't match: access is denied, not granted).
  */
 void ksmbd_user_set_token(struct ksmbd_user *user)
 {
-	int i, n = 0, max = 2 + 2 * (user->ngroups + 1);
+	int i, n = 0, max = 3 + 2 * (user->ngroups + 1);
 	struct smb_sid *sids;
 
 	sids = kcalloc(max, sizeof(*sids), KSMBD_DEFAULT_GFP);
@@ -388,6 +391,9 @@ void ksmbd_user_set_token(struct ksmbd_user *user)
 	if (!mapped_uid_sid(user->kuid, &sids[n]))
 		n++;
 	native_uid_sid(user->kuid, SIDOWNER, &sids[n++]);
+	if (uid_is_legacy(user->kuid) && !uid_eq(user->kuid, GLOBAL_ROOT_UID))
+		id_to_sid(from_kuid_munged(&init_user_ns, user->kuid), SIDOWNER,
+			  &sids[n++]);
 	for (i = -1; i < user->ngroups; i++) {
 		kgid_t gid = i < 0 ? user->kgid : user->sgid[i];
 
@@ -519,8 +525,15 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		kuid_t uid;
 		uid_t id;
 
-		/* Only the server domain RID has a local uid representation. */
-		sid_prefix = &server_conf.domain_sid;
+		/*
+		 * A local uid: S-1-22-1-<uid>, or the server's domain SID +
+		 * uid that ksmbd used to show (stored descriptors have it).
+		 */
+		if (psid->num_subauth == sid_unix_users.num_subauth + 1 &&
+		    !compare_sids(psid, &sid_unix_users))
+			sid_prefix = &sid_unix_users;
+		else
+			sid_prefix = &server_conf.domain_sid;
 		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
 		    compare_sids(psid, sid_prefix))
 			return -EINVAL;
-- 
2.56.0

