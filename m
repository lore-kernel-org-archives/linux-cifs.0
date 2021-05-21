Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB28C433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 02:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AAE7611AB
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 02:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhEUC2v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 22:28:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48470 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhEUC2v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 22:28:51 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210521022727epoutp03e5d02e8f1d42d3e9b83c5ee97d2136fe~A8_jraYwj1835418354epoutp03C
        for <linux-cifs@vger.kernel.org>; Fri, 21 May 2021 02:27:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210521022727epoutp03e5d02e8f1d42d3e9b83c5ee97d2136fe~A8_jraYwj1835418354epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621564047;
        bh=ZL0ZVDeDXSPoCnIcyKZT7D+NFCxRgLQ2Jt2qFiXxTYc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=jHrorqMS4NQ0tvputN+9FxgdeQNBLWhBQ/7PRiBvqOP2lXEV5dJ/GVeFmvrU9Rosq
         04VOINzxpaiC8esGCUCCC6A8xDRkfzgw49gs4O35ekTv09Hn3ku1M0DHbwHwIQdRb5
         dudPNTWVSZx9bD9jPSny31F9BfV6Xd9FsGYAraEU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210521022727epcas1p1e6ff5f5723e36f9b856a13644973fc33~A8_ja02500826808268epcas1p1R;
        Fri, 21 May 2021 02:27:27 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.164]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FmVqy1ZHvz4x9Q5; Fri, 21 May
        2021 02:27:26 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.A8.09736.C8A17A06; Fri, 21 May 2021 11:27:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210521022724epcas1p33f39829c533860b2347a36808bee2d26~A8_gxRb900790607906epcas1p3l;
        Fri, 21 May 2021 02:27:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210521022724epsmtrp21d0396d12188260d322b2e7979b1630d~A8_gwsQaY1865918659epsmtrp28;
        Fri, 21 May 2021 02:27:24 +0000 (GMT)
X-AuditID: b6c32a39-8d9ff70000002608-9c-60a71a8c462e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.23.08637.C8A17A06; Fri, 21 May 2021 11:27:24 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210521022724epsmtip2fe8b8b5368e34209eb4daac7f3addd4f~A8_goPum20385703857epsmtip2f;
        Fri, 21 May 2021 02:27:24 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     "'COMMON INTERNET FILE SYSTEM SERVER'" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'CIFS'" <linux-cifs@vger.kernel.org>
