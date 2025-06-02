Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245E2C3259;
	Mon,  2 Jun 2025 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748890144; cv=none; b=PYAQlAgiUh/WORn4j5qavaHruxR2jl8+XeZuC6wgOSQNmJMGQk7nZcYNWMSE+RxnjTX72m1eQuHrLb/VMPonYRqvtTmFHzbZXQSQVG4pgssuXBwzFxP5iejq17VOXFERLwLkRpf0q8jZ5QSjnH/nv+j70fI8LX44TGUXS4bDWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748890144; c=relaxed/simple;
	bh=aYyEprdRp/ljcXcEK7HsyY7FUc8vjLa0NlOSfLDY8jI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVQbXTdpxlwzUPexA4k8sI6V0A/8BGl2+jVCGKw3NRFyVT+FGjv9NOoV0ZkYZN4nzHpcF/Gd3o28zS/s8R8M4U93srn+3nucqH+QxPAMzV/nUopHOBpZ/s1eLte63Xvf64wJdUOdsv76eB4UPKXfT0mRQn17nfJSkhCnDqoRqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DznxHMmO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DznxHMmO"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad8a6c202ffso926709966b.3;
        Mon, 02 Jun 2025 11:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748890141; x=1749494941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dZSHgWdZ+Nqm/ahOmukFr7FBsJQafqUMLWFuarLhoE=;
        b=DznxHMmOLTL/FjyEWhiYkdJlGHT5w2UpiSfCiTgZFz8UVsuKTFT/fKrA2WVQmWHugh
         lq9r7Tb1ezvkfFSWG1/+I/kLaTzH1BRmQduKuy71Cnbo8JO5P9MvlvIcS1/+Ud28q2nK
         0weB7e8SA3bstrxbJTntSl4iO0Ym2p/rXYeZKrmg3JxsDjufps8oQF90vEkxR9RTxYLG
         9ksdK79aUklYioe4+zC7B7ap/Px0cdRcN1JV0VoxMUiwc8c250RwmVN4HwH/mapfxydt
         z54qnH9psj/UKZojWXeLUK83Cw/Pum78E+7VyksA/884l0M/vczR1XRm6Ps4HRljzGIx
         N2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748890141; x=1749494941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dZSHgWdZ+Nqm/ahOmukFr7FBsJQafqUMLWFuarLhoE=;
        b=kCKOf01MH1dVwqvwVxbVqEgNrwl/6hmI1mpSXnIZ9H7Z3LkhuIeWeCs5Pbzp+Qn6W4
         XNq9r4uBjgFuuTq6hoSwT3cIcTX2WQ6eHmk2UnmebyjpasAqKcej5wIVEQhmaF1a6dlL
         SuKIA0yec0nUSbURbtSIrYs/8SbIgmMO8x4Dy/VGElAQZgREDyMvAFYYY6rvkGunif7c
         hD7YlddumHkb18+NLjWOl3h2n2+RZtMP1TsGv0bAFSUydijfAen8TXnMMqoRm8KpG7gh
         +cC3ELi/1fIxZZhIxOEG4A51O9fBHehy7Ilrcbak04ZRouTbKQGER/Q60B8y14z4fiZR
         CoGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7sOLmkaRN6VXTO4p8xN+m3rZEsViZT5b2Z8TuRoZ0Yvo2s3ghPsg8EpCyjSIRpRWeUtYxpZc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk91Po9eUm7Qcl/jn87/PCAtm/rETWThZxM63vJlojzlewnLDZ
	XnXrpVE3JLyXa+gb/qAwHa9gkRKaELH14sBvVuZo1pr9LEoix1A8WEXVA8c4BmsgJmOVxpL4wOd
	8Yc2uTlYY2YGv2hbtxZRuA14bn8ln/o302r2x
X-Gm-Gg: ASbGncuwBXqgKy+dL6i82Y8Wf8IX3KoJzfgew/SXLF8Li72Bg0NN4QZbc7ADRZ1uFcQ
	tc2U7/pw2z4KTim9iLNBFKZZca2+Kh6Au0xOtuCsC9TxQZgq4Zwd0yw+m+HqKYL8ARUV8iDKJET
	IbIcwRa/IY44eve9mnafHJ0TFwPJOw97K/FALKwiHmP8HT933TPIBKVS6e0Vj966dQcFE=
