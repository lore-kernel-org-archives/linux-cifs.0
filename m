Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA87C433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3165261130
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDHILs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:11:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19071 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhDHILr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 04:11:47 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210408081134epoutp01938befc077fdbd01777b1564f959ce74~z07vKuKeH0153001530epoutp01B
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 08:11:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210408081134epoutp01938befc077fdbd01777b1564f959ce74~z07vKuKeH0153001530epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617869494;
        bh=9QSbWiPTGCBi8mMkBZUVJNwgPAhQQf6CwVk0dqkP6Fg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=amjwpnCV/H6U4MV/MQgTtCk+T1SlqCo3BItWLy6gDF8aP/xd8H+qG/aGD+9WfYy7u
         Ys/QbY7FIWKIaM16TliAtOwrqkWh2AhI4B7Q5+tDTfrOdy+XYexDBW5z9wcUjH0QAZ
         yA4rfG6SwV887aOkYhVh1B4z3epDnC/aYCb5gH7I=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210408081134epcas1p27daf8f35bac1619728acbf4d149c7e0b~z07us8TJi0720507205epcas1p2y;
        Thu,  8 Apr 2021 08:11:34 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.163]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FGDVr0Dbmz4x9Q8; Thu,  8 Apr
        2021 08:11:32 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.51.22618.3BABE606; Thu,  8 Apr 2021 17:11:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210408081128epcas1p18985126cd33057801f15c0ea4cf93d1f~z07pL_Qpe0096100961epcas1p16;
        Thu,  8 Apr 2021 08:11:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210408081128epsmtrp13f444bd1cc0b66c4e6e9680ef70cc4ef~z07pLIYqm3158931589epsmtrp14;
        Thu,  8 Apr 2021 08:11:28 +0000 (GMT)
X-AuditID: b6c32a38-e4dff7000001585a-00-606ebab316dc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.B3.08745.0BABE606; Thu,  8 Apr 2021 17:11:28 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210408081128epsmtip22fd3d6350f2899fe76cff60720958165~z07o_xE7_0258902589epsmtip2E;
        Thu,  8 Apr 2021 08:11:28 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Tian Tao'" <tiantao6@hisilicon.com>
Cc:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'Zhiqi Song'" <songzhiqi1@huawei.com>,
        <sergey.senozhatsky@gmail.com>, <sfrench@samba.org>,
        <hyc.lee@gmail.com>
In-Reply-To: <1617868656-34872-1-git-send-email-tiantao6@hisilicon.com>
Subject: RE: [PATCH] cifsd: remove unused including <linux/version.h>
Date:   Thu, 8 Apr 2021 17:11:28 +0900
Message-ID: <00f001d72c4e$c6a19b30$53e4d190$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHe7NapHd4AkSGH30olXVg1bFdsrAHD4XoiqoykRSA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmge7mXXkJBp8XsVpcu/+e3eLF/13M
        Fj//f2e0WPv5MbtFx8ujzBbLXi1gsVj9eh+7A7vHzll32T0ez93I7tFy5C2rx+4Fn5k85u7q
        Y/T4vEkugC0qxyYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
        LTMH6BYlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhQYFecWJucWleul5yfq6V
        oYGBkSlQZUJOxpS/f1gLXgpWvNu6mL2B8RxfFyMHh4SAicT0jzpdjFwcQgI7GCVed21ihHA+
        MUqcuvOMGcL5zChx48Q6oAwnRMe930wQiV2MEue3L2WHcF4ySuzfuYYFpIpNQFfi35/9bCC2
        iICmRN+2Q2BFzAIHGSVO7PgEluAUcJfY8/oVM4gtLOAq8X3HajCbRUBF4kjLSSYQm1fAUuJG
        5wooW1Di5MwnYAuYBeQltr+dwwxxkoLEz6fLWCGWWUl0zVzJCFEjIjG7sw2qZiGHxP+FkhC2
        i8T3t7eYIGxhiVfHt7BD2FISL/vb2CEBUy3xcT9UawejxIvvthC2scTN9RtYQUqYgf5av0sf
        IqwosfP3XKitfBLvvvawQkzhlehoE4IoUZXou3QYaqm0RFf7B/YJjEqzkPw1C8lfs5DcPwth
        2QJGllWMYqkFxbnpqcWGBSbIcb2JEZxMtSx2MM59+0HvECMTB+MhRgkOZiUR3h292QlCvCmJ
        lVWpRfnxRaU5qcWHGE2BIT2RWUo0OR+YzvNK4g1NjYyNjS1MzMzNTI2VxHmTDB7ECwmkJ5ak
        ZqemFqQWwfQxcXBKNTC1f2i79XTOiQu2WVYWId+2L2D29ft9JOjBF8UDCxZWGhSpG8m0TplU
        xZeu/Gzx49/bFuy87d30ICL6s+v35KIs5eWJ890bKupN31+dxHE6wH3vwUlXFO+f+t38+rXm
        UtXflh+1rm5yTJrinL3gXBtnwbKoeVxT11YcSAxXaD3FGL4kesZuCSmh3oaT/16nzFearOby
        9l7Op/Ob5xU8+6rccq2KPXkx35LA54Hmf77NVX/4VGJmk+7NHx/NJzLKi+ekBc3JPlT1/E7e
        MkGPjwe4/vySybPPyJinvvjP+SvZGgobHN/+05rx/V/TovQ7h/z/BvEHnP/wbLaW4SRf0WLb
        MwdaKxre3r4gJlszg7kyRomlOCPRUIu5qDgRAMlueocvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXnfDrrwEg5k/2C2u3X/PbvHi/y5m
        i5//vzNarP38mN2i4+VRZotlrxawWKx+vY/dgd1j56y77B6P525k92g58pbVY/eCz0wec3f1
        MXp83iQXwBbFZZOSmpNZllqkb5fAlTHl7x/WgpeCFe+2LmZvYDzH18XIySEhYCIx/d5vpi5G
        Lg4hgR2MEvs797BAJKQljp04w9zFyAFkC0scPlwMEhYSeM4o0b1TBMRmE9CV+PdnPxuILSKg
        KdG37RA7yBxmgeOMEm0XnjJCDJ3BKLFr0W1GkCpOAXeJPa9fMYPYwgKuEt93rAazWQRUJI60
        nGQCsXkFLCVudK6AsgUlTs58wgJyBLOAnkTbRrAxzALyEtvfzmGGuFNB4ufTZawQR1hJdM1c
        CVUjIjG7s415AqPwLCSTZiFMmoVk0iwkHQsYWVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl
        5+duYgRHlZbWDsY9qz7oHWJk4mA8xCjBwawkwrujNztBiDclsbIqtSg/vqg0J7X4EKM0B4uS
        OO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqaDHm8ii635ffz6E2MVZGxKlI//fB/EspA/N69E
        fa7AGm61/1NKTgVs8XWKn7HaaU11+Rrhibem9czSF77AtIlxddfO2hrnh/fDxfiyjtrLWNgy
        Zvf/W5avNDfDqumz3areY9b+D7Skyg/nLk4U5/njld5SI9B6m1u89YgHz8Ypey93hWksygg9
        G/Ghu+H7gyVMKk8bdRObH4vN7+2afiD0I1M4U4LBJNfGlXeUlFskeTbqGuRsKmJZarrxcXiL
        96/5+Z+ezrYpzHpyVeZS1PdJzeqp7+58fJIn9ZJv2s6p9Qd6V2WvkaiZovtsF3fWgt2XODXN
        c1hO/OeZxZtwstzM895zoR0sDPNDJULuKLEUZyQaajEXFScCAEqAzK4ZAwAA
