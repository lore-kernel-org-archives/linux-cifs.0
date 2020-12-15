Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284E0C2BB9A
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052CB207D8
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgLOC3x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:29:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34403 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgLOC3r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 21:29:47 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201215022903epoutp03b181dfb031f2abf6164553c7f37b31fd~QwuItShzN0702207022epoutp03R
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 02:29:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201215022903epoutp03b181dfb031f2abf6164553c7f37b31fd~QwuItShzN0702207022epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607999343;
        bh=skR/Qw2vVXW43PtNfvgOG+lsDO70LbpjjpQF3CxZK4A=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Eph1UMz5Kz1sElOOpnNGwRXtbQ0mpgztVwkrry2x9cd1dByssfsOKCt6iBrzv3tKX
         pSxBB0Aqm+GZJNmsS/ohHkJIca5i6Czq1fmN9/4rylNXad/S5l5RQNul8K1NKvfPrw
         vvaKcVwFnUktUNGpjGjt7K2RPwe1DfySjCCLW68M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201215022903epcas1p38b3bce90b33ebcb2be699d0a6f8c9929~QwuIWlCjK0252402524epcas1p3x;
        Tue, 15 Dec 2020 02:29:03 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.166]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Cw2JG18hKz4x9QB; Tue, 15 Dec
        2020 02:29:02 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.54.09577.E6F18DF5; Tue, 15 Dec 2020 11:29:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201215022901epcas1p2ee0986ba0904d6ed250a51f8503ab143~QwuGjR7Ua2038320383epcas1p2a;
        Tue, 15 Dec 2020 02:29:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201215022901epsmtrp178580bb63cdcc826e18ee9b95881c44f~QwuGiktuL2597025970epsmtrp1w;
        Tue, 15 Dec 2020 02:29:01 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-7a-5fd81f6e9904
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.D0.13470.D6F18DF5; Tue, 15 Dec 2020 11:29:01 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201215022901epsmtip2a85b7752cb1f9f24e93665d3630129be~QwuGZHtcz2948929489epsmtip2L;
        Tue, 15 Dec 2020 02:29:01 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Jeremy Allison'" <jra@samba.org>,
        "'Stefan Metzmacher'" <metze@samba.org>
Cc:     "'Steve French'" <smfrench@gmail.com>,
        "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'samba-technical'" <samba-technical@lists.samba.org>
In-Reply-To: <20201214184820.GB56567@jeremy-acer>
Subject: RE: updated ksmbd (cifsd)
Date:   Tue, 15 Dec 2020 11:29:01 +0900
Message-ID: <003b01d6d28a$0caa3750$25fea5f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDtjnMiCa1AcmvYMj1ELhOClJiQLwMbPjBGAcAX0rICKWbi6KuRyyDg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTTzdP/ka8wbYJbBZnl1xjt3jxfxez
        xcVlP1ks/izZz27x5sVhNgdWj52z7rJ7zJ89i8lj7q4+Ro/Pm+QCWKJybDJSE1NSixRS85Lz
        UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07WyK
        8ktLUhUy8otLbJVSC1JyCgwNCvSKE3OLS/PS9ZLzc60MDQyMTIEqE3IyFn1bx1jwgadi6s0Z
        jA2Mt7i6GDk5JARMJO4/m8PaxcjFISSwg1FixdYJUM4nRokNB7YyQjjfGCVONbxm6WLkAGuZ
        96YKIr6XUeL56QaoopeMErN/3GMBmcsmoCvx789+NhBbRCBQYt2Kf8wgRcwC3YwSV3v7wYo4
        BQwlmp4+YAKxhQWUJB5ensEMYrMIqEq0/jkEFucVsJQ4MOMYI4QtKHFy5hOwXmYBeYntb+cw
        QzyhIPHz6TJWiGVuEp9ubmaCqBGRmN3ZBrZYQqCVQ+L+3VOsEA0uEk0v+1ggbGGJV8e3sEPY
        UhIv+9vYId6slvi4H2p+B6PEi++2ELaxxM31G1hBSpgFNCXW79KHCCtK7Pw9lxFiLZ/Eu689
        rBBTeCU62oQgSlQl+i4dZoKwpSW62j+wT2BUmoXksVlIHpuF5IFZCMsWMLKsYhRLLSjOTU8t
        NiwwRY7sTYzgNKlluYNx+tsPeocYmTgYDzFKcDArifD2ll6PF+JNSaysSi3Kjy8qzUktPsRo
        CgzqicxSosn5wESdVxJvaGpkbGxsYWJmbmZqrCTO+0e7I15IID2xJDU7NbUgtQimj4mDU6qB
        yc/5B0/Rybq1rYcCzq6K29CbPV3X6+7OqdFPDi5e/rf82TNZNbHLayYGXVs0f9rUsyEzT9S4
        Pe67+zB42te5ybY3SqLPno88tP4k9zfD47NijDZuOJosPy0i87HwBkn/WUXHjKz5LjV/Uynt
        djHccVlavLLwolrO/61fLjx57ek4zz9qyteYltv7P03VsDLTnGOto9m05sP3v9cW5ho9zBXg
        et75TTmnbcHxBWqb5Q5vvWZcfPmFNldJSmDKG+bXrm9KwqMU/jC+LFtzn3fyHC0lIxkGY94d
        WioTHtsmbK7KvBQikthj+fjwm+mnfKacWbbprZ+MhtmiWMetMlJiKQt0l0jN1T3wxlf/48KT
        P+2UWIozEg21mIuKEwEPpJRlHAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvG6u/I14g1vb+C3OLrnGbvHi/y5m
        i4vLfrJY/Fmyn93izYvDbA6sHjtn3WX3mD97FpPH3F19jB6fN8kFsERx2aSk5mSWpRbp2yVw
        ZSz6to6x4ANPxdSbMxgbGG9xdTFycEgImEjMe1PVxcjFISSwm1Gi51ILcxcjJ1BcWuLYiTPM
        EDXCEocPF0PUPGeUaLnynAWkhk1AV+Lfn/1sILaIQKDE7rVPGEGKmAW6GSVe3XgEViQk8INR
        4tfdPBCbU8BQounpAyYQW1hASeLh5Rlgy1gEVCVa/xwCi/MKWEocmHGMEcIWlDg58wkLyBHM
        AnoSbRvBwswC8hLb386BulNB4ufTZawQN7hJfLq5mQmiRkRidmcb8wRG4VlIJs1CmDQLyaRZ
        SDoWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjhUtzR2M21d90DvEyMTBeIhR
        goNZSYS3t/R6vBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTByc
        Ug1McworN7912pDU5vRu/ua/73z7Th1bW+Iittsh7TRD6Ze+uY/ny/cqLu1MY7u5ou1MU7EZ
        4/V/K9Qaox07Pc84lV5Tn/j6Vt8S2Ztxop8iTmfoKAY8PDFx0f/Ti6rFq3fP+1215v8C8fvz
        f/de2122KtiNn4/t5RvHxjKL3e18pswCe7s0DSeyHV9jf1/0ZvfS4oV7Js9umXhXZ6vvWk3p
        Nw+8Dnh6Osm9trx0yXRWXUygu3eBkpf65QWmky7W68j2GKhuvc6bUGm34mPR/+0MYivMMx6+
        ClthOV15f8uO3AVf1bve3Cmb7S6xsMPztvK/4Dlb1E4mel2YMnVGe9ezBA/zCQzXIv+cevru
        VMbFH0osxRmJhlrMRcWJAOjd45oEAwAA
