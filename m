Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D15DC433E7
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 05:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A7D20760
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 05:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfyJzuIV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbgJPFOo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 01:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732369AbgJPFOo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Oct 2020 01:14:44 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD6C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 22:14:42 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d24so1100179ljg.10
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 22:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHSm2fA2JSYPrBPLlGU71EEnGldLd8HcWzw016cqfXw=;
        b=IfyJzuIV03VWises3Kd1QemR8dB8Q9MAS4kszn9DLhYFQMQ5eV96hNMC9l99dlM7dk
         hpa+1ge0rt2o2ZPU3P+IYOy+H3FskYAhxGyBttv6zrjdQqBZGQVyud1c3u6wjy3vUYww
         yWd4i2sDk+JnLj7oXLqUufhQ7vTI1wJMnm3ps2rCdHMEnVePMS0YHQ8HuWo0+KsD39ih
         XR/bkJGyfH4u1xtXrRP0Qu7vmSIMlpePtuZ2zWZBn8jL9fN+PNHdkBhC23X2jMUebbmU
         vaKsZTE4TC4pfJQdUc2C8Jq5q+3w5KtlDT1ZkppsYT/WF9D3xIoSfoF1mtkLJpSvxZ68
         HOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHSm2fA2JSYPrBPLlGU71EEnGldLd8HcWzw016cqfXw=;
        b=GK9coTaugY3M+0k5906qZ/UJ4e6qcMXWWDfpQTlum7gly2QClDx2zmkvbzB9mwY0lV
         ObQyuffxcSoc6/cM73KPrOwLnyLNZ/FjX6c1zCgAnPSUatH6eSLybc1gt0wdAZAY3hLX
         YpnV770sJ1XcKcx7Ol7FNQre+E+awrfEIaU5Ut7OVwG/LEV1mK2nvlafebuuvKvVjb2D
         7GwOCnzPUKd6jKPdLYyS7E2P+5NyhlXdN7gV/+HbNLCQh4B62RBu1HHt2OfwVN6XrjCj
         9F6JNDw+U+pHhb4JY/VXu6TfT+4UdQK6mZoBkH3vdax12qex+Vkwy1a+ufs6Y9Yi508b
         70DA==
X-Gm-Message-State: AOAM532ZVAydDe+6wveTqgIGC1gLMT8F0KooT1LTV7dkC9MGo+hxGQZl
        +JOIC7aQgw4ZfM6Z06TQiCJ5k0pTbbf5CP/kTNY=
X-Google-Smtp-Source: ABdhPJyPHvXYNLD0x6arrNr6tSIcHRrSMM7EQcAjjlya6DwfQ71xgmiwt7R2pdGLqZPHAQ9SmBjjhcXCawEr7ItepxI=
X-Received: by 2002:a05:651c:130d:: with SMTP id u13mr843061lja.265.1602825280700;
 Thu, 15 Oct 2020 22:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
 <CAN05THQ7XMF63-u1SLoRa-KZJS_u36M3Sb+ku6FsrUpvHx3doA@mail.gmail.com>
In-Reply-To: <CAN05THQ7XMF63-u1SLoRa-KZJS_u36M3Sb+ku6FsrUpvHx3doA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Oct 2020 00:14:29 -0500
Message-ID: <CAH2r5mvMdBpq9uYrmtYPPMuzFqV5ZQpaWNCi1hcQ8wA91ppv2g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the error from crypt_message when enc/dec
 key not found.
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="0000000000007e586705b1c2d74b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007e586705b1c2d74b
Content-Type: text/plain; charset="UTF-8"

updated patch with call stack and added cc:stable and merged into
cifs-2.6.git for-next


On Thu, Oct 15, 2020 at 5:25 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Oct 16, 2020 at 4:02 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Fixes bug:
> > https://bugzilla.kernel.org/show_bug.cgi?id=209669
> >
> > Please review.
>
> Since it is an oops, can you add the stack backtrace to the commit message ?
>
> >
> > --
> > -Shyam



-- 
Thanks,

Steve

--0000000000007e586705b1c2d74b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Return-the-error-from-crypt_message-when-enc-de.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Return-the-error-from-crypt_message-when-enc-de.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgbslh5w0>
X-Attachment-Id: f_kgbslh5w0

RnJvbSA5ZDA1ZmMyNGIzM2JmMjg1MjYwZDU4YjkzN2I4MzhiMzY1MzBlYTZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDE1IE9jdCAyMDIwIDEwOjQxOjMxIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogUmV0dXJuIHRoZSBlcnJvciBmcm9tIGNyeXB0X21lc3NhZ2Ugd2hlbiBlbmMvZGVjIGtl
eQogbm90IGZvdW5kLgoKSW4gY3J5cHRfbWVzc2FnZSwgd2hlbiBzbWIyX2dldF9lbmNfa2V5IHJl
dHVybnMgZXJyb3IsIHdlIG5lZWQgdG8KcmV0dXJuIHRoZSBlcnJvciBiYWNrIHRvIHRoZSBjYWxs
ZXIuIElmIG5vdCwgd2UgZW5kIHVwIHByb2Nlc3NpbmcKdGhlIG1lc3NhZ2UgZnVydGhlciwgY2F1
c2luZyBhIGtlcm5lbCBvb3BzIGR1ZSB0byB1bndhcnJhbnRlZCBhY2Nlc3MKb2YgbWVtb3J5LgoK
Q2FsbCBUcmFjZToKc21iM19yZWNlaXZlX3RyYW5zZm9ybSsweDEyMC8weDg3MCBbY2lmc10KY2lm
c19kZW11bHRpcGxleF90aHJlYWQrMHhiNTMvMHhjMjAgW2NpZnNdCj8gY2lmc19oYW5kbGVfc3Rh
bmRhcmQrMHgxOTAvMHgxOTAgW2NpZnNdCmt0aHJlYWQrMHgxMTYvMHgxMzAKPyBrdGhyZWFkX3Bh
cmsrMHg4MC8weDgwCnJldF9mcm9tX2ZvcmsrMHgxZi8weDMwCgpTaWduZWQtb2ZmLWJ5OiBTaHlh
bSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUGF2ZWwgU2hp
bG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+ClJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJl
cmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+CkNDOiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMv
Y2lmcy9zbWIyb3BzLmMKaW5kZXggNDg2NTdkZGJkNzVlLi4wZGZhODMyYTNkZTAgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0zOTQ0LDcg
KzM5NDQsNyBAQCBjcnlwdF9tZXNzYWdlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
aW50IG51bV9ycXN0LAogCWlmIChyYykgewogCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAiJXM6IENv
dWxkIG5vdCBnZXQgJXNjcnlwdGlvbiBrZXlcbiIsIF9fZnVuY19fLAogCQkJIGVuYyA/ICJlbiIg
OiAiZGUiKTsKLQkJcmV0dXJuIDA7CisJCXJldHVybiByYzsKIAl9CiAKIAlyYyA9IHNtYjNfY3J5
cHRvX2FlYWRfYWxsb2NhdGUoc2VydmVyKTsKLS0gCjIuMjUuMQoK
--0000000000007e586705b1c2d74b--
