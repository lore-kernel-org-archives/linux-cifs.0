Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9FA3242CF
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776226934; cv=none; b=cAAc6XgtqUcR7BZr/RgP0yWg/2by15n5DYnPuYd2nXepqh/bkFK/3JxT0ceh5nvIL9nEbXqr2HcocXLmiA5ikHjzw6U2w5Q0qQBGJ7NB/5Mq2e8O446omBGL6Tb0X3jGyZirfmlgqJsF2GvYE0ljkh2s+ijEQQxsaxpt8Q8OhVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776226934; c=relaxed/simple;
	bh=GUf5PKrIKfvd7WbyO0ssoN/5lZB9VybElqF957DkXPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uef1BUzTdBVzHJaTc3LyqX8+ILid7cGeOKHmWHuTKZNLN+6cdM8rO/Zt6cy1Ydn1reghrZM+nAvk3xdibBz02vzpeANbTKsJWO1pPx9iloyV8oyAISHQQNeYnTA496/9L70EpAFgMkFHr1F6d6TEBRm+LJAloGhSkCSB8Xg1Lmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkD+DT8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkD+DT8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3FAC19424
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776226934;
	bh=GUf5PKrIKfvd7WbyO0ssoN/5lZB9VybElqF957DkXPU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lkD+DT8ao6jpaNNDifeMZ5ZGVPZBPVMD2/nCDFw3JFjABC2p4/I1dmM+aeDs42Qui
	 AwvY5N9j9tg2mNXxylKaFZSEfVbFp1bpW8hG40YRsN9Sxb0x5btnylwOkwgGxW5jRJ
	 1mG18pjFLZdc9j3XJ3ylGxANYjmP8vVeQkjGl1gfTB1O/W6B0INYp4aE+2kmUBnEDr
	 s40mzCXN+9F+zvXS7ymQjydP4XhPIpRlwwGavCtoe271h1/RxuPNXTyFxOmBV6aKGN
	 TwdIjCSpeoYuwZ21per2NC2eqvHugoFsWPS9rWqJc31DH7jFl3VE8xe0vsEOrWcfhU
	 +JL6p6Cmdz5ZA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6708cc2d6f6so7606152a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 21:22:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YwYWwaa2Vsz/9lZW+qvsQgd3/IPOlLYDc+n9ymrWvrb2gnZBy+O
	vIk8avx5lPu+TfUq0dXG4FDKkiBA36uuwV3vcn/n0Y00Mu+6Vfyugna1PXa+symiPB/+jdcfKOe
	hCMnvqereo7r2OfDfVJEaGzCf5TmRxB0=
X-Received: by 2002:a05:6402:518f:b0:671:4f9c:f664 with SMTP id
 4fb4d7f45d1cf-6714f9cf751mr5750069a12.27.1776226932741; Tue, 14 Apr 2026
 21:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414191533.1467353-1-michael.bommarito@gmail.com>
 <20260414191533.1467353-2-michael.bommarito@gmail.com> <CAKYAXd-zwPuES8PdV+XQjuQUemVKejayqY_0aYS=88uZ=FG9+w@mail.gmail.com>
 <20260415023510.2659606-1-michael.bommarito@gmail.com>
In-Reply-To: <20260415023510.2659606-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Apr 2026 13:22:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com>
X-Gm-Features: AQROBzDnH204ozHkVxvQouLdZlt6lGsvRUy8zmBUdbe3nfoM3E9c6j6xUR5QtpA
Message-ID: <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: cap response sizes in ipc_validate_msg()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 11:35=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> On Wed, Apr 15, 2026 at 11:00:58AM +0900, Namjae Jeon wrote:
> > However, on the userspace side (ksmbd-tools/mountd/rpc.c), the DCE/RPC
> > response builder (try_realloc_payload() and ndr_write_bytes())
> > dynamically grows the payload by 4096 bytes using g_try_realloc() when
> > preparing responses for calls such as NetShareEnumAll, etc..
> > This can cause share enumeration failures on servers with many shares.
>
> OK, thanks for explaining.  Sorry for missing that context.  If you
> are OK with it, I will send a v2 that drops the cap on RPC_REQUEST
> and SHARE_CONFIG_REQUEST and uses check_add_overflow() to just
> prevent msg_sz from wrapping.  The [0, NGROUPS_MAX] bound stays on
> LOGIN_REQUEST_EXT.
OK, sounds good.
>
> > You don't add the check for KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST case.
> > We don't need to check resp->session_key_len and resp->spnego_blob_len?
>
> They're both __u16 so the sum can't wrap the unsigned int msg_sz,
> which is why I skipped them.  Happy to add check_add_overflow() there
> too for symmetry and clarity in case anyone refactors.  Just let me
> know which you prefer.
Ah, Okay, no need to add the check for this if so.
Thanks.
>
> Thanks,
> Mike
