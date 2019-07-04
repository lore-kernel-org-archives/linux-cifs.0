Return-Path: <SRS0=KBsq=VB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80D4C0651F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 20:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932C52189E
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 20:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mk2Tc5Ue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfGDUwc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jul 2019 16:52:32 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34491 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfGDUwc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Jul 2019 16:52:32 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so7255987ljg.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jul 2019 13:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O8+vZnySTLStsMY/cgZ+DKGHYYdnzS3NOdX5X7V50Tg=;
        b=mk2Tc5UeUm1pEyrT7RztEkJ6rL/ush+YAQ+6W3N4n8j3mXHojjRgmVoKQ8VnZxfjCw
         sMK7MvQU5jS9+e5UNfh3SRFww9/9cKwdhZZNYUX935yWt4S0BxZb6hPsOsNQDqIJOrmb
         wxdtAnUPBI6TazUrz3UaYA6n1ZMi9a0RFTw17frVRYYo/pr3xPfNXiLZHo9f+kkIznIr
         igOIF9mPEWvScb/cdsE0KCFhwfZ3J2aCZ8+csthMj36bXzg6/nGwQN4mo7b4igNeTcWd
         PbOQopaSFl+O/GXcH/1l/hUiNLUMoMgfgX3W8qx6WDpobhMkHb1MVy7bpiGwfCQI+swe
         oAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O8+vZnySTLStsMY/cgZ+DKGHYYdnzS3NOdX5X7V50Tg=;
        b=ivnqrnRY4jaHukB8zknJWm9dd7fSvJPYdqWKrA3t3Uop1HU8vgTTyQUHz18VyLSdOF
         bZ5XGW+Ezy5h8qA2my7w04tEUepXm6SkX+UjM9wdZEbYUxfi3Q8gBaY73A4oBjA+foQl
         t6xWqHycGWLpYmy/hSPxagHr1LkicJ45M3zGoBRj0Cy4N7c3HGESJccylvgoWaco/MiU
         YPBXflVCbKqBmMhA6j6uQ8A/TeJkDrVoAYuqyG7nd+YpT6fFbqQsChfKFSzY64446p5i
         YGDs94LJ9ovH9hgiVrFsAwn95G9twuAGGBKt4n/mspwJ5UurgCJAycvrYqpPpWa0ddUB
         tskw==
X-Gm-Message-State: APjAAAUu/+elOMnPuw+7t8GeUSu6UqF0PsDU+AztH23cmH2SA06I76Ib
        TKXj8G8jn+bowmcezf97Pl+vBh1i26tj6TsUJA==
X-Google-Smtp-Source: APXvYqxBpTls2KqsevtpdlC3GKIHj047hTPs6kcTvh+9cIzDKscAWQZm7z/DDoeoP9Z9E8+yPc9bn+tLdOqO6IB7FCM=
X-Received: by 2002:a2e:b167:: with SMTP id a7mr90307ljm.26.1562273549782;
 Thu, 04 Jul 2019 13:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
 <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com> <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com>
In-Reply-To: <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 4 Jul 2019 13:52:18 -0700
Message-ID: <CAKywueRpx8tcDb7p+1_vDgCjRZ_0FYOGt8CSQLMa3ixgqxoscQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode
 from special ACE
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These are good points and I agree with the plan.

I would rename the option:

"modefromace" -> ""modefromsid"

to make the naming consistent with the existing "idsfromsid" and match
the behavior closely: a mode is still technically from the special SID
and that SID is from the special ACE. Other than that the patch looks
good.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:25, Steve Frenc=
h <smfrench@gmail.com>:
>
> On Mon, Jun 24, 2019 at 2:07 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Can't we use the existing idfromsid for this purpose? We already have
> > a plenty of mount options and the list keeps growing.
>
> That is a good question - and I am open to suggestions to remove some
> mount options but
> the general problem is that that mount option name could be very confusin=
g -
> "idsfromsid" doesn't really imply anything about how we handle
> mode bits (we could save mode bits even if saving uid owner without
> using the "idsfromsid"
> mechanism) we want to allow:
>
> 1) query mode from special sid if present
> or
> 2) query mode from ACL (only check for perms on the three
> user-owner/group-owner/EVERYONE SIDs), in this case we may chose to
> mount noperm
> or
> 3) the default today - we set mode for files and directories to the
> permissions supplied as "file_mode" and "dir_mode")
> We by default do:
>       vol->dir_mode =3D vol->file_mode =3D S_IRUGO | S_IXUGO | S_IWUSR;
> and we can mount with noperm to disable the client perm checks if the
> checks on the client are not useful
> or
> 4) set the permissions (temporarily) locally only and cache them
> (dynperm) - typically not recommended.
>
> Where I would like to get to is that we focus strongly on only the
> first two common use cases:
> 1) "client focused perm checks"   -  get/set mode from special SID
> (server permission checks are not important in this case)
> 2) "server focused perm checks" - get/set the three ACEs
> (user-owner/group-owner/EVERYONE) in the ACL
>
> I would like to default to idsfromsid (setting the owner with  if
> looking up owner from Winbind or SSSD or falling back
> to S-1-22-1 (Unmapped user's special SID) or S-1-5-88-1  (MS-NFS and
> Apple style unmapped user's special SID).
>
> In a way I would like to remove "idsfromsid" (and do it by default),
> and add the new mount point to distinguish between
>
> "client centric" mode bit evaluation (special mode SID)
> vs.
> "server centric" ACL evaluation (where mode bits are mapped into the 3
> usual ACEs - user/group/other)
>
>
>
> > =D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 00:20, Steve F=
rench <smfrench@gmail.com>:
> > >
> > > See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/i=
t-pro/windows-server-2008-R2-and-2008/hh509017(v=3Dws.10)
> > >
> > > where it describes use of an ACE with special SID S-1-5-88-3 to store=
 the mode.
> > >
> > > Followon patches will add the support for chmod and query_info (stat)
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
