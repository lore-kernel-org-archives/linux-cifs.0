Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38908C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 00:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72FE23731
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 00:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgLQAJY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 19:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgLQAJY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 19:09:24 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE61DC061794
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 16:08:43 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id m12so52962210lfo.7
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 16:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gu3NQNu36tzmGj0i7T+7tFZafUmKExhIseFuVunIBNo=;
        b=JeiC2k5HcHB99piSc0ae5LbAz/RBw8CM4b8qfrXkpVqDY9AcyGLFpkDCaaIE8i0Upx
         DK9m/swW8FClJEEraNHaqhysk6A85tvHit6iUO/szYI654b76wigi7Vyvi845XzwehTT
         G6XzBpbrdnx8WPnfG8hPcsikHy2/9KPCuEwRk0CN+O8Ql12Mn56eIpZgsiUlpCA8AZOe
         S9D2Ufg6sLYiOM4roU1DUubREMbO22HTeDLsSPy2pRC2bQBbdOym5IMY2tx5bm1+WSUK
         csA6p2S/XqPenhQX0u9F2QJu+eABPo3TFquLIv3ACgnig9sL9Ln9VZlhIkybZM374i+y
         4A4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gu3NQNu36tzmGj0i7T+7tFZafUmKExhIseFuVunIBNo=;
        b=tkaWQh5kCQ0/lMbuPWOxoJaphh0x1+tuGxKusE3Hvf+MSpzMH773WwPj+B2szVhMtM
         p/bZmhHyhm8E9144QnK+XkTdTaTTNwn5YmB4Wq6M3y9WbKh5/0NP1xMtZsHNIsuflFQn
         l7aslQR0syb0EyEuDOBovWxsqzPu6aX3EhuhIMUPQGY35wxL/J3mWKxfxDT9T7cIyZ8z
         /XhE0wXckOnT4YtUsMgPF8XgUfBmCgEMU+XAewJHxYpxLLfsNEY7eTqZbn0HAEjqiFoa
         iC5ER7dAfiXYM9wHHL91ZYg20feYCVt91dxncsygFCE4bdDrnq2Vj4n+ZWm3hyBSuphQ
         Gu5A==
X-Gm-Message-State: AOAM533nzztF4wT3KHOyuxmDy5h+0VrZD/QGozIlvIckDnsQhFHLGEhR
        ciM58JPsGO4c1N1iw1wef83q+QxLihXgBJHt1BL9t1S89x8zig==
X-Google-Smtp-Source: ABdhPJyJSgM2+7F0jlzmKn6cH1Mg4Tz+dc+nEhNmxQZI2jAlCR/RlA2ANzrBMWpwKL6z7CdAGU3yJmok3weoWB7hQvs=
X-Received: by 2002:a19:828c:: with SMTP id e134mr8373475lfd.307.1608163721783;
 Wed, 16 Dec 2020 16:08:41 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Dec 2020 18:08:30 -0600
Message-ID: <CAH2r5mv6AXFVQ-QLsKMsYM5zqegf6bmmq=4rbFztj3JiJi_N1g@mail.gmail.com>
Subject: [CIFS][PATCH] Fix support for remount when not changing rsize/wsize
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000060c4b805b69dcb50"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000060c4b805b69dcb50
Content-Type: text/plain; charset="UTF-8"

When remounting with the new mount API, we need to set
rsize and wsize to the previous values if they are not passed
in on the remount. Otherwise they get set to zero which breaks
xfstest 452 for example.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 734b30db580f..0afccbbed2e6 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -707,6 +707,13 @@ static int smb3_reconfigure(struct fs_context *fc)
  STEAL_STRING(cifs_sb, ctx, nodename);
  STEAL_STRING(cifs_sb, ctx, iocharset);

+ /* if rsize or wsize not passed in on remount, use previous values */
+ if (ctx->rsize == 0)
+ ctx->rsize = cifs_sb->ctx->rsize;
+ if (ctx->wsize == 0)
+ ctx->wsize = cifs_sb->ctx->wsize;
+
+
  smb3_cleanup_fs_context_contents(cifs_sb->ctx);
  rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
  smb3_update_mnt_flags(cifs_sb);

-- 
Thanks,

Steve

--00000000000060c4b805b69dcb50
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Fix-support-for-remount-when-not-changing-rsize.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-support-for-remount-when-not-changing-rsize.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kis35dtb0>
X-Attachment-Id: f_kis35dtb0

RnJvbSA5OTRhYmQyN2RiYWU2MDAxNzM5YWI3YmQyMDNlOGRhZDVkZGRkNmI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTYgRGVjIDIwMjAgMTg6MDQ6MjcgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBGaXggc3VwcG9ydCBmb3IgcmVtb3VudCB3aGVuIG5vdCBjaGFuZ2luZyByc2l6ZS93c2l6
ZQoKV2hlbiByZW1vdW50aW5nIHdpdGggdGhlIG5ldyBtb3VudCBBUEksIHdlIG5lZWQgdG8gc2V0
CnJzaXplIGFuZCB3c2l6ZSB0byB0aGUgcHJldmlvdXMgdmFsdWVzIGlmIHRoZXkgYXJlIG5vdCBw
YXNzZWQKaW4gb24gdGhlIHJlbW91bnQuIE90aGVyd2lzZSB0aGV5IGdldCBzZXQgdG8gemVybyB3
aGljaCBicmVha3MKeGZzdGVzdCA0NTIgZm9yIGV4YW1wbGUuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9mc19jb250ZXh0
LmMgfCA3ICsrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDcz
NGIzMGRiNTgwZi4uMGFmY2NiYmVkMmU2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQu
YworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtNzA3LDYgKzcwNywxMyBAQCBzdGF0aWMg
aW50IHNtYjNfcmVjb25maWd1cmUoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCVNURUFMX1NUUklO
RyhjaWZzX3NiLCBjdHgsIG5vZGVuYW1lKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwgY3R4LCBp
b2NoYXJzZXQpOwogCisJLyogaWYgcnNpemUgb3Igd3NpemUgbm90IHBhc3NlZCBpbiBvbiByZW1v
dW50LCB1c2UgcHJldmlvdXMgdmFsdWVzICovCisJaWYgKGN0eC0+cnNpemUgPT0gMCkKKwkJY3R4
LT5yc2l6ZSA9IGNpZnNfc2ItPmN0eC0+cnNpemU7CisJaWYgKGN0eC0+d3NpemUgPT0gMCkKKwkJ
Y3R4LT53c2l6ZSA9IGNpZnNfc2ItPmN0eC0+d3NpemU7CisKKwogCXNtYjNfY2xlYW51cF9mc19j
b250ZXh0X2NvbnRlbnRzKGNpZnNfc2ItPmN0eCk7CiAJcmMgPSBzbWIzX2ZzX2NvbnRleHRfZHVw
KGNpZnNfc2ItPmN0eCwgY3R4KTsKIAlzbWIzX3VwZGF0ZV9tbnRfZmxhZ3MoY2lmc19zYik7Ci0t
IAoyLjI3LjAKCg==
--00000000000060c4b805b69dcb50--