X-Google-Smtp-Source: AGHT+IGvvYfDLrktmf/FrCI0cG2Rk/RxsTcSqE/xq4QhktMay6INTwMr3gEnmRhZqNTzsezAufONvzK1fyxz1uB4XE0=
X-Received: by 2002:a17:907:2da4:b0:ad8:aa6f:9fda with SMTP id
 a640c23a62f3a-adb49605525mr958440166b.55.1748890091268; Mon, 02 Jun 2025
 11:48:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602170842.809099-1-sprasad@microsoft.com>
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 2 Jun 2025 13:47:59 -0500
X-Gm-Features: AX0GCFuX0fkw6hqaLuquFyzJU0zMmYK5UVccSf_iZ94uK42KferTS9DDa9OloQM
Message-ID: <CAH2r5murRch3hv=-ZbF5O06iLOkPur8EaUZSjDXfg-ekcxCq1Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] cifs: deal with the channel loading lag while picking channels
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged all six of these multichannel fixes into cifs-2.6.git for-next
pending additional testing and any review comments but these three in
particular looked most obvious/safe:

b4f60a053a25 cifs: dns resolution is needed only for primary channel
c1846893991f cifs: update dstaddr whenever channel iface is updated
1f396b9bfe39 cifs: reset connections for all channels when reconnect reques=
ted

I want to look more carefully especially at these three:
2f2c5d38fb9d (HEAD -> for-next, origin/for-next) cifs: do not disable
interface polling on failure
4394c936623d cifs: serialize other channels when query server
interfaces is pending
bf75ad3631c7 cifs: deal with the channel loading lag while picking channels

On Mon, Jun 2, 2025 at 12:09=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Our current approach to select a channel for sending requests is this:
> 1. iterate all channels to find the min and max queue depth
> 2. if min and max are not the same, pick the channel with min depth
> 3. if min and max are same, round robin, as all channels are equally load=
ed
>
> The problem with this approach is that there's a lag between selecting
> a channel and sending the request (that increases the queue depth on the =
channel).
> While these numbers will eventually catch up, there could be a skew in th=
e
> channel usage, depending on the application's I/O parallelism and the ser=
ver's
> speed of handling requests.
>
> With sufficient parallelism, this lag can artificially increase the queue=
 depth,
> thereby impacting the performance negatively.
>
> This change will change the step 1 above to start the iteration from the =
last
> selected channel. This is to reduce the skew in channel usage even in the=
 presence
> of this lag.
>
> Fixes: ea90708d3cf3 ("cifs: use the least loaded channel for sending requ=
ests")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/transport.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 266af17aa7d9..191783f553ce 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1018,14 +1018,16 @@ struct TCP_Server_Info *cifs_pick_channel(struct =
cifs_ses *ses)
>         uint index =3D 0;
>         unsigned int min_in_flight =3D UINT_MAX, max_in_flight =3D 0;
>         struct TCP_Server_Info *server =3D NULL;
> -       int i;
> +       int i, start, cur;
>
>         if (!ses)
>                 return NULL;
>
>         spin_lock(&ses->chan_lock);
> +       start =3D atomic_inc_return(&ses->chan_seq);
>         for (i =3D 0; i < ses->chan_count; i++) {
> -               server =3D ses->chans[i].server;
> +               cur =3D (start + i) % ses->chan_count;
> +               server =3D ses->chans[cur].server;
>                 if (!server || server->terminate)
>                         continue;
>
> @@ -1042,17 +1044,15 @@ struct TCP_Server_Info *cifs_pick_channel(struct =
cifs_ses *ses)
>                  */
>                 if (server->in_flight < min_in_flight) {
>                         min_in_flight =3D server->in_flight;
> -                       index =3D i;
> +                       index =3D cur;
>                 }
>                 if (server->in_flight > max_in_flight)
>                         max_in_flight =3D server->in_flight;
>         }
>
>         /* if all channels are equally loaded, fall back to round-robin *=
/
> -       if (min_in_flight =3D=3D max_in_flight) {
> -               index =3D (uint)atomic_inc_return(&ses->chan_seq);
> -               index %=3D ses->chan_count;
> -       }
> +       if (min_in_flight =3D=3D max_in_flight)
> +               index =3D (uint)start % ses->chan_count;
>
>         server =3D ses->chans[index].server;
>         spin_unlock(&ses->chan_lock);
> --
> 2.43.0
>


--=20
Thanks,

Steve
