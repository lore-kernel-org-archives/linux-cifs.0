Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329935;
	b=dxmlVwDC9IRGBS65w3ThgrmcHGqIuOVPzsSakhkFKn0EeUu/qwTU41m9p2SPGwiTLAI5
	 PGVttkOYZQwW+CKEFugVsI/RGK1sBxiSrMg7BT2WzCbHxaaxW6jwuedMfrrKqkskYCt2E
	 nx/Ya0KKtbdouKMZuvg9jf31lteX5n7fOkjASrnoLbtMWHyyKVGFIaehNMjIRST7KSC6d
	 JnmFNxnhMOroMDqtiqfzx1TeEV2remfN1oorFZyOCHo3nuTySaak/XbBmRnEMzAGhhjOt
	 s7BR+U4d5ANNP6zvMaYhOI9n+F0ZzzLst135539Z5laG8tzrdglIBLd6L5wHv+F4y9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGmjhpqgPuXABcOPakX/g3GsnUA5UpZR8hxGr7WdBrU=;
	b=NX+LZuCi16GTZ5GNUfMG2jv+A8FjquPnqSdZT/HNyhnCTUcKCFqDeccmgDQJkue5Dci9
	 AAKcv1qsNslASQ8r0LLAI+U71vLpUpOocZUzwCqIksG9TNPt4jkkcEjxkMcVdryOQVm56
	 PYVdHE6JzcrU9Z4YAhI1XaLppXD1j5SOy0lWGN+tnSh11gHkzWaxbupdavez2lp8JX0DQ
	 i6BArI6YI2SYmFqraJhVi+1wFfdeDDWLB6tE4LgSBcRg6mBbqJzAbnUcDbtPQSHwdCSSw
	 b5xqSVdU0rB3ovoXUZJEFy98jWR0I1nZ4TjFMObT96sWMNM15zqvHS7aovDejde2zcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PB8T5I5E;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C698606A80A
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C698606A80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PB8T5I5E
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so1625531b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329934; x=1794934734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cGmjhpqgPuXABcOPakX/g3GsnUA5UpZR8hxGr7WdBrU=;
        b=PB8T5I5EjGz0Oxzx4XGEh/kLtXi37ShAQFX1EeMTVSR6GJf/VQGSiKTQE/tuAfnvCw
         ownVd71Ft1BPWF/aWHfSgOMI44nLwYqq5h3EMi21sBA8uxauVSs8HNZD5WSTtZV+NNyB
         0M59SFYCbK5zz6KRlBJqYsOQwWVccn36VW8PL7p1KNevOuJAm6tSHkrz2WbRH8eNngkU
         Cl5V8AEhAbR8k0vz+atXSG1wSyO2L1TzZRvL7h9VXd6eO36C/rRzNaNaYaeqpJHNsTUV
         5g8Fz+IAhSTFSj22rQN4w4iu2FFLQcJcuIYoTyBAQLyDUmIIAVsTsl8PjXSPk8fABTVM
         bBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329934; x=1794934734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cGmjhpqgPuXABcOPakX/g3GsnUA5UpZR8hxGr7WdBrU=;
        b=2ARbTuqOwCT7zQjhAr+7yVKS8n3Xolv6eiJc44BMhUK7dVKbTl3fRJ+VljBuQSnZv6
         UR/SHBUeH0BpDOEg4BBy5w2geZo4fPOA7jkg5DbJcYRC9mGu9a6b9ksm2AGTpL6iSKUi
         8ST5+BlE4heC3+eyloip1Tm/8mLHQ139nRaTxprKhGTOQxR8ijqiUsls1PjgMV+CrIlA
         VVYBc5X+UdDU4rxJLl5OEIX7ho6/+kGmqHn7zukaGwsaCK03oqetn4lpu7A6AWJ8k8gO
         rUkYzGOtmQSiUKaoxcXv3KdB5MLIjlR0T/LDwmskh6uiCzKFeufOLweYDzueDWxwntgw
         8WvA==
X-Forwarded-Encrypted: i=1; AL+hErGqr2pVH3xhAt/5mDk+Lr6y5nHQZDoUZ4OILwG0zq/9KFcpQopA4PVid6hniidZ4obVK607sOOQ92BY@vger.kernel.org
X-Gm-Message-State: APuU4Z9tT2FXj6oU3U575Zq1M2383Rjfj2gCyuaHzvK4X5vKzdtKzWfL
	ZDKY3NhvXE+Vwoc7ETcxBNzLCqUnenLyio6gtt3IrmuKeBrpRwFCk1pQYEStROVW8lFavLEp
