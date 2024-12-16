Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6BA1F03EA
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 20:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381811; cv=none; b=C5wTSdWBK5dDyTTucCKW9zxOxaU2+2i2HlIzGcsO9Sckn7qO6zRE+ZhF5+mZh7uPAsjdFhgpxnmaCpFldEOvE9tSHmcsF+crKf/lkunn/CHOx5v8HHUBAnEx0dIsf0elX8rdhIY75UmsrizyM8KDdKMKxjy+876+tyzC/C0dF1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381811; c=relaxed/simple;
	bh=YzOBWwJXq+gr5pD+zjivvl5CzSKcezJusBtIISQOaHo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u1wZaY5ooTQJJGOYk0WWkK/HVvD1knJJxsHEvJiC0uDKQBLD76GXL6Rs1ARX3JkykIIypy/b3wb9G4bo1CVS1N1XAXYKTez2RJBfz5fcXSfJ1K784C4cZV79P8RdykoZMQ2SW/yG6uReh42i4ehwTpGJ6dRoujW6nEo8b2AJuow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cDGWz0Mz; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cDGWz0Mz"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5401c52000fso4579771e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 12:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734381806; x=1734986606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dT4eKAzQPBGJCllASp1Ks7LU450jRKe9zEY/RP+jIA8=;
        b=cDGWz0MzCOXgQtD/cFhX7zeV3qDdwBY59R/ByAvriV9B019RfspwzD02kOYIl28qfB
         //GC/Rx8+l+RsJim47q5MeqmOg25JHWtha1/qpORqawrAsclUXgdkgCP4DApv0JQN6g9
         C4//b0WNLWk92c3eiWOo2qtO59a3rUC1kV3J8gAV2KRluuX/y17GPGJALd1vUxzeXl6t
         YXtZPHm33lpU7bqpo7Ryp6E+3AWzVs2ojQV2Kg7kMXPp68Ux7Pl6GxyV0hUlEprV9E78
         wZX1JrJenf4WcQw+Deykh5meOqiOO7phxXfsq4PhGfVsZYKpxpy+suQLLF60xhadtN6T
         InzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734381806; x=1734986606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dT4eKAzQPBGJCllASp1Ks7LU450jRKe9zEY/RP+jIA8=;
        b=jX3CY2BMyOxwEIxn/lxVxqvkRY6C1Oxn4aQqCMKV4Zi53uXDKLA2PLstz5jMPxz6+g
         QZTYl8pLoYjFEvydASi0WDSpm915lLWg48x/mIJTOJES1CSGHVAqP47OUiHov/H6N7dt
         rCxqOE1s7yEIh4IoHTGH9yHOdMfSHKWUulpCU/C3jShPYjwfxStnYUjvnm3PHwAAVoLS
         NsTX0dVxdAa+wPfoX5xv4n6025pjrUREtlO1EVWJXBd3urBImpRaoYeY1UlZGzmnhdG2
         y18sU2HXyvVnjV4cPotlb+XGqUdOhjwF7eMH3zsttqQHbY9DBoAZ6g9P6vY97ng6mvgp
         224w==
X-Gm-Message-State: AOJu0Ywqt5qpLxdi2n5yP5RnUaUuRQsOAdL78MI6b3bO0X6sUnKG3Nsh
	5RV2HjLIMKAohLI5NDnBqhtpap1Ad/s6O66xEwL5Hr1o5YgpV/xbQ24g1PH9qhXsr+vGFFdtLqZ
	mnMzO7Km98uSjVJcNNcdXD4wWLI4=
X-Gm-Gg: ASbGnctM+s/7vEDSVHUn70LBxSuWlFcub1W+M8b/IE2XKRqMD3XggaNsQuy64FW7bXa
	5OJFRZ/GlFTa2zu6dVzfKdnK3v+Y3B8MD8dKIAKy4axUUrGg9wwi2PsLW58yKku2AD8J4Kv/X
X-Google-Smtp-Source: AGHT+IGLDlKbpm4khM72VtntJzHAFA/li38TvFuaiKEe4FkeMcMt3t37LUjT7AfmZ2lSaB1xpsqUt2ZSgdk6aThrzVw=
X-Received: by 2002:a05:6512:3082:b0:53f:231e:6fa2 with SMTP id
 2adb3069b0e04-5409055dd7bmr4279325e87.26.1734381806182; Mon, 16 Dec 2024
 12:43:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241216183148.4291-1-bharathsm@microsoft.com>
In-Reply-To: <20241216183148.4291-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Dec 2024 14:43:15 -0600
Message-ID: <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
Subject: Re: [PATCH] smb: enable reuse of deferred file handles for write operations
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending review and more testing

On Mon, Dec 16, 2024 at 12:36=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> Previously, deferred file handles were reused only for read
> operations, this commit extends to reusing deferred handles
> for write operations.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/file.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index a58a3333ecc3..98deff1de74c 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct file *file=
)
>         }
>
>         /* Get the cached handle as SMB2 close is deferred */
> -       rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> +       if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
> +               rc =3D cifs_get_writable_path(tcon, full_path, FIND_WR_AN=
Y, &cfile);
> +       } else {
> +               rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> +       }
>         if (rc =3D=3D 0) {
>                 if (file->f_flags =3D=3D cfile->f_flags) {
>                         file->private_data =3D cfile;
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
