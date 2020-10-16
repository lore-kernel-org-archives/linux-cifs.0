Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381CFC43457
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 06:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5BF20848
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 06:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="plyBMoUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393950AbgJPGLV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 02:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391801AbgJPGLV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Oct 2020 02:11:21 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB8EC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 23:11:20 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id u19so2445123ion.3
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 23:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QRx5VA2jL04EprKBK7dDPa5Y1K8LOZnjXRlM9vGrDU0=;
        b=plyBMoUIxXDi9hd5cVmLlsJ6wUZiaFgkegrQX5t+yXOLekilh3/e31NsHKEFwmRad0
         IcxKUi50udKZIw+/RKtqtG26d4HsMNiqjLqaPfWZurnQdnkkBsfWgwGn6sjDdNr1QDJQ
         WACTkaX1NUG0k0qiWaW2PjtJ6dLfJo/uFpZMXrWrfWc4HVXaS4dt7wAOdqTFOz2tUMAW
         Sh4jgDAbH8VqpoWazjlD1fPMiNXA3ezo1OR8Qb2Ldb10TbZRJRyKB5f8fsO2VyghWRRo
         DUN8vcbGvytIKpI3Li4Z4XYNxsUuVW/hq8Tm0/o14Nf6b8r5iP7ow01vGHFsr9oNiPxJ
         h4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QRx5VA2jL04EprKBK7dDPa5Y1K8LOZnjXRlM9vGrDU0=;
        b=UTKeNaSbywwWwewymbACKTpzfVSL4gp/ajBIIFjbH2E1QKQjEmayN09RkdoVXRTuVH
         rLm915Gy53A+iJysoGuAxoH24ivcxo/ETLXYYXgDNBsqHBPk6LSdlmfysMldSvjgSAjm
         iniSdAjRwwWWlvae8BLseLzIZcj5MDSXRl9Tp3NaFe+q+wTMfhinBygtbwRtf6B5J6GV
         2iotcPjr3iNICr7S9nRvq27K3PykrCUtQv0WCxr7oSK41kVG0z1xvDvwzt1gZMz/taqa
         h7uirw8IUsok8flhJ+dnz38BCwFHUX5jpjGlT+iUOyqQDjib7yzFCJchlYh/IL7ZSREE
         Zfeg==
X-Gm-Message-State: AOAM530Nuv1auOGFttY4C/fOoZofhaxQtx92O5MtGUCNLMZzMkdwJxAD
        KiSobkMSmI1GSjTTc38nFwXJQFDoCx0O7pA6bqci28MP
X-Google-Smtp-Source: ABdhPJwx9DQtlrknp8fQtePyBlOfOTUJ3/YpxF1EZWCjT38iyIFV7v9JZF70uZBRQqI4LZUO+8kdyKcBXWdXybCNC+k=
X-Received: by 2002:a05:6638:974:: with SMTP id o20mr1551672jaj.37.1602828679902;
 Thu, 15 Oct 2020 23:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtwBHTk-Xoeuo+RbgNwiNw-cWTAhdy1YG5y+vXnNDSv4w@mail.gmail.com>
 <bd8f21ed-5fd4-0974-f15a-16d2f3ee607f@samba.org> <87r1q3hixr.fsf@suse.com>
 <827fd43f-40a9-9480-a6b9-aea1fa69090c@talpey.com> <CAH2r5mt3t=FHVd8RtCyrzY6TUKb+rGENENXbKJBgUdq4T4Qe6Q@mail.gmail.com>
 <CAH2r5mu72VSPFhiLjL3YUtStXc1=B5SBP86+A5vEWFhLFyOJBw@mail.gmail.com>
In-Reply-To: <CAH2r5mu72VSPFhiLjL3YUtStXc1=B5SBP86+A5vEWFhLFyOJBw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Oct 2020 16:11:08 +1000
Message-ID: <CAN05THRAZnea1NUW7-h5jHsQ+yUpvxO-5KHGaFgKB87JxmWBqg@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] Add defines for new signing context
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Stefan Metzmacher <metze@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good, but I think Tom's point is we should not put this in
upstream until the feature is officially launched.
In  wireshark, we can add these things immediately since any capture
files with these parameters will continue to exist forever.
See wireshark still supports pre-RFS versions of iSCSI.
But for cifs.ko we might want to wait sending to Linus until it is
officially released in a consumer version of windows.

