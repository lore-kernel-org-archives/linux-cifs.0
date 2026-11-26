Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705721;
	b=HGNhMuapY/4XXUCsENaxoIPXuBg9L9mDt2TkHc/zPShSAzC0wS6cnm4EtZse5ym472sl
	 bJ7d9pC0m/P8gVoPsSMdPALiM6Vzxoere5uGSqKTA3z5VGAZNaR1hPe+feuo+TfdozJXw
	 CBOwBwG2bUB9r2SPlR7FHSl4Q6f48ao+e4evFNYWgnoGNsJGa84P06nF1JQJX5x0n2Hfb
	 Y+0whgTsxTNTN6Hz7InNfcCWtHN5cWkFHUG8YEetP5UhpavP/1W6yG527/bwMuWstYrbE
	 jSkVolPK8M3fGKdNEFhAjhw7LtA3pCYDmycJ3bQCAnN1uw+OxBGoj3AcSkx4wGRznYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705721;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kYgv+hVmgXPLxXonu5mgkrwnkFs8asTp/shEtbRc/+U=;
	b=ssGc4oXw8tKtcMsbo8qkFGtHdy6APXOhRTCCyDvNe/YuHXV0ZuNE3fHvzdADfVOCZrSu
	 UmI+CTW7Rb55OBT9Rabw3nfOinVwPUEdt2LpXKK0qR2EsDl/jNAkWgLDE3lHbtSpZm0eO
	 Ww7/OtCuqDF7t3TGZu+rpUi1j9JkHWNuLC5CpQHU+wXgMtRekXygo+PVQTbo+09SvQvcR
	 lV66tRHpDE5LXe+SXFY5V5HFLwBOV11YJPQShCRPQMJZpWJayOq2kVDJs+HncplvB7c09
	 pUmGvEJo7cLhvlhTDO+wCAsu9KI3vzKJi3MkSxyhnQkRLd6RjFS1CGIMWcRnEW+DCPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=EIJH3VKg;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530E606A326
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8530E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=EIJH3VKg
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so68207705e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 07:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795705720; x=1796310520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kYgv+hVmgXPLxXonu5mgkrwnkFs8asTp/shEtbRc/+U=;
        b=EIJH3VKg8f6h3OOJ35ZEm308JPPFpSrPVjASs/7c+xkUbEgAfFtoveLGuaYkwhT3zQ
         dif6asIwYkaPzng+pEcP4eIBPp5/rOpTuHdrzVKzyPjdFjZYNk9eEy2Bgkncg6uHfeJG
         o20HvHVjaAlJqGwqnVH4NEq2ZbcKaHMgrOmwuvCVqT0R4FJ7ByvsT/5AxZsrRt4puDrO
         8VuKasws5JkLWyElrneFYm/Ndv1qt9/EVXfDrylQTBSms8LtT3LW1BtklyZIvrlxcNst
         cDhTznH27btNV7URutChc904Qy/FwBaDujBHWqxNKkPlGzeHqCPO++KGBZDc1zGzSg8z
         FaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705720; x=1796310520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kYgv+hVmgXPLxXonu5mgkrwnkFs8asTp/shEtbRc/+U=;
        b=llTdExI12XwTy17fb0eOCvEfby+b7F1sj36AD6KdJE6KdWJKba8Ag2X4mKIMw3USdJ
         ZNVn7z8+GBYp0gPd7JSzVwU+2zLJcqdQa7mgqhqdLHOt74bjj1/fkQB1vquTShlZwxGz
         D9oU0Tc+JAvl6tOMyqMa0Xq8zOoMlmkuemKyLWCv6oooJKxaML4EpFoiyaCTnms4ze+l
         WwbSXqvwPMq7KZq1eYla2M+T/hgltoB74l9pqqtf7PtLpC8x590BO2HPzyWDX3iOzwdq
         r7DAeZqQfMQOWfJ/KHRo7m/sEGSHG1WbVGvFZfbdmMRg6uSF0fwKCUThvuouMasonoKb
         BwOA==
X-Forwarded-Encrypted: i=1; AL+hErGWChwjgp3cTinrLK17hHNCg6t+DD9LQSOWhHDAdadIrU6T1Vc191rpkA6sy75e13YTWuNgYkpAGI1t@vger.kernel.org
X-Gm-Message-State: APuU4Z+ZzfN68EU6Q5FX03zcHX9XG/3ZIzrQfSm4OvD8SaPxq6VPgfGF
	YShNyqyUdi9qp22SjZb2kKXIBu1ESHMj89G1ihpOm6MS+O2te2XoT3fqgV/tGOMJlH49
X-Gm-Gg: AZFdTZdPbs0i9dTzdmwDWwxjpJhkJwBB5kD8UP2FV3uO41KsoosU04kbJ/kBT/N27dF
	WLgahOLAC6g0XN5brUWx40sWmZUP4QB6uNSN9SZR3+ZYHTQlSjdNgtpt14RSNCA8/3xCjAPfk58
	CdTobM9UJxqAVku4p6U0rF6CCHedDUS2NBGuR1T+yN454po0fJIM568cIUGEwI8dD3Ys2L6Khhm
	sB6nMoAkMsGlsW+yh5YP5y28o0APGHpLhh/NDq9TPpJX9cFU6YZnLtJn3E4yS73ANh3jrzvl4fl
	0Dj0L7fkXxv6ZHcnVpPXBxkzM3BssS8pUvI0ERtbn740a/J5GJAIfOiFLoBENgoJrEBw4Y2KTgN
	9y3Hzzx0fxeXq6YHM+iyKztkmXVrvhlS2xySAgH1/3SFulNnbV6GRU7rBkZemQiWEDTv+dZ4EIx
	EAYzx9TFCf/+IrFm8iZtbmLD6542FQKJeico08Xq/lpeZZkmCkaRXtcOYEqd5/w3J9CHTYCZGfn
	uh3oi3jCFzmIQp2ktVr4Q0Dcp+a4VO4y/txH1cYauSOl2rCAiGNWxw5nQmOvKLXNKwwSoAOLwnR
	9IHBD/t9gvLiiROQWUQVm5983ZyY5uPxjIlApsyBNURJGKipyIhlzrDPfS3+tAs7lzxG
X-Received: by 2002:a05:600c:64c9:b0:4bb:679a:86ee with SMTP id 5b1f17b1804b1-4bb88938dbemr429531555e9.29.1795705720013;
        Thu, 26 Nov 2026 07:08:40 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm599850045e9.5.2026.11.26.07.08.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 07:08:39 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Ian Bridges <icb@fastmail.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	RootSys GmbH Research <research@rootsys.at>
Subject: [PATCH v2 2/4] ksmbd: require signing on sessions that negotiated encryption
Date: Thu, 26 Nov 2026 16:08:34 +0100
Message-ID: <f2e340cdd649e944c3fffadc38f62f003a194b58.1795701726.git.research@rootsys.at>
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
Cc: stable@vger.kernel.org # 7.2.x: 16ab0adace8f: ksmbd: verify the signature of session binding requests
Cc: stable@vger.kernel.org # 7.2.x: 42a1d80e64a3: ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Cc: stable@vger.kernel.org # 7.2.x: ea472ddf7a9a: ksmbd: use the channel signing key for session setup on a bound channel
Cc: stable@vger.kernel.org # 7.2.x
Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
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

