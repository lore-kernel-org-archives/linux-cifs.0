Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7944C4332F
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Nov 2023 07:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjKDHux (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Nov 2023 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjKDHux (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Nov 2023 03:50:53 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC321AA
        for <linux-cifs@vger.kernel.org>; Sat,  4 Nov 2023 00:50:50 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c50305c5c4so39889471fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 Nov 2023 00:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699084248; x=1699689048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qjwxr6hE+pUzSRmlwuvXDjyRoc+hoacoMPDKn2nJU1E=;
        b=k3CsHOmI8yW7cpMtHlKNiE35ey5KuSV4q+xV1gnZfM2g+JVWiyofvnObH1htMxu7Jo
         rH9G5wkPpdV7wNoLBTnqUkAc03E/r2cddKNmM9bSx+bGQcMRzHK+qf9oD/0WFa7R1/zX
         /dCoQJtrM2eY7OZoZjUwY1it497QUkRQs40LmJEwzgchZDkmdlhCgzJWrFAkolDKFQNM
         5iF0RU2kdwaBBbPybWjGi4jEKOh1buYLQi0wKbTe1xQfwhHtPfOs33ThFop+5Sf6JVqL
         GJoXPvKbpzjIDd22UPG9oi5/kzz7ukIzIV9/bnp2+mHj5EoySfF040R9f8GQ+yi2DmNh
         pfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699084248; x=1699689048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qjwxr6hE+pUzSRmlwuvXDjyRoc+hoacoMPDKn2nJU1E=;
        b=pFE6uGJ8P+WgoJE4ow2pOKRlGIjG4yT8xA7KKjLt73hW6XNclkz2dCU5vssAviBTPm
         s8eiLFbYgfqn5m1G9tXKcewbz3XLhu3iIC3kQnhygq7m7msHVc321pAyGM7aKtLx8v0/
         O44KaT8GVClkElUUXPkhxoRySKi9Gt08OJGKaPto7KFVL9bTrvHMD2qJpmwzagxXVkZM
         ZS48O/so6Z0SMTiTv/xkFQiDz13NTULEQ91zSnKfccRfOhUReKyF5YJREGQ3abEq2h9E
         VvXL6uVZ1BaVLdxTJmoqPls7THFpxjnIo4FT4+vwjsg1ADQtuP0fVEuKjjubascYMW5p
         3VZg==
X-Gm-Message-State: AOJu0YzA0q5JGocKqIuFmvaFlxCSUliKv1NlA8WJDJlpu3NtFpns4NgY
        8JrLmBFIlMIv7hTB2Cq9W/igcy3qJFROfdM6Qoc=
X-Google-Smtp-Source: AGHT+IHEpTjwnhzcVYi+Erm8CbcLrnt//k05A8PW+4j2WMUxlVrm7wQdZLf/ojLoP3EtS6br+1QaG0QoRkJtuuok7aU=
X-Received: by 2002:ac2:5f51:0:b0:507:9f4c:b72 with SMTP id
 17-20020ac25f51000000b005079f4c0b72mr16593825lfz.15.1699084247777; Sat, 04
 Nov 2023 00:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-11-sprasad@microsoft.com>
 <412fe393cd49401e26a5624f0290eb43.pc@manguebit.com>
In-Reply-To: <412fe393cd49401e26a5624f0290eb43.pc@manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 4 Nov 2023 13:20:36 +0530
Message-ID: <CANT5p=rTDZytfeE+=kqWawNQNJ2_ffAp5hkgL6D2WB7s1RBdcw@mail.gmail.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting multichannel
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 1, 2023 at 9:22=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > When the user mounts with multichannel option, but the
> > server does not support it, there can be a time in future
> > where it can be supported.
> >
> > With this change, such a case is handled.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsproto.h |  4 ++++
> >  fs/smb/client/connect.c   |  6 +++++-
> >  fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++++++++++++++---
> >  3 files changed, 37 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 65c84b3d1a65..5a4c1f1e0d91 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -132,6 +132,10 @@ extern int SendReceiveBlockingLock(const unsigned =
int xid,
> >                       struct smb_hdr *in_buf,
> >                       struct smb_hdr *out_buf,
> >                       int *bytes_returned);
> > +
> > +void
> > +smb2_query_server_interfaces(struct work_struct *work);
> > +
>
> Why are you exporting this?  smb2_query_server_interfaces() seems to be
> used only in fs/smb/client/connect.c.

In an earlier version of this change, I was calling
smb2_query_server_interfaces from smb2_reconnect when multichannel is
reenabled.
That needed the export. However, I had to change that.
I will reset this back.

>
> >  void
> >  cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
> >                                     bool all_channels);
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index e71aa33bf026..149cde77500e 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -116,7 +116,8 @@ static int reconn_set_ipaddr_from_hostname(struct T=
CP_Server_Info *server)
> >       return rc;
> >  }
> >
> > -static void smb2_query_server_interfaces(struct work_struct *work)
> > +void
> > +smb2_query_server_interfaces(struct work_struct *work)
> >  {
>
> Ditto.
>
> >       int rc;
> >       int xid;
> > @@ -134,6 +135,9 @@ static void smb2_query_server_interfaces(struct wor=
k_struct *work)
> >       if (rc) {
> >               cifs_dbg(FYI, "%s: failed to query server interfaces: %d\=
n",
> >                               __func__, rc);
> > +
> > +             if (rc =3D=3D -EOPNOTSUPP)
> > +                     return;
>
> Maybe also get rid of cifs_dbg() when rc =3D=3D -EOPNOTSUPP?
>
> >       }
> >
> >       queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index b7665155f4e2..2617437a4627 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -163,6 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >       int rc =3D 0;
> >       struct nls_table *nls_codepage =3D NULL;
> >       struct cifs_ses *ses;
> > +     int xid;
> >
> >       /*
> >        * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
> > @@ -307,17 +308,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_t=
con *tcon,
> >               tcon->need_reopen_files =3D true;
> >
> >       rc =3D cifs_tree_connect(0, tcon, nls_codepage);
> > -     mutex_unlock(&ses->session_mutex);
> >
> >       cifs_dbg(FYI, "reconnect tcon rc =3D %d\n", rc);
> >       if (rc) {
> >               /* If sess reconnected but tcon didn't, something strange=
 ... */
> > +             mutex_unlock(&ses->session_mutex);
> >               cifs_dbg(VFS, "reconnect tcon failed rc =3D %d\n", rc);
> >               goto out;
> >       }
> >
> > -     if (smb2_command !=3D SMB2_INTERNAL_CMD)
> > -             mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
>
> Why are you removing this optimisation?  For example, session/tcon
> reconnect will no longer be triggered after returning back to userspace,
> only when next I/O comes in.



--=20
Regards,
Shyam
