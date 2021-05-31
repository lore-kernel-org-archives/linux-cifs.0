Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D35C47092
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 01:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D6861279
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 01:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhEaBLY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 May 2021 21:11:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12207 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhEaBLX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 May 2021 21:11:23 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210531010943epoutp045306365c41278c1a95d24ac65c572852~EAXiox9sH0030600306epoutp04z
        for <linux-cifs@vger.kernel.org>; Mon, 31 May 2021 01:09:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210531010943epoutp045306365c41278c1a95d24ac65c572852~EAXiox9sH0030600306epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622423383;
        bh=ZHlIzYSnP+FGMZecnRoWpX3V+9LlqLF+cwgx+tF+jC0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=c5HqxGYcXeybyoWxuhKpphQ906XcdruKOon9RZUH/fnrUIPJzBYslmuhet1Tu+ka7
         w8S3MVn4tmgjVreFVKBO9JejAmkpzUMxTsUDigHYF9U5kXWf5izcfnnEFHkrDIbRdy
         xQPU6i/I87hJY1qsEw6+xCQIliixknrB1XfA6aLk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210531010942epcas1p1d7e6e319a03f13b4ba5fe567542f9633~EAXiKa2on2810828108epcas1p1d;
        Mon, 31 May 2021 01:09:42 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.163]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Ftcdc1krWz4x9QM; Mon, 31 May
        2021 01:09:40 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.E7.09736.45734B06; Mon, 31 May 2021 10:09:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210531010939epcas1p2db0593e0ded597125c4522131b5a9a2d~EAXfK7pKo2570525705epcas1p2_;
        Mon, 31 May 2021 01:09:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210531010939epsmtrp205f6dce7d85fa05513cbf6c69a721863~EAXfJ_Bsf2033320333epsmtrp2W;
        Mon, 31 May 2021 01:09:39 +0000 (GMT)
X-AuditID: b6c32a39-8d9ff70000002608-ba-60b437547270
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.0B.08163.35734B06; Mon, 31 May 2021 10:09:39 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210531010939epsmtip1aa80143f27a25be6a26eae33d87c0306~EAXe9CZhz2988229882epsmtip1o;
        Mon, 31 May 2021 01:09:39 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Yang Yingliang'" <yangyingliang@huawei.com>
Cc:     <sergey.senozhatsky@gmail.com>, <sfrench@samba.org>,
        <hyc.lee@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>
