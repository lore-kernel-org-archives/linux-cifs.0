Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7A12B6A
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2lCONyV"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ccbc328744so47493021fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 09:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703870142; x=1704474942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dofN43VXWkM2wNCZHkHFpdfJqDmk692Vc0w/7BuIzBA=;
        b=C2lCONyVetl57aWIrblZu/8sCPCTy56X1/pWAyjMG/dTLPrMBh5ahglzMdYgvnaLTq
         6kKXFY/DqPsPBWXuWucONw4V20hTFYxIb7OVuhnX2KYFVa7PO1w1ZGvYGilocuwTOvUO
         uppPQywRGputq8jF5Kr8hfWeCAEuydLsi0YCdHKmdsJ61FYgyuH8n1q/5D9c8Rbht0hg
         6NbxLziEylJsHONwOlSy8cbyakZIXkbxM37asPtJohUPMcn4JUn5lnHm8twBw+LjjoLU
         13+Kb3nPqKGxJYDZu/BlnLdQOZlO39wlQYKQt4U/9vs8fiMyoiiPzF7bB6bK7NvZznUx
         MWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703870142; x=1704474942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dofN43VXWkM2wNCZHkHFpdfJqDmk692Vc0w/7BuIzBA=;
        b=nm97D7Xwxlfe4k4fAeVjplgPiKaFsMooAXXX8ByxHcIITdBwiZpQjW8mwbjhRtoDwU
         o08lOVJbdikFDu9bpD9bajPv7N6FQMj1sVwU323Tn4uUMznHjQ8WWPXc4H34ZFveZODZ
         PW+qvzdvFDH4iRAQv1FTlRyVE85VIobDC5MqfY1RFq/+OZpc33VipfqDqXBu4V4GZyh+
         bxWT+h63v8kSmqw4dNBDSnxiXSMKg7031PxKF68ER0X1oxTKNE8hRKQYVgujUeZtO3CB
         JkZ6+fEfnfvUGahX7HEX2Oq+/WJyEdbgA3lI4btFz2FlGm1BZGfekEiYmMG//9vE72Si
         X57A==
X-Gm-Message-State: AOJu0YzdK4jv0wGSzyNP0t9CVwBEZtHQrRRaWtplXMl0GscbTgUJlPzx
	dSAEG5yQCzH+cB4usJMZMv6UtmW/CE11w3r3qHR4yyWmzHY=
X-Google-Smtp-Source: AGHT+IGp0wX/SeL3Nu4jIrIgye/qHb7u5S+QAUVhiNojL/j/c6AX0t1CD/bTyVdyhH87G6m60AmxVdE5/QiNY58Ozqs=
X-Received: by 2002:a2e:9dd8:0:b0:2cc:8bd4:b860 with SMTP id
 x24-20020a2e9dd8000000b002cc8bd4b860mr5425583ljj.85.1703870141829; Fri, 29
 Dec 2023 09:15:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com> <20231229111618.38887-3-sprasad@microsoft.com>
 <CANT5p=reagZz5yL-3wutgyk0ePR=eRLkLqt3DYhW=kTXuvOXfQ@mail.gmail.com>
In-Reply-To: <CANT5p=reagZz5yL-3wutgyk0ePR=eRLkLqt3DYhW=kTXuvOXfQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Dec 2023 11:15:30 -0600
Message-ID: <CAH2r5mtfBB+Ci3c-Ct8bpuhNaVxfTcOd4rwJkb=bMQSjww-7Hw@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: cifs_pick_channel should skip unhealthy channels
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, meetakshisetiyaoss@gmail.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

for-next updated to remove that patch

On Fri, Dec 29, 2023 at 11:02=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > cifs_pick_channel does not take into account the current
> > state of the channel today. As a result, if some channels
> > are unhealthy, they could still get picked, resulting
> > in unnecessary errors.
> >
> > This change checks the channel transport status before
> > making the choice. If all channels are unhealthy, the
> > primary channel will be returned anyway.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/transport.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 4f717ad7c21b..f8e6636e90a3 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -1026,6 +1026,19 @@ struct TCP_Server_Info *cifs_pick_channel(struct=
 cifs_ses *ses)
> >                 if (!server || server->terminate)
> >                         continue;
> >
> > +               /*
> > +                * do not pick a channel that's not healthy.
> > +                * if all channels are unhealthy, we'll use
> > +                * the primary channel
> > +                */
> > +               spin_lock(&server->srv_lock);
> > +               if (server->tcpStatus !=3D CifsNew &&
> > +                   server->tcpStatus !=3D CifsGood) {
> > +                       spin_unlock(&server->srv_lock);
> > +                       continue;
> > +               }
> > +               spin_unlock(&server->srv_lock);
> > +
> >                 /*
> >                  * strictly speaking, we should pick up req_lock to rea=
d
> >                  * server->in_flight. But it shouldn't matter much here=
 if we
> > --
> > 2.34.1
> >
> Please skip this patch. I'll submit a revised patch next week.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
