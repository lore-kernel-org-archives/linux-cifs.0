Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADC13A4535
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941617; cv=none; b=iDT9G6GZnTEh1qJpmrtLfXqjjjE+7+gR1mXkmKiGzmF45MQ0exK1Zo0HvO9sqNZ61eumuLEd0ediSajpR3yDZ1w5K5xzXgK5s5gPn8Y1zBafygMQP4U9scolRCPE6znjHgRALadcmpAv+Hpa29fUJRPAnP+UexczhLr+JXdApAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941617; c=relaxed/simple;
	bh=4SlUJRZ6lCSLtCoC2eC7TwJ396NKEP6ndS27ONkS898=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D6TOtLBvGEYLDrYrGMxzjXxrrLDFHrbBBrRTKuv7yIGjoDuvvojISrfh+RqNJDYWNZKiBxYEThPrvnudlBhz+Btr4qm/jA6yG/ov1BwjZrxt5/hqp1w2AhHE5Ka1h5csrNfa9nIMsBZpZ469YyDOPn8Q2CUY2Jnti8wHd5tFIpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zq4wA4uC; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zq4wA4uC"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-39b24d114d4so5921358a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2026 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788941615; x=1789546415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=By31MJJOFbdY4DAev1nT7iD7DtFZXUQ34u/cf8nMk/A=;
        b=Zq4wA4uCrghFCyJKgQNkH2SKLrxviMR3hMt4Q/i/pPRt9AL2SgmBptOWE6NLRlRTph
         tW7SGIbeNx/1HejTBDZDdDt1wpzCML9b6NmgQ1+GRz1HlfFrebcdWoF+6bKaJCI4YosS
         Cnkwt7whgT/GKYf1x2gD6oWzzOGFbxwMaYI4wx/pJkUtwHtJk//8NR3ib4UQletbpC+2
         Ya6MKBcsl1mauoVxhfyUTNQh01s8sYs1iPc5Q0NlDFhpjskEzqMPqvoczEBDrHmC9q1N
         NJwXO3mXBglE9gr1tJQ/Ls1GTUgDd194zHoGBAkUF2u4Aydaqq73zHkHxoYgEWrDYZaL
         o9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788941615; x=1789546415;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=By31MJJOFbdY4DAev1nT7iD7DtFZXUQ34u/cf8nMk/A=;
        b=qOBs1Imc88fAXltpgwSs/eOI9XVAXb6nhQQ2JeL4V3piUJrRaG2zStcZMjNypX+orA
         4VlecQepLydaXGvONBKIpmt/ZcQiHNVHtEQneP1ozxpX2YqRiv6L3wH1ivQKQZKvsIMr
         hH22OUgq9PNoZzVcko0sUhhicWR3gOy6JD2loWqZ7Q+gP2IO2xEVhtugUXvWWgwfcbFy
         GP6SC42b1GCxV1I8i5msCZcacgQjpiCVTRuajf32oeT51qCyyZdgbwdg0rgiYg1ThyPT
         9S9mvW4Bj/t/5J9StoglAb8DAGoZ59ABQh2CT0x0nG1hzBpoXnAi1OCqlEJhdoFWNEcT
         0T0A==
X-Forwarded-Encrypted: i=1; AKwUvBwj3Dhb0jH7WeR9ku+Lf8ArTemRsIbrb2ZW0jsBjElkAerlCpgviRUc5Kz6A3YawLHLo9y2Cs5oL1od@vger.kernel.org
X-Gm-Message-State: AFuF++l99ZGGGPPl5Jo9eEpNhlZ1WmJnvveN3cpId36t2fmY4LQtik9E
	N0nNEJ6CDAecIya/XBr+KqfI0qsKkm49ygHgmlgaU+7EiUeUmDf0P1LE
X-Gm-Gg: AYBFou081qLC9KXg1p/+wx3H/xZ0UCd7h53Ulr2PaGFyq4ecBE9TWCnhlQ+dYlYdVpR
	MUTdCj6PSOI6xOstUR1iXNm2mYtQtv1xYpjhYibGsXiDqfIVjYb8I2ESQMt8XhjPqTJHNg9XNon
	DX4WDHrOBdJzLMNgzcajME1i1iP1Hk/SanTgId4rYO8AEia5W8RALwUQVDzQSEdnhGy+qthpbiw
	LADYTS3WNDOl58PBfVDAZ/VHzEbq72dIKRT8i83dehhnj+bQsHH9S1wApwjEGRVClIoBD9fU0W+
	DDTZku4Cu02nwwA2T/WCNpPoyY6rkqcPIlqgw2UHpukaRNdFLj7p1/SnJ56HkIgeE9O/kRX50ty
	X/OsgeciO2Tpe8e4hfefujHhD1gxmLXtHcqu7rwUoemGwAgNrBpUGIW5x3hUQdnGEiKPxYe86ZX
	jYobiPssXX6zKCjwhYUW+J/c/qInH4CxRQqNteYAHoeyg4CoAYpEXPIn2RBx/r9UtvJresRrHPc
	Jv1vmHmF29bWI4HgvvcVvjWzqxKMurOnFoL8WYfYo/wtrfWwQBCtgLiLlLSDtLXIWb4f8wyqFA=
X-Received: by 2002:a17:90b:3fd0:b0:398:d6e6:4671 with SMTP id 98e67ed59e1d1-39b262981a2mr48566902a91.25.1788941615120;
        Wed, 09 Sep 2026 01:13:35 -0700 (PDT)
Received: from ?IPV6:2600:1702:7bd1:29f:8000::1? ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1434c745a09sm10347066c88.7.2026.09.09.01.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:13:34 -0700 (PDT)
Message-ID: <297da587-b4bb-4ae2-bdc7-29749144f5ea@gmail.com>
Date: Wed, 9 Sep 2026 01:13:33 -0700
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Content-Language: en-US
To: Stefan Metzmacher <metze@samba.org>, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Ammar Ratnani <aratnani@nvidia.com>, Kechen Lu <kechenl@nvidia.com>,
 Mithun Maragiri <mmaragiri@nvidia.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
 <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
From: Ammar Ratnani <ammrat13@gmail.com>
In-Reply-To: <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thank you for the very quick response, Stefan!

> Given you have some automation to reproduce it I'm
> wondering if you could also test the iwarp case, see
> https://lore.kernel.org/linux-rdma/20260805000159.321645-2-yunseong.kim@est.tech/

I tried running my setup for iWARP. I used the old "bad" kernel, and the
only thing I changed was that I used an siw device instead of an rxe. I
do not get a hang in that case. To be more precise, I see the following
at the end of dmesg:

    [   40.006460] siw0: Port: 1 Link DOWN
    [   40.012912] siw0: Port: 1 Link ACTIVE

But I don't see any message of the form "INFO: task ... blocked for more
than ... seconds." Additionally, I'm able to list and read a file off
the CIFS mount, even after bringing the interface down and up.

For this test, I used commit 2beb1b31a12b ("Merge tag 'bpf-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf"). This is a later
tree than what I used in my last email, but I confirmed that I get the
same behavior I described in that email.

Thank you,
- Ammar Ratnani
