Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A1C40855;
	Mon, 25 Nov 2024 08:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732523351; cv=none; b=P3hkd6NpW5OrS7puVeLBjfrVsEFdtyarGzOitUa/QOy6Rh3Ue59v89H1EAiHSvDV4Xade7O49yD2kjOFBx7REZG5Zd4ijqB5BrP2Jqshar9ultVTYakU5foRUfSP1ezMzPCDxSfVjErnSsWKjUCIbCSnsMmoVxY5ev86jET12Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732523351; c=relaxed/simple;
	bh=FfExKHNiAR7dVrmIPFcK/ddj8dXLfNXfPJWvbPJyM4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CblbpTukbT7JdJxfeC5r63liZsX8Nu9dYoq/uuVz5rhZjKhFVG7BqOdWf1Vvtgu0bdJR8csurmZ3r+VSSFB7E67pQe46OPB+ph+UcM93+WhvOD6cMltCqN7JdBfIFleynzy+y0N+d6cnP7/8A0i7FM5SqEBmHyo6CEuu9ak1HJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abvTKEds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abvTKEds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39BEC4CED1;
	Mon, 25 Nov 2024 08:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732523351;
	bh=FfExKHNiAR7dVrmIPFcK/ddj8dXLfNXfPJWvbPJyM4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=abvTKEdsdzzNrWLm4q/ZnCkCvwPGKjzmIucP2BqmSYrtkNd7DNSI9ZnMPGAZnDnK2
	 yK/uACr9ZgllQzu+2S02aR5sE7DEbFnhWsemGL+IhpHp5K57CwzjMzYWG5aGWc0bEj
	 XIIqSNqvlBTCqBNdd7p3u8dOgo3csdtrYzlualDxqxMOxEmLkW5JassaI6yfS3iWiZ
	 w3Wg2JLgftzJZXOWzbGsYsl9IjpWfKeyUjQT3SiiiXeuwe8kt4y+wOX2eiaaglPZWt
	 LRFQOQajDiilHh6HNs4O/D3FEUVGHa1brrW7h7md1kMjfx8TiR1oSkggt8IVB/5yzO
	 ppi93gmt8kD4A==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2971f46e065so1603507fac.1;
        Mon, 25 Nov 2024 00:29:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWND3Tm7L9dK0SGvxnA89Ey+hztIVfd3wKMvsdwAO4cCdUPD4W4j9qjRNCxiIKtnRlYz1UBpjyr@vger.kernel.org, AJvYcCXgHUdq0zgdGUZcn/nhpZvTHh0XXGVez3OIL2Bqh7+W1Ce0/ne+AV5Tj7OiQe2H72ckwQuXuv0kFtYN@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ192DvRb6DrcSwx8ueArpttLRrmHBcj1RqHlg+sCWLjgd5j/6
	fnGGj8htrQmm2w1L1V0NjJGZiHTUjt4PpWqI0I1tYOTl3NEog9/ceGUFret10Um4HWSahZs7ryA
	Sq3Z/aWTn39U3VmRKS2jqOdEFP3g=
X-Google-Smtp-Source: AGHT+IGKPoRreDkT5hmee4BbL3QNLSTHFdtjxkZDAh2gjXGW8TkSy0rsZAumeyqTdgrkJRgIW2Qy45YfcwFBnvJ4yhI=
X-Received: by 2002:a05:6870:8a27:b0:297:4f1:1980 with SMTP id
 586e51a60fabf-2971e8409b1mr7202250fac.14.1732523350340; Mon, 25 Nov 2024
 00:29:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125074552.51888-4-yskelg@gmail.com>
In-Reply-To: <20241125074552.51888-4-yskelg@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 25 Nov 2024 17:28:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_W5b_wTeSKqnxEtyd9r+h6tR+aaJDAf6QuEYRkUqLNOA@mail.gmail.com>
Message-ID: <CAKYAXd_W5b_wTeSKqnxEtyd9r+h6tR+aaJDAf6QuEYRkUqLNOA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in SMB request handling
To: Yunseong Kim <yskelg@gmail.com>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, syzkaller@googlegroups.com, 
	Austin Kim <austindh.kim@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 4:53=E2=80=AFPM Yunseong Kim <yskelg@gmail.com> wro=
te:
>
> A race condition exists between SMB request handling in
> `ksmbd_conn_handler_loop()` and the freeing of `ksmbd_conn` in the
> workqueue handler `handle_ksmbd_work()`. This leads to a UAF.
> - KASAN: slab-use-after-free Read in handle_ksmbd_work
> - KASAN: slab-use-after-free in rtlock_slowlock_locked
>
> This race condition arises as follows:
> - `ksmbd_conn_handler_loop()` waits for `conn->r_count` to reach zero:
>   `wait_event(conn->r_count_q, atomic_read(&conn->r_count) =3D=3D 0);`
> - Meanwhile, `handle_ksmbd_work()` decrements `conn->r_count` using
>   `atomic_dec_return(&conn->r_count)`, and if it reaches zero, calls
>   `ksmbd_conn_free()`, which frees `conn`.
> - However, after `handle_ksmbd_work()` decrements `conn->r_count`,
>   it may still access `conn->r_count_q` in the following line:
>   `waitqueue_active(&conn->r_count_q)` or `wake_up(&conn->r_count_q)`
>   This results in a UAF, as `conn` has already been freed.
>
> The discovery of this UAF can be referenced in the following PR for
> syzkaller's support for SMB requests.
> Link: https://github.com/google/syzkaller/pull/5524
>
> Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org # v6.6.55+, v6.10.14+, v6.11.3+
> Cc: syzkaller@googlegroups.com
> Signed-off-by: Yunseong Kim <yskelg@gmail.com>
Looks good to me:)
Applied it to #ksmbd-for-next-next now.
Thanks!
