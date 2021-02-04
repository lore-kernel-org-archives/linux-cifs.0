Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309E2C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AF764F59
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhBDILC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhBDILB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 03:11:01 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C10C06178A
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 00:10:11 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id r2so2288562ybk.11
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 00:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=9ny99BcW9dhu2mSIu4xM2W8Cgk0hIF0f3QBfQC96IDU=;
        b=phr++q5D1m1cKKma5mSQacU3Fnnsmf9Qo4X1CiAA6Bz9Qe8sdHCXt5qvP5P7GbDC7g
         J7NeT5riZvcBNkrl7vV+RH2GArN5c43OYRZwziEhVpLUtoiWU66bsHspLenhNmUHZ7JF
         TubetiH2Qh2uu2Fqt1q03xZK2s+ymfOD0SdWRq+PSaFO9OQ6Uy09H5H3Ly98h2/kzOAW
         f02AA32NVwJgXENCkHABsq5/vLMP6RNp3Vq3bAAQxmxB0RVF/0mNZPVVlxhjf8ppo9/J
         rH8b9CwEf05aOlMCNgxN/icZtrkLlq3qbFUonlgiLSt0rABQe1YaVLkHCdrqFIVLL44R
         BP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=9ny99BcW9dhu2mSIu4xM2W8Cgk0hIF0f3QBfQC96IDU=;
        b=HrMyPzJtWyIodMvHUW5JHNzjFR/kz2KqtKU11SOEc0mpqh9KQVaUaG8GwYaQ1h0P0x
         m8LTK/agDi5Seqb2xEBdfc6CnAng55a4i61zeP1teIAZiqLjCAHif17DItSBcCf+D3fw
         m62vOHFkzo11QYEk7RucG+V/bSkrhXhCy7a639ezS60nlirzD6kdBh7dDgFgPRtms3Kj
         uGwGXrvZsUBWwMwRiHS43mya+gjOW7BPPmQpeWlDkGpPe1RD8yFEcPZ5L7VYvw0HlSZN
         Gy1aUtjkX5Qv2sBdjcTQpuxkedJw+J+neUMjZsEBbiccpiljAKj9MGPEooDAq49inPa9
         AKLQ==
X-Gm-Message-State: AOAM530bqGsj0dM9zDDw1hRzpbLw90ubwsrHaNR37X8lBu0F4PXIhmM8
        8iJxtZBjkFrbh7QHEgdBG5fa1aKLyiSftb7GVoA=
X-Google-Smtp-Source: ABdhPJxNjCXQPNabu1WgFaDsirA0PmVwkhgLPWSmMPZCPBsqqj0oLm9BqYfwiLhNFxNrzhfCBFRY3ogQJAxQoEpZjoI=
X-Received: by 2002:a25:7706:: with SMTP id s6mr10422321ybc.3.1612426210578;
 Thu, 04 Feb 2021 00:10:10 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
In-Reply-To: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 4 Feb 2021 00:09:59 -0800
Message-ID: <CANT5p=oaVbe2rz-38J=_XD7DqZN48Bap-myJW9v76=JLTvAetg@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: Fix in error types returned for out-of-credit situations.
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, tom@talpey.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000822d1305ba7e3b0c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000822d1305ba7e3b0c
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 4, 2021 at 12:08 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam

--000000000000822d1305ba7e3b0c
Content-Type: application/octet-stream; 
	name="0002-cifs-Fix-in-error-types-returned-for-out-of-credit-s.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-Fix-in-error-types-returned-for-out-of-credit-s.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkqkx7i00>
X-Attachment-Id: f_kkqkx7i00

