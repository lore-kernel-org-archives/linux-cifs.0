Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD18C6FA8F
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Aug 2023 18:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbjH3Sxa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbjH3OGr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Aug 2023 10:06:47 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7CD107
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 07:06:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b962535808so86624921fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693404400; x=1694009200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7uGBPPnjS58nuigJ4haP+at/PttAClvvO1vQc/zct4=;
        b=TyvH11a+NxB4UH+5gQ1cL7KLuHgpuAIDLoQ65CJLI7TajTyvnDrYc6GeKaWcBh9kaZ
         MGEwom0fQ4HEhCztz6YdJPK7oROUKO3oq445BCb7KmU40CYlBtQAJtmaKoL6DTcVJvq0
         MTEphQ2eNSg9dCTULvpcfog1KXhpOhrq3QPsx/flgyuLW/ob37Z+FFfagrGy83Gcah+f
         LlebJQvHiCCymLAJuWfBvPWMKCwD1/1tqUbWeFfbHaW8t/0lY2GUIxt+4Bp9iMfh6Z5P
         X0nz/KsJP6NxqMaE5UhWCX3Uc6qH0eqvpi/mli0FRWNgc/zvNoJuWMpUwF8EjVYaVM9a
         s+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693404400; x=1694009200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7uGBPPnjS58nuigJ4haP+at/PttAClvvO1vQc/zct4=;
        b=DXkPdhLfAq0HHZBahMyP6p3Bjx3QsfdPuiQQR+pyRRvSWRxV+uEtwKEmW+ox+wer5G
         GT6zQAcu/KfDcmsjnRq7i/SG8s9BO/AqNSnK/t+Atxrmy0Y9Bzy8qRj0wMFQtYSizcRF
         Ooq7BQFDA83h+7J0ulJnlYkh0zt/+qMTB1O5rtEzkbWnI3ZSX6gXWIOPSdpkrtQ33NEu
         Omr96tgDSITA9GgQrfpQ9zThdX0ExESfc/VNVW9R3QQNC1JDsnic7FVCpvnGFiDSaTFk
         F4xmnAaxeomXT+0UxYg0KP60uRUWJ9UqbzGFWh3mSm1ov1N/6VQ6wW2qdRKrImSBR3td
         7PcA==
X-Gm-Message-State: AOJu0YwNwTKOqP6nJkIYshCg3xjGhFrlCmG5DUKQ0Qn/Da5zN4LGWE89
        Tw39Jb8L4XubAht3bDsjlISMrw24/gTK4Ea8ZM8=
X-Google-Smtp-Source: AGHT+IHbob0RLWXUzIcweiKrE4+uW6Pn7CIP5x9eojvPjaNHnsT/1LeBWJO+JT1L0a+kCf+Sz1l1QLfBTyS+/CMrB1s=
X-Received: by 2002:a2e:b17a:0:b0:2b9:55c9:c228 with SMTP id
 a26-20020a2eb17a000000b002b955c9c228mr1892336ljm.27.1693404399755; Wed, 30
 Aug 2023 07:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
 <CANT5p=rHdWmD_wtQtKU615LAWmXx4UQxHORf0HDqgYNksddvEA@mail.gmail.com> <CAH2r5mtRJtNiN128kJTSknv_F4Q6uPDsETcKH7Pjkfk0Fco6zg@mail.gmail.com>
In-Reply-To: <CAH2r5mtRJtNiN128kJTSknv_F4Q6uPDsETcKH7Pjkfk0Fco6zg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 30 Aug 2023 09:06:28 -0500
Message-ID: <CAH2r5muiUG59xVxPr+2y1U9jGbwLvOVvMnE+FsmRHdVf0Wxeig@mail.gmail.com>
Subject: Re: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Bharath S M <bharathsm@microsoft.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is also an smbtorture case in the samba test suite for this
(replay.c) we can take a look at that.

On the channel sequence number question - there is interesting
additional information (although probably not indicating a client
change) on channel sequence overflow at source3/smbd/smb2_server.c
line 2944ff

On Wed, Aug 30, 2023 at 9:02=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> we could do a follow on with your suggestion, but seems like without the =
replay flag would just look like a new write to the same offset (which shou=
ld take precedence over an older queued write to the same offset that has a=
 lower sequence number)
>
> I will code up a follow on patch to do replay operation patch
>
> On Wed, Aug 30, 2023 at 8:56=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
>>
>> On Fri, Aug 25, 2023 at 10:09=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
>> >
>> > The ChannelSequence field in the SMB3 header is supposed to be
>> > increased after reconnect to allow the server to distinguish
>> > requests from before and after the reconnect.  We had always
>> > been setting it to zero.  There are cases where incrementing
>> > ChannelSequence on requests after network reconnects can reduce
>> > the chance of data corruptions.
>> >
>> > See MS-SMB2 3.2.4.1 and 3.2.7.1
>> >
>> > Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN" u=
sed by this patch is confusing (has a confusing name) since multichannel is=
 not supported for older dialects like CIFS.  I will fix that macro name in=
 a followon patch.
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>>
>> Theoretically seems okay. Although MS-SMB2 says that replay requests
>> need to be indicated as replay in the header, which we are not doing
>> currently.
>> I don't know what maybe a side effect of not sending that could be.
>> Will this patch without that make things worse?
>>
>> --
>> Regards,
>> Shyam
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
