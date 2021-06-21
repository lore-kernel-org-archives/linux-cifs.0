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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9566C4743C
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Jun 2021 21:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C056B6128E
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Jun 2021 21:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhFUVe2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Jun 2021 17:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhFUVe1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Jun 2021 17:34:27 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CDEC061574;
        Mon, 21 Jun 2021 14:32:13 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id f13so72590ljp.10;
        Mon, 21 Jun 2021 14:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XttW2DB5Vb9m+WTM2zdPl5AyA493GBkpUm0PN3ByhPM=;
        b=rUfqdcYZammBUrDpi4PoGjfb31cugOE7LvirnXnv+GIxcaUnG3w9zOJ604Ixzfs2SG
         y399ErsivItDWV57S32AzLmX6zCzi7EasoNbN0Fe8pKy5JIwSGuOXhsY6XIfIPQ6woSl
         ReKQa4oQ+2eo0epISX/RoA3y0QlXIPk//drUdgAnbgKxq2fKNO+eBZSZgiebDe1TkrKI
         vccM4wy515ts297PVue+3KEjhO/21oPCudUKI5WL4OPHXBO5nlpViyh+opnwQR3S5mSC
         ETWkid5bbudJ9Ak1TzgsOy6AFN2+LkkZptm0OahiILvNM4O/3THH2LjL1NgJm2bf0wod
         7/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XttW2DB5Vb9m+WTM2zdPl5AyA493GBkpUm0PN3ByhPM=;
        b=NqLfWpzGZK7VLqgL90FGQVqEZWyUgu8YJ8n6ORKmaondeBeZ9BJlQlIyHYQTNElX0L
         ER4XV3ra8lIU49SIreA3yP0cUBN8NlWkcLbvAv0LieCv6gpA8DCGf7qaoKA4c6cIlmv7
         W5Vpjbn9MXr8nUIwszTDo77/VoPk6vmcdm1kt2mfQvvHWdN6XBiRvAGoJNEsb8KRLoi1
         efNUNVy62k6SJ39OOrbppIxvjx2RX8mS1hkfLBTwqY5qzPDji4xhfutgidZrSit4+Bvl
         MTyS+Vnu9VthepYNIBa/IuELdtNqJ2f0XWjp8q2GphHDTHJY7xfFOmoOq8nB68vIHfn+
         Q46Q==
X-Gm-Message-State: AOAM533Hl6eYfhzWilu7TZYvhgU0vHQ1XwV5hGv7tsDzibFfX/NNh9k4
        27PUf56ffdyZygRI0FzrnGp3mzpfDfYxMUNhsJg=
X-Google-Smtp-Source: ABdhPJzQYy8Zv2CoT4+5jf+Ljt9HmhtwZp1c4bIUyBIO+4vf8Ela55EiC0s0gJecmfdGTLXQhmsvO2O/+kTDAQ0FLDA=
X-Received: by 2002:a05:651c:10b9:: with SMTP id k25mr227755ljn.256.1624311131260;
 Mon, 21 Jun 2021 14:32:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 21 Jun 2021 16:32:00 -0500
Message-ID: <CAH2r5msOSLaZT42-jFMjJrB1YiYTZBzdM18ieqQY2v=YwXzcrA@mail.gmail.com>
Subject: [SMBDIRECT][PATCH] missing rc checks while waiting for SMB3 over RDMA events
To:     Long Li <longli@microsoft.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000fbdd3d05c54d677d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fbdd3d05c54d677d
Content-Type: text/plain; charset="UTF-8"

    There were two places where we weren't checking for error
    (e.g. ERESTARTSYS) while waiting for rdma resolution.

    Addresses-Coverity: 1462165 ("Unchecked return value")
   Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 10dfe5006792..ae07732f750f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -572,8 +572,11 @@ static struct rdma_cm_id *smbd_create_id(
                log_rdma_event(ERR, "rdma_resolve_addr() failed %i\n", rc);
                goto out;
        }
