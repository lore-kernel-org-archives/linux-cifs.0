Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085EDC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 00:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC63F60200
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 00:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhEUA6K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 20:58:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55190 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbhEUA6J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 20:58:09 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210521005645epoutp020de1d5cfba2f545a9c2be60a5d410a76~A7vXfx5Wd1899718997epoutp02i
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 00:56:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210521005645epoutp020de1d5cfba2f545a9c2be60a5d410a76~A7vXfx5Wd1899718997epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621558605;
        bh=6+EF73nZKpxjg2jXQlhJUDzio0fjFzchH+3yXl2UX4U=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ZppVZ3AlYypDDuDVwUz3156C2bRXZXyFWRqUgt15Vjaj+z6NaU2irVhqNsr/5a91M
         Htk7wWj6VjhO8eOp3Z7ATV2BEFS8Z3VWoONW99laW881hEuGZgEkXLfa8ZHi0rYUqr
         dNXaFV+i8yyLgHINlJ98Uda9Ib8hbyrmkbemCIxo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210521005644epcas1p1c306a5a33917abbfa621a66fbe1e8b77~A7vWav2H00310203102epcas1p1U;
        Fri, 21 May 2021 00:56:44 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.162]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FmSqH0vY2z4x9Q0; Fri, 21 May
        2021 00:56:43 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.0C.09824.B4507A06; Fri, 21 May 2021 09:56:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210521005638epcas1p4a32942703c9f339310833e7fa70a5e64~A7vQ9kFMK1958519585epcas1p4V;
        Fri, 21 May 2021 00:56:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210521005638epsmtrp2944691d8872f205722a9184d67fd2d34~A7vQ82e2q0608406084epsmtrp2w;
        Fri, 21 May 2021 00:56:38 +0000 (GMT)
X-AuditID: b6c32a37-04bff70000002660-26-60a7054ae900
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.24.08163.64507A06; Fri, 21 May 2021 09:56:38 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210521005638epsmtip19f5aa5b73d076a8b97c04ad2e1003a06~A7vQzf-bH0266202662epsmtip1X;
        Fri, 21 May 2021 00:56:38 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Wei Yongjun'" <weiyongjun1@huawei.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>
Cc:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>,
        "'Hulk Robot'" <hulkci@huawei.com>
In-Reply-To: <20210520134211.1667806-1-weiyongjun1@huawei.com>
Subject: RE: [PATCH -next] cifsd: fix build error without
 CONFIG_OID_REGISTRY
