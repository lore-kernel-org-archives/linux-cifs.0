Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9817CC48BC2
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 01:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E8D6128C
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 01:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFXBFJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 21:05:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18607 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXBFI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 21:05:08 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210624010248epoutp02f248213277c808fbc42969daadb0393a~LXwW5vimy1794317943epoutp026
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 01:02:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210624010248epoutp02f248213277c808fbc42969daadb0393a~LXwW5vimy1794317943epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624496568;
        bh=VgQSjXhQ4qAZ/z/W2Wp4PAvllT/ZctH0/VYHmIW8kRs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=M7pBjnQLM53Y8mBAQ3afop3pcLZWfENoeO5Kb7fuKqQHL1cIWTm/U0kcg/iV5iv0R
         9uPhuu2NpiP6RTrVKlHcAPo0+McZd3f0cXqxOozr28Tr18po6op0X9t5vtod6mvm+H
         FBZGiccWddjWqNmxSmh8zxorK8uaMokHkncVG8eA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210624010239epcas1p426fe969276cd9769ec657572d4614f82~LXwOgxlQ92274222742epcas1p4C;
        Thu, 24 Jun 2021 01:02:39 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4G9MLQ17FTz4x9QV; Thu, 24 Jun
        2021 01:02:38 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.BE.09551.8A9D3D06; Thu, 24 Jun 2021 10:02:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210624010230epcas1p27cee803b261296294a069e8169a03c4a~LXwFkUwRx1170211702epcas1p29;
        Thu, 24 Jun 2021 01:02:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210624010230epsmtrp2415744ad319f15c6e0694db1563619e5~LXwFjk1oQ0890808908epsmtrp2J;
        Thu, 24 Jun 2021 01:02:30 +0000 (GMT)
