Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705722;
	b=Lfala6tSAMHgsi09hNSAMrAGIdgg2e3M6tz3oytzM7rHQwyK07LcvuVChL+fJA8StTvz
	 BBf0paVWOuhEFtwWLYlEN8Qh/ZOlLAmRpI9i8fOccS+AnnfTMYgFSBDqyktb4jvd0kVgC
	 433Jy4uxLiPVQS4fmjIi/0zauYtX76rZtGblviBrXYtXanYjFMH1GyOALmSvcrZFgvAM6
	 dtJaupTroGvpPTpP+cR1g6in0ivcf4lO/1VMTmX+U5V0zFmRjkxeSup96rG2aIKQpY+sf
	 J4KyxpcEQZ4samVn53SX2pU5xrZeXhhqOLlE5u1aS6+dCh2mbkUPO4d1jhtAnVKiy5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705722;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SlZNHBeRR2gP54BVQKHWrSOw18MC7MJC4aN/iKNxdGg=;
	b=DudD8QeUSMSkYa6idO9WEZQRCHJlVkfw/wDtS3x1G1vobfcNu5JKBgQGL9phHW6tLG0Y
	 +tr6bTsxxjtcpPAuaDkpoU84mmcB5OKNCVb6x93bFtxkSp5eL1L7ptJU2ZFTbFrWqBjuX
	 mk6f+ZRqnkObE8hoO9enRmyfS09SEoz1OC/Z9Y1p8MsBxIav/fmJ8A7wwhZMyWzGmKzAP
	 s/9R0uhxAidelGXHmbm8+1Likli1us74pVJz8+IoR9wBIQunId2mCZvUS+F0/oxszccW5
	 RsJu8RHBJUapOVvrIqmpxuSCXrDe/sp31Rt7ISHUkQ0MxvxGD66sk9arQdzebda8lTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=D+vfgNUy;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B5A606A323
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75B5A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=D+vfgNUy
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so72877885e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 07:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795705721; x=1796310521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SlZNHBeRR2gP54BVQKHWrSOw18MC7MJC4aN/iKNxdGg=;
        b=D+vfgNUyyJUSVX02qRO5LKjL5cwIhc7dqeRUn9WZz/k5KYrDGIUKkPYFMejdZM2BK1
         r5Cq2/da39n+tDoFQ3hUjwU4uaQ+jDzINmHZnPI8/fVdTNUJj2XQlRg/VimqZkoLbYP4
         /QWYQZeSk/RD3r40TSonU57Vx0CUPJdLvWWyjydGzTCOn9pVnuP7t7JIw8JkJcft5kce
         UMQ4bygoh41QOWDQL8qTEmNjmkZpdNNqjJHqOC3YMvPTx3BnpnUoi3n4esbDRoJxbjIW
         u1p29AXRvoBOV/2SuLYI1g+lfIAxD410jKut5rfL8mJGdCyM32a5aEJdNhvKRRqx1h8W
         MBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705721; x=1796310521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SlZNHBeRR2gP54BVQKHWrSOw18MC7MJC4aN/iKNxdGg=;
        b=J4tOcaRcoBJXh4cN6CVXamMN5uJ9ATxeCyKCRMquGqBv3YvDxYC2aI+uszQnPSz3L1
         mLJSTYZqPOUBidz1VQiKIunPA7PYF87+LjqQvRpWUDaON5KfYqqishTkSgqpa9/LYpgB
         8MmGJO0c4/WaOgZELY0fW45FZoPAQ3HnmUE4AMDKKQPDss913NOT+UMOqYK3MME5YugN
         KhCHNbkV13BwZN6U9vhtHPPBB4djnNgRuVmb6Vll/ndAkcJ/0eZK4FZj6uMS66VB6dww
         m/0wwSKOyvn+i9Dr77Gfb+NcpZal5qr784muiih3XjkQMn1IbN/Asa2IxcuZTHk26DDV
         1G+w==
