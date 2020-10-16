Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3373FC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 04:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62062073A
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 04:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNBSvhF8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbgJPEvC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgJPEvC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Oct 2020 00:51:02 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD40C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 21:51:00 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p15so1073045ljj.8
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 21:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=El1d4udlKsuJARiEY0oHwCh1PN6hfU+sP+g7/+dmgHc=;
        b=jNBSvhF8/fQKgJr/hqZbwqg7UsSSzJJWzpXOlGyVKS+LoL0A1FFEeEXFf5uINoc2Cq
         sMwYUIcLGO5xINiKaQNK8tN800bJTSx4H8g9RQB3FEHjsXGKbVAZyNvnLZrP4dwJrJ21
         Iz3v9CEuKEF+Y430BqyrUz7yzSNPv64WP8cc2vcGPEInOrBANhmpmkiFppD2MbPLrp0Z
         cGj0goRGNtbewLnzppQSYAxZ28s7A8rGhJfutfKYlC3gQVQyzSKpTKnZfINy7UqoLxxM
         kIcwuWBSwyjK4052PutCokp29wudJexEAyCi+udQlnF9fl6ww2HTcnKAKoT+OFsyM/2L
         5JEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=El1d4udlKsuJARiEY0oHwCh1PN6hfU+sP+g7/+dmgHc=;
        b=oH8KzIJ0FPja6bLZ/LyYfxjUTb+hv8zBVubWv3gfcqMzXA3kpZlFVSDLQlvsk7Heho
         mkcepgiQZZsbGiD+KV8YbOWXaeTIY13ehbcGBE4jVKI5IK30UI39eqZBlX2zYCbznWke
         qSQprPMe21qJU/C5DJnkCphY0LBIk1R/qdAhcuFV364ZfFZnytvl5tpfzP1PZWZcebD/
         X/O+r8VHlEvHF3SD7n9T7gP+8oIKU3Rip8SPN1qxsw++FcJsZPpLcxAPFqY8UOZpHaWo
         q3lZ0/N81udDK7/J6aD4DFFYnQeHTnGNcYfSoRx5d6/BjLydHNji9g8e+f9wcVyClrPm
         BOuA==
X-Gm-Message-State: AOAM532Q248oJge39lQE1kL9YF43oBzrq0C3W5xpV9akSalgkdW6wEjt
        XFuyc3FELtmGzCUKxnpZp5lPD8ufNEN8EiqHswFxKs6bCxIvBA==
X-Google-Smtp-Source: ABdhPJwyuHIMsMJycZcJaXGrCm8C8VeMpnCnzOUqM1mmf0Bo9qbGQlruiK85myct2elANvJJkc47V75E5RgGEz9i1Tc=
X-Received: by 2002:a2e:a376:: with SMTP id i22mr769000ljn.325.1602823859357;
 Thu, 15 Oct 2020 21:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtwBHTk-Xoeuo+RbgNwiNw-cWTAhdy1YG5y+vXnNDSv4w@mail.gmail.com>
 <bd8f21ed-5fd4-0974-f15a-16d2f3ee607f@samba.org> <87r1q3hixr.fsf@suse.com> <827fd43f-40a9-9480-a6b9-aea1fa69090c@talpey.com>
In-Reply-To: <827fd43f-40a9-9480-a6b9-aea1fa69090c@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 15 Oct 2020 23:50:48 -0500
Message-ID: <CAH2r5mt3t=FHVd8RtCyrzY6TUKb+rGENENXbKJBgUdq4T4Qe6Q@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] Add defines for new signing context
To:     Tom Talpey <tom@talpey.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Stefan Metzmacher <metze@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> suggest wrapping this context and the integrity algs in some kind of cond=
itional

I have a couple patches to send the context (which I haven't merged
yet, because, similar to what you suggested, I wanted to make sure
they were disabled by default).

Tentative plan was to have them disabled by default, and sending the
new context can be enabled for testing by a module parameter (e.g.
"echo 1 >  /sys/modules/cifs/parameters/enable_signing_context"  or
some similar config variable name)

On Thu, Oct 15, 2020 at 1:15 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/12/2020 5:50 AM, Aur=C3=A9lien Aptel wrote:
> > Patch LGTM
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >
> > Stefan Metzmacher via samba-technical <samba-technical@lists.samba.org>
> >> This isn't in MS-SMB2 yet.
> >>
> >> Is this AES_128?
> >
> > This is returned in latest Windows Server Insider builds but it's not
> > documented yet.
> >
> > https://www.microsoft.com/en-us/software-download/windowsinsiderpreview=
server
> >
> > I've asked dochelp about it during the SDC plugfest and they gave me
> > this:
> >
> >      The new ContextType is:
> >      SMB2_SIGNING_CAPABILITIES 0x0008
> >      The Data field contains a list of signing algorithms.
> >      =E2=80=A2    It adds a new negotiate context, which enables SMB to=
 decouple signing algorithms from dialects. E.g. if both client and server =
supports it, a session may use HMAC-SHA256 with SMB 3.1.1.
> >      =E2=80=A2    It adds the AES-GMAC algorithm.
> >
> >      SigningAlgorithmCount (2 bytes): Count of signing algorithms
> >      SigningAlgorithms (variable): An array of SigningAlgorithmCount 16=
-bit integer IDs specifying the supported signing algorithms.
> >
> >      The following IDs are assigned:
> >      0 =3D HMAC-SHA256
> >      1 =3D AES-CMAC
> >      2 =3D AES-GMAC
> >
> >
> > I've been CCed in a Microsoft email thread later on and it seems to be
> > unclear why this was missed/wasn't documented. Maybe this is subject to
> > change so take with a grain of salt.
>
> Just curious if you've heard back on this. Insider builds will sometimes
> support things that don't make it to the release. Even Preview docs can
> change. However, AES_GMAC has been on the radar since 2015 (*) so
> perhaps the time has come!
>
> I'd suggest wrapping this context and the integrity algs in some kind of
> conditional, in case this is delayed...
>
> Tom.
>
> (*) slide 29+
> https://www.snia.org/sites/default/files/SDC15_presentations/smb/GregKram=
er_%20SMB_3-1-1_rev.pdf



--=20
Thanks,

Steve
