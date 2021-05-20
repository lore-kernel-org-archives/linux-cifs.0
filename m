Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA681C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 01:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C602E611AD
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 01:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhETBpw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 May 2021 21:45:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15073 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhETBpw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 May 2021 21:45:52 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210520014429epoutp0216cb1d0567a12b1efd5dbd799dfed95f~AovwiuRwL0889308893epoutp02f
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 01:44:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210520014429epoutp0216cb1d0567a12b1efd5dbd799dfed95f~AovwiuRwL0889308893epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621475069;
        bh=38SJsWAoaV+iEIZJ6nqhbrE8AbGqgHRn+1Q5H8n7qrU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=YG9Sdofo0JfSqR0V7sqI5C8dU4FfPKxGk/bnUdkl+WxORIa7mnsOoNXO3kNhuvrgs
         Si8JQWEruK5ZppYsW3RRQdO+Gjoz2oNNqw3D5aH3Dv23dtPs4AwDhiXQWMCV2fjF6o
         Bg+XWX/L24mr2llCYFmRj4PnAJZNhURueepxxI5s=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210520014429epcas1p2e6739f31b8d389076741b89f112d34c9~AovwRwjZv0423504235epcas1p21;
        Thu, 20 May 2021 01:44:29 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.163]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Flswq49BRz4x9Q9; Thu, 20 May
        2021 01:44:27 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.59.09701.8FEB5A06; Thu, 20 May 2021 10:44:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210520014423epcas1p11c48e6aedd84b58c3a61f60328645783~AovrMB4Z81164611646epcas1p1Q;
        Thu, 20 May 2021 01:44:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210520014423epsmtrp2dc55ee5946fedd48495f257db3cedd34~AovrLX3dH2877028770epsmtrp2-;
        Thu, 20 May 2021 01:44:23 +0000 (GMT)
X-AuditID: b6c32a36-647ff700000025e5-1d-60a5bef84d03
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.7F.08637.7FEB5A06; Thu, 20 May 2021 10:44:23 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210520014423epsmtip1d6f6830dd8abbe60359ac79531c6877c~Aovq91UsE1731217312epsmtip1W;
        Thu, 20 May 2021 01:44:23 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'COMMON INTERNET FILE SYSTEM SERVER'" 
        <linux-cifsd-devel@lists.sourceforge.net>