In-Reply-To: 
Subject: RE: ksmbd and reflink support - enables many more functional tests
Date:   Fri, 21 May 2021 11:27:24 +0900
Message-ID: <003101d74de8$d5aa53e0$80fefba0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIdbNTfdPiyvIXNtY/noEWTb/ueXwEWKMiVAiV3KCGqRXw34IAAYjKQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmvm6P1PIEg2dH9Cxe/N/FbPHz/3dG
        izcvDrM5MHvsnHWX3WP3gs9MHp83yQUwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
        GlpamCsp5CXmptoqufgE6Lpl5gAtUlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
        GBoU6BUn5haX5qXrJefnWhkaGBiZAlUm5GRsn3mUqWCCZsW1h33MDYxPFboYOTkkBEwkJrc+
        ZO5i5OIQEtjBKLF47WVGCOcTo8S9tjlQmW+MEoualjHDtLzcdB+qai+jxOQJV5kgnBeMEge/
        PGUEqWIT0JX492c/G4gtIqAp8Wb3JLBuZoF6ibvN54DiHBycArwSE/5Zg4SFBbwlnk85B9bK
        IqAqcf/uVhaQEl4BS4kXW+pBwrwCghInZz5hgZiiLbFs4WuoexQkfj5dxgqxyU1i9v7jrBA1
        IhKzO9vAHpAQeMQusW7ZMTaIBheJ1xfnM0LYwhKvjm9hh7ClJD6/2wtVUy5x4uQvJgi7RmLD
        vH3sIPdICBhL9LwoATGZgb5av0sfokJRYufvuYwQa/kk3n3tYYWo5pXoaBOCKFGV6Lt0GGqg
        tERX+wf2CYxKs5A8NgvJY7OQPDALYdkCRpZVjGKpBcW56anFhgWmyFG9iRGcBLUsdzBOf/tB
        7xAjEwfjIUYJDmYlEd7t3osThHhTEiurUovy44tKc1KLDzGaAkN6IrOUaHI+MA3nlcQbmhoZ
        GxtbmJiZm5kaK4nzpjtXJwgJpCeWpGanphakFsH0MXFwSjUwhc1z3nNmbem1TvtO2bD9gcZ7
        +K0Zoqek31pp/dObL7bd4kXU5MzIlDUzJPXWsm6scOQKKSry2/DdNO/t7TtFJZuUhSsTguUL
        zz4/OD10x921+9hZr6Rf+7vQOO66ro3uFo7zmoIPjy1IqWo70xfK8sfX0/bf8uORz/bYb3Of
        lPRgn9lEYd73SvyrlglIHtS4G1Od9DFR6o/S8vVZTDpswsKJ/2UO91bn/fp4sUsimvnC6X8G
        lXM+GJ8WnPLV2ehUjcixuS4yu1T6VfeXSgr4djn1lRctS6/yeNJxwO3RYfdFcTpr7or0nbnD
        O8HdqOfj0s1T/Q8eyby1753myhOGXAJ8ytWdSSyZmj5ndtxWYinOSDTUYi4qTgQAZzmd3QsE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvG6P1PIEg1vXxCxe/N/FbPHz/3dG
        izcvDrM5MHvsnHWX3WP3gs9MHp83yQUwR3HZpKTmZJalFunbJXBlnD3uWNCgWdH8JamB8aRC
        FyMnh4SAicTLTfcZuxi5OIQEdjNKnL12jBkiIS1x7MQZIJsDyBaWOHy4GKLmGaPElq79jCA1
        bAK6Ev/+7GcDsUUENCXe7J4E1sssUCux+8pCNoiGi4wSD16tYQIZxCnAKzHhnzVIjbCAt8Tz
        KefA5rAIqErcv7uVBaSEV8BS4sWWepAwr4CgxMmZT1ggRmpLPL35FM5etvA11JkKEj+fLmOF
        OMFNYvb+46wQNSISszvbmCcwCs9CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCw7zUcr3i
        xNzi0rx0veT83E2M4FjQ0tzBuH3VB71DjEwcjIcYJTiYlUR4t3svThDiTUmsrEotyo8vKs1J
        LT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBiSPutO/165/jTmes2rWvVzAkpvjd
        6dj7Wh/aH3H+PsS9Ys8Fth6pSyLvcti++8YWq6gnirgnH17YYMGz+r6g1X2BWZ3V25OmXOC+
        cFfp6pau6QGT1cQzj07xCfvYWMexe53T3l9mJklGpTYfpEQu3Vw4/4Xv/ot1J6N2RJ5wt70v
        nRr8TeGiwcv3+lLFzpxGc1Z08LpbbYoIfh/GYzX15Se+nVcucOrvUuC79Ev0RZbTWYmkfpG9
        lw003xXt7dm9b8H+hUWbvHQsD8/a/UeRIWPLvpDdM/0+P+1nLqxenf5vVeW1MO6yky0z0sPa
        Xxap7Hl+t9q39C+fELcZY4Vrx1WjG5ELlh+5EXiw4cDupUosxRmJhlrMRcWJAPdgCoj0AgAA
X-CMS-MailID: 20210521022724epcas1p33f39829c533860b2347a36808bee2d26
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

I have been trying to reproduce this issue since yesterday. Hyunchul is als=
o helping to reproduce it together.
We have not seen the issue ksmbd have crash yet.

And the test results were slightly different.

