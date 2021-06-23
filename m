Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD3CC2B9F4
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 02:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E978F61375
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 02:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFWCnZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:43:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14457 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWCnZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 22:43:25 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210623024106epoutp0141c7e5a45466cda7755a12184835be11~LFc5cG5sE2877528775epoutp01P
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 02:41:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210623024106epoutp0141c7e5a45466cda7755a12184835be11~LFc5cG5sE2877528775epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624416066;
        bh=R1UbNar9rzQZNvgOCSs+UdbSmm9iXApDYS91SSmuC14=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cpGCZHDkmPQMIMDqzQEMup0DtKANaq7UZQEs/BYpLdoGmMEcGxIcWWMpr6XTDtkq2
         bk80SbprC7kBBRl7fMlUw0tH+3rNaQAYaeBu8sHcD4fd3SKDJoUVZMMc/PnuXuYoHq
         B0/avBlPSBoZq9QrCtFVt0ODq2bEJppb3hKMjHxc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210623024106epcas1p10a8a0afa2e6707254f9c4084234921fc~LFc49xYyX1584815848epcas1p1J;
        Wed, 23 Jun 2021 02:41:06 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.165]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4G8nZT1YFfz4x9Q5; Wed, 23 Jun
        2021 02:41:05 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.FA.09551.14F92D06; Wed, 23 Jun 2021 11:41:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210623024104epcas1p3e9c5447addcf156d86bf54768170dc65~LFc3fwmqx0209002090epcas1p3u;
        Wed, 23 Jun 2021 02:41:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210623024104epsmtrp155d6a768f95ebca22cfef77963f445c9~LFc3ehl7D0643206432epsmtrp1c;
        Wed, 23 Jun 2021 02:41:04 +0000 (GMT)
X-AuditID: b6c32a36-2c9ff7000000254f-4f-60d29f410e67
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.70.08394.04F92D06; Wed, 23 Jun 2021 11:41:04 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210623024104epsmtip2fa02f2d0eb6d95821f4f74bfb753f13f~LFc3UpDE70368303683epsmtip2t;
        Wed, 23 Jun 2021 02:41:04 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     =?utf-8?Q?'Aur=C3=A9lien_Aptel'?= <aurelien.aptel@gmail.com>,
        "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>,
        "'Steve French'" <smfrench@gmail.com>,
        "'ronnie sahlberg'" <ronniesahlberg@gmail.com>
