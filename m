Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_BL,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9B1C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1FC207C4
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLk0qcw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgESQhQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 12:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgESQhP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 12:37:15 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A31AC08C5C0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 09:37:14 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id z80so63365qka.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 09:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UvKyO85CaPUUDGngOc7ytDuwTWXaXTHlHM2W74Ijp/w=;
        b=mLk0qcw+D/H6d8JhvCfINlui/2Rt5fd+AhmDJ46FGVvfGVWYge+SXlQYDQusKsjaZN
         X3Y79PP5YxHAQ0YiE8cGEcnpJtP/FF+vsFVI3yZF+Uy09lFMXA+zpeJajXd49nxkVMuo
         jQU8zxRVCFo3fdFqWuU6gTY+7cz0jIraowQ5A4Z42kCgLn9cjm/g3nV91IBGedSoU0GU
         KQiPgFXFOV4Pg7owPGAYN2IFYkyaD8zbRZ7rBrcIexyCokhKqw9AH6fY/5FpogiaY2rx
         t+MrQyVVUUAhx1RyGvMDaR8eJksBFqvMmJeDQlvxpIsL6GBkxH1MxY5G7GrrKeHDCncU
         pCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UvKyO85CaPUUDGngOc7ytDuwTWXaXTHlHM2W74Ijp/w=;
        b=eeImcu4QJ3dOwBesPX13XtnpVpwFiaagfttjoLzEaMjezHLCskf13pL5Jsv+FnPx92
         CK/NIuIobtDioTxToVH5twzLx7AM/KW3Ro0xAE+6jMjHgWJ715oJEcWzGxXnvcItKV6V
         Ds4+5geWp5FpNBV5ashuVBbkMCFBuweUjG+ucQWz2irK973VAPv5qjAceC0OE+I6HbPx
         kZVkv5GGOQWbznMCgoEMLj9OhqpUiKozeK/CbEaFRC+3ufwuiU9j3w4enSVNWTQRi1w8
         X2qagbQ7Gp2MP5KW+f0UtrTJbh++FGpo3Yd6q7JDdE9m++cm+mSRQa8e9nkRN7shuwWb
         D8bA==
X-Gm-Message-State: AOAM530gPzaaGMJ75Xi72rlvMWBhKGkjZkF3cLmgrnPT4mNkahviSNke
        24SOZjopzWJovszGzpWo9qsQoZGx/vxDPEftnwQ=
X-Google-Smtp-Source: ABdhPJwBj+9t3gtEktqGjM59PMioxpayF1nmlx+9F3oohx5rBd2OAI6E5nwmlEvK8QP4VCAPAsdjBGhMHArTaN9OQNc=
X-Received: by 2002:a25:738e:: with SMTP id o136mr360585ybc.14.1589906233007;
 Tue, 19 May 2020 09:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com>
 <87k119maco.fsf@suse.com> <2024477496.29432550.1589904923298.JavaMail.zimbra@redhat.com>
In-Reply-To: <2024477496.29432550.1589904923298.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 May 2020 11:37:01 -0500
Message-ID: <CAH2r5mue+SPCH8MLyNsNCr43f4DAq8pcJiUTkn2K9Lyk7umQ6w@mail.gmail.com>
Subject: Re: How to verify multichannel
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

You can also "cat /proc/fs/cifs/Stats" and see the requests sent per
channel which can be helpful.  For example it enabled us to see that
prior to Aurelien's recent patch series (which is targeted for 5.8
kernel) we only received a slight benefit in large i/o workloads from
multichannel since reads and writes would be sent on the same channel
(other request types would be spread out across the channels).  With
Aurelien's patch series, even with only one network adapter, I am
seeing significant performance gains for large i/o workloads
especially for encrypted or signed workloads where the extra
parallelism on cifsd threads helps.  With multiple network adapters on
the client and the server, we can probably improve this scenario quite
a bit though - choosing which adapters to use (and eventually adding
integration with a userspace Witness Protocol helper to notify about
network interface changes)

