Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6273C2E
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771119253; cv=pass; b=FcO/hiCJq8eLEFO3IUPEMmY6MaibOznupIy9SFlWIlvojWCUz+XrFdEXkgueOlUKjOWdyp5KQQVSCRkOM1/CSroACTQaljNdjFmhB2UHpiYOylXnejo++0ES7hZbkUHVdNG4iLbvakflhIVKNj0Tkk/XH+T41mNASCoTs5VvHgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771119253; c=relaxed/simple;
	bh=qr5lt+lgewLt+SbJxw+ZpLap8itbPYa0dARebkzCP5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hs9crfP16TBQMXQMfdmmavoxGWl/qp57FWzeoyBJXGZ7iesP3CNdZLZBVHLoFl1elH8PRhG74SI7EBsWd4RdLpv2dJooL1QOcAqEsKvpQIz/KEhUVt2pTyTA4quZPYY8cN5xXi2+ii/kQlybbBYoFe8DsFcQUmpB/kEtWQwEBns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHPW9IMa; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHPW9IMa"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-896f5af3d8aso31615376d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 17:34:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771119251; cv=none;
        d=google.com; s=arc-20240605;
        b=C0Iy6iAcJLmJsDxqw8rh1cDvSQgeoCdnNyM8JI7tS3joL3KqvhMcFWze6n2MiFPo3X
         dnkVQ9whWmZEN2l140UNllaXRolnKYUP0K5oNbm+Vqf/dK/sCoTDvuYgEfg8DbF2VZY9
         3KJQ1VmfQyrnj8wABJ3Jo802G6niyfQPm3VPranqMdiDXOkusMCsBiefiQgsSY/uxtzL
         4lhuM1pB2v/awq5/D3lfvupPZ42XtNtAPpdB/w00Pegl91lqiTd0Hqe6lOrb6Rnvf9W6
         76diMEyiXyDjDvSK+rbkNjLN5R87i0KzxluN3T+DW8Lcj+25xG3YsxwyPGpwNmwaPjpV
         90qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4V18X/7a7hThGXYT8Y/sUu1/w7Gx31DBBY1sp1XT9Jw=;
        fh=fz/wBVMx4xH19h6IcObuEdCqKjRJriuvIIIgaJAb4lU=;
        b=g3UlKehnemIfk0vmQT/G15hHZ8DiMTWaDDc+p7Wnve3uDrTaZ4UzQWHuNaCvlpnviL
         zyPUTvMqPyWSBHX4Ghte9d4IWwn/SeAHmsKaOI9BFO16CoaI8lMztzkXlmdu7CAiqO7/
         dILwMl56wmVGX75CiVYwTi8CdE9kP7gbLs7ZphDHxXud79g9lQCQZHrjEAEZwYzlJb/T
         I+pE0XW9NdPvbwKjkVw1ATRVkrp5EU0L8fPikxBobQTuGQ417/1QaOXLWbpoDdqYX/x+
         3OEZ2/n1eY3baP4Cu5AAUN6HXv7X9CBbSgefh8WbZ7jixoXbEweEDjU5zs1eaPN/CMTC
         k8lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771119251; x=1771724051; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4V18X/7a7hThGXYT8Y/sUu1/w7Gx31DBBY1sp1XT9Jw=;
        b=kHPW9IMamLRzSJpFivnPgJJfSlt4qCfYlWzgvJpyao00xV0qoTWDo6cJawIT/IZ4tE
         5Nq/PYXO53LLRhqCCGj8FmU3P9eeqHrlpZ7aTsBNX0fIt145HjShhwMDg5qhF5Adg7H8
         wgIuFsyQOWXXyhQ+iBE9QtNWDesWFmILnGRt4H0gLR7zYXsOghT2RAAElwBTQIGcIHoZ
         4fw1Gmf6nwnSIylg6xv5OTobt5KXNbrmcOYjBz+JGo6On6YE5064+HLx0Ml/OWu3kr5D
         qglv6X20FSW8vJf/5uLC8kJVlz4VH80f6bzH4GaMnD1H3/XKrieT+IiX4HaMn1rhBGG9
         YoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771119251; x=1771724051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4V18X/7a7hThGXYT8Y/sUu1/w7Gx31DBBY1sp1XT9Jw=;
        b=HK7qMZ85AAINRTu/lr87IWW1LUoNs5FFUKA8ruILLh7YxJT8OCYVKenjjf2W3+whN9
         4n+PLUfx2Zj2bQbV4aqGJXsNxFp88DIKgrQxuFGm5wSRDEocBScz3gJnFIMRaDQM76Qz
         szDu/dqlrxvbIMEKsbEgQFqwPjEDyEZbYxw6qSvq86LvsfyVFrj5y3IvYohdQOS4eagK
         3xp/L10E3q7dAOXftGso9cduQWM/rxlK8BqSSqbxMyq9lz8jw+lZIoP1prO7oEFc7ju3
         +r/yfmp3Whz6VyyRvcsOi6WnGEWuxB402n76106L6wmZr71s868Q9L26RK9k5wcUMbsW
         poVw==
