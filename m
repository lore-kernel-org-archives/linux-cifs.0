Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253338;
	b=gT8ZCDcPoj9BA/fI+nKnt3kKvHeS8ixazgumyjC3FK1bgGkkBD0GzXuHhZjiowZ23jsI
	 88Mt/15q/UlLOynBDI73XZUH5ZaBFSyfSaK2ZbLXsniRlUGA1npn55Sd8JHzmyqkCvFb9
	 CdZE8khi8ZzM03/ebha+diKR0h1jPnS02lZmvpmVzvamk8Vciwr9DyJGJ+7QlOzw6MGXl
	 E48EV+X25QuyZM0RRvAtIV4dP89dNq5wnoRFaSCQtV3MhRnc+30JIT4E8RvVxMOETG1PY
	 5FgfMwLa9hQUqBiTgz4n4BfpVdeUiVv19i8zy7ysc+UwEhOHFZTa3KAH2/SDGx2pCPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIwwhY19T6f0qHtgPzyazjtCz8LaUAMO7sgruWI+rDo=;
	b=RSjfS/9UWGTUVgBi+SdEc+Gg+bhv9RfXcdxWHlPz3FJR6hDiweyiIK0q3nooyT7Yux2C
	 3fDNdr43DfjrzlY693hHV98NzYaf7uDGYweOqt9P8n9dkqF52aQIFnb3ghNkhKyeBU7vs
	 w0FsLBhgWwo9uUZa6EDhgX9joIPqd0CTkDVNpCh0+Iy82jg3K/o8WErFjoNA1wwbWXPbL
	 Wyv52GAwS/0wCKEx6guZH2lvuUI3uAvT6dzEFjIu9+4qnzzOZIc1+XL2mH5fbGOei2Cem
	 ZYKT+tGWT0DwNvzYT9GpaSWOM4jcoFCmiufpjrPourmJw4JRwIGl63bALBrEbvjHRBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hvgzSntr;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDCC60A260D
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DDCC60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hvgzSntr
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e9d7791b00so10562955ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253337; x=1794858137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lIwwhY19T6f0qHtgPzyazjtCz8LaUAMO7sgruWI+rDo=;
        b=hvgzSntrjv0Eepibl4tNE0CfHPMpPsJpxLAyFyYxacmIqWv/b4NvE18kC2Ro01MgZL
         ocE5YUoEl0/vrDPRWTPCdyX0fYILnlZAnwCTRrPOWCAULCoxGqZNJrO4HRGNTesBTQSH
         GD1wYH0JKpoRvpCwiEstogHvibfTEZU9eCQtTjDnfIlypM3vbzboFs0kZQ1LnjN47s6o
         UWvaj2xwsIOgdGWFc4PapXtdz9bx0M9FphhRD1OP+Yq2JuvlfZtZLRPbU8wrZSwq1iIk
         9VZs1MkkYPTrJX0M5/3965WY6DdK5lSFyBYfo3g01oKM473d4DGLqbL5qNX8RK+7xzYf
         mrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253337; x=1794858137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lIwwhY19T6f0qHtgPzyazjtCz8LaUAMO7sgruWI+rDo=;
        b=wj+G/ZhPLhzxGraKp93VkFF8rFdBv0GML7PeWlM0jkY0BSj1tWMXvyCGM9TRRk3/Es
         8GT+q8LnqthPTQcWQKkRdosrX6s2vTO6fF5h2OLmeaAZKHEDu+5MyGBuBssrZkFOcy8u
         itHxWH2xnw/9oegDMhV1S2NPtya5wxH+90hkcBKnM4mj0kYpkk0eY5y5b51kRwv+34xU
         Hd2PWqEZfN+vweKhzF9+c85a8o6lDTom6Q8FKTYsvj6tf7MZrE6ByPnmyOo5kbtvkd1W
         lr/g9FAVZmeVMw/rytfcDv/BIb+kgIx0YYRfbrJB6x+YAFJGBDFPUkRJltQqhUkpnAPT
         Ji3w==
X-Forwarded-Encrypted: i=1; AL+hErGImdzzz4gVNFxGQXpZKcoYswqOs9R8HmslYyk8b7OUPM6vSzBejOSgq+H45J+NRUqF810Qy9n69qd2@vger.kernel.org
X-Gm-Message-State: APuU4Z/FHNCepxuWheQ7Q9aSmIXdUAJnnjUfuPlYNENyY9PQtXDVXv6k
	ezE/dJaeZ7MGc+J3hhV36p7+nOlg4jMBGxuVwhLdFuUqhSyj5YIcH6ZB