X-AuditID: b6c32a36-2b3ff7000000254f-17-60d3d9a8ce38
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.03.08289.6A9D3D06; Thu, 24 Jun 2021 10:02:30 +0900 (KST)
Received: from localhost.localdomain (unknown [10.89.31.219]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210624010229epsmtip189d06a47618c0b1e35a45d4305ff95bd~LXwFXdsqM2054820548epsmtip1E;
        Thu, 24 Jun 2021 01:02:29 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-cifs@vger.kernel.org, linux-cifsd-devel@lists.sourceforge.net
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] ksmbd: move fs/cifsd to fs/ksmbd
Date:   Thu, 24 Jun 2021 09:52:10 +0900
Message-Id: <20210624005211.26886-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmru6Km5cTDFpPCVicnrCIyeLF/13M
        Fj//f2e0+DG93qK37xOrxZsXh9kc2Dx2zrrL7rF5hZbH7gWfmTz6tqxi9Pi8SS6ANSrHJiM1
        MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdov5JCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCgQK84Mbe4NC9dLzk/18rQwMDIFKgyISfjx8OT
        jAU7JzNW3Lnzg6WBcUNpFyMnh4SAicT7xd8Zuxi5OIQEdjBK9O/ZB+V8YpS4/ugAO4TzmVFi
        5q3NjDAtCzv3QyV2MUrsXH2aBSQB1nL0F38XIwcHm4C2xJ8toiBhEQF3iWX7+5lB6pkFFjNK
        9DSvZgdJCAuYSjTOn8gGYrMIqEosfnoFbA6vgI3Eym1TWCGWyUus3nCAGcJexS4x67o/hO0i
        MffjdqgaYYlXx7ewQ9hSEp/f7WWDsMslTpz8xQRh10hsmLePHeQ2CQFjiZ4XJSAms4CmxPpd
        +hAVihI7f88Fe5FZgE/i3dceVohqXomONiGIElWJvkuHoQZKS3S1f4Ba6iGx4shHdkggxEqc
        /nCYdQKj7CyEBQsYGVcxiqUWFOempxYbFhghx9EmRnCS0jLbwTjp7Qe9Q4xMHIyHGCU4mJVE
        eB+1XEoQ4k1JrKxKLcqPLyrNSS0+xGgKDK2JzFKiyfnANJlXEm9oamRsbGxhYmZuZmqsJM67
        k+1QgpBAemJJanZqakFqEUwfEwenVANTWd7S7W7Hd57KDWBVYf66ZkPVlxWiShumd/ufuqev
        PJ3zYeza6x9zdBlX5M243yHscvUEy1uFP5ZzuG95vb4guL7847Xi/EkVf4XvrJq1dkpnB+sZ
        MZbkafO+Z4tlS52P+7Qmrae13C0xa8lry5KWROZjylwXC5/N9eY72dAsurY9QCLrv9+TybaC
        G180xDVnfZ7+iIFzTW3tU8c/MnfTP6yf02Bly7bhn4f2FAc71nn2T5tN1O03qhZrvb8YM1NY
        L+e9+c0tuc/uLMrKb/rXuGrxn5zyT5bLFgloN1pNltjYXRvAo5smkHK8YYdvudXr8IUbL8+a
        xOGodO1UzkauqtMvfl3u2Lm0oGnFuTIeJZbijERDLeai4kQA1ly5R9sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsWy7bCSnO6ym5cTDF7+ZLM4PWERk8WL/7uY
        LX7+/85o8WN6vUVv3ydWizcvDrM5sHnsnHWX3WPzCi2P3Qs+M3n0bVnF6PF5k1wAaxSXTUpq
        TmZZapG+XQJXxo+HJxkLdk5mrLhz5wdLA+OG0i5GTg4JAROJhZ372bsYuTiEBHYwSixfcZgd
        IiEtcezEGeYuRg4gW1ji8OFiiJoPjBLvNy5jBImzCWhL/NkiClIuIuApsffqebA5zAJLGSXm
        3OkGmyMsYCrROH8iG4jNIqAqsfjpFRYQm1fARmLltimsELvkJVZvOMA8gZFnASPDKkbJ1ILi
        3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4MDR0trBuGfVB71DjEwcjIcYJTiYlUR4H7VcShDi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBif/cVNe+Vf+s
        +KpzU+z+PfZzvsbD2h7O/ubLcfe69aZf1J7F8s1/Wct92FtHS1c+5MQOpuXSbjOr8p6y5Wyb
        c2e329VYWyfdxsqPdzMr3x+c3dz8Zupt5eA9d799b9GO4F2qteDVo+nhB57Z3bpVrhh8qLZr
        ksOlz9vblr1rUZD7VrpU+qBeSOcMp8A/SiEzPWq0hXjeze7Wryl7rXPlQscPg5/LZu+Zs4jz
        ZE/W0++RmQf3rYtWFuyR1kyWXZ1YsmSuCXNMY3fmmg/8z+dlX06Vb63LXSX1+O1ed5Ne2Yw6
        Jve18ytCA5Pv+9WFsk46M2ljj3VC7fx13Cb8N1acWPjuJ9s65ak+JVIXqtgjlViKMxINtZiL
        ihMBu42PvYsCAAA=
X-CMS-MailID: 20210624010230epcas1p27cee803b261296294a069e8169a03c4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210624010230epcas1p27cee803b261296294a069e8169a03c4a
References: <CGME20210624010230epcas1p27cee803b261296294a069e8169a03c4a@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move fs/cifsd to fs/ksmbd and rename the remaining cifsd name to ksmbd.