RnJvbSA3MzdiOGQ3MWQ5Y2MzZWYyYjI0ODRmMjQ2Y2VjNGI4MTM1ZTU3NmQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMjI6NTg6MzggLTA4MDAKU3ViamVjdDogW1BBVENIIDIv
NF0gY2lmczogRml4IGluIGVycm9yIHR5cGVzIHJldHVybmVkIGZvciBvdXQtb2YtY3JlZGl0CiBz
aXR1YXRpb25zLgoKRm9yIGZhaWx1cmUgYnkgdGltZW91dCB3YWl0aW5nIGZvciBjcmVkaXRzLCBj
aGFuZ2VkIHRoZSBlcnJvcgpyZXR1cm5lZCB0byB0aGUgYXBwIHdpdGggRUJVU1ksIGluc3RlYWQg
b2YgRU5PVFNVUFAuIFRoaXMgaXMgZG9uZQpiZWNhdXNlIHRoaXMgc2l0dWF0aW9uIGlzIHBvc3Np
YmxlIGV2ZW4gaW4gbm9uLWJ1Z2d5IGNhc2VzLiBpLmUuCm92ZXJsb2FkZWQgc2VydmVyIGNhbiBy
ZXR1cm4gMCBjcmVkaXRzIHVudGlsIGRvbmUgd2l0aCBvdXRzdGFuZGluZwpyZXF1ZXN0cy4gQW5k
IHRoaXMgZmVlbHMgbGlrZSBhIGJldHRlciBlcnJvciB0byByZXR1cm4gdG8gdGhlIGFwcC4KCkZv
ciBjYXNlcyBvZiB6ZXJvIGNyZWRpdHMgZm91bmQgZXZlbiB3aGVuIHRoZXJlIGFyZSBubyByZXF1
ZXN0cwppbiBmbGlnaHQsIHJlcGxhY2VkIEVOT1RTVVBQIHdpdGggRURFQURMSywgc2luY2Ugd2Un
cmUgYXZvaWRpbmcKZGVhZGxvY2sgaGVyZSBieSByZXR1cm5pbmcgZXJyb3IuCgpTaWduZWQtb2Zm
LWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMv
dHJhbnNwb3J0LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5jIGIvZnMvY2lm
cy90cmFuc3BvcnQuYwppbmRleCA0MTIyM2E5ZWUwODYuLjM5ZTg3NzA1ODQwZCAxMDA2NDQKLS0t
IGEvZnMvY2lmcy90cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5jCkBAIC01Njcs
NyArNTY3LDcgQEAgd2FpdF9mb3JfZnJlZV9jcmVkaXRzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlciwgY29uc3QgaW50IG51bV9jcmVkaXRzLAogCQkJCQlzZXJ2ZXItPmhvc3RuYW1lLCBu
dW1fY3JlZGl0cywgMCk7CiAJCQkJY2lmc19zZXJ2ZXJfZGJnKFZGUywgIndhaXQgdGltZWQgb3V0
IGFmdGVyICVkIG1zXG4iLAogCQkJCQkgdGltZW91dCk7Ci0JCQkJcmV0dXJuIC1FTk9UU1VQUDsK
KwkJCQlyZXR1cm4gLUVCVVNZOwogCQkJfQogCQkJaWYgKHJjID09IC1FUkVTVEFSVFNZUykKIAkJ
CQlyZXR1cm4gLUVSRVNUQVJUU1lTOwpAQCAtNjA5LDcgKzYwOSw3IEBAIHdhaXRfZm9yX2ZyZWVf
Y3JlZGl0cyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGNvbnN0IGludCBudW1fY3Jl
ZGl0cywKIAkJCQkJCTApOwogCQkJCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAid2FpdCB0aW1lZCBv
dXQgYWZ0ZXIgJWQgbXNcbiIsCiAJCQkJCQkgdGltZW91dCk7Ci0JCQkJCXJldHVybiAtRU5PVFNV
UFA7CisJCQkJCXJldHVybiAtRUJVU1k7CiAJCQkJfQogCQkJCWlmIChyYyA9PSAtRVJFU1RBUlRT
WVMpCiAJCQkJCXJldHVybiAtRVJFU1RBUlRTWVM7CkBAIC02ODcsNyArNjg3LDcgQEAgd2FpdF9m
b3JfY29tcG91bmRfcmVxdWVzdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGludCBu
dW0sCiAJCQkJCXNlcnZlci0+aG9zdG5hbWUsIHNjcmVkaXRzLCBzaW5fZmxpZ2h0KTsKIAkJCWNp
ZnNfZGJnKEZZSSwgIiVzOiAlZCByZXF1ZXN0cyBpbiBmbGlnaHQsIG5lZWRlZCAlZCB0b3RhbD0l
ZFxuIiwKIAkJCQkJX19mdW5jX18sIHNpbl9mbGlnaHQsIG51bSwgc2NyZWRpdHMpOwotCQkJcmV0
dXJuIC1FTk9UU1VQUDsKKwkJCXJldHVybiAtRURFQURMSzsKIAkJfQogCX0KIAlzcGluX3VubG9j
aygmc2VydmVyLT5yZXFfbG9jayk7Ci0tIAoyLjI1LjEKCg==
--000000000000822d1305ba7e3b0c--
