Return-Path: <SRS0=aqf3=AT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8894FC433E0
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 04:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616EF20774
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 04:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ak1epF1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGHErS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jul 2020 00:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHErR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jul 2020 00:47:17 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF6BC061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 21:47:17 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g6so1716414ybo.11
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2020 21:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=t1zm4rFoTNNHC3eGsKGD6Fgub/4GaFQ3Ds768gV+HuM=;
        b=ak1epF1VAW1EBVYLvTEpSPZ5Yjonre4LZpvDGD5Bs6k9n7giPywAO3QnlkuTz89zsj
         T+qPQe4gXsjCmSRGlP1TfJmw4xFaCK4jwBd1PRh1BavDZY24XvQehmQ18sDaVHmc7KKf
         azGwWS/zy8Z9AokRA/Y3P2wvQkRN0V1JznLYvlDpshPZFGoYilfVfHX3dbdQqV4BoKfV
         rIT4gUjAqHPTSBRM8tRkq7zbwzcNRbPXEqUZPD0/DmRl2XQgfcKWrG8aSzw3lbSPxq3T
         CsdmFq2Ln2kWj277dbl3Nwu2+TVpY8wk/i31jBs0CijbQv/Tf5H9IOSV1ugK1m5FwFhL
         4wUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=t1zm4rFoTNNHC3eGsKGD6Fgub/4GaFQ3Ds768gV+HuM=;
        b=p05Ure2xVQ3wNf2+W33zacIsWM2WSHN3qKAxq1FWjMZPcAL1eJY0t7pbpGaXPuHsZp
         ONcTwovqOMXFVJ1DGFruptfCotyrXbUhhT6LNkKgFl0ISSrErWu1ZrSRjsINIfLo0Jvo
         qaKpIdyMdZU6J2tZfBZza6Lvca6VyTzfUcASkAgm2DXTYAbUZCE+MZslUQlAAO1lLtBu
         uPNXVl6u8UmQL1O0Irg+860T8bmPlJ1RELxbrrdFVrlFtj3DqO5y8tQsO056MGzuD9eK
         K6mnt4AbPymp0U9AX/KsYwJkjQhzv7Tz11FfH4hRuoJmIEouNNNmCJzFY6baiEo5UzIq
         E8mA==
X-Gm-Message-State: AOAM532vP9eWYWp1hhyFif/1qI/bdYtEG90TJ1khq+yyyKluRRkwlru7
        tPk/v0EBLC1DXhHC2EJn6+2ke+nZM5pMPxEamZ28BZqB
X-Google-Smtp-Source: ABdhPJzdu4Zcx3BRFbrUHXrwKaD4csW7LhbBKC9TiwQdSUBhuUt90+mw26Rs+Yb80kAvz5UHCo8MIi0ztIy1mU2+VDE=
X-Received: by 2002:a25:bc81:: with SMTP id e1mr88466871ybk.375.1594183636670;
 Tue, 07 Jul 2020 21:47:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 Jul 2020 23:47:05 -0500
Message-ID: <CAH2r5mvVKZn0sNrB2yq-eYBbFN4yN2BCQJT84X5uyKaf=SZ6og@mail.gmail.com>
Subject: [SMB3][PATCH] fix unneeded error message on change notify
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005efb6d05a9e6cd24"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005efb6d05a9e6cd24
Content-Type: text/plain; charset="UTF-8"

Fix the length check on SMB3 change notify



-- 
Thanks,

Steve

--0000000000005efb6d05a9e6cd24
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-unneeded-error-message-on-change-notify.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-unneeded-error-message-on-change-notify.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kccvrm810>
X-Attachment-Id: f_kccvrm810

RnJvbSA1MTc4MzA5MjcxOTg0MmI0NDQzOTI5MDk4YWYxZjg0OGRmNWRiZWIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNyBKdWwgMjAyMCAyMzo0MzozOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCB1bm5lZWRlZCBlcnJvciBtZXNzYWdlIG9uIGNoYW5nZSBub3RpZnkKCldlIHNob3Vs
ZCBub3QgYmUgbG9nZ2luZyBhIHdhcm5pbmcgcmVwZWF0ZWRseSBvbiBjaGFuZ2Ugbm90aWZ5LgoK
Q0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS42KwpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIy
bWlzYy5jIHwgOCArKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtaXNjLmMgYi9mcy9jaWZzL3Nt
YjJtaXNjLmMKaW5kZXggNmEzOTQ1MTk3M2Y4Li4xNTc5OTI4NjRjZTcgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMm1pc2MuYworKysgYi9mcy9jaWZzL3NtYjJtaXNjLmMKQEAgLTM1NCw5ICszNTQs
MTMgQEAgc21iMl9nZXRfZGF0YV9hcmVhX2xlbihpbnQgKm9mZiwgaW50ICpsZW4sIHN0cnVjdCBz
bWIyX3N5bmNfaGRyICpzaGRyKQogCQkgICgoc3RydWN0IHNtYjJfaW9jdGxfcnNwICopc2hkcikt
Pk91dHB1dENvdW50KTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX0NIQU5HRV9OT1RJRlk6CisJCSpv
ZmYgPSBsZTE2X3RvX2NwdSgKKwkJICAoKHN0cnVjdCBzbWIyX2NoYW5nZV9ub3RpZnlfcnNwICop
c2hkciktPk91dHB1dEJ1ZmZlck9mZnNldCk7CisJCSpsZW4gPSBsZTMyX3RvX2NwdSgKKwkJICAo
KHN0cnVjdCBzbWIyX2NoYW5nZV9ub3RpZnlfcnNwICopc2hkciktPk91dHB1dEJ1ZmZlckxlbmd0
aCk7CisJCWJyZWFrOwogCWRlZmF1bHQ6Ci0JCS8qIEJCIEZJWE1FIGZvciB1bmltcGxlbWVudGVk
IGNhc2VzIGFib3ZlICovCi0JCWNpZnNfZGJnKFZGUywgIm5vIGxlbmd0aCBjaGVjayBmb3IgY29t
bWFuZFxuIik7CisJCWNpZnNfZGJnKFZGUywgIm5vIGxlbmd0aCBjaGVjayBmb3IgY29tbWFuZCAl
ZFxuIiwgbGUxNl90b19jcHUoc2hkci0+Q29tbWFuZCkpOwogCQlicmVhazsKIAl9CiAKLS0gCjIu
MjUuMQoK
--0000000000005efb6d05a9e6cd24--
