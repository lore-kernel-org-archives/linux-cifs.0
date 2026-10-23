Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792716028;
	b=PQC7jUtBQp0n1fLXYZPRbH5TdD5SdLw5P24nb+JeET+p6VgqU37ZOWkfIPFEfa9vlFGi
	 YVcbgH569tpQnBXzGkSlVKFxF1BQ53plEt8//35Y+k9MDsKGdH4qd8KNRfm3WfNz9jFdj
	 Rt9cP2G0bj5/kvUuUwokU9UCMNVQ1jah2nvuvb6DVz9bIH53VHKa7VayvMv7Kj/K0As3C
	 gPwsIju0HyAuLLV+xgFnAdTMEIyYO4vEXguiXj0oCPq9IV3ROy8Di8imyeIifbPMOqbcq
	 JIu+TUWL+JwZ0scOnENaeRyT6YMhkLinBw0yTS5LHXoO+EAac3Cp+9FtYP53V7fUczQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792716028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTx9dOA+V3c9E2l48EAUDZlXgm5BgthbGaJoqzKG/Vw=;
	b=yXH94BZxJEWUXdGUikqgixYYmw2TJArUwbfXepc14jID07eoTwrxCQZykFiGejaCQ7IZ
	 o1T8VNlXsStwUuM/jDf0afcsu0oThI/RVJ9uPa7O2uiquJ5I1K/Gdm+atBP7hNKxagSUh
	 t3Mjkr0Bx+8LIRE3FlsNsUxxO8l1HH+QZRtNTamxGQ1msR22XQbKfgn7tZqVkSv471fGY
	 CFnTIdnUc5jBfttqW3Z5V4NRkcDhsXFgod9JHaJKAI1+zS9seM+5Hhd9Abkh9tCPfLlBF
	 BD1HB+2LqtcOVEEJ3fh8BuS/iDmL6pfsNcW641Aoy5qo2HgAYfYtlwsQQ9rGpa8/RzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="KLCb/S7o";
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6524F606A31D
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 00:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6524F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KLCb/S7o
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso435010a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 17:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792716027; x=1793320827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTx9dOA+V3c9E2l48EAUDZlXgm5BgthbGaJoqzKG/Vw=;
        b=KLCb/S7ocuj99JyVAApM/6QDX9Cz2zbxPrGTyACgHjD8EXkNbW8hpspKv0Lypr9T0u
         wtBN1hqypTjgzlYM1TfBFBxk313oO+wR7scKDe4hYdEq6AHqBh6bI79FtvtTxHw5ilPL
         nraSxLDgL+EZf51M9LuatFGFCZs3FbFYJwJEJPTQ42Zn6ajl6uAw8qaz0GdB1d+2pe/3
         +4S2FuhwHKJCXEOU8tARFmhEvLHWIU0Xmr884ARrtojQx2+9ERO4bJv5Ke/1O9vyP0py
         lYdyJXRqMPcJRywjXiBUWQ7a7KxNvH4042q6uLRwkp6MQYcUtKzZeL8T4GlOM5Q5sqM/
         SANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792716027; x=1793320827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZTx9dOA+V3c9E2l48EAUDZlXgm5BgthbGaJoqzKG/Vw=;
        b=dd5wPE12Xd1V8yY0yZQAfPNo+tRO3zUHJ19oCkqAFjrPNH4xjrKEpOMo52Gf26CE+M
         a3K9bFZADeXRpgqzmmhYhUfG9cVj8TXuTyDbhosYasR1JdbgL3KakLA9Ax7yhK9OHObN
         mB8ScOktuWEGmUJseyJ249fpCvJrqTCZJMAh8c5y0MTaKuylQlugcPz46KM+3qaPy+9a
         i4wKmiSBIN0qmwd6szr48sAlix9vDKkYJHLqDdL+wNwnIQCsJgfKUZoKVGF2YRQCqz1/
         x4xTVH8JG7k2nhAOFKe6/IYaRrGlfYWgfB1n/7UHGKBYFX0gQoueCx8Q5i+gZlhYGiV6
         BnpQ==
X-Forwarded-Encrypted: i=1; AKwUvBxlKqCK5/BFhszOefpgvt8jNVq++LdRiKHxQ/Mgz+16RJr2qU1GTMkOh71RLLsJWS8tS/pAGOMI7OO/@vger.kernel.org
X-Gm-Message-State: AFq9FYKCGknZ5U00GNFwnTTiLEVCpMgPVU8w+obpMXV+nwBvdSPNXC4X
	zK4q8sxqqUu2B3CU0gOeTsz+wDSjjGxAT/M6SsYAsQDISatWRM3z6ZQm
X-Gm-Gg: AYBFou3EmataAkyy8AAg2NhMfeyIMdzS46p7IZpVSWjKffhzv3/OD4Psjo7xRUXUIXq
	TaVLRza67NaxFMQ4C1Akr5Abv0gblNAQvX2VUfylkOWHpcBgAN2GtgXvtrFHTNdG4NeNfNQf/XW
	+uhVvCP3+WiUFUTl692X/DWZc/T2AZ3WRXV1T8sptetGUMZgGY3wg+IExJia038XVAjXa8BTQr8
	En3brRFo1crfyr5eamFhSoDi1Pfvw/Aqyf0fl9PDqrLtNCQs6Qx5Iayn+HvQDQ4Hra2790+lhCE
	cqDs/8uY4pVocOaAEXMlcKNk1wG90smsiqzAj8dqaN2iOmMjaKD0Z/ccqbyk1EO47ryUn7xRuXX
	dBJSwB/QUsvw3HaZw6n2lrcDiRJINvXTySln3Fs0b3O68vB9Y9b39u9KrRh/oEVNy6So5dgVF9O
	iegfTgPjvPSdJogzow/ySbju1meIxNO7yQ/hzAnmMixWkcVAvbZ4gJjsJYZANyo0wJnAS+ux8Pr
	t1Y5wlD+xpR3SFvpPQY7UWYb9iT5x+g8dcfc4j+G0aEr7CzAuD9B3e7/taACzfM4+VxDRx/Lx5A
	nwh1x/j5BcQf7AX1WZQs04Q1JA5A34oPHL3W7dKT
X-Received: by 2002:a05:6402:e8d:b0:6b1:cea1:a011 with SMTP id 4fb4d7f45d1cf-6b432a94c76mr1525699a12.0.1792716026746;
        Thu, 22 Oct 2026 17:40:26 -0700 (PDT)
Received: from localhost.localdomain ([45.93.75.180])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b432c96badsm426013a12.14.2026.10.22.17.40.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 17:40:25 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] ksmbd: restore Kerberos logins with released ksmbd-tools
Date: Fri, 23 Oct 2026 02:40:23 +0200
Message-ID: <20261023004023.98453-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023003855.98316-1-mike.michalo@gmail.com>
References: <20261023003855.98316-1-mike.michalo@gmail.com>
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

Sorry, this was re-sent by mistake. Please ignore it: the patch is
already in ksmbd-for-next as commit 0fec4c24e197.
