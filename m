Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E8AC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928AA21655
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8x0Ip9y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfLMAX5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:23:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33463 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730883AbfLMAX5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:23:57 -0500
Received: by mail-lj1-f196.google.com with SMTP id 21so699475ljr.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HJ2coV9kgtRyh7n/88Fu97n26kXWABPP9CnRUglgklA=;
        b=f8x0Ip9y9zxy/ppagano6w/wS4F+2acx3f7KAaDvs1zuMyCXdEifO5fGLWja8PRaAB
         vFK+R1fuipbWIVaFBO9tBqzPXxp8/zASo1MUoaAqf40XF4M0bWbWRzq1mx0d965QawwC
         YUrRHj2qkiW3PdoVWjHH9+ya8aCURykFYN0RVV6cWYfy1dUJwKjoljCMBfSdBMHQpTpc
         v9Au+g27wMooNOk2BEz9JxugyKSHA3jYSC0UOevBYqrLuHK6i0us5ZOFkMLPstwPbcDm
         UNOiRDu7/t2AuoaTmwGTwzsoaKnWhAilyqydNwQJVa3w2E9TkfKFLvTXgEtzwZm3zF8c
         Qpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HJ2coV9kgtRyh7n/88Fu97n26kXWABPP9CnRUglgklA=;
        b=NLG/4W7CpD8HKQuX0+fJglYGi1F/RJuk+NXKGGL3PJpBrs43mFES5Ip8V5AckSjNpX
         o7PePIf7Uz67H6M0QMv10dUnNLvmuzHd4GX3A+sDO9T+aVixuUenoxgHbntXC+LkOz9h
         2llAHAmeeZ47TR/weugiok9Wbi00V2hBgGMYvacDIo3/MRGUGMypDnXbSB9FBBtfCUAC
         kpNCiKWT1+BcAz4K8pnerMjedMGqux8Oj/EoSTfQfTfc2thndkTo4DAivj89EzU8WcaO
         DHFv6B6l75H8QAxThZQAuLeKD9f01EjhEk0LZjXCFQVrFVyUQQKLojGroIGFup68+61N
         1RWQ==
X-Gm-Message-State: APjAAAW2D/pJbTgJM5y/Zr5iqgLD2thwFPoYcCHzsuwD9XwCszhzAjt4
        oLcxkD6hemZTK02PPBHSFD4GyFhqfWdTKUADBg==
X-Google-Smtp-Source: APXvYqy05To8zT0ZyF+uA0RcV/bjVY3D1Uvv6CFBS2+WUYBlM3G9lzm1ENGZugu+hNSUc1w4AUJCQF1cnPzIqK27ka8=
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr7961714ljg.168.1576196635036;
 Thu, 12 Dec 2019 16:23:55 -0800 (PST)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com>
 <87k19ef0si.fsf@suse.com> <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
 <87h84hf4k6.fsf@suse.com>
In-Reply-To: <87h84hf4k6.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:23:43 -0800
Message-ID: <CAKywueRD76842q22OpZePdhO9+febBv-CxdhZZiCjCrCjrpAGQ@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi everyone,

Sorry for the delay in responses. I agree with the idea to re-write
smbinfo in python since it gives more flexibility. And yes, we will
need installers for python utilities in order to properly ship those.

I am going to cut off the next release at the beginning of next week.
The "next" branch is updated to have everything that I have got for
now, except smbinfo re-write in python that I would like to postpone
for the next release.

https://github.com/piastry/cifs-utils/commits/next

If any patch is missed or If someone has any WIP patches that need to
be in the next release, please let me know.

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 10 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 00:22, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> "ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> > I think it would be good to have these tools as part of the actual inst=
all.
> > They are in python so they are imho much more useful to the target user=
s
> > (sysadmins) than a utility written in C.
> > (I kind of regret that smbinfo is in C, it should have been python
> > too:-( )
>
> I completely agree, we could rewrite smbinfo in python.
>
> > Maybe we just need to decide on a naming prefix for these utilities
> > and then there shouldn't be
> > a problem to add many small useful tools.
>
> We can also make the C code call the python script for now (or vice
> versa, while smbinfo gets rewritten).
>
> > The nice thing with small python tools is that it is so easy to tweak
> > them to specific usecases.
>
> +100
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