X-Gm-Gg: AYBFou2jX1ptXGtwFmv3XdGimHXHUfIYSRCP1PKxMiw4k6Lqpr8kALhxsvRbK5/2oGY
	ZqJ1JMFSrFv5K3oopWYmaSjTf/pNROJ8AyXLSj10RGTiCXzMuKBcqdQUQnoKCozKvexGagK6zfy
	K2TUc9ah1pTF55t5biM06P0HH4pl+mtCxHIc5/J9dxo8Cr/wU/pTJIB7LeyoEildkpChNb0NplC
	xK4x7r4NgSbZ9G7ug19J80uCRImB/nbJwrYFE3qoqFVv50WRDtJfOvjirrQGPkPKN9fgQwTqa1P
	7DSeQ72JzzbiWjmxHfyo7ASDp3ceJ7tiT/VQCRhKZrcLt84yMMQvalMT0gmH5LtB6EBH7fKX5Cg
	DltkN0vs4Tu3vG3abns5P76AYPszRbj1ERnjDNawTGzZPibD7ZRibXBt4ziklszPXgKdQmto1/V
	k/LSwk9xCDMRE/7knuZBsByyrVKlfbslYPBst/6JYoPuiu9VRHuezI0srFYxUCwFmFgtkYdLf1I
	+9Yayn5zZjlaFgHz+fFVt30COnITCJssnWNeru/WoYNjBPnuvAMAKmqdY0tm5rkORfjc5SLcvN3
	ysD3TMii8hF/AO44hjkMxJ0aPFIsk72tsPHTjxEF/9wSmFuu/mFj0q8zBxPTwabAAuwFDBsS71F
	v9OX7xMCFLoGc4N2C6Lsx3IsP3M3/PSlRsCfMK0uHp4Q3qANaQPt2A9k=
X-Received: by 2002:a17:903:22ce:b0:2df:90d4:7758 with SMTP id d9443c01a7336-2edb9164135mr1348605ad.23.1794253337360;
        Mon, 09 Nov 2026 11:42:17 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.42.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:42:16 -0800 (PST)
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
Subject: [PATCH v3 4/6] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Tue, 10 Nov 2026 02:41:42 +0700
Message-ID: <20261109194144.22814-5-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109194144.22814-1-mike.michalo@gmail.com>
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
 <20261109194144.22814-1-mike.michalo@gmail.com>
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

When a session's Kerberos ticket has expired, smb2_check_user_session()
returns -EKEYEXPIRED and __handle_ksmbd_work() signs the
STATUS_NETWORK_SESSION_EXPIRED response if the request has
SMB2_FLAGS_SIGNED set. This happens before __process_request(), which
is where the MessageId and the request signature are checked. So the
response is signed with the session's key for a request whose
signature was never verified, at a MessageId that was never checked.

Anyone who can inject requests into the connection can then get
responses signed with that key at MessageIds of their choice: a
signing oracle. Reauthentication keeps the session's keys, so the effect
lasts for the rest of the session.

MS-SMB2 checks the MessageId (3.3.5.2.3) and the signature (3.3.5.2.4)
before the session (3.3.5.2.9). Do the same: sign the response only if
the request passes both checks, and otherwise answer with an unsigned
STATUS_INVALID_PARAMETER or STATUS_ACCESS_DENIED, as
__process_request() does.

For a later command of a compound, the response that is current at this
point is still the previous one, so the old code re-signed that response
instead. Leave the expired response of such a command unsigned.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Reported-by: Ian Bridges <icb@fastmail.org>
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 4430c8d6393e9..bd4db44f06cd2 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -107,6 +107,32 @@ static inline int check_conn_state(struct ksmbd_work *work)
 	return 0;
 }
 
+/*
+ * The keys of a session whose Kerberos ticket has expired are still valid,
+ * so STATUS_NETWORK_SESSION_EXPIRED is signed. Check the MessageId and the
+ * signature first (MS-SMB2 3.3.5.2.3 and 3.3.5.2.4), so that the key never
+ * signs a response to a request it did not sign.
+ */
+static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+
+	/*
+	 * For a later command of a compound, the current response is still
+	 * the previous one here, so signing would corrupt that response.
+	 * Leave this one unsigned.
+	 */
+	if (work->next_smb2_rcv_hdr_off)
+		return;
+
+	if (ksmbd_verify_smb_message(work))
+		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+	else if (!conn->ops->check_sign_req(work))
+		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
+	else
+		conn->ops->set_sign_rsp(work);
+}
+
 #define SERVER_HANDLER_CONTINUE		0
 #define SERVER_HANDLER_ABORT		1
 
@@ -276,7 +302,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 					rsp_hdr = ksmbd_resp_buf_curr(work);
 					if (rc == -EKEYEXPIRED && work->sess &&
 					    conn->ops->set_sign_rsp)
-						conn->ops->set_sign_rsp(work);
+						ksmbd_sign_expired_rsp(work);
 					else
 						rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
 				}
-- 
2.43.0

