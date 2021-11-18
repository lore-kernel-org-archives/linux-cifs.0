Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0014AC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Nov 2021 00:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B7761AFD
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Nov 2021 00:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbhKRAeT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Nov 2021 19:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhKRAeR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Nov 2021 19:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A1261B72;
        Thu, 18 Nov 2021 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637195477;
        bh=ge8O3XSc+rhcJ61Hra8kxuzsfavtrVhomTrdbcqrgnw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=KPa4D0AHwOt6da6GX/CQ12bHyaG/MJ4SSVJKncg8Fu2m6eZGbol/SZRxaZzp8Cbki
         H7G5xFdmK9zX0I3xNh7S0t3KLU/j/L/uTzsjMrgMpUy4x6fp6bDAtPlOgTdPbJfeir
         vGnmVxkTXwHii56tF32eUKW3ZoXaw2AkXXpNDdsjcWGwQnt2ZmHtIyGn3+ag5ESjQo
         Y4+d4AiEI78Hm7iDkDcDv7TrFGSEq4rzI3oTaT66TiA5vLMn2P5/MRhUMQFVgVaA/q
         T+JLOy97uxc1IXeWwdrsBmF861OEBwKlzBtYNp0aD0fLICs262jUI5ONph711RxGa5
         FqUmfQWLMIxgg==
Received: by mail-oi1-f176.google.com with SMTP id s139so10161782oie.13;
        Wed, 17 Nov 2021 16:31:17 -0800 (PST)
X-Gm-Message-State: AOAM531tgne5t8aDlOek97fbeOCjU2llUt3F1gAGefm7x9Zame9VuNHp
        CFgOR7WY7LbxwWqHPh7tJn77HGvJoNpsL6PCJG0=
X-Google-Smtp-Source: ABdhPJwHrFQ9QeCViy/0GXzQ26v+Tgd60IkanDALYbxV/kPkmRJaBsYZbx+asHhf/Lz6u0vjZAofa6WSPeUP1z+HVcQ=
X-Received: by 2002:a05:6808:14c3:: with SMTP id f3mr3835985oiw.51.1637195476980;
 Wed, 17 Nov 2021 16:31:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Wed, 17 Nov 2021 16:31:16
 -0800 (PST)
In-Reply-To: <YZU7EdoJmvisai+z@jeremy-acer>
References: <5831447.lOV4Wx5bFT@natalenko.name> <CAKYAXd-KmxMeYWP8z6RYYK6za-Sj81Qtb3RO=oG+Yy3kXDaLjg@mail.gmail.com>
 <2865530.e9J7NaK4W3@natalenko.name> <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
 <YZU7EdoJmvisai+z@jeremy-acer>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 18 Nov 2021 09:31:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9TTH+Nv5ebH6CYjZfwtwgy37uo5+XER4pT9=SPdJ0hnw@mail.gmail.com>
Message-ID: <CAKYAXd9TTH+Nv5ebH6CYjZfwtwgy37uo5+XER4pT9=SPdJ0hnw@mail.gmail.com>
Subject: Re: ksmbd: Unsupported addition info
To:     Jeremy Allison <jra@samba.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-18 2:25 GMT+09:00, Jeremy Allison <jra@samba.org>:
> On Wed, Nov 17, 2021 at 06:58:50PM +0900, Namjae Jeon wrote:
>>2021-11-17 16:00 GMT+09:00, Oleksandr Natalenko
>> <oleksandr@natalenko.name>:
>>> Hello.
>>>
>>> On st=C5=99eda 17. listopadu 2021 0:36:53 CET Namjae Jeon wrote:
>>>> 2021-11-17 6:44 GMT+09:00, Oleksandr Natalenko
>>>> <oleksandr@natalenko.name>:
>>>> > With the latest ksmbd from the next branch I have an issue with
>>>> > wife's
>>>> > Windows
>>>> > 10 laptop while copying/removing files from the network share. On he=
r
>>>> > client it
>>>> > looks like copy operation (server -> laptop) reaches 99% and then
>>>> > stalls,
>>>> > and
>>>> > on the server side there's this in the kernel log:
>>>> >
>>>> > ```
>>>> > ksmbd: Unsupported addition info: 0xf)
>>>> > ksmbd: Unsupported addition info: 0x20)
>
Hi Jeremy,
> Namjae, looks like your code is handling the
> following flags in query security descriptor:
>
>          if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECIN=
FO
> |
>                                PROTECTED_DACL_SECINFO |
>                                UNPROTECTED_DACL_SECINFO)) {
>                  pr_err("Unsupported addition info: 0x%x)\n",
>                         addition_info);
>
>  From the Samba code we have (the names are pretty
> similar):
>
>          /* security_descriptor->type bits */
>          typedef [public,bitmap16bit] bitmap {
>                  SEC_DESC_OWNER_DEFAULTED        =3D 0x0001,
>                  SEC_DESC_GROUP_DEFAULTED        =3D 0x0002,
>                  SEC_DESC_DACL_PRESENT           =3D 0x0004,
>                  SEC_DESC_DACL_DEFAULTED         =3D 0x0008,
>                  SEC_DESC_SACL_PRESENT           =3D 0x0010,
>                  SEC_DESC_SACL_DEFAULTED         =3D 0x0020,
>                  SEC_DESC_DACL_TRUSTED           =3D 0x0040,
>                  SEC_DESC_SERVER_SECURITY        =3D 0x0080,
>                  SEC_DESC_DACL_AUTO_INHERIT_REQ  =3D 0x0100,
>                  SEC_DESC_SACL_AUTO_INHERIT_REQ  =3D 0x0200,
>                  SEC_DESC_DACL_AUTO_INHERITED    =3D 0x0400,
>                  SEC_DESC_SACL_AUTO_INHERITED    =3D 0x0800,
>                  SEC_DESC_DACL_PROTECTED         =3D 0x1000,
>                  SEC_DESC_SACL_PROTECTED         =3D 0x2000,
>                  SEC_DESC_RM_CONTROL_VALID       =3D 0x4000,
>                  SEC_DESC_SELF_RELATIVE          =3D 0x8000
>          } security_descriptor_type;
>
> 0xF =3D=3D
> (SEC_DESC_OWNER_DEFAULTED|SEC_DESC_GROUP_DEFAULTED|SEC_DESC_DACL_PRESENT|=
SEC_DESC_DACL_DEFAULTED)
>
> and:
>
> 0x20 =3D=3D SEC_DESC_SACL_DEFAULTED
>
> Looks like you need to handle these bits.
>
> Hope this helps,
Let me check it. Thanks for your mail:)
>
> Jeremy.
>