Date:   Fri, 21 May 2021 09:56:38 +0900
Message-ID: <002501d74ddc$27b5d1d0$77217570$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHV31fRH7RXjboHKj6sXxuakebQ8QIutoLzqt6DLqA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmnq436/IEg/fLmC3+L7/CaHHt/nt2
        i623pC1e/N/FbPHz/3dGi7WfH7NbdLw8ymxx+MsuNgcOj52z7rJ7tBx5y+qxe8FnJo+5u/oY
        PT5vkgtgjcqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAE6RUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJMxc9IZ5oLlHBULXv1kbmB8xtbFyMkhIWAise5mG2MXIxeHkMAORomj94+xQzif
        GCUeNF9lhnA+M0q0PprE1MXIAdayfWsVRHwXo8Tft1tYIZwXjBLvZi1hAZnLJqAr8e/PfrAd
        IgKbGSXm/uQCsZkFpjBKXJgUAWJzCthJ/Jn/lxXEFhbwl1i7YhdYL4uAqsTKpxuZQGxeAUuJ
        izM+sEDYghInZz5hgZgjL7H97RxmiB8UJH4+XcYKsctKoufBWWaIGhGJ2Z1tYB9ICCzkkLh7
        tZcJosFFYsmsVdAAEJZ4dXwLO4QtJfH53V6oeLnEiZO/oOprJDbM28cO8b2xRM+LEhCTWUBT
        Yv0ufYgKRYmdv+cyQqzlk3j3tYcVoppXoqNNCKJEVaLv0mGogdISXe0f2CcwKs1C8tgsJI/N
        QvLALIRlCxhZVjGKpRYU56anFhsWGCPH9SZGcCrVMt/BOO3tB71DjEwcjIcYJTiYlUR4t3sv
        ThDiTUmsrEotyo8vKs1JLT7EaAoM6onMUqLJ+cBknlcSb2hqZGxsbGFiZm5maqwkzpvuXJ0g
        JJCeWJKanZpakFoE08fEwSnVwKR1eBXjlyl3nB9d2LVsfdjOGydPTXCYeLTQUOFvRtsU7cBF
        14o+NvBHVZV3PHk64fKGjT6zUzY9L9x2Zclihn8Z216ctC+K7Uw6ceWvVEaymmLkmp0uPLW7
        7k19IpJUpNX5zOZ39p6DIa/r2p7s/Ft7dnePgoVWw19v9yKh1JwnR/ZuN6jUrhRMu5Z/a/55
        q08vHy9Kn872QvPDlECpFW86bm+Yf0/A6510+szzuzbtVzB1ee2ydF5UjmLPJ3EGQ6sl6zK8
        dfYwf5/wjdf2R56Oytzl7yuXVNwRWFWdXVj2XK8qx+7FjuoNPxj3nhDjSJicmtKtELFtpv6j
        SctPFnRfXLRCQunD2//vnuavWBd0X4mlOCPRUIu5qDgRAM4TUZMuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJTteNdXmCwYbtShb/l19htLh2/z27
        xdZb0hYv/u9itvj5/zujxdrPj9ktOl4eZbY4/GUXmwOHx85Zd9k9Wo68ZfXYveAzk8fcXX2M
        Hp83yQWwRnHZpKTmZJalFunbJXBlzJx0hrlgOUfFglc/mRsYn7F1MXJwSAiYSGzfWtXFyMUh
        JLCDUWLJhKesXYycQHFpiWMnzjBD1AhLHD5cDFHzjFFi8vEHTCA1bAK6Ev/+7GcDsUUEtjJK
        NFzjBCliFpjBKHHj62VmiI5+RomXnWvAqjgF7CT+zP8LtkFYwFdi9uFOsEksAqoSK59uBLN5
        BSwlLs74wAJhC0qcnPkEzGYW0JNYv34OI4QtL7H97RxmiEsVJH4+XcYKcYWVRM+Ds8wQNSIS
        szvbmCcwCs9CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M
        4LjS0trBuGfVB71DjEwcjIcYJTiYlUR4t3svThDiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6Hr
        ZLyQQHpiSWp2ampBahFMlomDU6qB6fzzGWXJc4z23uJa2nc99unvs+tfyclamIvK1n/Uy/nP
        lXdEyeJIg8st3sWiOqcmh382XSaVfcWvdpWJu+7XE3MYlyyqLdJaEfIgS1rgYN7mhUv717yT
        3RC226CNUynNxuZtlrH41jff3DdGBh6sE+i9kSGi+0T0xpbYl1N+zX61bYvSBpEV/Ct33Xy5
        caOli8y1mweOb/oo4maxiGNvfa5v+NKmn8aBM/nm6abPC67wrTonkqS2d4u8+AOu3cd26W+d
        fy9b06Lm0NqZ979fPh1Y0XL4YE7bQrbpIUGizO2zt98IP6dVyWbApMk16/bhgNmaF3bN23BH
        dol5d3XYJwbhfF/Xq8fefFboiJjoZKnEUpyRaKjFXFScCADnh1z/GgMAAA==
X-CMS-MailID: 20210521005638epcas1p4a32942703c9f339310833e7fa70a5e64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210520133301epcas1p325b7d973e4febb2e9832051462585213
References: <CGME20210520133301epcas1p325b7d973e4febb2e9832051462585213@epcas1p3.samsung.com>
        <20210520134211.1667806-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Fix build error when CONFIG_OID_REGISTRY is not set:
> 
> mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `gssapi_this_mech':
> asn1.c:(.text+0xaa0): undefined reference to `sprint_oid'
> mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `neg_token_init_mech_type':
> asn1.c:(.text+0xbec): undefined reference to `sprint_oid'
> 
> Fixes: fad4161b5cd0 ("cifsd: decoding gss token using lib/asn1_decoder.c")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
I will apply it. Thanks for your patch!

Hyunchul, You also need to add this change to your cifs patch.

> ---
>  fs/cifsd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifsd/Kconfig b/fs/cifsd/Kconfig index 5316b1035fbe..e6448b04f46e 100644
> --- a/fs/cifsd/Kconfig
> +++ b/fs/cifsd/Kconfig
> @@ -18,6 +18,7 @@ config SMB_SERVER
>  	select CRYPTO_CCM
>  	select CRYPTO_GCM
>  	select ASN1
> +	select OID_REGISTRY
>  	default n
>  	help
>  	  Choose Y here if you want to allow SMB3 compliant clients


