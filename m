Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F31EC001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Aug 2023 03:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357780AbjHRD4v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 23:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357836AbjHRD4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 23:56:47 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F34B3A93
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 20:56:43 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4ff8a1746e0so647280e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 20:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692331002; x=1692935802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXQ+sUMDXlBbVAdwFCOAtV9Qy8BSXkMPj479a8Y2YIw=;
        b=lZ/BU0qS07AxF82ScUN6Fpv0BySZ6Llj5f1iDXMQ8M/8rCWPUu1Nxu5e/KtG/OTByZ
         O/DJ8HtUuzuG4DvfBrhDE4OQWC/b477PXz1ppycXezq5svr+gMnzCRNaPMuuSx4aerox
         sk/NjfQT7ji+FE9LRMtTlfpX50z+gZx3EXnGBKOAwdWTGrMjAvxyjbsOLX5WtHxsF86R
         qm789eiV3KOFTlRF9YaTcHVELBX20CagluJdJBQ3tHhq+iCQG/+p8FCpxczuAyuLXqRf
         yJMXh1UTUorg4m8+y2SItouyTPLOaazc6EGeD3mU2qrEiEVxJmOzHfhDMbCJ3+5rM1YG
         RQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692331002; x=1692935802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NXQ+sUMDXlBbVAdwFCOAtV9Qy8BSXkMPj479a8Y2YIw=;
        b=I/fXEwrASVY9ofMeJFbTHZVQkYHQ/Gr+f3Sf2Jo7eZ0plIN/kmj0NY37m8VHK8z6Sk
         unf4108yA0WyUetw36dmM/GVvMXBuwvruzqY1P/n+FkiraXdHTFJQ3YOcGJU+ZHb/u1z
         r1ou9TYkhGvZfFpaf9zGFsRcbVTGhZwqvzsGTajghSjKXIo7maK0mp6vjE+imsWIA7HA
         VV5aE+AwmyFutL28z1jbeQxUcmev+1igN0o5SGZGoLjZ/e4Fm9MT34OP87pC2Mw6//rE
         Rej/7p9/YQL1E26GVU7dz4rgLN1oGiO7lg/MH+qDNSeNBjMGwF3UFG3posr1doMw7auE
         zOuw==
X-Gm-Message-State: AOJu0YyeIOHgLpsNW17Lu7g2ZTYbliATumUTQpfy7UrNnq8GJHAccK4z
        TTZsqxpUS2QPJYxpIm8Hr1I92xH48AbDEbn65Jo=
X-Google-Smtp-Source: AGHT+IH7vy5rSO1fWMQOmVaM51h2AxQgoj6rMktYkh8Mngmmj2BlFRli69yrcPxMCi1zGdqTJ7c+XINn2C3W2rmpUlU=
X-Received: by 2002:a05:6512:1189:b0:4ff:881d:620 with SMTP id
 g9-20020a056512118900b004ff881d0620mr1077295lfr.34.1692331001542; Thu, 17 Aug
 2023 20:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221115103936.3303416-1-zhangxiaoxu5@huawei.com>
 <20221115103936.3303416-2-zhangxiaoxu5@huawei.com> <CAH2r5mvxC=8Pe5SJ9HHyCbNFo48Xfzdyyji-ZqPnZMD28A1tog@mail.gmail.com>
In-Reply-To: <CAH2r5mvxC=8Pe5SJ9HHyCbNFo48Xfzdyyji-ZqPnZMD28A1tog@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 18 Aug 2023 09:26:30 +0530
Message-ID: <CANT5p=oq2j0knRv96B6HgxsS_Na5qk6BkHhavU+Xb5_6M-BR3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: Fix wrong return value checking when GETFLAGS
To:     Steve French <smfrench@gmail.com>
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 16, 2022 at 12:40=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> good catch - merged into cifs-2.6.git for-next
>
> The other two look reasonable but I wanted to do a little more testing
> on them - feedback/reviews on them welcome (especially patch 2)
>
> On Tue, Nov 15, 2022 at 3:35 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wr=
ote:
> >
> > The return value of CIFSGetExtAttr is negative, should be checked
> > with -EOPNOTSUPP rather than EOPNOTSUPP.
> >
> > Fixes: 64a5cfa6db9 ("Allow setting per-file compression via SMB2/3")
> > Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> > ---
> >  fs/cifs/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> > index 89d5fa887364..6419ec47c2a8 100644
> > --- a/fs/cifs/ioctl.c
> > +++ b/fs/cifs/ioctl.c
> > @@ -343,7 +343,7 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
> >                                         rc =3D put_user(ExtAttrBits &
> >                                                 FS_FL_USER_VISIBLE,
> >                                                 (int __user *)arg);
> > -                               if (rc !=3D EOPNOTSUPP)
> > +                               if (rc !=3D -EOPNOTSUPP)
> >                                         break;
> >                         }
> >  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
> > @@ -373,7 +373,7 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
> >                          *                     pSMBFile->fid.netfid,
> >                          *                     extAttrBits,
> >                          *                     &ExtAttrMask);
> > -                        * if (rc !=3D EOPNOTSUPP)
> > +                        * if (rc !=3D -EOPNOTSUPP)
> >                          *      break;
> >                          */
> >
> > --
> > 2.31.1
> >
>
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
