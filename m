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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C51C4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77280233FB
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgLPWok (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730280AbgLPWoj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 17:44:39 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D499C0617A6
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:43:59 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id y19so52432785lfa.13
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RraQxFubWkLaRPHcHp7s5FxOjPyXlZWojEueGaT6yF4=;
        b=N1IsJG7dCLsFwFYwWeQH2K1yP5v+WHU38XUruZVceRELQhlz2p17vqa2Sc+UaJlI95
         2RyCFIAeAHVGi53NA1rYSFCT5pL1EbHYc13eammS/nfjyMy+mrbw3cM4bDIk/Z0WUamW
         X/opNFJ3edshVD0WPs2uJOYKFU05EtaxxNwu0YL/k2MJ7Qqi43gyuP/P+DLI6epvy3CM
         RnYrZHkMZi5+m2Gs9+Cm1I6zmrMYXpD9t40zEM/8VSUpX+biouf57krWIM19xoXA1E85
         qs5GoHwqUOXDnUH2RsRY5ezbyWLZMJ/nG2MjD+BhFayAqNQh2KhPnhVpVY7DJji3OkSK
         vu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RraQxFubWkLaRPHcHp7s5FxOjPyXlZWojEueGaT6yF4=;
        b=B4ZzF2Nj5bKNcwOYjKHYiwMZpOSl/W+7h7vJC1ka1U0md6seCsFP1Q0ulOf6+36s+h
         adXbSiMsNbNWL7EXo1l+Gyg4IVU9vIllB1gZ0mK0lf2Q9OWarS4Ww8i2+ZP/shgEj/s6
         hu3/F6id73wYIgEyIqpVwU/tBNothFJv3ztZF88/mAkcbtYl2MNIW4si+PSc61PgDldL
         fulUXYaG3A/8CDRt1G7jD6tcQcr1C64IKgofrWR5V3w/qcdGO1/g6DSI5KPaRguzSXYK
         hshvDrs9Y98NJsF7vyqTWPBCAiwsqWs1vFRUmVW+5SGqOWcLtftFUTuRKw13v7qu/qup
         ACoQ==
X-Gm-Message-State: AOAM530+wvF0HTLLJLzrQVlFZczyDu/2fOWgnpXp1JpPu/XzgpfHXRvm
        kxhKaERIIIdBsYllugOSZpLcxgqKl8RXStE0oNXQ7dcMlAg=
X-Google-Smtp-Source: ABdhPJyEnvKmClQ5NoxTj0vrx8rbNsdtQ3PSNJUp4fUU3Ct4hWYm2LmiepyO9tQPq7+q3D48Ei6VQ9CD4RJE7GuYkXs=
X-Received: by 2002:a2e:6a14:: with SMTP id f20mr2223949ljc.6.1608158637870;
 Wed, 16 Dec 2020 14:43:57 -0800 (PST)
MIME-Version: 1.0
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net> <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
In-Reply-To: <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Dec 2020 16:43:46 -0600
Message-ID: <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
To:     Simo Sorce <simo@redhat.com>
Cc:     The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

generally I would feel more comfortable using something (library or
utility) in Samba (if needed) for additional SPNEGO support if
something is missing (in what the kernel drivers are doing to
encapsulate Active Directory or Samba AD krb5 tickets in SPNEGO) as
Samba is better maintained/tested etc. than most components.  Is there
something in Samba that could be used here instead of having a
dependency on another project - Samba has been doing Kerberos/SPNEGO
longer than most ...?   There are probably others (jra, Metze etc.)
that have would know more about gssproxy vs. Samba equivalents though
and would defer to them ...

On Wed, Dec 16, 2020 at 8:33 AM Simo Sorce <simo@redhat.com> wrote:
>
> Hi Michael,
> as you say the best course of action would be for cifs.ko to move to
> use the RPC interface we defined for knfsd (with any extensions that
> may  be needed), and we had discussions in the past with cifs upstream
> developers about it. But nothing really materialized.
>
> If something is needed in the short term, I thjink the quickest course
> of action is indeed to change the userspace helper to use gssapi
> function calls, so that they can be intercepted like we do for rpc.gssd
> (nfs client's userspace helper).
>
> Unfortunately I do not have the cycles to work on that myself at this
> time :-(
>
> HTH,
> Simo.
>
> On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> > Hello,
> >
> > I have a use-case for authentication of Linux cifs client mounts withou=
t the user being present (e.g. from batch jobs) using gssproxy's impersonat=
ion feature with Kerberos Constrained Delegation similar to how it can be d=
one for NFS[1].
> >
> > My understanding is that currently neither the Linux cifs kernel client=
 nor cifs-utils userland tools support acquiring credentials using gssproxy=
. The former uses a custom upcall interface to talk to cifs.spnego from cif=
s-utils. The latter then goes looking for Kerberos ticket caches using libk=
rb5 functions, not GSSAPI, which prevents gssproxy from interacting with it=
.[2]
> >
> > From what I understand, the preferred method would be to switch the Lin=
ux kernel client upcall to the RPC protocol defined by gssproxy[3] (as has =
been done for the Linux kernel NFS server already replacing rpc.svcgssd[4])=
. The kernel could then, at least optionally, talk to gssproxy directly to =
try and obtain credentials.
> >
> > Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI so th=
at gssproxy's interposer plugin could intercept GSSAPI calls and provide th=
em with the required credentials (similar to the NFS client rpc.gssd[5]).
> >
> > Assuming my understanding is correct so far:
> >
> > Is anyone doing any work on this and could use some help (testing, codi=
ng)?
> > What would be expected complexity and possible roadblocks when trying t=
o make a start at implementing this?
> > Or is the idea moot due to some constraint or recent development I'm no=
t aware of?
> >
> > I have found a recent discussion of the topic on linux-cifs[6] which pr=
ovided no definite answer though.
> >
> > As a crude attempt at an explicit userspace workaround I tried but fail=
ed to trick smbclient into initialising a ticket cache using gssproxy for c=
ifs.spnego to find later on.
> > Is this something that could be implemented without too much redundant =
effort (or should already work, perhaps using a different tool)?
> >
> > [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-imper=
sonation-via-constrained-delegation
> > [2] https://pagure.io/gssproxy/issue/56
> > [3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocumenta=
tion.md
> > [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-server
> > [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-client
> > [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> > --
> > Thanks,
> > Michael
> > _______________________________________________
> > gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> > To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
> > Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/co=
de-of-conduct/
> > List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> > List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@l=
ists.fedorahosted.org
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
Thanks,

Steve
