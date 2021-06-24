Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E76C48BC2
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 01:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538926128C
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 01:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFXBFD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 21:05:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63027 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXBFD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 21:05:03 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210624010243epoutp04808ce490ced96ddbbf7a1cdcf9e3cb42~LXwSGvftX0392003920epoutp04f
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 01:02:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210624010243epoutp04808ce490ced96ddbbf7a1cdcf9e3cb42~LXwSGvftX0392003920epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624496563;
        bh=JcUGNAtgj6MJiLIMgdkrM5S6NJxlaD0KNYzRpN/tRoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED8pfYS6V1SLyYcHaMAuwlx7IRTJkyC2k0/k/pAiFUl6PgEt+eLDhnVAmDo6tZQ/e
         wK5fcQg1Vpzim+kAu+BEGAruD/ln0ICwRH27KvRpUyLWgCu56wc39b5Xq0GjBfetub
         lSrAAnCksUsxNsffGYWVdmToFS+YYMpE5J+sT7p8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210624010240epcas1p4b88c3df976c8154b4deb8be926a0b597~LXwPAouJ83206832068epcas1p4k;
        Thu, 24 Jun 2021 01:02:40 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.161]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G9MLR4vGTz4x9QG; Thu, 24 Jun
        2021 01:02:39 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.2B.09468.CA9D3D06; Thu, 24 Jun 2021 10:02:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210624010231epcas1p22d8b6576f5966f45cbf9bf99331dec53~LXwGrIfvq2824228242epcas1p2l;
        Thu, 24 Jun 2021 01:02:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210624010231epsmtrp20f11bbe4bef1fe7c9da1dad0615559fd~LXwGqVo2B0890808908epsmtrp2O;
        Thu, 24 Jun 2021 01:02:31 +0000 (GMT)
X-AuditID: b6c32a37-0c7ff700000024fc-b2-60d3d9ac5d52
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.03.08289.7A9D3D06; Thu, 24 Jun 2021 10:02:31 +0900 (KST)
Received: from localhost.localdomain (unknown [10.89.31.219]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210624010231epsmtip11fbbed1bdc39525dced6cab99773bb6d~LXwGdInQX1611816118epsmtip1A;
        Thu, 24 Jun 2021 01:02:31 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-cifs@vger.kernel.org, linux-cifsd-devel@lists.sourceforge.net
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] MAINTAINERS: rename cifsd to ksmbd
Date:   Thu, 24 Jun 2021 09:52:11 +0900
Message-Id: <20210624005211.26886-2-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624005211.26886-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmvu6am5cTDHbe47A4PWERk8WL/7uY
        LX7+/85o8WN6vUVv3ydWizcvDrM5sHnsnHWX3WPzCi2P3Qs+M3n0bVnF6PF5k1wAa1SOTUZq
        YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QfiWFssScUqBQ
        QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFBgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G7eaV
        TAW7eCo+HytsYLzL1cXIySEhYCLR/eUIYxcjF4eQwA5Gid//T7JAOJ8YJX7uWsMOUiUk8JlR
        YtO+SJiOeXfeQcV3MUr821YEYQM13O9162Lk4GAT0Jb4s0UUJCwi4C6xbH8/M8hMZoHFjBI9
        zavBeoUFzCVW3HvBBFLPIqAq8el5DkiYV8BG4u6L9cwQq+QlVm84AGZzCthK7Pt0hwlkjoTA
        PnaJriV/oIpcJN5/e8oCYQtLvDq+hR3ClpL4/G4vG4RdLnHi5C8mCLtGYsO8fewgeyUEjCV6
        XpSAmMwCmhLrd+lDVChK7Pw9lxHEZhbgk3j3tYcVoppXoqNNCKJEVaLv0mGogdISXe0foJZ6
        SJy9NQ8aghMYJbae2s02gVFuFsKGBYyMqxjFUguKc9NTiw0LjJEjaxMjOG1pme9gnPb2g94h
        RiYOxkOMEhzMSiK8j1ouJQjxpiRWVqUW5ccXleakFh9iNAUG3URmKdHkfGDizCuJNzQ1MjY2
        tjAxMzczNVYS593JdihBSCA9sSQ1OzW1ILUIpo+Jg1OqgemAgEftnKQt4nYz2N//yf6d3LT7
        64K/T2dKTl4k8Uj53Nb9BjP0HnefvnJjfZizVcT8l9Myfgjkuz1o1H5/5Upbw3NHhWCxBUVB
        X6ax/lz1d8fPW4LtL0MCvnBM0Ph0x2BztouyTT13kv1t1j87E+7sEmIMaRL/k1jiP627JLm6
        wfiR4Z4MhqWGXn/38/7tfdu892R9413lIyrbYu2fHV3gHak0z71kbm1gVJLTql+vnxXPkXgS
        dfcE7+6KCYY+jWvWdF/k65Fu4umevDPY/ZX5zZNv5ut8PRuVtNauqOmDucJhh7eb43bsTfcs
        OLX72887UX6fPovYCcvM4W57s41jlpS98+dtLzIDJy940/dSiaU4I9FQi7moOBEAxwZ5euQD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42LZdlhJTnf5zcsJBg+O8lqcnrCIyeLF/13M
        Fj//f2e0+DG93qK37xOrxZsXh9kc2Dx2zrrL7rF5hZbH7gWfmTz6tqxi9Pi8SS6ANYrLJiU1
        J7MstUjfLoEr43bzSqaCXTwVn48VNjDe5epi5OSQEDCRmHfnHXsXIxeHkMAORol3t1tYIBLS
        EsdOnGHuYuQAsoUlDh8uhqj5wCgxZ/c+JpA4m4C2xJ8toiDlIgKeEnuvngebwyywFKjmTjc7
        SEJYwFxixb0XYPUsAqoSn57ngIR5BWwk7r5YzwyxSl5i9YYDYDangK3Evk93mEBsIaCa3d+u
        Mk9g5FvAyLCKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4xLS0djDuWfVB7xAjEwfj
        IUYJDmYlEd5HLZcShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl
        4uCUamBKdZ+slTrjVXZbmkyv9JHZx66Yn5ads0ls8wWeNplOhwqP00WsSUIqkRFMGtPqw3as
        uKi2Lol7f/2Une93FU+Yy2+2PEbStXltxsvwcw7/vu17/Vzjwx0Xk6JYZYY5x2WPLbjvE6Z5
        WuiL36eo5N9iFcvPFTl0uj6Syn5Se39JiVvl/62NUwO/XZl78NTEu+sKHFauc58fEPFBTkJy
        fV6PpQm3SLuyQXixrsKf589iQoMiPBd1pJ60u1Y0p6DNyY5R+NeLH+KGa0/UlJW26E6XYRUp
        Ma88a9OdnjFb8b73d1vFtMPBorx+wd/WlHTFX351/bpUgGKl87KjCaZ5K15Oba36JXB487tV
        N3/qBimxFGckGmoxFxUnAgCrt6ewoAIAAA==
