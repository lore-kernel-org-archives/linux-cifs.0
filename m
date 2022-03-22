Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D13DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Mar 2022 04:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiCVEiW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Mar 2022 00:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiCVEiV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Mar 2022 00:38:21 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8B821E13
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 21:36:52 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id w7so27820356lfd.6
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 21:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tb8ri8QBmlj4Mv65OSHhZ9ER+noruH/06tLtzjpavd0=;
        b=OBL4+2DUrdCbIZ15quBUlonSHOQ7tcXCP0MeFPDJGyTNdXsdmDURV6U6SrvkhlLjS9
         KzGkuHmJHlQKmF5o9b+f5euw1DoPoBcPYatVSew7w1A4ucZLyYji65m5TP4MP4t/kvEV
         c0TfUJM41xFICPaaH24cbp8VuCCZ1OAH2+CSGPT6UPy/EUmbiQcRt5Xv3LnFtxWz7kWR
         scUU+L0r36XuzcgkW5SEYpRt30OhTA/RtiJrgPO18n6GcEcFmcEs7PeaSXNbV+ldD+Qa
         Xap7VYKWVWG3SYl0pLvCp8hT71fnfho/DABTyQ3ZqO/kG1YUAPzAbxsLIkIzD76LSSD3
         EOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tb8ri8QBmlj4Mv65OSHhZ9ER+noruH/06tLtzjpavd0=;
        b=KBSl/yUm7p5c42d7xWSgc1c+CMv6Ktss2owTKwmFGJgCZs0FWo35bqWv6dZHEhdZ9p
         Rh9PQBQ6MVMEL7kUZ+pLOLbxgtbb+p6+G9h8JToA6WEhmK8W1Wa1bltAl1OM2noLQ2y2
         80xe2YgtRHpch5W7CdgiLcJs503uFKAJw7UELBMvUQu9SxZtW4m13nOyTWZp6RZSDkY4
         C+E/PbnP0l+sv/v0N7cC31J2SsitgEBFX+CbwWBlKaHYxeuyVR5N36jCXcDvzCIuPQqM
         hI73+EqJSWZQcSsg1p7ftjW7AQGtkGiDK6IUApr2J1yihlfP7u9JyftwTerZE5zJYaLS
         P0zw==
X-Gm-Message-State: AOAM533gBNfczTcbrtMk0K4bfp7m4Airit6+QO7BYBpfiFjRS+lc5eDJ
        Dk1hLHk5l8vpIjwhqwLHqndyGDVFQu+TsZ/x35Fjr+C73DU=
X-Google-Smtp-Source: ABdhPJwyebPTvZh7+7BydywioHbaHM7Zj0kdlY3DeRrWq8rSFCOo5QpIP80AfWb82lApqs07VuYTYZfPcR2dZitELw8=
X-Received: by 2002:a05:6512:130c:b0:44a:2dd3:91d0 with SMTP id
 x12-20020a056512130c00b0044a2dd391d0mr5214106lfu.234.1647923810713; Mon, 21
 Mar 2022 21:36:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 21 Mar 2022 23:36:39 -0500
Message-ID: <CAH2r5msnSKT5dCMQkc7JWWadqY9HrN7x7EmVA4=NwApnk268hA@mail.gmail.com>
Subject: [PATCH][CIFS] writeback fix
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000005aeb2205dac729de"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005aeb2205dac729de
Content-Type: text/plain; charset="UTF-8"

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=d9a5f40a52016abe765d97d1e57acead9e824a12

   Wait for the page to be written to the cache before we allow it
    to be modified

    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a2723f7cb5e9..cf8642c16e59 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4210,13 +4210,19 @@ cifs_page_mkwrite(struct vm_fault *vmf)
 {
        struct page *page = vmf->page;

+       /* Wait for the page to be written to the cache before we allow it to
+        * be modified.  We then assume the entire page will need writing back.
+        */
 #ifdef CONFIG_CIFS_FSCACHE
        if (PageFsCache(page) &&
            wait_on_page_fscache_killable(page) < 0)
                return VM_FAULT_RETRY;
 #endif

-       lock_page(page);
+       wait_on_page_writeback(page);
+
+       if (lock_page_killable(page) < 0)
+               return VM_FAULT_RETRY;
        return VM_FAULT_LOCKED;
 }

-- 
Thanks,

Steve

--0000000000005aeb2205dac729de
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-cifs-writeback-fix.patch"
Content-Disposition: attachment; filename="0001-cifs-writeback-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l11na2b90>
X-Attachment-Id: f_l11na2b90

RnJvbSBkOWE1ZjQwYTUyMDE2YWJlNzY1ZDk3ZDFlNTdhY2VhZDllODI0YTEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpE
YXRlOiBNb24sIDI0IEphbiAyMDIyIDIzOjE1OjE4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gY2lm
czogd3JpdGViYWNrIGZpeAoKV2FpdCBmb3IgdGhlIHBhZ2UgdG8gYmUgd3JpdHRlbiB0byB0aGUg
Y2FjaGUgYmVmb3JlIHdlIGFsbG93IGl0CnRvIGJlIG1vZGlmaWVkCgpTaWduZWQtb2ZmLWJ5OiBE
YXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9maWxlLmMgfCA4ICsr
KysrKystCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCBhMjcyM2Y3
Y2I1ZTkuLmNmODY0MmMxNmU1OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMv
Y2lmcy9maWxlLmMKQEAgLTQyMTAsMTMgKzQyMTAsMTkgQEAgY2lmc19wYWdlX21rd3JpdGUoc3Ry
dWN0IHZtX2ZhdWx0ICp2bWYpCiB7CiAJc3RydWN0IHBhZ2UgKnBhZ2UgPSB2bWYtPnBhZ2U7CiAK
KwkvKiBXYWl0IGZvciB0aGUgcGFnZSB0byBiZSB3cml0dGVuIHRvIHRoZSBjYWNoZSBiZWZvcmUg
d2UgYWxsb3cgaXQgdG8KKwkgKiBiZSBtb2RpZmllZC4gIFdlIHRoZW4gYXNzdW1lIHRoZSBlbnRp
cmUgcGFnZSB3aWxsIG5lZWQgd3JpdGluZyBiYWNrLgorCSAqLwogI2lmZGVmIENPTkZJR19DSUZT
X0ZTQ0FDSEUKIAlpZiAoUGFnZUZzQ2FjaGUocGFnZSkgJiYKIAkgICAgd2FpdF9vbl9wYWdlX2Zz
Y2FjaGVfa2lsbGFibGUocGFnZSkgPCAwKQogCQlyZXR1cm4gVk1fRkFVTFRfUkVUUlk7CiAjZW5k
aWYKIAotCWxvY2tfcGFnZShwYWdlKTsKKwl3YWl0X29uX3BhZ2Vfd3JpdGViYWNrKHBhZ2UpOwor
CisJaWYgKGxvY2tfcGFnZV9raWxsYWJsZShwYWdlKSA8IDApCisJCXJldHVybiBWTV9GQVVMVF9S
RVRSWTsKIAlyZXR1cm4gVk1fRkFVTFRfTE9DS0VEOwogfQogCi0tIAoyLjMyLjAKCg==
--0000000000005aeb2205dac729de--
