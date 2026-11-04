Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755949;
	b=050+zuaGMzfG8JEg30MrLGfytRsqPYpWyGFsuFlZy2znKnwCueMG/YyCR9UhQ2DI7yUB
	 BH85v25547boIZcW5hx4sth0uElR9CntO1cmVY65sAEUoae4nN+Ov2BE13OQeYtKOy+nW
	 J1CXPvBSmh+d/Vi38uFpheBRmFVuKpPOMDxbvvuCKzHBFA1GWFQ55X6r9kaqmmj5flDru
	 yq90rrPYK7Q/9tT28AmYEHKY4ig79Z/fnVl7S7nPptfwy+CRKWL1ir2FSuuRL3PVISJP/
	 RcyzIxBCdbTkBwpQIliZ/xF4+uL6p5qlsDlUFu7LiyV5AetLnaA5XipWVK8aOC7gSng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755949;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=awrfhiEA42VS0d/8o22Ax5AFh4w7DC/RppH++lqL+3s=;
	b=2Qs3FbVaXXl35QR8o9ZVXWMIwRtz/Usi1S7f6rosnh0uooNQXj1I5lahXY6WPPUYQv/W
	 QFOiNm0tHcytbDBdDe140n9rNaf3aI2UD6rbQdoNdSYMTHMwEoMk89tXjHXq/HARHyjJb
	 eVYdfcW1qRWxVZVPjJt3F71qy1F0KOMdoS5zO/0JdVwCcUBaH2NcG47D2rhAPYrYYQOVl
	 Jblyp8xoezm8vDy7bXNPZYH/Sr0UF5zjz1NLdj9TU67QybNsFfjeS9tSFMsaXPZ+XzTvy
	 a3aAO0dU1nKQmAd3T0QlB0qxG34wbSxuT1t8DMYzoPMqUQCtcgJRc/6MVjJbXcEWefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Xxgv3Ki4;
	arc=none smtp.remote-ip=91.218.175.92
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059D0606A326
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 059D0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Xxgv3Ki4
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zxAAps4yyewUnME/6mVtgZ+mIleUTfY4MSvSG+oC/zQ=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793755944; v=1; x=1794360744;
 b=Xxgv3Ki42ydvpb7lSHHsBO5qwXbkhWUPJlCdOSk0CLQWYpVpPmXfeboJw2zlYezSAMF9EK91
 6Qkl7voEZmqoB5l7TsohU391svxsNdfeDcCUPj50Am7fmSPE7de1jVSHBygK8//WA1my+ZJxGUi
 I/S+jUI479ads0ScFrVWudcwp0opuo7zi9Yjg5XOHLSaI/y4IFcENZhpXYRdCuCBDwzTfB4514j
 UR8nC24kRjYWNwhrK8E2b+Eqa3tCV8ln//HJGt3K2EGBnDHCk4KOFvOHqdDP7ZCS+bGUYIm8EwW
 NvnNEa+64Agx8TCCuukiihLy5OZzxIjBJAATWAF1X7NIw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6b67cbe64defc0e1;
	Wed, 04 Nov 2026 01:32:23 +0000
X-Mizu-Trace-ID: 6b67cbe64defc0e1
X-Migadu-Flow: FLOW_OUT
Message-ID: <e938dcd4-08b9-4da9-afe7-3e05c792abbf@chenxiaosong.com>
Date: Wed, 4 Nov 2026 09:32:14 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: refactor security descriptor handling?
To: Namjae Jeon <linkinjeon@kernel.org>, Ian Bridges <icb@fastmail.org>,
 ZhangGuoDong <zhangguodong@kylinos.cn>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, linux-cifs@vger.kernel.org
References: <20261104010725.50071-1-icb@fastmail.org>
 <CAKYAXd_xB-2c=19qaNkAqB9a9rKsthGy4pCtJg+QW+J6Z23Q8g@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_xB-2c=19qaNkAqB9a9rKsthGy4pCtJg+QW+J6Z23Q8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I also plan to ask my team member ZhangGuoDong to refactor smb2_open(). 
This function is over 1300 lines (900 lines a few months ago), and has 
had many memory leaks and refcount leaks.

On 11/4/26 09:19, Namjae Jeon wrote:
> This sounds like a great idea. I’d been thinking about doing this
> myself, but haven’t had the time. I’d be very grateful if you could
> take it on. Please go ahead and send an RFC series.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

