Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D06C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB215207A0
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLOChB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:37:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45845 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgLOCg6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 21:36:58 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201215022842epoutp040615d7033cc45e58755cca2edff2559a~Qwt1cwQkK2367423674epoutp044
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 02:28:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201215022842epoutp040615d7033cc45e58755cca2edff2559a~Qwt1cwQkK2367423674epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607999323;
        bh=C6cMqNj7gzMKd12i3GOKnHnQ2pKaXHaTzApbDP/ONXk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=u4OO+75ubIwRJOL/k7UvUs0dJAF7TLGA5T7TI1wDzu8tcG8hEMkoR3b6hsP204HPN
         Th+N/S6Z2tbLC1QmnaIgCcnLy1AH0uqrTK8m5t7AMZk+E9qJ9OrVyxMCQ3cS4Nx4qu
         CbMYFFlgcUndkq/YeKTDsu2mnZ/L4WgdrSbP5bMU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201215022842epcas1p2c4b5881c9a13ff0ac05a0007906a3f9a~Qwt1DdIag0881508815epcas1p2n;
        Tue, 15 Dec 2020 02:28:42 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Cw2Hs4XW6z4x9Q8; Tue, 15 Dec
        2020 02:28:41 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.60.63458.95F18DF5; Tue, 15 Dec 2020 11:28:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201215022841epcas1p10b4dde15676ae066b1cca67478099be6~Qwtzx8WO71167011670epcas1p1i;
        Tue, 15 Dec 2020 02:28:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201215022841epsmtrp1cd32d1ed81bfe27cca40e3d6e7bc2214~QwtzxTfzf2597025970epsmtrp1K;
        Tue, 15 Dec 2020 02:28:41 +0000 (GMT)
X-AuditID: b6c32a36-6dfff7000000f7e2-29-5fd81f598957
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.D0.13470.85F18DF5; Tue, 15 Dec 2020 11:28:40 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201215022840epsmtip21125d7195390123501ae3fd890860fe7~QwtzgoMZY2807028070epsmtip2N;
        Tue, 15 Dec 2020 02:28:40 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Stefan Metzmacher'" <metze@samba.org>
Cc:     "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'samba-technical'" <samba-technical@lists.samba.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>,
        "'Steve French'" <smfrench@gmail.com>
In-Reply-To: <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
Subject: RE: updated ksmbd (cifsd)
Date:   Tue, 15 Dec 2020 11:28:41 +0900
Message-ID: <003a01d6d28a$00989dd0$01c9d970$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDtjnMiCa1AcmvYMj1ELhOClJiQLwG3FqLJAxs+MEaro0rx4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTVzdS/ka8wf69yhbX7r9nt3jxfxez
        xcVlP1ks/izZz26x9vNjdos3Lw6zObB57Jx1l91j/uxZTB5zd/UxenzeJBfAEpVjk5GamJJa
        pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
        rKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2VoYGBkClSZkJPx9Pt6poL/
        AhV7t01lamB8ydvFyMkhIWAise5bK3sXIxeHkMAORonr13uYQBJCAp8YJbb944NIfGOUePHv
        LitMx9zGv1BFexklHi9Shih6ySjx9vgyNpAEm4CuxL8/+8FsEQFtiUOv7oCtYBZ4xSjRvv8L
        I0iCU8BWonvdR7CpwgJKEg8vz2AGsVkEVCUm/vkJ1swrYCmxcd1mKFtQ4uTMJywgNrOAvMT2
        t3OYIS5SkPj5dBkrxDIniafNl5ggakQkZne2MYMslhBo5ZBo2n+NCaLBRWLVJZCLQGxhiVfH
        t0DZUhIv+9uAbA4gu1ri436o+R1A73+3hbCNJW6u38AKUsIsoCmxfpc+RFhRYufvuYwQa/kk
        3n3tYYWYwivR0SYEUaIq0XfpMNQB0hJd7R/YJzAqzULy2Cwkj81C8sAshGULGFlWMYqlFhTn
        pqcWGxYYIcf1JkZwutQy28E46e0HvUOMTByMhxglOJiVRHh7S6/HC/GmJFZWpRblxxeV5qQW
        H2I0BQb1RGYp0eR8YMLOK4k3NDUyNja2MDEzNzM1VhLn/aPdES8kkJ5YkpqdmlqQWgTTx8TB
        KdXAVMG+898bBpWKwO/nruseWLmjyDR5ruL5wJSFBktEIow9TQtFvvf+LHgfKLajocz4kHiX
        kr2jvOuSGAZGmR9uvH57tga+6Gp6avZHKG3ZlVMpulN/3t1syGeladbF/E+nweSOve2D1kW1
        7w6fY/ZZN1lkF+fjtrtd6xbVO9i7aKtECjgxn1awPzn/ncKdbLaloinTV8d9zk895NbtWMOe
        31x6/PsjKY3oyfv5rh9V/yUismTuCy2VhU8+WjDe1S41Wst/c9muvVF5Hn16l52vvGXTva7V
        ubO+t5ifxau+RWnq+7hNz84IzOFje1ufeNw9/ShzsJS73L6Ea1F+K+fUJX1K9X7klnFY4XOB
        QJMSS3FGoqEWc1FxIgBVnLfXIAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvG6k/I14g5k+Ftfuv2e3ePF/F7PF
        xWU/WSz+LNnPbrH282N2izcvDrM5sHnsnHWX3WP+7FlMHnN39TF6fN4kF8ASxWWTkpqTWZZa
        pG+XwJXx9Pt6poL/AhV7t01lamB8ydvFyMkhIWAiMbfxL1MXIxeHkMBuRokTs48zQySkJY6d
        OANkcwDZwhKHDxeDhIUEnjNKLHtdBGKzCehK/Puznw3EFhHQljj06g47yBxmgTeMErs3vGGF
        aLjMKPH6jyWIzSlgK9G97iNYXFhASeLh5Rlgu1gEVCUm/vkJNohXwFJi47rNULagxMmZT1hA
        bGagBb0PWxkhbHmJ7W/nQN2pIPHz6TJWiCOcJJ42X2KCqBGRmN3ZxjyBUXgWklGzkIyahWTU
        LCQtCxhZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeNluYOxu2rPugdYmTiYDzE
        KMHBrCTC21t6PV6INyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYO
        TqkGpos/Lx89muNuwCSVf1rTQOWkRivHpYMpCR6KXoWK2yTWG7kLft4v4sVosLhxv/J3Z+2m
        z8dEH115PaP9v12s2Of7vG93TE1kjzBU13zbfnUSh7DuJZ9o/Rbj4H99LeFtPjdX5AQbFv91
        3d2xold80x2B5Uun+xkwKMeatjRt39rBsurr01sdlw74e7h9vcMwV6DkZF1inMzZ65da4n8Z
        3T9cwcx/lOnktRzvO6t3uR7/0zZtHW978Xz/yxV8og9/ruZ+o35TroRx73vdR7uf3vzwf9us
        5sUrc2wX5H568PXgIyb35yvrvNh+3F/vcE2xRDpuZe+D/Y/sXzEZ3lGdlOOf78LTYRG7+9Zl
        cXu2e0osxRmJhlrMRcWJANp/CJAKAwAA