Cc: Steve French <smfrench@gmail.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com> 
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 Documentation/filesystems/cifs/index.rst               |  2 +-
 .../filesystems/cifs/{cifsd.rst => ksmbd.rst}          | 10 +++++-----
 fs/Kconfig                                             |  2 +-
 fs/Makefile                                            |  2 +-
 fs/{cifsd => ksmbd}/Kconfig                            |  2 +-
 fs/{cifsd => ksmbd}/Makefile                           |  0
 fs/{cifsd => ksmbd}/asn1.c                             |  0
 fs/{cifsd => ksmbd}/asn1.h                             |  0
 fs/{cifsd => ksmbd}/auth.c                             |  0
 fs/{cifsd => ksmbd}/auth.h                             |  0
 fs/{cifsd => ksmbd}/connection.c                       |  0
 fs/{cifsd => ksmbd}/connection.h                       |  0
 fs/{cifsd => ksmbd}/crypto_ctx.c                       |  0
 fs/{cifsd => ksmbd}/crypto_ctx.h                       |  0
 fs/{cifsd => ksmbd}/glob.h                             |  0
 fs/{cifsd => ksmbd}/ksmbd_server.h                     |  0
 fs/{cifsd => ksmbd}/ksmbd_spnego_negtokeninit.asn1     |  0
 fs/{cifsd => ksmbd}/ksmbd_spnego_negtokentarg.asn1     |  0
 fs/{cifsd => ksmbd}/ksmbd_work.c                       |  0
 fs/{cifsd => ksmbd}/ksmbd_work.h                       |  0
 fs/{cifsd => ksmbd}/mgmt/ksmbd_ida.c                   |  0
 fs/{cifsd => ksmbd}/mgmt/ksmbd_ida.h                   |  0
 fs/{cifsd => ksmbd}/mgmt/share_config.c                |  0
 fs/{cifsd => ksmbd}/mgmt/share_config.h                |  0
 fs/{cifsd => ksmbd}/mgmt/tree_connect.c                |  0
 fs/{cifsd => ksmbd}/mgmt/tree_connect.h                |  0
 fs/{cifsd => ksmbd}/mgmt/user_config.c                 |  0
 fs/{cifsd => ksmbd}/mgmt/user_config.h                 |  0
 fs/{cifsd => ksmbd}/mgmt/user_session.c                |  0
 fs/{cifsd => ksmbd}/mgmt/user_session.h                |  0
 fs/{cifsd => ksmbd}/misc.c                             |  0
 fs/{cifsd => ksmbd}/misc.h                             |  0
 fs/{cifsd => ksmbd}/ndr.c                              |  0
 fs/{cifsd => ksmbd}/ndr.h                              |  0
 fs/{cifsd => ksmbd}/nterr.h                            |  0
 fs/{cifsd => ksmbd}/ntlmssp.h                          |  0
 fs/{cifsd => ksmbd}/oplock.c                           |  0
 fs/{cifsd => ksmbd}/oplock.h                           |  0
 fs/{cifsd => ksmbd}/server.c                           |  0
 fs/{cifsd => ksmbd}/server.h                           |  0
 fs/{cifsd => ksmbd}/smb2misc.c                         |  0
 fs/{cifsd => ksmbd}/smb2ops.c                          |  0
 fs/{cifsd => ksmbd}/smb2pdu.c                          |  0
 fs/{cifsd => ksmbd}/smb2pdu.h                          |  0
 fs/{cifsd => ksmbd}/smb_common.c                       |  0
 fs/{cifsd => ksmbd}/smb_common.h                       |  0
 fs/{cifsd => ksmbd}/smbacl.c                           |  0
 fs/{cifsd => ksmbd}/smbacl.h                           |  0
 fs/{cifsd => ksmbd}/smbfsctl.h                         |  0
 fs/{cifsd => ksmbd}/smbstatus.h                        |  0
 fs/{cifsd => ksmbd}/transport_ipc.c                    |  0
 fs/{cifsd => ksmbd}/transport_ipc.h                    |  0
 fs/{cifsd => ksmbd}/transport_rdma.c                   |  0
 fs/{cifsd => ksmbd}/transport_rdma.h                   |  0
 fs/{cifsd => ksmbd}/transport_tcp.c                    |  0
 fs/{cifsd => ksmbd}/transport_tcp.h                    |  0
 fs/{cifsd => ksmbd}/unicode.c                          |  0
 fs/{cifsd => ksmbd}/unicode.h                          |  0
 fs/{cifsd => ksmbd}/uniupr.h                           |  0
 fs/{cifsd => ksmbd}/vfs.c                              |  0
 fs/{cifsd => ksmbd}/vfs.h                              |  0
 fs/{cifsd => ksmbd}/vfs_cache.c                        |  0
 fs/{cifsd => ksmbd}/vfs_cache.h                        |  0
 63 files changed, 9 insertions(+), 9 deletions(-)
 rename Documentation/filesystems/cifs/{cifsd.rst => ksmbd.rst} (98%)
 rename fs/{cifsd => ksmbd}/Kconfig (97%)
 rename fs/{cifsd => ksmbd}/Makefile (100%)
 rename fs/{cifsd => ksmbd}/asn1.c (100%)
 rename fs/{cifsd => ksmbd}/asn1.h (100%)
 rename fs/{cifsd => ksmbd}/auth.c (100%)
 rename fs/{cifsd => ksmbd}/auth.h (100%)
 rename fs/{cifsd => ksmbd}/connection.c (100%)
 rename fs/{cifsd => ksmbd}/connection.h (100%)
 rename fs/{cifsd => ksmbd}/crypto_ctx.c (100%)
 rename fs/{cifsd => ksmbd}/crypto_ctx.h (100%)
 rename fs/{cifsd => ksmbd}/glob.h (100%)
 rename fs/{cifsd => ksmbd}/ksmbd_server.h (100%)
 rename fs/{cifsd => ksmbd}/ksmbd_spnego_negtokeninit.asn1 (100%)
 rename fs/{cifsd => ksmbd}/ksmbd_spnego_negtokentarg.asn1 (100%)
 rename fs/{cifsd => ksmbd}/ksmbd_work.c (100%)
 rename fs/{cifsd => ksmbd}/ksmbd_work.h (100%)
 rename fs/{cifsd => ksmbd}/mgmt/ksmbd_ida.c (100%)
 rename fs/{cifsd => ksmbd}/mgmt/ksmbd_ida.h (100%)
 rename fs/{cifsd => ksmbd}/mgmt/share_config.c (100%)
 rename fs/{cifsd => ksmbd}/mgmt/share_config.h (100%)
 rename fs/{cifsd => ksmbd}/mgmt/tree_connect.c (100%)
 rename fs/{cifsd => ksmbd}/mgmt/tree_connect.h (100%)
 rename fs/{cifsd => ksmbd}/mgmt/user_config.c (100%)
 rename fs/{cifsd => ksmbd}/mgmt/user_config.h (100%)
 rename fs/{cifsd => ksmbd}/mgmt/user_session.c (100%)
 rename fs/{cifsd => ksmbd}/mgmt/user_session.h (100%)
 rename fs/{cifsd => ksmbd}/misc.c (100%)
 rename fs/{cifsd => ksmbd}/misc.h (100%)
 rename fs/{cifsd => ksmbd}/ndr.c (100%)
 rename fs/{cifsd => ksmbd}/ndr.h (100%)
 rename fs/{cifsd => ksmbd}/nterr.h (100%)
 rename fs/{cifsd => ksmbd}/ntlmssp.h (100%)
 rename fs/{cifsd => ksmbd}/oplock.c (100%)
 rename fs/{cifsd => ksmbd}/oplock.h (100%)
 rename fs/{cifsd => ksmbd}/server.c (100%)
 rename fs/{cifsd => ksmbd}/server.h (100%)
 rename fs/{cifsd => ksmbd}/smb2misc.c (100%)
 rename fs/{cifsd => ksmbd}/smb2ops.c (100%)
 rename fs/{cifsd => ksmbd}/smb2pdu.c (100%)
 rename fs/{cifsd => ksmbd}/smb2pdu.h (100%)
 rename fs/{cifsd => ksmbd}/smb_common.c (100%)
 rename fs/{cifsd => ksmbd}/smb_common.h (100%)
 rename fs/{cifsd => ksmbd}/smbacl.c (100%)
 rename fs/{cifsd => ksmbd}/smbacl.h (100%)
 rename fs/{cifsd => ksmbd}/smbfsctl.h (100%)
 rename fs/{cifsd => ksmbd}/smbstatus.h (100%)
 rename fs/{cifsd => ksmbd}/transport_ipc.c (100%)
 rename fs/{cifsd => ksmbd}/transport_ipc.h (100%)
 rename fs/{cifsd => ksmbd}/transport_rdma.c (100%)
 rename fs/{cifsd => ksmbd}/transport_rdma.h (100%)
 rename fs/{cifsd => ksmbd}/transport_tcp.c (100%)
 rename fs/{cifsd => ksmbd}/transport_tcp.h (100%)
 rename fs/{cifsd => ksmbd}/unicode.c (100%)
 rename fs/{cifsd => ksmbd}/unicode.h (100%)
 rename fs/{cifsd => ksmbd}/uniupr.h (100%)
 rename fs/{cifsd => ksmbd}/vfs.c (100%)
 rename fs/{cifsd => ksmbd}/vfs.h (100%)
 rename fs/{cifsd => ksmbd}/vfs_cache.c (100%)
 rename fs/{cifsd => ksmbd}/vfs_cache.h (100%)

