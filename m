Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3554C47082
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 05:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9057761208
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 05:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFGFpK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:45:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51504 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFGFpJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Jun 2021 01:45:09 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210607054316epoutp02ed45aa796143ac85225191b1ecae5c00~GNnYquGEx0365103651epoutp026
        for <linux-cifs@vger.kernel.org>; Mon,  7 Jun 2021 05:43:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210607054316epoutp02ed45aa796143ac85225191b1ecae5c00~GNnYquGEx0365103651epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623044596;
        bh=MoJyC+uuKbsYuYmo5748mB+SMcm0t68y/fvqVnsRbVI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=NqkhFd870Qgpp70kI2VWXVVR+kkTE2aW+yRYQfibwRqHr/AVAcY3TdQnuEVI3xaPU
         S8r5gz4hFV2n/GsGzTkPm8Lk0NiCnPy+so9r+l2CjY4O0LB5KGRSQ8o/zJq2ua96th
         sLZLexpFoyBMfZ8FSH76uXTNXxNgnKBwDo6+8aOo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210607054316epcas1p15426f5a6027fb0e8d0405345fb49aa5d~GNnYa2Eo92979529795epcas1p18;
        Mon,  7 Jun 2021 05:43:16 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.164]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fz2N323Fcz4x9Pw; Mon,  7 Jun
        2021 05:43:15 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.8D.09578.3F1BDB06; Mon,  7 Jun 2021 14:43:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210607054314epcas1p1ef3bd42647373eca219042744ab18d28~GNnWy3KE62979529795epcas1p11;
        Mon,  7 Jun 2021 05:43:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210607054314epsmtrp175f40551bc48ce1c7b4e8a5742da1be8~GNnWyJvdv1236512365epsmtrp1U;
        Mon,  7 Jun 2021 05:43:14 +0000 (GMT)
X-AuditID: b6c32a35-fb9ff7000000256a-5e-60bdb1f308b8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.50.08163.2F1BDB06; Mon,  7 Jun 2021 14:43:14 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210607054314epsmtip107d4f80888076d89716100939626ecf0~GNnWhYrDi3196431964epsmtip1V;
        Mon,  7 Jun 2021 05:43:14 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Wan Jiabing'" <wanjiabing@vivo.com>
