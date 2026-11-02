Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663654;
	b=C+jXcqdKqZ6uHZOaqvJULrKYcGrcD6QHBZijSed3lG5PA62x7JUdf5bFEXNs99UdDPtf
	 ua2M8j2g8MedQ7Bjfvxz/tZn7GZUkQkcwUrgu6k7BYbXMkHeqKCXiyLsjIS8WipTL9B4t
	 r0YNRV2L/AAJR9ewH69Gzf6zVsGquMwV0xE3qGemv9yDijPNAgFRtFCJ3aHOPcGofRF+x
	 BcqtXWI4apqARZZods3bnogPV97qOX4XZyUKOYxf3xsDPLBkvoXJPnfQqZqyygLJnodF+
	 coC1hOdYXjlKmUd41MxgGPZeyHukj9KR1QQJ24dnfE7Z9LzieuGOU4UDVtHez6XSYFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663654;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+UqSyir9zlJtTj6oGLIp9AFPvgL5F/23wHoJo5ierls=;
	b=fah6ZDW7C0+pPDlhP+rLdKAk9KXjRUOtCK2/tKiJXo4CLRCmuPv+OHb2j+9pyyRb2AQ1
	 VXbNVc1+CRNM0/LoYXsCT2PDYN0FX6O3E+kdYAsfhdMpMlh/253V8Blon1PyQ7uuKC9Qo
	 Nj7moVEfYLbTIo8vUOqB7QmTAjzAaOvzKLtRwrpGLZByAFX6bySVI5pb5CgglaDRqk/9i
	 g6fNtCxKIUV9kc5PYHxNw4O8Y9LyTDxS+4wOvODK4AiV4E2PVFcS5vWP+aXTHXMDJSuLx
	 m+t1DzecGcGxFimN3MvqKV1a7HgduDiFjPixG5pWAjXi2T7Zt/h9OZC1D9z4RAi92eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lChM+1O7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4AB606A324
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lChM+1O7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97831F00A1B
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793663653;
	bh=+UqSyir9zlJtTj6oGLIp9AFPvgL5F/23wHoJo5ierls=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lChM+1O75/pz8GnNKwtFDREVmqSf1W++CekSa/AKO8SYp8u5C8LP6XHWXtNQhSXpK
	 OPAuJMpsoI7q8iDybVE3Wtsq2BCVgj9UD3lSCNHejpt6cq14FrMn8ubIo73ywKi/D5
	 AIwe5gQjpMbRaD5BLymxg9eYp66tauf1xL0EMdZtE1NpTBQlx76mUwqd9DpLbNpIJi
	 cjCv3OdG8Z4GWb1FfApBrXnVV/Rj9OI6LCR9ji87+hjTolIbQkzjEYgyTvGp/uPRkS
	 fGKxqDXuv7RzRC1VQwsMzrYulUDTuwA8ceENOkGwUNW7Aikjm1brN3xI+dmtUnE9LM
	 WseOHDO/zV4Eg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c43373ae89aso542778966b.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 15:54:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxhZ+24ItzD5bIS6+hJSUUM+7hcxtUycIktSrjbOcBqIZAsbwDnAZiYiQZzQaBCKEbCw6KXK9xNVPfr@vger.kernel.org
X-Gm-Message-State: APuU4Z/0Y59LovXf2pDBJgpfS4J81lgWsu9h4manhqwrixOBFRlsOZPU
	fqZ9x42vb8Vv3AFVjepd8AgsAjtwgqHjYQmR3Dq2uoILC8UJFSYo9m/Hfg3kqQFEdBX7sjzM5nS
	jTg063f+jFvE6B4s9rKs+4BP1gph6bBw=
X-Received: by 2002:a17:907:18c3:b0:c26:22ae:b66b with SMTP id
 a640c23a62f3a-c4ca7aee966mr947443066b.15.1793663652482; Mon, 02 Nov 2026
 15:54:12 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179362071771.29269.6848836845989806334@stu.pku.edu.cn>
In-Reply-To: <179362071771.29269.6848836845989806334@stu.pku.edu.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 3 Nov 2026 08:53:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9G9VKLYzsKMqS87yj0KLxSjis-8iAAegnPdDzdpv=vGw@mail.gmail.com>
X-Gm-Features: AclHuK_ZiPl_8EII_1_G4Hx1xfHmBmUEZKMwbV1xvMdMI83u3u7g6JkbLF7jK5g
Message-ID: <CAKYAXd9G9VKLYzsKMqS87yj0KLxSjis-8iAAegnPdDzdpv=vGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: bound invalid NTLMSSP signature diagnostic
To: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Steve French <sfrench@us.ibm.com>, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 8:58=E2=80=AFPM Yifan Zhang <yfzhang23@stu.pku.edu.c=
n> wrote:
>
> The NTLMSSP Signature field is an eight-byte binary value and need not be
> NUL-terminated.  decode_ntlmssp_challenge() prints it with %s on the
> signature-mismatch path, so the diagnostic can continue beyond the receiv=
ed
> blob until it encounters a zero byte.
>
> KASAN reports:
>
>   BUG: KASAN: slab-out-of-bounds in string
>   Read of size 1
>   string
>   vsnprintf
>   _printk
>   decode_ntlmssp_challenge
>
> Print the fixed-width field with the bounded hexadecimal format.
>
> The patched kernel reaches the invalid-signature path and returns -EINVAL
> without a KASAN report.
>
> Fixes: 0b3cc858003b ("[CIFS] NTLMSSP reenabled after move from connect.c =
to sess.c")
> Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

The patch is quoted-printable encoded, so we can not apply it.
Please send it as plain text, preferably using git send-email.
Thanks.
