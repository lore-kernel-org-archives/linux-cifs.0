Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664A6C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 23:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4539C6125F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 23:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhHXXwp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 19:52:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11648 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbhHXXwo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 19:52:44 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210824235158epoutp01105e56ab86f0fb9a1ed08f35b8cb4914~eYyM1cvQu3055930559epoutp01i
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 23:51:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210824235158epoutp01105e56ab86f0fb9a1ed08f35b8cb4914~eYyM1cvQu3055930559epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629849118;
        bh=mjrN51PWFfhhh3K9MGNHujanuXgw0cpIho6U5//CEvQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=bXokaZMPIMGpWz2CDdXBpc/I9diBmljdRAIaXgHQYk6t6MLduyZNlvOhJaIsaSCp3
         SekLN/4ErBCuw1GicHTg3DmqVfo7qj9n9oI1Fo/43bkbFETnrqRwLBpM3GQ7AjH1Cg
         EbKKIMUi4gIBjYSqGBsTz6tgUYIfdQEOmWmnr2MM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210824235157epcas1p459192311f6c94557089f597c36e5ef7c~eYyMPwaPf0303503035epcas1p4i;
        Tue, 24 Aug 2021 23:51:57 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.248]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GvQrC3S0Mz4x9QN; Tue, 24 Aug
        2021 23:51:55 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.CD.09752.61685216; Wed, 25 Aug 2021 08:51:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210824235149epcas1p1c89e037d05a36fde4f98935b50c48896~eYyE16rw42466924669epcas1p1B;
        Tue, 24 Aug 2021 23:51:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210824235149epsmtrp16f8db9fab35ca8bdf6037560be895cd0~eYyE1QSZy0570805708epsmtrp1I;
        Tue, 24 Aug 2021 23:51:49 +0000 (GMT)
X-AuditID: b6c32a39-6a7ff70000002618-1b-6125861640f9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.09.09091.51685216; Wed, 25 Aug 2021 08:51:49 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210824235149epsmtip2adb4596bae2c770cce692736dfbb504a~eYyEqdGjU2846628466epsmtip2g;
        Tue, 24 Aug 2021 23:51:49 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>,
        "'CIFS'" <linux-cifs@vger.kernel.org>