X-Gm-Gg: AYBFou2XGCaUyFT0qiot46G5pn1RZ52sDKDHWuwOMyu7y4YsJEMZiY4+U1ZzMY0vNRp
	gbwkP6EcXhBRxLCP9jbrN2RhAjDL5144oUro8Me+OpOGoWCDLs95FfTTxbKEr3HrQNSM2ZZKU3g
	HeUe1kZSQuBXPHvV0IWk5oRQ3WEo2YNOw53xYjty42WyOtcH9BqwGFKGWgQeDp140ZzcfYvbt9j
	pIB29tsmKkVr3IJgh4UI3qk8bScJhTMb0v9p7e9enW/wdaOC2YjqrGIC2jTStVXY4PQA5GpQtM/
	suUp2oo9iNx78fPMf/32prelh5ZFj7awdtZRAkKxMmKHqQpfREhpwSP9teGxhWqMRCl9aAn5+RV
	NXMk7TY+rHcRpertgmToQEkEEGYD5DrDWAJupYak+qnoMK2XiuqJdIvwYJaFB/QhS8l1vMnPIHd
	dS844rl2cIlga7bTm5J3i9Zux00MSC1dwjQYIIE1g9V0HUWEgpZDH4wRRj8K0Zjjf6AxTfkLN+8
	EIxr01S4dudRHJZnOFaTUM0obCgM69qxyo7F6kOQVYbOXwc0ykNdwY9BXdtCILcqwHmJ7Y5cMz9
	7TeAWzbE8bDugomozXfApHQ/GKRE0gAExhvoad4O5vIJ7Nbxaypg8GsDDSsMyydSEL+F31MKRFh
	at/JWxiaAcIfOm4a5UpgYZ1iXemf8zog4SYwQqKjAxWKytDUykI1Hdb8=
X-Received: by 2002:a05:6a00:2e2a:b0:8a0:5d6f:8a9d with SMTP id d2e1a72fcca58-8ba89d27effmr3247039b3a.35.1794329934301;
        Tue, 10 Nov 2026 08:58:54 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.58.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:58:51 -0800 (PST)
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
Subject: [PATCH v4 1/6] ksmbd: verify the signature of session binding requests
Date: Tue, 10 Nov 2026 23:58:29 +0700
Message-ID: <20261110165834.28162-2-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110165834.28162-1-mike.michalo@gmail.com>
References: <20261110165834.28162-1-mike.michalo@gmail.com>
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
MessageId of their choice. With AES-CMAC this is a signing oracle. With
AES-GMAC the nonce is the MessageId, so it also lets two different
messages be authenticated under the same key and nonce, which reveals
the GHASH key and allows forging signatures for that session.

MS-SMB2 3.3.5.2.4 requires the server to verify a binding request with
Session.SigningKey and to fail it with STATUS_ACCESS_DENIED if that
fails. Do so before the request is processed further. The failure
response is not signed, because work->sess is only set once the
request has been accepted.

smb2_check_sign_req() and smb3_check_sign_req() zero the Signature
field in place to compute the MAC. Restore it in both before they
return, as generate_preauth_hash() later hashes the request as received
into the channel's SMB 3.1.1 preauth integrity hash.

The other binding branch, which rejects a binding request that is not a
valid multichannel bind, verifies the signature as well. A missing
negation on the multichannel flag made that branch unreachable for an
SMB 3.x request when multichannel is disabled: such a request fell
through to the reauthentication path instead and was answered with an
unsigned STATUS_USER_SESSION_DELETED. Correct the condition so the
request is verified and rejected there.

An AI assistant was used to draft the patch and as an independent
reviewer.

Reported-by: Ian Bridges <icb@fastmail.org>
Closes: https://lore.kernel.org/all/20261103171742.18816-1-icb@fastmail.org/
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca8813cc..053f3eb398f5a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2558,6 +2558,24 @@ static int krb5_authenticate(struct ksmbd_work *work,
 }
 #endif
 
+/*
+ * A binding request must be signed with the signing key of the session it
+ * binds to (MS-SMB2 3.3.5.2.4). Check it before the request is processed
+ * and before any response is signed with that key.
+ */
+static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
+					struct smb2_hdr *hdr,
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
@@ -2640,6 +2658,11 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		if (!smb2_check_binding_sign_req(work, &req->hdr, sess)) {
+			rc = -EKEYREJECTED;
+			goto out_err;
+		}
+
 		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
@@ -2675,7 +2698,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		conn->binding = true;
 	} else if ((conn->dialect < SMB30_PROT_ID ||
-		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
+		    !(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
 		if (sess) {
@@ -12853,6 +12876,8 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 
 	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 			    signature);
+	/* Restore the request as received, for the SMB 3.1.1 preauth hash */
+	memcpy(hdr->Signature, signature_req, SMB2_SIGNATURE_SIZE);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
@@ -12972,6 +12997,8 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_len = len;
 
 	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
+	/* Restore the request as received, for the SMB 3.1.1 preauth hash */
+	memcpy(hdr->Signature, signature_req, SMB2_SIGNATURE_SIZE);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
-- 
2.43.0

