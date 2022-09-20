Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ED7C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 04:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiITELv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiITELu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 00:11:50 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BA2501B6
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:11:49 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id p17so576869uao.11
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=SC+zqmDrKvv6sV8VV1BrdiZotLVKkiOteLCZ9hm2YDo=;
        b=JSmjV1vbovTrSqW2USaKvI3yY3fAJjpMqXrWzmLmSGR5oXc54IvdU+8qyczSjKWMVF
         +iDAqAkyvvuBEtfoEOsb9NSMggS+IdHHzaIlForil05VAeE/LG+a8Z9KGdOV0PLj03vT
         e4mGHB9tLWCBomIvL6glVgbeUmOSxBw83w+KQCj0H20dDXwKia6DTeMJbvrYyYbc16g9
         ePaWkBuK6pc9hHMSVoKixsCoYDY+uH1hqWXQvSABWUalGGfmkqHVoDpR0BQ0nGJ1dUX4
         Po88+CN2GCC1CMfv8ouvj4vQQ8b90hgnCmZ5Scx5LKXDG+sbF2hitp9Evionm3/AACoN
         moDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=SC+zqmDrKvv6sV8VV1BrdiZotLVKkiOteLCZ9hm2YDo=;
        b=Ai4v2XIkneju1fZgASI33WcQGv8qRG47Hn46YGqOoc2Py/zXFsFa5nWgDlxv3pfjGh
         /Ec5cGrOqvjmmpXRx8FUKhcvygFzXELjnzvRPMWERIn6YvRZbJ29cu3K9DkXbRUbCgcQ
         cnAE8GVFDfE1FKquvZA+uXSP6Eh4IMCSQxYltckNzMR/gyY0M6EVJYK730Yl3cT2s6QG
         9YlST89SwU7OboqDf7zQyIJgWhafbjCG18K8Gbjg+q+aaJ3IJzGC661UQhrcYSmrwewd
         d+sgFP/bdSvc2AqpQOtvX033nxK0cWE7emt1wiwr+HTaJBsp31VPBeJcC1i2SdKZaSqO
         aThw==
X-Gm-Message-State: ACrzQf2ndvmGkN0nKXzfGQNLVQe9rH7QIEPREKKM6O/dyd3WBFNYpiCP
        j7oH1n+KOlxkfPPo8EPHpG0GLlGUYxgrcPnRbehlCeB3
X-Google-Smtp-Source: AMsMyM40gkhVetWFsRvHMd02k+estg3l9uR4q5xQCpbnFVYIWPo8/SG+lARL4U0u0+1e9dlJ/qrVTInGi7Iow685Hbk=
X-Received: by 2002:a9f:3f0a:0:b0:3bf:173d:13d with SMTP id
 h10-20020a9f3f0a000000b003bf173d013dmr3196712uaj.81.1663647108469; Mon, 19
 Sep 2022 21:11:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Sep 2022 23:11:37 -0500
Message-ID: <CAH2r5mt-jYkgr+YBUitbj+hsx1pwdbA43ZqV+uLWmQZE=MPn4A@mail.gmail.com>
Subject: [MAINTAINERS][PATCH] Add Tom Talpey as reviewer
To:     Tom Talpey <ttalpey@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000eeac4605e91406e0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000eeac4605e91406e0
Content-Type: text/plain; charset="UTF-8"

Tom has been reviewing/contributing a lot for RDMA/smbdirect so note
that in the MAINTAINERS file for cifs.ko as well

-- 
Thanks,

Steve

--000000000000eeac4605e91406e0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-MAINTAINERS-Add-Tom-Talpey-as-cifs.ko-reviewer.patch"
Content-Disposition: attachment; 
	filename="0001-MAINTAINERS-Add-Tom-Talpey-as-cifs.ko-reviewer.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l89oiyjb0>
X-Attachment-Id: f_l89oiyjb0

RnJvbSBmOTgxNTcxMDY1NTk0YTQ5MmY0MzZhOGE4M2M4NTg2ZGIwZGMyMzU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTkgU2VwIDIwMjIgMjM6MDg6MDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBN
QUlOVEFJTkVSUzogQWRkIFRvbSBUYWxwZXkgYXMgY2lmcy5rbyByZXZpZXdlcgoKSGUgaGFzIGJl
ZW4gYWN0aXZlbHkgcmV2aWV3aW5nIGFuZCBzdWJtaXR0aW5nIHBhdGNoZXMsCmVzcGVjaWFsbHkg
Zm9yIHNtYmRpcmVjdCAoUkRNQSkgc28gYWRkIGhpbQphcyBhIHJldmlld2VyIGZvciBjaWZzLmtv
CgpBY2tlZC1ieTogVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBNQUlOVEFJTkVSUyB8IDEg
KwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5F
UlMgYi9NQUlOVEFJTkVSUwppbmRleCA5YWU5ODliMzJlYmIuLjlkY2U0OWQ3YzI5NCAxMDA2NDQK
LS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTUxMzksNiArNTEzOSw3IEBA
IE06CVN0ZXZlIEZyZW5jaCA8c2ZyZW5jaEBzYW1iYS5vcmc+CiBSOglQYXVsbyBBbGNhbnRhcmEg
PHBjQGNqci5uej4gKERGUywgZ2xvYmFsIG5hbWUgc3BhY2UpCiBSOglSb25uaWUgU2FobGJlcmcg
PGxzYWhsYmVyQHJlZGhhdC5jb20+IChkaXJlY3RvcnkgbGVhc2VzLCBzcGFyc2UgZmlsZXMpCiBS
OglTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPiAobXVsdGljaGFubmVsKQor
UjoJVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+IChSRE1BLCBzbWJkaXJlY3QpCiBMOglsaW51
eC1jaWZzQHZnZXIua2VybmVsLm9yZwogTDoJc2FtYmEtdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9y
ZyAobW9kZXJhdGVkIGZvciBub24tc3Vic2NyaWJlcnMpCiBTOglTdXBwb3J0ZWQKLS0gCjIuMzQu
MQoK
--000000000000eeac4605e91406e0--
