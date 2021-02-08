Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88A4C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 07:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881E164E76
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 07:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBHH30 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Feb 2021 02:29:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61288 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBHH3Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Feb 2021 02:29:25 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210208072842epoutp01c44a95f311813cb34cf1c6a7fdec7c81~htSd2bkYz0934809348epoutp01j
        for <linux-cifs@vger.kernel.org>; Mon,  8 Feb 2021 07:28:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210208072842epoutp01c44a95f311813cb34cf1c6a7fdec7c81~htSd2bkYz0934809348epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612769322;
        bh=MP46nDGAqWLFcidnx9lnN21j7YDuNPr08szG3smj5gY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=h/qCxqxiwfFCZ1f/b3ZEhXa+pboglBuPxM3kIw/d8xyHdf/TQft6BaChdfEH93n1+
         2dFhApizdFfO64K1Dj17ME0d55R7mQFDwZV0N90dMCR7hLg2x5PVxUJZDB8Me3Ro3z
         bXTYWrXbNclBgH8mA8eABcl+U8eYZKaye0SnAtnM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210208072842epcas1p4c3a9662aeb7c1f6945d9d7c9324236f9~htSdZSa062262122621epcas1p4H;
        Mon,  8 Feb 2021 07:28:42 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.165]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DYyLc6Qdkz4x9Pr; Mon,  8 Feb
        2021 07:28:40 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.00.09582.628E0206; Mon,  8 Feb 2021 16:28:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210208072838epcas1p4263cd7632a6e6f01535ba92fb623d298~htSZhNh_-0911209112epcas1p4Y;
        Mon,  8 Feb 2021 07:28:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210208072838epsmtrp2c9361e21fdaa253d755873c6ca39c4de~htSZghXlr1935219352epsmtrp2F;
        Mon,  8 Feb 2021 07:28:38 +0000 (GMT)
X-AuditID: b6c32a37-8afff7000000256e-59-6020e82647c0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.E2.08745.528E0206; Mon,  8 Feb 2021 16:28:37 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210208072837epsmtip19346371cc9434d5f64ef521b2255cc47~htSZVYT8r2363123631epsmtip1N;
        Mon,  8 Feb 2021 07:28:37 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     "'Stefan Metzmacher'" <metze@samba.org>,
        "'Samba Technical'" <samba-technical@lists.samba.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'Namjae Jeon'" <linkinjeon@kernel.org>,
        "'CIFS'" <linux-cifs@vger.kernel.org>
In-Reply-To: <CAH2r5mtmmei0q9kemkjL-QyDfeiNNYCidAuqX=WN0PncoqiokA@mail.gmail.com>
Subject: RE: [Linux-cifsd-devel] [PATCH] cifsd: make xattr format of ksmbd
 compatible with samba's one
