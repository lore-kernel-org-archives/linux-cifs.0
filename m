Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAA3C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 00:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92EB920857
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 00:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9fFarBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfDBATq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Apr 2019 20:19:46 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35272 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfDBATq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Apr 2019 20:19:46 -0400
Received: by mail-pf1-f175.google.com with SMTP id t21so5403448pfe.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Apr 2019 17:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MsU4oQ6/ujK0Xu+oO5/+kbw+SpD2O6zqpRPa+qVSpxw=;
        b=d9fFarBBcCm8kOw8VK7qBp1c4m++nFxUHQ6P+jFzvsu4W31Z4mgAZVwNOfiENdZXhT
         nj7bqeo40gA9chK4aFzEF/tzTxrKmw0yyWtzGEBUhvmcNwK8hpG6kLnwFvNOFM86MdU2
         rZEjXw77Y7pNpy46g39DxVk2dAKrmi/mrxSc72GlqqpSY0T1H1K8EMDIxGiJ6mNe9cJF
         nSw86BPTzntAPiZ/ANqIJy6g5vHsuK0AAfLgTgZ+GNM6YeSLxsZ768GFlAZiStXVgAXV
         QAV4JpMEn5H1P5Mj461XXoWpnuOJXgiKwwlumM9YQfQS5yaMz/uD14j6gTaiUw+ipu6g
         fHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MsU4oQ6/ujK0Xu+oO5/+kbw+SpD2O6zqpRPa+qVSpxw=;
        b=MpQCxN1wCAmu7kFpo4jLQ2mEElUSYqT+VfxfUrwsgjOckwwxExOcd/jBsRAe40KaXJ
         T081JtQK37Pj6RsHDytyM6dQphr4o8UrfI6YQ7bi/Uu9mTmEYDM0oOw8dPn6wBFHdQaZ
         23sl6nC7j9ZHuzkOF+AlEg9JujoKEbBk2v8DbDSU83EvqhnS3nvzuawvI8EY/AVyUXvM
         26W+fp6fH7OTHzF3oWEvYu2MtPCl1PXHDHnB0lwRgkVGpHtLRhOPpvQxPOPjJn1ZO2IF
         b04pu9BTjk41sQVsfwF8wPyc3hUi81yquDNDjOKP5tWNmsjDBYGB2E7ZBvGGUJNjpTpM
         AJug==
X-Gm-Message-State: APjAAAWDLy+PWnqvmC39irWj6/KFyfTYzJ+R+WO/AYqhKu6tF/vR3dht
        5NwxUuBM+9vmgGVzfhcxOMhQ2TnEvnEmUfg8y0g5QZRK
X-Google-Smtp-Source: APXvYqylROjD0Oba02x8FfjujJSBU0skxAmo7rRiIdlGVzxnaSUIwAF7ZqyK8+qb/zit4+jBGygXaAMR6h/f8kpEiko=
X-Received: by 2002:a62:4115:: with SMTP id o21mr64173936pfa.153.1554164385064;
 Mon, 01 Apr 2019 17:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <637c6227392d4f67b76aa6ebb8b71d0c@UL-EXC-PR-MBX20.ulaval.ca>
 <1550849364135.34775@ulaval.ca> <CAJUwKM3kKM-g6L+vAVNUvVbCds6ezFmaB8J2BQT2zWyHBmmc6Q@mail.gmail.com>
 <1551277059649.97069@ulaval.ca>
In-Reply-To: <1551277059649.97069@ulaval.ca>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Apr 2019 19:19:34 -0500
Message-ID: <CAH2r5msGR2HZeGomWEWemDjHfN_hukta80-Z88TxucC2OW6mSg@mail.gmail.com>
Subject: Re: mount -t cifs fails while smbclient succeed
To:     =?UTF-8?B?QWxleGlzIEZvcnRpbi1Dw7R0w6k=?= 
        <alexis.fortin-cote.1@ulaval.ca>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "Robin P. Blanchard" <robin.blanchard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

STATUS_PATH_NOT_COVERED is 'normal' indicating that there is a DFS
referral to a different target server share - so the server you are
mounting is redirecting you to another one.

Also note that the error that is logged "CIFS VFS: DFS capability
contradicts DFS flag" indicates that the server reported a different
value for share flags and capabilities (which is probably a server
bug).

