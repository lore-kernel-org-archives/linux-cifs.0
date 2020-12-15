Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5570C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D07207A0
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 02:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgLOCg4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:36:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:38563 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgLOCgy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 21:36:54 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201215022809epoutp03c41b5d5e2df55e893ff8fff83cfac1f4~QwtV7ofsR0675506755epoutp037
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 02:28:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201215022809epoutp03c41b5d5e2df55e893ff8fff83cfac1f4~QwtV7ofsR0675506755epoutp037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607999289;
        bh=SGu2L9Ty4Jx4keki1YpkjdBh5K+q36VaU3Ijy9igl+c=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=H5Lw+wioaBYs5Dj6P23u6EiNEMw0ceBgsDVsG72G/ywGwYTsAkirGBQpKYeghmXiu
         F7gDnRfQhAcwZqye4eACgMhY//93iBf3iY7JLk1LKZKcFDB1DFsd4bjDZAnlZg+/Cv
         FdlOr2/ehkThxxr4nRY6cwcpSjn+sRfs3H7iov+I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201215022808epcas1p2eddf603daef93e9e2158e8c43e9a19ba~QwtVuSWbi3157231572epcas1p2E;
        Tue, 15 Dec 2020 02:28:08 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.162]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Cw2HC6QHQzMqYkY; Tue, 15 Dec
        2020 02:28:07 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.30.63458.73F18DF5; Tue, 15 Dec 2020 11:28:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20201215022807epcas1p312cb80f3437bdfd8f01606097e941bd6~QwtUPxgVW1015710157epcas1p3I;
        Tue, 15 Dec 2020 02:28:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201215022807epsmtrp224aa38a25582fb956271fdc8c3612139~QwtUPSCrG2612226122epsmtrp2g;
        Tue, 15 Dec 2020 02:28:07 +0000 (GMT)
X-AuditID: b6c32a36-6dfff7000000f7e2-48-5fd81f371495
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.C0.13470.73F18DF5; Tue, 15 Dec 2020 11:28:07 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201215022807epsmtip133c80062b9d3c4ea45bd7b3455249a78~QwtUEz4jP1254212542epsmtip1d;
        Tue, 15 Dec 2020 02:28:07 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'samba-technical'" <samba-technical@lists.samba.org>,
        "'Namjae Jeon'" <linkinjeon@kernel.org>
