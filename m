Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453537;
	b=21GY8lRZYFGihcsLAIgblQO0fqxLtannmskzPc7+/wBYBy2fPtvSvXEGjPZ6mdpeGo7i
	 ZrLUIWps3hXnB7h0q8XaI15dPPLmnkYABqFuJQYAjrqfBhwdVK59loL2h2sK1SMSvNm+a
	 OAaN0bUWAaqT0JWmz+m0DD4mnvPJji+jrtEi2jhwVx1e8JJ7wuT3DQfu1Z3Xu5D8VLijc
	 0/aRCelym/5oYl0GuVeHRlhzIm/pakxZPjhtubtRUd5jl8i/8XVQy4M7ajt5tpD5rGsLa
	 I2q++ckeszLi/PY0mqQCa0g56Ro0KWr5crNCz10X7jAzp96IwZeNz/2OzfUHh37otiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453537;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DxliMSnYix7Z3B5F+OR+QQC2rRyWpstwzDNKYsrKqeQ=;
	b=y5070YKDJE85TmD+4ihEOBKIcmZEo3tTmQFZD4kJFU5tv5MLdZn41Q7xw8HOVLRmyuSx
	 5utdOtROpgWE8dctK/rbuiC8Z6CwYabMY7HzS7kolHWEmBSjzOr9Semv6X+XyhswkbkjC
	 6W+FrD2x9XwJ2VfKDKTfVRTNczzKInLfHSu8Is4E2l3ZU1EWyZL2cHIzew2ePgU39AHRz
	 u5+I+qlFkeUQ8lMILGgS7iyCTsVuazeJxPnVlaeRxbOHON7OB2xe99ea9k7147a2y9LFv
	 CatXuxv1ni4AXA1U2Ah7tmjEzundvv7VKI0OW06a3M/IDNQE8yjotQn7FMAZZq/kLJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=m5GNyJMh;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WXu2Vwq8;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18307606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 03:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18307606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=m5GNyJMh;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WXu2Vwq8
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 44C3DEC01E5
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 22:18:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 11 Nov 2026 22:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794453535; x=1794539935; bh=DxliMSnYix7Z3B5F+OR+Q
	QC2rRyWpstwzDNKYsrKqeQ=; b=m5GNyJMhPgIM8yeNH5v/iVq+mZwbbUCFhrGtU
	2h55snlKKrSG7IJYzUCaLnWbFpHMYaGBfMcHmvn9Q5ZHFm0kG9kbPw0o8xCcA+A8
	pC5eOknZhIqMyxiNNRoyzIR3AreRxp+/I3xJgf6u+s6HBvXveAtpeC4emsny238V
	fFVdVK1TXt5wJfReaPYNRS6UJ9bKrhI5Lxzl4CJV9Qu21phjfu5VgC5LM61cQJEY
	Bmttzp5WvbhQhDnm1RaWJaI1atpQbYBz5IpS8KzE+3dMhyGoW73EeTtoPALIMhPh
	8mbyHqNGkJjCVYtcUYDEz5s1/fLoxbNXLOo/wKaS1MIKcRMEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794453535; x=1794539935; bh=DxliMSnYix7Z3B5F+OR+QQC2rRyWpstwzDN
	KYsrKqeQ=; b=WXu2Vwq8ZzhZRNneZrwxHsXmjQzgy0X0F7FbgpnZzc031cTr5S/
	NC9xebigYIZfqFS8Eb4Wjz5vLwCSP45uSCc4rNWccr5Q0MhC4g0fNOZRb1CcOWSX
	jONhjch+VS/pYUNUxUETWjxWR8d+zIbd04mFYmJUhBO9FskKfBu9AFe1Y3VryjWZ
	CPGmaeIrNJ6kt6EBYtgX0Q2fbuSCZjCJT2WT1uA246N9UxFwyHkqshSm0P1Ud80P
	Wzm6wLBGOjDj+0fIJlfqHZD11von/HNqWk/NTH3NG7pw17kxhqO/wiup9VHIxnzi
	7vWsA7ok/yXa6TKZJG0fXSMsMigp2pm+9hQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794453535; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:elnnS/aFRsDmuSfbE7o/39OIZpkZcFUOcw+uK6cPddsuin5
	usmV9K2dKMGTlVQsUb/cmGIkb0AIs5EI0Bo3xbf3GZzr+D2+0G+JD9C1VjZjx6QH
	2J6AtYrxGYHq2yqaRuZJA5FEZ47It3NDOfTQjh1ICWmbBOloqgntbiAqCyBiUAu0
	6kkJNVVP2T/Jx3oMnGSK61edv8XoGLGAngRVgCHHDPAonVijmYiKkGgFf3ATOVvB
	9v5zcNoGqZQ2H2B+GfzDeN2q6IkvbD0UHPJX5z0BgIHkWyybEzVKrMFjvYY9BmbU
	1fAhn/BJAzC5iZbRQ4PoZTbbs2Enfo1ZHFGVkfw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:mBg91KtQ9BBe9REXzqGnhXIThVoS/89eW2C6JXOphV0=:wADtaVpL+lPYE1sB30apHbsnl4wJDhhYpBrF3zecc/4=;