Since this is Ubuntu 18.04 it is very easy to try with recent kernels
too and the 5.0 kernel had a huge improvement in DFS caching and
failover and is worth trying as an experiment.

Why don't you check and see if
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.0/ works around
(what may be) a server bug with the illegal flags?  That kernel
includes the good work by Paulo to improve DFS caching and failover.

On Wed, Feb 27, 2019 at 8:38 AM Alexis Fortin-C=C3=B4t=C3=A9
<alexis.fortin-cote.1@ulaval.ca> wrote:
>
> Hi,
> Thanks for your help.
> But it doesn't seem to be an authentication failure. I tried all sec opti=
on. Some clearly failed early (in the wireshark trace) due to authentificat=
ion problem. Its seems to be able to authenticate with ntlmv2.
> But fails latter in the exchange.
>
> https://pastebin.com/zkRHtTvq
>
> Frame 25 Create Response, Error: STATUS_PATH_NOT_COVERED
>
> Any idea?
>
> Thanks again.
>
> Alex
>
> ________________________________________
> De : Robin P. Blanchard <robin.blanchard@gmail.com>
> Envoy=C3=A9 : 22 f=C3=A9vrier 2019 14:13
> =C3=80 : Alexis Fortin-C=C3=B4t=C3=A9
> Cc : linux-cifs@vger.kernel.org
> Objet : Re: mount -t cifs fails while smbclient succeed
>
> Compare:
>
> failed: lines 21-42
>
> I think you may need to mount with a different sec option:
>
>
>        sec=3D
>            Security mode. Allowed values are:
>
>            =C2=B7   none - attempt to connection as a null user (no name)
>
>            =C2=B7   krb5 - Use Kerberos version 5 authentication
>
>            =C2=B7   krb5i - Use Kerberos authentication and forcibly enab=
le packet
>                signing
>
>            =C2=B7   ntlm - Use NTLM password hashing
>
>            =C2=B7   ntlmi - Use NTLM password hashing and force packet si=
gning
>
>            =C2=B7   ntlmv2 - Use NTLMv2 password hashing
>
>            =C2=B7   ntlmv2i - Use NTLMv2 password hashing and force packe=
t signing
>
>            =C2=B7   ntlmssp - Use NTLMv2 password hashing encapsulated in=
 Raw
>                NTLMSSP message
>
>            =C2=B7   ntlmsspi - Use NTLMv2 password hashing encapsulated i=
n Raw
>                NTLMSSP message, and force packet signing
>
>            The default in mainline kernel versions prior to v3.8 was sec=
=3Dntlm.
>            In v3.8, the default was changed to sec=3Dntlmssp.
>
> On Fri, Feb 22, 2019 at 9:30 AM Alexis Fortin-C=C3=B4t=C3=A9
> <alexis.fortin-cote.1@ulaval.ca> wrote:
> >
> >
> > Hi,
> > I have trouble mounting a windows share on my Ubuntu 18.04 workstation.
> > I've tried every thing I found using google search to no avail.
> >
> > The following smbclient command works, so I know my Username and Passwo=
rd are working
> > smbclient -U ulaval.ca\\alfoc //132.203.235.15/Partages/FSS
> >
> > But the following mount fails with errors :
> > sudo mount -t cifs -o cred=3D/home/alexis/smbcred,vers=3D2.0 //fssdc1.f=
ss.ulaval.ca/Partages/FSS/ /home/alexis/win/
> >
> > mount error(22): Invalid argument
> >
> > I've logged the failing and successful trace with wireshark
> > failed : https://pastebin.com/7UTBNgs2
> > success : https://pastebin.com/kQ80vVmr
> >
> > I'm using Kernel 4.20.11-042011-generic
> > I'm not sure about the server configuration, but it looks like its a wi=
ndows server that support smb vers=3D1.0 and vers=3D2.0
> > mount.cifs version: 6.8
> >
> > dmesg with debug information reads when it fails:
> > [ 2021.652324] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_R=
EQUIRED
> > [ 2021.667748] CIFS VFS: DFS capability contradicts DFS flag
> > [ 2021.673168] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> > [ 2021.675001] CIFS VFS: cifs_mount failed w/return code =3D -22
> >
> > Thanks for helping,
> > Please respond (cc) to this address.
> >
> > Alex
> >
> >



--=20
Thanks,

Steve
