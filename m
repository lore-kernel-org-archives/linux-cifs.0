Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFC7C43334
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jul 2022 11:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiGMLAp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiGMLAo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jul 2022 07:00:44 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F649F788C
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 04:00:44 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id h22so1165058qta.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 04:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BfZxnwY/QU/ckAlFlOyUo3NhskFbgSE0bBECB1BZfsA=;
        b=S6uCCRCipysuZzmD0mdMy4aCV+8P3v1vrhgbVSzX4bs6hN4KKK5+OboYYEXgoaoRRD
         8idREtdCdD37FgOe6xgnJzSCC2eU6Nh/ndwiHVLU+PmtIicXJDMDkYqVd9mhReq/GGgj
         nwcBJk33OrErCW05Ta9fFFSHrC9FHAuKrczFOEEidYQELAIVzxvxTuT8dsWuBeqOf6Wz
         71cDGYuls00A3WqPDq/c2hNovSVQxAhfLLeeoGtHQoC37MflMKABlLwEaiuGjdhtfWOC
         dUYpoGYnSI1z+4yIZtCL7G+t0+sYSYsJFVjhiUPReIzUhntXTWbCKp0841a3Co+L0gRo
         pFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BfZxnwY/QU/ckAlFlOyUo3NhskFbgSE0bBECB1BZfsA=;
        b=EPvAkvYxNqiZQIYraLwR/5jeeVF2QeGUPEzI2IdES1yZ7EK0R5WYE9djn4aBrCoft6
         nrUrx825qAhNps94/RQQW1uTGwxZSnZd4IhHSjDq9gnp/OPy/myxeg1TOcZpQzRKvJTe
         8+mpL15iJWWyS3LrZIobeuJMywubzMSl5o7B0nCdhhVo6tsemGZj4H1gZHj2Zeup/EPa
         ZON+zGxC9s0OeybkZUOg0e/WoFi4IRUwN73qNg/+ITKQ3lERiqYl1VU680UgT7n05sxh
         CqUMUZJVPJ6ebFApY/d2JCYzWzPSWLTy4DSy9hFEvJTzGtS4sYjSQ6LwqBs/gtVbf6Ek
         z62A==
X-Gm-Message-State: AJIora+7hWT78FtK6zZyWOd2zxLAYtZMiaHHQ3cbKPH/vczhWq7D1rYa
        Sc72HDarspsMmCkNwVB6ITDc4i1ARUjstBINlGGh1XZSIH+fHI4p
X-Google-Smtp-Source: AGRyM1upoZBVmgcUcQ/GDjVy5fOEFjx9VHGPu2e6pZU0CSaC+a9Ywyk0GMiBPUygSE9Y8OgzGX+IVaxe4BydqeM80Y4=
X-Received: by 2002:ac8:7fce:0:b0:31d:34bd:66b4 with SMTP id
 b14-20020ac87fce000000b0031d34bd66b4mr2228894qtk.673.1657710043224; Wed, 13
 Jul 2022 04:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pamwCmYC3pFHPmg1QGNTEpNdqp9aoE=8w++BEVk+8nbQ@mail.gmail.com>
 <CANT5p=pPdY_-gUQUamOJ2p79riyJ++h2V2HJ7mGm9+OHPQ2L7w@mail.gmail.com>
 <CAN05THSk6UKeTGo3=2kg3pJcHTz+DB2K9h4ijg7c9Ep=XsVqeQ@mail.gmail.com> <CAH2r5mvoi=8dgdjQG46-Hz=QaT7w+jNXn_nRqX0foriqxrfj2A@mail.gmail.com>
In-Reply-To: <CAH2r5mvoi=8dgdjQG46-Hz=QaT7w+jNXn_nRqX0foriqxrfj2A@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 13 Jul 2022 16:30:32 +0530
Message-ID: <CANT5p=pB=-G65UhKxmNtEFMpwUeVQ8meRLsNY8SvMU1Q79mpwQ@mail.gmail.com>
Subject: Re: Problem with deferred close after umount
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 13, 2022 at 3:17 AM Steve French <smfrench@gmail.com> wrote:
>
> Looks like the patch Shyam had for force unmount doesn't help regular unm=
ount case but fixing the reference count on super lock could fix it. When f=
ile is closed locally but not over smb (deferred close) we can probably dec=
rement the reference count so unmount would work
>
> On Tue, Jul 12, 2022, 16:40 ronnie sahlberg <ronniesahlberg@gmail.com> wr=
ote:
>>
>> On Sat, 9 Jul 2022 at 16:48, Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>> >
>> > On Sat, Jul 9, 2022 at 11:45 AM Shyam Prasad N <nspmangalore@gmail.com=
> wrote:
>> > >
>> > > Hi Steve/Ronnie,
>> > >
>> > > I'm seeing a strange problem with deferred close.
>> > > This is the test that I'm running:
>> > > 1. mount a share with actime=3D600
>> > > 2. open a file in the share so that a handle is opened, and it gets
>> > > scheduled for deferred close.
>> > > 3. umount the share. That works.
>> > > 4. rmmod cifs does not seem to work. It says module cifs is in use.
>> > > DebugData shows that tcon/ses/connections are all active for the
>> > > unmounted share.
>> > >
>> > > I think I understand why this happens, but need help understanding h=
ow
>> > > to fix this.
>> > >
>> > > Each handle open takes a reference on tcon, and also on the
>> > > superblock. So even when the mount point is umounted, tcon does not
>> > > get freed. I see that it gets freed when all handles that are deferr=
ed
>> > > for close are actually closed.
>> > >
>> > > I tried calling cifs_close_all_deferred_files for the tcon in
>> > > cifs_umount_begin. I even tried printing a log there. I did not see
>> > > that getting logged during umount. Does that mean umount_begin is no=
t
>> > > getting called?
>> > >
>> > > Wondering what is the correct way to fix this? Ideally, we should ca=
ll
>> > > cifs_close_all_deferred_files as soon as the share is umounted. Whic=
h
>> > > is the first callback in cifs.ko for this. I was assuming that
>> > > umount_begin is that callback. But my experiments are not seeing tha=
t
>> > > getting called.
>> > >
>> > > --
>> > > Regards,
>> > > Shyam
>> >
>> > I checked the VFS code. It looks like the umount_begin callback gets
>> > called only when called with "umount --force" option.
>> > I tested that. It seems to work.
>> >
>> > Is it the expected though without force? Doesn't seem right to me.
>>
>>
>>  umount_begin() is a special callback just for network filesystems
>> that need to do something special
>> if/when a forced umount is attempted so this would be the wrong place
>> for the normal deferred close
>> handling.  It is poorly documented though :-(
>>
>> Maybe cifs_kill_sb() would be the right place to use?
>>
>>
>> >
>> > --
>> > Regards,
>> > Shyam

Thanks Ronnie and Steve.

This seems to work:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c1aa4ca2231a=
247abcf948dd7411ea5a1a0330b8.patch

Please review the changes.
Tested some basic test cases. Seems to work.
I don't see this change affecting any other mount options. Do you?

--=20
Regards,
Shyam