Cc:     "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20210607045432.19359-1-wanjiabing@vivo.com>
Subject: RE: [PATCH] [-next] cifsd: remove duplicated argument
Date:   Mon, 7 Jun 2021 14:43:14 +0900
Message-ID: <006901d75b60$02696a90$073c3fb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKgw/UDu7t2X4eU8t0FLIkoC8uhyQDTq2rLqW6amcA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmge7njXsTDD6/4rK4dv89u8WL/7uY
        LX7+/85ocXnXHDaLtZ8fs1t0vDzKbNE89Q+LA7vHzll32T12L/jM5DF3Vx+jx+dNch4bPnUw
        B7BG5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
        pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIF
        qkzIybi0dDdrwRaminmbz7M0MP5j7GLk5JAQMJH4P+MNaxcjF4eQwA5GiYeHp0I5nxgllj1s
        ZYdwPjNKbNpxhx2m5fj0CywQiV2MEtMvLmUGSQgJvGCUmP1UEMRmE9CV+PdnPxuILSKgKbGm
        rZcZpIFZ4AujRMPhJ6wgCU4BS4m1k36BTRUWsJNY17sMzGYRUJGY2nGdBcTmBarZ13ufEcIW
        lDg58wlYnFlAXmL72znMEBcpSPx8uowVYpmVxJr7a5khakQkZne2gS2WEJjLIXHjw1WoBheJ
        yRdb2SBsYYlXx7dAvSYl8bK/Dcoulzhx8hcThF0jsWHePqA4B5BtLNHzogTEZAZ6bP0ufYgK
        RYmdv+cyQqzlk3j3tYcVoppXoqNNCKJEVaLv0mGogdISXe0f2CcwKs1C8tgsJI/NQvLALIRl
        CxhZVjGKpRYU56anFhsWGCJH9iZGcBLVMt3BOPHtB71DjEwcjIcYJTiYlUR4vWT2JAjxpiRW
        VqUW5ccXleakFh9iNAUG9URmKdHkfGAazyuJNzQ1MjY2tjAxMzczNVYS5013rk4QEkhPLEnN
        Tk0tSC2C6WPi4JRqYMo39DoVuPjyAuazf5vC016+f/HVL8Lm7bqnG9Yf6nl7tPGNDmOfZnZZ
        /t2uWWaMTG2O1R4P324Ke9t39Pb9Z1MWl9RFnYnPi02MiHT2PtPYdq364F0ZvTffj0S/Wnl6
        +e4cI88jlTNa/skz7bvf2bTV67TgpTtxT7UDP4icf1z7N/GNryQjn8DVfusHM6fVl7rOSaq8
        52TuIiD/vVjkpebSJ7/PzzwsIsqndCZz+a93J4skrvL8uOz6d/HXqS/tmuc82ysu+cRg3WEL
        nhX5rzoWfTj5bWbyCQ52DkFnywmNL25OvrXsvvMWDsE4ZZ3k3wJhc8+6B7O/kCtJaPI23mEg
        PfH0Nl/p2LW9j9aenR+ixFKckWioxVxUnAgAQgdR9SsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJTvfTxr0JBrsfa1lcu/+e3eLF/13M
        Fj//f2e0uLxrDpvF2s+P2S06Xh5ltmie+ofFgd1j56y77B67F3xm8pi7q4/R4/MmOY8NnzqY
        A1ijuGxSUnMyy1KL9O0SuDIuLd3NWrCFqWLe5vMsDYz/GLsYOTkkBEwkjk+/wNLFyMUhJLCD
        UeLEkzZWiIS0xLETZ5i7GDmAbGGJw4eLQcJCAs8YJea+ZgKx2QR0Jf792c8GYosIaEqsaetl
        BpnDLPCDUWLJnmPMEEO7GCWWHT4NVsUpYCmxdtIvdhBbWMBOYl3vMjCbRUBFYmrHdRYQmxeo
        Zl/vfUYIW1Di5MwnLCBHMAvoSbRtBAszC8hLbH87hxniTgWJn0+XsUIcYSWx5v5aZogaEYnZ
        nW3MExiFZyGZNAth0iwkk2Yh6VjAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4
        lrS0djDuWfVB7xAjEwfjIUYJDmYlEV4vmT0JQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2M
        FxJITyxJzU5NLUgtgskycXBKNTBZ/Ql3OZzDtLyMYW/wk6IeyXdHtuhX2LFP2SgSOcXxkaP6
        vcVLv88IjHBaaXfQ77xd5XIpDo5N8zfdrvE9mquw/SdT9HTB7G37Pn93vVvsca5jrVMN69Nr
        n75rrTwbGMkUFfWm4fkjZ9lmI6G1Em6s89k51r0Qv/Uk9/KDA7qNyx95/fzow3v/sta1OZHr
        IqT3Wiy0azwu1Lvcs5rBKnVmttTZXAZb8WjGjHrHgLA1049EXJ/Rm3WFP2Npvt+vGe8+J3NI
        nlnw+IBeybvgg6J+TBkdS76oNfYz1P7/03l2sq2i7mO+sgW79838rPBsX+C2zsN/J+xv3Lti
        0t2vzXUy7i2zysWUdzasry1495xBiaU4I9FQi7moOBEAU72CmxQDAAA=
X-CMS-MailID: 20210607054314epcas1p1ef3bd42647373eca219042744ab18d28
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607045501epcas1p169d50fec8f89cc86b83a4672be75098f
References: <CGME20210607045501epcas1p169d50fec8f89cc86b83a4672be75098f@epcas1p1.samsung.com>
        <20210607045432.19359-1-wanjiabing@vivo.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Fix the following coccicheck warning:
> ./fs/cifsd/smb2pdu.c:1713:27-41: duplicated argument to & or |
> 
> FILE_DELETE_LE is duplicated. Remove one and reorder argument to make coding style reasonable.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
I will apply it, Thanks for your patch!

