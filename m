Return-Path: <SRS0=SjeK=VW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E29C76190
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 18:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A5F22BEF
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 18:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5Q1jSx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfGYSvd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Jul 2019 14:51:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45973 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGYSvc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Jul 2019 14:51:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so23189699pfq.12
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jul 2019 11:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ShXp07IhPxqxswl7Kll2yThYng3eon29wJBqeUyllvM=;
        b=s5Q1jSx5vfls4l0LlJz5i4LTFjQYPIdz8mWL4GrfiFUVTA7cGLP9E9eapoQBAhRS3/
         EAmFoiqhNK/tVza0Yhk64QZyHI41sYjJw/Ld6uU/vPrRR0Whykd84JzV/zckH33Mxy38
         witGG3/W/XVOIu91YvOARSrdcriC85v4SSzuMZeGAslZDDOp9y2gVCUdLhUlf6aRLzzb
         AVltFS5kthmaM18Fs4YnvGPTpUqOO7/21uhEPxPVHPnUdWcUZJECiGj8FlYy1tAFcKNh
         8e4G0DOEh0m48KsqQXiEPg6XxQDxxWWegRV4vSlvzvXQ2oBPrLCqJy3/K+ufKcQZbyVP
         5PPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ShXp07IhPxqxswl7Kll2yThYng3eon29wJBqeUyllvM=;
        b=och05G7hx7YIENH2VD2ynHU29vRMGDudxzf7hPpema7hi0jRpmoQsI4kFKuauS+MOO
         DzIedtW4NTZTbhP5TKJhvlzVfwqivn30kVwgnc146LWJbPte5BI5cUg5rhbNqrupCfmS
         cl5zW/DnwQSH54i1Gv59rstNe0f3ewPAAMR/DK0IQCsW5fadelBQmmnm6p0y8EwyBcXy
         yvbDKZtIEPJ39LG7zYY794uVla/1Sezcule02NrnSn6nNqkEZc/JJWPRREmFetUKZD4v
         CBf2ix4+D+gx+IG+KgQT2r4CDj/N9D9E2yji93ZGynlLba/1Le3YFKXLIztWptauCS3B
         Gy7Q==
X-Gm-Message-State: APjAAAUNnw35iC0JyyCc6qd9Xu7AbHIcsjyi9xph/mMsdrfrQQE/Hl8U
        mPCrh8kHlnxTOywI5ZqBkgMgtbs7h+jeyn+j43rehXRz+/Q=
X-Google-Smtp-Source: APXvYqw7M6GJqRsXvNj4NLCyF2OmMe3hXWX1d6lf8SWnW5j7cVEVg1EV2qHBKpG4hI080SwGoXTgssC/+YwAHxH5Mr4=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr91419095pjb.138.1564080691601;
 Thu, 25 Jul 2019 11:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAO3V83L1Q9jCLBsjHgFE1jw2PPi_sHtQz4geDKC4jEPWkhNYBg@mail.gmail.com>
 <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com>
 <87zhlnvesj.fsf@suse.com> <CAO3V83+dmZNNaDQ14up=SL+pGv7ndiqG0y_rE7ciFyy1oNQCQw@mail.gmail.com>