In-Reply-To: <CAKYAXd-qTqLF3M1S0xbpu-C0w1E=vS4HRFa_ou0xXnGJaFKuWg@mail.gmail.com>
Subject: RE: updated ksmbd (cifsd)
Date:   Tue, 15 Dec 2020 11:28:07 +0900
Message-ID: <003901d6d289$ec771cf0$c56556d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDtjnMiCa1AcmvYMj1ELhOClJiQLwKF7csoAmVajgeromj5IA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdlhTX9dc/ka8wbZ7BhYTpy1ltnjxfxez
        xZ8l+9kt3rw4zObA4rFz1l12j02rOtk85s+exeTxeZNcAEtUjk1GamJKapFCal5yfkpmXrqt
        kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvp1NUX5pSapC
        Rn5xia1SakFKToGhQYFecWJucWleul5yfq6VoYGBkSlQZUJOxs+X+xkLWnUqWvYsZG5gbFLp
        YuTkkBAwkVi89zZTFyMXh5DADkaJty/mskI4nxglbl9cCOV8Y5R4N28TK0zLy8uX2CESexkl
        ds07BOW8ZJR4P/c6WBWbgK7Evz/72UBsEQFNiTe7JzGDFDELdDNK3J+6hAkkwSkQKLF9RRsz
        iC0soCTx8PIMMJtFQFXi3pEZYM28ApYSzTfXsUDYghInZz4Bs5kFtCWWLXzNDHGSgsTPp8tY
        IZY5SaxZcZoVokZEYnZnG9hiCYGf7BL3DsxnhGhwkZjz7QU7hC0s8er4FihbSuLzu71AizmA
        7GqJj/uh5ncwSrz4bgthG0vcXL+BFaSEGeix9bv0IcKKEjt/z2WEWMsn8e5rDyvEFF6JjjYh
        iBJVib5Lh5kgbGmJrvYP7BMYlWYheWwWksdmIXlgFsKyBYwsqxjFUguKc9NTiw0LjJBjexMj
        OD1qme1gnPT2g94hRiYOxkOMEhzMSiK8vaXX44V4UxIrq1KL8uOLSnNSiw8xmgKDeiKzlGhy
        PjBB55XEG5oaGRsbW5iYmZuZGiuJ8/7R7ogXEkhPLEnNTk0tSC2C6WPi4JRqYKoqYfmbYLzz
        sc/rC8e3FlvLXrE/r8918L69xftJP9Y/fj3dIPrynAfTH3qfYhLuDrh/TvmHyFqlqzvDpBjV
        JpjWvopvDdP0rGmZNU9OybYw27F3930f7vaLK57Yaj29sfCMUkn0iQntMV+OH8ytT5+jldRt
        MmNu8I2K86Iaq8piYteGBv/qUS0+ZXHnqvK/EMaMu0m2KsE/hR2s5Z+tjzHIj9foDhZ4N6vI
        J6VCT272k5drQoo6HXc5bl27+e6cp2ckvRb/+n83z9RHgoPJYy7LxIy8uIXHImOeO++P87Ws
        9z0bzs6yRu7jvPNqvvF53M/WRU2rKkx6bc39MXqx+VZ5vSm2HiEbDJj3vTjnqcRSnJFoqMVc
        VJwIAAmoaJ4YBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSnK65/I14gy3b+CwmTlvKbPHi/y5m
        iz9L9rNbvHlxmM2BxWPnrLvsHptWdbJ5zJ89i8nj8ya5AJYoLpuU1JzMstQifbsErowNr36w
        FPToVDRdWsvWwNis0sXIySEhYCLx8vIl9i5GLg4hgd2MErOmNLFDJKQljp04w9zFyAFkC0sc
        PlwMEhYSeM4oceNiEIjNJqAr8e/PfjYQW0RAU+LN7knMIHOYBXoZJe4e+8YK17CxIQLE5hQI
        lNi+oo0ZxBYWUJJ4eHkGmM0ioCpx78gMsEG8ApYSzTfXsUDYghInZz4Bs5kFtCV6H7YywtjL
        Fr5mhrhTQeLn02WsEEc4SaxZcZoVokZEYnZnG/MERuFZSEbNQjJqFpJRs5C0LGBkWcUomVpQ
        nJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERwlWpo7GLev+qB3iJGJg/EQowQHs5IIb2/p9Xgh
        3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamDycJedXLG58
        u1lxwsKT0/8dZP377b1uXt3JXy3/Jm857FMYcV5k2a+jlznLa97XH2O+55f0ji2/1udhxM4J
        X0KqUi/uLXtyvUblo+PhU06Plf9y31Tzir7yurhzkQlTqzL7ojsJy55cWivUxn7tq91C13uT
        3B91CD47fPIc5/FLB3nFpWzu1HHJf1/9+1tCdNgpi+ankzJkjuhm7D3bz2eb4O0pb++Up5F8
        /ncK/7IJCuF5K3mPHRI4ZDIrf37TXU6ZK+KbNp3h6984/UfFjIdpX/wFdnlzqjs2rHCXZNHV
        WF+zYu8PifvLn3VaTFiyvfGG8vfte+s/HH1/cJ2tedTqzZP6DD/LVIYnfnf6ZcCgxFKckWio
        xVxUnAgAYMKgCgEDAAA=
X-CMS-MailID: 20201215022807epcas1p312cb80f3437bdfd8f01606097e941bd6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201214124704epcas1p3a5e4349522b58764ba9ca79bdf1da3fd
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
        <CGME20201214124704epcas1p3a5e4349522b58764ba9ca79bdf1da3fd@epcas1p3.samsung.com>
        <CAKYAXd-qTqLF3M1S0xbpu-C0w1E=vS4HRFa_ou0xXnGJaFKuWg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


> > I just rebased https://github.com/smfrench/smb3-kernel/tree/cifsd-for-n=
ext
> > ontop of 5.10 kernel. Let me know if you see any problems.   xfstest
> > results (and recent improvements) running Linux cifs.ko->ksmbd look
> > very promising.
> With the help of Ronnie, I fixed one problem in previous patch. I have se=
nt
> a pull request for this patch. And I have also checked number of 118 test=
s of
> xfstests were passed on rebased smb3-kernel(+ the patch in pull request).

I share the xfstests's result of 5.10 kernel+ksmbd(cifsd).
---------------------->8------------------
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 linkinjeon-Samsung-DeskTop-System 5.10.0+ =23=
1 SMP Mon Dec 14 10:55:27 KST 2020
MKFS_OPTIONS  -- //10.88.103.87/homes
MOUNT_OPTIONS -- -ousername=3Dlinkinjeon,password=3D1234,noperm,vers=3D3.11=
,mfsymlinks,nostrictsync //10.88.103.87/homes /mnt/test

