Return-Path: <SRS0=SjeK=VW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4E0C76190
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 23:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D8D2173E
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 23:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sKvy91W3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfGYXWw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Jul 2019 19:22:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40038 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGYXWw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Jul 2019 19:22:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so23936044pla.7
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jul 2019 16:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z2NdjywOIpNDArejK7fcNT8qBE4gYa3vt/vFWStG5CY=;
        b=sKvy91W38kRDJyHp7zWj8sk+0doSJcpdysoUtQbfi2vN9Ywm7NMjiqR314dFg+5EUA
         t6IAA4xTZd3eK5Jk+hp1tbaDXOHdlEL6s3D+abbn26Nb8nsc7oTww7YRoRxy1cZURa4f
         vi5kwQjmDcJ8TKYMKwtH37IOkCTtBplwnz488EXvSBshn94TxLrJp9YIYD/Bv/tUB0AL
         jwKjvYgaCkOVu+JiiZb1eJM3LpkYj2UnxRya+uQLSuE4Pipw0QhScGuwutn3Fy/9e6cC
         M2jX3fKnUJXjkizLbOsr8pIA4khCjS/RGNsHcVD9iCAMs1fSBm9rlZRDSZ87+qnAbAIZ
         mVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z2NdjywOIpNDArejK7fcNT8qBE4gYa3vt/vFWStG5CY=;
        b=h2UkH6GVtwkox7nCt2XRcUbnXaJPwlfw3H5S2LBnkcmoGgsO2aD005Us5noTMtqKzU
         RZR4ateu5LkWwKMxH3iQXX+JReS8l2k2N+XBocTHr2C66GI9miHlgRyaUn9bKehF59KK
         7o8NyBpQwkTUMTVPnU/SneZDxfoOOlOYC/o1qHqmupluyXrQNYFCDRY/XUjnXLMUDT5v
         2q9uBhhA3zBmVt94IHcomwA41SJyvH7v0BHwGn/gxgzhUO2kzUdWRorx6NO4+f1iV3+m
         8owKdr5ESNETA/wHXAr9MZ1mb+mvcgCIxKFifzqTp/YecN7EDpzGU1LnsSk9HT3D7Xk0
         IkOw==
X-Gm-Message-State: APjAAAXIvHAx8EoyRLPM780XcyUbL1YrHq0veK2p7bhrbLMYuGBZiit+
        mhDNFW8S6v71dz2NGOcvCYRFL5bGg8VylmjvwOSHRBSm
X-Google-Smtp-Source: APXvYqwdMb4QX3c+XBKukb8QE9oSZqFYb9H+e2vwEUXGr8YD9VwtRFhJD+VCBT/VcnSA6kQPkbzBINDCVE8w+QAtQjM=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr93940875plb.46.1564096971117;
 Thu, 25 Jul 2019 16:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAO3V83L1Q9jCLBsjHgFE1jw2PPi_sHtQz4geDKC4jEPWkhNYBg@mail.gmail.com>
 <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com>
 <87zhlnvesj.fsf@suse.com> <CAO3V83+dmZNNaDQ14up=SL+pGv7ndiqG0y_rE7ciFyy1oNQCQw@mail.gmail.com>
 <CAH2r5mvgbtL2YmqnRrKGQO5z4XRsS9GCTLyH+cDyGEfj0BhNpg@mail.gmail.com> <CAO3V83JL1ddpMeTHSp6M78vVfe8LdDHwwOQo3849FsNP_QsKfA@mail.gmail.com>
In-Reply-To: <CAO3V83JL1ddpMeTHSp6M78vVfe8LdDHwwOQo3849FsNP_QsKfA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Jul 2019 18:22:39 -0500
Message-ID: <CAH2r5mvqYUHSRPexefEcKM1aJ-3NGZs+MmWXmKi=pzLeA=Cb8g@mail.gmail.com>
Subject: Re: Fwd: mount.cifs fails but smbclient succeeds
To:     Wout Mertens <wout.mertens@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005bf339058e89b459"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005bf339058e89b459
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is a patch to try