X-Forwarded-Encrypted: i=1; AL+hErH6sfjpiTV/3H7jCHkz2OeF57RyTh+1EoX4165xB8NZbouJEGA/G2K3uDstsbcG4So4Swi8tLxzAl0/@vger.kernel.org
X-Gm-Message-State: APuU4Z++2Y62XMVcni6kMfI25adhccIG5k465txa8K1LuxFc+KuCiFEp
	Q1ld6QfJRc05gh2uCzUnod2rdJ22XgxUPTkT2/iMHQ1H1QajtSX8lRzJP0v4ypor/4TOScsC1vu
	Kn1WZqgPE
X-Gm-Gg: AZFdTZefz2lXB5p/LFnil4YTg4e2JqmiQAHT1yZQydNf9FsezCqTRhe3HNjRtPHHKCL
	p7tWcpI1KYEj25fs/BfhU1nMbp5WJRfv0tYINIxJnBwBgSUc9tpEegDyW2EfkJGKOZpIPUFujdX
	CXBwcpngJhV8YAWNHx4hQsekk6fQnVsZ5ILulorDNNehxOX/G6K0mQ0kMdNkS6d73hZkkfuOqS6
	Lf3KT1sAGU5IL0FitTCQiuXeaPlgh3XE3O8wcWQY/K6dRgcxJIPqId0gpo9DRRIIZV+OjK8Q7bF
	76HSwLEmmsccOqBDvgNPccUHoxl1xQhYOJGpba15++nf9SOZfrAoKL3XyxK+gS9aBZZg5ktSUov
	XQnY7cqUwC3dBM021TypYYjsAwJ4Ezn77KIOyM0Ta8+Q3lIi+kSAbi2xdVe1i2Rx0tPpvyp3vCb
	v0fBFPVODgxSI/D9QtIIN6Fv1uhSl56oQgPxiB3QnTGwYQmdbzJpm7AOICv5Gj8eDonvt6sOwqw
	ZAWG7gIFrCw9Z5DN12j+HIG6IjheKPvhFSGwV0ivTgoYHFv+mBecvRvDjcF2c0Hi4u/i4DIcsMf
	0lm/hPMgU5/X/I8057nsBXQslUOp3RxiFN128pJ+ASiCRFE3d/Cd00FGWSVFHnHPHOzC
X-Received: by 2002:a05:600c:1115:b0:4bb:a602:6c8b with SMTP id 5b1f17b1804b1-4bba60271damr80493015e9.14.1795705720826;
        Thu, 26 Nov 2026 07:08:40 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm599850045e9.5.2026.11.26.07.08.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 07:08:40 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Ian Bridges <icb@fastmail.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	RootSys GmbH Research <research@rootsys.at>
Subject: [PATCH v2 3/4] ksmbd: reject plaintext requests on sessions that must be encrypted
Date: Thu, 26 Nov 2026 16:08:35 +0100
Message-ID: <f2f8d65edd82bfe84b80335ef0992e7726af3d7b.1795701726.git.research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1795701726.git.research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at> <cover.1795701726.git.research@rootsys.at>
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

From: RootSys GmbH Research <research@rootsys.at>

With "smb3 encryption = mandatory" ksmbd sets
SMB2_SESSION_FLAG_ENCRYPT_DATA in the SESSION_SETUP response of every
session that negotiated a cipher, so the client encrypts all further
requests. Nothing on the request path checks this, though: a plaintext
request on such a session is executed like an encrypted one. Since
sess->sign is cleared for these sessions, it does not even have to be
signed. The only encryption check on the request path is the one for
shares carrying KSMBD_SHARE_FLAG_ENCRYPT_DATA.

An attacker on the path can therefore inject plaintext, unsigned
requests into a session that both sides believe to be encrypted.
MS-SMB2 3.3.5.2.9 requires the server to fail such a request with
STATUS_ACCESS_DENIED.

