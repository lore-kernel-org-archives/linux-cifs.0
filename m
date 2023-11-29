Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="New9T82N"
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5842A111
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 01:00:50 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c9bd3ec4f6so7218561fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 01:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701248448; x=1701853248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pFuL00TQhCcVZfMVgaNXenuQkQlWcNGho3KyZnSL4g=;
        b=New9T82Nh8toz3l7fj2pqTfLlPZr4AxZEtesedLrs77rKNz1M43U2q90ZGg7AzpCGE
         jWOy4anVQwQkY5jvCS+yY7QWbJS0+kAdJtI2cMhaXlm4XhxiOoQ+S2LRbZzo6eJQJ1q6
         AcACTJA3DdK2nUU7D51SxwEQo/pUN3pa7HUxSEaWKMpk2RoKiYlnc+EIrmdETFAIiD6N
         sd3iP5mVWVIBXxW6p5Lp1Pad/GMcbuBIn8tKTFjH7QPj94xahQa4vMovSP2ti0446VTM
         wwXp4OOQYPCT48KpC8h9iKrVDs5mUfA7uM40zs3faV2CND33hOdulnWz46F6oclwgRoh
         TwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701248448; x=1701853248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pFuL00TQhCcVZfMVgaNXenuQkQlWcNGho3KyZnSL4g=;
        b=vRD7caHKUC0xhSplUpLv6yxmdmdLyHNDuqdze0QoimGWVYrkrWkP7xJ4ksKhRLHvJF
         /R3ndFUfCAd5dfcy0M9C9ogL5iNaa4Tp4eJWjlfhe7dgWQzkX0TCpAENxAHcKscmu55l
         sgRU5ivNdySrbr0CnKbahKenkWu63G/TFDg0akM6WnMUVwVncXpLu8uH4P66CH6aAI9x
         b0EOgTH9QUidawWOBbpxApHJSZebso2qRC5XtvvWWLGecNF25H6XlyWTC7n3FXKJtr/J
         xFR/HvCN/Iccy/suB/rA1kOF/U8OIjHs2/K+nBiqrhnnFTBXgRFbf8hkoyaM8Pxlys+r
         FcSA==
X-Gm-Message-State: AOJu0YwaSeIUEduPzdOtXy+TLO6KdXb846pS3K7AS/lJL5SI5sWTNqK0
	H19kqIoXAyD1viDuIe8IJAH7DT9DV/AvZX/tJK13Dg+l
X-Google-Smtp-Source: AGHT+IGSjL+tUQADxOujmVlcb0hat5Uj0U7zXwyoN6tMoyLXMIU4S0cOTMlme50Hhr5MT+AtmTMJPPFKycFGiXjawMo=
X-Received: by 2002:a2e:b5d3:0:b0:2c9:a05c:547d with SMTP id
 g19-20020a2eb5d3000000b002c9a05c547dmr6192342ljn.34.1701248448142; Wed, 29
 Nov 2023 01:00:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <234ee19f9706fa55af3bae3e339e39c42d5b0b0a.1701060106.git.pierre.mariani@gmail.com>
In-Reply-To: <234ee19f9706fa55af3bae3e339e39c42d5b0b0a.1701060106.git.pierre.mariani@gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 29 Nov 2023 14:30:37 +0530
Message-ID: <CANT5p=o6NBZn15pVk885tC7PhRoYJjw5-Mx0Li5EN6_MTw7-ow@mail.gmail.com>
Subject: Re: [PATCH 2/4] smb: client: Protect ses->chans update with chan_lock
 spin lock
To: Pierre Mariani <pierre.mariani@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 10:22=E2=80=AFAM Pierre Mariani
<pierre.mariani@gmail.com> wrote:
>
> Protect the update of ses->chans with chan_lock spin lock as per document=
ation
> from cifsglob.h.
> Fixes Coverity 1561738.
>
> Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> ---
>  fs/smb/client/connect.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 449d56802692..0512835f399c 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2055,6 +2055,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>         spin_unlock(&cifs_tcp_ses_lock);
>
>         /* close any extra channels */
> +       spin_lock(&ses->chan_lock);
>         for (i =3D 1; i < ses->chan_count; i++) {
>                 if (ses->chans[i].iface) {
>                         kref_put(&ses->chans[i].iface->refcount, release_=
iface);
> @@ -2063,11 +2064,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>                 cifs_put_tcp_session(ses->chans[i].server, 0);
>                 ses->chans[i].server =3D NULL;
>         }
> +       spin_unlock(&ses->chan_lock);
>
>         /* we now account for primary channel in iface->refcount */
>         if (ses->chans[0].iface) {
>                 kref_put(&ses->chans[0].iface->refcount, release_iface);
> +               spin_lock(&ses->chan_lock);
>                 ses->chans[0].server =3D NULL;
> +               spin_unlock(&ses->chan_lock);
>         }
>
>         sesInfoFree(ses);
> --
> 2.39.2
>
>

Hi Pierre,

Thanks for proposing this change.

While it is true in general that chan_lock needs to be locked when
dealing with session channel details, this particular instance above
is during __cifs_put_smb_ses.
And this code is reached when ses_count has already reached 0. i.e.
this process is the last user of the session.
So taking chan_lock can be avoided. We did have this under a lock
before, but it resulted in deadlocks due to calls to
cifs_put_tcp_session, which locks bigger locks.
So the quick and dirty fix at that point was to not take chan_lock
here, knowing that we'll be the last user.

Perhaps a better fix exists?
Or we should probably document this as a comment for now.

This version of the patch will result in the deadlocks again.

--=20
Regards,
Shyam