On Tue, May 19, 2020 at 11:15 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Thanks Aur=C3=A9lien for your professional information. It's very detaile=
d and
> useful.
>
> Now I can see the multiple channel info in network package when mount wit=
h
> option "max_channel=3D2". If doesn't specify it. Client will only open on=
e
> channel. And my smb.conf setup below can work for multichannel. Seems ser=
ver
> and client don't require multiple network interfaces. And also don't need
> network team.
>
> But When test seedup, it isn't change. I use two vm in the same host. And
> each have 4 cpu and 1G memory. Maybe it's the problem.
>
> Thanks so much.
>
> ----- Original Message -----
> > From: "Aur=C3=A9lien Aptel" <aaptel@suse.com>
> > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> > Sent: Tuesday, May 19, 2020 1:17:11 AM
> > Subject: Re: How to verify multichannel
> >
> > Hi Xiaoli,
> >
> > Xiaoli Feng <xifeng@redhat.com> writes:
> > > Hello,
> > >
> > > When I test multichannel. I don't know how to verify if it works. I j=
ust
> > > catch network
> > > packages to see if server and client communicate with multiple IP. Bu=
t from
> > > my test, it
> > > doesn't. Does any one know how to verify multichannel?
> >
> > Testing if it works vs checking speed improvement are 2 different
> > things unfortunately.
> >
> > Source code
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > First you need the latest patchset which is available on my github remo=
te:
> >
> >     https://github.com/aaptel/linux.git
> >
> > You can use the "multichan-page" branch or you can extract the last
> > patches of it (with "multichannel:" in the title). These patches add th=
e
> > multichannel support to the main read/write codepaths from memory pages=
.
> >
> > Client setup
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Then you need to mount with "vers=3D3.11,multichannel,max_channels=3DN"=
 where N
> > will be the total number of channels the client will try to open.
> >
> > Do a network capture of the mount and run couple of commands in the
> > mount point (ls, cat, stat, ...).
> >
> > If the client also has multiple interface, make sure you capture all
> > interfaces traffic (otherwise you might ignore the other channels).
> >
> > Interface list check
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Look at the trace in wireshark and use "smb2" filter.
> >
> > Look for "Ioctl Response FSCTL_QUERY_NETWORK_INTERFACE_INFO", if the
> > server has multiple interfaces you should see a list.
> >
> > You can also look at /proc/fs/cifs/DebugDate to see the list of
> > interfaces the client saw and has connected to.
> >
> > Multichannel check
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Still in wireshark:
> > - right-click on the first "Negotiate protocol" packet
> > - "Colorize conversation" > "F5 TCP"
> >
> > You can repeat this for each channel to see clearly different colors fo=
r
> > each channels.
> >
> > I have made some screenshots, maybe this can help:
> >
> > https://imgur.com/a/j3IBewF
> >
> > You can see the alternating colors in my traces that shows different
> > channels being used.
> >
> > Speedup check
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Now this is the hard part.
> >
> > If you test with VMs and the interface are "virtual", when you make 2
> > channels you are actually just dividing by 2 the bandwidth of the
> > virtual bus, so you won't see much speedup.
> >
> > To see a speedup you need to limit the bandwidth of the server
> > interface, for example 1MB/s to each, so that together with 2 channel
> > you might see 2MB/s.
> >
> > You can look into iperf to check raw bandwidth and tc to limit it:
> > - https://iperf.fr/
> > - https://netbeez.net/blog/how-to-use-the-linux-traffic-control/
> >
> > Also similarly if the VM only has 1 CPU you might not see much
> > improvement as it will switch from one NIC to the other sequentially
> > instead of in parallel.
> >
> > This gets tricky very quick...
> >
> >
> > > Setup:
> > > server is samba server in linux upstream.
> > > client is linux upstream.
> > > smb.conf is:
> > > [global]
> > > interfaces =3D eth1, eth2, team0
> > > server multi channel support =3D yes
> > > vfs objects =3D recycle aio_pthread
> > > aio read size =3D 1
> > > aio write size =3D 1
> > > [cifs]
> > > path=3D/mnt/cifs
> > > writeable=3Dyes
> >
> > This looks ok but I've mostly used Windows Server 2019 in my test.
> >
> > Let me know how it goes.
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
> >
>


--=20
Thanks,

Steve
