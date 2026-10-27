Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793094634;
	b=0KnuvJnhDszjTY4zqDqIFtLcO1RsawITvaJZ+7/DWR9I0uNdoUYbDjkJN86+0+nPN4j9
	 npGXqZkvU4PpUFdQroNOlJRq1zQ33bxqjx3zuFHlkJYUWqXpMcLSxxrLUl72/+p1bGyi2
	 mWzlS8YmlK+W2sXXy+qocaaM06XqIqXyupvpY9WYtczQjhvTYqPujzHlmrVD9v3DPvpXO
	 03dIOPa/nwo/Q8SA17vKMV65TUAbxn0dCDR5VyGwCVVd/Tr/9iWsQw5SSCETxK14Kyr38
	 Qzu2pIVbxUpn0gzhjUTKw5uolqWNjp1jRzefKcv2nzxbjvzDczDbrWT06Hw4OzoE4Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793094634;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0RqTFyVn/l364Pu7jS7dFXzz69K6cCLaLO+gjoUqCcY=;
	b=ETCVlFS8WmmauinS/wX+k09vRkvWy7LRSp3EDvI6d12J5I6V5VAnvonx8TKrRlviy3yz
	 xiKvjKdsJqgo+ylhEjbc+bMDj/5H8KOhJSItq0V8+WPOI1QONCssr/TzLsyRsxcLsG5uH
	 aD6LCAWEDziifuiVuIrPrVZbi/R+2aLoDpU4nLjyfN51/Xvm0pCuMg67T2vGdCMD7mGzE
	 k9c5JW88ZGI8k27vAinskwLJoMRQzOepg6r1XeNooXHQ8lf5Ycjit4+0F3ogqjiIQwkbi
	 HrHzy5eOWkioziVJslxdNrwWXhwtrpNOZ74SB89WebIadxGJ44DHGwn8+dTriFJ5vFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBUaD6VP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D8606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBUaD6VP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9861F031E0
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793094633;
	bh=0RqTFyVn/l364Pu7jS7dFXzz69K6cCLaLO+gjoUqCcY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VBUaD6VPoyO+o2vCfbg3pqKZqdairWQdoPhH7047vnPN/R4AvVaoawlC2ObiO4grJ
	 b0uQ59k0nCwUciSk/kZLz4hA41dOTo6g/+R2yQ3lh5YC4BZuY8eh8RkieLfMXiEFQr
	 OzQ5jr0W1b6GhytEyOgf9K39MrfsCgKxh6tKTwVFerNWlvt7Xy1xiqx3rbf/nOxrJ2
	 J9I7375tSJoCdeUf2UL4pB2D7kuAnPDz+JMfA0LVhl85RnYqamXRjrTFxf8fR0ctpr
	 Qwih9N8jZm2AascskDG1rPL6MGwhj04mG7QGQ8H5aNK0lYQHbiMxMn85/esD/E82Sg
	 B7h0OlZUpbqPg==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-679a2b540f3so3546328d50.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 02:50:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz4jT3eITeMGBBsUboJxtPHfMWyrwxtBjzUO1s5kyJy8qKJza0FQWfuAcMn/s0sS7wQGB8eTPUgSJFj@vger.kernel.org
X-Gm-Message-State: AFq9FYJByzLEn+XJWBSnWa5DImtZsZygPSVk17P2ViB7P4EqvkJZ3Sr/
	30ohTa/w88Z6a24dgoGhGFfLpyNGbLCPInKFBxy/+GgZZp6NEGIuFzzLr6qn0h8/l+XiAe4fRDj
	PHcPVCMV8TavWEKfLeUn7HPm40sEHwWw=
X-Received: by 2002:a05:690e:2510:10b0:679:2ec9:9b1a with SMTP id
 956f58d0204a3-67a4543d42amr3823226d50.64.1793094633129; Tue, 27 Oct 2026
 02:50:33 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027014021.108390-1-icb@fastmail.org>
In-Reply-To: <20261027014021.108390-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 27 Oct 2026 18:50:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_03VQfaneatZURH4hLVBZA4f46tjTubPeG-Tt91cmGMA@mail.gmail.com>
X-Gm-Features: AclHuK90c9Mz02fa-V3lujObRHgoXJIiCvz94FvKUdOCqBAu-HVrqlSq8UtgxKk
Message-ID: <CAKYAXd_03VQfaneatZURH4hLVBZA4f46tjTubPeG-Tt91cmGMA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix out-of-bounds read when padding the final
 compound response
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Steve French <stfrench@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 10:40=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> Compound response handling pads the last response of a compound to an
> 8-byte boundary by growing the final iov and the RFC1002 length.
> smb2_allocate_rsp_buf() allocates exactly response_sz. A command can
> fill the response buffer to within 7 bytes of its end, for example a
> QUERY_INFO whose output is bounded only by the space left. The padding
> can then run past the allocation, and ksmbd_tcp_writev() reads those
> bytes when it sends the response.
>
>   BUG: KASAN: slab-out-of-bounds in _copy_from_iter+0x744/0x10e0
>   Call Trace:
>    _copy_from_iter+0x744/0x10e0
>    tcp_sendmsg_locked+0x2290/0x3f80
>    ksmbd_tcp_writev+0x10c7/0x1ab0 [ksmbd]
>
> Allocate room for the padding when the request is a compound, as
> smb2_read() and smb2_read_pipe() do for their payloads. response_sz is
> unchanged, so commands still fill only up to it, and kvzalloc() zeroes
> the padding.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
