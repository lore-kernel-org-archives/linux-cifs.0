Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1FFC47092
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 01:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6756F61278
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 01:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhEaBK4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 May 2021 21:10:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58376 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhEaBKz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 May 2021 21:10:55 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210531010915epoutp023ac81a926552459a2d333b0c4c38d369~EAXIKyBCU2430224302epoutp02z
        for <linux-cifs@vger.kernel.org>; Mon, 31 May 2021 01:09:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210531010915epoutp023ac81a926552459a2d333b0c4c38d369~EAXIKyBCU2430224302epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622423355;
        bh=564Sd01tVo5cveiCmJa5+UV0p3NF2/OhL+Hln/gw1oU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=hmoS5BNKcCJNJ+G6qaczMyXQuVLr6xmKeGwUFx0LUpGtsdmaPZ6Ubu8zj2TjMyoRc
         tqhcQTvotV5XOKgL3tuyXT3MvburaF9plaSYX1X9EFHnEkUnFHlkFS5dTvnQm0spI5
         UZIFrigpGtYVylLRQQFX7dD3rS3VsU90oWXBieTE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210531010914epcas1p1874f3a1bdab08b43432cbd426f54b3e0~EAXH1XhQr2242322423epcas1p1w;
        Mon, 31 May 2021 01:09:14 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.166]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ftcd500NWz4x9QB; Mon, 31 May
        2021 01:09:13 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.3B.09824.73734B06; Mon, 31 May 2021 10:09:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210531010910epcas1p33002ec0dba10896e6d63178a08eab385~EAXEVH1UM3235632356epcas1p3R;
        Mon, 31 May 2021 01:09:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210531010910epsmtrp26bf6bec867517521de820fe00a36da9f~EAXEUal8e2033320333epsmtrp2h;
        Mon, 31 May 2021 01:09:10 +0000 (GMT)
X-AuditID: b6c32a37-04bff70000002660-e3-60b43737267d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.AC.08637.63734B06; Mon, 31 May 2021 10:09:10 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210531010910epsmtip1b5e985d2ae77a07792a185db8a6a209d~EAXEDFk8L2990229902epsmtip1S;
        Mon, 31 May 2021 01:09:10 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Yang Yingliang'" <yangyingliang@huawei.com>
Cc:     <sergey.senozhatsky@gmail.com>, <sfrench@samba.org>,
        <hyc.lee@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>
In-Reply-To: <20210529082058.3012233-1-yangyingliang@huawei.com>
Subject: RE: [PATCH -next 1/3] cifsd: fix memleak in
 ksmbd_vfs_stream_write()
