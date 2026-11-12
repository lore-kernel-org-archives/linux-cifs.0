Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509460;
	b=a655/+9Odl//J7vwZ+qHSKaMbvrs0RYZ13rOtSqLOvYyl5AFN9FzHuDaa0GCMawpExi4
	 VpwRRm1FqDC50RtlJUXov+7I34ARIjLkhiQeekPk5luF8HrYVJAtTZ/je6PEoon0hCAkZ
	 jZ1uwEHDRCA383mB1eL3JxyJAQU5J2yaYtuFQ3ITjEs0z4iShNN9L6C6ughA0XQenz2Sg
	 4UdHUwIdZ7ZULvPdnt6wVnN5mL9hX0QF/uc+m5gnzszcDR2yed6zeWNHY5iawrZGlQh9c
	 srGjmETBV5gpwIgYSSNeVa9HFlZDMOPf9HcYH0GDEtoxQqUcssLyfK3sDysEgTjfrEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2mIJe06tR2ADVRwfWCiA/uYE+uwyaywasdmh0M8dYA=;
	b=Fp0h4PCKdTl7DPoCida3huxYdlRNKwHacAZYc7cQUTvMGPrSykHiELJGC9yMaZwBiSHl
	 lDKEk64cw7KicSQqvlxmWO6eB9P1qpgqs08tKUlqrnh1YrU2eESzP5DsP/fyFlerXzPPv
	 FDRZlCyE8C9gSOi0oUgMOvEn/c/fRsxMO5D07dHeAb2uwPc3FuDJ+0keX0bIrg0gZZWiS
	 33ywI3pa+H7MNtXEFKX3kn0MCHIDr50HZ6+O/DZCMMoo0IbuI+iQ5iOtbtPxQTDiBy65s
	 XLLRAbPh6ZLZZ24X3FagiPtuFAAvaZ0bgbw9DOu8hH4tWAycq5Ul8ACxpFqmeSw4kew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UOFheoAM;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FB606A32E
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 886FB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UOFheoAM
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed0890476fso1186275ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509459; x=1795114259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u2mIJe06tR2ADVRwfWCiA/uYE+uwyaywasdmh0M8dYA=;
        b=UOFheoAM6XFVgIsQ1byqJmV3O7w8AcneqfODBw20g6UaQ1b7c0FDsx5HxIFqxtjDe2
         2YYgZI6q9lWhydbeZKsguQrPqcbRarwH0IoC1c+DrVkosdJ4qQAYBa1+gaTKWSnaWTik
         DWqL6dSE6sUtMMC/D/qLHZvPSaq9l6536FfRbepN/8lgx3XxMFGa3n92j/0C6m3V8lQD
         0jQkgN4ncb3+UElDXLkAE+zvYfSHFX03/8ripcCJ59qNI2M5xGAxY112n/W/K729p5VG
         t2wEd1DxaIMWwXLIU+fgovBJTaQHwakooMNt8YAj3Qh/9KkoLISSfOpUPc9QPNLewU45
         YD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509459; x=1795114259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u2mIJe06tR2ADVRwfWCiA/uYE+uwyaywasdmh0M8dYA=;
        b=i7+rrL/N4bsVyuDyYnYfDraVyrrS7hjUpUkSF04BbOn5huKwSrIUEoz+5n3JzBn+sx
         reZQ3Sh4PsoqAhx5ex6k+J/QTrkH3/B+OsYX7Ki8jusW3LrgCa2QyEZCp9HaLOxGWypI
         8f5Kk1GByJjIRrr1THMOAADW0tQwLtNe2aWarGuthCYPYV5boJfVSPk7/8AhANV8PsN/
         BOcazaLxhGkBaK/kM1oKAIB7zI0jaVCr3lQsx1xNiW2skP0lcWgKYY4KfaSQV16olaWS
         5GjpyH21CULakL014PzOKobI0cjW5vanIVok69IH45zK2JzTmEE7ZQu9D5tCS2s5Lxfd
         vq0w==
