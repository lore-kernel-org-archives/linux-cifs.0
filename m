Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498167;
	b=cIRfZWTHxawSNLUYdcv0u3M2YRYSUyJWUaSdkXM/FUnkYL8LI+b8zuDrG1/Qw8CJw5r4
	 2lvApalWvJxRX0ofbn0F9SsbdYjbeGmVORe+fZVq9PHgMZyQzbKcnS4z+1iG8GI9KQhBl
	 hYQXzabGPdwLwgQ6scmfMrezzmT8nTwj/7sTsHK1ROsYXwlFHTnwQUyL+0bWG1FK0K85Q
	 IbhOvhMPAE+BEFUxGHyEVMwESIxVgVtUNnvTeRHijpKoJMwtRNChLUN+8Bn1/1FKyc0qY
	 QT211rw1V+gf4t7Vc0CWuX3Fm7pa85VvznZlhhWlNcD1qY5FixUytDyIK61ikzzz7NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498167;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmrDW5oxPDCT6kNIjHKrqyE0Mun040k//ijsfC3fuC4=;
	b=KofHK7uc0zhd6PuMmPyELReLyeKLA8nMqYsnylgt6EmNcMeca9VhwuuBfqD+ln9jhnF/
	 fu3ip4ympIKXqn78YzHUGvVdja5JGXYEmNhvGChxRUtMB77kzBh6NQC7IvCE2UdNbBCLC
	 YmDXovS+fyVfTJfGYhISd42/CyxizKax0Z1Bc5bjgEAmYGhVl4SApKaPotnY3rPIfNdtG
	 3x7OgianCCIyQ9vmBgfWq9ypXQNVGSRwVwHppohPQRErJw0hoqcNXr0kpIAruRSk16XhE
	 r5Os1vMz0N2R3aPWD1FZJAXMqXJ9MWLpvmH8L0aeJzXmpGXIBBZ6xyRFMIlmSHd7h1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NGJJyN8T;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD038606A884
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD038606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NGJJyN8T
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a60f90a924so1918851b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498166; x=1795102966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmrDW5oxPDCT6kNIjHKrqyE0Mun040k//ijsfC3fuC4=;
        b=NGJJyN8TLSDamU3rlphuj3kbaO7HtRQ+QACITfzPw2oi0pUl6jR6URruPdxiTnB37+
         BJ7R33Md8sNrKXt4PgmVq1Py7w15J2125Cf+GOqvXBOdZjySYIS5rbQgvt4nGhNujzPR
         NW2UQTbHqSyfpyoYsqQhY62cXrhe03fm00X6evuTsI+8Xw1ns6AIENVTiHshu0TlXz9k
         oruS63smbKmK8JB4nWI0mbEq8INxrXczDIBLN2qvJovvz2XvGbyQ2ovQBZvMbc01KR/y
         dJVUdeKEpLBVyOn21YRVJ+Sma3Ti3eVF6qv0c4/WCNercGcVCTNvbBVWzJy7/o5LkO9b
         4RjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498166; x=1795102966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmrDW5oxPDCT6kNIjHKrqyE0Mun040k//ijsfC3fuC4=;
        b=P0GP2sSJ8lCWBZ3sKBDhtiG3Z6lthpfJ/IEOPogfjdTrIKcGI6Df7OYiRF/T8QNdGw
         6WIchSekVvQiZuBcw4aQq3VsHZcD0YzN+hGxvDsDgSZXojFCLP6q7TE1Yw1zf10+xDKK
         0ZE1eSKQ4Wzc7NGobvhfllDg6QuSnQ3SLqCcTP5/+BjJGww8LYC8OjKmz4LTmvGxk0Vs
         Rb7F4WdkBDhaVrVEoUfFeUC+o5l54wudaG/xpZwHp1OCPwkjuqeb/jSAjfoHfhQmWBH8
         XeUGPP84sraAoGkQ8Rm8llKoUPEl4yDQ0ArAFvxruFdTq1/3SY84T3rWsq2ugITAbcFV
         M6GA==
X-Forwarded-Encrypted: i=1; AL+hErHrGwxjz9upM0FVJdu7JtTHFkYbpyu+4QZ2XpclQUu0UD6gX0kIU0FZm8Q7yxQkMUHtSQeEqF/EVkUp@vger.kernel.org
X-Gm-Message-State: APuU4Z+lYwEdvgkzCW2N8NYNGvTuy2/LCClbAuUkzcXkNEay1GZkTpAu
	ueuhhck+4FsvexxvdWShVGN45iI8Kj6KalFAkr3f4yALzRslOnv7ol1R