Date:   Mon, 31 May 2021 10:09:10 +0900
Message-ID: <001001d755b9$90306380$b0912a80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHGFJ2WtWYoeA5H1K6a0pImPZRtFQJmwAWLqwwTmjA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmrq65+ZYEg9N3xS2u3X/PbvHi/y5m
        i5//vzNaXN41h81i7efH7BYdL48yW2z5dI3Jgd1j56y77B4tR96yeuxe8JnJY+6uPkaPz5vk
        AlijcmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
        UihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhToFSfmFpfmpesl5+daGRoYGJkC
        VSbkZEz9/o25oIWp4tznDtYGxpuMXYwcHBICJhI92xO7GLk4hAR2MEosbHjBDOF8YpR4dGwZ
        E4TzjVFi2fwvQBlOsI4nG/cwgthCAnsZJRbN0YQoesEo8en2OxaQBJuArsS/P/vZQGwRAUOJ
        lRNuMYIUMQvsZJTYubUTrIhTwEHi7LIbYJOEBfwlZt3tZwWxWQRUJbq2TwPbxitgKXHl6CQm
        CFtQ4uTMJ2C9zALyEtvfzoG6SEHi59NlrBDLrCSO/7vPDFEjIjG7sw3sHwmBuRwS/683skA0
        uEjM+d/NCmELS7w6voUdwpaS+PxuLxuEXS5x4uQvJgi7RmLDvH3skAAzluh5UQJiMgtoSqzf
        pQ9RoSix8/dcRoi1fBLvvvawQlTzSnS0CUGUqEr0XToMNVBaoqv9A/sERqVZSB6bheSxWUge
        mIWwbAEjyypGsdSC4tz01GLDAmPkuN7ECE6hWuY7GKe9/aB3iJGJg/EQowQHs5II75mKjQlC
        vCmJlVWpRfnxRaU5qcWHGE2BQT2RWUo0OR+YxPNK4g1NjYyNjS1MzMzNTI2VxHnTnasThATS
        E0tSs1NTC1KLYPqYODilGphEaxerPxSX8Xe8HMCeEc18VXhHzPSvvL9uPG1Qdans8Lj1e6qH
        xCPrKbc0t6mknftSuiP0d96MWT2rtIWf33gR9TJKTG7XDftb3ontvr9n1K9unSHQzht1l32i
        +IUtP/J2Mucal081ur4iKJx/kVTzB9GrEdudi54aH+iIz2i7f2Sm7I2bAd/2Chj/WxEnIvvy
        ykv+fI9TFtOY1TXF+K4kc86emuE7gWNXX9UdjlM876dttvnLX2UXxvDoEdP0a7xbr+gFWyZq
        2mxpy9WYc595Dde/hnmvD7WwrwjrfXbSJFkqQFpDP+qUaUKNQGawx25HiaWTrxw6N2PPLeP6
        zaudXjJMX//ukOrP645PpGSVWIozEg21mIuKEwGK976MKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJTtfMfEuCwYKnhhbX7r9nt3jxfxez
        xc//3xktLu+aw2ax9vNjdouOl0eZLbZ8usbkwO6xc9Zddo+WI29ZPXYv+MzkMXdXH6PH501y
        AaxRXDYpqTmZZalF+nYJXBlTv39jLmhhqjj3uYO1gfEmYxcjJ4eEgInEk417gGwuDiGB3YwS
        f/dNZ4JISEscO3GGuYuRA8gWljh8uBgkLCTwjFGiZRk/iM0moCvx789+NhBbRMBQYuWEW2Bz
        mAX2M0pMODOZBWLoREaJTX0dzCBVnAIOEmeX3QDbLCzgK3Fs8VUWEJtFQFWia/s0sBpeAUuJ
        K0cnMUHYghInZz5hATmCWUBPom0jWCuzgLzE9rdzmCHuVJD4+XQZK8QRVhLH/91nhqgRkZjd
        2cY8gVF4FpJJsxAmzUIyaRaSjgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJj
        SUtzB+P2VR/0DjEycTAeYpTgYFYS4T1TsTFBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPx
        QgLpiSWp2ampBalFMFkmDk6pBqaaaWF2E8xWFSYq/+9ePL/b+zXPomxj5ftvmEs3ugRskcjb
        fWjC2n2dbeukje/WyS3/X1e0Qd1uV4pP9bfpfEsXVxTvz1nFuuMVQ+nNcz8nlL4K5LLICZb7
        phmod6ld8g/HHoblidfWKzNd8ztm8+BNQ7Vj6+KNB3g+JbosMrjN4CVTsu/UAuH9Wyx3CS4q
        Ppcyd8bSIqcfmYkhb7s8J664+nQpI/9LXfGi1WvyHbx/aEon5IV8dZp4ecd9Uz4JuT07hDzm
        1Pg1st6/W309333qpaQ17l8kbx6+l6T+Z2+75OekrBcmq+uzMq1S7VUMtd9bqM6p/xg5weHx
        UhtLsbyj4narVog5Sh1eylx1vVuJpTgj0VCLuag4EQBIHMrgFAMAAA==
X-CMS-MailID: 20210531010910epcas1p33002ec0dba10896e6d63178a08eab385
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210529081635epcas1p130adfff1e044c7749f059e413ad4e8b8
References: <CGME20210529081635epcas1p130adfff1e044c7749f059e413ad4e8b8@epcas1p1.samsung.com>
        <20210529082058.3012233-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Before assigning wbuf to stream_buf, memory allocate in
> ksmbd_vfs_getcasexattr() need be freed.
> 
> Fixes: f44158485826 ("cifsd: add file operations")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
I will apply, Thanks for your patch!