diff --git a/Documentation/filesystems/cifs/index.rst b/Documentation/filesystems/cifs/index.rst
index e762586b5dc7..1c8597a679ab 100644
--- a/Documentation/filesystems/cifs/index.rst
+++ b/Documentation/filesystems/cifs/index.rst
@@ -6,5 +6,5 @@ CIFS
 .. toctree::
    :maxdepth: 1
 
-   cifsd
+   ksmbd
    cifsroot
diff --git a/Documentation/filesystems/cifs/cifsd.rst b/Documentation/filesystems/cifs/ksmbd.rst
similarity index 98%
rename from Documentation/filesystems/cifs/cifsd.rst
rename to Documentation/filesystems/cifs/ksmbd.rst
index 01a0be272ce6..1e111efecd45 100644
--- a/Documentation/filesystems/cifs/cifsd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -1,13 +1,13 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 ==========================
-CIFSD - SMB3 Kernel Server
+KSMBD - SMB3 Kernel Server
 ==========================
 
-CIFSD is a linux kernel server which implements SMB3 protocol in kernel space
+KSMBD is a linux kernel server which implements SMB3 protocol in kernel space
 for sharing files over network.
 
-CIFSD architecture
+KSMBD architecture
 ==================
 
 The subset of performance related operations belong in kernelspace and
