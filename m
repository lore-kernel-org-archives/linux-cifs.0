Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301320;
	b=2GuZEeR58G/BoDCgEpbRr1vtIL/XHj/cz543mZPsWB960+urzkqzxHY3kxX20HCHDM0a
	 UU0SqC7wGkJQvz1/oHLVLh/elBMqmz+os/uPfGhxRkPPB3AOvxjzTXUqpaP/pgsmD7UQZ
	 0rsoxsJLUYLSt6POc+00bE++G4vyEX9lolCesvk4NgLT3ExMYf5tLxDJ2HKdS8AR1d1TT
	 8Se/uDmmOMsAxpjluuYXAtuNfMZwZkfZGahPUuQ35QF71bGI5KH8Uzhux3axM0YgH56hf
	 TJfVyEu6R0qFf4p8mZtK1ydenNI41dN+DB7KbgGXFW5XDM301CheC046/J4RnmwnVyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301320;
	h=DMARC-Filter:DKIM-Signature:X-Virus-Scanned:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Pe8NsLN7WqTqkzXTXDhASnGwHTGgkud8CSCPEuEBpxM=;
	b=XF32VGUW3h0ll/aruZhS/NJg0WQ480E4oMfCmVLY7cbmIZcaG0glmDNMHHpzcVXQlP/h
	 w9M8PeTEtPZ89elc+AeP22KrJj3ERyJV4lVQOifMvBXd8RaLBipAX3joxPcM2Yz3KfK5z
	 oMYLayHSCa9D2/FD+yrhvlu/bJcJ7huxPqMPPYRIJqdj1jaelOoq4Pouilz4dEnPjeZN5
	 LfC3U2JbaK8rsGnWnWCZudEi+zV4BJ8tsBUYQoaYfmstwHBy3aEpvuF5jSQlqG1JeA4pK
	 iUVbACQHt4xww+rP2Vm1q2hmZqUIP/cL6u99SkTuBz3Xr4A1UBnBwj86EisetfGruCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=pass smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=Ol19HMJ5;
	arc=none smtp.remote-ip=173.212.254.19
Received: from proxyplus-primary (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624860A261D;
	Tue, 10 Nov 2026 09:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9624860A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=Ol19HMJ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxist.de; s=201705; h=from:to:subject:date:message-id; bh=Pe8NsLN7WqTqkzXTXDhASnGwHTGgkud8CSCPEuEBpxM=; b=Ol19HMJ5gAbod5AH57grOXEHHdLQeAJqt64a4/6JMhvrFDdnnEWtHM9znVAzSCl7Cvdl10RqPxqz4bL5BnluH9CuC7YiX6N7kGpQt4r9bDl+axSduYHrXRFjrwJ4s6aPLQeSq7Z9eA9FILRW5/kWTOeUv9Sb0Umsx4kEDt9MdMht22/aqFqfG10936Dj58wTIkICrGTPpc3198/YKFYqxxDETO6uDZA5yNTqDP+lSyZoK2A82ypj2G3f8wahokSLuwUd3m0nxrQGrgu/nRzDSbVCTuLo6dCo9bQEpze/78sTwgQTu7ry9U2GFMfIdbctmqsjukF8nMh2debhIxw26w==
Authentication-Results: proxyplus-primary; auth=pass smtp.auth=713ee033-d4f8-4c9d-9e24-a891eb9c547d
X-Virus-Scanned: proxyplus-clamav builtin
Received: from groupi2 ([10.1.2.46]) by proxyplus-primary (ProxyPlus) with ESMTPSA; Tue, 10 Nov 2026 09:01:29 +0000
From: Jan Koester <jan.koester@tuxist.de>
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, brauner@kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/6] ksmbd: show classic users as S-1-22-1-<uid> on every server
Date: Tue, 10 Nov 2026 09:02:52 +0000
Message-ID: <f30f64394434b17ac1347afb@groupi3>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

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
