Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9611C8B
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUMA/Ap4"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ccec6edfa9so7359281fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 07:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703862088; x=1704466888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XU8nPwfdvfEn2SEWFezhU7RLi6pB8xoOyos4a4HKzBI=;
        b=PUMA/Ap4CvfjObC68jfYF0KN2SnvtzR5IBT8fXFeNzT747by8iJ13aP1Rm7EEJrJSN
         Sb3//4CfYB6pa8xdTgJEDk3tVPJe8ht7f+4vFFioS9m3OSF9ygmn5uJFk6H+eVNeaVdq
         sqzmGtsqONiIbrzSy/6oOnd/0NuOiTtjluT21o/Xakzkn1iTnCR/1gOkE7R04l1xXW9z
         r9EhXbDbUqzu4T5+sXMnxiPpb4CFhuON6GU+7Y/rskjSqEQElVIQHRYiEM69XMMzBMJf
         obhIYz/fxjbtoFHhu+FRySyiwNOvOB5nGtcrh7km+MgikocY2GfX0w4pvHGP5uKFu5o1
         jhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703862088; x=1704466888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XU8nPwfdvfEn2SEWFezhU7RLi6pB8xoOyos4a4HKzBI=;
        b=HbvugWgsxyUk0FVIDDbRIY9Ho6QjMQn/hPXPdkwIw7imoSy7oD+yJCJlIM5GurT5+R
         AXeuxln/jtKuTIrerIT7s54HaZ8pUeyATpy9ncm4xGHKXfyPBuFcv8Z94Q5ChRUglLN4
         DAQgSdwWRw47o+N+ZTCLVGj7pym9mvNpEUsXGqGNL0BNRAdwz/EirfrxpwjLsvleX1+8
         OmGxrXat4d//Oh/hEixt9XinHQpDgOLXkMVQ3DTqUScUkrMhmDNCRJ4BLYncZwtLN6yF
         WB5ko5NLLpsr3GWZtkzqNEfk1A3X8AxiTIGZQP40TgObyjmQS3mkrMReU7pmEGKCrazu
         N78A==
X-Gm-Message-State: AOJu0YyvgaLhqMvUQRg6qV62gzkclaW/BJdcARf9MGPqgDgFSfF9P13h
	kY2DD2zYxPPRjj5T7lproSfQdhkIU8DGTrSAPwA=
X-Google-Smtp-Source: AGHT+IHF4XZ8Y+lTYECnJdf6EXTSGHrznYzVZ7Gc9oYQuCmhIRZtDYBYuNmYW0hWJYIsULidBpkyizaLu+nk1qdxFaE=
X-Received: by 2002:a05:651c:1a25:b0:2cc:f162:302a with SMTP id
 by37-20020a05651c1a2500b002ccf162302amr563751ljb.17.1703862087791; Fri, 29
 Dec 2023 07:01:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com> <CANT5p=rX81OL+cU+EVSRcv+xF_cHQQ+Oz6JkMQoTDzH6YVBWqA@mail.gmail.com>
 <CAH2r5mvNBNy56Q1vhj=1F_YELX00X9ok_8==njW=P_38F7oAHA@mail.gmail.com>
In-Reply-To: <CAH2r5mvNBNy56Q1vhj=1F_YELX00X9ok_8==njW=P_38F7oAHA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Dec 2023 09:01:16 -0600
Message-ID: <CAH2r5mu80KY0B_OAs+Teo+qJ7UD4B_hxy2PxiT_T=6XJsLQRLA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: cifs_chan_is_iface_active should be called with
 chan_lock held
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, meetakshisetiyaoss@gmail.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ignore my rebased patch. I applied his series in wrong order

On Fri, Dec 29, 2023 at 8:57=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> updated patch attached (to fix minor merge conflict)
>
> On Fri, Dec 29, 2023 at 5:25=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> > >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > cifs_chan_is_iface_active checks the channels of a session to see
> > > if the associated iface is active. This should always happen
> > > with chan_lock held. However, these two callers of this function
> > > were missing this locking.
> > >
> > > This change makes sure the function calls are protected with
> > > proper locking.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/connect.c | 7 +++++--
> > >  fs/smb/client/smb2ops.c | 7 ++++++-
> > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > index 8b7cffba1ad5..3052a208c6ca 100644
> > > --- a/fs/smb/client/connect.c
> > > +++ b/fs/smb/client/connect.c
> > > @@ -232,10 +232,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TC=
P_Server_Info *server,
> > >         spin_lock(&cifs_tcp_ses_lock);
> > >         list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, s=
mb_ses_list) {
> > >                 /* check if iface is still active */
> > > -               if (!cifs_chan_is_iface_active(ses, server))
> > > +               spin_lock(&ses->chan_lock);
> > > +               if (!cifs_chan_is_iface_active(ses, server)) {
> > > +                       spin_unlock(&ses->chan_lock);
> > >                         cifs_chan_update_iface(ses, server);
> > > +                       spin_lock(&ses->chan_lock);
> > > +               }
> > >
> > > -               spin_lock(&ses->chan_lock);
> > >                 if (!mark_smb_session && cifs_chan_needs_reconnect(se=
s, server)) {
> > >                         spin_unlock(&ses->chan_lock);
> > >                         continue;
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index 441d144bd712..104c58df0368 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -784,9 +784,14 @@ SMB3_request_interfaces(const unsigned int xid, =
struct cifs_tcon *tcon, bool in_
> > >                 goto out;
> > >
> > >         /* check if iface is still active */
> > > +       spin_lock(&ses->chan_lock);
> > >         pserver =3D ses->chans[0].server;
> > > -       if (pserver && !cifs_chan_is_iface_active(ses, pserver))
> > > +       if (pserver && !cifs_chan_is_iface_active(ses, pserver)) {
> > > +               spin_unlock(&ses->chan_lock);
> > >                 cifs_chan_update_iface(ses, pserver);
> > > +               spin_lock(&ses->chan_lock);
> > > +       }
> > > +       spin_unlock(&ses->chan_lock);
> > >
> > >  out:
> > >         kfree(out_buf);
> > > --
> > > 2.34.1
> > >
> >
> > This one fixes two changes. Not sure if it's valid to have two Fixes ta=
g.
>
> Yes - that is ok (two Fixes tags)
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