X-Gm-Gg: AYBFou17mgchoh6Vfe2x8I3us96TO/7cBYTfCjNaBCLNZvJZcyk5rHqdL02YyrYskfr
	yDbf3+Ur1FGDFvY1/C0JzQQz2NOj+joHg5ISKT1jjsjb+2Es5rXd31MJVGF/jgxzNYvPRZwggrB
	PVaj1YnF9CD3MSd5UqnoE4i0khxY/Cudyb/fz94A1GrPqJ2qVzJWK1PD5tx3dgRh/Qr15brG3rG
	l2MKTAdb2TKh/9W/okVGqsq+EykZ+EiYOT1g36rEMJPj6zJSkSQnn6yyHkAem8q5GEtIefnJ8Ms
	5PnNPa03ufJTmhsKXp2As3HWcSkwBFwiQJx7nSG98Q5ZiscVfIuxUExUV67awrk0wvBcH3A/4ej
	Vdt7k+RT8mqN/eGVeC3KXD09JXiwfn51WnD45xjEFzwHVosKBaUYVNr36rzopp13EYmR/aIzbdE
	3y0ucqCvDa3XVun71mQ3LpcmpP3pAyOpqIUuWY84x77GLpHraxweW5h/81GTwvklelp+wW7A02W
	hfG0TpkRaGXX193DZGWdyM9e6G4IDqifJV5knGY7aMhRJIZFT5DAxMJRhb0/riIblwjWH40lGCD
	Ps0+zNw0/umnsqySoqcqHCHn2uPAKfOTFVI7YjLSHqy0HFSDzSwlYOAPiiGJurjrb+jz7kZUn+G
	T1oGXSzEm9CDTq2K9UDE8jJbZwptt2Y2KL//teJriC+NgFJ1S
X-Received: by 2002:a05:6a00:9087:b0:87d:430:1437 with SMTP id d2e1a72fcca58-8bc1def0ad5mr5929164b3a.38.1794498166048;
        Thu, 12 Nov 2026 07:42:46 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:45 -0800 (PST)
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
Subject: [PATCH v6 8/8] ksmbd: account for the credits of a request on a failed session
Date: Thu, 12 Nov 2026 22:41:55 +0700
Message-ID: <20261112154155.20255-9-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112154155.20255-1-mike.michalo@gmail.com>
References: <20261112154155.20255-1-mike.michalo@gmail.com>
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

A request on an unknown, invalid or expired session is answered by
__handle_ksmbd_work() without reaching the code that calls
smb2_set_rsp_credits(). Its credit charge is never taken off
conn->total_credits, and the response grants no credits.

The client has spent those credits all the same. Each such request
leaves ksmbd's count of the client's credits too high by its charge,
which reduces what later responses can grant, and a client that keeps
getting these errors runs out of credits. Since the command sequence
window was added in commit fd8c97d7c1cc ("ksmbd: implement the command
sequence window"), this also ends the connection: after NEGOTIATE, the
second request that names an unknown session is already outside the
window. A client whose session has expired loses a credit with every
request, until it can no longer send the SESSION_SETUP that would
reauthenticate it.

MS-SMB2 has the server consume a credit for every request but CANCEL
(3.3.4.1.2) and put the credits it grants in an error response as in
any other (3.3.4.4). Charge the request's credits and grant the ones it
asks for, as for a request on a valid session, before the response is
signed, except for an SMB2 CANCEL, which consumes no credit. This
response ends the work, so it reports the credits granted for the whole
compound, also when it answers a CANCEL that follows commands that were
granted credits.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 52eee04e0d93a..e91e3a1459e5c 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -132,6 +132,41 @@ static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
 		conn->ops->set_sign_rsp(work);
 }
 
+/*
+ * Charge the credits of a request that is answered without going through
+ * __process_request(), and grant the ones it asked for. This response ends
+ * the work, so it carries the credits granted for the whole compound.
+ */
+static int ksmbd_set_failed_rsp_credits(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+	struct smb2_hdr *rsp_hdr;
+	int rc;
+
+	if (!conn->ops->set_rsp_credits)
+		return 0;
+
+	/*
+	 * An SMB2 CANCEL consumes no credit (MS-SMB2 3.3.4.1.2), but its
+	 * response may still end a compound whose earlier commands were
+	 * granted credits.
+	 */
+	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE) {
+		spin_lock(&conn->credits_lock);
+		rc = conn->ops->set_rsp_credits(work);
+		spin_unlock(&conn->credits_lock);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (work->next_smb2_rcv_hdr_off)
+		rsp_hdr = ksmbd_resp_buf_next(work);
+	else
+		rsp_hdr = ksmbd_resp_buf_curr(work);
+	rsp_hdr->CreditRequest = cpu_to_le16(work->credits_granted);
+	return 0;
+}
+
 #define SERVER_HANDLER_CONTINUE		0
 #define SERVER_HANDLER_ABORT		1
 
@@ -300,6 +335,17 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 				else
 					conn->ops->set_rsp_status(work,
 						STATUS_USER_SESSION_DELETED);
+				/*
+				 * The request has used its credits, so charge
+				 * them and grant new ones in this response, as
+				 * for a request on a valid session, and before
+				 * the response is signed.
+				 */
+				if (ksmbd_set_failed_rsp_credits(work)) {
+					conn->ops->set_rsp_status(work,
+						STATUS_INVALID_PARAMETER);
+					goto send;
+				}
 				if (conn->ops->is_sign_req(work, conn->ops->get_cmd_val(work))) {
 					struct smb2_hdr *rsp_hdr;
 
-- 
2.43.0

