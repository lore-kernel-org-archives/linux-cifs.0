Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C350BC43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 20:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B98E20857
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 20:52:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqXRC+Ss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfCQUwf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:52:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32861 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfCQUwf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 16:52:35 -0400
Received: by mail-lf1-f68.google.com with SMTP id v14so9707132lfi.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 Mar 2019 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Ze7X25VvAYPWd8uKmrZby6aeNpgMCpzL5DOakqSBI8=;
        b=OqXRC+SsyRW/BdcwWmkC4TEhw6Pz31LTc8P1Ajpgk051xSw/iZexrx9pMBCPWNUprm
         E0Ce76nRaD0BUQ/3CYP88GWqWm+oi6+XMjUmCmJVs45MzfoCmgfhv0xK9TcB4VitoRhY
         N4Hq/ZbuTH3t9HA/2sUNuo/StmtKytS/TzIWQlQQCvUZgcoEvhauJ5gwwEgfwlPLv5RN
         udXe/JgVaRX84/b1D+X3TD1wPu5V2WIXJcW9D26DReKXdHUWVd9oiznfNz+TATysXt+0
         WTEnyjoIM1gUEbFH1L0bfUsdlSLQqPpsIH35rONa7FhAvlFQWM0Df5Gd/hk71aXrQUo4
         hSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Ze7X25VvAYPWd8uKmrZby6aeNpgMCpzL5DOakqSBI8=;
        b=Bg9rZpKERvT9L3ZuxmA3itltiP6CPf2TVQihQRD+qhrDFO5hMWgWdVc1GeIGAjznwG
         y3hBpVSHmuqmtEWcDLN9opb7NQbB+0dmew7q/3lW7TMc5+UwAq/BtpaXWvSdOOhlACnJ
         vmBZ/NyCxihg7skIxuUdyBgTS96KygRcRFAaWyYtAcU4cbwBTtmpNZsEwfWfgfJIWyqL
         1lSdeHmB1SlilxvaFqvINGA9+vAtpRDo9gm3oPdXKd2vVhd1jZOCevw7CaK/hszjrlBW
         5tRXv0ZGnLKA6/yFCLZsFRRnUPkAOBlJQNyRc4q8Tk7gPzR3Rj3MUEOjRTaduHLP+w2T
         7+rQ==
X-Gm-Message-State: APjAAAUXbVyuA/3j+uAz2EuHKz3p9LyDQEDXYZ2BMk8f1/LUThnXhj3+
        nZqp3IQEh58p1RDddUZtW28WwmOxJYEhUO64lA==
X-Google-Smtp-Source: APXvYqwbayNFE3E1EwBXzqdqk9gf+V6sKXZ/a1fdsL9ed8hP0cBtNhpKPA3I80h0o70lqBLP26bs9Gjk3+uanOKP8FQ=
X-Received: by 2002:ac2:4474:: with SMTP id y20mr8232951lfl.42.1552855952959;
 Sun, 17 Mar 2019 13:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190316041154.27619-1-xifeng@redhat.com> <CAH2r5mv=WVFgrPAg1LkUYgnsk0z4X94wv2o40Kz0As2aSdqgeA@mail.gmail.com>
 <CAKywueS_pSZMcNXf97nPOyr=QbP5awET4TMDhL7LhQdTMM+jRQ@mail.gmail.com> <CAOoqPcQN-bqfiMkGWffXZ-EZqiZZ=NEySUF8PmPzcaK2s=yHPA@mail.gmail.com>
In-Reply-To: <CAOoqPcQN-bqfiMkGWffXZ-EZqiZZ=NEySUF8PmPzcaK2s=yHPA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sun, 17 Mar 2019 13:52:21 -0700
Message-ID: <CAKywueSvAFiyVH387BXQJOdC1Rt4LQT2DjeCqq5WDWJzZTkK+A@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix that return -EINVAL when do dedupe operation
To:     =?UTF-8?B?5Yav5bCP5Li9?= <fengxiaoli0714@gmail.com>
Cc:     XiaoLi Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for confirming this!

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 17 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 06:46, =E5=86=AF=
=E5=B0=8F=E4=B8=BD <fengxiaoli0714@gmail.com>:
>
> I checked my test kernel. It didn't include the fixed patch you mention. =
And after including this fixed
> patch, bz202785 is gone. Thank you for this information. I will update th=
e commit log.
>
> (re-send this mail again. Because the last mail message contains HTML sub=
part. Sorry about that)
>
> Pavel Shilovsky <piastryyy@gmail.com> =E4=BA=8E2019=E5=B9=B43=E6=9C=8817=
=E6=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=8812:46=E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> =D0=BF=D1=82, 15 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 22:39, Steve Fr=
ench <smfrench@gmail.com>:
>>
>> >
>> > updated and tentatively placed in for-next - running the automated tes=
ts now
>> >
>> > On Fri, Mar 15, 2019 at 11:12 PM XiaoLi Feng <xifeng@redhat.com> wrote=
:
>> > >
>> > > From: Xiaoli Feng <fengxiaoli0714@gmail.com>
>> > >
>> > > dedupe_file_range operations is combiled into remap_file_range.
>> > > But it's always skipped for dedupe operations in function
>> > > cifs_remap_file_range.
>> > >
>> > > Example to test:
>> > > Before this patch:
>> > >   # dd if=3D/dev/zero of=3Dcifs/file bs=3D1M count=3D1
>> > >   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
>> > >   XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>> > >
>> > > After this patch:
>> > >   # dd if=3D/dev/zero of=3Dcifs/file bs=3D1M count=3D1
>> > >   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
>> > >   XFS_IOC_FILE_EXTENT_SAME: Operation not supported
>> > >
>> > > Influence for xfstests:
>> > > generic/091
>> > > generic/112
>> > > generic/127
>> > > generic/263
>> > > These tests report this error "do_copy_range:: Invalid
>> > > argument" instead of "FIDEDUPERANGE: Invalid argument".
>> > > Because there are still two bugs cause these test failed.
>> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202935
>> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202785
>>
>> Hi Xiaoli,
>>
>> About https://bugzilla.kernel.org/show_bug.cgi?id=3D202785: which kernel
>> version did you use for testing?
>>
>> There is a fix merged recently that fixes a similar problem:
>> https://patchwork.ozlabs.org/patch/1052067/.
>>
>> --
>> Best regards,
>> Pavel Shilovsky
