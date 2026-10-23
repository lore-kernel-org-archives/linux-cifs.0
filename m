Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777705;
	b=jsMqUIjkdEJsMSPelJZ13KNvFHcooOf+lRUSPzhnCbdqG8cQ6EtILCQmjDI9j2uupeWF
	 y3OpFYgFLOtXPv+nxIrRychMiqpi2XWzeJLV7kXeKfSPchbUMh8HiRF+x+SpGi7egDf81
	 iwk7l2VI63vf3VJL7Tv58AO50cIlG19VPDBSW+gfS+ot2aRZ6e1RnqH94/vuTknY+3VKD
	 nCypYmgd9a1H+lt8sHJd0oZiNmPnFOfjI/CsxrEDFyGRXi15S2S0LbWsxKSIVty4awfMM
	 oLIGwS4yfgxorPgdSmcAHCOp5VVwB51Iw4+Ly39QM7qYmkj0+6DZJYwtwCho7x6vBww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eXjhl/muhSYc3JZvkf3le3KeLMNcjlVnf0zA1wHM+OE=;
	b=CWHBYZWO3lJtL+jg2iBiz8hqDyiaymBJOBwJJyNi95zMGWpNf58tUVOJVnTIx5TUWCr2
	 UTZKIjMU/1IWx8sbYgxk6Qi+fMsx+byW1vhfxqa8g/fixZ6J0CHq9VduhBuSWJ+UYI9Lq
	 J2Umr0yO1mkyv850x1m0C/wNKx0NdkZ/FGEfHDgNec/N03pBkePsG9nA7mCL+Mx0mKw33
	 UiTM5YEqpLnE85Rki9dTk8tld6RDBXwQD4o2H5YEHpsH/4S0kQfcK3hJa0xesR6txYBxo
	 C6XLYaeK+d7aTaNWstRLVRi9Nk3j2r8MTvwXHYqQpp5a+2dgtooY+rbD44YVI9kor+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=o650go5V;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FE1606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 17:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33FE1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=o650go5V
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1ec41d8e9so1229225a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 10:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792777703; x=1793382503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eXjhl/muhSYc3JZvkf3le3KeLMNcjlVnf0zA1wHM+OE=;
        b=o650go5VaL1cq/qa4aM55ghk7g/QMFZXazAWMvnWUp8hlV3RMKaeFHLi9KI+20fns9
         JFU+fBrXxsFbCCZbZMEGXecJWc/9Sl+hYxEMVNtBDauv8LZAvDf1pmBA9vyA/neXfFBK
         Y5uEJjwBZFdQoOXrpvs1XOCgqy55s3ICHAJX+ebEjRzGQv5GiPITMdkyltwSZFmYjtA9
         4891WB/f/FJGB023NNyCdiOCmKGS8jiUcrlrWfx15A/jeJMf96We2c66hwuxnOj9ohPm
         PHwXRGG8jmO8McD8jmtzUJZNlugpViExPX+3Cn47aQ1bso8ym+ILMhl/sFG+45DajLqw
         E+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777703; x=1793382503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eXjhl/muhSYc3JZvkf3le3KeLMNcjlVnf0zA1wHM+OE=;
        b=uZ+C7ze0EOjAlOxJdzLGCgPbKy3+0mt2sqmrNnNX8b3/++HQZdHotINS0Jq9R+9SPF
         M/zWOhDPpazqZeWHwBSua/hxahgtXzEKe7UudAzxh7bd/KFyE9oiJgbkCG7OJ9sa7NSs
         fd22r7vfxnIivgWpkiTx59R5uB9KNd+7S3IaHfeaZ71IwvHNlSHCgX2t72YsYNXGnVai
         wUEajvy6+u4+vh/s02HLwOhcQHiYVjXPG/eR6If4jyzU5ayidgM8XlsbQMy6jxtPD7k+
         7iCnt+NO8n+6LnELypuRZzHgVCgqVCu9K/gV3JLUC6evcPalVMkhKOZIjeIL8ajxxC5t
         A/Wg==
