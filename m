Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EB2CA6B
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555566; cv=none; b=C72XfPMlAzMJD4oR6/2pH7neQyyxYrlf+CevuGH/b4o9piA1JKw5C/mhlHo5mS2FiA1INQCuVWkS0AVo8/BNLc0Y2+bnPidROYlVTIc4MwEKrMFYkJp9jeqbBMFy7bTdaU33Y2XYwod/FjH2L47EE9yvqDkiacZFHwPOHvA2oQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555566; c=relaxed/simple;
	bh=OsxDSfvm7mg/CQgBT+naEn94RqGINwlIarZsqmrRar4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekyLodQEhopDMnsN1gdXfA/uDwjGHFNLH0rBpldY5leaehH2lLCqBuaI0FKwihiojrhzWwOfOX0yJ/yKdCeH/78d4/oJNk72Iv/8Ouq8QQKKRl4soT9E3/zA8V0JIJIBaDvCvrHgJ4J64ErkC79IN5RZFV+tOZWfuMOuejrU+Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NH5u0TyH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NH5u0TyH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493c7902f47so9567065e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555564; x=1784160364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=blMSz52J/+GEMzsbESHw0dQY2vsA0g3D+tSIVto5dyo=;
        b=NH5u0TyHZv0077/GRx28M2P6TbBslWFKVuGoMOTpuBbjBGL2mz8IpKEm+buSzudFqI
         z7V8Khg7w44VRYWqj92ZPONlwzOv9gWRYgh1T8iShIeaqN1myhILuhA7N75uVjVgcESX
         Y6nW9olEpH6H+tSxUCI+W58k/T4Wiw/EaMPZwJ22/z1g39WdnM2wbp7UPxzaSIk+Vy0B
         3OyB9IDxhyY/9QVAFWBtHFPLxk4ZzOerAPk+Q5L5LYhj/3vsB3RUHuM1JJXQt0IoAr0G
         0mh3V6XOsYk9orfiQnYdH8FI6SaM7vHY55L8M9QLxxBTBGae6A8w0hNTcn1jPf2Dh7Kr
         RoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555564; x=1784160364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=blMSz52J/+GEMzsbESHw0dQY2vsA0g3D+tSIVto5dyo=;
        b=CX7H2qXWT/Z3z83MFEkc50PifX2DrS6v7hjg6CojbxdJn/FlDBCq5mgnqQfefkGuPt
         AkUxaJqIhrXr85ibOxE9U+8BR7DcKoUaey2tyrJZ7WCx9QBsi2yLtumR8YIIGW72T8cD
         Pxw9XpnWO22PNo8qkZSeplHPaHmMHxwmo/y3mwDtAnibgsDie5MHHYofS2uI9/z+aeje
         YEuDAtB8rIqexA70rqhnkQI/pA2qsuZnYC+j0CUG5GQxJCGBIsmln4G76G8spu3s5SHw
         bNPGbPPjWoXRhwOqGXp4R1oCzCsyF4ZGbnLYDzur0TvRMFR1CZSWJbTVUPo8VpW5ncT+
         2xig==
X-Forwarded-Encrypted: i=1; AHgh+RoHl1zbz4wk+cDzep5nloBsZGPgVZM2coAGlK290i/EQ48Bm0jncFKvisOxD108HeUh/a7ItCzRAuah@vger.kernel.org
X-Gm-Message-State: AOJu0YxyAqozLXYp8ujeP64Zp8M5UlBDb+Blafy8lZKa0HIhErNZURXf
	Yzraz5qilsHojoM7dwpPmrSvapxUSQF9aFz7/qfPvkM/wO2dH8ueJzbpIeMX0MAD
X-Gm-Gg: AfdE7cmOBh8nYj7ZugJajaK9GfNRkVA67qJIWhwS58cRpl1JmcJ7/GYCqJRxzVgKCEa
	Zch21S0K0n8tQoULZ0TIblQRWsk+La6Rr69l2WWsnHgqxxrlbWiuOaKJ0UCJPBlPidqkScaGAjU
	gyUhuiJxZpsVPZMyLCfNCkxAhUi72Ls3haS7rqEUmXUir/FNepLssHNd9zGfbyfQ6lFWnccrkwX
	H5s8+oZ78tXo+q+OCEqvu0czqMnIvVlkfFYHq4SgR6qtLJfkMA8wJXH0MG8PRvlsRLPMDsk6QG5
	Bu6CKcZm5WV0cXxwQWI9+ykSdrJQS8j5p/e404p3VOrV1EbX4JqvExgdbFdPbN7S0vjHK8bVRYY
	qoCuBu2n5kJqJTUPlLUZNS6AxFK9acUzrOdI0N7OzgSA6gEkknB7PayO1ZGfkwIZ6w81r1Tr3tW
	zIKxu16E86+fFKFOJnBLSQZVaD4s4cvu5hUA4=
X-Received: by 2002:a05:600c:3e07:b0:493:de89:61b with SMTP id 5b1f17b1804b1-493e6868766mr46892135e9.26.1783555563493;
        Wed, 08 Jul 2026 17:06:03 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:03 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/8] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Thu,  9 Jul 2026 02:01:06 +0200
Message-ID: <20260709000548.66445-4-g.blivet@me.com>
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

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2e87139d0..190fde409 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4202,10 +4202,17 @@ int smb2_open(struct ksmbd_work *work)
 					min_t(unsigned int, dh_info.timeout,
 					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.43.0

