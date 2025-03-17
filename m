Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F155629CE8
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 22:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742250895; cv=none; b=EIYoVS3LNQkDO3cvVvNQvYQ8A13SNiDMA5XPu344TZ5BY1rRqPeOy5+S4gpdtk+Re+YMaUJoDhAMb//DTdye3z52dLf40faNCHf4HDUJIXL4DHgRkRCZyQnfzj5LbyqcmeCdxuxQFVI76h84BysDPnTJOeHibSfASYoxzFV3ReY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742250895; c=relaxed/simple;
	bh=6ecrxSiftbBlcyDDhdH93tXnyC2offesZ8csGFyWIvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwNCEUcKSFmoDwOmP210JYn5LfIKIrreJJv1qFF1oIKusbYKd2wWUqlBPImOQ300Ts2RQLGaFswvSOjVRB1S+kqmf8vwgiSr8fcmbVAiwXAd+f9i/uXuQIcCZ/lovSffVLtKMTfxpvkU1pqbdOR33sihzcW6khRzo2eiz88sTRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAU9Vt16; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAU9Vt16"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-30bfe0d2b6dso55980761fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 15:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742250892; x=1742855692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WP9GVY5wXnVPdABMxT132Hdb0HTvxlI9jCXFvQQDPsc=;
        b=KAU9Vt16vJSzdbHIK5tEUvT/2iZKQdzVkxyVzPebBKE21hAb2nGq84t8V2+D5U1iP1
         GgHJE3uOrqHkzNQBAqD4FI5r7m5zFUrj6zDGS0QscBqnueP1Sug35Is8SWPUKpJ4/xe3
         X1qv+7EXzewFsXFhpebapkRb83BWquhcO+2ckfQi05aFIURgQZiQKuDODjnV7UcVhXxC
         vZvMZ5fn6+KQvMyhanmbd8YBzJrGPUoyNFzq162hloHItuIYTUz5Co798G2jmLg+Ju7n
         dMpYJj6N7il2d//EwSEqhWFI3n2TvseU4GPaC6fVIoxwkvJVe7yLjl2dfKv+SipcW62R
         LMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742250892; x=1742855692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WP9GVY5wXnVPdABMxT132Hdb0HTvxlI9jCXFvQQDPsc=;
        b=LcfiQPaMuERsY5ZvmeodO75qxWH8W9aOzKw1LxzKA+SOUMYVrnCUsxNiKq+hpHlNE5
         KYpjgqLZuoVkP3uJudH703N2TmCpbBefJzF6Vy6jxajA1/g1WIAIIirk/NjRinocFXyx
         asKHqUlv0vhhT3SYrpoo8yg9Y1m/0aVrSTWcTuV9pRidX07i4EZQt/G5ZWXZ6vMiJiRA
         sXxUXMt4DjL/Ql9YyJtzw/fR++3lm2NYSkIyptOZkeUXb/ROm5oofFltkD8QVqimrc2m
         B9exGfwDHQSOlVwoZLXsf0pGOkQbX27K2aOIYgXb+RoBX1Avurnwjpe8zWQ4sa4ZPnQX
         xznQ==
X-Gm-Message-State: AOJu0YygEdy2pbKr0WQlQm9UndqqmKObcqAs0LfJO13NBeuBMzBhwJ9p
	SjvhpYKtIq3ohVLjT2fKd6MMh3USbrc/KbJIZd3Cf0tstnaE5jDW4/jyxD2ysSem1FFFW9vyDq2
	SAz0iaKiih+L76CB7GPPlkNlSYaU=
X-Gm-Gg: ASbGnctyH0+xvzIwCvSohGt9LXbCzLafRhkYSoG0cxLzvYPwtiP4UHG8y9J8q5uDkJo
	O4x6zTogJJkHegPBzwojubwNfT1P9/8n5pM22SncZVfCSNFgOZsIqfyAiGioDZK1SJc9Hwnl8KO
	HoYuS8k2Mx3c1HIICVUVnCxkIbpdefg5J1MM8kPaGIC0P+toOnKPDCpAhjnnDjqHBxJ/vSCw==
X-Google-Smtp-Source: AGHT+IEy8gKx8GtYXa/X1sBzf9P2kzvLzXOYRBqwPdm/HJKzPBeRJG94JSExotsIxARTNdYTtq+YUjI2v1gf0nuag3A=
X-Received: by 2002:a05:6512:b89:b0:545:d27:e367 with SMTP id
 2adb3069b0e04-549c3989e00mr7567178e87.42.1742250891707; Mon, 17 Mar 2025
 15:34:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317193922.388668-1-pc@manguebit.com>
