Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084703;
	b=sTKautLRJDdO3xwgNTYu82SYD20UnujEKwv8ayZ9T8m6hEVpLrWu6SFuWEGfXsusrqYa
	 Dm599bfEiChZ6slhHaMhApGKBgGk88jw2etkz0qmnywc+fGORA5YdUYCGYiabmQDrgJV8
	 tLLZX3hkeClPFQ8BwNmqyTrSNrIcLJ9n7OXEIpBj2eqYYt8ta1Du3sSy4E8W12NVwV4nu
	 Wz9sAEfq91JCLGk8T6T6/YCwzhZAS2S05yL0o2CTZ/3w7KcMZ8cwEt2/0PZuIhSjdyMv0
	 lc8Mm8rDuEuoJNef24ToEONCOZALLQckXqAe3Zx4ONBnvTUFl8gUsJIBN6rPyraO9lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084703;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=N6MGzyJLnkEzYXsRUJ2m4nvPFKylKcskvzAYyTbdVL8=;
	b=0oEAIi3bwGIvIvXx/rxMXXsuUmXme9Se/duonBDNmwatKC1cwOyhBADy0XcLWLg4CjXb
	 0QWt0SGpNRqBF20mD61me+aqRGd1fJ3bXZ6Hpw5TPo4sXB+VO9rQtGUZR0VeKGQQX8dY+
	 zJnPUu2AaUgyrI7sRbGqYjhDbNRAM3EXXQ1DM+SHfDF5Eq7aYAk7Rn9ceWJ0dDlpC8Vta
	 ExP3+N4YJ7xbZxJKNRt4bXBZsTATiEaBg9IRTMkuWHdk1M2hylagAg3McMfWh3sI4PtxN
	 tOZ1SG1LaYLwq8JYm/sRsc1taJOc89Ugq9a88rKC4HvkiKBL3B4dQGR/20hSnCmo/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=d5qrkZdW;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12C0606A320
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:38:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E12C0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=d5qrkZdW
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso1871024f8f.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795084701; x=1795689501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N6MGzyJLnkEzYXsRUJ2m4nvPFKylKcskvzAYyTbdVL8=;
        b=d5qrkZdW/CD1hXQSaLncSq52C14Ox2dRAJ2C5Wtq0ZLJ1kNuGyAdkQrgkH7xsEKMLY
         1QoI+9+v6RESZF3AupY6hwWhiH4XMtQfExGoIC1rQJyEhhLUB1YIN2OCSb1iTcJH0tUI
         kAjBfHUrnWu6/1e/4IVO3mgUowI0eYK5pvnA0M0exBILj8ED3vnqK+yE+P26Sm9U7upo
         7fqqKu2GwuMmGkypIUULeoTxElJUKl2EI8FqzxHtYo8VnJOX8uufTOYWNu1JRVOR9iTa
         0KNBGoQlHyzuZOWTLG0yqT2vFJGDEfAEuxwnMZPHyLhWdp3yOGafy+TRMoXoy+E2Nbn3
         Rosg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084701; x=1795689501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N6MGzyJLnkEzYXsRUJ2m4nvPFKylKcskvzAYyTbdVL8=;
        b=Y7EvuUekPXZepAXTJRCHZlvjvwpo4vASK6k0uSm9ie6miCUpNcOBOEQ3pHFHW1Uc6s
         rbUW2ubhYh++rQBDDd+F3hXnQei7F05MitLNIsVdFO5ufVZv+3nCQ2S6vs0wUuB1cNOB
         5XAyq9LhXqgl7nNBS5himko4NCcYO6mlZE4qYcIPx2dlFqVTxQUS0Byks7JWyxTCvw/h
         fx59WFNvqelmFguUopfQSsF7uZ9LTl9tXtCXUzfTaxBnn7q41aae5j4/vkskfSWB11Cc
         JhJheh+emVBuKKhzIP7FiKtDJAp7C1PucwVco1MdrHE2OSWyeIaCvLgi3zu8DigQtqEX
         NKxQ==
