Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6297C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Jul 2022 04:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiGKEIn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGKEIk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Jul 2022 00:08:40 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7603558B
        for <linux-cifs@vger.kernel.org>; Sun, 10 Jul 2022 21:08:36 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id x125so1235444vsb.13
        for <linux-cifs@vger.kernel.org>; Sun, 10 Jul 2022 21:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fllguJpF5BnkzkEtoQdiaDv1n0MWRGtfi77Hkgiwu7w=;
        b=J0g3ViFEff4Py7WHG4RL4FSWzOVY8gx+z+C3KxUmstsBfH6cvz7QKPt2cRe0Sn+Yle
         GdA1pxlKrQuslgEkVfgSEyxOT6GDUcuzbV2PhRql8g3TaRFUGKEajXTwurqEByYRnY9i
         aqnAZcsw3I3rRlsHXYaRlcXzh+t6VNxh51h33YrZUt/dHQfLkCFQ0QxbYiTJZmq9rkiy
         QzVm0FjiLWuA1WXz/cHheGn0PkoMjnyP6ZzH5ZnjpF35DVW8YtoVldA7ccS/gboKa8uP
         DdNO3o5TtAQM8Cg2FZjlX8PqluHilQCjSpczyTzSe7SVgmjQMJ+wpYUDJDADetAuXVRw
         tprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fllguJpF5BnkzkEtoQdiaDv1n0MWRGtfi77Hkgiwu7w=;
        b=lAzTIYk/BMejHo1smgxB5AgRUP5lAFhhGl6usW1lg6TMkSccx3Q7Pe3HKgObs13oOQ
         H9glqXOE4CoSxJjxzqCaiJzNCPtLiq7jtwyrnsiBERxrqTBTgq0I1FWXycdrOF2mZXkf
         FxnpKrTnsWSN+OkboRrnbMgcsC5ow3UoB/MENmWy8JN4UsO/6bj5StUwqQlUZoM5qfla
         UaYgbh2V/X++SzCgvfy4lNHCi0u9J+rGkfML+U/9lFSOTKsd1xcVmUQHsZMR4JwWcsL3
         nBQhcTNiyXs0rgdjBOlD7aei55DRgi/sDv3h3FjMxo9Sw4h0sdpPMKjLQrsR0/kn2+Jd
         IZhg==
X-Gm-Message-State: AJIora9wRR89A2HKBIyyaWrcFQ0jkNsoF9ZYQRFjKg0TOhoQwDrPh8xg
        jNMTlidFqJhijx9o+dgSs2Rvb4ujnmyN+t6OMzg=
X-Google-Smtp-Source: AGRyM1uX1bCiFSyBL4si1vDblPNKneQTJ3LnVUKFcoIbF3k0f/Xh+iDpdXh/5E5KrsRDaadVkConD+zaRe6mZ5VFS0k=
X-Received: by 2002:a67:ca82:0:b0:357:32b6:5f04 with SMTP id
 a2-20020a67ca82000000b0035732b65f04mr5405610vsl.60.1657512515219; Sun, 10 Jul
 2022 21:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAARpZ=_WCZhEZ2DzR3jRNLNLx28duH2iSn7WwRVezGKpjX0LDA@mail.gmail.com>
In-Reply-To: <CAARpZ=_WCZhEZ2DzR3jRNLNLx28duH2iSn7WwRVezGKpjX0LDA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 10 Jul 2022 23:08:24 -0500
Message-ID: <CAH2r5mtYzhd9EpzJAFLH+AHvKB0CaUtVBTP+UP4PDgg686-SFA@mail.gmail.com>
Subject: Re: mount.cifs broken after update, advice?
To:     Brian Caine <brian.d.caine@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This looks like the Samba server bug pointed out in an earlier email
thread by Metze (fixed by
https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a)

I had trouble reproducing it on my systems but it looks like (based on
Julian Sikorski's testing) when we fixed the netname context to not be
null in some multichannel cases, the reordering of the contexts
(putting netname context after the posix negotiate context) triggered
this bug in some versions of Samba (which was fixed earlier by the
Samba server commit above).

On Sun, Jul 10, 2022 at 10:35 PM Brian Caine <brian.d.caine@gmail.com> wrote:
>
> Hey all,
>
> So I recently updated my kernel and my previously-working CIFS
> mountpoints are broken. The server hasn't changed.
>
> I can successfully access it via smbclient. Only mount.cifs is broken.
>
> On the server:
>
> % /usr/local/sbin/smbd --version
> Version 4.12.15
>
> On the client:
>
> $ mount.cifs --version
> mount.cifs version: 6.15
>
> $ smbclient --version
> Version 4.16.2
>
> $ uname -r
> 5.18.9-arch1-1
>
> (I know it's not a vanilla kernel, so I wanted to ask for advice here
> before making a bug report.)
>
> As mentioned, smbclient still works:
>
> $ smbclient -U brian //192.168.1.131/backup -c ls
> Password for [WORKGROUP\brian]:
>   .                                   D        0  Sat Apr 24 16:01:23 2021
>   ..                                  D        0  Tue Dec  1 20:18:28 2020
>   brian                               D        0  Sat Apr 24 16:09:46 2021
>
> 15119769681 blocks of size 1024. 12418540722 blocks available
>
> This doesn't though:
>
> # mount.cifs --verbose --verbose -o username=brian
> //192.168.1.131/backup /tmp/foo
> Password for brian@//192.168.1.131/backup:
> mount error(22): Invalid argument
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
> kernel log messages (dmesg)
>
> I attached my kernel output. Is there anything there that jumps out at
> anyone? Any easy fixes or should I look into opening a bug report?
> Anything else I can provide, just ask.
>
> Thanks,
> Brian



-- 
Thanks,

Steve