@@ -60,7 +60,7 @@ NetServerGetInfo. Complete DCE/RPC response is prepared from the user space
 and passed over to the associated kernel thread for the client.
 
 
-CIFSD Feature Status
+KSMBD Feature Status
 ====================
 
 ============================== =================================================
@@ -138,7 +138,7 @@ How to run
 
 6. Access share from Windows or Linux using CIFS
 
-Shutdown CIFSD
+Shutdown KSMBD
 ==============
 
 1. kill user and kernel space daemon
diff --git a/fs/Kconfig b/fs/Kconfig
index 7462761ebd2f..720c38f484c6 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -344,7 +344,7 @@ config NFS_V4_2_SSC_HELPER
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
-source "fs/cifsd/Kconfig"
+source "fs/ksmbd/Kconfig"
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
 source "fs/9p/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 542a77374d12..e03a048b2cd8 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_NLS)		+= nls/
 obj-$(CONFIG_UNICODE)		+= unicode/
 obj-$(CONFIG_SYSV_FS)		+= sysv/
 obj-$(CONFIG_CIFS)		+= cifs/
-obj-$(CONFIG_SMB_SERVER)	+= cifsd/
+obj-$(CONFIG_SMB_SERVER)	+= ksmbd/
 obj-$(CONFIG_HPFS_FS)		+= hpfs/
 obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
diff --git a/fs/cifsd/Kconfig b/fs/ksmbd/Kconfig
similarity index 97%
rename from fs/cifsd/Kconfig
rename to fs/ksmbd/Kconfig
index 796f928a7da0..ba8554fc36d3 100644
--- a/fs/cifsd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -1,5 +1,5 @@
 config SMB_SERVER
