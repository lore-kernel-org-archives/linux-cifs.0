Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458856;
	b=kPPsOx3gmzrH59GDouvEKfcqzCJ/OFfqP0vJ3g1FsAGxmAbn54hOM81hCZCtVRfsC0BE
	 UXmOTogGfQXRp5nPXdRAO71SFrHQ8bcwY9rueRLMBVPponZXwhi7uiMxWQxF6lvlFtCsT
	 LMwDaIWDXDm7Gni3sNRpKPwssr3oKqT88aK5z8C4xhH1DapiZW2XIy3SV5wJhBp2c7w9R
	 SqHrQHsyLDoXDAJLWUgydY0v3lXvc5eVuVq9IUOZI+dXkChZS6h00TedtPxSA90dz41I5
	 a1qKbli1EeUXZ5duWzoE+ZdXaSx8zQOiELdZAXkGxNLlSDTwOQPS0NkoykiL5XDBMng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWOiT8mtCGqAbQ2n8g+EV5uWeS59q5JxKnJ7/ECCPaI=;
	b=A3QPynRSN0P+AXvugT06klR1IRvZeaBtoFBdKAMb8VNoNUHyCbGV0LkmegAqRnrhNtu3
	 iSyPoTsYxpG9yUIZ21GRP0wdV3O/RvwtUe9gyvomAheXGV/MvOSIxk0m4e6oR1zuhzzWU
	 ke/AkESVrBno7FHbVcjeVhHbIQ3Gj95ZnWjxk9+gVh5HG8e4nvuLBifEwPa/8LFuaTot1
	 mOd/1DXAE0709kEndDh+1vB9U1L2sj2r0HelKSUEpJ+MDxH/9x7D1LaiZymUZ3tTH+FpL
	 KefmnsyhfDXlYrQhaK14TgZF+lsxLWIpxE6e10EH+Qxjc1iV/h3aPI695ymI4hrmUWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0lMbfN6L;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01502606A89B
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01502606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0lMbfN6L
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1a2761c69fbso6746545c88.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458855; x=1795063655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cWOiT8mtCGqAbQ2n8g+EV5uWeS59q5JxKnJ7/ECCPaI=;
        b=0lMbfN6L4DIb0xQwGWaz1cHzTL3IEnMHQsPpBDtA0sASNUMaOEE4Er2lnLqCBLSfaQ
         8yCAzgVWOM7x9Eyi/PFNimVngcdKSxLjuNxaJv9ElR5eHeRKaVacUE9sy2d+5lKqyER4
         9polB6A+jgFbL5VAaxHK/i81nsy2vn70BvSetgfnDxz2ULmEvCGwvLFSXukj461dMmVs
         LsqLcxa/eetJBQMzSzATjRoCovQSadcCy3NHDjUJtap+ZZH0EDPgSyz8XM2Z8LHwsUjc
         1CRdzPkhXko3cMw5hDtDQLGelYRlE5+MU1mtV422KCPOf5n9wEKQOb7fpCKVhuG1CJ3u
         zZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458855; x=1795063655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cWOiT8mtCGqAbQ2n8g+EV5uWeS59q5JxKnJ7/ECCPaI=;
        b=2RTqle1wkOvTNZn+FKMwtAOGswRNDf4AYt2Hb6Xitp1R74W2WxD0cjHLi03mLGtwcU
         rwYH20ahkpDlxoccuEBgtQ/zdwPt5vFF+s/KhGEwyuMAsjh7vPl1eTAA1RxQsUl/2RHs
         Vw5UXbKqpBe+FXxtxjgjPZ2EQvQCKWlgAJKSYon2xPDi0UPiGGAArYjhDnR8pD7QOzP9
         sir1GdUcZrpNZ177CcpiHk5hCPlkfRYyJCLR9TRCQaI+707cfIKMu7WqCEPF5PI0fog1
         F1bURFiElK39v7S/O3quq26sD+ZQQW5THG7L0nZkRhUapN/sLEffAS5OMRaUulVYZk+4
         hcZQ==
X-Forwarded-Encrypted: i=1; AL+hErGfbG8UsJH4h385UNRUGf6CHcglT+K/0BBwCwtNvbYaImCJqFlkBcDg9kKCybxdzFZXxSTP+W1XnrGo@vger.kernel.org
X-Gm-Message-State: APuU4Z8Nk/R7S8hLlCUC3jrob1PWqtbpaC2czQ43KwSR+gi9FLKwM1BH
	mCaMq+JSDygHLc2VQ8dtKlHLGivd3Q5LiXcnaIlPkjoj6zniL+N8tHX7
X-Gm-Gg: AYBFou1uxrAb3q7UpWknfwLKBIwuXmnsbyrd9d3VBmBOhLWA6e+yZ6EnpjTdWEWMw3Q
	dL38Ho/QzPeza9NBdkhRffC7z88dwxAo7OM5Uhzg2j5xcGtynG/jOrwI1lQzixZCN9VWT0GW3BA
	UhZhr2EhAN6IsItyEPIGsd4qcU8aippuzkrp6uD3DIugrkuSghhZtYhRSGzp4H7RUaRhM3aVHsw
	+A1eFbqJMY1FMyYLxHTtfJLFIe++vJDl1zYZf2UehpJln4FTdgumUMjiSmNBFZgQXevd4YmxSrn
	87Uw7GqxCE/4c0lXexlc0DHxsegLxGoaHQ78se/i8oB+SvKfah2ztwkuB9kySwSZG25IXA5ICJv
	BrbysI81mTs8FTjU4MZfBIRQ2N4616ABJGR5Z40jTB6BUCczPGWVxucnZbTdmOKP3/WCw8jxUyC
	6oyWWhvkZsyUFSXKoBmejImeVOf8tb3UOSlI46QEzrt4kUn3X5GUyUZKRqTcNEJI8LSYT+d8YAu
	J7Pp4ey9gZNsdJ33pcxDWEM6NgvJGwQTwmtGT3jOn3IuQEQ62C/qjMViIcA9+UCx87GaqLp1gpV
	8KClb+9TUA26ZSPV/gvBv8F1Iy70Dw6JhFGI8kPHGEDPMGT4vHP2XbnAiuoI0Wvj/XcawnkbWEd
	vYPvU9AF/NySab+LEfoUM9ZyAtA==
X-Received: by 2002:a05:7022:7f0b:b0:14d:baf5:c419 with SMTP id a92af1059eb24-1b3c023c195mr3372490c88.6.1794458854757;
        Wed, 11 Nov 2026 20:47:34 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.47.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:34 -0800 (PST)
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
Subject: [PATCH v5 8/8] ksmbd: account for the credits of a request on a failed session
Date: Thu, 12 Nov 2026 11:46:45 +0700
Message-ID: <20261112044645.4074-9-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112044645.4074-1-mike.michalo@gmail.com>
References: <20261112044645.4074-1-mike.michalo@gmail.com>
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
compound.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 52eee04e0d93a..1522eb560e838 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -132,6 +132,36 @@ static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
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
+	/* An SMB2 CANCEL consumes no credit (MS-SMB2 3.3.4.1.2) */
+	if (!conn->ops->set_rsp_credits ||
+	    conn->ops->get_cmd_val(work) == SMB2_CANCEL_HE)
+		return 0;
+
+	spin_lock(&conn->credits_lock);
+	rc = conn->ops->set_rsp_credits(work);
+	spin_unlock(&conn->credits_lock);
+	if (rc < 0)
+		return rc;
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
 
@@ -300,6 +330,17 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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

