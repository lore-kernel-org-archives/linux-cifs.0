Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88DFC4338F
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 20:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD25C60EB7
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 20:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhHHU5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Aug 2021 16:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhHHU5c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Aug 2021 16:57:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEF4C061760
        for <linux-cifs@vger.kernel.org>; Sun,  8 Aug 2021 13:57:12 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x8so29681866lfe.3
        for <linux-cifs@vger.kernel.org>; Sun, 08 Aug 2021 13:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YIRAs95TCC+TwDi6WekW7vwID/apXELk6kebOC3mn0I=;
        b=C31JkrS1ALUZLNVtzV3I2juWonImIbKG3AA6h/YWopO59gXqlPPAfcypFpjcxi2aGN
         4b+oeQGP9HnFYcaws3SC6/z3q9b1WJXDOu6r9cko9VDsw9osMpjYQ3PUvhfG2PE6Y+d6
         inmI36F80hwnSHgE2eHfiabd80kB6cX58L9nyBHk4PU5km9uYyV5whW5iS6RHPoVCiJt
         KGve5/HadmO2JDBFi2wA02LyiM9qTx8vqGgRKiHWTBomawGYxHZLHwJBmAmDPgXWiM6V
         4+vU45WZ6kz3KafvkN3C5fPe3pKncahfM8ajhw2XoXXazxd8Ng1MTvUu6Sm/GkRBObo/
         +Slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YIRAs95TCC+TwDi6WekW7vwID/apXELk6kebOC3mn0I=;
        b=mg+wyvSIN7ma+NNSFJlecSm3IA/D2O9GZXsD54mJxOclQct8mMoEy5zOg4mpS5ZBYa
         7hPoaRjvqhNymvSHLOZC8HIrm4+w9Yslk3H/aHHUX8pQPTxcjHRLCBlRR2bMek0LRVag
         ah971v5h9j2sgIX1py71ydfpcKcKuP3TCd68fTF2qhQPx23rcS6d6sy5ippO2Q3Q+cQA
         EKaQggmBubA9AEsWam4Fgjf+LDfUVVYPsz6yTrtnmN7PJvgyOO0DLX8Fhr4aZyaHEQ+2
         LNVnfbRb7GbjS8DlLtuRQntmKoyrUWzF8JFQWmMR6CE/OnpK3lOBs87UPptT66cWUfFr
         R5tg==
X-Gm-Message-State: AOAM530m5mttzcc1+SzObAI6mdy3YXejlICQkRq5HEthQokxrYOur6Go
        VzOMaYByPp0f03N0Ne+MSzoV9lJtQnLdGoxjRC0=
X-Google-Smtp-Source: ABdhPJxg677wVnBwv/hePP6AXzanp45alyyG0zDoHblNIrstkQFgRDBAtKvsiNSRB3AkGzgQ++nVqM/Q//m+sR62nM4=
X-Received: by 2002:ac2:41c5:: with SMTP id d5mr14905474lfi.313.1628456230756;
 Sun, 08 Aug 2021 13:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAJK_Yh-m-p8r=9WhrHn=V5yMWBpYZCRZeqWyci+NbUEGNPwpYw@mail.gmail.com>
 <CAJK_Yh_tWGoRkCSfSwPBHi2SAPi9cKeyb8L=Lg1Gx=xtEDY29w@mail.gmail.com>
In-Reply-To: <CAJK_Yh_tWGoRkCSfSwPBHi2SAPi9cKeyb8L=Lg1Gx=xtEDY29w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Aug 2021 15:56:59 -0500
Message-ID: <CAH2r5mv0XxFDMyY-iSDKqQUvH38fpjHJ762hNaCKjwwUM1eY4w@mail.gmail.com>
Subject: Re: rsync copy operation fails on a CIFS mount
To:     =?UTF-8?B?U1pJR0VUVsOBUkkgSsOhbm9z?= <jszigetvari@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As Rohith has been investigating, there can be cases where
   "CIFS VFS: No task to wake, unknown frame received!"
is ok (e.g. races between close and oplock break) but to investigate
your storage problem some additional information could be helpful.

Is this a large file workload, or lots of small files in directories,
or deep directory trees?

Large directories, and deep directory trees can result in the Linux
VFS layer doing many revalidate
requests beyond the default 1 second metadata caching timeout (cifs.ko
is stricter than some other
fs in defaulting to 1 second).   Especially if this is the only client
likely to update the files while backing them up
then setting actimeo much higher (e.g. actimeo=3D30) could be helpful.

