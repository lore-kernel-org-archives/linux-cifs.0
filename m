Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792898198;
	b=vmKh9v7GQYYhcXGzGRjHYPEnY1710jUWNWEe/EadG8G/h89FiTKXw0hT+W2WYUTPr0rv
	 /YzpAR4HYq6D648HknJfTBOKy9vR1I/hp3lzYTr3jD5jQ6M36pp2naouVKneQ6uUMHDr8
	 Oe/iHrW/8Sqxo1F9ac41bKYJXQ7n3jhhDw3WJAdpR5hg4h0wTrobFqp9UY8UPkQ1o6Ts7
	 Yufk8v8X/X4MWZA1I0VDulVWJLSrCVWJFbpOoxF16GC6qPViGlipRu27suZpxOTj61n+R
	 xdKM4k+1+hvhp7hvINv52p3qKoWfHdaAO+EMq0K6Qw2u7/1THzpNZmycGyZGHjDsCFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792898198;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XKFXrKYRPqU7qAVWjY0wBkwug5TMC39sgy3bzrYOKQQ=;
	b=KOVDHGsJd6kpqDgsXNp+0qZgfJ0RUV6Z1mKmerPS6iuu4tn34zkv1MffDUVapXXOyYXb
	 DgPZBow8N8EPKVmWku4+AjrhO7R/ZaDJnOu6Nhdc2wC7MuIOsAiIuv65kjvsGcCoLS76w
	 UtMhvykOO6/7bbff8utxV+6RVRy77hozuMf/2DzLNPRU/Al3nMtAFfhhlbr8a4NhYNp2E
	 vnpayuUNxxD+Bln2IqNqORVXopZvfgxjUbj6hXbKit3n8t7CjwchkQAAp7MEzPGch6HnX
	 y6xlAvj8lT00Lpev0CBCA/MeGBZx8sK9uL3N4OgjnV+8O9Dbj3LXSqMZJhZ+Jljasqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDf+nn1m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE7E606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDf+nn1m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DD91F01829
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 03:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792898197;
	bh=XKFXrKYRPqU7qAVWjY0wBkwug5TMC39sgy3bzrYOKQQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YDf+nn1mBKCjk1D4pflG8c8QGRGzUPRWY+K47yTkG57gAl7D83GJ//mCD0SIGtUU5
	 eF712T9OaOkYCcCFm6i2fC3+QFhcUbiOqf+KIfUx1IfqOCJrDk+NNy9bXNbErw5Ajt
	 6teQL31sLh6jvYwQcx1lVR31glfwydJ7JkqRb2IEhSwT2VuZ7C6c6CA/OgCkw+G79C
	 Giyr0A1cpZVCYqO5UDD+u7MGuqNjHb6yTqb3ki3xAlxurnargBG3AFLasdk9n6vujW
	 g8MBEb2/Iwc9nCJV6D3nZWqtSf95LvxhXbn+vsCjpb7mvHIkyIimjeCvvh4qIE1kfv
	 7ziqFAb01SrBA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4322d310e7so297270766b.0
        for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 20:16:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxnRBG1ffBhAurc28cPKzE6cVCP1Qm6xBSGR6EhSBaMkRUMfOxUhEp289QkyP7hPJ0pxu/cqBjXTQFi@vger.kernel.org
X-Gm-Message-State: AFq9FYLmI8AQEZB/STeVPy3RyOlQn6N2ii7l5P9NNIfEq2hIKTPZv8z3
	cwuXX1sG3YfF09KZUlbOVbUcey9wzGy63hUnFVQCCpwRfvGyHkdfr4h0OU60Pvyxk3oaCI8fyGx
	B1pubEv+U9hiq5laThrDlU4er66S7kpU=
X-Received: by 2002:a17:907:a0c9:b0:c1c:4a80:30c4 with SMTP id
 a640c23a62f3a-c46bddf651cmr394166466b.11.1792898196329; Sat, 24 Oct 2026
 20:16:36 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
 <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com> <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
 <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com> <17D8C477-341E-4D81-B585-56629E155153@gmail.com>
In-Reply-To: <17D8C477-341E-4D81-B585-56629E155153@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 25 Oct 2026 12:16:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-228tBUbzmN=+9wHSaqh2Yzy0rMCTqCVnhf2HYJcr+dQ@mail.gmail.com>
X-Gm-Features: AclHuK-M0QMLkQXxszaLeDJfQ06h3xcJGdAt9OztCscYVpmMPzrFI2ZZFsp3z7E
Message-ID: <CAKYAXd-228tBUbzmN=+9wHSaqh2Yzy0rMCTqCVnhf2HYJcr+dQ@mail.gmail.com>
Subject: Re: ksmbd: AES-GMAC signing support?
To: mixalhs <mike.michalo@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 25, 2026 at 1:14=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wr=
ote:
>
> Hi all,
>
> A short addition for question 1: x86 numbers and a Windows test.
>
> Setup: 2 cloud VMs (AMD EPYC Milan, 4 vCPUs), 3.56 Gbit/s network,
> ksmbd-for-next + the 2 patches.
>
> Windows Server 2025 offered GMAC first and ksmbd answered AES-GMAC;
> a 1 GiB copy to and from the share came back identical.
>
> On x86 the slow part of the library is CBC-MAC, not GHASH:
> aes_cbcmac_blocks() has an arch hook only on arm64, so x86 takes
> the FPU for every 16-byte block. Signing 1 MiB, MB/s:
>
>                     HMAC-SHA256   AES-CMAC      AES-GMAC
>   library today            1494        207                  1174
>   with experiment       1670      757 (3.7x)          2475 (2.1x)
>
> (experiment: the arm64 GHASH approach ported to x86, plus one FPU
> section per 4 KiB in CBC-MAC; lib/crypto KUnit tests pass.)
>
> End to end, 1M reads: HMAC 449, CMAC 341, GMAC 469 MB/s today
> (HMAC and GMAC at the network limit); CMAC 400 with the experiment.
Thanks for the update. The results look promising. I've answered your
questions in my earlier reply.
