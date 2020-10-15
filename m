Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFACEC433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 17:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9690C22260
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 17:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wei8iCem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403788AbgJOR4s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403764AbgJOR4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 13:56:47 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E6DC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 10:56:47 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l15so2996309ybp.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 10:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xiiJc6FhWkGSCGxGNa7eOLZ6PARadg0WVJepfbhgbWU=;
        b=Wei8iCemYwgXyTuxtKky/OdgICtmi5eCq5tzZhFm+jbwftCgxU8J4Tv6GUS8gF7M2S
         /Wk9qtRdlYjJrQ78VcZRMASE5rlhRijIlDuEng8u8Q2zeSPnozUeQAHXu0/CH5tbGS3O
         DWnHQCZ3ZFBscsymQ+UAu7ANKP5/w1g3IIejrUA1iMGCvGBlCR34+htY9aSHiX4krSry
         GRqGMMaOvLfziUHo28mb7xtxOXnKJOiW/HLLz0Hw7rJV4LDM94pykRdS+48bWUz5C/45
         kX9MJpqBvbaQ01H9gG47t7apqUvxa886dVJXh2WK9Aca9tZ0qln692bViAd8slTHhWLa
         wrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xiiJc6FhWkGSCGxGNa7eOLZ6PARadg0WVJepfbhgbWU=;
        b=V5Z2AWwg1Nyqq5Kyw2Pepm5xNCVfM0FHFUW4ABTUTunRojiGCnxh8ikFM1MtIExVWS
         Ke+paCANqRfboum5vXNUziIRaF2KU8Mmc82Ie6ilaD26YFXuaYF+x879A4xSlrtRywEd
         nY17qmiuAhoJF91Ld65PPr46ASDVu3AcmtcK1Z1QUkZp2mwsL0t3nOLI5Y46tlOOfVYN
         s/rEInQ71VviFIDH1aKCdGHDGwHpM9ZQQM+xsfBuEVG5AeL9GrjYfYEFJzyDsqt09Rrl
         Ln7VCOKnDlXDtv1Bh6AqC96oBsxUOyD+vBlp3RMhPhTUuNUQTHBBOG0mIX2upN8ZFw1L
         MEMQ==
X-Gm-Message-State: AOAM5313kddR34RqxAmPF5Vh/gea2p7cOx0iADEjRrgPK17qHvmyYOBz
        DY9iQ5WNRQjh26bcf48mJIAEWxBId0vcXHdDeis=
X-Google-Smtp-Source: ABdhPJxK5hM7g4zqQ41R6MG2JbBOGmIm8TH5ZpbQslmY12JVdE0ksklA9CPAmgM1WltiJvXygJILJnfNPMSveyB96tU=
X-Received: by 2002:a25:3793:: with SMTP id e141mr6779575yba.185.1602784606841;
 Thu, 15 Oct 2020 10:56:46 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 15 Oct 2020 23:26:36 +0530
Message-ID: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
Subject: [PATCH] cifs: Return the error from crypt_message when enc/dec key
 not found.
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="000000000000250bfa05b1b95ff7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000250bfa05b1b95ff7
Content-Type: text/plain; charset="UTF-8"

Fixes bug:
https://bugzilla.kernel.org/show_bug.cgi?id=209669

Please review.

-- 
-Shyam

--000000000000250bfa05b1b95ff7
Content-Type: application/octet-stream; 
	name="0001-cifs-Return-the-error-from-crypt_message-when-enc-de.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Return-the-error-from-crypt_message-when-enc-de.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgb4g9z80>
X-Attachment-Id: f_kgb4g9z80

RnJvbSBkNzM3MDY0YThhYWI1ODQyZGNlYTE3NTU3MmFkMmI2MmYyZjkxMDcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDE1IE9jdCAyMDIwIDEwOjQxOjMxIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogUmV0dXJuIHRoZSBlcnJvciBmcm9tIGNyeXB0X21lc3NhZ2Ugd2hlbiBlbmMvZGVjIGtl
eQogbm90IGZvdW5kLgoKSW4gY3J5cHRfbWVzc2FnZSwgd2hlbiBzbWIyX2dldF9lbmNfa2V5IHJl
dHVybnMgZXJyb3IsIHdlIG5lZWQgdG8KcmV0dXJuIHRoZSBlcnJvciBiYWNrIHRvIHRoZSBjYWxs
ZXIuIElmIG5vdCwgd2UgZW5kIHVwIHByb2Nlc3NpbmcKdGhlIG1lc3NhZ2UgZnVydGhlciwgY2F1
c2luZyBhIGtlcm5lbCBvb3BzIGR1ZSB0byB1bndhcnJhbnRlZCBhY2Nlc3MKb2YgbWVtb3J5LgoK
U2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL3NtYjJvcHMuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lm
cy9zbWIyb3BzLmMKaW5kZXggNzZkODJhNjBhNTUwLi43ZWM0OTk0NzE1ZjggMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0zOTQzLDcgKzM5
NDMsNyBAQCBjcnlwdF9tZXNzYWdlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgaW50
IG51bV9ycXN0LAogCWlmIChyYykgewogCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAiJXM6IENvdWxk
IG5vdCBnZXQgJXNjcnlwdGlvbiBrZXlcbiIsIF9fZnVuY19fLAogCQkJIGVuYyA/ICJlbiIgOiAi
ZGUiKTsKLQkJcmV0dXJuIDA7CisJCXJldHVybiByYzsKIAl9CiAKIAlyYyA9IHNtYjNfY3J5cHRv
X2FlYWRfYWxsb2NhdGUoc2VydmVyKTsKLS0gCjIuMjUuMQoK
--000000000000250bfa05b1b95ff7--