Record in the session that it was told to encrypt and refuse
unencrypted requests on it with STATUS_ACCESS_DENIED where the session
is verified, before the tree connect is looked up, in the order of
MS-SMB2 3.3.5.2.9. SESSION_SETUP is left to smb2_sess_setup(), which
checks the session it reauthenticates, and an ECHO without a SessionId
is not verified (3.3.5.17). A plaintext SMB2 CANCEL on such a session
is dropped without a response: MS-SMB2 3.3.5.16 never answers a CANCEL
and verifies the session as in 3.3.5.2.9 only for a signed one.

The response to a reauthentication did not carry
SMB2_SESSION_FLAG_ENCRYPT_DATA; set it there too, as 3.3.5.5.3
requires, so that a client that takes its session flags from that
response keeps encrypting.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/server.c            | 33 ++++++++++++++++++++++++++++++-
 fs/smb/server/smb2pdu.c           | 14 +++++++++++--
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 423f0a10315a..81960f3334b6 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -62,6 +62,8 @@ struct ksmbd_session {
 	/* signing was required at setup; sign is cleared with encryption */
 	bool				sign_required;
 	bool				enc;
+	/* the session was told to encrypt (SMB2_SESSION_FLAG_ENCRYPT_DATA) */
+	bool				enc_required;
 	bool				tearing_down;
 
 	int				state;
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5d94a3683f7f..8d1ad6495e35 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -245,6 +245,22 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	return SERVER_HANDLER_CONTINUE;
 }
 
+/*
+ * MS-SMB2 3.3.5.2.9: a session that must encrypt takes no plaintext request.
+ * SESSION_SETUP checks its own session in smb2_sess_setup(), and an ECHO
+ * without a SessionId is not verified (3.3.5.17).
+ */
+static bool ksmbd_plaintext_refused(struct ksmbd_work *work, u16 cmd)
+{
+	struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
+
+	if (!work->sess || !work->sess->enc_required || work->encrypted)
+		return false;
+	if (cmd == SMB2_SESSION_SETUP_HE)
+		return false;
+	return cmd != SMB2_ECHO_HE || le64_to_cpu(hdr->SessionId);
+}
+
 static void __handle_ksmbd_work(struct ksmbd_work *work,
 				struct ksmbd_conn *conn)
 {
@@ -371,7 +387,22 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 						rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
 				}
 				goto send;
-			} else if (rc > 0) {
+			}
+			/*
+			 * Before the tree connect is looked up, so that a
+			 * plaintext request learns nothing about its TreeId.
+			 * A CANCEL is never answered (MS-SMB2 3.3.5.16).
+			 */
+			command = conn->ops->get_cmd_val(work);
+			if (ksmbd_plaintext_refused(work, command)) {
+				if (command == SMB2_CANCEL_HE)
+					work->send_no_response = 1;
+				else
+					conn->ops->set_rsp_status(work,
+						STATUS_ACCESS_DENIED);
+				goto send;
+			}
+			if (rc > 0) {
 				rc = conn->ops->get_ksmbd_tcon(work);
 				if (rc < 0) {
 					if (rc == -EINVAL)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5a7842264b98..a133437b94ab 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2419,8 +2419,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
-		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION) {
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+			sess->enc_required = true;
+		}
 		/*
 		 * signing is disable if encryption is enable
 		 * on this session
@@ -2525,8 +2527,10 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		conn->ops->generate_encryptionkey(conn, sess);
 		sess->enc = true;
-		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION) {
 			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+			sess->enc_required = true;
+		}
 		sess->sign = false;
 	}
 
@@ -3052,6 +3056,12 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	}
 
 	if (authenticated) {
+		/*
+		 * MS-SMB2 3.3.5.5.3: the response to a reauthentication tells
+		 * the client to keep encrypting, too.
+		 */
+		if (sess->enc_required && !work->session_setup_binding)
+			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		/*
 		 * Draining the previous session drops srv_mutex. Finish using the
 		 * connection's authentication state and free mechToken first, and
-- 
2.43.0