generic/110 12s ...  9s
generic/111 13s ...  10s
generic/115 13s ...  9s
generic/116 12s ...  10s
generic/118 12s ...  10s
generic/119 13s ...  10s
generic/134 12s ...  10s
generic/138 13s ...  10s
generic/139 13s ...  11s
generic/140 14s ...  10s
generic/142 14s ...  12s
generic/143 26s ...  23s
generic/144 13s ...  10s
generic/146 13s ...  11s
generic/148 13s ...  10s
generic/149 13s ...  10s
generic/150 13s ...  11s
generic/151 14s ...  10s
generic/152 14s ...  11s
generic/153 14s ...  11s
generic/154 14s ...  11s
generic/155 16s ...  13s
generic/161 59s ...  20s
generic/164 39s ...  38s
generic/165 47s ...  37s
generic/166 53s ...  51s
generic/167 49s ...  46s
generic/168     - output mismatch (see /home/linkinjeon/xfstests/loopback/x=
fstests-cifsd2/results//generic/168.out.bad)
    --- tests/generic/168.out   2021-05-21 10:36:41.316652422 +0900
    +++ /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/results//generic=
/168.out.bad 2021-05-21 10:47:19.136657700 +0900
    =40=40 -2,3 +2,26 =40=40
     Format and mount
     Initialize files
     Reflink and write the target
    +/mnt/read/test-168/file2: Bad file descriptor
    +/mnt/read/test-168/file2: Bad file descriptor
    +/mnt/read/test-168/file2: Bad file descriptor
    +/mnt/read/test-168/file2: Bad file descriptor
    ...
    (Run 'diff -u /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/tests/=
generic/168.out /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/results/=
/generic/168.out.bad'  to see the entire diff)
generic/170     - output mismatch (see /home/linkinjeon/xfstests/loopback/x=
fstests-cifsd2/results//generic/170.out.bad)
    --- tests/generic/170.out   2021-05-21 10:36:47.132652470 +0900
    +++ /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/results//generic=
/170.out.bad 2021-05-21 10:49:36.696658838 +0900
    =40=40 -2,3 +2,6 =40=40
     Format and mount
     Initialize files
     Reflink and dio write the target
    +/mnt/read/test-170/file2: Bad file descriptor
    +/mnt/read/test-170/file2: Bad file descriptor
    +/mnt/read/test-170/file2: Bad file descriptor
    ...
    (Run 'diff -u /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/tests/=
generic/170.out /home/linkinjeon/xfstests/loopback/xfstests-cifsd2/results/=
/generic/170.out.bad'  to see the entire diff)
generic/175 242s ...  294s
generic/176      1088s
generic/178 39s ...  38s
generic/179 35s ...  35s
generic/180 34s ...  32s
generic/181 37s ...  35s
generic/183      56s
generic/185 22s ...  17s
Ran: generic/110 generic/111 generic/115 generic/116 generic/118 generic/11=
9 generic/134 generic/138 generic/139 generic/140 generic/142 generic/143 g=
eneric/144 generic/146 generic/148 generic/149 generic/150 generic/151 gene=
ric/152 generic/153 generic/154 generic/155 generic/161 generic/164 generic=
/165 generic/166 generic/167 generic/168 generic/170 generic/175 generic/17=
6 generic/178 generic/179 generic/180 generic/181 generic/183 generic/185
Failures: generic/168 generic/170
Failed 2 of 37 tests

If there are error message from dmesg, It will helpful to find root-cause..=
.

Thanks=21
> -----Original Message-----
> From: Namjae Jeon <namjae.jeon=40samsung.com>
> Sent: Thursday, May 20, 2021 10:44 AM
> To: 'Steve French' <smfrench=40gmail.com>
> Cc: 'CIFS' <linux-cifs=40vger.kernel.org>; 'COMMON INTERNET FILE SYSTEM S=
ERVER' <linux-cifsd-
> devel=40lists.sourceforge.net>
> Subject: RE: ksmbd and reflink support - enables many more functional tes=
ts
>=20
> Hi Steve,
> >
> > Did a run of reflink dependent xfstests against ksmbd (from current
> > 5.13-rc2 linux client) and see a very promising number (35+) of new tes=
ts that we should be able to
> enable.  See below:
> Thanks for your check=21
> >
> > generic/110 0s ...  0s
> > generic/111 0s ...  0s
> > generic/115 0s ...  0s
> > generic/116 0s ...  1s
> > generic/118 0s ...  0s
> > generic/119 1s ...  0s
> > generic/134 1s ...  1s
> > generic/138 0s ...  0s
> > generic/139 1s ...  1s
> > generic/140 0s ...  0s
> > generic/142 1s ...  2s
> > generic/143 2s ...  1s
> > generic/144 1s ...  1s
> > generic/146 1s ...  1s
> > generic/148 1s ...  0s
> > generic/149 0s ...  1s
> > generic/150 1s ...  0s
> > generic/151 0s ...  1s
> > generic/152 1s ...  1s
> > generic/153 0s ...  0s
> > generic/154 1s ...  1s
> > generic/155 0s ...  0s
> > generic/161 1s ...  1s
> > generic/164 8s ...  8s
> > generic/165 9s ...  8s
> > generic/166 6s ...  16s
> > generic/167 5s ...  230s
> > generic/168 46s ...  37s
> > generic/170 44s ...  103s
> > generic/175 7s
> > generic/176 58s ...  50s
> > generic/178 1s ...  0s
> > generic/179 0s ...  1s
> > generic/180 0s ...  0s
> >
> > After test 180 (for tests 181, 183, 185 and following eg.) I got
> > =22could not connect to server=22 on all tests so ksmbd may have crashe=
d
> > at that point
> Okay, I am trying to reproduce it.
>=20
> Thanks=21
> > --
> > Thanks,
> >
> > Steve


