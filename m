Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B762918CC13
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764198616; cv=none; b=VQSfHQbjXdVP8fbbSfKMCYHk6U7xR4oBSl4Ryy8bFHjlG6mtZgwtvbAKxJYkOb6qiQtyKjPoac+JsMjtUOXq5r1VWqroAIcQSe45zoU0BUbzlQLDQGrlk94nqHTlAdJOyv8VT//gDO852yj1x6duFX8S7wCqZy1KnahTaKnqTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764198616; c=relaxed/simple;
	bh=nH1JfdYw0mw2MsHTQz+O8kH6xkZ+R068FHjIhnf2bw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f+vyL6NJ65jKdSI5BhTN3Z8hh31RkZocOehrDayJZzyShZmb3UrePx9qe7/vS7vuUWY4/QEfa/1ItwawucUS5qrJmWcpt9Y9gnnWsOO7+mPSbWsUyyzjNVcl0NGbxDWVQtu2rdPdauPGWQFlK1X0X/J3vQ4REY1luXlmczelb2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFjCQhQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFjCQhQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2B8C113D0
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764198616;
	bh=nH1JfdYw0mw2MsHTQz+O8kH6xkZ+R068FHjIhnf2bw0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jFjCQhQQfUu5gnDZgSkXyb1ZoD38A6QW1rKlSEPRJOjNsHrjex1mRpihBXyFkKqMC
	 PtTm1t+VPGG/XVPUXkRiV5geTuaql0s7yqaBzOQAXYqMdq7f8FN01HWFrlzcwYEk4b
	 u/y2v5VTwct/49R4fC959vKx7QmOwCOKfGuioTBB6ypVQ5DELRm9CxUyX6N+pygBeD
	 Arz+z6Pi0YUby8KOCi8vQQrpC2bheCCTNdD2GSxsn5fgPzZhUHHj+rsHBICRwwZjKT
	 mht9o0NgQp6tQ8hsiKwkyIi1rgXOfRzU9LnvHRLodXuejkPkcvPAVWjfmEuAPmB/kr
	 AwEkPfr6NIO+g==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso562616a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 15:10:16 -0800 (PST)
X-Gm-Message-State: AOJu0YxyZ3K5jyCizQFoZUFZVuqkECM9rIjWKekGbsJ5SQL9UhyDgwzI
	tllUWqAIXeSZRzxVcjf2nitTQaNNdVDVsOvAx5ZA7QpE8H8x3QNgYlPtBzy8w6fu8YEUaCRVj9L
	oiq1KOlAAeUVB7DaXQrjbLdgdQaWGd44=
X-Google-Smtp-Source: AGHT+IFMsL+Ny0U3yIVfZOFe1R2tEdf5NXbzw26tQ91YaO8bw1yHPs+GioCAYVZtntpel8Tb1xbuQ+d62NsjJ7wSxHc=
X-Received: by 2002:a05:6402:3054:20b0:646:618:ff41 with SMTP id
 4fb4d7f45d1cf-6460618ff64mr2803350a12.2.1764198614733; Wed, 26 Nov 2025
 15:10:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org> <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
 <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org> <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
In-Reply-To: <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 27 Nov 2025 08:10:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
X-Gm-Features: AWmQ_bkitniyxtmDo4233u1JmTOAWiQMhzWYpcHCGx1_cbfCmJf4bFc3YRTJ8tk
Message-ID: <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 1:03=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 26.11.25 um 16:18 schrieb Stefan Metzmacher via samba-technical:
> > Am 26.11.25 um 16:17 schrieb Namjae Jeon:
> >> On Wed, Nov 26, 2025 at 4:16=E2=80=AFPM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>>
> >>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
> >>>> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@sa=
mba.org> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> here are some small cleanups for a problem Nanjae reported,
> >>>>> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> >>>>> by a Windows 11 client.
> >>>>>
> >>>>> The patches should relax the checks if an error happened before,
> >>>>> they are intended for 6.18 final, as far as I can see the
> >>>>> problem was introduced during the 6.18 cycle only.
> >>>>>
> >>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
> >>>>> message, I'd really propose to keep this for 6.18, also for the
> >>>>> client where the actual problem may not exists, but if they
> >>>>> exist, it will be useful to have the more useful messages
> >>>>> in 6.16 final.
> >>>> First, the warning message has been improved. Thanks.
> >>>> However, when copying a 6-7GB file on a Windows client, the followin=
g
> >>>> error occurs. These error messages did not occur when testing with t=
he
> >>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
> >>>
> >>> With transport_rdma.* from restored from 6.17?
> >> I just tested it and this issue does not occur on ksmbd rdma of the 6.=
17 kernel.
> >
> > 6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?
> >
>
> Can you also test with 6.17 + fad988a2158d743da7971884b93482a73735b25e
> Maybe that changed things in order to let RDMA READs fail or cause a
> disconnect.
The kernel version I tested was 6.17.9 and this patch was already applied.
>
> Otherwise I'd suggest to test the following commits in order
> to find where the problem was introduced:
> 177368b9924314bde7d2ea6dc93de0d9ba728b61
I don't have time to do this right now due to other work.
Did you test it with a Windows client and can't find this issue?
>
> After this it gets more tricky.
>
> metze
>
>
>
