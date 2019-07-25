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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818C7C7618B
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 14:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A64220659
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 14:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FG7kIFyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbfGYOvd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Jul 2019 10:51:33 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:39955 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387804AbfGYOvd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Jul 2019 10:51:33 -0400
Received: by mail-lj1-f176.google.com with SMTP id m8so14690813lji.7
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jul 2019 07:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pUr6qF7tigPZBDQcWwmq6D76HKvP4Jg7BLseOWQs26Y=;
        b=FG7kIFyZGxkoboqyl8TIVo4lmkx3EbdI64ATp4+0fRuZ+63KlkeLy7qOF1SXHX+ig7
         9cGVQ78QN9d7yjdMXEUo5YgVv7BWaJIffNnMFmh1gqthzBMwXTt+c37NPzG9tvKUBnpX
         hbrjqvyvEazcjm6kBzj8wCUtm1H41F7A3HamWdKI2ECgIO/jQ+HvS9T6pCyiAs4dHpJV
         BmxA7s3Lu4RnkeHq98A7z8ksMzAWrYNXctZ0gVQrNywMG0bSxxzszqnXY/qei2PSOFDv
         DmZN3kHfTgchINqCQrv0VFWM+nzlbtzUf2k3gsNAhajs5k4MorGm7mmArzPQZNOfvZUT
         mXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pUr6qF7tigPZBDQcWwmq6D76HKvP4Jg7BLseOWQs26Y=;
        b=I+kXxJUa0JHZAjELei6tr5kiRRcEqew89EHoGPa3m8aoo5FTOO0arybKUQqPvnzgMJ
         7ZxKDZrudKFs5wKAw0VpUyVcUKP78+Nznj7+IXXC9F5ulcxkkNg1MKIhyXBpw4FmuaRS
         EfyEk5aEmev+tjrigRzXVzIRiIEYK5kx848N0nmky+bJ6sbwp/o5mEZltSd5h4dcj4gZ
         GFpj2nAT4hIHJ1Q0Ldj+f5EOiFPSwcjkIf5VL7jx/vL7AKblqAf+rWWd2qZC6hkjiWJu
         M2tF/2Y4r3S/gZuurc6K7yQcnGaU0AEmIOc8uUsrPfaGCU+JFtdGxUlYJtiZAyX1vS+a
         BPxg==
X-Gm-Message-State: APjAAAXpHpoQ7f8CcZEsr61kZL9MTodsQesidaQj8aV67onOdwCrxDKM
        ads1ZK/buu5/7Se0PQzHrv+uF24X0zdZnZjsIpU=
X-Google-Smtp-Source: APXvYqx8/A1LVsFTYsf4QGfFUN55KrNTDJlZr0Fx4aJmLsz/P+ClE0nYu/G7p12V6etsgEPqCdZartfFPzxgSxbLwog=
X-Received: by 2002:a2e:9a58:: with SMTP id k24mr46454953ljj.165.1564066290352;
 Thu, 25 Jul 2019 07:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAO3V83L1Q9jCLBsjHgFE1jw2PPi_sHtQz4geDKC4jEPWkhNYBg@mail.gmail.com>
 <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com>
 <87zhlnvesj.fsf@suse.com> <CAO3V83+dmZNNaDQ14up=SL+pGv7ndiqG0y_rE7ciFyy1oNQCQw@mail.gmail.com>
In-Reply-To: <CAO3V83+dmZNNaDQ14up=SL+pGv7ndiqG0y_rE7ciFyy1oNQCQw@mail.gmail.com>
From:   Wout Mertens <wout.mertens@gmail.com>
Date:   Thu, 25 Jul 2019 16:51:19 +0200
Message-ID: <CAO3V83+tbZpmXgBUtqzqZ0R5j1OgbpxO5fftXzFughnkDRvhCg@mail.gmail.com>
Subject: Re: Fwd: mount.cifs fails but smbclient succeeds
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I installed linux 5.1.19 but that doesn't make a difference. It still
sets the DFS bit to 0 on the NTLMSSP_NEGOTIATE and then when smbclient
does a FSCTL_DFS_GET_REFERRALS, mount.cifs does a "Tree connect
request tree" which fails with "STATUS_BAD_NETWORK_NAME". After that
failure, it does do a FSCTL_DFS_GET_REFERRALS but it doesn't mount.



Wout.

On Thu, Jul 25, 2019 at 3:24 PM Wout Mertens <wout.mertens@gmail.com> wrote=
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