X-CMS-MailID: 20210408081128epcas1p18985126cd33057801f15c0ea4cf93d1f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210408075720epcas1p256de791fecd957017c3ba9d848996ff1
References: <CGME20210408075720epcas1p256de791fecd957017c3ba9d848996ff1@epcas1p2.samsung.com>
        <1617868656-34872-1-git-send-email-tiantao6@hisilicon.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
There are still leftover of it...
./mgmt/user_session.c:#include <linux/version.h>
./mgmt/user_session.h:#include <linux/version.h>
./mgmt/tree_connect.c:#include <linux/version.h>

I will directly update your patch and apply it.
Thanks for your patch!

> ---
>  fs/cifsd/crypto_ctx.c | 1 -
>  fs/cifsd/glob.h       | 1 -
>  fs/cifsd/misc.c       | 1 -
>  fs/cifsd/vfs.c        | 1 -
>  fs/cifsd/vfs_cache.h  | 1 -
>  5 files changed, 5 deletions(-)
> 
> diff --git a/fs/cifsd/crypto_ctx.c b/fs/cifsd/crypto_ctx.c index 2c31e8b..8322b0f 100644
> --- a/fs/cifsd/crypto_ctx.c
> +++ b/fs/cifsd/crypto_ctx.c
> @@ -9,7 +9,6 @@
>  #include <linux/slab.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
> -#include <linux/version.h>
> 
>  #include "glob.h"
>  #include "crypto_ctx.h"
> diff --git a/fs/cifsd/glob.h b/fs/cifsd/glob.h index d0bc6ed..9d70093 100644
> --- a/fs/cifsd/glob.h
> +++ b/fs/cifsd/glob.h
> @@ -8,7 +8,6 @@
>  #define __KSMBD_GLOB_H
> 
>  #include <linux/ctype.h>
> -#include <linux/version.h>
> 
>  #include "unicode.h"
>  #include "vfs_cache.h"
> diff --git a/fs/cifsd/misc.c b/fs/cifsd/misc.c index b6f3f08..cbaaecf 100644
> --- a/fs/cifsd/misc.c
> +++ b/fs/cifsd/misc.c
> @@ -5,7 +5,6 @@
>   */
> 
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/xattr.h>
>  #include <linux/fs.h>
> 
> diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c index d388220..5985d2d 100644
> --- a/fs/cifsd/vfs.c
> +++ b/fs/cifsd/vfs.c
> @@ -9,7 +9,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/backing-dev.h>
>  #include <linux/writeback.h>
> -#include <linux/version.h>
>  #include <linux/xattr.h>
>  #include <linux/falloc.h>
>  #include <linux/genhd.h>
> diff --git a/fs/cifsd/vfs_cache.h b/fs/cifsd/vfs_cache.h index 318dcb1..8226fdf 100644
> --- a/fs/cifsd/vfs_cache.h
> +++ b/fs/cifsd/vfs_cache.h
> @@ -6,7 +6,6 @@
>  #ifndef __VFS_CACHE_H__
>  #define __VFS_CACHE_H__
> 
> -#include <linux/version.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/rwsem.h>
> --
> 2.7.4


