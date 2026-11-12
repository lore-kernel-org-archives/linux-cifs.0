Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794459168;
	b=5CrNIn+ldhsaGO+sEHffRJeJ0LAwm2NE1KPQIdHSPMBweGJyrtMA+0Lcv9OPqGb7/uE2
	 KioE5wpUkJ90lCB9hIYDk5o7QP6GycArG+aeA7fQioqOunzkr+TXBZuWbQ+iRYnHg5wf5
	 GdvTEqnRnwPeMQIWsIIBWMC4+0Rgq6WJRnll0+w5veiW89R6JARLqlFs5BAVODHaMq33+
	 YCDyI7pC8CHIQ7zXQ+qxwOksTVF09uuDK4u77XCYrue0+nH5JlrwOL4fLTjJoTzyVGeLZ
	 FrHhBP+m0DaxNiP1qoQOqMXSn+nUaNasDpmHqC6qOBkFXFA11NNvwnmnYv25JHqDTQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794459168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLCqWlTLv5zUj1BUTyM/Ud/mFd3BD01LgxIiWW/VVWs=;
	b=VEwtOpYmndD7iG4oGtxucsZWKK3T9u2wZY6GpAK0yTLwB7jqv1luLn6iDEsLHqzqYTZj
	 6isqQiV1sT2g7dDzC4gWU0602gQoWW3i090ql4hZY8D0z4ZxshsTfepZFymLo3UxBswxt
	 stkcBQVHqp6h/t1QUM7VvorOY7Ketf/2cWnlyVk1UUyEVMl+yFLd1tusrL5GCMu8vOtOG
	 kMnTgCzV3fb269J2OgCDqBXTP1bpIjI46+tNvm+k6x2fdfPtZBYpeyXVhLvrCcmBbn0hZ
	 qUn8hhxWFYDn9tdbbNDkIs/gfMJTO0FvDmYlZH2bp6aPOwuRcDw4PNl5rNqr87UAimg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cgYkWS91;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226CE606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 226CE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cgYkWS91
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1aefd1bf74aso408412c88.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794459167; x=1795063967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OLCqWlTLv5zUj1BUTyM/Ud/mFd3BD01LgxIiWW/VVWs=;
        b=cgYkWS91Ht9ZcjTwpuDEo2DfmxVNaqoN9+94ev+m6sCB5GbCKRqt/Sid8ohUVtxNP9
         sjTVmiz0Ot+4k485OrG6OYVAOX/xnJ1tfB3DBfq3uRPHie+p+A3WxF25odHiZOUANGT9
         J6s6l8X05k2iHsXWGhjJD9VbiImPAT2ozJec4r4xulPvoDE88MQ6odjhWhh37p7e1gQL
         +6STwwAaMemdRYhxFqbmpZ1Xi35D9bWKDq3z1WRlUdUXu2+pFVCOZIuVLXIImdvqqEH+
         ikN9+Q9hRL5ztxidmI2VCBgue4Bs/EiUkuOn7x/jEVJ/kz5yrgoN3BAU3UWvpSUoDk9V
         n1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794459167; x=1795063967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OLCqWlTLv5zUj1BUTyM/Ud/mFd3BD01LgxIiWW/VVWs=;
        b=qYf5fxXR+g7/HjbzIT6B53CxPcIz/ZuLXl7eKsK9+7HC/GLtCcGt74T79zQPSTM7Dr
         JNGIEaiK3mRDpyg3d5jAUA4F0sgNDLOSSpFSk4OI/krxDP/F/PEvE046IvSoynE0PlRp
         Y7tp2LaIf+YBecByGCF2EimxwucHwC2Usdg1Akqc/+bKmIEEQPKeQ0BAK3TmCcr8e1vz
         Qe0DTt/bRnM1xwP7vLa2Kp8WMTjJy9nIi5K8zmkMUx47RTT46jm9ylgxIEGc1iXNSAmt
         lc6dQmYN2XKOTCKc1n32U21Ugm/Uoxv2id4TX2VZllkiDF01FRPFEjH9eCuW5F9ttP/d
         jlmQ==