X-Forwarded-Encrypted: i=1; AL+hErFHqkcXy5tTI9cuDxZ6SKlkykbNVa/Z44aX16cdrlj6AOIpzEfd1uMTCs6i+vc8obR3stWUNmRlKyH8@vger.kernel.org
X-Gm-Message-State: APuU4Z/qiW6AUFrGfiE7g+2xiYcFx0uG841qm5wpxav0P19ooPOd9dK0
	W5WNJqLB+BlkedSnneCa5CgY4DE55B8bZo5+4jcxNSQ9l6zg8LSVUYyF
X-Gm-Gg: AYBFou3hyA7jcYO2mxIiYkXtbtKQ9n/NE9fZZbxhvaPuW3D1Ugsqxj+UExnL97GkCYP
	Bs6I9TpNZdrlx8naSsYpP1ZH7xt3fuloavoN0itKlJckv4ByhsfPTKPiMSNBch+kgZiCA7R03Ah
	/krrcUK9zpNLEtr1ldsZsKe9IS/qY662/sI33rXNg2xkkma9SdP68yiRV8LD67ffME0dzJabHCU
	cU99Fq1+6VGrrbfgSFoZ/iLGAAy5OF5iM6/c23eCAsM5Ob+mFngJs5Dah7yXBZlV2kIpAWDmZUO
	OxOGlXtWBH+CieAX3uttJnlSZk5qrZCzeBCoUnaVkX4QKFCTh7fzp29deOkLJE7+rWped9QAdqW
	rqrIke9d98cy39zFgcUuls7wMFrLN6FBOj+hDPRJFmcKi+PnlvjQlpfq1VuRVR3359mVUsthpQQ
	642ilK2kO3Z6IPqX2AM6BoH0hFM8igs8eWs/HElPfS4mg+iA7pjGWx18luQ6x1Ch35gIOLPcZRv
	I/PVc6GrQfJgvc0CKEFW8cOB/W4/GjQ0QkRsK1wzkER/L3Y/GW+kho0RLL/UsH9CfEVW5ci9n5P
	V5kN9aOxgz0yE9Z1+bnn+p6Dmb5GpYYNPsbiXWzbnLjfrEfbAbpBXrwhKs6tGGkJKJOUFDVZ/3d
	NAZk6e9jsQUPl9mTCw5UfbWJZMw==
X-Received: by 2002:a17:903:2409:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2ee0dd2ed39mr2800125ad.18.1794509458622;
        Thu, 12 Nov 2026 10:50:58 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.50.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:50:58 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: icb@fastmail.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	lsahlber@redhat.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 1/8] ksmbd: verify the signature of session binding requests
Date: Fri, 13 Nov 2026 01:50:37 +0700
Message-ID: <20261112185044.41571-2-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112185044.41571-1-mike.michalo@gmail.com>
References: <20261112185044.41571-1-mike.michalo@gmail.com>
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

When multichannel is enabled, smb2_sess_setup() accepts a binding
request on a new connection once it finds the session and sees
SMB2_FLAGS_SIGNED, but never checks the signature: SESSION_SETUP is
exempt from the generic check in __process_request(), because
work->sess is not set for it. The request then goes through
authentication, and the response is signed with the session's signing
key, since the request claims to be signed.

So anyone who knows a SessionId and ClientGUID can open a connection
and have the server sign STATUS_MORE_PROCESSING_REQUIRED responses with
another client's session key, each with a fresh NTLM challenge and at a
MessageId of their choice: a signing oracle.

MS-SMB2 3.3.5.2.4 requires the server to verify a binding request with
Session.SigningKey and to fail it with STATUS_ACCESS_DENIED if that
fails. It does so while receiving the message, before the checks of
3.3.5.5, so do it right after the check that the request is signed. The
failure response is not signed, because work->sess is only set once the
request has been accepted.

smb2_check_sign_req() and smb3_check_sign_req() zero the Signature
field in place to compute the MAC. Restore it in both before they
return, as generate_preauth_hash() later hashes the request as received
into the channel's SMB 3.1.1 preauth integrity hash.