In-Reply-To: <87mtriqj6v.fsf@suse.com>
Subject: RE: ksmbd mailing list
Date:   Wed, 23 Jun 2021 11:41:04 +0900
Message-ID: <006501d767d9$361eeec0$a25ccc40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKEoK/ucUJhU+AlUKRaTDLvHCKH0wHZDfPRAiUqc4MCZCxSv6mTXRAg
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZdlhTT9dx/qUEgxlr2C2Ov/7LbnF6wiIm
        ixf/dzFb/Pz/ndGit+8Tq8WbF4fZHNg8ds66y+6xeYWWx+4Fn5k8Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIyWi/u4at4Apn
        xbc/M5kbGFdwdjFyckgImEhsufqVqYuRi0NIYAejxOU/R9ggnE+MEosvz2cDqRIS+MYosfCF
        N0zHu1MfWSCK9jJK7Fh8D6rjBaPE25bH7CBVbAK6Ev/+7AfrFhHIlehd95IZpIhZYBmjxNwH
        vWAJTgE1iW39F5hBbGEBeYlVhxuYQGwWAVWJ9atusIDYvAKWEisWLGeEsAUlTs58AhZnFtCW
        WLbwNTPESQoSP58uY4WIi0jM7mwDinMALXaTmD4vGmSvhEArh8Sne2/ZIepdJO5862CBsIUl
        Xh3fAhWXknjZ3wZll0ucOPmLCcKukdgwbx87yEwJAWOJnhclICazgKbE+l36EBWKEjt/z2WE
        uIBP4t3XHlaIal6JjjYhiBJVib5Lh6EGSkt0tX9gn8CoNAvJX7OQ/DULyS+zEJYtYGRZxSiW
        WlCcm55abFhghBzXmxjByVLLbAfjpLcf9A4xMnEwHmKU4GBWEuF91HIpQYg3JbGyKrUoP76o
        NCe1+BCjKTCkJzJLiSbnA9N1Xkm8oamRsbGxhYmZuZmpsZI47062QwlCAumJJanZqakFqUUw
        fUwcnFINTBYNySFGBb8jop/1vG9c/yRoyVQbbf0b0QZPDPzvS5y3Pr/Tf4+v/tafJu89Vh3J
        b1mesGtSpVLe5p4DDVH11Wcnurp8naJ+if/zicN69jkRterbF94316q9+KL+zLsb02UbusJj
        Ul74+z30udx27UDDjglO3/eIKrixF77b4Gfb6Hp5FrOiTG7wxBLj7b9WdmkK7yqc8YpzwYfK
        axtmykkmLZ/WwfnvjVbe36Rw75kSNgFzeLM/vEl26f5bMcHd6MmxZYF39G3tTSVPK/3taWvt
        Yp/EVZN2b+6vV1ttco09b4gesvPMzO7J698te/2Lkrdw4fGOmcv4zpQ9lFgjVGNl8X6C08dd
        u4+FdLQrK7EUZyQaajEXFScCAC7c0hcfBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvK7D/EsJBituyVgcf/2X3eL0hEVM
        Fi/+72K2+Pn/O6NFb98nVos3Lw6zObB57Jx1l91j8wotj90LPjN5fN4kF8ASxWWTkpqTWZZa
        pG+XwJVxf/Yd9oIvbBXNOx6zNjAeZe1i5OSQEDCReHfqI0sXIxeHkMBuRomlG36wQCSkJY6d
        OMPcxcgBZAtLHD5cDFHzjFHi2P1HzCA1bAK6Ev/+7GcDsUUEciV6171kBiliFljBKHFj3Vuo
        qccYJX63r2YCqeIUUJPY1n8BrFtYQF5i1eEGsDiLgKrE+lU3wDbzClhKrFiwnBHCFpQ4OfMJ
        WJxZQFvi6c2ncPayha+ZIS5VkPj5dBkrRFxEYnZnG9jVIgJuEtPnRU9gFJ6FZNIsJJNmIZk0
        C0n3AkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwZGjpbmDcfuqD3qHGJk4GA8x
        SnAwK4nwPmq5lCDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMH
        p1QDU7hqlmLOn0+xmZWTBWXi1//hN5vn1FT201N00XnRy7Z8y4Nac1acyb11rZ471lZKYzsj
        +6tInX3Zl/23rTRSanuuZKfzbX7y0xcydzbZHto6KSbsVryV3I+pzkEH57oFT2KaeTnn0kqh
        K5fUuB6K33wsGLpy3dc3J38skvjTE6H4VmSeb11rz+XtjLM+WG+y/XX+7+40x1vrdos1aC1W
        iZ+0WeV+30vBPb2b+tJ1E848vpZ0THxRus6zVyuLrc69NA/wieppPL/YdovqCtmXE6bzT16X
        av6fW662b3WPcrfdxMcCvQmNxzn1D3ZVHt12der0klcng2d82hAWrRGZXKIXEXzsjElC2X5P
        g/LUjUosxRmJhlrMRcWJAOt8F2gLAwAA
X-CMS-MailID: 20210623024104epcas1p3e9c5447addcf156d86bf54768170dc65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
        <YNF/OpvdMLbIDZiZ@infradead.org>
        <013001d76734$0cf3bee0$26db3ca0$@samsung.com> <87mtriqj6v.fsf@suse.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> =22Namjae Jeon=22 <namjae.jeon=40samsung.com> writes:
> > Add CC: Steve, Ronnie, Aur=C3=A9lien.=0D=0A>=20>=20Any=20opinions?=0D=
=0A>=20=0D=0A>=20I=20think=20having=20only=20one=20list=20would=20be=20nice=
=20too,=20but=20we=20should=20ask/document=20to=20put=20a=20=5Bcifsd=5D=20t=
ag=0D=0A>=20somewhere=20in=20the=20subject,=20which=20is=20hard=20to=20enfo=
rce.=0D=0A>=20=0D=0A>=20Case=20in=20point,=20it=20already=20gets=20confusin=
g=20when=20people=20send=20patches=20for=0D=0A>=20cifs-utils:=20we=20can't=
=20always=20tell=20it's=20not=20for=20the=20kernel=20from=20the=20subject=
=20which=20can=20confuse=20people=20and=0D=0A>=20scripts.=0D=0AThanks=20for=
=20your=20opinion=21=0D=0AI=20will=20change=20to=20specify=20single=20list(=
linux-cifs=40vger.kernel.org)=20in=20MAINTAINERS.=0D=0A=0D=0A>=20Cheers,=0D=
=0A>=20--=0D=0A>=20Aur=C3=A9lien=20Aptel=20/=20SUSE=20Labs=20Samba=20Team=
=0D=0A>=20GPG:=201839=20CB5F=209F5B=20FB9B=20AA97=20=208C99=2003C8=20A49B=
=20521B=20D5D3=20SUSE=20Software=20Solutions=20Germany=20GmbH,=0D=0A>=20Max=
feldstr.=205,=2090409=20N=C3=BCrnberg,=20DE=0D=0A>=20GF:=20Felix=20Imend=C3=
=B6rffer,=20Mary=20Higgins,=20Sri=20Rasiah=20HRB=20247165=20(AG=20M=C3=BCnc=
hen)=0D=0A=0D=0A