Date:   Mon, 8 Feb 2021 16:28:37 +0900
Message-ID: <017501d6fdec$04418400$0cc48c00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGl6IhnSLG/1SsUO9NpARHPFZxSUgHLNQ68Ax7baU4BuzjdCwG11peXAcHI8CgBpXVnkKpR8o9w
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmga7aC4UEg3urJS0mTlvKbPHi/y5m
        i5//vzNaXFz2k8Xiz5L97BZvXhxmc2Dz2DnrLrvHplWdbB7zZ89i8ti94DOTx9xdfYwenzfJ
        BbBF5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
        pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIF
        qkzIyZi5vIex4IB4xdaDIg2MXwW7GDk4JARMJBae9+ti5OIQEtjBKPFk7WdGCOcTo0TP5AYo
        5zOjRPuUeUAOJ1jH3e/voRK7GCX+L9jEDOG8ZJSYsPshK0gVm4CuxL8/+9lAbBEBTYk3uyeB
        FTELPGaUePHuHtgoToFAiT3728CKhAUyJD5OX8wCYrMIqEh87j/EDGLzClhKbPt/iQnCFpQ4
        OfMJWA2zgLzE9rdzmCFOUpD4+XQZK8SyKIkTu3rZIWpEJGZ3tkHVzOSQmH0iCMJ2kZjz9TMr
        hC0s8er4FnYIW0ri87u9bJCAqZb4uB+qtQPo5u+2ELaxxM31G1hBSpiB/lq/Sx8irCix8/dc
        RoitfBLvvvawQkzhlehoE4IoUZXou3SYCcKWluhq/8A+gVFpFpK/ZiH5axaS+2chLFvAyLKK
        USy1oDg3PbXYsMAYOao3MYITqJb5DsZpbz/oHWJk4mA8xCjBwawkwhvYKZcgxJuSWFmVWpQf
        X1Sak1p8iNEUGNITmaVEk/OBKTyvJN7Q1MjY2NjCxMzczNRYSZw3yeBBvJBAemJJanZqakFq
        EUwfEwenVAPTnabmRq24SW/OyGZ+u+GXOknzf0bGlbMTTGTPJT/ir+T2Xe1R0VrFdpM/omHT
        h2UhM4I6ndTz924yY5/bsm3K60m35jcWx13U9t8vpiGq8qXxxyuDdkGOTqt5Fw80t716f+N0
        WtY8W8/IfB8PUwv93i5zi3/8N+1YZF2rWzfObrzGaDv30LzI9Uc/2lkZH/G12z7h/pyTV3o0
        G+MPM8R9dqpgFn5UMmH69IAnKQ8mfmjqeLZ0wgTdqlOeWoq7W6ve5PUc05CNnn8nUlfGMCvj
        cMjqSOtTzr8NFE9wbbdkuMZw822SfurN+bu/ro6Y4MD3YumKREfNvVKfOwqF2ngSPRh+XhPU
        d1TXEMvsY1JiKc5INNRiLipOBACoMIX4KQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTlf1hUKCwdv5FhYTpy1ltnjxfxez
        xc//3xktLi77yWLxZ8l+dos3Lw6zObB57Jx1l91j06pONo/5s2cxeexe8JnJY+6uPkaPz5vk
        AtiiuGxSUnMyy1KL9O0SuDJmLu9hLDggXrH1oEgD41fBLkZODgkBE4m7398zdjFycQgJ7GCU
        2DdvBStEQlri2IkzzF2MHEC2sMThw8UQNc8ZJa5+ew5WwyagK/Hvz342EFtEQFPize5JzCBF
        zAJPGSWm7N3MAtGxh1miowMkw8nBKRAosWd/G1iHsECaxIWu42CTWARUJD73HwKr4RWwlNj2
        /xIThC0ocXLmExYQm1lAW6L3YSsjhC0vsf3tHGaISxUkfj5dxgpxRZTEiV297BA1IhKzO9uY
        JzAKz0IyahaSUbOQjJqFpGUBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgeNLS
        2sG4Z9UHvUOMTByMhxglOJiVRHgDO+UShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQ
        nliSmp2aWpBaBJNl4uCUamDq+SAww3f6EbVLWVz71wU/dLzMFGfPr2U/+4dN5vV1W1a9aXyb
        ethWyebF12e70rl7j0a+SdxhsNxoidsGvo4tshs1gsVNNzsKs7Tn12U904rbukazZG7cmk/h
        X/hOlbBPk3T7fdSqKvDx7U7LV8lHHeQO373/5En2sirbs4buX4Pyl81M1ls2uZ1zofSt2n/i
        MWLfE5Lku+dGrOORKvDblWU6/dU+ts3P5jxTLu2dFLjuhKXQhfiHS8U03QVZk23zPsmUW/53
        UnIPMDzx+aLsddusVxzTjZjTnUtbvh5jTG9S1+p6tDD98PKpiSXxQYerNhz5HxS7gatp1skH
        dpkbMtZn/HrV8rhZebpcnoUSS3FGoqEWc1FxIgD4osNwFgMAAA==
