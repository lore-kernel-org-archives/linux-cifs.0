Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A11C0015E
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Jul 2023 17:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjGZRDu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Jul 2023 13:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjGZRDt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Jul 2023 13:03:49 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208551724
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:03:46 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fcd615d7d6so10849700e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690391024; x=1690995824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0P8qA4ersnNBGw+4kmWLlSR4WRYnTn2VOzN9X6TIxxw=;
        b=Q1qltLsdcxZybA/5EU4IpxjlL6+8KrXUabQcd54erz1aae+veermtZHOB8Ek8f7Bap
         bpK8rPYmc/25XutYjf5TUcuqmsnnlILYVR7EpxSa8QxsBalmJk44AL7EbW6nFhEKvTNL
         3LmjaNc9o9sHv8SSwfhNi9sOofgLpTMZ4Qcf+1r5zUNGAn6sw7TfopS877/1ZoWPw/fh
         ybWnywN0Z8+6DTS+I9KMuBRwcBwUywqtzuMPdCxmbU0WB4mFS1Ag4H6LVLLu7jgrbCAV
         10aoN5dagTXtBD1GaaNqXxQMQaD8WgBPw0oekk0v34KzjVuOacf694MgOMdxyXq5XCGv
         y2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690391024; x=1690995824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0P8qA4ersnNBGw+4kmWLlSR4WRYnTn2VOzN9X6TIxxw=;
        b=ds9k5WQiRsN6gHu5mCz87sn0kcobJUBDEXzirMa9qV156vKq91GYi7/8P0Oq7BB+tU
         duwz8QK44nMNJ0REoU7YdWoWKSy5/tq4Qg86nDUJ7CE0ifSAW21CkEtEDYwuSfIJs82H
         Ucv0OolPavQYdJC1pNI26vl7/vMIe9k/4uiV6T/GfCki8ihzdRrOYsVxC8B+eCjj4XP3
         8lWdsH29BKIi7Y6oSo/mbx6P4QxRoqzfw1EG4NcEl7CiJgNSLFowvbQHbzszXzNS67pq
         vKO3+Byod01txcGqE0B4tkE1dzkoHLp/Anjlwh6pgeNgdQpmhI14dH4XcPhlXwsTa8AQ
         mIyg==
X-Gm-Message-State: ABy/qLZFo4UE6xdbtORciZWO82I8c2ZzCn2ErZOt+jPiTO4qS3sqPz8W
        SlXShPvHJgHCCPxzJS4VWFneqWt2u0w1UwEQnv9FwOO9SMQ=
X-Google-Smtp-Source: APBJJlFojys50Td7laiw0h+BrDiKOS+RVZXWLXGHv/jTB6s9QyRcp0IRkrCti12jwJlXXTAR2cNJUqdpyv7PUo+O1tY=
X-Received: by 2002:a05:6512:3b8:b0:4f4:c6ab:f119 with SMTP id
 v24-20020a05651203b800b004f4c6abf119mr1741762lfp.64.1690391023985; Wed, 26
 Jul 2023 10:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <e36ce0a0-7bed-4184-8068-82151f175bec@moroto.mountain> <CANT5p=rPMFfUwVwcAveqjom7MUNOZvU_Wqp_3g+qgu5qJx+3sg@mail.gmail.com>
In-Reply-To: <CANT5p=rPMFfUwVwcAveqjom7MUNOZvU_Wqp_3g+qgu5qJx+3sg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 26 Jul 2023 22:33:32 +0530
Message-ID: <CANT5p=oQCEtWsscKr3gt6gJxAS=msCV+uyT-5EfSRCo526wAog@mail.gmail.com>
Subject: Re: [bug report] cifs: allow dumping keys for directories too
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jul 24, 2023 at 2:02=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Mon, Jul 24, 2023 at 1:25=E2=80=AFPM Dan Carpenter <dan.carpenter@lina=
ro.org> wrote:
> >
> > Hello Shyam Prasad N,
> >
> > The patch 27bfeaa7b929: "cifs: allow dumping keys for directories
> > too" from Jun 16, 2023 (linux-next), leads to the following Smatch
> > static checker warning:
> >
> >         fs/smb/client/ioctl.c:481 cifs_ioctl()
> >         error: 'tlink' dereferencing possible ERR_PTR()
> >
> > fs/smb/client/ioctl.c
> >     469                 case CIFS_DUMP_FULL_KEY:
> >     470                         /*
> >     471                          * Dump encryption keys (handles any ke=
y sizes)
> >     472                          */
> >     473                         if (pSMBFile =3D=3D NULL)
> >     474                                 break;
> >     475                         if (!capable(CAP_SYS_ADMIN)) {
> >     476                                 rc =3D -EACCES;
> >     477                                 break;
> >     478                         }
> >     479                         cifs_sb =3D CIFS_SB(inode->i_sb);
> >     480                         tlink =3D cifs_sb_tlink(cifs_sb);
> >
> > cifs_sb_tlink() requires error checking.
> >
> > --> 481                         tcon =3D tlink_tcon(tlink);
> >     482                         rc =3D cifs_dump_full_key(tcon, (void _=
_user *)arg);
> >     483                         cifs_put_tlink(tlink);
> >     484                         break;
> >     485                 case CIFS_IOC_NOTIFY:
> >     486                         if (!S_ISDIR(inode->i_mode)) {
> >     487                                 /* Notify can only be done on d=
irectories */
> >     488                                 rc =3D -EOPNOTSUPP;
> >     489                                 break;
> >     490                         }
> >     491                         cifs_sb =3D CIFS_SB(inode->i_sb);
> >     492                         tlink =3D cifs_sb_tlink(cifs_sb);
> >     493                         if (IS_ERR(tlink)) {
> >     494                                 rc =3D PTR_ERR(tlink);
> >     495                                 break;
> >     496                         }
> >     497                         tcon =3D tlink_tcon(tlink);
> >     498                         if (tcon && tcon->ses->server->ops->not=
ify) {
> >     499                                 rc =3D tcon->ses->server->ops->=
notify(xid,
> >     500                                                 filep, (void __=
user *)arg,
> >     501                                                 false /* no ret=
 data */);
> >     502                                 cifs_dbg(FYI, "ioctl notify rc =
%d\n", rc);
> >     503                         } else
> >     504                                 rc =3D -EOPNOTSUPP;
> >     505                         cifs_put_tlink(tlink);
> >     506                         break;
> >
> > regards,
> > dan carpenter
>
> Hi Dan,
>
> Thanks for bringing this to our notice.
> I think similar checks are missing in a few other places in the code.
> I'll submit a new patch for this soon.
>
> --
> Regards,
> Shyam

My bad. Only this change is missing the check.
Added that and submitted a new patch. Please check [PATCH] cifs: add
missing return value check for cifs_sb_tlink

--=20
Regards,
Shyam