In-Reply-To: <000001d74d19$6b525d00$41f71700$@samsung.com>
Subject: RE: ksmbd and reflink support - enables many more functional tests
Date:   Thu, 20 May 2021 10:44:23 +0900
Message-ID: <000801d74d19$a9133b50$fb39b1f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIdbNTfdPiyvIXNtY/noEWTb/ueXwEWKMiVAiV3KCGqRXw34A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmru6PfUsTDF7tN7B48X8Xs8XP/98Z
        Ld68OMzmwOyxc9Zddo/dCz4zeXzeJBfAHJVjk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
        a2hpYa6kkJeYm2qr5OIToOuWmQO0SEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJT
        YGhQoFecmFtcmpeul5yfa2VoYGBkClSZkJPx6MQt1oJLXBUvZ95ja2D8zN7FyMkhIWAi0XR4
        MXMXIxeHkMAORom5U/8wQTifGCW6P0xig3C+MUqsf3ETruXPlBZ2iMReRokZk99BVb1glHjy
        8SorSBWbgK7Evz/72UBsEQFNiTe7JzGD2MwCtRLzOo+B1XAKWEks3vMIrEZYwFvi+ZRzjF2M
        HBwsAqoSJ14EgoR5BSwljl7bxQphC0qcnPmEBWKMvMT2t3OYIQ5SkPj5dBkrxConiX3b1jJB
        1IhIzO5sA/tNQuAlu8SrzhlQDS4S/Vc6oL4Rlnh1fAuULSXx+d1eNgi7XOLEyV9MEHaNxIZ5
        +9hBbpMQMJboeVECYjIDvbV+lz5EhaLEzt9zGSHW8km8+9rDClHNK9HRJgRRoirRd+kw1EBp
        ia72D+wTGJVmIXlsFpLHZiF5YBbCsgWMLKsYxVILinPTU4sNC4yQ43oTIzgNapntYJz09oPe
        IUYmDsZDjBIczEoivNu9FycI8aYkVlalFuXHF5XmpBYfYjQFhvREZinR5HxgIs4riTc0NTI2
        NrYwMTM3MzVWEudNd65OEBJITyxJzU5NLUgtgulj4uCUamCq07+5R7V7IVPG8pZnuUslSk96
        PvvibNL91Mzy+uXiE/MfZOw2299w83vs4iyHSP95/y/u+yDtZevqIah81vK1msEh2xe3tNrz
        F/Zsyqi6L7ol6r/ihBXT7vBbq/n3tfzurZRfVsX8ZVqOqN3hXN/aL31MDzpvzH6/9Chr/rct
        rPusvq7+5GYR+eJIhsiFzd+yZlo7fHd4Xqq01f3at2mquo57EgyeHTnJfJ8tT7vlQWxOqfEU
        93+XZ/1ZYZnitNbkvpTYF81MGUHd0yJqL9hWT3fwf/uO7b/UqWPWrUbLVB7dZl25p1M4ZE7E
        7MfTXyqE2U+0Ssp/eWJ1e550eeDF+rdBU/6/W9KV+7vGQCRFiaU4I9FQi7moOBEA7kTA6AwE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO73fUsTDPae07V48X8Xs8XP/98Z
        Ld68OMzmwOyxc9Zddo/dCz4zeXzeJBfAHMVlk5Kak1mWWqRvl8CV8ejELdaCS1wVL2feY2tg
        /MzexcjJISFgIvFnSguQzcUhJLCbUeLx+7nMEAlpiWMnzgDZHEC2sMThw8UQNc8YJWZfvsAC
        UsMmoCvx789+NhBbREBT4s3uSWC9zAK1Es9WrocaeoFRovPADSaQBKeAlcTiPY/AGoQFvCWe
        TznHCLKARUBV4sSLQJAwr4ClxNFru1ghbEGJkzOfsEDM1JZ4evMplC0vsf3tHKg7FSR+Pl3G
        CnGDk8S+bWuZIGpEJGZ3tjFPYBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWGBYZ5qeV6
        xYm5xaV56XrJ+bmbGMERoaW5g3H7qg96hxiZOBgPMUpwMCuJ8G73XpwgxJuSWFmVWpQfX1Sa
        k1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5PfzIVn7xdPrmTeYvhtrveF/34v
        zjyau59Deee+vBtz3q63PRR7+pSfpucWT/8fTycvuqYhdGlT08UzecGN62eYJCeF9B77d1lh
        W6QBeyFn3J8n7x5Ur7qcqCrMHuwT+yHuWuMOrp+Lagsj90nq2p0S7/DR+nxw7Xb+HVb7PKYL
        HV3a/JhrGWskw/MlkZxNtc3Pc3X0dB7N1nB/+VLT+IJr+HmN3/d4FxX4uHF8Z9ojfiDXQWBq
        TbeN/DsXKdG3KX/Dg2Ymc8yL5nrZdlnx41nuq0bJ9b9edM1QNXnMbRQQmNWxLK68c3Lr4+2s
        oSuiDM6vX2sxyfeHSKKVyubGB2GGT0JZOL3ys1ZnlEsFCSuxFGckGmoxFxUnAgC72tqF9wIA
        AA==
X-CMS-MailID: 20210520014423epcas1p11c48e6aedd84b58c3a61f60328645783
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210519212114epcas1p1aa444144a84b4de9b2f465c24b411194
References: <CGME20210519212114epcas1p1aa444144a84b4de9b2f465c24b411194@epcas1p1.samsung.com>
        <CAH2r5mv-q=8b7L7r8_V66b2TXXKGFx95hRFFbEa1biCv-tzxDw@mail.gmail.com>
        <000001d74d19$6b525d00$41f71700$@samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,
> 
> Did a run of reflink dependent xfstests against ksmbd (from current 5.13-rc2 linux client) and see a
> very promising number (35+) of new tests that we should be able to enable.  See below:
Thanks for your check!
> 
> generic/110 0s ...  0s
> generic/111 0s ...  0s
> generic/115 0s ...  0s
> generic/116 0s ...  1s
> generic/118 0s ...  0s
> generic/119 1s ...  0s
> generic/134 1s ...  1s
> generic/138 0s ...  0s
> generic/139 1s ...  1s
> generic/140 0s ...  0s
> generic/142 1s ...  2s
> generic/143 2s ...  1s
> generic/144 1s ...  1s
> generic/146 1s ...  1s
> generic/148 1s ...  0s
> generic/149 0s ...  1s
> generic/150 1s ...  0s
> generic/151 0s ...  1s
> generic/152 1s ...  1s
> generic/153 0s ...  0s
> generic/154 1s ...  1s
> generic/155 0s ...  0s
> generic/161 1s ...  1s
> generic/164 8s ...  8s
> generic/165 9s ...  8s
> generic/166 6s ...  16s
> generic/167 5s ...  230s
> generic/168 46s ...  37s
> generic/170 44s ...  103s
> generic/175 7s
> generic/176 58s ...  50s
> generic/178 1s ...  0s
> generic/179 0s ...  1s
> generic/180 0s ...  0s
> 
> After test 180 (for tests 181, 183, 185 and following eg.) I got "could not connect to server" on all
> tests so ksmbd may have crashed at that point
Okay, I am trying to reproduce it.

Thanks!
> --
> Thanks,
> 
> Steve


