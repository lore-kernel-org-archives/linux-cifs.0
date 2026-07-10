Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A29199949
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783642960; cv=none; b=KdSq0yHjLD4DRl02cfeoB9kiKn6hSd9fHtbuDHuupv0ainNPfDkxNB/MuyOYHZFLXGIuqmSsdFwJ87nWuBTJhVR8TeyGe9BF9AQzpY55ndfwKqACDf+PqpJHTwU6EL+av+02eGKN/1SKBIc/BZujVs7mz2BCqtO1pc+dkCOG1MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783642960; c=relaxed/simple;
	bh=z8ut3tka8zgh8fThbsEhCCgBt2v4kr/mqupRpNBWJIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHOSLZMXISVmMHLmgdTwGHEExoVnBI6pQytFo7b2/E5DH4Qt+Xbe6509V8msIfg5pjS4lN080XDqImv7TjqCQxJ7hPhumOJSEQnQ9se3VsmkEJpluX4RSsI7vVuXyiobAOvm5FL8AdhIgcBre+XHgD/yQAzniyzA//o0nSl1jh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiOmgVxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiOmgVxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BFD1F00A3A
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642958;
	bh=z8ut3tka8zgh8fThbsEhCCgBt2v4kr/mqupRpNBWJIU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LiOmgVxrNEAX6ediIZcEOHY0rrfeQ3LDmL0xNahdgx0thrIHd5+1V7RiLILhqQxPr
	 dIPs/QIx/V3c8i6UOXLh2BmS1E84djY0B2UctWSbRvgQ5jUC5l5BQDEPHtvRSKG7W1
	 g7xyaiDr3qx9wSwnrxiXH9HpDB5IJUGlnftt4TtVkLykob2ZMLDk9KnJ0SGwuqFvZl
	 hHueB2zCk539aorz8891ndmys4yOp2+rAY8nXzOkgyC5G5XU9sUoNtz4Mem1BEu+WR
	 lcfykrOtI+caY+BaBUn/893GBMgGYOrC0tQJCkubS0RghThnPV5yWv7noNC7xylD67
	 QxeFfuLrBMZSA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15b509c323so64718466b.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 17:22:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YwVmt0zHjbCUu0yDTF5V1BNpfCDtmRzleGxi0JMyPliUAILCcLx
	eUUB3woBlomF86joeQuPh2P2tTj3inatVtge8oqn0eDgWX26+EfbqxAVjUyqOIrhoi76BDOQOy4
	fTWumQRO6Za/rjCFNEz9XDwJ4CihkVtY=
X-Received: by 2002:a17:906:180a:b0:c12:389f:e765 with SMTP id
 a640c23a62f3a-c15ce007770mr340923866b.17.1783642957237; Thu, 09 Jul 2026
 17:22:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709165141.2111-1-g.blivet@me.com> <20260709165141.2111-2-g.blivet@me.com>
In-Reply-To: <20260709165141.2111-2-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 10 Jul 2026 09:22:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Hr2EaeoPm_wq0GZ_tEMP9Ntou+3S-90gXSCTngtYcSA@mail.gmail.com>
X-Gm-Features: AUfX_mwf4-S4ZSBPB2kN_ULHQ0mrySHACewh-yLBwPBlxqPy1VeEGQURTASJNmU
Message-ID: <CAKYAXd8Hr2EaeoPm_wq0GZ_tEMP9Ntou+3S-90gXSCTngtYcSA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 1:51=E2=80=AFAM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> Follow-up to
> commit bb682f1496f7 ("ksmbd: quiet mdssvc RPC log spam"),
> which silenced __rpc_method()'s own "Unsupported RPC: mdssvc" log line
> but missed that ksmbd_session_rpc_open() failing for that same,
> now-still-rejected pipe also trips a second, separate pr_err() here in
> its caller. macOS's routine mdssvc (Spotlight) probes still spam the
> kernel log via this second site on every single probe, defeating the
> original commit's stated purpose.
>
> Suppress this specific case the same way the other site does; behavior
> is unchanged for every other RPC failure.
>
> __rpc_method() (mgmt/user_session.c) returns -ENOENT for mdssvc, not
> -EINVAL.
>
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