X-ME-Sender: <xms:HzD1alNPSyEaCZ9vVqDuAPxMmaTGCr7MGwOtD6gyh5q42jqdn-KzVQ>
    <xme:HzD1aoYOewINih3hhrg2pWtskYrxUQXEWl-OT7L7n8AO8h7wY5mPD-8TF1quY8HyU
    nInABpqcpcmXUYBQe1udM8FqF4Eb052jxD32hQFoXLFCPkagZTV2OSc>
X-ME-Received: <xmr:HzD1ak-PAP5si52d9Snxx008YHxnZeqtJQmRxgWonW6fEkKCRBUs9cPH3ZNeqfhD>
X-ME-Proxy-Cause: dmFkZTF1gV8HNpSkgXQ7XXCwAd1i43qIIL91rRT+fSkE1WTDEBeIcw4LaFVdFoP34cTivk
    V8OgB0rNje/fgYYNvihmcPMbY1CNmAkzTg2oQqFoO3nZR6saPkYT8R3ar1q/yi9iyraLrV
    hxGOTDHfGvcW5L1PBJEPCUY/RbEpD0LHUQrUwajlTiXElx6rUZ9IjOmoUkHST+RU8iBvUq
    qFplITDw4zucgst2ggJUJOJpu0IWBC6ix0NshKkac5j4PR1pTCmol82UT/ztgB4eJXFKRY
    dSDoN74Kr8g5ziPVg6tOyywPi41JTdsbhiCTY+IG7D6tGjkdL2NwWytVbzUnzxn2PGnBfV
    k+KE1fYNCcOv6LvFEdPBytJkrWalSg5Ldn1I8rKmo/kAEvegq+wFhHBtL92UHpOSj5FaQb
    f3AEhA7iqNjv68k2QWkpDuA4lF8PTl4wRhXhAcNhRscEzi6gGzuHx2haXovFbWk2Xlh51r
    tOFnGLXMNr+WVrvktXe/eUYRG0kFe2QMclr2lkNQqE0alW9mX35NaJf7aKeYglPFskgDb9
    q3tkSoS72jSo+DjtTj1WTa1EF4pdyv73R9+B6eZEaBnPtLsGIjEBl+yPm+50vvnXsj/Xib
    fk5JNq1QeuM3BDnlrzK5F9Jd6lU2qMOxjXKYef1HqwIv+3x8/9Hs73cEtoIQ
X-ME-Proxy: <xmx:HzD1apTlnb04gMh0Z2V_b8MTDLuB8xwaVXxMf55ov-ZxstALYZGxuA>
    <xmx:HzD1aufwkwj8ny_Zzslxj2fjpIoDs37pbWfnNwHy6ISFDG9CjK-ncg>
    <xmx:HzD1arQd1ijYq3aJVq07Q2WGEKm1odFvj3INElzrF4iZZoJ78uOK7Q>
    <xmx:HzD1aqI16JdIambvgQnF9swmBKVoxdFl0LCAeFNmp7-21jMEulFRvg>
    <xmx:HzD1arJmapLqAYWyZnlmjbpNVDk0qAk7b6LZHwYD9_2HROIID3QH7L-T>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 22:18:54 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix out-of-bounds read in expired-session LOCK check
Date: Wed, 11 Nov 2026 21:18:50 -0600
Message-ID: <20261112031850.712949-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

smb2_session_expired_cmd_allowed() runs from smb2_check_user_session()
before ksmbd_smb2_check_message() has validated the request. For a LOCK
on an expired Kerberos session it scans the lock elements, using the
unvalidated NextCommand field as the command length. A malformed request
makes it read past the request buffer.

  BUG: KASAN: slab-out-of-bounds in smb2_session_expired_cmd_allowed+0x260/0x2a0 [ksmbd]
  Call Trace:
   smb2_session_expired_cmd_allowed+0x260/0x2a0 [ksmbd]
   smb2_check_user_session+0x4ff/0x680 [ksmbd]
   handle_ksmbd_work+0x465/0x1cb0 [ksmbd]

Decide whether a command may run on an expired session from the command
alone. Move the unlock-only rule for LOCK into smb2_lock(), which runs
after the request has been validated. An expired session can still
release byte-range locks but cannot take new ones, as before.