In-Reply-To: <CAO3V83+dmZNNaDQ14up=SL+pGv7ndiqG0y_rE7ciFyy1oNQCQw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Jul 2019 13:51:20 -0500
Message-ID: <CAH2r5mvgbtL2YmqnRrKGQO5z4XRsS9GCTLyH+cDyGEfj0BhNpg@mail.gmail.com>
Subject: Re: Fwd: mount.cifs fails but smbclient succeeds
To:     Wout Mertens <wout.mertens@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To clarify the differences you see:
1) on the smb2 session setup requests you see the working client
(smbclient) setting the SMB2_FLAGS_PRIORITY flags (this shouldn't make
any difference because it is SMB3.1.1 specific flag unless the server
negotiated smb3.1.1)
2) you see CAP_DFS (0x00000001) not CAP_EXTENDED_SECURITY (0x80000000)
set on the Capabilities field of the session setup response (the
negotiate protocol request if you specify vers=3D3 or vers=3D3.1 or
vers=3D3.1.1 or vers=3D3.0 should show these capabilities set on the
negotiate protocol request:

SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING |
SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_PERSISTENT_HANDLES |
SMB2_GLOBAL_CAP_ENCRYPTION | SMB2_GLOBAL_CAP_DIRECTORY_LEASING

Would also be interesting to see if the signing required difference is rela=
ted.

I could give you a patch that forces the Capabilities field to include
more flags on session setup - it is easy enough to change the line
(round line 1181 of smb2pdu.c) - see SMB2_sess_alloc_buffer

req->Capabilities =3D 0;

to req_capabilities =3D SMB2_GLOBAL_CAP_DFS;

On Thu, Jul 25, 2019 at 9:12 AM Wout Mertens <wout.mertens@gmail.com> wrote=
:
>
> Thank you so much Aur=C3=A9lien, smbcmp was really helpful!
>
> Is there a way to force mount.cifs to use DFS? (cifs-utils 6.8, kernel 4.=
19.57)
>
> It turns out that when smbclient connects, it sends that it supports
> DFS, but mount.cifs sends that it does NOT support DFS. Then smbclient
> connects to the host and figures out the correct server to talk to,
> and connects as needed, but mount.cifs just fails to do that.
>
> What I did was to sniff the smbclient traffic for the server that has
> the path I wanted, and then mount that directly using mount.cifs. That
> works, but I'm worried that if they move things around it will break
> again, or maybe they'll split the mount in two servers.
>
> Here's the comparison: (-: smbclient, +: mount.cifs)
> =3D=3D=3D=3D=3D=3D
> smbclient first  has an extra "Negotiate Protocol Request" + Response,
> which the mount.cifs doesn't do. Then there's a common "Negotiate
> Protocol Request" + Response,
> > Session Setup Request, NTLMSSP_NEGOTIATE  (same with the subsequent NTL=
MSSP_AUTH)
>          Server Component: SMB2
>      SMB2Header Length: 64
> -        Credit Charge: 1
> +        Credit Charge: 0
>          Channel Sequence: 0
>          Reserved: 0000
>          Command: Session Setup (1)
> -        Credits requested: 8192
> -        Flags: 0x00000010, Priority
> +        Credits requested: 130
> +        Flags: 0x00000000
>              .... .... .... .... .... .... .... ...0 =3D Response: This
> is a REQUEST
>              .... .... .... .... .... .... .... ..0. =3D Async command:
> This is a SYNC command
>              .... .... .... .... .... .... .... .0.. =3D Chained: This
> pdu is NOT a chained command
>              .... .... .... .... .... .... .... 0... =3D Signing: This
> pdu is NOT signed
> -            .... .... .... .... .... .... .001 .... =3D Priority: This
> pdu contains a PRIORITY
> +            .... .... .... .... .... .... .000 .... =3D Priority: This
> pdu does NOT contain a PRIORITY
>              ...0 .... .... .... .... .... .... .... =3D DFS operation:
> This is a normal operation
>              ..0. .... .... .... .... .... .... .... =3D Replay
> operation: This is NOT a replay operation
>          Chain Offset: 0x00000000
> -        Message ID: Unknown (2)
> -        Process Id: 0x00000000
> +        Message ID: Unknown (1)
> +        Process Id: 0x000040fc
> [...]
> -        Security mode: 0x01, Signing enabled
> -            .... ...1 =3D Signing enabled: True
> -            .... ..0. =3D Signing required: False
> -        Capabilities: 0x00000001, DFS
> -            .... .... .... .... .... .... .... ...1 =3D DFS: This host
> supports DFS
> +        Security mode: 0x02, Signing required
> +            .... ...0 =3D Signing enabled: False
> +            .... ..1. =3D Signing required: True
> +        Capabilities: 0x00000000
> +            .... .... .... .... .... .... .... ...0 =3D DFS: This host
> does NOT support DFS
>
> After that, they both do
>
> > Session Setup Response
> > Tree Connect Request Tree: \\corp.local\IPC$
> > Tree Connect Response
>
> and then smclient does
> > Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \corp.local\ib
> but mount.cifs does
> > Ioctl Request FSCTL_VALIDATE_NEGOTIATE_INFO
> =3D=3D=3D=3D=3D=3D
>
> I saw that there were fixes in 5.0 regarding crediting and DFS
> reconnect, would they make a difference?
>
> Wout.
>
> On Tue, Jul 9, 2019 at 9:38 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > "Wout Mertens" <wout.mertens@gmail.com> writes:
> > > Any suggestions? This is driving me crazy :-/
> >
> > If you make a network capture of smbclient connecting and a capture of
> > mount.cifs failing you can use smbcmp [1] to compare them.
> >
> > https://github.com/aaptel/smbcmp
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)



--=20
Thanks,

Steve
