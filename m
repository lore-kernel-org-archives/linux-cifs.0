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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9937FC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 17:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735456108F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 17:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbhHXRwL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 13:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239733AbhHXRwJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 13:52:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4628BC053438
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 10:15:18 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id v19so21775040lfo.7
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 10:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=UVfDipoRnIK19fJOk6FZhnuCHRUc8tv1RtByPcNLa/o=;
        b=beM8sa9Fn+Bt7TJl9YDImKg8Vvs4CBNmCJ6lrur0MTz3SA0BqOZklEqSKkBb48ER36
         6djEvlnAQ9Xi4bKdxb+HZmr2JtxuiattW5NFvTr+Ju/LSF9/RnvVEokfwy1gnHfoQdMt
         RZS/aCxY11V9vcofDP/eZfppP9IOMqGcpjMlm4DCB0tU5l1ly4jwGKo41IYhSqXarBFe
         H6KV0IBc2TAwFiArHRs7vGjLS1fhhJxthFGoLIChRHDbd7YjOGVgG0XTNYJtRi60gkS+
         VaH9Dff+NGEclWlGIb4VRzDkWBZy0IqoBUADx+15KFMlfBO+bYbBg+VHuqcLM91/vzht
         Jr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UVfDipoRnIK19fJOk6FZhnuCHRUc8tv1RtByPcNLa/o=;
        b=G6H8Td2kQYa34vZXtdF6uHWT+ynLAM3IW19JOA1KlUM9CEx55JfDnD/IxyU2ZFnGaz
         vy2/v1Y0oX3cRRJYMDk+Vl5dfI0dbD7Vme7z5P0XiLbBiJNIF7tbNtmVSHs9lRJExHYy
         ana95LWNyNdYneqUFD7/GsVGY65PvDPwLRF9H+lgg/n9amwVxRvK32nfs65nZd0zpYsI
         BvHpVj6HW5ZtmDOwiA7QgcCGbaqDQjC+fkKwZt2e+AXK+MluEggt7V4YMFHLzMULEe2T
         M393lHhLUuQtNrlLg8hmZgRqrZkSr1ub6p60agJ40qJ/lJyknGNYIJs70RQPnW0qAIv6
         0dqw==
X-Gm-Message-State: AOAM532rFHPolM7EELQ0aX6wWxFkT8GpmKMG7QLpDvMEWBtaeFuwRI9D
        Amjhzuh597vXVfDrMmS4Ousbdw7DT2MXEUydkzP68nve8jw=
X-Google-Smtp-Source: ABdhPJweoBqrCYm0W+vGPvA9+bBiDITxhqK8ztyGA/6Qkng6zIVqcZPC+gW8esoUrlZaeNA2H3pMJZG+n0DUTfR2Ye4=
X-Received: by 2002:a05:6512:3ef:: with SMTP id n15mr7012573lfq.184.1629825316394;
 Tue, 24 Aug 2021 10:15:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Aug 2021 12:15:05 -0500
Message-ID: <CAH2r5mu-QRnkdaB=nNVY2Q3Dhb5vgnk4n0XnMADMWkEGbtchFw@mail.gmail.com>
Subject: [PATCH] cifs: cifs_md4 convert to SPDX identifier
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000007e26305ca514761"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000007e26305ca514761
Content-Type: text/plain; charset="UTF-8"

Add SPDX license identifier and replace license boilerplate
for cifs_md4.c

-- 
Thanks,

Steve

--00000000000007e26305ca514761
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-cifs_md4-convert-to-SPDX-identifier.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-cifs_md4-convert-to-SPDX-identifier.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksqbwj940>
X-Attachment-Id: f_ksqbwj940

RnJvbSAyY2MwOGU3MzI4MDVhZDZmOTlkNzhlNTAxM2RiZjNkMDZlYjEzNzcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjQgQXVnIDIwMjEgMTI6MDc6NDYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBjaWZzX21kNCBjb252ZXJ0IHRvIFNQRFggaWRlbnRpZmllcgoKQWRkIFNQRFggbGljZW5z
ZSBpZGVudGlmaWVyIGFuZCByZXBsYWNlIGxpY2Vuc2UgYm9pbGVycGxhdGUKZm9yIGNpZnNfbWQ0
LmMKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJtYXBlcnJvci5jICAgIHwgMiArLQogZnMvY2lmc19jb21tb24vY2lm
c19tZDQuYyB8IDggKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMgYi9mcy9j
aWZzL3NtYjJtYXBlcnJvci5jCmluZGV4IGNlYTM5YmNlY2JhYi4uOGJhNGFhM2UwZDhkIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJtYXBlcnJvci5jCisrKyBiL2ZzL2NpZnMvc21iMm1hcGVycm9y
LmMKQEAgLTEsNiArMSw2IEBACiAvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogTEdQTC0yLjEK
IC8qCi0gKiAgIGZzL3NtYjIvc21iMm1hcGVycm9yLmMKKyAqICAgZnMvY2lmcy9zbWIybWFwZXJy
b3IuYwogICoKICAqICAgRnVuY3Rpb25zIHdoaWNoIGRvIGVycm9yIG1hcHBpbmcgb2YgU01CMiBz
dGF0dXMgY29kZXMgdG8gUE9TSVggZXJyb3JzCiAgKgpkaWZmIC0tZ2l0IGEvZnMvY2lmc19jb21t
b24vY2lmc19tZDQuYyBiL2ZzL2NpZnNfY29tbW9uL2NpZnNfbWQ0LmMKaW5kZXggZGJmOTExM2I4
NjAwLi5jYzEyZTRjZWRiOTYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnNfY29tbW9uL2NpZnNfbWQ0LmMK
KysrIGIvZnMvY2lmc19jb21tb24vY2lmc19tZDQuYwpAQCAtMSw0ICsxLDcgQEAKKy8vIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCiAvKgorICogZnMvY2lmc19jb21tb24vY2lmc19t
ZDQuYworICoKICAqIENyeXB0b2dyYXBoaWMgQVBJLgogICoKICAqIE1ENCBNZXNzYWdlIERpZ2Vz
dCBBbGdvcml0aG0gKFJGQzEzMjApLgpAQCAtMTQsMTEgKzE3LDYgQEAKICAqIENvcHlyaWdodCAo
YykgMjAwMiBEYXZpZCBTLiBNaWxsZXIgKGRhdmVtQHJlZGhhdC5jb20pCiAgKiBDb3B5cmlnaHQg
KGMpIDIwMDIgSmFtZXMgTW9ycmlzIDxqbW9ycmlzQGludGVyY29kZS5jb20uYXU+CiAgKgotICog
VGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFu
ZC9vciBtb2RpZnkKLSAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5Ci0gKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgotICogKGF0IHlvdXIgb3B0
aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KLSAqCiAgKi8KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
CiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0tIAoyLjMwLjIKCg==
--00000000000007e26305ca514761--