X-CMS-MailID: 20201215022841epcas1p10b4dde15676ae066b1cca67478099be6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
        <CGME20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2@epcas1p1.samsung.com>
        <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

 
> I just looked briefly, but I'm wondering about a few things:
> 
> 1. The xattr's to store additional meta data are not compatible with
>    Samba's way of storing things:
>     https://git.samba.org/?p=samba.git;a=blob;f=librpc/idl/xattr.idl
> 
>    In order to make it possible to use the same filesystem with both servers
>    it would be great if the well established way used in Samba would be used
>    as well.
Yes, Maybe... I will check it after sending ksmbd to linux-next.
 
> 2. Why does smb2_set_info_sec() have fp->saccess |= FILE_SHARE_DELETE_LE; ?
Because of smb2.acls.GENERIC failure.

TESTING FILE GENERIC BITS
get the original sd
Testing generic bits 0x00000000
time: 2020-12-15 00:00:37.940992
failure: GENERIC [
(../../source4/torture/smb2/acls.c:439) Incorrect status NT_STATUS_SHARING_VIOLATION - should be NT_STATUS_OK

I really don't understand this test. This testcase expect that FILE_DELETE is set in response if desired access
of smb2 open is FILE_MAXIMAL_ACCESS.
I don't know why smb2 open should be allowed although FILE_SHARE_DELETE is not set in previous open in this test.
Can you give me a hint ?

> 3. Why does ksmbd_override_fsids() only reset cred->fs[g|u]id, but group_info
>    is kept unchanged, I guess at least the groups array should be set to be empty.
Yes, We need to handle the groups list. Will fix it.

> 4. What is work->saved_cred_level used for in ksmbd_override_fsids()?
>    It seems to be unused and adds a lot of complexity.
ksmbd_override_fsids could be called recursively.
work->saved_cred_level prevents ksmbd from overriding fs[g|u]id again.
 
> 5. Documentation/filesystems/cifsd.rst and fs/cifsd/Kconfig still references https://github.com/cifsd-team/cifsd-tools
>   instead of https://github.com/cifsd-team/ksmbd-tools
Okay. Will update it.

> 6. Why is SMB_SERVER_CHECK_CAP_NET_ADMIN an compile time option and why is it off by default?
>    I think the behavior should be enforced without a switch.
I can make it default yes. Can you explain more why it should be enforced ?

> These are just some initial thoughts.
Thanks for sharing your review!
> 
> metze


