Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2F3C1F
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170237; cv=none; b=VlYZxIidFvoutOVkoGLsFZjSdrdtHIx6TaJWSgfMJEYGPMj9W2iPbeg5nKt/+nULQH8Grd1MhwDQCpQxlx5csx3OkqZDxmRdpqz34c1eSLqgtT3XqrlSnPWI6Ctu7Rrvao1sy2QFOlgZt0ZgKwD6SZyoyfm/77QwDRF/Vf4tir4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170237; c=relaxed/simple;
	bh=/n2IMyT4UBDvSfcwRBffepGkIzE0NI5Ntu4zwVrBvtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PAiMcUD2zwUBY1AhchVfGnycXEmi0hvJnbPUjckOqXKE2gVTHqcEDsWXleDLJGJQ0Hi0fJf4aGnK9GmGzB0lNxlXCUbA/+G9xPWcc5Rnjxu/XHKAG7RzVXqmQPShRL/1fNfFKU2aOvldu4NaehrJP3JrdWI/jpnxrg01prhVbxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLRwb7fT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLRwb7fT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C4AC113D0
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764170237;
	bh=/n2IMyT4UBDvSfcwRBffepGkIzE0NI5Ntu4zwVrBvtI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SLRwb7fT7Jff6G2MPAW5+gMN8q3GdHFK5wDAh752DkzYkFd7tUrKRjujd1Z5/Mmpe
	 rVPqsxEnYVMLjx6o5CtUgKvcWywCQV65fKumT0LKGg9G5giVdV2RzxqiDMomiuyG36
	 pNzdO6+7rdBjevkNpXqVD8auYEY9vE+9ylnBSBLLrnWmuxNjVFC/LB9Fo+Xg6nKObM
	 T1LTdhxabtY+QNzJOus0FnjqS575m4Vyse5hOK1yNo8qXVWMNa79S09IeKVCVpJvKB
	 xzumoLxnpQIeT0HNT+7c2eC3/5JdFfMRePKeI7iij+d0Tgr7lxrvvlD6pAtSDxFGqh
	 Lmm3FbH+N/UCg==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so9725140a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 07:17:17 -0800 (PST)
X-Gm-Message-State: AOJu0YzwpirgQZGwz950KwFOYhfu9hT9rHgyq1agGEorTuiV69qriAZN
	QG2h7BkuerEVdQHVpB3Up4ogvPrxdPRLfBinMovKufEzdEVEGvgOmnOG8W1/IHNyYBEOG1MH8K0
	ThCFmFMDxdzDWyzxwyd5DqmZ5oxTVbi8=
X-Google-Smtp-Source: AGHT+IH123LKj8eIYxZA00cVdSKsJ038DSdVfsNBAbRkT2TbspDoe30m7yPWucZaG5pSpNFhXs9LycH8U3wTRcV1L4Y=
X-Received: by 2002:a05:6402:3489:b0:63c:4da1:9a10 with SMTP id
 4fb4d7f45d1cf-645546a3c05mr16718820a12.31.1764170235879; Wed, 26 Nov 2025
 07:17:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
In-Reply-To: <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 27 Nov 2025 00:17:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
X-Gm-Features: AWmQ_bkqVgnyCnpD3sDHpobxA475gQK_ZOcqTm_BmFVg9DdXo_z4G3WaYPWokkI
Message-ID: <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 4:16=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
> > On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>
> >> Hi,
> >>
> >> here are some small cleanups for a problem Nanjae reported,
> >> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> >> by a Windows 11 client.
> >>
> >> The patches should relax the checks if an error happened before,
> >> they are intended for 6.18 final, as far as I can see the
> >> problem was introduced during the 6.18 cycle only.
> >>
> >> Given that v1 of this patchset produced a very useful WARN_ONCE()
> >> message, I'd really propose to keep this for 6.18, also for the
> >> client where the actual problem may not exists, but if they
> >> exist, it will be useful to have the more useful messages
> >> in 6.16 final.
> > First, the warning message has been improved. Thanks.
> > However, when copying a 6-7GB file on a Windows client, the following
> > error occurs. These error messages did not occur when testing with the
> > older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>
> With transport_rdma.* from restored from 6.17?
I just tested it and this issue does not occur on ksmbd rdma of the 6.17 ke=
rnel.
>
> metze