A session that is still being set up has no signing key yet: the key is
all zeroes until authentication completes. Refuse a binding request for
it before verifying, in both binding branches, with the
STATUS_REQUEST_NOT_ACCEPTED that 3.3.5.5 gives for such a session
(3.3.5.2.4 would answer STATUS_NOT_SUPPORTED, as the key is NULL), so
that a request is never verified against a missing key. Set
SMB2_SESSION_VALID with smp_store_release() and read the state with
smp_load_acquire(), so that a session seen as valid has its key.

Read the state once for all the checks of the binding branch, so that
they agree. The signature check now sits between the check for a
session in setup and the one for an expired session, and a
reauthentication on another channel can move the session from expired
to in progress in between, so that neither check refused the request.

A guest or anonymous session has no real signing key either: ksmbd
derives it from an all-zero session key, so a binding request signed
with it proves nothing, and the other binding branch would sign its
refusal with it. Refuse a binding request for such a session before
verifying it, with the STATUS_NOT_SUPPORTED of 3.3.5.5, and do not
verify against its key in the other branch.

The other binding branch, which rejects a binding request that is not a
valid multichannel bind, verifies the signature as well. A missing
negation on the multichannel flag made that branch unreachable for an
SMB 3.x request when multichannel is disabled: such a request fell
through to the reauthentication path instead and was answered with an
unsigned STATUS_USER_SESSION_DELETED. Correct the condition so the
request is verified and rejected there. A binding request for a session
of the connection itself used to be processed on that path as a
reauthentication; it is now refused with STATUS_REQUEST_NOT_ACCEPTED as
well, which 3.3.5.5 gives for a binding request when the server is not
multichannel capable.

That branch signs its refusal of a verified request with the session's
key. An SMB 3.x connection binding to an SMB 2.x session now gets there
too, and the connection's own handler would sign with the SMB 3.x
signing key, which such a session does not have. Sign that response
with smb2_set_sign_rsp(), as is already done the other way round.

An AI assistant was used to draft the patch and as an independent
reviewer.

Reported-by: Ian Bridges <icb@fastmail.org>
Closes: https://lore.kernel.org/all/20261103171742.18816-1-icb@fastmail.org/
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c  |  9 ++++
 fs/smb/server/smb2pdu.c | 98 ++++++++++++++++++++++++++++++++---------
 2 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 064f99427ca6f..51aa981bcef4e 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -322,10 +322,19 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 		if (work->sess &&
 		    (work->sess->sign || smb3_11_final_sess_setup_resp(work) ||
 		     conn->ops->is_sign_req(work, command))) {
+			/*
+			 * A refused binding request is answered with the key
+			 * of the session, which can be of another dialect
+			 * family than this connection.
+			 */
 			if (command == SMB2_SESSION_SETUP_HE &&
 			    work->sess->dialect >= SMB30_PROT_ID &&
 			    conn->dialect < SMB30_PROT_ID)
 				smb3_set_sign_rsp(work);
+			else if (command == SMB2_SESSION_SETUP_HE &&
+				 work->sess->dialect < SMB30_PROT_ID &&
+				 conn->dialect >= SMB30_PROT_ID)
+				smb2_set_sign_rsp(work);
 			else
 				conn->ops->set_sign_rsp(work);
 		}
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5b046f10e2ce4..7ff001dd33bf9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2569,6 +2569,23 @@ static int krb5_authenticate(struct ksmbd_work *work,
 }
 #endif
 
