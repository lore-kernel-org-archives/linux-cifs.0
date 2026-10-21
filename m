Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792592814;
	b=Vpqdv5iss4w2/GDiQGfILgj0fH8Phavem16IdPQ7OOwAD4KfM/Pn0GsmuDXE3yzj4YXb
	 CNAB79Lkdd5ckXB5Qbqn9ZwPU8OKz6TvzG/GWjD1pFClJoJnuF697GDwY22vDvssLC/sV
	 hiGx1H1bXM6enRpuq46XkTWDsN6g2e7US+77SWV8cbpGX5XBcNkvJ2tK7MWuWfrZMZZj9
	 hprAd3r3Zbr9cx5AMaP40gcmNtcCZ82debvwwbv5gdVl3bcG69JiEt5wVtkY+vfS2TBQz
	 qq4VooxZ6hYcHEBykKtwaDZ/3wsnvB5IW2IXVPB8buqJgNX5Ng0pt5JtRJ0VkF768Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
	b=q11i5YzwDW2OYY8+Cum89ja1/iI2gkCO+a1T83/bZutZJRZzQny62CGCgtmc0mqlxQOJ
	 VbPgm2fH1H7hSNmE+teD2PeMqGhksim1DERpOnBA0lTPu2jVZawEY7cldkOok8m5BoIQr
	 s5m95OuLVfl1gzQdhQDmdSByZ4RVLuJFeIM5I7agHZ8Yxu76T6yAOlSHxDvM7OsMXMK4S
	 sxacaeRg3onchv6s8yLAuQlOQkR7yREPMGpU7Mje94KZDX9AQAbH38rkcOWKwOlvwVCfP
	 Byy0UcA1jVEZtV2A8HZ3wDKAaxDroCLmjlN1ygpXT129Q2XQ3T4uC6DgcszZq/aAnUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C1606A327
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 14:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 365C1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so1078712a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 07:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792592812; cv=none;
        d=google.com; s=arc-20260327;
        b=q7xOIYybVk/Cn1YJM8EuMqZHyCtEirHHDgw81CEGNQAIrBd4k/n8H2AVcbowzPlDud
         qPfLBuu9AnfE3LDtQZyS9jqDaKzdukPrXLp3NCH9QYgstkKmxgcF5W6jBMi6sISRfkx8
         gKPyN8OTsNK1qYCNCd47yCkC7WfHDBoeCHEg+t3jNhR5Mxhsac8PpFVwk6O0Ow+FjAJp
         KP9ODYn5NqidzLdyFoXMzeuiJTg2FrwPnl8RYLgf0+n0DQFpI0fb89wlg4p15wwH+Eaa
         e28iTYgr81z7BYshNqY4xl9vqYGr9B2LvT1BXRy1dZRTeRxpYDQBvJ4le75IkfNuHz3Z
         pt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        fh=3zz7QzfNU5M7ec15FCJYbfzNBVb3Vtmavkxl91qlAUU=;
        b=MHmKztnU0Kpf0Kk4K3lBr+az74c6+v3XI5JboVGegZNavE5CRGFglR6cHRKIX+LcmZ
         8mO1RtaSsfp5pFK6XZGZ3rCvkFqQtWJVUrwZ/+qyIls4aJ5cMqiXW/Ik2n3Jy81V9S6J
         a3CT4FtoJe3VuV4RE8rhnpTAKIO4TM9xj5cv3eFlYMS0XFgIRHlptCwOghF9wH7a3Eku
         SDpsnFW94SmCDH2xlJxTqCq8YgoVHZLObRWNAIxrMmppovZOg6RKMtYmnfwb3m9c4sGe
         XFTco48yde6Qzn1jRan5qhM077MIjSx1JB0zkSriKIggIb3JQlCbZpA9ZO7UP9WmZAhQ
         ReGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592812; x=1793197612; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=BRqHAhOJRFQGCZ0436cerbXsvDGcjOTtcEFCOpJRV+nbVKbSAKMl662tBLFTfb2Sg5
         NFxQNyHoxxgYHQR13h13k71ankQp/N0fxgwfPZdFZZwD0LZwBvhOQiky2tnvBNcGVE92
         vpRJ7hzp6lhKrZveGyDGkQ94JZjS5rrim4/SQCOenhyqo5st97RuKWVFwTkWZQ5bTbIw
         iWX7FjROAHIvHplEaKREmJYGpSp7sUQFKLAPhXVjYlSpM8WQnUK4iSviJf2DCzgxJwf5
         mmlBS+ISZT3vDsrX9Xx3+f3KYgz6TnHUVdIwJP9bY9OfNIdfJdTh5lFsIo+qwhCRzOmH
         nAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592812; x=1793197612;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=sJgJ9nMUxT/0x5myX3AXKW4IZZzbRa941Sy8iY9Q1KpOPcx24edu9gqsGMk+Y8Xa+W
         KKjcFBAIHsUCQzLKjyS6NlMs5tlOkak0G2KTtjhFdi79AwigD0YFaoeaNzoG7wyIyjQI
         vJvkPwUZhd9FfX/ZAiTqEeqztmDYX1c8TBMqLZ5eVhX0I0504+EV6wWTTzHvFrTYOQgv
         JcYbQjNlPgCRJPnaBPTT8K7xAF+tYeKCQsCiYs0HBBprFiCwkxmHLZl2j1qk4ConnSDp
         aoVIY6vQ3yAKobFIef5bpOjE3fGt5I6+ei8SCZ682GkEHUBZPiTH82ZSusiLAzEcxFv9
         uHGA==