In-Reply-To: <20210529082058.3012233-2-yangyingliang@huawei.com>
Subject: RE: [PATCH -next 2/3] cifsd: fix memleak in ksmbd_vfs_stream_read()
Date:   Mon, 31 May 2021 10:09:39 +0900
Message-ID: <001101d755b9$a167e3d0$e437ab70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJmwAWLq8cPiJNp7RTaabO3wPgwFgJVm9ACAXqwfdypv3C4cA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmnm6I+ZYEg66jnBbX7r9nt3jxfxez
        xc//3xktLu+aw2ax9vNjdouOl0eZLbZ8usbkwO6xc9Zddo+WI29ZPXYv+MzkMXdXH6PH501y
        AaxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
        KZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQr0ihNzi0vz0vWS83OtDA0MjEyB
        KhNyMq49XsNe0MZUsez0H9YGxruMXYycHBICJhKdl6+wdTFycQgJ7GCU6N/3mx0kISTwiVFi
        5c9oiMRnRom/x/cywXS0nLrHDJHYxSix7McqJgjnBaPEtl+rWUCq2AR0Jf792c8GYosIGEqs
        nHCLEaSIWWAno8TOrZ1gRZwCDhKXn1wBs4UFfCSm/9jKCmKzCKhKHJnexQxi8wpYSjxZ85YV
        whaUODnzCVg9s4C8xPa3c5ghTlKQ+Pl0GSvEMieJqQd3sULUiEjM7mwDO1VCYC6HxMn1nVA/
        uEhsb5/JCmELS7w6voUdwpaS+PxuLxuEXS5x4uQvqPoaiQ3z9gHVcADZxhI9L0pATGYBTYn1
        u/QhKhQldv6eywixlk/i3dceVohqXomONiGIElWJvkuHoQZKS3S1f2CfwKg0C8ljs5A8NgvJ
        A7MQli1gZFnFKJZaUJybnlpsWGCKHNmbGMFJVMtyB+P0tx/0DjEycTAeYpTgYFYS4T1TsTFB
        iDclsbIqtSg/vqg0J7X4EKMpMKgnMkuJJucD03heSbyhqZGxsbGFiZm5mamxkjhvunN1gpBA
        emJJanZqakFqEUwfEwenVAMTe3ql9OyIqL7A/w91fn+982Juysasvbx/dvgI7A6++f+DXHux
        6/rWRMGk9dlqs+XuMqX271s0QWByTMIj1+2b58ZIs1dHukT03fE5MqPpnvOBdwXdDenh6RG7
        OM9tfzvL9wtnclRLRVyU5NZfTDYHAt9dKk/+8aklMDHm/Tompf1nuea/VFFZF91ozdC99nS1
        2flVU+Xe3t+aP0130u+l//nPrpyZcuAff2vFfePTZhP+pIhG9F5Zc74/jWv25bdXE38Y1b5Z
        2dl0w3VmVGXsrQfqIn25rw/NTD16wGVqzE3TnY+ClYLE7Jl274kQYn4goCUxTdPfgO+P6fpl
        BudP17CW/62yOV7trflU+beNEktxRqKhFnNRcSIAQitSFisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTjfYfEuCweYzWhbX7r9nt3jxfxez
        xc//3xktLu+aw2ax9vNjdouOl0eZLbZ8usbkwO6xc9Zddo+WI29ZPXYv+MzkMXdXH6PH501y
        AaxRXDYpqTmZZalF+nYJXBnXHq9hL2hjqlh2+g9rA+Ndxi5GTg4JAROJllP3mLsYuTiEBHYw
        Sqw50sECkZCWOHbiDFCCA8gWljh8uBii5hmjRO+5FUwgNWwCuhL//uxnA7FFBAwlVk64xQhS
        xCywn1FiwpnJLBAdRxklbu14A1bFKeAgcfnJFbANwgI+EtN/bGUFsVkEVCWOTO9iBrF5BSwl
        nqx5ywphC0qcnPmEBeQKZgE9ibaNYFczC8hLbH87hxniUAWJn0+XsUIc4SQx9eAuVogaEYnZ
        nW3MExiFZyGZNAth0iwkk2Yh6VjAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4
        mrS0djDuWfVB7xAjEwfjIUYJDmYlEd4zFRsThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZ
        LySQnliSmp2aWpBaBJNl4uCUamCae2XPb/aA6OmJMn4zNdedFOhr2ZgQd1wtL7WaYfo0jmuq
        ZTc+B0mcNK2+15J4Qs5s896T0q+EZyi9f/vFxHraJ6uJodomFxVT5cwntdWmGBhZl6Wen6Zz
        huOoWXjAA4Hn87RYL3D/fFcyXcFVOz65ZsuvnuVOWSeutxsbbRRbf7F9oeeN2o9hC5Jm3WV8
        q8sZYfuwunHRsy7O7+pWsav1hKcKZq+OsXdlPM8RHb58KWf/HlsjQZ/5bv1zbi6PuzB3k973
        mAOz0u/lZ054LZqmMdXSsPf1t0+p6nXPWjO3f1vldYrr08aJZyvcGwRzfNulfxRZ997/r7wz
        6uWhJX7TuWc9+8MbOvu+ZPxSnlIlluKMREMt5qLiRACCZkg1FQMAAA==
X-CMS-MailID: 20210531010939epcas1p2db0593e0ded597125c4522131b5a9a2d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210529081635epcas1p2396c9d5e2c1604e0c705c280b1d71497
References: <20210529082058.3012233-1-yangyingliang@huawei.com>
        <CGME20210529081635epcas1p2396c9d5e2c1604e0c705c280b1d71497@epcas1p2.samsung.com>
        <20210529082058.3012233-2-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Before ksmbd_vfs_stream_read() return, memory allocate in
> ksmbd_vfs_getcasexattr() need be freed.
> 
> Fixes: f44158485826 ("cifsd: add file operations")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
I will apply, Thanks for your patch!

