Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD54BC43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 20:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8849A20663
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 20:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tzIzLMV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfFXUZh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 16:25:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44979 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXUZg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 16:25:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so7692610pgp.11
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 13:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yzvDWYs06EZoMy72rtg97V8n9i/gpqOvQpO7kHfHqu0=;
        b=tzIzLMV1Wdoa5Hh5wsVxi1QV5biFXYjtz2qvDoDlwDrjwD5tPvN+oaBiA3CXDckn/N
         N5H/0W9h0TrsZKAcgBqwETrvYt3JMSk+CObC8Y3lL0tP2XlrtVG/sjeIy+C3iZDgXQs5
         d1IaEs2RpNgqjFohKChoBx2g6tbl3nX7lxEVMZAnZFyfZXuqHjakHOMvf+4CxG2pQ9RM
         +Uns5VMjIa4BnSUBZzjjymSOCK0FwkJdt2BaCD+vWAQv2Aku6BLUoKgtTczFU/FQMEGf
         6QvlPb814P4RFEemZawbQ6FpvaQeuPgWPmRDPZCpa3oY9zi3t4htkacpnlBeYmb1+DaM
         +buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yzvDWYs06EZoMy72rtg97V8n9i/gpqOvQpO7kHfHqu0=;
        b=K2ZEPTcIHuvPiu8Pk71IuPA4Fvoxv0JKgMcf+bP3MY2vkr5d2Ro26Wk6fquO2ElxaC
         ZOwmWppqnasizMckjZu4EjrVCRLCe9TtcCIPGiAMAsB8fBv9sk01TgtT7HJiz6GTWfE0
         SxAjnmU43cv7h3atgg2xpn358KDjP0fGSQ0zRqA66/5qw24JckHz9PhurCjuM78KJxRX
         MSzGkGtX8uOlb3UFqEV2Q0qV50XggfbTtYRk/ngGnlEVOzFm+6lFGxd8yUX5XrVgmZOw
         y70OgKMtP5ETbA0pkWqRFlpEJ4HX/I3/df6T05zKmfsrO72uqNA20TyD7hEZVUkz6bU6
         EEhg==
X-Gm-Message-State: APjAAAXOqa1O8qnRPrizHCjtGL4QSO76r6rY7C2x+PvpfbmeaDCuSsUM
        1wUIRxkOsZdeJyZUseXKjVwwqERHtaCdSZywebk=
X-Google-Smtp-Source: APXvYqyR6Q6RglxXtUQ3oBtFJGLDfrl+B/Wf/MAJjao7UVM5c0jn5JQ/hCgol+nnPotuDwLnMiiXY2MaEFc6jHEXkFU=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr26169932pjb.138.1561407936066;
 Mon, 24 Jun 2019 13:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
 <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com>
In-Reply-To: <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 15:25:24 -0500
Message-ID: <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode
 from special ACE
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 24, 2019 at 2:07 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Can't we use the existing idfromsid for this purpose? We already have
> a plenty of mount options and the list keeps growing.

That is a good question - and I am open to suggestions to remove some
mount options but
the general problem is that that mount option name could be very confusing =
-
"idsfromsid" doesn't really imply anything about how we handle
mode bits (we could save mode bits even if saving uid owner without
using the "idsfromsid"
mechanism) we want to allow:

1) query mode from special sid if present
or
2) query mode from ACL (only check for perms on the three
user-owner/group-owner/EVERYONE SIDs), in this case we may chose to
mount noperm
or
3) the default today - we set mode for files and directories to the
permissions supplied as "file_mode" and "dir_mode")
We by default do:
      vol->dir_mode =3D vol->file_mode =3D S_IRUGO | S_IXUGO | S_IWUSR;
and we can mount with noperm to disable the client perm checks if the
checks on the client are not useful
or
4) set the permissions (temporarily) locally only and cache them
(dynperm) - typically not recommended.

Where I would like to get to is that we focus strongly on only the
first two common use cases:
1) "client focused perm checks"   -  get/set mode from special SID
(server permission checks are not important in this case)
2) "server focused perm checks" - get/set the three ACEs
(user-owner/group-owner/EVERYONE) in the ACL

I would like to default to idsfromsid (setting the owner with  if
looking up owner from Winbind or SSSD or falling back
to S-1-22-1 (Unmapped user's special SID) or S-1-5-88-1  (MS-NFS and
Apple style unmapped user's special SID).

In a way I would like to remove "idsfromsid" (and do it by default),
and add the new mount point to distinguish between

"client centric" mode bit evaluation (special mode SID)
vs.
"server centric" ACL evaluation (where mode bits are mapped into the 3
usual ACEs - user/group/other)



> =D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 00:20, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/it-=
pro/windows-server-2008-R2-and-2008/hh509017(v=3Dws.10)
> >
> > where it describes use of an ACE with special SID S-1-5-88-3 to store t=
he mode.
> >
> > Followon patches will add the support for chmod and query_info (stat)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