On Thu, Jul 25, 2019 at 3:59 PM Wout Mertens <wout.mertens@gmail.com> wrote=
:
>
> Thanks! I'll give that a try and let you know.
>
> Wout.
>
> On Thu, Jul 25, 2019 at 8:51 PM Steve French <smfrench@gmail.com> wrote:
> >
> > To clarify the differences you see:
> > 1) on the smb2 session setup requests you see the working client
> > (smbclient) setting the SMB2_FLAGS_PRIORITY flags (this shouldn't make
> > any difference because it is SMB3.1.1 specific flag unless the server
> > negotiated smb3.1.1)
> > 2) you see CAP_DFS (0x00000001) not CAP_EXTENDED_SECURITY (0x80000000)
> > set on the Capabilities field of the session setup response (the
> > negotiate protocol request if you specify vers=3D3 or vers=3D3.1 or
> > vers=3D3.1.1 or vers=3D3.0 should show these capabilities set on the
> > negotiate protocol request:
> >
> > SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING |
> > SMB2_GLOBAL_CAP_LARGE_MTU | SMB2_GLOBAL_CAP_PERSISTENT_HANDLES |
> > SMB2_GLOBAL_CAP_ENCRYPTION | SMB2_GLOBAL_CAP_DIRECTORY_LEASING
> >
> > Would also be interesting to see if the signing required difference is =
related.
> >
> > I could give you a patch that forces the Capabilities field to include
> > more flags on session setup - it is easy enough to change the line
> > (round line 1181 of smb2pdu.c) - see SMB2_sess_alloc_buffer
> >
> > req->Capabilities =3D 0;
> >
> > to req_capabilities =3D SMB2_GLOBAL_CAP_DFS;
> >
> > On Thu, Jul 25, 2019 at 9:12 AM Wout Mertens <wout.mertens@gmail.com> w=
rote:
> > >
> > > Thank you so much Aur=C3=A9lien, smbcmp was really helpful!
> > >
> > > Is there a way to force mount.cifs to use DFS? (cifs-utils 6.8, kerne=
l 4.19.57)
> > >
> > > It turns out that when smbclient connects, it sends that it supports
> > > DFS, but mount.cifs sends that it does NOT support DFS. Then smbclien=
t
> > > connects to the host and figures out the correct server to talk to,
> > > and connects as needed, but mount.cifs just fails to do that.
> > >
> > > What I did was to sniff the smbclient traffic for the server that has
> > > the path I wanted, and then mount that directly using mount.cifs. Tha=
t
> > > works, but I'm worried that if they move things around it will break
> > > again, or maybe they'll split the mount in two servers.
> > >
> > > Here's the comparison: (-: smbclient, +: mount.cifs)
> > > =3D=3D=3D=3D=3D=3D
> > > smbclient first  has an extra "Negotiate Protocol Request" + Response=
,
> > > which the mount.cifs doesn't do. Then there's a common "Negotiate
> > > Protocol Request" + Response,
> > > > Session Setup Request, NTLMSSP_NEGOTIATE  (same with the subsequent=
 NTLMSSP_AUTH)
> > >          Server Component: SMB2
> > >      SMB2Header Length: 64
> > > -        Credit Charge: 1
> > > +        Credit Charge: 0
> > >          Channel Sequence: 0
> > >          Reserved: 0000
> > >          Command: Session Setup (1)
> > > -        Credits requested: 8192
> > > -        Flags: 0x00000010, Priority
> > > +        Credits requested: 130
> > > +        Flags: 0x00000000
> > >              .... .... .... .... .... .... .... ...0 =3D Response: Th=
is
> > > is a REQUEST
> > >              .... .... .... .... .... .... .... ..0. =3D Async comman=
d:
> > > This is a SYNC command
> > >              .... .... .... .... .... .... .... .0.. =3D Chained: Thi=
s
> > > pdu is NOT a chained command
> > >              .... .... .... .... .... .... .... 0... =3D Signing: Thi=
s
> > > pdu is NOT signed
> > > -            .... .... .... .... .... .... .001 .... =3D Priority: Th=
is
> > > pdu contains a PRIORITY
> > > +            .... .... .... .... .... .... .000 .... =3D Priority: Th=
is
> > > pdu does NOT contain a PRIORITY
> > >              ...0 .... .... .... .... .... .... .... =3D DFS operatio=
n:
> > > This is a normal operation
> > >              ..0. .... .... .... .... .... .... .... =3D Replay
> > > operation: This is NOT a replay operation
> > >          Chain Offset: 0x00000000
> > > -        Message ID: Unknown (2)
> > > -        Process Id: 0x00000000
> > > +        Message ID: Unknown (1)
> > > +        Process Id: 0x000040fc
> > > [...]
> > > -        Security mode: 0x01, Signing enabled
> > > -            .... ...1 =3D Signing enabled: True
> > > -            .... ..0. =3D Signing required: False
> > > -        Capabilities: 0x00000001, DFS
> > > -            .... .... .... .... .... .... .... ...1 =3D DFS: This ho=
st
> > > supports DFS
> > > +        Security mode: 0x02, Signing required
> > > +            .... ...0 =3D Signing enabled: False
> > > +            .... ..1. =3D Signing required: True
> > > +        Capabilities: 0x00000000
> > > +            .... .... .... .... .... .... .... ...0 =3D DFS: This ho=
st
> > > does NOT support DFS
> > >
> > > After that, they both do
> > >
> > > > Session Setup Response
> > > > Tree Connect Request Tree: \\corp.local\IPC$
> > > > Tree Connect Response
> > >
> > > and then smclient does
> > > > Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \corp.local\ib
> > > but mount.cifs does
> > > > Ioctl Request FSCTL_VALIDATE_NEGOTIATE_INFO
> > > =3D=3D=3D=3D=3D=3D
> > >
> > > I saw that there were fixes in 5.0 regarding crediting and DFS
> > > reconnect, would they make a difference?
> > >
> > > Wout.
> > >
> > > On Tue, Jul 9, 2019 at 9:38 AM Aur=C3=A9lien Aptel <aaptel@suse.com> =
wrote:
> > > >
> > > > "Wout Mertens" <wout.mertens@gmail.com> writes:
> > > > > Any suggestions? This is driving me crazy :-/
> > > >
> > > > If you make a network capture of smbclient connecting and a capture=
 of
> > > > mount.cifs failing you can use smbcmp [1] to compare them.
> > > >
> > > > https://github.com/aaptel/smbcmp
> > > >
> > > > --
> > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG =
N=C3=BCrnberg)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--0000000000005bf339058e89b459
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-send-CAP_DFS-capability-during-session-setup.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-send-CAP_DFS-capability-during-session-setup.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jyjaxw4k0>
X-Attachment-Id: f_jyjaxw4k0

