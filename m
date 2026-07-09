Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB11367
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555566; cv=none; b=P2QNVlyGPDuwcxySjpCqBWNHaxW164HkIRc8c9jDGDCR/G6dRY/bI/ZqfVqMixFVRvjaxTf9kDZY64v4LFSx9u/89qi0n4s8VHepHQ3wmPAkfj4Dh4uRHtQT+gZ+gdm5jtlX0Mm+2dAA4o4DW38Czze/cV8WMjcnj7X4YW7fROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555566; c=relaxed/simple;
	bh=kGniuApSFzyeM16x2sF847rNZ1aZ3++vqdTPXQ18MOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlwsQCqHZCOyG08L1YSfI6UF/uQS3Uw56hjfzzzpKLv5ovp45zl2FlDlFUnmahaqT9z6geULWQtcGfqu3oS/6xDtKE/v0pbpXZT1vRZ3SDfMfbQHX9WgPvC6eLnrsMCr9FGtC3BHVGekZQ7VdJUVebUaOWYc1tWsrB1m+sUmchA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQZvyDfJ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQZvyDfJ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so9703765e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555563; x=1784160363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UrvmcWXweiwKFOGPrIBeRGfCJ8BB7ddGp/WfiQMyORs=;
        b=IQZvyDfJwLeGFqq4K1YifoWXK8c7BRZsvR2HhelXYyGc2Xz5At0gFKxysQUT3/rA+P
         SwKN03aeH4LCPTD2Onf7RUtpP7XqkBzxGIgVpxPQEhd+rl5FYT0FS8C4ZHH3rBp2XBOm
         yAX/u1VhfUjhwAJcWPVmnDiktcQVNIlj91D1Kon/JFuL7hlvz263DMT3ENQOgAGnNMhl
         JLH7+TlQN1xAOvpS/KQy7XJG2AeY+rspOjvm76CwdoTFs/9gEM+FxxmkWs277ZZlFJyU
         pbNQ9W4RY4TI45vlUxMMEsiTdQk4hAEsv0tnXVzMNFQBpAyxC8hW2jIpZg6gezAg4dba
         9VsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555563; x=1784160363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UrvmcWXweiwKFOGPrIBeRGfCJ8BB7ddGp/WfiQMyORs=;
        b=oRQuLQGozN7FJLTxWsSjpzJ5RLgw1mxkCB5m4WRtZv/izX9yjG5NPXAmgNcXepx8+C
         s8gspJoE0flGcVwiCQjjzABv7VY7a0ZVqlIENrronb++MnSRCBfK7RvFvNQqVNqPt7pw
         rrO7EEXLgOn7l7iBcQK9cMFy2T50WG48/HIlIS4puPELC/8bfP2VKKh5qUplw3toN3J0
         qd7uebAHBFxMW4m2pxtje4l43a65j6AK/H1hvGOjx/Ctbf6If81Wx2KFvWxaDuHdRhWR
         vwDJ+Ys/hIcj0PM8CZLNOBPu+VmVsUbQSyP5tdcDPFG4eqOq+qBLXBx+47oTtNHsSt27
         BQrQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNov1nCeeLCIE435+yTRDEyOU1k50Xay+sVAmdN31ncyGRacZp9XZXCyPagqu5AWkycjOQzltYTKcM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbx5G3jEcD/mR3xxLKdU4dfehcuYP4LdQc6MlUt+IixdXqpIgT
	eRgYg1PWEzqg2VAxtycfdfAx8jkgidAFBey2p37wu1vVQUIzsLsRzd+ofqpbHN2a
X-Gm-Gg: AfdE7cm8ReYPjH/4FgeIeuJ8IELlqtmWtGVqrHjw+eAtzGUbtPxYS2QdTdLdqLJY0Bw
	i1LzCZc7r4u2HBh+vjoQ02TlwKmAU8gPBBCT+IIhTt52xtEdkbwhLBm+3euMGmkk1uXrthMnYK0
	hWnF1O1HVVggGZcJ2QFC9D9mH2x/x06TmIsxvv0PyxRJ+/VGAzkXpmiOati4dPr/ukOf075cUnV
	1WwYGJYjbL7Jr3ODRhy4/Dnf6IbaT2xlMSQz5XhsVUx99zjWsFJ+BCMuWpmDtYWtbSErmfZKQxf
	sfdtU2Ze/ewR+PuBuLpiPE3kkHxkkVEal8tEbZwb4fnTRtyU9vcV+y3cECtxFpX325nXbVJSG7t
	beu6WUhnxndYOJqCBt/ycaHVBQfKN1S4XsjLH1OA/AqAangrHNt6t61FuqLU4JTzDe5vPeI0Xzp
	dFjPtNTIlBX3/QFc22tEuTRNXArtc7NQgp0c0=
X-Received: by 2002:a05:600c:a48:b0:493:a909:8c71 with SMTP id 5b1f17b1804b1-493e6894ad5mr44775915e9.7.1783555562822;
        Wed, 08 Jul 2026 17:06:02 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:02 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/8] ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
Date: Thu,  9 Jul 2026 02:01:05 +0200
Message-ID: <20260709000548.66445-3-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Follow-up to
commit bb682f1496f7 ("ksmbd: quiet mdssvc RPC log spam"),
which silenced __rpc_method()'s own "Unsupported RPC: mdssvc" log line
but missed that ksmbd_session_rpc_open() failing for that same,
now-still-rejected pipe also trips a second, separate pr_err() here in
its caller. macOS's routine mdssvc (Spotlight) probes still spam the
kernel log via this second site on every single probe, defeating the
original commit's stated purpose.

Suppress this specific case (-EINVAL from a "\mdssvc"/"mdssvc" name)
the same way the other site does; behavior is unchanged for every
other RPC failure.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 81f4af614..2e87139d0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2656,7 +2656,16 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 
 	id = ksmbd_session_rpc_open(work->sess, name);
 	if (id < 0) {
-		pr_err("Unable to open RPC pipe: %d\n", id);
+		/*
+		 * mdssvc (Spotlight) is a routine, expected probe from macOS
+		 * that we deliberately don't support -- it's disabled at the
+		 * __rpc_method() level (mgmt/user_session.c), but this
+		 * generic failure log would otherwise still fire on every
+		 * single probe regardless.
+		 */
+		if (!(id == -EINVAL && (!strcmp(name, "\\mdssvc") ||
+					!strcmp(name, "mdssvc"))))
+			pr_err("Unable to open RPC pipe: %d\n", id);
 		err = id;
 		goto out;
 	}
-- 
2.43.0