+/*
+ * A binding request must be signed with the signing key of the session it
+ * binds to (MS-SMB2 3.3.5.2.4). Check it before the request is processed
+ * and before any response is signed with that key.
+ */
+static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
+					struct ksmbd_session *sess)
+{
+	struct ksmbd_session *prev_sess = work->sess;
+	int ret;
+
+	work->sess = sess;
+	ret = smb3_check_sign_req(work);
+	work->sess = prev_sess;
+	return ret;
+}
+
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -2619,6 +2636,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		   (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   req->Flags & SMB2_SESSION_REQ_FLAG_BINDING) {
 		u64 sess_id = le64_to_cpu(req->hdr.SessionId);
+		int state;
 
 		sess = ksmbd_session_lookup_slowpath(sess_id);
 		if (!sess) {
@@ -2646,23 +2664,50 @@ int smb2_sess_setup(struct ksmbd_work *work)
 				goto out_err;
 		}
 
+		/*
+		 * Read the state once: a reauthentication on another channel
+		 * can change it while this request is being checked. Pairs
+		 * with smp_store_release() in smb2_sess_setup().
+		 */
+		state = smp_load_acquire(&sess->state);
+
+		/*
+		 * A session that is still being set up has no signing key
+		 * yet, so there is nothing to verify a binding request with.
+		 */
+		if (state == SMB2_SESSION_IN_PROGRESS) {
+			rc = -EACCES;
+			goto out_err;
+		}
+
+		/*
+		 * Nor has a guest or anonymous session: its signing key is
+		 * derived from an all-zero session key. It cannot be bound
+		 * (MS-SMB2 3.3.5.5).
+		 */
+		if (user_guest(sess->user) || ksmbd_anonymous_user(sess->user)) {
+			rc = -EOPNOTSUPP;
+			goto out_err;
+		}
+
 		if (!(req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
 			rc = -EINVAL;
 			goto out_err;
 		}
 
+		/* As part of receiving the request (MS-SMB2 3.3.5.2.4) */
+		if (!smb2_check_binding_sign_req(work, sess)) {
+			rc = -EKEYREJECTED;
+			goto out_err;
+		}
+
 		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
 		}
 
-		if (sess->state == SMB2_SESSION_IN_PROGRESS) {
-			rc = -EACCES;
-			goto out_err;
-		}
-
-		if (sess->state == SMB2_SESSION_EXPIRED) {
+		if (state == SMB2_SESSION_EXPIRED) {
 			rc = -EFAULT;
 			goto out_err;
 		}
@@ -2679,28 +2724,30 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (user_guest(sess->user)) {
-			rc = -EOPNOTSUPP;
-			goto out_err;
-		}
-
 		conn->binding = true;
 	} else if ((conn->dialect < SMB30_PROT_ID ||
-		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
+		    !(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
 		if (sess) {
-			int sign_ret;
+			int sign_ret = 0;
 
 			work->sess = sess;
 			installed = true;
-			if (sess->dialect >= SMB30_PROT_ID)
-				sign_ret = smb3_check_sign_req(work);
-			else
-				sign_ret = smb2_check_sign_req(work);
-			if (sess->state != SMB2_SESSION_VALID ||
-			    !(req->hdr.Flags & SMB2_FLAGS_SIGNED) ||
-			    !sign_ret) {
+			/*
+			 * Only a valid session that is not a guest or anonymous
+			 * one has a signing key to check with
+			 */
+			if (smp_load_acquire(&sess->state) == SMB2_SESSION_VALID &&
+			    !user_guest(sess->user) &&
+			    !ksmbd_anonymous_user(sess->user) &&
+			    (req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
+				if (sess->dialect >= SMB30_PROT_ID)
+					sign_ret = smb3_check_sign_req(work);
+				else
+					sign_ret = smb2_check_sign_req(work);
+			}
+			if (!sign_ret) {
 				ksmbd_user_session_put(sess);
 				work->sess = NULL;
 				sess = NULL;
@@ -2939,7 +2986,12 @@ out_err:
 			destroy_previous_session(conn, sess->user, previous_session_id);
 		if (!ksmbd_conn_need_reconnect(conn)) {
 			ksmbd_conn_set_good(conn);
-			sess->state = SMB2_SESSION_VALID;
+			/*
+			 * The session's keys are generated by now. Pairs with
+			 * smp_load_acquire() where a binding request is
+			 * verified with them.
+			 */
+			smp_store_release(&sess->state, SMB2_SESSION_VALID);
 		}
 	}
 
@@ -12911,6 +12963,8 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 			    signature);
+	/* Restore the request as received, for the SMB 3.1.1 preauth hash */
+	memcpy(hdr->Signature, signature_req, SMB2_SIGNATURE_SIZE);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
@@ -13030,6 +13084,8 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
+	/* Restore the request as received, for the SMB 3.1.1 preauth hash */
+	memcpy(hdr->Signature, signature_req, SMB2_SIGNATURE_SIZE);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
-- 
2.43.0

