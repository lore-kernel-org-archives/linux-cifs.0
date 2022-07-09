Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129ADC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Jul 2022 06:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGIGsN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Jul 2022 02:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGIGsM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Jul 2022 02:48:12 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E641747A3
        for <linux-cifs@vger.kernel.org>; Fri,  8 Jul 2022 23:48:11 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w1so805641qtv.9
        for <linux-cifs@vger.kernel.org>; Fri, 08 Jul 2022 23:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=r7C9geDg9kRx3okRVDEtuXqQXzR55qgFjiAmiCB4knY=;
        b=UX2TkzfE3tORyYoqLQx4DUhtgH/cnKz6/efRXSdnGNrkGZ23Q1Y/4LflDw/Ue8+w6w
         NnMvEIPEyPbKp23Ssv5XnDxsAOdpF/m0hzX90hDMJZRFBs+d05yc3ccsFLXty5e3IDX2
         zsVfXLeFK7qjJn+aGhnJr0GAjKgt8Qzm3oR9RJV0xeAsXI2/sHbcLbbu271VyeobtVUF
         GzxypBGfaluQYy885teQJQKj1Ywde1jBGmnzXNza9YsRSX4qYKjfS4PCyZxLZkpT4BiH
         9IwsGHh7n4VcfpxvVTYoRgWpWbn4tiYwDe7I/nG1kQXrAxK0OU8ZhnwB7u9ZYglZE19I
         lHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=r7C9geDg9kRx3okRVDEtuXqQXzR55qgFjiAmiCB4knY=;
        b=saR63dmOLuOyxWwpDR4hZlaIzIedpY6oxDWXhochi+Y5bmgtjgt5hqvUw/HxykJrSx
         Hd609Yf2jArluGixgIrBO/RjNRnWNNasbs3M8xGsbNzbCpDm7kzfPOSe06I0i5FHAo/1
         1LkaAF0iNoc5rR+7Nl4OPucq2J+H6V3UMMhVQxs0AGOHJamHcmpBQQFbPNJPh3vpoGLp
         ZAfCB5cp1suLOCJ5jYVllTZICHDj1N/YWPaNNQBwignyaTs7aHr6kWftxDfsPI1fEuK9
         IY+e2Ej5CbHqRLL77cUOZC+S+a3W47LLzCKa7okQW0a66a0KuqaT2aRCEcug0B7bYVwo
         PU/Q==
X-Gm-Message-State: AJIora85D5MVhnuoBkZzo2NRxP6xMArWBylO0MH2FHW6rYKh8RlFGDmD
        w8xD4Oy4vkeDDJX0rJuYR9i0tJYkIgKphbVy7eGGwPp5bUo=
X-Google-Smtp-Source: AGRyM1vvTAxllbTAZn9ouIPyQA5taP5/6Wd/NwkJ6xt5me25aOwonx52kgC3FjGl3TJlqilDOQvtM0y8CyhPnMI6XMU=
X-Received: by 2002:a05:6214:c2a:b0:470:b6c6:8a68 with SMTP id
 a10-20020a0562140c2a00b00470b6c68a68mr5711452qvd.99.1657349290759; Fri, 08
 Jul 2022 23:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pamwCmYC3pFHPmg1QGNTEpNdqp9aoE=8w++BEVk+8nbQ@mail.gmail.com>
In-Reply-To: <CANT5p=pamwCmYC3pFHPmg1QGNTEpNdqp9aoE=8w++BEVk+8nbQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 9 Jul 2022 12:17:59 +0530
Message-ID: <CANT5p=pPdY_-gUQUamOJ2p79riyJ++h2V2HJ7mGm9+OHPQ2L7w@mail.gmail.com>
Subject: Re: Problem with deferred close after umount
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jul 9, 2022 at 11:45 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve/Ronnie,
>
> I'm seeing a strange problem with deferred close.
> This is the test that I'm running:
> 1. mount a share with actime=600
> 2. open a file in the share so that a handle is opened, and it gets
> scheduled for deferred close.
> 3. umount the share. That works.
> 4. rmmod cifs does not seem to work. It says module cifs is in use.
> DebugData shows that tcon/ses/connections are all active for the
> unmounted share.
>
> I think I understand why this happens, but need help understanding how
> to fix this.
>
> Each handle open takes a reference on tcon, and also on the
> superblock. So even when the mount point is umounted, tcon does not
> get freed. I see that it gets freed when all handles that are deferred
> for close are actually closed.
>
> I tried calling cifs_close_all_deferred_files for the tcon in
> cifs_umount_begin. I even tried printing a log there. I did not see
> that getting logged during umount. Does that mean umount_begin is not
> getting called?
>
> Wondering what is the correct way to fix this? Ideally, we should call
> cifs_close_all_deferred_files as soon as the share is umounted. Which
> is the first callback in cifs.ko for this. I was assuming that
> umount_begin is that callback. But my experiments are not seeing that
> getting called.
>
> --
> Regards,
> Shyam

I checked the VFS code. It looks like the umount_begin callback gets
called only when called with "umount --force" option.
I tested that. It seems to work.

Is it the expected though without force? Doesn't seem right to me.

-- 
Regards,
Shyam
