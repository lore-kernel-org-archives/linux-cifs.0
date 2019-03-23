Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54100C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 15:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 176622192B
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 15:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfCWPgX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Mar 2019 11:36:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36149 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfCWPgX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Mar 2019 11:36:23 -0400
Received: from mail-oi1-f200.google.com ([209.85.167.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h7ih2-0006ib-Gr
        for linux-cifs@vger.kernel.org; Sat, 23 Mar 2019 15:36:20 +0000
Received: by mail-oi1-f200.google.com with SMTP id r84so280910oia.9
        for <linux-cifs@vger.kernel.org>; Sat, 23 Mar 2019 08:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7u43T/gUtuEKt0lRQoqfnXsPE4c/rXh6CQ9/yvJIhc=;
        b=Vy95dK0PoFfiWDYq5ErJxrAdPMZWgWmQd6aFOM3qIegViMUZQAGiJbvuZO3Hhz8VJE
         ljD1Y4Re1FBcP/Mc0VeSLUnRo4JAqnq/HUXl3D0RMV8DPtZun+9LktWjBoiu0yk+KyFh
         TVpo7xIqXvPunpx62qCDUBucWqRCsh/0RDcXYs4tNdsZRjT5YcMiXXy+NOKSh5UxFgjF
         erhD1s5jOoQjIQNqH9wnJWItwMEeb+/j8gOPTKDWJJ8iffGvJEvTsv5vPWUEVzag0fgr
         yrf547AkwdG9K/G+xHWUsSdLt1B6SUlE11ppchCGWuuU23Be2b5pSktcvhkFSlv1cMCm
         fS/A==
X-Gm-Message-State: APjAAAWjLmGTWu7VXBKMC1cg8Y4coHFWUGqHrtrcQcpA1HFF1cyiSmvM
        sC+kfeEgdmX2n5ytWccFvBHqfXiBVPRneSIlEVm4hxtAXNVVrOAWzg76w9dEXxeWzQSAuxv7l9C
        T0c3bNM4X2IBz2KeufsFXGBUaU7MjXQcSKhcl0b5xycr4qqpzG9QKs6o=
X-Received: by 2002:aca:b408:: with SMTP id d8mr5495121oif.15.1553355379282;
        Sat, 23 Mar 2019 08:36:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw3S4BxiCTB8N+b55NK/XwTP2aFR862jSgcoonFhI1Ul+2Aw+n1pV8IWjAcbE9wn7iAEr/YD4jzojUe3RP0AVs=
X-Received: by 2002:aca:b408:: with SMTP id d8mr5495111oif.15.1553355378941;
 Sat, 23 Mar 2019 08:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRk9dCu3cwYNrCY8L2jUGR92vKjjiAniMqyPjvzCrV9A@mail.gmail.com>
 <CAH2r5ms_Md9UOsM5x0ACamTz2Zhiu0+HVVzZJF2PGzqyXNY_1g@mail.gmail.com>
In-Reply-To: <CAH2r5ms_Md9UOsM5x0ACamTz2Zhiu0+HVVzZJF2PGzqyXNY_1g@mail.gmail.com>
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Sat, 23 Mar 2019 12:36:07 -0300
Message-ID: <CANYNYEHJZ019AsJ0efxPu=aJEduGd1qXMjyXQPAaUiGDwbcgBQ@mail.gmail.com>
Subject: Re: [PATCH] Fix guest smb3.1.1 mounts to Samba
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The current for-next branch (I tested
cf7d624f8dcc9b833a8489208b6ef6dcc5dd308b) worked for me:

root@andreas-disco-cifs:~# mount //localhost/pub /mnt -o guest,vers=3.11
root@andreas-disco-cifs:~# mount -t cifs
//localhost/pub on /mnt type cifs
(rw,relatime,vers=3.1.1,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)

root@andreas-disco-cifs:~# uname -a
Linux andreas-disco-cifs 5.1.0-rc1 #2 SMP Sat Mar 23 15:01:59 UTC 2019
x86_64 x86_64 x86_64 GNU/Linux

On Sat, Mar 23, 2019 at 12:35 AM Steve French <smfrench@gmail.com> wrote:
>
> Version 2 of patch added additional check that it is not krb5 mount
> when username is null
>
>
> On Fri, Mar 22, 2019 at 8:01 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Add to Ronnie's patch check for null user so we can handle guest
> > mounts for 3.1.1 to Samba as well
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