Lets just look at SMB2.PDF and all the bitfields/flags that specify a
feature with description and then the comment that it is not used,
clients should set it to 0 and servers must ignore the flag. Things
can change until official release.



On Fri, Oct 16, 2020 at 3:50 PM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Here is a patch to add a module load parm that is turned off by
> default to allow users to enable it for experimentation
>
> # ls /sys/module/cifs/parameters/
> CIFSMaxBufSize    cifs_min_small           enable_oplocks
> cifs_max_pending  disable_legacy_dialects  enable_signing_negcontext
> cifs_min_rcv      enable_gcm_256           require_gcm_256
>
> # cat /sys/module/cifs/parameters/enable_signing_negcontext
> N
>
> On Thu, Oct 15, 2020 at 11:50 PM Steve French <smfrench@gmail.com> wrote:
> >
> > > suggest wrapping this context and the integrity algs in some kind of =
conditional
> >
> > I have a couple patches to send the context (which I haven't merged
> > yet, because, similar to what you suggested, I wanted to make sure
> > they were disabled by default).
> >
> > Tentative plan was to have them disabled by default, and sending the
> > new context can be enabled for testing by a module parameter (e.g.
> > "echo 1 >  /sys/modules/cifs/parameters/enable_signing_context"  or
> > some similar config variable name)
> >
> > On Thu, Oct 15, 2020 at 1:15 PM Tom Talpey <tom@talpey.com> wrote:
> > >
> > > On 10/12/2020 5:50 AM, Aur=C3=A9lien Aptel wrote:
> > > > Patch LGTM
> > > >
> > > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > > >
> > > > Stefan Metzmacher via samba-technical <samba-technical@lists.samba.=
org>
> > > >> This isn't in MS-SMB2 yet.
> > > >>
> > > >> Is this AES_128?
> > > >
> > > > This is returned in latest Windows Server Insider builds but it's n=
ot
> > > > documented yet.
> > > >
> > > > https://www.microsoft.com/en-us/software-download/windowsinsiderpre=
viewserver
> > > >
> > > > I've asked dochelp about it during the SDC plugfest and they gave m=
e
> > > > this:
> > > >
> > > >      The new ContextType is:
> > > >      SMB2_SIGNING_CAPABILITIES 0x0008
> > > >      The Data field contains a list of signing algorithms.
> > > >      =E2=80=A2    It adds a new negotiate context, which enables SM=
B to decouple signing algorithms from dialects. E.g. if both client and ser=
ver supports it, a session may use HMAC-SHA256 with SMB 3.1.1.
> > > >      =E2=80=A2    It adds the AES-GMAC algorithm.
> > > >
> > > >      SigningAlgorithmCount (2 bytes): Count of signing algorithms
> > > >      SigningAlgorithms (variable): An array of SigningAlgorithmCoun=
t 16-bit integer IDs specifying the supported signing algorithms.
> > > >
> > > >      The following IDs are assigned:
> > > >      0 =3D HMAC-SHA256
> > > >      1 =3D AES-CMAC
> > > >      2 =3D AES-GMAC
> > > >
> > > >
> > > > I've been CCed in a Microsoft email thread later on and it seems to=
 be
> > > > unclear why this was missed/wasn't documented. Maybe this is subjec=
t to
> > > > change so take with a grain of salt.
> > >
> > > Just curious if you've heard back on this. Insider builds will someti=
mes
> > > support things that don't make it to the release. Even Preview docs c=
an
> > > change. However, AES_GMAC has been on the radar since 2015 (*) so
> > > perhaps the time has come!
> > >
> > > I'd suggest wrapping this context and the integrity algs in some kind=
 of
> > > conditional, in case this is delayed...
> > >
> > > Tom.
> > >
> > > (*) slide 29+
> > > https://www.snia.org/sites/default/files/SDC15_presentations/smb/Greg=
Kramer_%20SMB_3-1-1_rev.pdf
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