In general SMB3.1.1 is MUCH faster with reasonably current Ubuntu
(make sure you have updated
your Ubuntu to at least 5.4 although current Ubuntu AFAIK is 5.8 or
5.11 kernel now).   It is VERY
important to use a kernel more recent than 5.3, not just because of
the many bugfixes but also
because of the addition of GCM (much faster) encryption for SMB3.1.1
in 5.3 kernel.kernel:

There are very few cases where you want to mount with something other
than the default (which
for modern servers is almost always SMB3.1.1, e.g. default or
explicitly with "vers=3D3.1.1") as GCM
encryption is faster.  There are a few cases where SMB1 POSIX
Extensions can be helpful but there
are tradeoffs with older SMB1 being so much less secure and so many
other features missing from the
20+ year old SMB1 - use the default SMB3.1.1 if possible.

There are other parameters that can be helpful e.g. "nostrictsync" in
some cases.

Also consider whether rsync is what you want to use - rsync picks an
unfortunately small default I/O size and its
maximum I/O size is also terrible - this is less of an issue if you
are using the default caching (which goes
through the Linux page cache so will aggregate I/O into larger chunks)
but for a network FS you really want
I/O 1MB or larger (SMB2+ will typically default to 4MB or 1MB I/O and
even NFSv4+ will typically default to 1MB)

If you have the ability to try newer kernels (e.g. Ubuntu makes it
very easy to download install packages to update
to the more current 5.13 kernel from the Ubuntu website for testing on
older Ubuntu) - give 5.13 a try and experiment
with the new mount parm ("rasize") e.g. setting it to 8MB and see if that h=
elps.

Another key thing to look at is whether there are reconnects being
triggered (e.g. by bad app behavior - like we saw
with scp sometimes sending signals accidentally killing the TCP
network connection, or by timeouts on the server,
or bugs that have been fixed in more recent kernels).   See the number
of reconnects in /proc/fs/cifs/Stats and if
it is increasing then focusing on whether that is a server bug, or a
bug due to an older kernel on the client which
is missing fixes can be useful.

On Sun, Aug 8, 2021 at 3:37 PM SZIGETV=C3=81RI J=C3=A1nos <jszigetvari@gmai=
l.com> wrote:
>
> Dear Members,
>
> I work for a company that (among others) sells Ubuntu-based log
> storage appliances. I ran into a problem, where I'm trying to copy a
> large amount of data over to a CIFS mount from a Ubuntu 18.04 based
> appliance to a Windows 2012 R2 Storage Server, and rsync fails after
> 1-2-3 hours into the copy operation with something like:
> rsync: failed to set times on "FILENAME.U5EgGX": No such device (19)"
>
> and I see a number of kernel logs just prior to that, that look like this=
:
>
> kernel: [3819786.441711] CIFS VFS: No task to wake, unknown frame
> received! NumMids 1
> kernel: [3819786.441717] 00000000: 6c000000 424d53fe 00000040 00000000
>  ...l.SMB@.......
> kernel: [3819786.441718] 00000010: 00000012 00000001 00000000 ffffffff
>  ................
> kernel: [3819786.441720] 00000020: ffffffff 00000000 00000000 00000000
>  ................
> kernel: [3819786.441721] 00000030: 00000000 00000000 00000000 00000000
>  ................
> kernel: [3819786.441722] 00000040: 00000000
>
> I also tried to google around for a while, and I found the same exact
> package hexdump on the linux-cifs mailing list from 2012:
> https://www.spinics.net/lists/linux-cifs/msg06634.html
>
> In that thread the person reporting the problem failed to reproduce
> the problem a few weeks after reporting it.
> There it was recommended to try and mount the share with SMB v1, but
> that is out of the question nowdays.
>
> We tried forcing the mount to happen with vers=3D3 and 3.02, but it made
> no difference. The error still re-occurred.
>
> Best Regards,
> J=C3=A1nos Szigetv=C3=A1ri
> --
> Janos SZIGETVARI
> RHCE, License no. 150-053-692
>
> LinkedIn: linkedin.com/in/janosszigetvari
>
> __@__=CB=9AV=CB=9A
> Make the switch to open (source) applications, protocols, formats now:
> - windows -> Linux, iexplore -> Firefox, msoffice -> LibreOffice
> - msn -> jabber protocol (Pidgin, Google Talk)
> - mp3 -> ogg, wmv -> ogg, jpg -> png, doc/xls/ppt -> odt/ods/odp



--=20
Thanks,

Steve