X-CMS-MailID: 20210624010231epcas1p22d8b6576f5966f45cbf9bf99331dec53
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210624010231epcas1p22d8b6576f5966f45cbf9bf99331dec53
References: <20210624005211.26886-1-namjae.jeon@samsung.com>
        <CGME20210624010231epcas1p22d8b6576f5966f45cbf9bf99331dec53@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename cifsd to ksmbd and update Sergey's mail address.

Cc: Steve French <smfrench@gmail.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com> 
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 MAINTAINERS | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f23bb5cbfd70..6691ac75fce5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4540,16 +4540,6 @@ T:	git git://git.samba.org/sfrench/cifs-2.6.git
 F:	Documentation/admin-guide/cifs/
 F:	fs/cifs/
 
-COMMON INTERNET FILE SYSTEM SERVER (CIFSD)
-M:	Namjae Jeon <namjae.jeon@samsung.com>
-M:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-M:	Steve French <sfrench@samba.org>
-M:	Hyunchul Lee <hyc.lee@gmail.com>
-L:	linux-cifs@vger.kernel.org
-L:	linux-cifsd-devel@lists.sourceforge.net
-S:	Maintained
-F:	fs/cifsd/
-
 COMPACTPCI HOTPLUG CORE
 M:	Scott Murray <scott@spiteful.org>
 L:	linux-pci@vger.kernel.org
@@ -9948,6 +9938,15 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL SMB3 SERVER (KSMBD)
+M:	Namjae Jeon <namjae.jeon@samsung.com>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
+M:	Steve French <sfrench@samba.org>
+M:	Hyunchul Lee <hyc.lee@gmail.com>
+L:	linux-cifs@vger.kernel.org
+S:	Maintained
+F:	fs/ksmbd/
+
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendanhiggins@google.com>
 L:	linux-kselftest@vger.kernel.org
-- 
2.17.1

