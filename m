Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E498686329
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762259609; cv=none; b=o4qSYk5Bq3E2ocAr5qiX2ATD3+vdVEtW4LXqrGI5dcnMnGTbtJaJG+aIdnWHh+U2tayhVvtwZ4WFTc0TtWBU7ROrMBoqmykM/pUQDXOw10yOX7vJG+7hvfWNXSAo9aNZBjlH9gDXVP1+MjZjW5qg3n0gaXg82al84GoM+9M+Yuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762259609; c=relaxed/simple;
	bh=rvu6O0E/7DDQAPj95W4jLS6+wxWIiNJJleMFtELomlU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aaaGKBbBj0BdJbxJ9LxjcX/fKCx6/JJ7TITVV4lxAIL7MA75cYJccMEfG0wkv2L1qYV1GxqoKo7yqkzx2dfCjaJ6MUD/wGeilxsJQj1Dd46ZealBqXKRZVPzKB2zYLaVabBeUEbP1m96ZbqE2Ag4E9ubiE3LL0ueKJ4Vf96JJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OXuDU95H; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y8VxjrhB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OXuDU95H";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8VxjrhB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762259606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+n3IR+AGm5h5aAEd+ooyhPcJs+3zBjyrD/S6ttEIHg=;
	b=OXuDU95Hk3J0WPFLcGJs2ychYOtloAw9/IOt40heLkF5gidwyIlZXJT5ehHbrZx32LC373
	fnvuUEoiRp8Fyri0pMZJZnIEdcozPPiDmcq2krmFn87LJAjrb9y3SA+9FHpqO5PpHcr2bu
	/EBxqVwJbwrdiXV3o8dZttwkiaCmRtA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-ocjfzrglMeGvrxYtP7YRIg-1; Tue, 04 Nov 2025 07:33:24 -0500
X-MC-Unique: ocjfzrglMeGvrxYtP7YRIg-1
X-Mimecast-MFC-AGG-ID: ocjfzrglMeGvrxYtP7YRIg_1762259604
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4721b4f3afbso21481055e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 04:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762259604; x=1762864404; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+n3IR+AGm5h5aAEd+ooyhPcJs+3zBjyrD/S6ttEIHg=;
        b=Y8VxjrhBIi81w5mWliTL1aJFYNOnIeKVI3j3x3QjeVPI0Q2UQs75iITc9WnujdoQq5
         Vc+sSlyMA8aBrEBXgkRInWxb0RXHuEtFWRDyVeeqO/tZJn9Yjx2moWYxCGzHtwFQHyDp
         SvFioVZYyLNCt0nj7mrPpYtbi8GaU6MPqOJth4QBcD/nkNPIrsEWBFj2Jh3dxseaq8g1
         AfpUdTJQXCvm98dKaaKZVijxSxZzjrYDdZdK6Z+Oy+mRlKLT9lLc22hvkE96MKZqjVUG
         MjKnNb5VymksBELwW/YJl7JBv1az5hjPnJfvGPWWdGoZODC1JsGzlGhb5BQBIoZluwSd
         2/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762259604; x=1762864404;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+n3IR+AGm5h5aAEd+ooyhPcJs+3zBjyrD/S6ttEIHg=;
        b=LXNXq2wchjxQIeEs3kOXCYweZ3KmdCtsN/wlyfaZekDjDqb26K59OQbu/bthfn/ZMx
         kkBQ1BetGbHseplH0DOBw2IXqNi8f8puZ4cUy1StyiHp8Gbm58XTvpQhkhNlBEHkB5Ds
         d282twF2RGEhtkQQLvZMmw14+cfcCdpxd46RccNpV0af2GLHNeNCJkhf5/e4Gz7RqM+G
         toXRElFUlbzQulNlFXXZZeKeW5sLEFLV2xLDgaA6iqy+52owSfDMMspA3Qj3PaExIPLx
         Vctcdu+fcl1zNy8ux7wr40d5/Q0CQ+DHYAsm+jwNUlfEin6SC+d12+2iSJ0ocIvoUaNr
         vBXw==
X-Forwarded-Encrypted: i=1; AJvYcCVnYFY354D3lbTTL9kRIBHc3Vt+SbramYguET+OCd6FtcEmPNC/qXNxlt/LUk07WR0wSrSW5rW5LLfw@vger.kernel.org
X-Gm-Message-State: AOJu0YyW0NV/cmL4dnv1FWe9DvT7l9CSXrfucuRJAgSLz/V7c2zcaljA
	qF7l2xO3JSxc9/7iJqMluwUx1sC2ZlHymDoFEN5j/Xav3vubCj32VJ5rvPBtRsHupxR8XCO1xoM
	t5GROCMjRgWP6UhAhJQtC0Y7B+KO3ShBb+QQhn3q0GdEhSFgv/CPkfhI/uEPcAuM=
X-Gm-Gg: ASbGncvQbxh3fcox1AXYBYDlvs0FXzcSNqZi8ttl4eaBoWnJJXkzfs1bG6U8O0aieL1
	foxesrAqUoFYUdVqgg6z3xLauYZmtQsLCzPYAGIuv7LigFd+7yNu+vZTPZjLMKpbG+eHMTrp6FL
	xUQ1VkLt5A/8wnoOeM9oExxNbvSzSA7kaQ6ZRuyW6XisX+DRTbSjHF54h+FbbP8Q+bJtPdQvmjm
	rtro7cV758GjjXn+RuwE/flOUoyQV5Q6DSR09KqUlwfb9UZua/2CLs0huyowZrQeHTVCp7/YEDt
	IhaUC3PsAMzeANTzgSZldj3e66JGlXVi6uh3LxqgGluLmg87AQKke78vfj6NxNvtf9RNI0lyKSz
	VXcHKFN5TOaiX0h9of8elksW04g14mP1S9AGvc3aMSIQn
X-Received: by 2002:a05:600c:a086:b0:477:5582:dee3 with SMTP id 5b1f17b1804b1-4775582e17dmr21786615e9.23.1762259603577;
        Tue, 04 Nov 2025 04:33:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEW7XZAfAI36z3n3gua+YP3lVHEkUX5rYhKEKRSMwAwl/px8xmvwUV2n/8i+Vg7lzMYGCOnZA==
X-Received: by 2002:a05:600c:a086:b0:477:5582:dee3 with SMTP id 5b1f17b1804b1-4775582e17dmr21786255e9.23.1762259603207;
        Tue, 04 Nov 2025 04:33:23 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477558e695esm17324625e9.2.2025.11.04.04.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 04:33:22 -0800 (PST)
Message-ID: <3618948d-8372-4f8d-9a0e-97a059bbf6eb@redhat.com>
Date: Tue, 4 Nov 2025 13:33:20 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 13/15] quic: add timer management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
 <cc874b85134ba00f8d1d334e93633fbfa04b5a9a.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <cc874b85134ba00f8d1d334e93633fbfa04b5a9a.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +void quic_timer_stop(struct sock *sk, u8 type)
> +{
> +	if (type == QUIC_TIMER_PACE) {
> +		if (hrtimer_try_to_cancel(quic_timer(sk, type)) == 1)
> +			sock_put(sk);
> +		return;
> +	}
> +	if (timer_delete(quic_timer(sk, type)))

timer_shutdown()

Other than that:

Acked-by: Paolo Abeni <pabeni@redhat.com>