X-Forwarded-Encrypted: i=1; AKwUvBy5QWJwFlVHYGcRCd9b1EydMGTqc/OvJHpykCtpS8Z6h0FEKUZP50oAgpyDtWA/iqaMwcmSkgY9N5i2@vger.kernel.org
X-Gm-Message-State: AFq9FYIQoaxGJNBlJt+Fh8MiqdrHeHLRpM+toM1GG0HQvqXhom2l8fLi
	grXF/gquHz2NHvthPqNz/F1u3Qou0738pjfJzxwT8pcVbAqN5Oq2bkfQXSdnKwLWQ+0=
X-Gm-Gg: AYBFou3t7VE+KZy40PQdIb4OxV+84EZIcvXseIYYCgvyMDA+GvS5OBh0hz1xIHGAjVt
	xotCEYFRS5niw7FM1HQHfGDpJbPmwExL2BQEA1+8qzeo8xPo2H8mpoQ8jJerdCDUvTreBe0Et9c
	KHksEMBYoQB75HGB7zp1XIjvZzgqTezcgfXiyLf1QbIztK87RD1JZPZOR0BpA6xoAAUqWUl9YEB
	J7K7FP5XHKIKoaBMez0f5ePaVlc9mJYkP4yXYLG9HJr9KG1KlaLH5Kyi1eY/VHjcetnAOOw4joo
	Ro9l4NHsMgcHvRmRBKuGbltYZJsXmzuzQblowcjkMO+3//i7cwH8i+0i4x+7cFZBgABi6++2j1+
	8TSL/MTGujAjUtWH9fcs2veGffYVf7RbwTyeLiifX0lxGu4Y6bn+xHwUMqUA1BxTW6to8sZRu1c
	IijBiGD6rlfHwEaj2wybtkC8ygkHnGb1sVJntOaXBt5s48zvjYCFZaZxsL1RsY1e7PZTofKBaKH
	rtb1gSk6PdoSqzS9O8Dsi6TGoPzI2lwvGSA6uZe3fZZPe92jRnWtcNzFNQLYaf6ao5WiGo2WXfF
	v68L0oEqWB7QH2ZVFNS8Q0NjvRjg7ijGStR20RUlR2CprmO8xkPqx0A0vFOyYsSRzya7qFn9VOH
	n596JHP7jMbA=
X-Received: by 2002:a17:907:d1b:b0:c42:24ea:3220 with SMTP id a640c23a62f3a-c46a926f252mr449665066b.31.1792777703317;
        Fri, 23 Oct 2026 10:48:23 -0700 (PDT)
Received: from localhost.localdomain (ip-80-113-117-72.ip.prioritytelecom.net. [80.113.117.72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46b8da997asm25018766b.79.2026.10.23.10.48.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Oct 2026 10:48:22 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org
Subject: ksmbd: AES-GMAC signing support?
Date: Fri, 23 Oct 2026 19:48:21 +0200
Message-ID: <20261023174821.17552-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Hi Namjae,

ksmbd currently negotiates HMAC-SHA256 and AES-CMAC for SMB 3.1.1
signing, but not AES-GMAC (SIGNING_ALG_AES_GMAC is defined in
fs/smb/common/smb2pdu.h but unused), which is what Windows 11 and
Server 2022 clients prefer when it is offered.

Would you be interested in patches adding it? Roughly:

 - accept AES-GMAC in the SMB2_SIGNING_CAPABILITIES negotiate context,
 - sign and verify with gcm(aes) over the message, using the nonce
   from MS-SMB2 3.1.4.1 (MessageId plus the request/response and
   CANCEL bits), and
 - keep HMAC-SHA256/AES-CMAC behaviour unchanged.

I would test it with smbtorture's signing tests and the ksmbd CI
tests, and check the existing signing paths against an older Windows
server I have access to.

I have exams until mid-November, so I would start on it after that,
and as it is a bigger change it may take a few weeks. If someone
needs it sooner, I'm happy to leave it to them.

Before I start: is anyone already working on this, or is there
anything you would like done differently?

Thanks,
Michalis
