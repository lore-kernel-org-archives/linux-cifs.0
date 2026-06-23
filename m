Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6161A3B3BF7
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201869; cv=none; b=lj76R6NhwRwp3gbTnt814/gq2O64hOj/0b0YF5LCUKRjus9OdlMgc6f99moyWmTAbcnP/xxJtdbAEeZEEAo1LsrJUE0rih/hl47Ei/nIrIvRxX134v5f1XOjsWaA/A/51vdVAqJD7KWjS2X/W1mtDLfTdU78TZ6H6kfTjaYWVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201869; c=relaxed/simple;
	bh=MNXPWIIvfxWd9huKq+y4pmUNQVKAopjevka2TvCheUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9tVqVogQVb/upu/tzUtP3V0MSK/pSCngiqES35aF+nA6ZU01uXYAnSdCu5YwIzWT7aCHoIvGvxsTACe3GB39WaW6LRqwtKdjxuIg8UfpvGR0P4cUeI/NJutq18G3f8R8FJuBLp8FcsB2f8+sgkE8hZ/RspyEKaupzhT1EQ0bvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exEks7pG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exEks7pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC891F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 08:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201868;
	bh=duqiBybDSj+/ni40yEEsF0AkVu40eQgqwqHqMYQxStw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=exEks7pGGmx/QOYLgmREoybZWjudyFd6RHGHhGm+O0qLYHvCt8+NsK85wDMkFGFB7
	 21g3P1H43YUe4SxXtmoNktU+q9pJyndJf0Uew6ceEKLql3HYCvxglrJ166tnJfKwtj
	 zSXBGOeInrdlsK8/dm4zOOsZCbHOPdFgl4eGKANFQV63kNBL0YLZ9422KW5RifOuAC
	 FOjag8dIZZZf07AVSteaiiXrynCwAbGbPUhzlXZy/47Gnil5s7MECgZa5I/ApSETGK
	 FBIEEpulemyrEBLLgvJ8RdFMCpwKXfBCzWTAqLngZwy6JYOoZ6xOMJb/qxlcQJw2Ge
	 EYTItil6+VfQg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c106f737b5bso51971366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 01:04:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9fMU4La40jSb/6yWiQPxt9JRADZyCl+nAsJN+6U5UbRNVTgUzEBJPvSt+pYlqzIzu0B/bz2SC+rdrn@vger.kernel.org
X-Gm-Message-State: AOJu0YwYlvoMo8cBlS+T0oWCK6+exuofEFO/BvcH7rQh6pJVv7jzCu0e
	m3M2p7YCBQtoQk9RzQtzN0EcpAqmV13PTynWh2th7u+2B0+PTQlu1Wsgn/x8HO4NZvIQdT+RVkb
	7/kFYKvgYxz3HBH/p2N3dP3rjFUIB3yc=
X-Received: by 2002:a17:907:9481:b0:bd3:6ec5:f141 with SMTP id
 a640c23a62f3a-c107eec929cmr67194766b.30.1782201866789; Tue, 23 Jun 2026
 01:04:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
 <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com> <4747ff73-f57c-4c8f-9038-ee00c7561817@chenxiaosong.com>
In-Reply-To: <4747ff73-f57c-4c8f-9038-ee00c7561817@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 23 Jun 2026 17:04:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_3KmNbaUe5U-mp=vEOJQ0ovmnyxQxezY4fy_egcHJf+A@mail.gmail.com>
X-Gm-Features: AVVi8CcEbW-NdtzmDYeE-uR7eR-3Bhb79jgVhu2j8Wfoljn7_Vd-Q6e0CfLVM4w
Message-ID: <CAKYAXd_3KmNbaUe5U-mp=vEOJQ0ovmnyxQxezY4fy_egcHJf+A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Haofeng Li <920484857@qq.com>, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	metze@samba.org, linux-cifs@vger.kernel.org, Haofeng Li <13266079573@163.com>, 
	Haofeng Li <lihaofeng@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 3:53=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
Hi ChenXiaoSong,
>
> Thanks for your review.
>
> If we use `continue`, the next iteration may get an invalid `aces_size`
> and the previous `ntace`.
We can properly use a goto statement to skip that.
>
> ```
> for (...) {
>         if (offsetof(struct smb_ace, access_req) > aces_size)
>                 break;
>         if (nt_ace_size > aces_size)
>                 break;
>         if (ntace->sid.num_subauth =3D=3D 0 || ntace->sid.num_subauth >
> SID_MAX_SUB_AUTHORITIES)
>                 continue;
>         aces_size -=3D nt_ace_size;
>         ntace =3D (char *)ntace + nt_ace_size;
> }
> ```
>
> On 6/23/26 13:03, Namjae Jeon wrote:
> > Instead of using break, would it be better to use continue? Using
> > continue would allow us to skip only the invalid ACE while still
> > returning the rest of the valid entries.
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
