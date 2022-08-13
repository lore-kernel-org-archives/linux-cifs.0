Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D34BC19F2D
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Aug 2022 22:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiHMW1j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Aug 2022 18:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiHMW1i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Aug 2022 18:27:38 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8A16110F
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 15:27:36 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id j2so4066716vsp.1
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 15:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=oELi/Z8DAoqcgLpTP7kO/VVanB8m/Pw8kI597FUWI2M=;
        b=GZMv1NZz6PFgNuyPMK8+VM3bx8yV7gRJeypWipGZ+5vje+ny0taPRbNfPDHZH9tY72
         gq4NUTNlZa+bEXvJCilwJ4GXLOiAVWoV+2KWOnaSfl+qq08M2meVJyuKiQAT4bbPluy5
         q2/IabJ4NQLM8fOZiNfroZUSy8TblCA6b03nfEK6qFOob8Rbqr0LgkuPi1XEm078i5SM
         UGH3//LEkjYiA2IgWWm99PPYrX2TYTl9PSk6RP4o7Ycq3l3RQTSPmtpVLHxHwiJ6nDex
         2ecjiCRQmVA9RC2YUM/a2wdZmKmo7goJCvzrs4+nw49Whjg/npABx5FCczwz9FQOiifo
         bHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=oELi/Z8DAoqcgLpTP7kO/VVanB8m/Pw8kI597FUWI2M=;
        b=z8VlnaiL2GmSzXhj2WLG/FEplDJ8SH6sPaYZL2Lz6m+o9/UVWhtsJ71Yy0sZjVSoVi
         0NpXKzEi7tlhixkoWwLj91P3XR/iOEnKUkmWT5858gXUWLykwFrG8gYJ1oxzg33bMKNR
         0mpVKaKRKDwKS/zRhD45bTjkJzjoX0+VN6v2b0IWDIeoU9VQ2XqMwR+Oz56dhjRAQUcb
         cwjZo0lELUvkJRErNkKiw+AiHvAO8FVXJW4JtQ84zYopTFc1oxc5mmXICYxDBGxs4D8Q
         lG8yWB5PCemew4liwKvAfo++iUU1UywZIY5QOv5lOmG/dvd+M9abI1Ig34UzoV6MI5S9
         AMDw==
X-Gm-Message-State: ACgBeo0VyFdvYWvHh0rlGdJEbAtIZUrfVXrPTIWW/kA/Vjze6p6XgNzi
        7nYhuFJnlp18CRxx7hXFzasUwSOBKRngBC1IV0xlP2YYCLwYUg==
X-Google-Smtp-Source: AA6agR5/qslwoEn2FWISGKdIgLLDuMOr1tyEkjy/454mGn/fainTvE/+rdPy/g4T0ANGo8rzkDQJtMcn6DIbRDt46Pk=
X-Received: by 2002:a67:ca83:0:b0:374:ab95:ed82 with SMTP id
 a3-20020a67ca83000000b00374ab95ed82mr3945043vsl.60.1660429655761; Sat, 13 Aug
 2022 15:27:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Aug 2022 17:27:25 -0500
Message-ID: <CAH2r5mtrtLZSuSY3=kQfQ7i-Y_eAzTpxaRubJxA6gMCXYxWMaA@mail.gmail.com>
Subject: two "maintainerless" files
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ce8ab005e626e774"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ce8ab005e626e774
Content-Type: text/plain; charset="UTF-8"

I noticed a report showing hundreds of files without a maintainer
listed, including two that relate to cifs.ko.

include/uapi/linux/cifs/cifs_netlink.h
include/uapi/linux/cifs/cifs_mount.h

One of them was written by Samuel for the witness protocol work.

We could simply add "include/uapi/linux/cifs" to the MAINTAINERS file.

See attached patch

-- 
Thanks,

Steve

--000000000000ce8ab005e626e774
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-directory-in-MAINTAINERS-file.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-directory-in-MAINTAINERS-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6sgxfjj0>
X-Attachment-Id: f_l6sgxfjj0

RnJvbSAyN2EzODUyOGRjZTM4ZTkwZmE0N2FlODMwMjNlZGRmZjUzNDMzOGNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTMgQXVnIDIwMjIgMTc6MjI6MTEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIGRpcmVjdG9yeSBpbiBNQUlOVEFJTkVSUyBmaWxlCgpUaGUgaW5jbHVkZS91
YXBpL2xpbnV4L2NpZnMgZGlyZWN0b3J5IChub3QganVzdCBmcy9jaWZzIGFuZApmcy9zbWJmc19j
b21tb24pIHNob3VsZCBiZSBpbmNsdWRlZCBpbiBjaWZzIGVudHJ5IGluIHRoZQpNQUlOVEFJTkVS
UyBmaWxlLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIE1BSU5UQUlORVJTIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykKCmRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTCmluZGV4IGViM2QxMGZh
M2VlZC4uMWEzYWE3NzQxM2RlIDEwMDY0NAotLS0gYS9NQUlOVEFJTkVSUworKysgYi9NQUlOVEFJ
TkVSUwpAQCAtNTA2OCw2ICs1MDY4LDcgQEAgVDoJZ2l0IGdpdDovL2dpdC5zYW1iYS5vcmcvc2Zy
ZW5jaC9jaWZzLTIuNi5naXQKIEY6CURvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy8KIEY6
CWZzL2NpZnMvCiBGOglmcy9zbWJmc19jb21tb24vCitGOglpbmNsdWRlL3VhcGkvbGludXgvY2lm
cwogCiBDT01QQUNUUENJIEhPVFBMVUcgQ09SRQogTToJU2NvdHQgTXVycmF5IDxzY290dEBzcGl0
ZWZ1bC5vcmc+Ci0tIAoyLjM0LjEKCg==
--000000000000ce8ab005e626e774--
