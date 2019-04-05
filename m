Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394F3C4360F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 16:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080EE204EC
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 16:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JmVXdGRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfDEQIH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 12:08:07 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44779 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfDEQIH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 12:08:07 -0400
Received: by mail-lj1-f180.google.com with SMTP id h16so5710122ljg.11
        for <linux-cifs@vger.kernel.org>; Fri, 05 Apr 2019 09:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tDBSo7niIByD/BOvtgLUkFqQyqtGLsoosIa+5xvOxrQ=;
        b=JmVXdGRmkLuHp0ASO/Jh3rJroo/SZ9u9zyIWThBs/p5Og90w7RMkzhzjq9gGG31tdy
         AxaYSd3x7hFiCd7v5DG3a9BRXcOD29L6M94N3Ap2Udc/3FALPz25efTe8CV+/uvREBjp
         FnUsm1VCHodrMU4zLCA5hZCykStHnuhBI2leszDviOW3w3PZa8cumGyVJhwaa2X4y0p9
         RPWXqdELlPNelrMnfczKGDexCXmUCmCMkh8KQF07+rbpRr9O8N5tcY1DtxXHWo0shrlP
         7ZzAOixrFJtKFlfwzNezepotUwsUW7FnUiowwcF+oj5sNtoB79LqWmg41CXK54PdBFFo
         gX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tDBSo7niIByD/BOvtgLUkFqQyqtGLsoosIa+5xvOxrQ=;
        b=VcsSNpqUAQgUsYY8RdOXOAyYGHSl/11/gfdxnqthYINzUSGaZB9gEt/jwUnSbjL+qO
         kB+2p6tg37KhzurK55MtjJANUNeMD3/bMdQH6u1OdBgkyDx42fYyObZNIYv71LTbPoun
         WVeqKuG+Pv0mjK/iFYpyQnWg6oxvHl0Qg1zwNIW2yTawDuD/uu0LhevdqsNMI3JSo0+3
         mI4RrQpPOQlf8OleT61sCcBt+ypQ1p6QidbgVSQsid0G73GJKXbEh6eMYpd/qjiWU8n+
         u4NCV5OVPvTfLawpDT+OQF5prebS1wb4KJVYhPrpKT0fXa62SUiJXKfvfEXooZgKNT9a
         WMsQ==
X-Gm-Message-State: APjAAAX1CqSmwpQI+pLO1NLpYcomva8rMthIyk/Nas1TKE15yOLIJ2qj
        rPOhgNgYgzb94lPB1w7TonyOjMd4vCShq+gODg==
X-Google-Smtp-Source: APXvYqw/sZLNRvKX68J0dUO4SI6zitPpxFmJuzYU2eHZ33KxtHeYiU450PyHXQ9TVC2wwXFrOznpXzqZZG8/dstCkR0=
X-Received: by 2002:a2e:6c0f:: with SMTP id h15mr7237996ljc.155.1554480485458;
 Fri, 05 Apr 2019 09:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mstkeagNZzxMZQdritnU53jsVOWW2kMN8bcfN2fL7CCOA@mail.gmail.com>
 <87sguwsse1.fsf@suse.com>
In-Reply-To: <87sguwsse1.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 5 Apr 2019 09:07:53 -0700
Message-ID: <CAKywueQbRG4HJOJ29fWBBZxW4_RbtMYAq7en1F=1zE+Jpt6w0A@mail.gmail.com>
Subject: Re: Add smb3 mount helper
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 5 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 02:39, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> Steve French <smfrench@gmail.com> writes:
> >     We want to encourage use of more secure SMB3, and don't want
> >     people using cifs and this new helper makes it less confusing:
> >          "mount -t smb3"
> >     rather than
> >          "mount -t cifs"
> >     Users can still mount the old way, but if they use smb3 mount
> >     helper (mount.smb3 or "mount -t smb3") it will be less confusing
> >     and less likely to use older insecure dialects.
>
> I don't think duplicating the source is a good idea. Could we just make
> a symlink or hardlink at installation? Alternatively move the common
> code to a separate file.
>
>

Agree. I suggest to move the common code to a separate file.

--
Best regards,
Pavel Shilovsky