X-CMS-MailID: 20210208072838epcas1p4263cd7632a6e6f01535ba92fb623d298
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210126023109epcas1p257c4128a9d8673cb44f81dca636da39a
References: <CGME20210126023109epcas1p257c4128a9d8673cb44f81dca636da39a@epcas1p2.samsung.com>
        <20210126022335.27311-1-namjae.jeon@samsung.com>
        <09887b1a-3303-9ac6-1d29-c53951be5324@samba.org>
        <CAKYAXd-rfk26A4SOeqvhMkBV2FcvpE0goj415HX7T4fBim1zQA@mail.gmail.com>
        <CAH2r5mutwPP570YbwxDWikwM6e+gdD7m2iwMJ5xNEcvqpkVrNg@mail.gmail.com>
        <000101d6f833$d9c38ba0$8d4aa2e0$@samsung.com>
        <CAH2r5mtmmei0q9kemkjL-QyDfeiNNYCidAuqX=WN0PncoqiokA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> I have rebased cifsd-for-next on 5.11-rc7
Okay.

> 
> Will kick off some buildbot tests with it this week - it is looking good so far, but let me know of
> other PRs coming soon
I have just sent a PR. Please check it.
And I will test on rebased #cifsd-for-next. If you find any issue, Let me know it.

Thanks!
> 
> On Sun, Jan 31, 2021 at 6:47 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
> >
> > > FYI - I have rebased the cifsd-for-next branch onto 5.11-rc6
> > Let me check it!
> >
> > Thanks!
> > >
> > > https://protect2.fireeye.com/v1/url?k=776f3edf-28f407c5-776eb590-0cc
> > > 47a6cba04-
> > > 039abc8d8963817e&q=1&e=3337a309-5806-4005-8f00-
> > > b7312c0621f1&u=https%3A%2F%2Fgithub.com%2Fsmfrench%2Fsmb3-kernel.git
> > >
> > > On Tue, Jan 26, 2021 at 4:46 PM Namjae Jeon via samba-technical
> > > <samba-technical@lists.samba.org>
> > > wrote:
> > > >
> > > > 2021-01-26 23:36 GMT+09:00, Stefan Metzmacher via samba-technical
> > > > <samba-technical@lists.samba.org>:
> > > > > Hi Namjae,
> > > > Hi Metze,
> > > > >
> > > > >> Samba team request that ksmbd should make xattr format of ksmbd
> > > > >> compatible with samba's one. When user replace samba with ksmbd
> > > > >> or replace ksmbd with samba, The written attribute and ACLs of
> > > > >> xattr in file should be used on both server. This patch work
> > > > >> the following ones.
> > > > >>  1. make xattr prefix compaible.
> > > > >>     - rename creation.time and file.attribute to DOSATTRIB.
> > > > >>     - rename stream. to DosStream.
> > > > >>     - rename sd. to NTACL.
> > > > >>  2. use same dos attribute and ntacl structure compaible with samba.
> > > > >>  3. create read/write encoding of ndr functions in ndr.c to store ndr
> > > > >>     encoded metadata to xattr.
> > > > >
> > > > > Thanks a lot!
> > > > >
> > > > > Do you also have this a git commit in some repository?
> > > > Yes, You can check github.com/cifsd-team/cifsd
> > > > tree(https://protect2.fireeye.com/v1/url?k=abb45e79-f42f6763-abb5d
> > > > 536-0cc47a6cba04-
> > > 4d12d0be7dd14e1f&q=1&e=3337a309-5806-4005-8f00-b7312c0621f1&u=https%
> > > 3A%2F%2Fgithub.com%2Fcifsd-
> > > team%2Fcifsd%2Fcommit%2F0dc106786d40457e276f50412ecc67f11422dd1e).
> > > > And there is a cifsd-for-next branch in
> > > > github.com/smfrench/smb3-kernel for upstream.
> > > > I have made a patch for that git tree, but I haven't fully tested it yet...
> > > > I'm planning to send a pull request to Steve this week after doing it.
> > > > >
> > > > > I played with ksmbd a bit in the last days.
> > > > Cool.
> > > > >
> > > > > I can also test this commit and check if the resulting data is
> > > > > compatible with samba.
> > > > Great!  Let me know your opinion if there is something wrong:)
> > > > Thank you so much for your help!
> > > > >
> > > > > metze
> > > > >
> > > > >
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> 
> 
> --
> Thanks,
> 
> Steve