X-Forwarded-Encrypted: i=1; AL+hErGLCvvyVR/GIKxReb82JYZfM98PqsB/tg+8bJH4for95wMUBrfrRiQdTatHaN7mZ9kr1W/Fzhl/tibz@vger.kernel.org
X-Gm-Message-State: APuU4Z/159UffxScRY6vAqW+G3pu6J4X4kFX3O2DfUHjPI0j6+e4drea
	pCf0AZYHXJzQblZ3+7KUOldey9mvv1mDgsVTfO3+frEXR4vBEkVAWfpgw2CjDyX85gVj
X-Gm-Gg: AZFdTZcoqb5U2zoS2LMJhPJvydo7kQTxFumkj8qFbOPKaLmNeOvwmo5qFQ1VdvGXNqQ
	oGRKWeLFCnt/QLu5l3o5o1cfPHmOEl2HDJMHqe8w7/BCf8wL9aOykcJwAat3Ey4zQrsHviPAieE
	dVuPLVXk/jIdP9iEX2Y2/YJbMXjtyZePoSp9Boxt8yrzL1GYpCKgJIHY7yYCw04HZPbdSomrSu5
	VSERuGG3HAV4zQwvUg1+p5jzXWHaNKkj7r4hXf7lhQU9G5PJhXQGjUTD8OZgic3ZwpWoTnKQg1f
	GnfUZLb/ZC91brVR554PY05Ds4kJA88faZ16BrHMn18W8+3kBZEosN/je1tlkosLn46wVDmhc2J
	w3sWYzGtOo9k9Dn37Ycu1RkHOEfxpP9lPzdE/iJMrsWOywI6r53n2V6c1/GQj52OTctpBG6t1hs
	mo+cX9oVZDtuqywku7UFMb2m/xTAYDNZo3lFdNsaLTIu35wuFT/aluqIS1P0YrbE9KO1OHxhK72
	RYEmxrNipq/FwuLoiFnVa//PQLjxNVZ7zu6DLe7r3XN19xj5Jbgl/Fb/Li5qDnByVzwRD1lb9Q0
	m7DtXOHnxfTxQQi+bBH+902kRjNWLcALJPGQBKoIKfM3qHmgR+NIdYfvYcgmk3UDSYEb
X-Received: by 2002:adf:e188:0:b0:4a6:67e2:5c6d with SMTP id ffacd0b85a97d-4a667e25cc9mr10639612f8f.13.1795084701396;
        Thu, 19 Nov 2026 02:38:21 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10030927f8f.34.2026.11.19.02.38.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:38:21 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/4] ksmbd: require signing on sessions that negotiated encryption
Date: Thu, 19 Nov 2026 11:38:02 +0100
Message-ID: <20261119103805.29514-2-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
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

ntlm_authenticate() and krb5_authenticate() clear sess->sign whenever
smb3_encryption_negotiated() is true, that is whenever the client
offered a cipher in NEGOTIATE. Offering a cipher does not mean the
client will encrypt: unless the server sets
SMB2_SESSION_FLAG_ENCRYPT_DATA, the client keeps sending plaintext
requests and signs them because signing is required.

__process_request() only refuses an unsigned plaintext request when
sess->sign is set, so on a server with "server signing = mandatory",
or for a client that sent SMB2_NEGOTIATE_SIGNING_REQUIRED, unsigned
plaintext requests are executed as soon as the client offered a
cipher. The Linux client always offers one, and so do current Windows
clients. An attacker on the path between client and server can then
inject requests that run with the victim's session and tree
connections, which mandatory signing is meant to prevent; commit
2bebf2470af1 ("ksmbd: enforce signing required by the session") closed
this only for sessions that did not negotiate encryption.

sess->sign_required already records that signing was required when
the session was set up. Use it in the request gate too.

Found with AI-assisted code review and testing.

Fixes: 2bebf2470af1 ("ksmbd: enforce signing required by the session")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/server.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 962f12e969ba..5d94a3683f7f 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -203,8 +203,12 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	}
 
 	signed_req = conn->ops->is_sign_req && conn->ops->is_sign_req(work, command);
-	if (work->sess && work->sess->sign && !work->encrypted &&
-	    !signed_req) {
+	/*
+	 * sess->sign is cleared once encryption is negotiated, even when the
+	 * client does not encrypt, so check sess->sign_required as well.
+	 */
+	if (work->sess && (work->sess->sign || work->sess->sign_required) &&
+	    !work->encrypted && !signed_req) {
 		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
 		return SERVER_HANDLER_ABORT;
 	}
-- 
2.43.0

