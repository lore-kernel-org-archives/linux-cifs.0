Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67437C0015E
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jul 2023 03:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjGQDPL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Jul 2023 23:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjGQDOs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Jul 2023 23:14:48 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B4510E9
        for <linux-cifs@vger.kernel.org>; Sun, 16 Jul 2023 20:13:58 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so6310910e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 16 Jul 2023 20:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689563636; x=1690168436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nScr7lgAXXLHBUGAif5R5+zBC+kE5B0yCDCuuyrLDoY=;
        b=fyZodOrs2lkTy1lxx0FL3Ua5uPNMD/iiffK+iC9Wj/ERW/AQKsbIaQM9p/sU4ufTyk
         UsVCQdJe99QkTRmz+35/yQUXN7S+07M+RzTnORO5ILuXWaHkkR1XIqybpPubtpDyXT5f
         M/5byqMHjrXkAVDinsyz9LIXejhGjUOrv5L6o42UuRFPPZHL6t05LzkwK1SCm57+nmSY
         fD8xk8ztiODeel5A3Kl21JKZ9uVO516KU+bCr/E5xErAMr/AW6bRFSZOM+df1KR04TSG
         eLj/rOamy4GADQEZKOIYCvizX1ne8+iUHWn3uFlUPdfv3QTpdmjfsyMfSZ5hrBMY2qOb
         /nRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689563636; x=1690168436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nScr7lgAXXLHBUGAif5R5+zBC+kE5B0yCDCuuyrLDoY=;
        b=Wayp41ED5qhlVcKiATRP/+nLHqc88ivSoWeWucOmtFpMfy1JkJ3UyoyGuvui2JzIUR
         dTfHINn9Grc35CKDu1xSJHovC7FeuJ/lsudVf3G19hhYTu9f3ZqIHc/4LTVTW06tLrPM
         BXyBpj4ZQtrzZEIIY7ri4nRVJy6WeZqtevawaGgT3jwDY/FknVBe9bba76AVw6PyWhiu
         rFlnrx5n3NMxqWtIW4+qeSWDao6WyBonEFK4PnsxcT/tnNmlUWgTSMpPGWlXGqMZkNKd
         pm4RNJBmqTWHa/r0jXAcSYFKgEHXbHJvf3rRhs8ukWdB+bIFjBvkaoiGaczSMHCRBu0w
         PZTQ==
X-Gm-Message-State: ABy/qLYdUgITDEqQP3LMXID9XqHsVoaaebWI6o5WpMweonE4IL47muOi
        uUldKMCXz3eYiJcMz3/TJwtrqee31ez0jRyvzMQ=
X-Google-Smtp-Source: APBJJlG6RUyh3jzpgZRVdmt4yq3IsA9kskmursTbb0UvCmKKdRMqexOlSqdFCBG+3HYVYdtIcF8jeHs+VRfCVKUtBg8=
X-Received: by 2002:a05:6512:3a89:b0:4fb:8dcc:59e5 with SMTP id
 q9-20020a0565123a8900b004fb8dcc59e5mr8755004lfu.39.1689563636276; Sun, 16 Jul
 2023 20:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230714085634.10808-1-sprasad@microsoft.com> <20230714085634.10808-2-sprasad@microsoft.com>
 <CAH2r5muDwakr_nXp+TbaSK2YB4wabJaskvJRWCSFczMCtxhRQQ@mail.gmail.com>
In-Reply-To: <CAH2r5muDwakr_nXp+TbaSK2YB4wabJaskvJRWCSFczMCtxhRQQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 17 Jul 2023 08:43:45 +0530
Message-ID: <CANT5p=ofPzhrvkgUwqOrLgCHimUkxPHEja3Af3s4WFH3UwSS0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: is_network_name_deleted should return a bool
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, pc@cjr.nz,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 14, 2023 at 9:07=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> should we have a dynamic trace point for this event as well?

We do print the status returned from the server in smb3_cmd_err. So
strictly speaking we don't loose this info.
But we can have a tracepoint to make it jump out.

>
> On Fri, Jul 14, 2023 at 3:56=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > Currently, is_network_name_deleted and it's implementations
> > do not return anything if the network name did get deleted.
> > So the function doesn't fully achieve what it advertizes.
> >
> > Changed the function to return a bool instead. It will now
> > return true if the error returned is STATUS_NETWORK_NAME_DELETED
> > and the share (tree id) was found to be connected. It returns
> > false otherwise.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h |  2 +-
> >  fs/smb/client/connect.c  | 11 ++++++++---
> >  fs/smb/client/smb2ops.c  |  8 +++++---
> >  3 files changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index b212a4e16b39..bde9de6665a7 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -532,7 +532,7 @@ struct smb_version_operations {
> >         /* Check for STATUS_IO_TIMEOUT */
> >         bool (*is_status_io_timeout)(char *buf);
> >         /* Check for STATUS_NETWORK_NAME_DELETED */
> > -       void (*is_network_name_deleted)(char *buf, struct TCP_Server_In=
fo *srv);
> > +       bool (*is_network_name_deleted)(char *buf, struct TCP_Server_In=
fo *srv);
> >  };
> >
> >  struct smb_version_values {
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 87047bd38485..6756ce4ff641 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1233,9 +1233,14 @@ cifs_demultiplex_thread(void *p)
> >                         if (mids[i] !=3D NULL) {
> >                                 mids[i]->resp_buf_size =3D server->pdu_=
size;
> >
> > -                               if (bufs[i] && server->ops->is_network_=
name_deleted)
> > -                                       server->ops->is_network_name_de=
leted(bufs[i],
> > -                                                                      =
 server);
> > +                               if (bufs[i] !=3D NULL) {
> > +                                       if (server->ops->is_network_nam=
e_deleted &&
> > +                                           server->ops->is_network_nam=
e_deleted(bufs[i],
> > +                                                                      =
          server)) {
> > +                                               cifs_server_dbg(FYI,
> > +                                                               "Share =
deleted. Reconnect needed");
> > +                                       }
> > +                               }
> >
> >                                 if (!mids[i]->multiRsp || mids[i]->mult=
iEnd)
> >                                         mids[i]->callback(mids[i]);
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 153b300621eb..d32477315abc 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2391,7 +2391,7 @@ smb2_is_status_io_timeout(char *buf)
> >                 return false;
> >  }
> >
> > -static void
> > +static bool
> >  smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server=
)
> >  {
> >         struct smb2_hdr *shdr =3D (struct smb2_hdr *)buf;
> > @@ -2400,7 +2400,7 @@ smb2_is_network_name_deleted(char *buf, struct TC=
P_Server_Info *server)
> >         struct cifs_tcon *tcon;
> >
> >         if (shdr->Status !=3D STATUS_NETWORK_NAME_DELETED)
> > -               return;
> > +               return false;
> >
> >         /* If server is a channel, select the primary channel */
> >         pserver =3D CIFS_SERVER_IS_CHAN(server) ? server->primary_serve=
r : server;
> > @@ -2415,11 +2415,13 @@ smb2_is_network_name_deleted(char *buf, struct =
TCP_Server_Info *server)
> >                                 spin_unlock(&cifs_tcp_ses_lock);
> >                                 pr_warn_once("Server share %s deleted.\=
n",
> >                                              tcon->tree_name);
> > -                               return;
> > +                               return true;
> >                         }
> >                 }
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> > +
> > +       return false;
> >  }
> >
> >  static int
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
