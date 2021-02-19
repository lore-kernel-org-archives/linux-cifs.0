Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE781C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 11:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7358764E92
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 11:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBSLbp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Feb 2021 06:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBSLbn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Feb 2021 06:31:43 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0583C061574
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 03:31:03 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id x19so5262723ybe.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 03:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iiY72QTWO/QuuHIj4qmiinDPixTgkLmZxFG3kDsLbMc=;
        b=WhbOzooiA+Ksr+yMUMvEsWYjY2xsd3JBkTo7/A/Ufg9OU3JQgP+D2PXpqgw+xR4Ohz
         Gy0yqN9DedZ5yBTudxXhQQr6o2AEZETIAJrNUUZMhvjGpF0FI1emT5pFiR/W6ZPKDepm
         3qKwwDshofbqgh/a2WLBVqkdrGa+nW07EiGOn4c89W18npo5UPYvOnlg+W/3DJfNFgtT
         fF+I/4XBHvDXcO0xWPwtJdDWVUJIaQgPpqiw3MhLcJcajmWNw7OzBWfN6t/+/gTVw+xx
         cL2aG6jslqQK4BN/0+zkoLwRj77rmlalI6+P/8kBXb3MGuYxtsL5vYWF78tTGdrIcVLt
         Oy1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iiY72QTWO/QuuHIj4qmiinDPixTgkLmZxFG3kDsLbMc=;
        b=ey/msHyLkqZi1lrr9YDwCkMqWFInGAmRE+M3VrKvXB3UiMaQDyfTaexDPCVhL9c+oH
         40bP19pY8ycZlUS1ZpcAS2RHEFWu2EHrT9pvQ2jbfxYpIia1hDh4wA3Vc1T+XqIWgANr
         wENXEzZUxMAhEfTmv/1tECZyJDXuGSCPJSvaymiYXQmA/BN1H/z9j8Tg8g0nUlGS7LP+
         ZgO1T72lBcjloUQS6ptNNMSLUGt/q01zTbK4YU9AT9zY4fSVVyMzh9hnfgsPNA1eBXax
         BiRF0xis4WXqBzM7WiBp7cjzj4rYAFxca1SvYcBnADq2QMhe7m2E3Rz1XvtIgO2ATj3t
         PpcQ==
X-Gm-Message-State: AOAM533Ron0wlxBpFN40+pMANsddwbO+uT2npvvY43JFix4aHsgipvFF
        ssQtItDBYdGa72AGk05FU0Ek+doyiXCBecUiZ2Lg27pzLnYE+X2C
X-Google-Smtp-Source: ABdhPJwQ83joxz4UbseNKL0lSKmfS8PUWVdfm+IU5TLW//dZMPJcG4iWgOum2PsCwoCAFLKQ1uFTfDO3imeuXW4d0Hc=
X-Received: by 2002:a25:ab29:: with SMTP id u38mr12715750ybi.327.1613734262896;
 Fri, 19 Feb 2021 03:31:02 -0800 (PST)
MIME-Version: 1.0
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net> <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
 <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com> <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
In-Reply-To: <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 19 Feb 2021 03:30:52 -0800
Message-ID: <CANT5p=p_G+jMMVMkYDL=fXZi_OO7eY2Foz8VkyQuT+1h5Xgifw@mail.gmail.com>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
To:     Simo Sorce <simo@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Simo,

> Finally the GSS-Proxy mechanism is namespace compatible, so you also
> get the ability to define different auth daemons per different
> containers, no need to invent new mechanisms for that or change yet
> again protocols/userspace to obtain container capabilities.

Could you please point me to the documentation for doing this?

Regards,
Shyam

