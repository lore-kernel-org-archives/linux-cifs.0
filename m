Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794829534;
	b=xlq9z5mGo23Bj2cHDY8Yt58mNiD9PruFyJQTwdCQorZHk/f7kKf/MNoCqHEr14s3EBuD
	 5AZ1jqGch1qGaU2bjshiEUgN4ELrd5SF5rjx7RBlp/oGklJkLWFakT6pGkQMkp/c2TElN
	 ZzsL8Fv4vqMRjZuoPdjAGG7w3cfUlh8ULMx6OGv2W0aEmCX9cuphT6bwkoIqm1bxfzQeS
	 nobr7yn9VEBGJTfieRVUbcGOf2y+tMxjL8/lOXd0HdJwcWumW5V6aG8az9ynR5rFVeXfx
	 Qzq1YD2GVDgbl9qpJFS7l91qVxm8PMPSlzz0iT1TJuXBIh3hmrqvalltcSxnkJDjKRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829534;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yNKmdsf3yYn/xyXEK4QOIUERiIN+OHKy+Lj3GXdZkPg=;
	b=ITAlayucGZHLg8K8TebzuJdXraginaSR+1TYij7g2RIEj0Tu+NetoZfHk95f1/6kjaq2
	 xD/1UVYVeBcxX4tAgwR4SWHXzBlkfM+W7eUyPQpTPunT9ysBM25Y23Wfbt/yc8fvdi290
	 o+dbGPNfKFPQ73DQqj5AqPOC6SvIt20e3NwvBMn+yuka6cMtVHGqscBorBEbw2drqqOo4
	 FGROlzQxgGX+weDZRUrtl+QW3UqTtX/WdiaOtlbGujXKHUsTq2JeQxhFAnPrKoYKWygM1
	 749yZvpN9W3gK04bqh+8ZxPuMgHbqYCiHob/VIWh4CYpeGgFL4e9VyuQeMMTt788rPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQzYR3uw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510D606A32A
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 11:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQzYR3uw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2BD1F000CA
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794829534;
	bh=yNKmdsf3yYn/xyXEK4QOIUERiIN+OHKy+Lj3GXdZkPg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aQzYR3uwi0O8puV/x6+awjXSzPCKjZMj2Tsc+VhaA5XCN0IN/L14pt7fGNgI/hVx7
	 ok7ke/n6CwZzLImcbQoVMGBGsU4kgcvwCoX3+gfwjOu1mb8flxhyiLnNd3hBUvk61n
	 75l8aMmHBHiQUkg8af4DFLAAubPhf0j2S7EwoDBlR5CmWFkjCSxkW37EkoE+AyaXSt
	 TFC+e5MlTbztVnJkwd9tjIgewJ4bg6AcEEfKOwedFHLduyaaAA1g+0JYMQW2bhgzRC
	 CACH7ygXas3AotC29Bg3S4naDXmq4T4p2lFIXcxOl+wNChPx15ChcSL9pJzYBBkCev
	 QAvVISz6HwoEg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d427836e9so430988466b.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 03:45:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEmaZU8Y7/J3F6mJkmyrFft++plU5S+neM31iIBobJZRExwYt4Ee4GbL8JvKaI3WiNmBgh/6IQ5dz5S@vger.kernel.org
X-Gm-Message-State: APuU4Z9n4faTBHCGjZteLSLT9F99HoEYNFbx7dnV49s3Hpt4DcVJISE/
	xDaRDn1n6g4Fp3MCLtrYv79RNPH9fR3F1veP13N2Dk7v8MqcOhNcNfz4SJYd8Y5W6fkNRk71TE3
	5QWmVm0zYX2E6yK4/W71DHb3WaikQ1vc=
X-Received: by 2002:a17:907:3f9e:b0:c49:c76f:dad4 with SMTP id
 a640c23a62f3a-c50963b5cf3mr853853766b.31.1794829533177; Mon, 16 Nov 2026
 03:45:33 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116032314.46458-1-wuyiqing@cmss.chinamobile.com>
In-Reply-To: <20261116032314.46458-1-wuyiqing@cmss.chinamobile.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 16 Nov 2026 20:45:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91MdtF+eFJC+wF3xkSjCrZ7q7R_=LN9aEbYp6QdJbHDQ@mail.gmail.com>
X-Gm-Features: AclHuK-X8RoIW1SUKIYSe1a_GK5CkT5SqqFxuAc4qHuW9cQDIrxvuL5lO7X0OB8
Message-ID: <CAKYAXd91MdtF+eFJC+wF3xkSjCrZ7q7R_=LN9aEbYp6QdJbHDQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove unreachable input length check in FSCTL_SET_SPARSE
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:23=E2=80=AFPM Yiqing Wu
<wuyiqing@cmss.chinamobile.com> wrote:
>
> The FSCTL_SET_SPARSE handler checks whether a nonzero input buffer is
> smaller than sizeof(struct file_sparse) before parsing it.  That
> structure holds a single __packed byte, so a nonzero in_buf_len is
> always at least sizeof(struct file_sparse) and the condition can never
> be true.  GCC flags the dead test when building with W=3D2:
>
>   fs/smb/server/smb2pdu.c:12035:32: warning: logical and of mutually excl=
usive tests is always false [-Wlogical-op]
>
> Remove the unreachable branch.  A zero-length input is still handled
> by the call site, which passes the local SetSparse default instead of
> the request buffer.
>
> Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Applied it to #ksmbd-for-next.
Thanks!