RnJvbSAxODJjODA2YzNkOTZhZGY1N2MzMjg0MjE3OGRiMDZlNDRiNDZkMjQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjUgSnVsIDIwMTkgMTg6MTM6MTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBzZW5kIENBUF9ERlMgY2FwYWJpbGl0eSBkdXJpbmcgc2Vzc2lvbiBzZXR1cAoKV2UgaGFk
IGEgcmVwb3J0IG9mIGEgc2VydmVyIHdoaWNoIGRpZCBub3QgZG8gYSBERlMgcmVmZXJyYWwKYmVj
YXVzZSB0aGUgc2Vzc2lvbiBzZXR1cCBDYXBhYmlsaXRpZXMgZmllbGQgd2FzIHNldCB0byAwCih1
bmxpa2UgbmVnb3RpYXRlIHByb3RvY29sIHdoZXJlIHdlIHNldCBDQVBfREZTKS4gIEJldHRlciB0
bwpzZW5kIGl0IHNlc3Npb24gc2V0dXAgaW4gdGhlIGNhcGFiaWxpdGllcyBhcyB3ZWxsICh0aGlz
IGFsc28KbW9yZSBjbG9zZWx5IG1hdGNoZXMgV2luZG93cyBjbGllbnQgYmVoYXZpb3IpLgoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L2NpZnMvc21iMnBkdS5jIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5k
ZXggNTNmODg5NzgzZTU5Li5lZTVkNzQ5ODhhOWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBk
dS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0xMTk2LDcgKzExOTYsMTIgQEAgU01CMl9z
ZXNzX2FsbG9jX2J1ZmZlcihzdHJ1Y3QgU01CMl9zZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAllbHNl
CiAJCXJlcS0+U2VjdXJpdHlNb2RlID0gMDsKIAorI2lmZGVmIENPTkZJR19DSUZTX0RGU19VUENB
TEwKKwlyZXEtPkNhcGFiaWxpdGllcyA9IGNwdV90b19sZTMyKFNNQjJfR0xPQkFMX0NBUF9ERlMp
OworI2Vsc2UKIAlyZXEtPkNhcGFiaWxpdGllcyA9IDA7CisjZW5kaWYgLyogREZTX1VQQ0FMTCAq
LworCiAJcmVxLT5DaGFubmVsID0gMDsgLyogTUJaICovCiAKIAlzZXNzX2RhdGEtPmlvdlswXS5p
b3ZfYmFzZSA9IChjaGFyICopcmVxOwotLSAKMi4yMC4xCgo=
--0000000000005bf339058e89b459--