X-CMS-MailID: 20201215022901epcas1p2ee0986ba0904d6ed250a51f8503ab143
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201214184832epcas1p2095ebcc51c22fd003316c0e2334b9e1b
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
        <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
        <CGME20201214184832epcas1p2095ebcc51c22fd003316c0e2334b9e1b@epcas1p2.samsung.com>
        <20201214184820.GB56567@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


> On Mon, Dec 14, 2020 at 06:45:51PM +0100, Stefan Metzmacher via samba-technical wrote:
> >Am 14.12.20 um 02:20 schrieb Steve French via samba-technical:
> >> I just rebased https://protect2.fireeye.com/v1/url?k=e100f21c-be9bcb17-e1017953-002590f5b904-
> f00629b46b3afee4&q=1&e=6fc8b980-0fd2-4e4d-a9dc-
> 9ea15e482833&u=https%3A%2F%2Fgithub.com%2Fsmfrench%2Fsmb3-kernel%2Ftree%2Fcifsd-for-next
> >> ontop of 5.10 kernel. Let me know if you see any problems.   xfstest
> >> results (and recent improvements) running Linux cifs.ko->ksmbd look
> >> very promising.
> >
> >I just looked briefly, but I'm wondering about a few things:
> >
> >1. The xattr's to store additional meta data are not compatible with
> >   Samba's way of storing things:
> >
> >https://protect2.fireeye.com/v1/url?k=fbb13e03-a42a0708-fbb0b54c-002590
> >f5b904-f4288e37b0eb9ae8&q=1&e=6fc8b980-0fd2-4e4d-a9dc-9ea15e482833&u=ht
> >tps%3A%2F%2Fgit.samba.org%2F%3Fp%3Dsamba.git%3Ba%3Dblob%3Bf%3Dlibrpc%2F
> >idl%2Fxattr.idl
> >
> >   In order to make it possible to use the same filesystem with both servers
> >   it would be great if the well established way used in Samba would be used
> >   as well.
> 
> A thousand times this ! If cifs.ko->ksmbd adds a differnt way of storing the extra meta-data that is
> incompatible with Samba this would be a disaster for users.
> 
> Please fix this before proposing any merge.
You said that samba can handle it even if ksmbd has own extra metadata format. I didn't think it was
necessary to what you said. If we have to do this, I think it is not too late to work after sending
ksmbd to linux-next first.

