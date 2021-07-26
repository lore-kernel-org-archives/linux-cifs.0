Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F02AC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 21:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E29C60F5A
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 21:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhGZUuX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jul 2021 16:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhGZUuW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jul 2021 16:50:22 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16989C061764;
        Mon, 26 Jul 2021 14:30:50 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l4so13067987ljq.4;
        Mon, 26 Jul 2021 14:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kpuJ/WYdNgBF49P4pvJR+hAZ0dbtc1c7btf843eJJ7E=;
        b=Zt7DdGvBoweu6MBfcyH+hBJK8vj3/8u/Po1LN2cF3xCd8mME/9trzn1xNsKDRRkZBD
         qAnCpTR3t2I+l0h8D4hpJFC1YzOjki425pCtnaJE9PUjMD4NuHsCdyRoqA/NSy9P0FmD
         p0lc0fX3N68pWi4MZ7SvTtWJh4v5wixGrYmpZYvinwaVFbnJV/7yeCL5ahRIu2v5ESlC
         0lr/C7Tx73CYeOsuwsSS33dw9UIiTfaHkvczfxmx/ArpPR/Wgz5u5zNpI0kj7ifd1aOE
         x28VQlE0/rQanhMJj9qcsHvNZ21HIabhOaRqKqITK5UjT9xCoWOLqYACBY9haq0Pih0l
         XjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kpuJ/WYdNgBF49P4pvJR+hAZ0dbtc1c7btf843eJJ7E=;
        b=EZYcAfHRMx3ksAcjYmURnMreWFyZBCqyZPjq2BhJAA0h2xLogCNlEd+2g2InBA4sNP
         Dq9YHZem85a06/XfqkE69wttfCbPWH7i3VWEUQZK5EqT4OmO9Q48B21GAXN37dYmAE/1
         TdBVEIRRRND2CVhkpdUTREXce0b27l1CpbeYab7M2+dd/+kGjtdq+paRaoSiR9iXw5/K
         1druVT95ZfZr6D6kDGZOeadD2oSoZa8+QI0ZdE7VEZzlD+tXXZ3abyZayEwBqUOBCUai
         jMCcngO58nbyWnWteMXQirzFVGjPOUHtQO9qoWsD1XAs85YU0gDDLeHBlStqgaLFOZuU
         mxMQ==
X-Gm-Message-State: AOAM530ptSyZOphh6fkpOm8Q4LjhfUQUh05eGO1mPK3ddQt8sDQ85TjV
        Ygq4QMDGPWQ4BzcsujQABRN6rre0o6q40HbBeUJ8JvO2DdTugw==
X-Google-Smtp-Source: ABdhPJy//VhnptTN3eecns5pTN+j2wwiJ9Ta6JW9Q7Ks7+3wqZ909Cjz+w87L7eg9XMp5vpy144fx8Ag3DbC5dK69MA=
X-Received: by 2002:a2e:b4ac:: with SMTP id q12mr13799593ljm.477.1627335048270;
 Mon, 26 Jul 2021 14:30:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jul 2021 16:30:36 -0500
Message-ID: <CAH2r5mv-HDPQ0XUTsH8e8xVJtfgcB12i=Yk1RiHZo2EJUOQHFQ@mail.gmail.com>
Subject: [PATCH][SMB3] fix static analysis warning in smb3_simple_fallocate_write_range
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000007bb15405c80d77ee"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007bb15405c80d77ee
Content-Type: text/plain; charset="UTF-8"

    Clang detected a problem with rc possibly being unitialized
    (when length is zero) in a recently added fallocate code path.

    Reported-by: kernel test robot <lkp@intel.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 23d6f4d71649..2dfd0d8297eb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3617,7 +3617,8 @@ static int
smb3_simple_fallocate_write_range(unsigned int xid,
                                             char *buf)
 {
        struct cifs_io_parms io_parms = {0};
-       int rc, nbytes;
+       int nbytes;
+       int rc = 0;
        struct kvec iov[2];

        io_parms.netfid = cfile->fid.netfid;


-- 
Thanks,

Steve

--0000000000007bb15405c80d77ee
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-rc-uninitialized-in-one-fallocate-path.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-rc-uninitialized-in-one-fallocate-path.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krl58j6k0>
X-Attachment-Id: f_krl58j6k0

RnJvbSA1M2FmM2NjOGYxMGYwYTAzNTZhYmQ2Njc2MDI4ZTE4N2NlNTA3Njg5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjYgSnVsIDIwMjEgMTY6MjI6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiByYyB1bmluaXRpYWxpemVkIGluIG9uZSBmYWxsb2NhdGUgcGF0aAoKQ2xhbmcgZGV0ZWN0
ZWQgYSBwcm9ibGVtIHdpdGggcmMgcG9zc2libHkgYmVpbmcgdW5pdGlhbGl6ZWQKKHdoZW4gbGVu
Z3RoIGlzIHplcm8pIGluIGEgcmVjZW50bHkgYWRkZWQgZmFsbG9jYXRlIGNvZGUgcGF0aC4KClJl
cG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4KU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21i
Mm9wcy5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5j
CmluZGV4IDIzZDZmNGQ3MTY0OS4uMmRmZDBkODI5N2ViIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMzYxNyw3ICszNjE3LDggQEAgc3Rh
dGljIGludCBzbWIzX3NpbXBsZV9mYWxsb2NhdGVfd3JpdGVfcmFuZ2UodW5zaWduZWQgaW50IHhp
ZCwKIAkJCQkJICAgICBjaGFyICpidWYpCiB7CiAJc3RydWN0IGNpZnNfaW9fcGFybXMgaW9fcGFy
bXMgPSB7MH07Ci0JaW50IHJjLCBuYnl0ZXM7CisJaW50IG5ieXRlczsKKwlpbnQgcmMgPSAwOwog
CXN0cnVjdCBrdmVjIGlvdlsyXTsKIAogCWlvX3Bhcm1zLm5ldGZpZCA9IGNmaWxlLT5maWQubmV0
ZmlkOwotLSAKMi4zMC4yCgo=
--0000000000007bb15405c80d77ee--