-       wait_for_completion_interruptible_timeout(
+       rc = wait_for_completion_interruptible_timeout(
                &info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+       /* -ERESTARTSYS, returned when interrupted, is the only rc mentioned */
+       if (rc < 0)
+               goto out;
        rc = info->ri_rc;
        if (rc) {
                log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
@@ -586,8 +589,10 @@ static struct rdma_cm_id *smbd_create_id(
                log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
                goto out;
        }
-       wait_for_completion_interruptible_timeout(
+       rc = wait_for_completion_interruptible_timeout(
                &info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+       if (rc < 0)  /* e.g. if interrupted and returns -ERESTARTSYS */
+               goto out
        rc = info->ri_rc;
        if (rc) {
                log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);


-- 
Thanks,

Steve

--000000000000fbdd3d05c54d677d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbdirect-missing-rc-checks-while-waiting-for-rdma-e.patch"
Content-Disposition: attachment; 
	filename="0001-smbdirect-missing-rc-checks-while-waiting-for-rdma-e.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq74wddw0>
X-Attachment-Id: f_kq74wddw0

RnJvbSA5YmY0MmNhZWI5NWQ4YTViZjY3MjM0OGU1ZGViYTU4M2Y4MjMzNzEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjEgSnVuIDIwMjEgMTY6MjU6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJkaXJlY3Q6IG1pc3NpbmcgcmMgY2hlY2tzIHdoaWxlIHdhaXRpbmcgZm9yIHJkbWEgZXZlbnRz
CgpUaGVyZSB3ZXJlIHR3byBwbGFjZXMgd2hlcmUgd2Ugd2VyZW4ndCBjaGVja2luZyBmb3IgZXJy
b3IKKGUuZy4gRVJFU1RBUlRTWVMpIHdoaWxlIHdhaXRpbmcgZm9yIHJkbWEgcmVzb2x1dGlvbi4K
CkFkZHJlc3Nlcy1Db3Zlcml0eTogMTQ2MjE2NSAoIlVuY2hlY2tlZCByZXR1cm4gdmFsdWUiKQpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQog
ZnMvY2lmcy9zbWJkaXJlY3QuYyB8IDkgKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iZGlyZWN0
LmMgYi9mcy9jaWZzL3NtYmRpcmVjdC5jCmluZGV4IDEwZGZlNTAwNjc5Mi4uYWUwNzczMmY3NTBm
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYmRpcmVjdC5jCisrKyBiL2ZzL2NpZnMvc21iZGlyZWN0
LmMKQEAgLTU3Miw4ICs1NzIsMTEgQEAgc3RhdGljIHN0cnVjdCByZG1hX2NtX2lkICpzbWJkX2Ny
ZWF0ZV9pZCgKIAkJbG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX2FkZHIoKSBmYWls
ZWQgJWlcbiIsIHJjKTsKIAkJZ290byBvdXQ7CiAJfQotCXdhaXRfZm9yX2NvbXBsZXRpb25faW50
ZXJydXB0aWJsZV90aW1lb3V0KAorCXJjID0gd2FpdF9mb3JfY29tcGxldGlvbl9pbnRlcnJ1cHRp
YmxlX3RpbWVvdXQoCiAJCSZpbmZvLT5yaV9kb25lLCBtc2Vjc190b19qaWZmaWVzKFJETUFfUkVT
T0xWRV9USU1FT1VUKSk7CisJLyogLUVSRVNUQVJUU1lTLCByZXR1cm5lZCB3aGVuIGludGVycnVw
dGVkLCBpcyB0aGUgb25seSByYyBtZW50aW9uZWQgKi8KKwlpZiAocmMgPCAwKQorCQlnb3RvIG91
dDsKIAlyYyA9IGluZm8tPnJpX3JjOwogCWlmIChyYykgewogCQlsb2dfcmRtYV9ldmVudChFUlIs
ICJyZG1hX3Jlc29sdmVfYWRkcigpIGNvbXBsZXRlZCAlaVxuIiwgcmMpOwpAQCAtNTg2LDggKzU4
OSwxMCBAQCBzdGF0aWMgc3RydWN0IHJkbWFfY21faWQgKnNtYmRfY3JlYXRlX2lkKAogCQlsb2df
cmRtYV9ldmVudChFUlIsICJyZG1hX3Jlc29sdmVfcm91dGUoKSBmYWlsZWQgJWlcbiIsIHJjKTsK
IAkJZ290byBvdXQ7CiAJfQotCXdhaXRfZm9yX2NvbXBsZXRpb25faW50ZXJydXB0aWJsZV90aW1l
b3V0KAorCXJjID0gd2FpdF9mb3JfY29tcGxldGlvbl9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQoCiAJ
CSZpbmZvLT5yaV9kb25lLCBtc2Vjc190b19qaWZmaWVzKFJETUFfUkVTT0xWRV9USU1FT1VUKSk7
CisJaWYgKHJjIDwgMCkgIC8qIGUuZy4gaWYgaW50ZXJydXB0ZWQgYW5kIHJldHVybnMgLUVSRVNU
QVJUU1lTICovCisJCWdvdG8gb3V0CiAJcmMgPSBpbmZvLT5yaV9yYzsKIAlpZiAocmMpIHsKIAkJ
bG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX3JvdXRlKCkgY29tcGxldGVkICVpXG4i
LCByYyk7Ci0tIAoyLjMwLjIKCg==
--000000000000fbdd3d05c54d677d--