cifs/001 files ...  1s
generic/001 files ...  15s
generic/002 files ...  2s
generic/005 files ...  2s
generic/006 files ...  58s
generic/007 files ...  46s
generic/008 files ...  1s
generic/011 files ...  56s
generic/013 files ...  62s
generic/014 files ...  12s
generic/020 files ...  3s
generic/023 files ...  2s
generic/024 files ...  2s
generic/028 files ...  6s
generic/029 files ...  2s
generic/030 files ...  1s
generic/032 files ...  14s
generic/033 files ...  1s
generic/036 files ...  11s
generic/037 files ...  9s
generic/069 files ...  18s
generic/070 files ...  39s
generic/071 files ...  1s
generic/074 files ...  98s
generic/080 files ...  3s
generic/084 files ...  6s
generic/086 files ...  2s
generic/095 files ...  6s
generic/098 files ...  2s
generic/100 files ...  39s
generic/103 files ...  2s
generic/109 files ...  28s
generic/113 files ...  7s
generic/117 files ...  38s
generic/124 files ...  7s
generic/125 files ...  62s
generic/129 files ...  35s
generic/130 files ...  4s
generic/132 files ...  16s
generic/133 files ...  36s
generic/135 files ...  1s
generic/141 files ...  1s
generic/169 files ...  1s
generic/198 files ...  1s
generic/207 files ...  2s
generic/208 files ...  200s
generic/210 files ...  0s
generic/211 files ...  0s
generic/212 files ...  0s
generic/214 files ...  1s
generic/215 files ...  3s
generic/221 files ...  2s
generic/225 files ...  9s
generic/228 files ...  1s
generic/236 files ...  2s
generic/239 files ...  31s
generic/241 files ...  73s
generic/245 files ...  0s
generic/246 files ...  1s
generic/247 files ...  20s
generic/248 files ...  0s
generic/249 files ...  2s
generic/257 files ...  2s
generic/258 files ...  1s
generic/286 files ...  6s
generic/308 files ...  1s
generic/309 files ...  2s
generic/310 files ...  101s
generic/313 files ...  4s
generic/315 files ...  1s
generic/316 files ...  2s
generic/337 files ...  0s
generic/339 files ...  4s
generic/340 files ...  6s
generic/344 files ...  11s
generic/345 files ...  11s
generic/346 files ...  25s
generic/349 files ...  4s
generic/350 files ...  3s
generic/354 files ...  9s
generic/360 files ...  0s
generic/377 files ...  1s
generic/391 files ...  10s
generic/393 files ...  3s
generic/394 files ...  2s
generic/406 files ...  2s
generic/412 files ...  1s
generic/420 files ...  1s
generic/422 files ...  2s
generic/428 files ...  1s
generic/432 files ...  1s
generic/433 files ...  1s
generic/436 files ...  2s
generic/437 files ...  2s
generic/438 files ...  69s
generic/439 files ...  1s
generic/443 files ...  1s
generic/445 files ...  2s
generic/446 files ...  14s
generic/448 files ...  3s
generic/451 files ...  31s
generic/452 files ...  1s
generic/454 files ...  2s
generic/460 files ...  9s
generic/464 files ...  54s
generic/465 files ...  3s
generic/476 files ...  18864s
generic/490 files ...  3s
generic/504 files ...  0s
generic/523 files ...  118s
generic/524 files ...  6s
generic/533 files ...  2s
generic/539 files ...  2s
generic/551 files ...  7923s
generic/567 files ...  4s
generic/568 files ...  1s
generic/590 files ...  106s
generic/591 files ...  1s
Ran: cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 g=
eneric/008 generic/011 generic/013 generic/014 generic/020 generic/023 gene=
ric/024 generic/028 generic/029 generic/030 generic/032 generic/033 generic=
/036 generic/037 generic/069 generic/070 generic/071 generic/074 generic/08=
0 generic/084 generic/086 generic/095 generic/098 generic/100 generic/103 g=
eneric/109 generic/113 generic/117 generic/124 generic/125 generic/129 gene=
ric/130 generic/132 generic/133 generic/135 generic/141 generic/169 generic=
/198 generic/207 generic/208 generic/210 generic/211 generic/212 generic/21=
4 generic/215 generic/221 generic/225 generic/228 generic/236 generic/239 g=
eneric/241 generic/245 generic/246 generic/247 generic/248 generic/249 gene=
ric/257 generic/258 generic/286 generic/308 generic/309 generic/310 generic=
/313 generic/315 generic/316 generic/337 generic/339 generic/340 generic/34=
4 generic/345 generic/346 generic/349 generic/350 generic/354 generic/360 g=
eneric/377 generic/391 generic/393 generic/394 generic/406 generic/412 gene=
ric/420 generic/422 generic/428 generic/432 generic/433 generic/436 generic=
/437 generic/438 generic/439 generic/443 generic/445 generic/446 generic/44=
8 generic/451 generic/452 generic/454 generic/460 generic/464 generic/465 g=
eneric/476 generic/490 generic/504 generic/523 generic/524 generic/533 gene=
ric/539 generic/551 generic/567 generic/568 generic/590 generic/591
Passed all 118 tests