On Thu, Dec 17, 2020 at 5:41 AM Simo Sorce <simo@redhat.com> wrote:
>
> Hi Steve,
>
> GSSAPI and krb5 as implemented in system krb5 libraries exists from
> longer than Samba has implemented those capabilities, I do not think it
> make sense to reason along those lines.
>
> GSS-Proxy has been built with a protocol to talk from the kernel that
> resolved a number of issues for knfsd (eg big packet sizes when a MS-
> PAC is present).
>
> And Samba uses internally exactly the same krb5 mechanism as it defers
> to the kerberos libraries as well.
>
> Additionally GSS-Proxy can be very easily extended to also do NTLMSSP
> using the same interface as I have built the gssntlmssp long ago from
> the MS spec, and is probably the most correct NTLMSSP implementation
> you can find around.
>
> Gssntlmssp also has a Winbind backend so you get automaticaly access to
> whatever cached credentials Winbindd has for users as a bonus (although
> the integration can be improved there), yet you *can* use it w/o
> Winbindd just fine providing a credential file (smbpasswd format
> compatible).
>
> GSS-Proxy is already integrated in distributions because it is used by
> knfsd, and can be as easily used by cifsd, and you *should* really use
> it there, so we can have a single, consistent, maintained, mechanism
> for server side GSS authentication, and not have to repeat and reinvent
> kernel to userspace mechanisms.
>
> And if you add it for cifsd you have yet another reason to do it for
> cifs.ko as well.
>
> Finally the GSS-Proxy mechanism is namespace compatible, so you also
> get the ability to define different auth daemons per different
> containers, no need to invent new mechanisms for that or change yet
> again protocols/userspace to obtain container capabilities.
>
> For the client we'll need to add some XDR parsing functions in kernel,
> they were omitted from my original patches because there was no client
> side kernel consumer back then, but it i an easy, mechanical change.
>
> HTH,
> Simo.
>
> On Wed, 2020-12-16 at 16:43 -0600, Steve French wrote:
> > generally I would feel more comfortable using something (library or
> > utility) in Samba (if needed) for additional SPNEGO support if
> > something is missing (in what the kernel drivers are doing to
> > encapsulate Active Directory or Samba AD krb5 tickets in SPNEGO) as
> > Samba is better maintained/tested etc. than most components.  Is there
> > something in Samba that could be used here instead of having a
> > dependency on another project - Samba has been doing Kerberos/SPNEGO
> > longer than most ...?   There are probably others (jra, Metze etc.)
> > that have would know more about gssproxy vs. Samba equivalents though
> > and would defer to them ...
> >
> > On Wed, Dec 16, 2020 at 8:33 AM Simo Sorce <simo@redhat.com> wrote:
> > > Hi Michael,
> > > as you say the best course of action would be for cifs.ko to move to
> > > use the RPC interface we defined for knfsd (with any extensions that
> > > may  be needed), and we had discussions in the past with cifs upstrea=
m
> > > developers about it. But nothing really materialized.
> > >
> > > If something is needed in the short term, I thjink the quickest cours=
e
> > > of action is indeed to change the userspace helper to use gssapi
> > > function calls, so that they can be intercepted like we do for rpc.gs=
sd
> > > (nfs client's userspace helper).
> > >
> > > Unfortunately I do not have the cycles to work on that myself at this
> > > time :-(
> > >
> > > HTH,
> > > Simo.
> > >
> > > On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> > > > Hello,
> > > >
> > > > I have a use-case for authentication of Linux cifs client mounts wi=
thout the user being present (e.g. from batch jobs) using gssproxy's impers=
onation feature with Kerberos Constrained Delegation similar to how it can =
be done for NFS[1].
> > > >
> > > > My understanding is that currently neither the Linux cifs kernel cl=
ient nor cifs-utils userland tools support acquiring credentials using gssp=
roxy. The former uses a custom upcall interface to talk to cifs.spnego from=
 cifs-utils. The latter then goes looking for Kerberos ticket caches using =
libkrb5 functions, not GSSAPI, which prevents gssproxy from interacting wit=
h it.[2]
> > > >
> > > > From what I understand, the preferred method would be to switch the=
 Linux kernel client upcall to the RPC protocol defined by gssproxy[3] (as =
has been done for the Linux kernel NFS server already replacing rpc.svcgssd=
[4]). The kernel could then, at least optionally, talk to gssproxy directly=
 to try and obtain credentials.
> > > >
> > > > Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI s=
o that gssproxy's interposer plugin could intercept GSSAPI calls and provid=
e them with the required credentials (similar to the NFS client rpc.gssd[5]=
).
> > > >
> > > > Assuming my understanding is correct so far:
> > > >
> > > > Is anyone doing any work on this and could use some help (testing, =
coding)?
> > > > What would be expected complexity and possible roadblocks when tryi=
ng to make a start at implementing this?
> > > > Or is the idea moot due to some constraint or recent development I'=
m not aware of?
> > > >
> > > > I have found a recent discussion of the topic on linux-cifs[6] whic=
h provided no definite answer though.
> > > >
> > > > As a crude attempt at an explicit userspace workaround I tried but =
failed to trick smbclient into initialising a ticket cache using gssproxy f=
or cifs.spnego to find later on.
> > > > Is this something that could be implemented without too much redund=
ant effort (or should already work, perhaps using a different tool)?
> > > >
> > > > [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-i=
mpersonation-via-constrained-delegation
> > > > [2] https://pagure.io/gssproxy/issue/56
> > > > [3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocum=
entation.md
> > > > [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-se=
rver
> > > > [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-cl=
ient
> > > > [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> > > > --
> > > > Thanks,
> > > > Michael
> > > > _______________________________________________
> > > > gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> > > > To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.=
org
> > > > Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/projec=
t/code-of-conduct/
> > > > List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidel=
ines
> > > > List Archives: https://lists.fedorahosted.org/archives/list/gss-pro=
xy@lists.fedorahosted.org
> > >
> > > --
> > > Simo Sorce
> > > RHEL Crypto Team
> > > Red Hat, Inc
> > >
> > >
> > >
> > >
> >
> >
>
> --
> Simo Sorce
> RHEL Crypto Team
> Red Hat, Inc
>
>
>
>


--=20
Regards,
Shyam