X-Forwarded-Encrypted: i=1; AL+hErHAJh6MwScsj9li+Bm7OYNlWUmXel4Z5JD1qnbR55wkmPgQYg8VBA5iq+5yrrILvr8z5U5rcTZDghAu@vger.kernel.org
X-Gm-Message-State: APuU4Z8eMCMWM6VJrFmqFVUkCgsJsdNxPUYcIMnnBcJzkWIyhgiyuleR
	3wprAR5KLlU+k77Ff9XfZJOLxgkeybRpeW1+ptufU6qmklKFu0p0gfQy
X-Gm-Gg: AYBFou2xaViLLOKNBsCiJirMzwtaBtKE2RFTMOaYC1Kpq5FdxjF/lRXhVFKh7qVKwo9
	igPstyRe+XNzMhgpOqyU0+I85WbmTXvaqARYcCleYFUBxbv2amOA19KRW2y8okNp976wX4pAFbc
	g9FPHuvZHqIxwF2ZzJ41NNI+dglLfj1m61nzGtKVpqxltCSnyMXt99ZSlZ4AiT8mvmeH7fLXs68
	KoTs69e8ItMnzWTXH32eNDtOPMzuPMDEt2ivH2Q5zWRk/HrN+muZg0Zbs19COuNBUC6mHBf32p7
	s+o8GfCmZL1YfusWRiTkzB67gm+LFA+8vUEDz4YSUO2mbF0u7dnL45uhaiMEzsneBWVzFsdLbbL
	roRAcqNQ6Jp4UoVCKaJbQBEpfZoErhaxqcrmXE3jsdhAd7m1nr5r3DEBh/wR09LglPhOr4/uvbg
	Iy7vqeORXzTLeyq4cmIrsjmVm6AC6hpsoQWIsRFlwXdBveNAG29Su9kL/Nzev3O/b+CbgvMFJdV
	7jXvWbLQXZXBA51z1prGSv5PkD2QgmITCFEuUbfIuW3blpnIpkEPAXh8wnJ/YVq6VeFuG0SHN+5
	Zcpli1IJuDxa4WMn//80fChjqrii1VNOPm45dvbGEfjVVlZP6jNTxv4dex9HzCSMk4qayx+Ya1G
	CQ395C+RRbm3UCDZm8e/C5X0vA6esCReD519ED2/17FNNmw==
X-Received: by 2002:a05:701b:2313:b0:1b3:a8ee:a0e5 with SMTP id a92af1059eb24-1b4f5e7503bmr1295818c88.2.1794459166892;
        Wed, 11 Nov 2026 20:52:46 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b48a9c34c9sm5378660c88.4.2026.11.11.20.52.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:52:46 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: icb@fastmail.org,
	linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: Re: [PATCH] ksmbd: fix out-of-bounds read in expired-session LOCK check
Date: Thu, 12 Nov 2026 11:52:38 +0700
Message-ID: <20261112045238.4688-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <MESSAGE-ID>
References: <MESSAGE-ID>
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

On top of linux-next 20261105 with the four newer ksmbd-for-next commits
up to a4277e7b7682, under KASAN, with session expiry forced by a
test-only hook as in your notes. With well-formed requests on an expired
session, before and after the patch:

- an unlock succeeds and releases the range; another client can then
  lock it
- a new lock, and a request that unlocks one range and locks another,
  both return STATUS_NETWORK_SESSION_EXPIRED and change nothing
- a compound of an unlock and a lock returns STATUS_SUCCESS and
  STATUS_NETWORK_SESSION_EXPIRED
- READ is refused; CLOSE and LOGOFF succeed

These results are the same with and without the patch, with no KASAN
reports.
I did not test the malformed request itself.

One difference, for the better: a LOCK with a bad signature on an
expired session now goes through the signature check in
__process_request(), so it gets an unsigned STATUS_ACCESS_DENIED instead
of a STATUS_NETWORK_SESSION_EXPIRED signed with the session's key. Patch
5/8 of my v5 signing series fixes the same thing for the other commands;
the two patches do not overlap.

Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