Cc:     "'Paulo Alcantara'" <pc@cjr.nz>
In-Reply-To: <CAH2r5muXxAAYOUS6YOcu1P=D3-=AQkNkRb_BF+bufbeTZX9HSg@mail.gmail.com>
Subject: RE: [PATCH] add cifs_common directory to MAINTAINERS file
Date:   Wed, 25 Aug 2021 08:51:49 +0900
Message-ID: <03d901d79943$0132bd40$039837c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQIweKVd14k3LA3rPa1F3CctAYQa7gIuKgXxqsAiWFA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmnq5Ym2qiwb0pihYv/u9itrhxuYnZ
        4s2Lw2wOzB7b+k6xeuycdZfd4/MmuQDmqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
        Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwC
        swK94sTc4tK8dL281BIrQwMDI1OgwoTsjMUTZzMX3GOqWND7mL2BcRJTFyMnh4SAiUTT1lmM
        XYxcHEICOxgl7n67zAKSEBL4xChx8xUrROIbo0T3s1WsMB3rt5yD6tjLKDGlr4kZwnnBKLHr
        3A42kCo2AV2Jf3/2g9kiAkESkx5MAyri4GAWUJZ49CMDJMwpECix8+cHZhBbWMBJYvbPFWA2
        i4CqxNS9a8Gu4BWwlFh+8BorhC0ocXLmE7A4s4C8xPa3c5ghDlKQ+Pl0GStEXERidmcbM8Ra
        K4knn1axg9wmIfCRXeLE0h9sEA0uEtt3L4H6Rlji1fEt7BC2lMTL/jYou1zixMlf0DCqkdgw
        bx87yP0SAsYSPS9KIF7RlFi/Sx+iQlFi5++5jBAn8Em8+9rDClHNK9HRJgRRoirRd+kw1EBp
        ia72D+wTGJVmIXlsFpLHZiF5ZhbCsgWMLKsYxVILinPTU4sNC0zhUZ2cn7uJEZwCtSx3ME5/
        +0HvECMTB+MhRgkOZiUR3r9MyolCvCmJlVWpRfnxRaU5qcWHGE2BQT2RWUo0OR+YhPNK4g1N
        LA1MzIxMLIwtjc2UxHkZX8kkCgmkJ5akZqemFqQWwfQxcXBKNTCF/ODxXvTKfNv7KxvfRX6a
        wNj67zLfz0WbbpiHrtSc7lNRf5DlyupHp8wV21n2x3nsLEgWiK08Y7Jv0m9nC7EppkFazRLf
        dVu2zBdm4p+7WGTaTab54aJCfTmv+NMYvcvnqB+d07vJLOOes+7Tpu4HyikFBsXdZekn5nKp
        u1z17z3Cd2eVe4E2386HU8+92c+bVcqtVvbW/fctg+Cu4i/TX3PqzNuX/kB63V+7qnUpe+wX
        acX9Kz9ufITp0l+PxHVWWmEh/oxiLxc0rV2501fbRLJJ2fnUJRNOr9P/RHhW/Aw6V/RIf92M
        7yerotmeXdq8cZeunUumXP6lT4mdvM92f4u9tPLM/02Ba58lTAhXYinOSDTUYi4qTgQA8oJw
        rAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvK5om2qiQcMLMYsX/3cxW9y43MRs
        8ebFYTYHZo9tfadYPXbOusvu8XmTXABzFJdNSmpOZllqkb5dAlfG4omzmQvuMVUs6H3M3sA4
        iamLkZNDQsBEYv2Wc4xdjFwcQgK7GSU2PljFDpGQljh24gxzFyMHkC0scfhwMUTNM0aJKbsu
        MoLUsAnoSvz7s58NxBYRCJL4+PcMO0g9s4CyxKMfGRD1ixglpnZ/Ywap4RQIlNj58wOYLSzg
        JDH75wowm0VAVWLq3rUsIDavgKXE8oPXWCFsQYmTM5+AxZkFtCV6H7YyQtjyEtvfzmGGuFNB
        4ufTZawQcRGJ2Z1tzBD3WEk8+bSKfQKj8Cwko2YhGTULyahZSNoXMLKsYpRMLSjOTc8tNiww
        zEst1ytOzC0uzUvXS87P3cQIjggtzR2M21d90DvEyMTBeIhRgoNZSYT3L5NyohBvSmJlVWpR
        fnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MJqpP/SbLyUryPJcVudr9
        zFS5jf997JYJdjFyJRka98+Yi5uLNroLvZ6cd+bosX2P1c8f2uz+SsiQ+49h6/yjSS+9Zn9k
        6vmVd2Xfpl19E2aH/30ty8c37cayj8pbuHsNLA2YLNhSmScJbywNl7h7VTT7Y8H7yevjr4i9
        Lbvw/Lgow4JNBdMvfHz+O+zCkbmvplueWLqa1/sEi1xAh9XyogPcHCyPFuYdff565vr7k5ac
        8klyuyxjwlEYeD9y5kkVhXf8FY8Ljwf7nupSaN0xiTfD/pS56FfxNUx/FgRoRN5rOtvWeirS
        /OLLODbuH+uv8MY/eblh5pPO/KhXSz2PP9onIZZ59EvG3SO/Ileo5yqxFGckGmoxFxUnAgBu
        848r9wIAAA==
X-CMS-MailID: 20210824235149epcas1p1c89e037d05a36fde4f98935b50c48896
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210824211853epcas1p496abd06e1440c42358fb2f97d8d852d6
References: <CGME20210824211853epcas1p496abd06e1440c42358fb2f97d8d852d6@epcas1p4.samsung.com>
        <CAH2r5muXxAAYOUS6YOcu1P=D3-=AQkNkRb_BF+bufbeTZX9HSg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> With some files moving into the cifs_common directory, we need to add it to the CIFS entry in the
> MAINTAINERS file.
I will add cifs_common directory to ksmbd entry in MAINTAINERS.

Thanks!
> 
> Suggested-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> 
> 
> --
> Thanks,
> 
> Steve

