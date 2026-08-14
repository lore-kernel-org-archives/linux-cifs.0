Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858801DFF0
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686875; cv=none; b=WiyR3Ay+l6xwbnTgXAcLok0f4x7oCnHqR7F2G3oVINRkaP7irARaoTwiwfKhwIpkK5t1a17GcmwDZDkJFA3ybz6f1l44ocLZyc9VGdP5lzxhuNwQRxwhDbn7I7muM3BUzWPPu0AibGNxvOBi2TyPPfb7v9b0gi7PjzxMHT/dpsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686875; c=relaxed/simple;
	bh=LrKbjFwRL5xXz7a4zmThyu0PrqpKPF06VSfelDlpA/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BByVi/hjkLBceN5mCCXfSQHdKHkVRl5l7jjkK4nk9dwWhC4Ad7QDxR5ba3g0ad1DPEeYizmVWlW49q5Q9BJ7cO73YHNOijCQZhwDbvRYQftRAmBOmJBgDKrxxTLc6jl7bUadQRXQGB6MAPjxrt0lZujWqZ4ptznwdji0UwPdyzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LU9RMq4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LU9RMq4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564B21F00AC4
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786686874;
	bh=LrKbjFwRL5xXz7a4zmThyu0PrqpKPF06VSfelDlpA/4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LU9RMq4+BnK4e7QrvimSZVrhpIAl94qBu5XRRCu0MoA7C3yXWi1l+jgbxhm7Z6ZPv
	 jfD3AEhZ4v2peXPTGtKCnszNhZ5df4JN1BMWq9JEY+Irq6OIvGh0rfgeUPP749x/jX
	 6PsCSjGSQFg++vFs4TKE7J9mzOJpfJ8hdaoD9y7wj7tzZR6kM+vBIMB/j6jj+IkyEU
	 oXYSsShnoqpOJ2fwJKyVHelwYBB9AkiCEgDJrBO9tdbJ6HnV/B1G25YZzY7iPUozOL
	 mnQMhLud+1zt0THjhrU/7En9qsVB2QTb/TyqOGKzCUv32yUVbKf4Xcd1bZApvS1Mci
	 OM16mnnCpCe+Q==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c197eaaab00so129615066b.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:54:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqbco10TaldJs5eT7DW7FvFu/7xDAqpA1qWJXgFPwlnkGNZuADa4doVHV2D3MSBVyHVlngfRxxwcTmZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzenmayFj7H2T+REcRPfwWpysxcISaN6Z/oR5Dt/1X+7maymivh
	DxjZ3GaiVC4Q9ScKEYsIVSD+V53gyJpsaOB42QwfR94ue03AnKf3cEw/7MHxFOBgQU2mfMQ4Wkr
	EuRaHd9Z8M2QjJ6cARdVWol79jt6ecu0=
X-Received: by 2002:a17:906:730f:b0:c1c:2aa5:322b with SMTP id
 a640c23a62f3a-c2129b5b1ccmr148451266b.2.1786686872720; Thu, 13 Aug 2026
 22:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com>
 <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com> <CALT=-84nzBrQx62WgOkdQeDfB6+75O31uPoN2hAiBO=xO=tnWQ@mail.gmail.com>
In-Reply-To: <CALT=-84nzBrQx62WgOkdQeDfB6+75O31uPoN2hAiBO=xO=tnWQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 14:54:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9REpfSFF7Ch-sy=C1zXfEYXuDNK8OaTXtBqN=9J=n=Lw@mail.gmail.com>
X-Gm-Features: AUfX_mx6JtdNpWYOUY03A-F59AQIRHBla5M6X8ExNMfnd570nxutRz7qmUs51ZE
Message-ID: <CAKYAXd9REpfSFF7Ch-sy=C1zXfEYXuDNK8OaTXtBqN=9J=n=Lw@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com, 
	senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 2:51=E2=80=AFPM Blue bird <obnred@gmail.com> wrote:
>
> > Can you check if an attached patch fixes this issue ?
>
> Yes, it fixes it. Thank you for the quick turnaround.
>
> Tested-by: Kyenghwan Hwang <obnred@gmail.com>
Thanks for the test! Applied your tag to the patch.