In-Reply-To: <20250317193922.388668-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Mar 2025 17:34:40 -0500
X-Gm-Features: AQ5f1Jp4sIOt9e6_8D6Fvfnm9B_5xdlFHgU8dmqngtsA_b-OMfeuBcjeWdJOF4k
Message-ID: <CAH2r5mt+oDrfzLgrBAxeAKYCaoTjfuh_mQ5QpP_EUcqPmXMWrQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: don't retry IO on failed negprotos with soft mounts
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Jay Shin <jaeshin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next pending additional review/testing

On Mon, Mar 17, 2025 at 2:39=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> If @server->tcpStatus is set to CifsNeedReconnect after acquiring
> @ses->session_mutex in smb2_reconnect() or cifs_reconnect_tcon(), it
> means that a concurrent thread failed to negotiate, in which case the
> server is no longer responding to any SMB requests, so there is no
> point making the caller retry the IO by returning -EAGAIN.
>
> Fix this by returning -EHOSTDOWN to the callers on soft mounts.
>
> Cc: David Howells <dhowells@redhat.com>
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/cifssmb.c | 46 ++++++++++++--------
>  fs/smb/client/smb2pdu.c | 96 ++++++++++++++++++-----------------------
>  2 files changed, 69 insertions(+), 73 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index d07682020c64..4fc9485c5d91 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -114,19 +114,23 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb=
_command)
>
>         mutex_lock(&ses->session_mutex);
>         /*
> -        * Recheck after acquire mutex. If another thread is negotiating
> -        * and the server never sends an answer the socket will be closed
> -        * and tcpStatus set to reconnect.
> +        * Handle the case where a concurrent thread failed to negotiate =
or
> +        * killed a channel.
>          */
>         spin_lock(&server->srv_lock);
> -       if (server->tcpStatus =3D=3D CifsNeedReconnect) {
> +       switch (server->tcpStatus) {
> +       case CifsExiting:
>                 spin_unlock(&server->srv_lock);
>                 mutex_unlock(&ses->session_mutex);
> -
> -               if (tcon->retry)
> -                       goto again;
> -               rc =3D -EHOSTDOWN;
> -               goto out;
> +               return -EHOSTDOWN;
> +       case CifsNeedReconnect:
> +               spin_unlock(&server->srv_lock);
> +               mutex_unlock(&ses->session_mutex);
> +               if (!tcon->retry)
> +                       return -EHOSTDOWN;
> +               goto again;
> +       default:
> +               break;
>         }
>         spin_unlock(&server->srv_lock);
>
> @@ -152,16 +156,20 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb=
_command)
>         spin_unlock(&ses->ses_lock);
>
>         rc =3D cifs_negotiate_protocol(0, ses, server);
> -       if (!rc) {
> -               rc =3D cifs_setup_session(0, ses, server, ses->local_nls)=
;
> -               if ((rc =3D=3D -EACCES) || (rc =3D=3D -EHOSTDOWN) || (rc =
=3D=3D -EKEYREVOKED)) {
> -                       /*
> -                        * Try alternate password for next reconnect if a=
n alternate
> -                        * password is available.
> -                        */
> -                       if (ses->password2)
> -                               swap(ses->password2, ses->password);
> -               }
> +       if (rc) {
> +               mutex_unlock(&ses->session_mutex);
> +               if (!tcon->retry)
> +                       return -EHOSTDOWN;
> +               goto again;
> +       }
> +       rc =3D cifs_setup_session(0, ses, server, ses->local_nls);
> +       if ((rc =3D=3D -EACCES) || (rc =3D=3D -EHOSTDOWN) || (rc =3D=3D -=
EKEYREVOKED)) {
> +               /*
> +                * Try alternate password for next reconnect if an altern=
ate
> +                * password is available.
> +                */
> +               if (ses->password2)
> +                       swap(ses->password2, ses->password);
>         }
>
>         /* do we need to reconnect tcon? */
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index ed7812247ebc..f9c521b3c65e 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -300,32 +300,23 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
>
>         mutex_lock(&ses->session_mutex);
>         /*
> -        * if this is called by delayed work, and the channel has been di=
sabled
> -        * in parallel, the delayed work can continue to execute in paral=
lel
> -        * there's a chance that this channel may not exist anymore
> +        * Handle the case where a concurrent thread failed to negotiate =
or
> +        * killed a channel.
>          */
>         spin_lock(&server->srv_lock);
> -       if (server->tcpStatus =3D=3D CifsExiting) {
> +       switch (server->tcpStatus) {
> +       case CifsExiting:
>                 spin_unlock(&server->srv_lock);
>                 mutex_unlock(&ses->session_mutex);
> -               rc =3D -EHOSTDOWN;
> -               goto out;
> -       }
> -
> -       /*
> -        * Recheck after acquire mutex. If another thread is negotiating
> -        * and the server never sends an answer the socket will be closed
> -        * and tcpStatus set to reconnect.
> -        */
> -       if (server->tcpStatus =3D=3D CifsNeedReconnect) {
> +               return -EHOSTDOWN;
> +       case CifsNeedReconnect:
>                 spin_unlock(&server->srv_lock);
>                 mutex_unlock(&ses->session_mutex);
> -
> -               if (tcon->retry)
> -                       goto again;
> -
> -               rc =3D -EHOSTDOWN;
> -               goto out;
> +               if (!tcon->retry)
> +                       return -EHOSTDOWN;
> +               goto again;
> +       default:
> +               break;
>         }
>         spin_unlock(&server->srv_lock);
>
> @@ -350,43 +341,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
>         spin_unlock(&ses->ses_lock);
>
>         rc =3D cifs_negotiate_protocol(0, ses, server);
> -       if (!rc) {
> -               /*
> -                * if server stopped supporting multichannel
> -                * and the first channel reconnected, disable all the oth=
ers.
> -                */
> -               if (ses->chan_count > 1 &&
> -                   !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNE=
L)) {
> -                       rc =3D cifs_chan_skip_or_disable(ses, server,
> -                                                      from_reconnect);
> -                       if (rc) {
> -                               mutex_unlock(&ses->session_mutex);
> -                               goto out;
> -                       }
> -               }
> -
> -               rc =3D cifs_setup_session(0, ses, server, ses->local_nls)=
;
> -               if ((rc =3D=3D -EACCES) || (rc =3D=3D -EKEYEXPIRED) || (r=
c =3D=3D -EKEYREVOKED)) {
> -                       /*
> -                        * Try alternate password for next reconnect (key=
 rotation
> -                        * could be enabled on the server e.g.) if an alt=
ernate
> -                        * password is available and the current password=
 is expired,
> -                        * but do not swap on non pwd related errors like=
 host down
> -                        */
> -                       if (ses->password2)
> -                               swap(ses->password2, ses->password);
> -               }
> -
> -               if ((rc =3D=3D -EACCES) && !tcon->retry) {
> -                       mutex_unlock(&ses->session_mutex);
> -                       rc =3D -EHOSTDOWN;
> -                       goto failed;
> -               } else if (rc) {
> +       if (rc) {
> +               mutex_unlock(&ses->session_mutex);
> +               if (!tcon->retry)
> +                       return -EHOSTDOWN;
> +               goto again;
> +       }
> +       /*
> +        * if server stopped supporting multichannel
> +        * and the first channel reconnected, disable all the others.
> +        */
> +       if (ses->chan_count > 1 &&
> +           !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +               rc =3D cifs_chan_skip_or_disable(ses, server,
> +                                              from_reconnect);
> +               if (rc) {
>                         mutex_unlock(&ses->session_mutex);
>                         goto out;
>                 }
> -       } else {
> +       }
> +
> +       rc =3D cifs_setup_session(0, ses, server, ses->local_nls);
> +       if ((rc =3D=3D -EACCES) || (rc =3D=3D -EKEYEXPIRED) || (rc =3D=3D=
 -EKEYREVOKED)) {
> +               /*
> +                * Try alternate password for next reconnect (key rotatio=
n
> +                * could be enabled on the server e.g.) if an alternate
> +                * password is available and the current password is expi=
red,
> +                * but do not swap on non pwd related errors like host do=
wn
> +                */
> +               if (ses->password2)
> +                       swap(ses->password2, ses->password);
> +       }
> +       if (rc) {
>                 mutex_unlock(&ses->session_mutex);
> +               if (rc =3D=3D -EACCES && !tcon->retry)
> +                       return -EHOSTDOWN;
>                 goto out;
>         }
>
> @@ -490,7 +479,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>         case SMB2_IOCTL:
>                 rc =3D -EAGAIN;
>         }
> -failed:
>         return rc;
>  }
>
> --
> 2.48.1
>


--=20
Thanks,

Steve
