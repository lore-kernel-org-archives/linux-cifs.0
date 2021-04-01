Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C07C433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 09:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB51F61004
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 09:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhDAJSn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 05:18:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56303 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbhDAJSV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 05:18:21 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210401091819epoutp02d43b4dd45b37e0a3cc40da9cc0f980ca~xsVBMdCmz2106721067epoutp02F
        for <linux-cifs@vger.kernel.org>; Thu,  1 Apr 2021 09:18:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210401091819epoutp02d43b4dd45b37e0a3cc40da9cc0f980ca~xsVBMdCmz2106721067epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617268699;
        bh=b9IPwcKsm2C3n9PXMZFOeCKKX6wHbwjJy1ULphl8cio=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ULBVfcaY5Kgerrg1kzft3A/w4oqVquMI+em5/MzgSZ6EUCB8v4jONcA6S6lndW4Yj
         uVswPSV+hjdJcNleaSBlgegWdsIPETx5psckrT+z+mWkJ/e/1Zd9pFcQbFdfsOlx2T
         3SZFrqbJW0dfd0fYentCZiXT4InRMus8tRRLW22w=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210401091819epcas1p4a9a9f94d65f6b73a019fab675ef99f2f~xsVA0Nwbv0415804158epcas1p4V;
        Thu,  1 Apr 2021 09:18:19 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4F9yK56pP8z4x9Q9; Thu,  1 Apr
        2021 09:18:17 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.B9.02277.9DF85606; Thu,  1 Apr 2021 18:18:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210401091817epcas1p4d4afc08a87993ff719a16be8647d60f3~xsU-M1gPs0415804158epcas1p4E;
        Thu,  1 Apr 2021 09:18:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210401091817epsmtrp2396429f28f1f3843ab5b2ac0cbb5524c~xsU-L8vgX2156921569epsmtrp2f;
        Thu,  1 Apr 2021 09:18:17 +0000 (GMT)
X-AuditID: b6c32a36-4edff700000108e5-9d-60658fd9838d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.C8.08745.9DF85606; Thu,  1 Apr 2021 18:18:17 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210401091817epsmtip290bcb67977fd68ca8c281437dd894131~xsU_9mdDz3106231062epsmtip2a;
        Thu,  1 Apr 2021 09:18:17 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Muhammad Usama Anjum'" <musamaanjum@gmail.com>
Cc:     "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>,
        "'open list:COMMON INTERNET FILE SYSTEM SERVER \(CIFSD\)'" 
        <linux-cifs@vger.kernel.org>,
        "'open list:COMMON INTERNET FILE SYSTEM SERVER \(CIFSD\)'" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <colin.king@canonical.com>,
        <dan.carpenter@oracle.com>
In-Reply-To: <20210401090850.GA2779473@LEGION>
Subject: RE: [PATCH] cifsd: use kfree to free memory allocated by kmalloc or
 kzalloc
