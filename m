Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509494;
	b=3hOe+1PBbFmz2azi7vi847aABNwPEaq0OJLYKp5gGw1fLCklyw5eSQ6qIGEmhCSdioJd
	 Nqf99xUTV1YHQ0MUo3eKzeV7pnlZxHuiduAD6+ZSLlNJiTW8rJ+nU9zHCg2LD0OFh2uih
	 qR6uax/FVSIyuxLsmAjP4azBow+insQrNYE6PZHmK1o9peeIADf23PbS7/JpxAil6ArKa
	 +L9/ypFgMa07In0/Tyj+DmSUQdJI6tj5UbSHReHY2SoynI0Ih5DbbiLWQSX7j3NoIzME0
	 es5kCQKYdAT3vgUx+NVbHo7rkCTVA8fQk+eI5OoPWrk2wWhs43CICWjU6Lp7mHmLWgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509494;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwpBy7aCuNryqK7ChK2jdyNQZwtIbInwf3mrciB/5/w=;
	b=ke2zFoHNfMM1rrmwZIVnI0SMD+7mM+5xsDvQd2btIqLqewpZpk75dByBAk0XWwGkqMdD
	 cXuvzk3s+F8ZGZxPKU4JO3+ubxfQHjcxS0B2yqdn3191XarwkyGwkzpbTqBAkGEMUHgmP
	 b4dBCKoSECGlgr7R/j4HhAmXcv2tAx1rAFwcZz66PPfKWOnAWmUfppk1pc/i3V0vhpmRQ
	 GjUgdRWKd/HlAGPR2rgWPnevNzdMr2jPmpjNQZ4xOp9RnmQqqwJtTErHcCGm+EMEfPYdF
	 +wPANUv1ApBiS8TtnkAR+RMn65C15mcUKWYy6KkGxKZJ2/qkMpQsVYMa+W2uKDC3YiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b6c1WIWF;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC160A263D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04BC160A263D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b6c1WIWF
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ed408b0d9dso876215ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509493; x=1795114293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KwpBy7aCuNryqK7ChK2jdyNQZwtIbInwf3mrciB/5/w=;
        b=b6c1WIWFkfrbHfv7IJO+yPunQkHlxgc905Dencs8hBqMr/Cm2e+LasD30H9PFiJQQy
         YXUWpBn2rOyqihmweriC2yQgSBJkFtVOoRio4/HxQDPSbeya0RJk2KhkBjBB+WNtOr1h
         Q3Bzbr2pwDZBA6hblBDx5Bt1F5gWccqEHs1utM5sGN/s7EsjHlEWzT+YmHLwSD0affFM
         WoO2KsJS436CJtSI8P815XQVR1rD6F3d2A8RD1vknPkvAtrHTRoP0ixS6MHTefTWMETj
         w1PbJCBD4C4USz8my4r2FTSITnlKD30OpyYeG2HHOVlJgrfMkxJsvieo+0asFZBv6JXq
         /F9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509493; x=1795114293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KwpBy7aCuNryqK7ChK2jdyNQZwtIbInwf3mrciB/5/w=;
        b=sw39AK85FvuZoZqRfl6T6FDYqbG76kUkF4dTQubhdDbyp6ZwoQE2DLIxvaR2qB0nwf
         p0yyeOIK4XdY9iAYBtGLBOgOsCJhLWhtxvcCOeUS2pHlPxGXP4LxY8piDH+4Erh/+JE4
         yuQ4BVh+URwIcPgeZSPr3vHeupo6Zg3ZT/OCIw0e7XqAnP1kpvrPAIUXJ/Cnv/T08mt6
         6ORS0k1BMjCrPc+v8U+JUjk3gsW3eIqN41m0KPsZxrGkgHZRmxx7pMT5zweKDXVoGm8j
         +iG481nz0T+/6/vsAqig10cs3uPxvEnKPgPg9Va09QABLDhzfouaQRWfim7+nPkELOrh
         Yj4w==
X-Forwarded-Encrypted: i=1; AL+hErF0UKK3U4XDdqfMvII+iS6MjGXrjMc1Vtj3kY1K0HgXURZ1nJui0KcBTRU+hHetGi/fdChXZ3tzFv5E@vger.kernel.org
X-Gm-Message-State: APuU4Z9dEQyuOEvfft0CP2iB0LszB3fdSvqGeFR8oIhELXYymifBHLox
	5iiCw1l6dksUzP+v0W+xlWl0WmS3tcSF/eh8sDJ4b8EExKqTMf4sKJvv
X-Gm-Gg: AYBFou35pfu1o7woOLGWonnYXqO4jqyKPj57NY+mi1W3nxArBsn7CDLf6owRqm6mL6E
	Ka3XTuCkztS+/Y6tUZbFgEGEuvXniDnUc+twCCAUS1jKTOwycy+dC0cQZnl0RrNaGRqfFKjv2Rx
	4uTfNdJxxz+Ba9vNppjpxaKQVC7AQvNAYHWy6hk+ljupPnhl8wmyL2JliIPuU/PIxKt1TsVMpt/
	w6chAvbcWwir67QO5R4WTPDOu8RwGAgPeYeXLPAWMYXVE9NVURjlWm/KEZo3l1g620wc1HcNzTo
	zsNTQZk6mqmVdSba/U/N0eiaakJkz72ruOWLoYjejyQc0y4QJqQyqiFbwcWxfOnwIYNRkrmkk7V
	gEMVZcZR4HVmHKW4fC30w9j34RjP7vAApSNLXpFraT+ZhNVUvwUrQWqY2sTPXxp2WMxD5ZrmvLG
	fI/P5/PGvkXC2Xe3vsHOTLG0b8nfFEcFw63RbcUwEXKj/qUf5U+llFGZy36d9QUftPIwVn+IT2l
	9cDusy2uJSvj4XkIJXFeR+q0UV3x84eANnktXEWSmccHOC/zeMMjFVWya0W6tThgz/s95UvmuLg
	AxTifjAbk15469KlTJfrX0Hg3kniN7ibS0mDYNSaeVPIhsOeHBLPxTsWGQcpSWpwVCV38AQIXJK
	JYfRUVZOrYlxAVe44qPUNORe+CVQ=
X-Received: by 2002:a17:902:e80e:b0:2ed:2176:244f with SMTP id d9443c01a7336-2ee0df868acmr2099305ad.51.1794509493128;
        Thu, 12 Nov 2026 10:51:33 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.51.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:51:32 -0800 (PST)
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
Subject: [PATCH v7 8/8] ksmbd: account for the credits of a request on a failed session
Date: Fri, 13 Nov 2026 01:50:44 +0700
Message-ID: <20261112185044.41571-9-mike.michalo@gmail.com>
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
granted credits. The same applies to a request answered on this path
because the connection is not in a good state, including one sent
before NEGOTIATE.

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