-	tristate "SMB server support (EXPERIMENTAL)"
+	tristate "SMB3 server support (EXPERIMENTAL)"
 	depends on INET
 	depends on MULTIUSER
 	depends on FILE_LOCKING
diff --git a/fs/cifsd/Makefile b/fs/ksmbd/Makefile
similarity index 100%
rename from fs/cifsd/Makefile
rename to fs/ksmbd/Makefile
diff --git a/fs/cifsd/asn1.c b/fs/ksmbd/asn1.c
similarity index 100%
rename from fs/cifsd/asn1.c
rename to fs/ksmbd/asn1.c
diff --git a/fs/cifsd/asn1.h b/fs/ksmbd/asn1.h
similarity index 100%
rename from fs/cifsd/asn1.h
rename to fs/ksmbd/asn1.h
diff --git a/fs/cifsd/auth.c b/fs/ksmbd/auth.c
similarity index 100%
rename from fs/cifsd/auth.c
rename to fs/ksmbd/auth.c
diff --git a/fs/cifsd/auth.h b/fs/ksmbd/auth.h
similarity index 100%
rename from fs/cifsd/auth.h
rename to fs/ksmbd/auth.h
diff --git a/fs/cifsd/connection.c b/fs/ksmbd/connection.c
similarity index 100%
rename from fs/cifsd/connection.c
rename to fs/ksmbd/connection.c
diff --git a/fs/cifsd/connection.h b/fs/ksmbd/connection.h
similarity index 100%
rename from fs/cifsd/connection.h
rename to fs/ksmbd/connection.h
diff --git a/fs/cifsd/crypto_ctx.c b/fs/ksmbd/crypto_ctx.c
similarity index 100%
rename from fs/cifsd/crypto_ctx.c
rename to fs/ksmbd/crypto_ctx.c
diff --git a/fs/cifsd/crypto_ctx.h b/fs/ksmbd/crypto_ctx.h
similarity index 100%
rename from fs/cifsd/crypto_ctx.h
rename to fs/ksmbd/crypto_ctx.h
diff --git a/fs/cifsd/glob.h b/fs/ksmbd/glob.h
similarity index 100%
rename from fs/cifsd/glob.h
rename to fs/ksmbd/glob.h
diff --git a/fs/cifsd/ksmbd_server.h b/fs/ksmbd/ksmbd_server.h
similarity index 100%
rename from fs/cifsd/ksmbd_server.h
rename to fs/ksmbd/ksmbd_server.h
diff --git a/fs/cifsd/ksmbd_spnego_negtokeninit.asn1 b/fs/ksmbd/ksmbd_spnego_negtokeninit.asn1
similarity index 100%
rename from fs/cifsd/ksmbd_spnego_negtokeninit.asn1
rename to fs/ksmbd/ksmbd_spnego_negtokeninit.asn1
diff --git a/fs/cifsd/ksmbd_spnego_negtokentarg.asn1 b/fs/ksmbd/ksmbd_spnego_negtokentarg.asn1
similarity index 100%
rename from fs/cifsd/ksmbd_spnego_negtokentarg.asn1
rename to fs/ksmbd/ksmbd_spnego_negtokentarg.asn1
diff --git a/fs/cifsd/ksmbd_work.c b/fs/ksmbd/ksmbd_work.c
similarity index 100%
rename from fs/cifsd/ksmbd_work.c
rename to fs/ksmbd/ksmbd_work.c
diff --git a/fs/cifsd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
similarity index 100%
rename from fs/cifsd/ksmbd_work.h
rename to fs/ksmbd/ksmbd_work.h
diff --git a/fs/cifsd/mgmt/ksmbd_ida.c b/fs/ksmbd/mgmt/ksmbd_ida.c
similarity index 100%
rename from fs/cifsd/mgmt/ksmbd_ida.c
rename to fs/ksmbd/mgmt/ksmbd_ida.c
diff --git a/fs/cifsd/mgmt/ksmbd_ida.h b/fs/ksmbd/mgmt/ksmbd_ida.h
similarity index 100%
rename from fs/cifsd/mgmt/ksmbd_ida.h
rename to fs/ksmbd/mgmt/ksmbd_ida.h
diff --git a/fs/cifsd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
similarity index 100%
rename from fs/cifsd/mgmt/share_config.c
rename to fs/ksmbd/mgmt/share_config.c
diff --git a/fs/cifsd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
similarity index 100%
rename from fs/cifsd/mgmt/share_config.h
rename to fs/ksmbd/mgmt/share_config.h
diff --git a/fs/cifsd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
similarity index 100%
rename from fs/cifsd/mgmt/tree_connect.c
rename to fs/ksmbd/mgmt/tree_connect.c
diff --git a/fs/cifsd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
similarity index 100%
rename from fs/cifsd/mgmt/tree_connect.h
rename to fs/ksmbd/mgmt/tree_connect.h
diff --git a/fs/cifsd/mgmt/user_config.c b/fs/ksmbd/mgmt/user_config.c
similarity index 100%
rename from fs/cifsd/mgmt/user_config.c
rename to fs/ksmbd/mgmt/user_config.c
diff --git a/fs/cifsd/mgmt/user_config.h b/fs/ksmbd/mgmt/user_config.h
similarity index 100%
rename from fs/cifsd/mgmt/user_config.h
rename to fs/ksmbd/mgmt/user_config.h
diff --git a/fs/cifsd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
similarity index 100%
rename from fs/cifsd/mgmt/user_session.c
rename to fs/ksmbd/mgmt/user_session.c
diff --git a/fs/cifsd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
similarity index 100%
rename from fs/cifsd/mgmt/user_session.h
rename to fs/ksmbd/mgmt/user_session.h
diff --git a/fs/cifsd/misc.c b/fs/ksmbd/misc.c
similarity index 100%
rename from fs/cifsd/misc.c
rename to fs/ksmbd/misc.c
diff --git a/fs/cifsd/misc.h b/fs/ksmbd/misc.h
similarity index 100%
rename from fs/cifsd/misc.h
rename to fs/ksmbd/misc.h
diff --git a/fs/cifsd/ndr.c b/fs/ksmbd/ndr.c
similarity index 100%
rename from fs/cifsd/ndr.c
rename to fs/ksmbd/ndr.c
diff --git a/fs/cifsd/ndr.h b/fs/ksmbd/ndr.h
similarity index 100%
rename from fs/cifsd/ndr.h
rename to fs/ksmbd/ndr.h
diff --git a/fs/cifsd/nterr.h b/fs/ksmbd/nterr.h
similarity index 100%
rename from fs/cifsd/nterr.h
rename to fs/ksmbd/nterr.h
diff --git a/fs/cifsd/ntlmssp.h b/fs/ksmbd/ntlmssp.h
similarity index 100%
rename from fs/cifsd/ntlmssp.h
rename to fs/ksmbd/ntlmssp.h
diff --git a/fs/cifsd/oplock.c b/fs/ksmbd/oplock.c
similarity index 100%
rename from fs/cifsd/oplock.c
rename to fs/ksmbd/oplock.c
diff --git a/fs/cifsd/oplock.h b/fs/ksmbd/oplock.h
similarity index 100%
rename from fs/cifsd/oplock.h
rename to fs/ksmbd/oplock.h
diff --git a/fs/cifsd/server.c b/fs/ksmbd/server.c
similarity index 100%
rename from fs/cifsd/server.c
rename to fs/ksmbd/server.c
diff --git a/fs/cifsd/server.h b/fs/ksmbd/server.h
similarity index 100%
rename from fs/cifsd/server.h
rename to fs/ksmbd/server.h
diff --git a/fs/cifsd/smb2misc.c b/fs/ksmbd/smb2misc.c
similarity index 100%
rename from fs/cifsd/smb2misc.c
rename to fs/ksmbd/smb2misc.c
diff --git a/fs/cifsd/smb2ops.c b/fs/ksmbd/smb2ops.c
similarity index 100%
rename from fs/cifsd/smb2ops.c
rename to fs/ksmbd/smb2ops.c
diff --git a/fs/cifsd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
similarity index 100%
rename from fs/cifsd/smb2pdu.c
rename to fs/ksmbd/smb2pdu.c
diff --git a/fs/cifsd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
similarity index 100%
rename from fs/cifsd/smb2pdu.h
rename to fs/ksmbd/smb2pdu.h
diff --git a/fs/cifsd/smb_common.c b/fs/ksmbd/smb_common.c
similarity index 100%
rename from fs/cifsd/smb_common.c
rename to fs/ksmbd/smb_common.c
diff --git a/fs/cifsd/smb_common.h b/fs/ksmbd/smb_common.h
similarity index 100%
rename from fs/cifsd/smb_common.h
rename to fs/ksmbd/smb_common.h
diff --git a/fs/cifsd/smbacl.c b/fs/ksmbd/smbacl.c
similarity index 100%
rename from fs/cifsd/smbacl.c
rename to fs/ksmbd/smbacl.c
diff --git a/fs/cifsd/smbacl.h b/fs/ksmbd/smbacl.h
similarity index 100%
rename from fs/cifsd/smbacl.h
rename to fs/ksmbd/smbacl.h
diff --git a/fs/cifsd/smbfsctl.h b/fs/ksmbd/smbfsctl.h
similarity index 100%
rename from fs/cifsd/smbfsctl.h
rename to fs/ksmbd/smbfsctl.h
diff --git a/fs/cifsd/smbstatus.h b/fs/ksmbd/smbstatus.h
similarity index 100%
rename from fs/cifsd/smbstatus.h
rename to fs/ksmbd/smbstatus.h
diff --git a/fs/cifsd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
similarity index 100%
rename from fs/cifsd/transport_ipc.c
rename to fs/ksmbd/transport_ipc.c
diff --git a/fs/cifsd/transport_ipc.h b/fs/ksmbd/transport_ipc.h
similarity index 100%
rename from fs/cifsd/transport_ipc.h
rename to fs/ksmbd/transport_ipc.h
diff --git a/fs/cifsd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
similarity index 100%
rename from fs/cifsd/transport_rdma.c
rename to fs/ksmbd/transport_rdma.c
diff --git a/fs/cifsd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
similarity index 100%
rename from fs/cifsd/transport_rdma.h
rename to fs/ksmbd/transport_rdma.h
diff --git a/fs/cifsd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
similarity index 100%
rename from fs/cifsd/transport_tcp.c
rename to fs/ksmbd/transport_tcp.c
diff --git a/fs/cifsd/transport_tcp.h b/fs/ksmbd/transport_tcp.h
similarity index 100%
rename from fs/cifsd/transport_tcp.h
rename to fs/ksmbd/transport_tcp.h
diff --git a/fs/cifsd/unicode.c b/fs/ksmbd/unicode.c
similarity index 100%
rename from fs/cifsd/unicode.c
rename to fs/ksmbd/unicode.c
diff --git a/fs/cifsd/unicode.h b/fs/ksmbd/unicode.h
similarity index 100%
rename from fs/cifsd/unicode.h
rename to fs/ksmbd/unicode.h
diff --git a/fs/cifsd/uniupr.h b/fs/ksmbd/uniupr.h
similarity index 100%
rename from fs/cifsd/uniupr.h
rename to fs/ksmbd/uniupr.h
diff --git a/fs/cifsd/vfs.c b/fs/ksmbd/vfs.c
similarity index 100%
rename from fs/cifsd/vfs.c
rename to fs/ksmbd/vfs.c
diff --git a/fs/cifsd/vfs.h b/fs/ksmbd/vfs.h
similarity index 100%
rename from fs/cifsd/vfs.h
rename to fs/ksmbd/vfs.h
diff --git a/fs/cifsd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
similarity index 100%
rename from fs/cifsd/vfs_cache.c
rename to fs/ksmbd/vfs_cache.c
diff --git a/fs/cifsd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
similarity index 100%
rename from fs/cifsd/vfs_cache.h
rename to fs/ksmbd/vfs_cache.h
-- 
2.17.1