Date:   Thu, 1 Apr 2021 18:18:17 +0900
Message-ID: <004601d726d7$f3798310$da6c8930$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHE1YfbJKWSfn21hU+sU4uf/CNVewIuWIugqrKR2PA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmru7N/tQEg1OLTS1+r+5ls3j9bzqL
        xbX779kttt6Stnjxfxezxc//3xktLu+aw2axt3Ubo8Xaz4/ZLTpeHmV24PKY1dDL5rFz1l12
        j90LPjN5fHx6i8Vj7q4+Ro/Pm+QC2KJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
        LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBga
        FOgVJ+YWl+al6yXn51oZGhgYmQJVJuRk/Nv+kKXgAFPF7sutzA2MrUxdjJwcEgImEpe2NrCB
        2EICOxglnl6KhLA/MUrMXxLQxcgFZH9mlNg6ZzsLTMPsc61sEIldjBK/1uxih+h4ySix4oMJ
        iM0moCvx789+sKkiQA3H73QxgTQwC9xklpjaexRsEqeAnsTFv+8ZQWxhgTCJxxe6mUFsFgEV
        ia6mPlYQm1fAUmL6rG1QtqDEyZlPwHqZBeQltr+dwwxxkYLEz6fLWCGWWUnsXT0fqkZEYnZn
        GzPIYgmBHRwSm7vOQf3sIrFxzQYoW1ji1fEt7BC2lMTnd3uBruYAsqslPu6Hmt/BKPHiuy2E
        bSxxc/0GVpASZgFNifW79CHCihI7f89lhFjLJ/Huaw8rxBReiY42IYgSVYm+S4ehlkpLdLV/
        YJ/AqDQLyWOzkDw2C8kDsxCWLWBkWcUollpQnJueWmxYYIQc1ZsYwWlWy2wH46S3H/QOMTJx
        MB5ilOBgVhLhFT6QmCDEm5JYWZValB9fVJqTWnyI0RQY1BOZpUST84GJPq8k3tDUyNjY2MLE
        zNzM1FhJnDfR4EG8kEB6YklqdmpqQWoRTB8TB6dUA5Plkyfi88pOsAkEu3xe897e1HRp4Rdh
        udUr8g/vulz/XoH/eYN1qOnqTW/W/tsZ8/h8TfWtZ8sO9QQHfE8teXo47HTy6e45MdUnfkQ9
        djlmzZHv4rZxkpQJp0vw/E9etQ5e1zbv2sedWMeWd2qxe77I7Funfe3vPHO9ysjjN+tr754j
        MYxiYf9+KF+Z+HrJfDH5NnGh/RsmXVq4xPj/5Ds7T28R+XCG588cg7w0fjMm/pVynFbbNy5e
        fO/QPsXt3x4qle28bc+7/Kvb/9NrtCISSq5ECs1WzVpi+kHzo1ppmZPKls8zL/26nRLQLfKv
        XTpD/ve7+29fips2P2x3+iox0W5Hh7B/4e6rLTPf9da8UGIpzkg01GIuKk4EANk2ALY8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO7N/tQEg+lPRC1+r+5ls3j9bzqL
        xbX779kttt6Stnjxfxezxc//3xktLu+aw2axt3Ubo8Xaz4/ZLTpeHmV24PKY1dDL5rFz1l12
        j90LPjN5fHx6i8Vj7q4+Ro/Pm+QC2KK4bFJSczLLUov07RK4Mv5tf8hScICpYvflVuYGxlam
        LkZODgkBE4nZ51rZuhi5OIQEdjBKLPt1ghkiIS1x7MQZIJsDyBaWOHy4GKLmOaPErYYdbCA1
        bAK6Ev/+7AezRYAGHb/TxQRSxCxwl1niycIFLCAJIYF6ibOz94AN5RTQk7j49z0jyFBhgRCJ
        yUudQcIsAioSXU19rCA2r4ClxPRZ26BsQYmTM5+wgJQzA7W2bWQECTMLyEtsfzsH6kwFiZ9P
        l7FCnGAlsXf1fBaIGhGJ2Z1tzBMYhWchmTQLYdIsJJNmIelYwMiyilEytaA4Nz232LDAKC+1
        XK84Mbe4NC9dLzk/dxMjON60tHYw7ln1Qe8QIxMH4yFGCQ5mJRFe4QOJCUK8KYmVValF+fFF
        pTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwLbC7nBPcW7SZ8fsMZb7wu+UZ
        M/o2+orvWSfn3rNsJtPftZe+LWS2edUcHDA//WDjr7ZzX1d7vuF5w3JSSfyo1F+Z/3ZhUU3K
        joolDZXP2y8cmFfz5ccFjmV7l+Xx54jFP485ETFNR6tD3WN3694XW3efPL5S9nLqMaVVXsqn
        r72KWzBdV3pH7NyzRosf2kefeeR9c/Ovr/Fm6tfUsvT9+pkPS3SXTv96/Mb5b++7e3tnaHTr
        9fLN6rw61eOl/6pbX2uvBzzVjrm15U3qg/VTOaZm/dabFWfcyTK9dnlh+KldUT8POE6W+GM2
        Mz6RtS93lmRIVknT/ayNnueLW5hrn552jpGSsvw9Yer9GYs2aSuxFGckGmoxFxUnAgC4xBiT
        JgMAAA==
X-CMS-MailID: 20210401091817epcas1p4d4afc08a87993ff719a16be8647d60f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210401090901epcas1p49be3384fda4e000a6e9f40af63833f3a
References: <CGME20210401090901epcas1p49be3384fda4e000a6e9f40af63833f3a@epcas1p4.samsung.com>
        <20210401090850.GA2779473@LEGION>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> 
> kfree should be used to free memory allocated by kmalloc or kzalloc to avoid any overhead and for
> maintaining consistency.
> 
> Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
Looks good. I will apply. Thanks for your patch!