A LOCK on an expired session now goes through the normal request checks
before smb2_lock() sees it, as CLOSE and LOGOFF already do. A malformed
one is rejected by those checks instead of returning
STATUS_NETWORK_SESSION_EXPIRED.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs an authenticated client whose Kerberos session has
    expired. The client then sends a malformed LOCK request.

    A reproducer is available on request.

    This fix was developed with LLM assistance.

    Tested under KASAN on a kernel whose fs/smb/server matches
    ksmbd-for-next ffde0bdfc69a. No Kerberos KDC was available, so
    session expiry was forced with a temporary hook in
    smb2_session_kerberos_expired() that is not part of this patch.
    Expiry of a real Kerberos ticket was not tested. With the hook, the
    malformed LOCK reads out of bounds before the patch and not after
    it. On an expired session an unlock still succeeds and releases the
    lock, and a new lock still returns STATUS_NETWORK_SESSION_EXPIRED,
    also inside a compound. READ is still refused, and CLOSE and LOGOFF
    still succeed. smbtorture gives the same results as on the base.

 fs/smb/server/smb2pdu.c | 57 +++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 92843d2944e4..ec87118e50b1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1014,39 +1014,15 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	return 0;
 }
 
-static bool smb2_session_expired_cmd_allowed(struct ksmbd_work *work,
-					      unsigned int cmd)
+/*
+ * MS-SMB2 3.3.5.2.9 lets LOGOFF, CLOSE and LOCK proceed on an expired
+ * session. CANCEL is allowed too. For LOCK, smb2_lock() allows only
+ * unlocks, after the request has been validated.
+ */
+static bool smb2_session_expired_cmd_allowed(unsigned int cmd)
 {
-	struct smb2_lock_req *req;
-	unsigned int len, lock_count, i;
-
-	if (cmd == SMB2_CANCEL_HE || cmd == SMB2_CLOSE_HE ||
-	    cmd == SMB2_LOGOFF_HE)
-		return true;
-	if (cmd != SMB2_LOCK_HE)
-		return false;
-
-	req = ksmbd_req_buf_next(work);
-	if (req->hdr.NextCommand)
-		len = le32_to_cpu(req->hdr.NextCommand);
-	else {
-		len = get_rfc1002_len(work->request_buf);
-		if (len < work->next_smb2_rcv_hdr_off)
-			return false;
-		len -= work->next_smb2_rcv_hdr_off;
-	}
-
-	lock_count = le16_to_cpu(req->LockCount);
-	if (!lock_count || len < offsetof(struct smb2_lock_req, locks) ||
-	    lock_count > (len - offsetof(struct smb2_lock_req, locks)) /
-			 sizeof(struct smb2_lock_element))
-		return false;
-
-	for (i = 0; i < lock_count; i++) {
-		if (le32_to_cpu(req->locks[i].Flags) != SMB2_LOCKFLAG_UNLOCK)
-			return false;
-	}
-	return true;
+	return cmd == SMB2_CANCEL_HE || cmd == SMB2_CLOSE_HE ||
+	       cmd == SMB2_LOGOFF_HE || cmd == SMB2_LOCK_HE;
 }
 
 static bool smb2_session_kerberos_expired(struct ksmbd_session *sess)
@@ -1124,7 +1100,7 @@ int smb2_check_user_session(struct ksmbd_work *work)
 			pr_err("compound request on a non-valid session (state %d)\n",
 					work->sess->state);
 			if (smb2_session_kerberos_expired(work->sess) &&
-			    smb2_session_expired_cmd_allowed(work, cmd))
+			    smb2_session_expired_cmd_allowed(cmd))
 				return 1;
 			return smb2_session_kerberos_expired(work->sess) ?
 				-EKEYEXPIRED : -EINVAL;
@@ -1136,7 +1112,7 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	work->sess = ksmbd_session_lookup_all_states(conn, sess_id);
 	if (work->sess) {
 		if (smb2_session_kerberos_expired(work->sess)) {
-			return smb2_session_expired_cmd_allowed(work, cmd) ?
+			return smb2_session_expired_cmd_allowed(cmd) ?
 				1 : -EKEYEXPIRED;
 		}
 		if (work->sess->state != SMB2_SESSION_VALID) {
@@ -10881,6 +10857,19 @@ int smb2_lock(struct ksmbd_work *work)
 	if (smb2_compound_has_failed(work, &rsp->hdr))
 		return -EACCES;
 
+	/* An expired session may release byte-range locks, not take them. */
+	if (work->sess && smb2_session_kerberos_expired(work->sess)) {
+		lock_count = le16_to_cpu(req->LockCount);
+		for (i = 0; i < lock_count; i++) {
+			if (le32_to_cpu(req->locks[i].Flags) !=
+			    SMB2_LOCKFLAG_UNLOCK) {
+				rsp->hdr.Status = STATUS_NETWORK_SESSION_EXPIRED;
+				err = -EKEYEXPIRED;
+				goto out2;
+			}
+		}
+	}
+
 	if (work->next_smb2_rcv_hdr_off &&
 	    !has_file_id(req->VolatileFileId)) {
 		ksmbd_debug(SMB, "Compound request set FID = %llu\n",

base-commit: ffde0bdfc69a0f01a081d9c1a213e63d5719e625
-- 
2.47.3

