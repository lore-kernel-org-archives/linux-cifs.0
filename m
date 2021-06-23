Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAAEC2B9F4
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 01:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F97661166
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 01:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFWBUV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBUU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 21:20:20 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A9C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 18:18:03 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p7so1323009lfg.4
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 18:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=07FgMVo6gbZ16ocf7Rsp/dQ4TFHeb86K0zNpFrg/quU=;
        b=t0ZGr7xRMrF2oIengY35iXBGWFzBt+ueM3w51Dnalesg0rFsZL2Qv4tCbvn+LMlmzU
         44s4Xhl09KyKSYsYMvVUSyt0FjVbQTL+gy2bMMdT6SNqDCnOFlLWQy+Uhj2/nUqZMJ19
         OWO7uV8YkRA+uvcMAMk2uYZadkIRaNNxyGFddSQwlmU9341nevn7+sD5ddQmfLneXxMO
         5DP2tcZ9MjH9WigehImJ8XVsGoq/EGTX4aEDX6d2FuSSpt78S6U9F+FaJ65WIm5ZosZY
         tgBrA9o8TG567oH9BkSjbU1ODEYmFU0pJFPZRqEGQC6TMqhY6PM5P0kW1VMSYocaUfRn
         kk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=07FgMVo6gbZ16ocf7Rsp/dQ4TFHeb86K0zNpFrg/quU=;
        b=Sd/XJWHMd/mTAXI1fhj0kPCictKyPvcLrZP/CWVgfiXIW0hP++JqE4EGR/ILWvXRuL
         L4hQbDzWpMniDGgBLUqloNCsDhGU+oCUNi8lGmfSY7J7CZVyzkqhO1SEf6m99U0bejbQ
         PHNW+VxtqRPHVkmTLYHg7jAorBWErVggWaftQmTONofeh14Ke6g9t3txiAVfNE1MwUhO
         vEWhGEcv7ehBK/wfD7CiOZbtQlRV1FPi8pMHe5Ba8bJjSw2q2GcDUjWSRS7CqbdLto98
         OoULYGBnm+zCfTws+nj7lKRbVG7IQ5lfquFOO9p6Od0WpCeiRI+lkqWdMG4NVfPWlCUV
         Uc/w==
X-Gm-Message-State: AOAM530+UBfw/crRWZk7bSDXqxMSSDR36vefCwZ8fL0eR5t+8SSePGEz
        TnkcTfyt0TgzSSdZBOgt1yUrpgdtGmzvPx7PwRUJl7toOmWqwQ==
X-Google-Smtp-Source: ABdhPJw5JIuUdl/XgRzme7sbDzEeYgweu9+v5bZrsTyWaeRsCnvgN+6oZxvqgnVzDk4RFDeXshGaEbGRXok+IzQKUEg=
X-Received: by 2002:ac2:419a:: with SMTP id z26mr5024151lfh.307.1624411081257;
 Tue, 22 Jun 2021 18:18:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 20:17:50 -0500
Message-ID: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
Subject: [PATCH] cifs: missing null pointer check in cifs_mount
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000077d19b05c564adc6"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000077d19b05c564adc6
Content-Type: text/plain; charset="UTF-8"

We weren't checking if tcon is null before setting dfs path,
although we check for null tcon in an earlier assignment statement.

Addresses-Coverity: 1476411 ("Dereference after null check")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d95607a9312..196ef9ec69db 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3480,7 +3480,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
struct smb3_fs_context *ctx)
  goto error;
  }
  spin_lock(&cifs_tcp_ses_lock);
- tcon->dfs_path = ref_path;
+ if (tcon)
+ tcon->dfs_path = ref_path;
  ref_path = NULL;
  spin_unlock(&cifs_tcp_ses_lock);


-- 
Thanks,

Steve

--00000000000077d19b05c564adc6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-null-pointer-check-in-cifs_mount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-null-pointer-check-in-cifs_mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq8senbd0>
X-Attachment-Id: f_kq8senbd0

RnJvbSA2MzIwOTZiNjZiMmZhMjYyMWUzZDJkMDJjMmMyZmQ0MzY5NzU4MTBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjIgSnVuIDIwMjEgMjA6MTM6NDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIG51bGwgcG9pbnRlciBjaGVjayBpbiBjaWZzX21vdW50CgpXZSB3ZXJlbid0
IGNoZWNraW5nIGlmIHRjb24gaXMgbnVsbCBiZWZvcmUgc2V0dGluZyBkZnMgcGF0aCwKYWx0aG91
Z2ggd2UgY2hlY2sgZm9yIG51bGwgdGNvbiBpbiBhbiBlYXJsaWVyIGFzc2lnbm1lbnQgc3RhdGVt
ZW50LgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxNDc2NDExICgiRGVyZWZlcmVuY2UgYWZ0ZXIgbnVs
bCBjaGVjayIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0
LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA4ZDk1NjA3YTkzMTIuLjE5NmVmOWVjNjlkYiAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAg
LTM0ODAsNyArMzQ4MCw4IEBAIGludCBjaWZzX21vdW50KHN0cnVjdCBjaWZzX3NiX2luZm8gKmNp
ZnNfc2IsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAkJZ290byBlcnJvcjsKIAl9CiAJ
c3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7Ci0JdGNvbi0+ZGZzX3BhdGggPSByZWZfcGF0
aDsKKwlpZiAodGNvbikKKwkJdGNvbi0+ZGZzX3BhdGggPSByZWZfcGF0aDsKIAlyZWZfcGF0aCA9
IE5VTEw7CiAJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAotLSAKMi4zMC4yCgo=
--00000000000077d19b05c564adc6--
