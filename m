Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF6B15820C
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 02:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741661611; cv=none; b=Jmfy/2QOtKNqrhl9NZlSs+XTdwCfMkMzul31BbuFKiRSGtrxRpmJJG7devxJ6Hk9RQ8uQ0Yhg/G/XAzRl40JuUKsLW/AWjG7RNycWToRljtMAh6VVuTY/dGgw8RoWbUT/dqMDlZs/1mTk8HreVo0Lkw9PZBA71YskvwOd3RC7K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741661611; c=relaxed/simple;
	bh=3dCIo7Ehr7ZN6m4KEGaruYzdPVUOGbBUtywue0267kc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UhYL+LsTLOygbwUz5FRYWuYetcYrUmvXo6Xzi3gfTC7ka0JiJIAj6XLZcENFpVvodNnaZ42WSn83AdjzUaDyZqqdGAFUEJGMow8RD5At0Q5jOMnb2WcKNAUyfIVOZGgK8UJ2ACZ3SQ/xtpeLMS0vekZOmHfxktzyicyM5IibCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltEdxvmH; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltEdxvmH"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so994800a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 10 Mar 2025 19:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741661607; x=1742266407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3BTEnOrpnn0txatI4R9fsf+yqIBhHfDLJ64Qmukdgc=;
        b=ltEdxvmHiLOr8HK3SAVCEW0irnw2yvUqSXr2gMn0+bxQPUL7Ag0hVz2Gec1tCg+0i8
         /WlsI0l34n5xYrJj5F7rfS8pUbHpAOr0zsHMxnjhU8ZXBzQOZB29lcGkYBlajhTB+ZR3
         4I/wcs30cSSDOxwVVtc8kWqW31aqlSqrU1zx7l8xo20mt4TXNpAgpDXAFsrt5j6O2DiO
         w7IZrlOSf4Zf5f2ur7yVpoBspjYFqTIYr+KpJqG6CteseqWLo4sfSNG+2OrnwsqY2usg
         zLfegrUrtQbP6Ma5x7PGimeHxjg/axa+hxDUkgnSUkeEQ6g4CGMJxDp/h3teUeQSt9wE
         6ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741661607; x=1742266407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3BTEnOrpnn0txatI4R9fsf+yqIBhHfDLJ64Qmukdgc=;
        b=mMa8vxMiOJouD7EBNYQosc84UHzCiXiWIFh2G4iObYTh+ecEK1O/T/Bxzq3Nk+TQ3I
         9WIXieNU7wIn17A/KzbBrbykKYJggsbLDZV/8elaUZE+TJp/BsFxzYa91glv4T8DyLnB
         HsXf4X4P0UBoP2DbqrqeBurRSbyUZHvQOWCBhPoq33alPnb3siDK0qXRgeqf8Sbmqkgj
         /9tIyHXXvlO3/rcZqsk1UtrF5XPNCttBz/H2MY4W4VzHXTekTVMgzDhIimljAxyXm+Cc
         0Z94g+cs36LDVHRj9BjTN86N7tO/GFiK2RAm6jeXuhjw2B+Z0a4tpkET4lVvSZmZYucr
         vokw==
X-Forwarded-Encrypted: i=1; AJvYcCVySysG73app+w9/RFpBxxOFGOqAjgb/+R+9KReH3N71rEIElDAD1rKorG9qgj5h1L5562Dl0KktFF0@vger.kernel.org
X-Gm-Message-State: AOJu0YygB2nystRi9ujOdAof1g8vBJeT4ogHRukciHjexQDhIpVLge3K
	B0R/4HElsOnQaIwWiksAz2SerY7e4YKwcIVLlKWFPnHZmco9vlxvvqRJhaIl07niFktBLEevbjV
	Zq2kRp05Ewt7FgNTwlyHOkc+EwubVpQ==
X-Gm-Gg: ASbGncuXUJs0cG+AAU6l8phm7mEmUUZ3Kmb5MYZMuowrITyJKsUy6zzGX5JjL3Qlccv
	2fAQ0D52ZY0uw7Z+D+oOgU0H6PtrcuDXMAgK+1NNdhuc51tX6W/Vy4kiJedkV2b4ENTFiN7bYR0
	voVMIRnmFGya3jWkApXXMDfPJvvmt2sJcQ0JmR3XzBK/nT23ScSu8hduzkS6pN
X-Google-Smtp-Source: AGHT+IG7nU82M63SFGFLbnrv8DcboG4OSjFOFC6Apb+n21SP9GdC5mAiQRkZBZKy+n9CNbsk9OcKz4WYw/Cf/1IxEVg=
X-Received: by 2002:a05:6402:3595:b0:5d9:a5b:d84c with SMTP id
 4fb4d7f45d1cf-5e762808229mr1935513a12.3.1741661607443; Mon, 10 Mar 2025
 19:53:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311013231.2684868-1-henrique.carvalho@suse.com>
In-Reply-To: <20250311013231.2684868-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Mar 2025 21:53:14 -0500
X-Gm-Features: AQ5f1JrU-wYqCWI-Qr2IqHa4NTIw9uGjF9g6MhHcQ7wSd1SlFzpsjUxCckxuGFU
Message-ID: <CAH2r5mvoXDd-hCwxqhBtBz+T-u55ZHD0Lw8+_RqtUjA9KQN=CQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix match_session bug causing duplicate
 session creation
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional reviews and testing

On Mon, Mar 10, 2025 at 8:35=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Fix a bug in match_session() that can result in duplicate sessions being
> created even when the session data is identical.
>
> match_session() compares ctx->sectype against ses->sectype only. This is
> flawed because ses->sectype could be Unspecified while ctx->sectype
> could be the same selected security type for the compared session. This
> causes the function to mismatch the potential same session, resulting in
> two of the same sessions.
>
> Reproduction steps:
>
> mount.cifs //server/share /mnt/a -o credentials=3Dcreds
> mount.cifs //server/share /mnt/b -o credentials=3Dcreds,sec=3Dntlmssp
> cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 1
>
> mount.cifs //server/share /mnt/b -o credentials=3Dcreds,sec=3Dntlmssp
> mount.cifs //server/share /mnt/a -o credentials=3Dcreds
> cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 2
>
> Fixes: 3f618223dc0bd ("move sectype to the cifs_ses instead of
> TCP_Server_Info")
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/connect.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index f917de020dd5..0c8c523d52be 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1825,8 +1825,11 @@ static int match_session(struct cifs_ses *ses,
>                          struct smb3_fs_context *ctx,
>                          bool match_super)
>  {
> +       struct TCP_Server_Info *server =3D ses->server;
> +       enum securityEnum selected_sectype =3D server->ops->select_sectyp=
e(ses->server, ctx->sectype);
> +
>         if (ctx->sectype !=3D Unspecified &&
> -           ctx->sectype !=3D ses->sectype)
> +           ctx->sectype !=3D selected_sectype)
>                 return 0;
>
>         if (!match_super && ctx->dfs_root_ses !=3D ses->dfs_root_ses)
> --
> 2.47.0
>
>


--=20
Thanks,

Steve
