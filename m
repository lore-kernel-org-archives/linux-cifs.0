Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379E9C433E6
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 11:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9EC64DCF
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 11:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhBKL3z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 06:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhBKL1u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Feb 2021 06:27:50 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C902BC061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Feb 2021 03:27:06 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id l8so5187467ybe.12
        for <linux-cifs@vger.kernel.org>; Thu, 11 Feb 2021 03:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OmGXDfRX3iRbwv4sBVpi+Bn1sMBT0LYjDll9EEvWzAk=;
        b=g3TNkm2WqxX5nAarosFqmaJOs1Y0v7Jlqr+MSRMvdgONCPB/0E93MtT5q2M8c/9Bsc
         EKv9A1Dc7KXDUXQECrUK7Luay/lxmJMCOrDG928rTWLVbIcj7j8dmc3scZzD89e7TVYP
         hPVYEw0+USEPEO8cakHCHks2q6n8AEzvrmPjzZ95BML5lO5Oar2WBIlwoepUVAUShKgm
         MzMaYqyjkB/yLlLJkX+P/eAWxbGnM+Yp3ypeC4C3Mx592JvVNZ2qDpd+wxXJsAEiPQyN
         zHZW15nNeUGLgcUguvyEqj5knAKt3b6KX4ASvmXLY2GE002pHyyJf0drr7FOV8S8qG7X
         595w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OmGXDfRX3iRbwv4sBVpi+Bn1sMBT0LYjDll9EEvWzAk=;
        b=eEp+Znu+P60hOU6iXRNIMMA8KKBefDIBYHEeC5ajdzX44aVlGZ3fal9ccAqzrwLljd
         cFiRzfl+GxUcr3/nQuOeRC6hwkQhokOrqLSHHp/rd5lwJuqBkX2mOPJA3CdX4z1Lc6jR
         fuhMPBTTZEEaPa4/tihmDpzBLNbvr/+4RSJQoO2qETW4pxXzl33Zr3t6tzcZSQwRkLRd
         ivLd2DR8n5/bV3ZXJTqFQ5PWvYB37kCCL/KNK0gBQX+pnoUOgMAdV0asDu8hcxkwr+5X
         KCt+gKwgwCvkqb6w8vjaDlboInFBydGwPZg+91eK7tKKLiRfkgDIIR2GMnptqAoP9MUV
         pd0A==
X-Gm-Message-State: AOAM531LcWTUr/2Z1cW+yiFFBJEWXtgAn5jAUoFiCZR/dNt6knv3E4AL
        TdP1zLFGZN83X0uKLtCOjGGk982rd12eJ30Si1w=
X-Google-Smtp-Source: ABdhPJyT0j9q8MC9D6l61z6Yrtf9sL18dRViARiBsRqlF8WI9Yrynrfrf6P6FmgNJTKtuR/6FFli9VaQEK6cppYDryY=
X-Received: by 2002:a25:380e:: with SMTP id f14mr10930243yba.185.1613042825946;
 Thu, 11 Feb 2021 03:27:05 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 11 Feb 2021 03:26:54 -0800
Message-ID: <CANT5p=qNNFqeZnegrYZa0s_=KwmMVvQE3bbbGk60Y=WYvmiHOQ@mail.gmail.com>
Subject: [PATCH] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a5fe7805bb0dccfa"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a5fe7805bb0dccfa
Content-Type: text/plain; charset="UTF-8"

While debugging another issue today, Steve and I noticed that if a
subdir for a file share is already mounted on the client, any new
mount of any other subdir (or the file share root) results in sharing
the cifs superblock.
This could likely result in issues in other code paths as well.

Based on cursory code review, I think the CIFS_MOUNT_USE_PREFIX_PATH
flag is always used in conjunction with the cifs_sb->prepath field.
Attached patch sets this flag as soon as the prepath field is set in cifs_sb.

Please let me know if any of the above assumptions are wrong, or if
more needs to be done as a part of this fix.

-- 
Regards,
Shyam

--000000000000a5fe7805bb0dccfa
Content-Type: application/octet-stream; 
	name="0001-cifs-Set-CIFS_MOUNT_USE_PREFIX_PATH-flag-on-setting-.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Set-CIFS_MOUNT_USE_PREFIX_PATH-flag-on-setting-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kl0rjxwy0>
X-Attachment-Id: f_kl0rjxwy0

RnJvbSAzYTEzNzRmMDJkNzY4NjY0NzQ5NTg2MjRlMmM1MTJhMGZlYTM5M2JjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDExIEZlYiAyMDIxIDAzOjA3OjEzIC0wODAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogU2V0IENJRlNfTU9VTlRfVVNFX1BSRUZJWF9QQVRIIGZsYWcgb24gc2V0dGluZwogY2lm
c19zYi0+cHJlcGF0aC4KCldoaWxlIHNldHRpbmcgcHJlZml4IHBhdGggZm9yIHRoZSByb290IG9m
IGEgY2lmc19zYiwgQ0lGU19NT1VOVF9VU0VfUFJFRklYX1BBVEgKZmxhZyBzaG91bGQgYWxzbyBi
ZSBzZXQuIFdpdGhvdXQgaXQsIHByZXBhdGggaXMgbm90IGV2ZW4gY29uc2lkZXJlZCBpbiBzb21l
IHBsYWNlcy4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25u
ZWN0LmMKaW5kZXggNzZlNGQ4ZDhiM2E2Li40YmI5ZGVjYmJmMjcgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yNzU2LDYgKzI3NTYsNyBA
QCBpbnQgY2lmc19zZXR1cF9jaWZzX3NiKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IpCiAJ
CWNpZnNfc2ItPnByZXBhdGggPSBrc3RyZHVwKGN0eC0+cHJlcGF0aCwgR0ZQX0tFUk5FTCk7CiAJ
CWlmIChjaWZzX3NiLT5wcmVwYXRoID09IE5VTEwpCiAJCQlyZXR1cm4gLUVOT01FTTsKKwkJY2lm
c19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9VU0VfUFJFRklYX1BBVEg7CiAJfQog
CiAJcmV0dXJuIDA7Ci0tIAoyLjI1LjEKCg==
--000000000000a5fe7805bb0dccfa--