X-Gm-Message-State: AOJu0YwQk4i9dr5u6VwkaqgHqRLXlklShdH2eNezLWzzS4/2MezDRhUw
	UiZq6UbbHjypjNrGFysqqdyy77jsfYbOCVkPX3IUqJMdUAxyKM6pqmSr2FfNVys2CJJCyrB9zbv
	AbcrNbrck8CNt3YZ3HBDA93n2+XRGQqizaw==
X-Gm-Gg: AZuq6aL3amIaSpg//gQPGcWLRcrT6V92FFYT22KMoDKJWwr09dICCHgtGjqzL8RoUr4
	TmY4C8MqrrgTa85v0adDI97FroeScLeIHiEjQZeWb1AE5LLKt0PVJCi9ewRgYs5intlI9dE16Ea
	NaL9P9kFXSbhS4kRnOEkPwKVPnCE9cfMXDiRvyMvBBJ1Jvsg/EZfJcVc05HfTOL84ydXYW8d07Y
	ESC2jYfR9QBSo6pGJzEYTWQYdrgGDLrA0b/NrreIVB4/o/GzQh2isj4kpvgS3AFlBxN5jTp5MNl
	zkTFeR1DwiZ42I3y3AvAFP4AuSjtvkXI45SbyNSW1J436A6Ec+Z6RV0k9bByJ1AKvpYUutnLX5O
	zsYnmwrzmqlWNMTNkyW/BQjXOdcWmtaJVCQfBck32VXJyzUL+XhXXER37W2bDvVvp2tzvpFnl9Z
	O1Uvo1qEW4Iw/HOGjNa6DW
X-Received: by 2002:a05:6214:21e3:b0:897:153:6f67 with SMTP id
 6a1803df08f44-89736313b42mr92440576d6.71.1771119251225; Sat, 14 Feb 2026
 17:34:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260214102943.190621-1-sprasad@microsoft.com>
In-Reply-To: <20260214102943.190621-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Feb 2026 19:34:00 -0600
X-Gm-Features: AaiRm51dIkVkeHPTNobfnyGZ79h83JAiaIy-pbSPL_99I7Dqk-alBjEa7Tv3ph0
Message-ID: <CAH2r5mte0yQFDprTAFJhvRnzetKvE4KCQ4GR-xpw9OT7EJDk8w@mail.gmail.com>
Subject: Re: [PATCH] cifs: some missing initializations on replay
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next (as well as your
previous debugging patch) pending additional review and testing

On Sat, Feb 14, 2026 at 4:30=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> In several places in the code, we have a label to signify
> the start of the code where a request can be replayed if
> necessary. However, some of these places were missing the
> necessary reinitializations of certain local variables
> before replay.
>
> This change makes sure that these variables get initialized
> after the label.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c | 2 ++
>  fs/smb/client/smb2pdu.c | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 262df6d2c2c82..ae39b3c027d2d 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1185,6 +1185,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       used_len =3D 0;
>         flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         server =3D cifs_pick_channel(ses);
> @@ -1586,6 +1587,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       buffer =3D NULL;
>         flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         server =3D cifs_pick_channel(ses);
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 4602b4dfe8322..7f3edf42b9c3f 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2908,6 +2908,7 @@ int smb311_posix_mkdir(const unsigned int xid, stru=
ct inode *inode,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       pc_buf =3D NULL;
>         flags =3D 0;
>         n_iov =3D 2;
>         server =3D cifs_pick_channel(ses);
> --
> 2.43.0
>


--=20
Thanks,

Steve
