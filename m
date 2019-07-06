Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C491C5B57D
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 02:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F3021670
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 02:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pG915B+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfGFCLb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 22:11:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37002 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGFCLb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jul 2019 22:11:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id g15so4994614pgi.4
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2019 19:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hw+b+neIW7MtsyNA6OjVyrNR6npi0LbyKRuYVuXizvY=;
        b=pG915B+TVRQIV0vGdhrMTVsUb2sy06/HH8qtObybfg7SDExbyMXEf30kpnFCEtzUhU
         o4h1EkVH5dqw3PjHEyqss+fNzq+6quZlIYcjsQOQD15p/Yj8Zi48tNAb0Q6M6HqLVyi2
         eLfC8OPalWMsJGnZ12TmUhvcYdDaGK9RyOZ+sB8NOHfWmPhfBSKXVoZ2IlRc75prs3c5
         4KKEB73IgJQmELCCVfxV30bs+jwYxEOquq1xLS3gqwSUZo/Ql0uimBJC680nyV569y+U
         Ekiz4rkOTVu87sqa04fc2XvTYzv0wb1O7IByo5JDMxxm0xSamPmP2KDw7g6b/DTKrw4P
         Bheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hw+b+neIW7MtsyNA6OjVyrNR6npi0LbyKRuYVuXizvY=;
        b=o8ZweJvkuYXpPGhDpbrDLramCzlwFlG5AiMBpcZyvfp3SG/5QYz1xPL1piNI+kf6VS
         EaEnDrziZEfBAG3FOZytgiOr0PlwvY04dbAKdDY94EZjsYH1vZgIDF7dyFd9jNF6jFLI
         hGy/AqbeTY547HGu2/CDaNEJM8RStiaVCG6LGZBS2RjgJwRwZjBU9G/oTo7MFSu0WyPH
         AMEnrN8jskS5qJDTgaMp/2xwT64U31sPh+PqupG5pLpl2+OqKX4HVkcRPnt6HuANw2jZ
         j/+aHPq3R9W5SHfWjjP5mVNBTkfaJvKiBMXPKMbr+yqaKUNQq1st3AJlazWe2Sv5z4UH
         PRGw==
X-Gm-Message-State: APjAAAWXeBo+EfKRFKrI+/F8dNzdf3na1VYOk6kpxDK2/5DLNUsNBajp
        YlHTLpEaeVB8Vj7ZNAqBpwtNstAgX8T44wXiBOY=
X-Google-Smtp-Source: APXvYqzEhBjKUa4ncEKFG3yudE02YJcUazuZIkTYKiCNVipsacMmUibRmeIF5CC2qTijY3BLc5U+KNMXGkGj1gRBH5I=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr8882505pjb.138.1562379090182;
 Fri, 05 Jul 2019 19:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
 <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com>
 <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com> <CAKywueRpx8tcDb7p+1_vDgCjRZ_0FYOGt8CSQLMa3ixgqxoscQ@mail.gmail.com>
In-Reply-To: <CAKywueRpx8tcDb7p+1_vDgCjRZ_0FYOGt8CSQLMa3ixgqxoscQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Jul 2019 21:11:18 -0500
Message-ID: <CAH2r5muuZt=zfADHpGOiTPX403fZ-Leqq92=LEFb7jzKXe=cbw@mail.gmail.com>
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

Updated "modefromace" to "modefromsid"

On Thu, Jul 4, 2019 at 3:52 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> These are good points and I agree with the plan.
>
> I would rename the option:
>
> "modefromace" -> ""modefromsid"
>
> to make the naming consistent with the existing "idsfromsid" and match
> the behavior closely: a mode is still technically from the special SID
> and that SID is from the special ACE. Other than that the patch looks
> good.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:25, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > On Mon, Jun 24, 2019 at 2:07 PM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Can't we use the existing idfromsid for this purpose? We already have
> > > a plenty of mount options and the list keeps growing.
> >
> > That is a good question - and I am open to suggestions to remove some
> > mount options but
> > the general problem is that that mount option name could be very confus=
ing -
> > "idsfromsid" doesn't really imply anything about how we handle
> > mode bits (we could save mode bits even if saving uid owner without
> > using the "idsfromsid"
> > mechanism) we want to allow:
> >
> > 1) query mode from special sid if present
> > or
> > 2) query mode from ACL (only check for perms on the three
> > user-owner/group-owner/EVERYONE SIDs), in this case we may chose to
> > mount noperm
> > or
> > 3) the default today - we set mode for files and directories to the
> > permissions supplied as "file_mode" and "dir_mode")
> > We by default do:
> >       vol->dir_mode =3D vol->file_mode =3D S_IRUGO | S_IXUGO | S_IWUSR;
> > and we can mount with noperm to disable the client perm checks if the
> > checks on the client are not useful
> > or
> > 4) set the permissions (temporarily) locally only and cache them
> > (dynperm) - typically not recommended.
> >
> > Where I would like to get to is that we focus strongly on only the
> > first two common use cases:
> > 1) "client focused perm checks"   -  get/set mode from special SID
> > (server permission checks are not important in this case)
> > 2) "server focused perm checks" - get/set the three ACEs
> > (user-owner/group-owner/EVERYONE) in the ACL
> >
> > I would like to default to idsfromsid (setting the owner with  if
> > looking up owner from Winbind or SSSD or falling back
> > to S-1-22-1 (Unmapped user's special SID) or S-1-5-88-1  (MS-NFS and
> > Apple style unmapped user's special SID).
> >
> > In a way I would like to remove "idsfromsid" (and do it by default),
> > and add the new mount point to distinguish between
> >
> > "client centric" mode bit evaluation (special mode SID)
> > vs.
> > "server centric" ACL evaluation (where mode bits are mapped into the 3
> > usual ACEs - user/group/other)
> >
> >
> >
> > > =D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 00:20, Steve=
 French <smfrench@gmail.com>:
> > > >
> > > > See e.g. https://docs.microsoft.com/en-us/previous-versions/windows=
/it-pro/windows-server-2008-R2-and-2008/hh509017(v=3Dws.10)
> > > >
> > > > where it describes use of an ACE with special SID S-1-5-88-3 to sto=
re the mode.
> > > >
> > > > Followon patches will add the support for chmod and query_info (sta=
t)
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
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
