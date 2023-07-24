Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DF4C001DE
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jul 2023 08:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjGXIcz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jul 2023 04:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjGXIcu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jul 2023 04:32:50 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCEAE7F
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 01:32:45 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fba8f2197bso6053720e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 01:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690187564; x=1690792364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vbJBu7YI8B2H4GwOk4jz92za3hzF3SkRToEoCI4Z+A=;
        b=jPjU44c5EQpCO3N4vP7MVUXPV6YJ6QFyEBeGNyXXn+V1/tDgtCVgxpWmfYLb5b+0Tp
         zbkf/o1AveOAKsCMMdYKjdUobM98cqtxEVZ9hQoscxbDOccd6fB6BOl4tqGfSqcy8Hph
         9Sac3Qi7ux7a+awkCoRnKMSbniotTcR3ovHK84xdmRCCcQ4PxSNeOerjgJ6FOl8U2FA9
         vpTv8sQIrmi1s7jY9T6QoPd0vBfhAeIninLF3d9XopL/4yjmrv7jiI+1R46aeetwAgDU
         6kaBhDOYSgEejK/3XUTdTWN8Savu+THlpFSVt/9gsVyv5tjcqPCvh/Mz1QVOZbf+Hp6C
         vRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690187564; x=1690792364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vbJBu7YI8B2H4GwOk4jz92za3hzF3SkRToEoCI4Z+A=;
        b=J5rTm0iHRwoinrQwxrJhL+safsmhVnAKWOXeyxyN57//oDugDb9YUGPOy1v2ktS+L1
         B8R9ty/F87eV9tnUbWiqrCLbZLDYYUx9VgU3W/QkbV20KvoF6UrigxIfWucci1bmfUrw
         8gUF9zayrwLFIFAhgLHq6V5AgY1pVy910abeLTFr+SfCj5slcaztTgf9MSpcBuzV/vnc
         xSJWM2kLQtrj6HftBI9z7/b8Cd1yM8u1R2iHvpv1lzF2qZKcAnqKY6swHeSYPu1MxHT5
         DkexPhqGXG2M6ua8Ldtr8SZmVTPj/8EE1XqmdEUgXmHToDpBbsYQZK/67odR69uAUMk3
         JPFA==
X-Gm-Message-State: ABy/qLaYnKtx1aEJjR4z/naeQRwsBs/t4+ZDzgTj5lp5fnBVfwilfEXA
        9XSXn7KloxWK5hG5ckfK9aDI4pEBf8YT4vPS7aTdE8nw
X-Google-Smtp-Source: APBJJlGjSX+KnUIeEipbvUdpMeSbIdjYisVO18NqdIa3QrFmamtMEU/dftBhj2DaMxqR3Z6w/AIZ1UpcIQrSioVkMXk=
X-Received: by 2002:a19:7110:0:b0:4f8:7551:7485 with SMTP id
 m16-20020a197110000000b004f875517485mr4466081lfc.5.1690187563763; Mon, 24 Jul
 2023 01:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <e36ce0a0-7bed-4184-8068-82151f175bec@moroto.mountain>
In-Reply-To: <e36ce0a0-7bed-4184-8068-82151f175bec@moroto.mountain>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 24 Jul 2023 14:02:32 +0530
Message-ID: <CANT5p=rPMFfUwVwcAveqjom7MUNOZvU_Wqp_3g+qgu5qJx+3sg@mail.gmail.com>
Subject: Re: [bug report] cifs: allow dumping keys for directories too
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jul 24, 2023 at 1:25=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hello Shyam Prasad N,
>
> The patch 27bfeaa7b929: "cifs: allow dumping keys for directories
> too" from Jun 16, 2023 (linux-next), leads to the following Smatch
> static checker warning:
>
>         fs/smb/client/ioctl.c:481 cifs_ioctl()
>         error: 'tlink' dereferencing possible ERR_PTR()
>
> fs/smb/client/ioctl.c
>     469                 case CIFS_DUMP_FULL_KEY:
>     470                         /*
>     471                          * Dump encryption keys (handles any key =
sizes)
>     472                          */
>     473                         if (pSMBFile =3D=3D NULL)
>     474                                 break;
>     475                         if (!capable(CAP_SYS_ADMIN)) {
>     476                                 rc =3D -EACCES;
>     477                                 break;
>     478                         }
>     479                         cifs_sb =3D CIFS_SB(inode->i_sb);
>     480                         tlink =3D cifs_sb_tlink(cifs_sb);
>
> cifs_sb_tlink() requires error checking.
>
> --> 481                         tcon =3D tlink_tcon(tlink);
>     482                         rc =3D cifs_dump_full_key(tcon, (void __u=
ser *)arg);
>     483                         cifs_put_tlink(tlink);
>     484                         break;
>     485                 case CIFS_IOC_NOTIFY:
>     486                         if (!S_ISDIR(inode->i_mode)) {
>     487                                 /* Notify can only be done on dir=
ectories */
>     488                                 rc =3D -EOPNOTSUPP;
>     489                                 break;
>     490                         }
>     491                         cifs_sb =3D CIFS_SB(inode->i_sb);
>     492                         tlink =3D cifs_sb_tlink(cifs_sb);
>     493                         if (IS_ERR(tlink)) {
>     494                                 rc =3D PTR_ERR(tlink);
>     495                                 break;
>     496                         }
>     497                         tcon =3D tlink_tcon(tlink);
>     498                         if (tcon && tcon->ses->server->ops->notif=
y) {
>     499                                 rc =3D tcon->ses->server->ops->no=
tify(xid,
>     500                                                 filep, (void __us=
er *)arg,
>     501                                                 false /* no ret d=
ata */);
>     502                                 cifs_dbg(FYI, "ioctl notify rc %d=
\n", rc);
>     503                         } else
>     504                                 rc =3D -EOPNOTSUPP;
>     505                         cifs_put_tlink(tlink);
>     506                         break;
>
> regards,
> dan carpenter

Hi Dan,

Thanks for bringing this to our notice.
I think similar checks are missing in a few other places in the code.
I'll submit a new patch for this soon.

--=20
Regards,
Shyam