X-Forwarded-Encrypted: i=1; AKwUvBzQUyJpw/2ge0No4y+yXXXr0ItXys1X7T8OK1A3nPZ9aUyk6r+/bp3LR4ejNlFvELOSs5jeWYVi3V2O@vger.kernel.org
X-Gm-Message-State: AFq9FYKOrsckF4iIVPMtrmjLOfHLzZmZQ9P8FZSRrg6bVZcSRYJyf6Lg
	+t1q0DzN3H/6CqQ/UB7SkRw6GDRU8OyhKBSQj37p2WFNh5ussfFakbI8ONDBac1t7Xom/tl0Vpn
	QOascmDr1a4Vz1fWLPYZb0VJ2afM+/Os=
X-Gm-Gg: AYBFou1nJHZ4ISWb5LM1vfKCUdnYkk/MKOr33sh9I+kAQ/thhAPs2o3e7rD4p/IZZHd
	Ca8t7Dyc6UP0kmdSc1K4wSk8mnQ6fBjbnEkR6k90KKx25/Tv9h1Qx29nofEK+CA/+Ukhz4togpv
	8YZuCRpPVYMXOizpkVo0+/fJZwxGgPiKfHE8fantliUuujI58y2uu3d8cEIKnEdemWYu70o5E2w
	M6801uQ5tZ6jC2Fzswx3Slz3MvwzZH5RZC3kl9mB7bIl0ETxoK7I5EvIcaKFwxyplgA94ZWWSoA
	ny5veYLb87uFpHg/iYtpV5dbRhP4sNOM/z0+R50LWrHlQXeKh0z5ORvKZ9D2+UWsVdz4Ak0c1Em
	1+uMSXhkBwmohDECbs9kUR2jTLx0oKy3EaoV/
X-Received: by 2002:a17:906:c105:b0:c33:ca5e:8ddb with SMTP id
 a640c23a62f3a-c46796b58cdmr190770166b.28.1792592812271; Wed, 21 Oct 2026
 07:26:52 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1792552161.git.jan.koester@tuxist.de>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Wed, 21 Oct 2026 16:26:15 +0200
X-Gm-Features: AclHuK9oo5ZYObAiFZur0ih7xDKEBxlKdO-BvoDx6w0mXhpoTx1_PdEXJcogV54
Message-ID: <CAPJSo4UJPnhLFAYRXE-_M2_Nin6=Ff02AjayD10cB7946MvJDQ@mail.gmail.com>
Subject: Adding dreaded Windows SID-style, or. Repeating history, the bad
 chapters. UUID/GUIDRe: [RFC PATCH v2 00/41] UUID and GUID user and group ids
 (*_r system calls)
To: Jan Koester <jan.koester@tuxist.de>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 13:24, Jan Koester <jan.koester@tuxist.de> wrote:
>
> Hi,
>
> this RFC series lets a user or group id be a UUID (RFC 9562, version 4)
> or a Microsoft GUID as well as a classic 32-bit number. Processes can run
> as such a user, files can be owned by one, and credentials, ACLs, keys,
> System V IPC, sockets, signals, audit and procfs carry the whole id.

Are you Linnux guys aware that this is just a variation of the
*DREADED* Windows SID that this patch tries to introduce, just with a
new name?
Maybe, before doing this, read about Windows SIDs, and why they are so hated.

Secondly, the whole idea of doing 128bit hashes as UUID is not new,
IBM DFS had it, and had many iterations of security issues via hash
collision exploits. 40 years later all this horror comes back. Does
history really have to repeat itself?

Lionel
