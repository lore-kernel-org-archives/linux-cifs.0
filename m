Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED3CC7EE23
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Jun 2023 08:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjFKIBh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Jun 2023 04:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjFKIBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Jun 2023 04:01:36 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336711C
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:01:35 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b1acd41ad2so36776041fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686470493; x=1689062493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfhPQPN3HXedejaK3IkG7DnIJ/gHbjr9vhhktEnILE0=;
        b=Ad31u/v/q79E/DYpPk46w/8cgQTUzFhgzJXf8LFdknswrkWTGLqYj4CfX161TsF1ba
         nKMf3Z2b43aMpAj2ECyGdno9XMQMkwdWrZz6R+NxUUQNDpEbFia0WxEVPK/1gOidYk8f
         QTkYVqhxiMVWlmUy6LgkRqVHsNM3BGPb76Gvh1NkH1K34FslofPtYWmXJV4UqRgcrE2v
         LduE1Pub1Yi+wAdBrPMvB4TrLmd8/3ZkR7h+P5oQu3lrXto9QO+PlOjGpSE5IhFN0fzZ
         Pk4wP9UtdOVvIzLWM8mYt1C4kK8TrJTx3Vz4sWQXOouv6guvOPYZW78AunqkZ3I/K0LM
         stEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686470493; x=1689062493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfhPQPN3HXedejaK3IkG7DnIJ/gHbjr9vhhktEnILE0=;
        b=CZ3n1vJnPHNSn5YqyBzrMqPc408tMVgfKgMUOohaCI8cXJK2dAaLIoSg3UUrWs9GkX
         YRrM9CpWq1f/BR3S5QJ/qLYpNi/4Kb7TktwB4y22mC6IEGRI4wrZfaJK7E3iKbPg34pR
         +bOgVf76UmzDe1Q0+UkKeuQ9BSuszZmPFkTfGn7gIxemm/2b9j4O8lS6sKGZHkeDdMEQ
         496mUiuCFd+1mmh/XjnUe1ulxj7o8FwCMFLdbt2DsOwhawSMlTEch04U9qQZF1LNxo1n
         dsY2yDU7K/EJeK7JdGvzti/K+rxbzGfDSKIjLVhXDnschmDKfFh4FnqeP2u1ALsHHErq
         f5hA==
X-Gm-Message-State: AC+VfDx8WvP8Xq41g4x19PjxIZAwDPdzqI4/1PlaGF52+vr5SIo6jmW9
        TO7FjjCAQNHeubUTIIvLhF/VN36FHXV2cUpKAXk=
X-Google-Smtp-Source: ACHHUZ5nBDVbm7EMLQJSeo3O4fdNq+/NQWqNAlSIsbI+VrZUcN/3DJOM27cdqYQwSQJmqYm+dOIXTFZ6ysqZFXaNbT8=
X-Received: by 2002:a05:6512:559:b0:4f6:3fa1:19bb with SMTP id
 h25-20020a056512055900b004f63fa119bbmr2542576lfl.63.1686470493356; Sun, 11
 Jun 2023 01:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-3-sprasad@microsoft.com>
 <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 11 Jun 2023 13:31:22 +0530
Message-ID: <CANT5p=pa39qfZxu0jDp01L1AtvQTqoGdk1cB3jwq-rGOY-2+hg@mail.gmail.com>
Subject: Re: [PATCH 3/6] cifs: add a warning when the in-flight count goes negative
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, bharathsm.hsk@gmail.com,
        tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Jun 11, 2023 at 1:19=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> should this be a warn once? Could it get very noisy?
>
> On Fri, Jun 9, 2023 at 12:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > We've seen the in-flight count go into negative with some
> > internal stress testing in Microsoft.
> >
> > Adding a WARN when this happens, in hope of understanding
> > why this happens when it happens.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2ops.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 6e3be58cfe49..43162915e03c 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -91,6 +91,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
> >                                             server->conn_id, server->ho=
stname, *val,
> >                                             add, server->in_flight);
> >         }
> > +       WARN_ON(server->in_flight =3D=3D 0);
> >         server->in_flight--;
> >         if (server->in_flight =3D=3D 0 &&
> >            ((optype & CIFS_OP_MASK) !=3D CIFS_NEG_OP) &&
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve

Makes sense. We can have a warn once.

--=20
Regards,
Shyam
