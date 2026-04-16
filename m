Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCD9382284
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 23:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776382618; cv=none; b=tHWkXkG/XtdLva2ey7wCO+jreH5moRIY+AlCCfZ41FwMipwG3v/p2axgxesuuIDtOZMXBUSem9hsbl+l+9yjIxVb6+dKt173WJoGEnXWqIWYp43ygPV0Jxn+AQKwEiQxAHtmVlhcZafpMSfmgJY7NbmzGCKomkAe5RiuZeFl7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776382618; c=relaxed/simple;
	bh=Ia4Z1gW6inXqBnNjZ5tfjmiMCPXDFFfczDlGe0Y3rA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H722NOZgnboxsH1ngHmh9wY82WY0+7iWAPBLn5EfeLHv7cveCr5TZo1SsmNvCKNXMbPJLnzWJdVz79rFv169dazJRAbfHWKmrzN8IlP2m62NepnzNvo6oHypERPhr9EsmjFtcB2+K29Egl71ecrD7ScZ9By9GG0lZIMAl1KIlUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHSY6H4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHSY6H4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB3EC2BCAF
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 23:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776382617;
	bh=Ia4Z1gW6inXqBnNjZ5tfjmiMCPXDFFfczDlGe0Y3rA4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nHSY6H4HzrjG1B7ncgE10nhlBQ7WknRrHPKmbUNXlcwrnhGRl5eVmTSHviyuJXp8k
	 /G+r62TmWTB0kXX+HVImcHx1VusvuKkQjUrKW58VayWTwUGBOKGc4uwzodgJsqA7wf
	 LI/WAQ8QejwDcnGhm6duFABlx4t89+R3CJtbq8PSOJTJEsE4QSDvConlxbRu7JAD6B
	 Xq+MNiG/6yTPLX8Kfm4j4pwHOLUfFVpqLPsygAl7Jp6Nkr3QkP7LQlHNUjDJ4TeI9V
	 KSs46Xda+FSfm7ENDBrbKt/VbnqaNPuTO3x8YjIe77otNHZHtEVj/bq7l7QJgnFGgu
	 IB7INjhGlrZ/w==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-672bd8d2400so108402a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 16:36:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/JdE8vpPNpi1KgsrqwhnQln1/krbhHS5VlQupxbS8JBdXatBVOtebRr+LloDh3VQpc5dfkGk6Evi46@vger.kernel.org
X-Gm-Message-State: AOJu0YyFM950PYZIQibTj4LVn2kl4LFCPeZ4LraAm/iagw0pjugqh9mh
	K/KeSzQHLeWjHX+wsWUQw0DPzaZ2tG6PGXv1w5YKLOs4cXkCNlk5Pyo6Um+f1JWjyaSl+z4ofh2
	iBX4ZAuuLpiQYXs0+vgoLiCQo341BXAo=
X-Received: by 2002:a05:6402:24cd:b0:66b:aa56:ee5c with SMTP id
 4fb4d7f45d1cf-672bffd3a22mr237465a12.28.1776382616452; Thu, 16 Apr 2026
 16:36:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416211735.3558718-1-charsyam@gmail.com>
In-Reply-To: <20260416211735.3558718-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Apr 2026 08:36:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-P=E+bc+3W4DffU4SRtBDysJ+0yhmsxX7LvNB_8vR=sQ@mail.gmail.com>
X-Gm-Features: AQROBzB66y9CrUgy1WHZWYxRh_RXy7Qc-7PMcqfpOvkbqt64rMF7nxAIdWWdei4
Message-ID: <CAKYAXd-P=E+bc+3W4DffU4SRtBDysJ+0yhmsxX7LvNB_8vR=sQ@mail.gmail.com>
Subject: Re: [PATCH] smb: server: fix max_connections off-by-one in tcp accept path
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 6:17=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> The global max_connections check in ksmbd's TCP accept path counts
> the newly accepted connection with atomic_inc_return(), but then
> rejects the connection when the result is greater than or equal to
> server_conf.max_connections.
>
> That makes the effective limit one smaller than configured. For
> example:
>
> - max_connections=3D1 rejects the first connection
> - max_connections=3D2 allows only one connection
>
> The per-IP limit in the same function uses <=3D correctly because it
> counts only pre-existing connections. The global limit instead checks
> the post-increment total, so it should reject only when that total
> exceeds the configured maximum.
>
> Fix this by changing the comparison from >=3D to >, so exactly
> max_connections simultaneous connections are allowed and the next one
> is rejected. This matches the documented meaning of max_connections
> in fs/smb/server/ksmbd_netlink.h as the "Number of maximum simultaneous
> connections".
>
> Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
