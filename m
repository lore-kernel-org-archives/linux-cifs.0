Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A03C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 04:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9B060F70
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 04:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhKLELD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Nov 2021 23:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKLELD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Nov 2021 23:11:03 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B66C061766
        for <linux-cifs@vger.kernel.org>; Thu, 11 Nov 2021 20:08:13 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id z34so19099223lfu.8
        for <linux-cifs@vger.kernel.org>; Thu, 11 Nov 2021 20:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=XbNUR6/sDPGZtmSjOt4N/YbG8ZdXKgRnVAdrZ4uHg8w=;
        b=elGkLMBZ1i/7IssRbxissiFvcxSF8GRJtmI1/mr04/z5YjI1SYvJTY7obNIMtnmPXu
         GJ5cagFacvKHy09Hgx3Bz19ZfCQ3iYptSBcjOvYSxNIs0Kwn3bASJFiyi2/euc7BE14j
         da6XxlYZyIulyIHnm/wETrO2KTe2rrdfrEYHea70ZcgOZytFaoa0835LFzKJIwluNnXm
         T3klqQS50CNdExwREcuaORkFDzDLtiim+6E2T/YJxjExwyhHn9apuYJn5/nO6hNx/ERt
         IzNGAErCh0lpaGMXnLrBxClo4ZtGifDvz8nzlFI1Lfz0SIojQ+1Kw9tHqqofQbJ3O1fo
         2UNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XbNUR6/sDPGZtmSjOt4N/YbG8ZdXKgRnVAdrZ4uHg8w=;
        b=XKbESula1dC702d1UbgInPOwmI5SgmNxoXbvmA8F2GK1PGnQMgQsUy4sbcSZFcK8Ws
         bESHW4EaANnGqWJiPcVyUH1pYISPIq6StWJf3jXx1yp04IvFxDoTnFbIHZVZt2xxWtZk
         DyAMe7ORlERHhTfiQB4DYC+sfnowL5Y8cDTeW8/Sejl/co/wbV8rzQk3aQt9dR1H9iui
         7LJkNtIhqpjOlIJpURC3t+E6cy4HoqU3A96pM8RHNlOk3qLRDWv7yCGSWouBJd43qYEI
         NgBUkUAQKw7mxkjZRHrZw2Vwla0s854NYeYbI/+hWI39FBuZKUMVyInvUSiavBwC6Ox4
         yuEQ==
X-Gm-Message-State: AOAM533FDFtV692GEH+hdidss3HNllqjYN2t1gcFop6eLG1fli8RoHEd
        sRrziBNVWE/lOch852449VCxc/fdIwyXsyaWvEsHn9xe8wE=
X-Google-Smtp-Source: ABdhPJzaWBG/tx+EmXxnMxLuEX67+m257A+Wfl4Q2pt1mVLbERqc1oh9+nDeSjmOOPy7bAdfgzLF1Cg6xSCZon9jCd0=
X-Received: by 2002:a19:770a:: with SMTP id s10mr11773310lfc.234.1636690091031;
 Thu, 11 Nov 2021 20:08:11 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Nov 2021 22:08:00 -0600
Message-ID: <CAH2r5mtxMpmUXXWn9vEyC_d1WizGB0fdkAeYUtauYwGv82nRLg@mail.gmail.com>
Subject: Ideas for Coverity 1507573 "Thread deadlock" fix
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007c71bb05d08f9bc8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007c71bb05d08f9bc8
Content-Type: text/plain; charset="UTF-8"

Coverity complains about holding the GlobalMidLock in dequeue_mid in
fs/cifs/connect.c while calling pr_warn_once (which grabs a rate limit
lock)

CID 1507573 (#1 of 1): Thread deadlock (ORDER_REVERSAL)
lock_order: Calling _printk acquires lock ratelimit_state.lock while
holding lock GlobalMid_Lock

Thoughts about the attached trivial fix?



-- 
Thanks,

Steve

--0000000000007c71bb05d08f9bc8
Content-Type: application/octet-stream; name=coverity-1507573
Content-Disposition: attachment; filename=coverity-1507573
Content-Transfer-Encoding: base64
Content-ID: <f_kvvuybjf0>
X-Attachment-Id: f_kvvuybjf0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
MGFiYmZmNGU0MTM1Li45NGEyMjc4ZjUxN2YgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC02NjUsMTMgKzY2NSwxNCBAQCBkZXF1ZXVlX21p
ZChzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCwgYm9vbCBtYWxmb3JtZWQpCiAJICogVHJ5aW5nIHRv
IGhhbmRsZS9kZXF1ZXVlIGEgbWlkIGFmdGVyIHRoZSBzZW5kX3JlY3YoKQogCSAqIGZ1bmN0aW9u
IGhhcyBmaW5pc2hlZCBwcm9jZXNzaW5nIGl0IGlzIGEgYnVnLgogCSAqLwotCWlmIChtaWQtPm1p
ZF9mbGFncyAmIE1JRF9ERUxFVEVEKQorCWlmIChtaWQtPm1pZF9mbGFncyAmIE1JRF9ERUxFVEVE
KSB7CisJCXNwaW5fdW5sb2NrKCZHbG9iYWxNaWRfTG9jayk7CiAJCXByX3dhcm5fb25jZSgidHJ5
aW5nIHRvIGRlcXVldWUgYSBkZWxldGVkIG1pZFxuIik7Ci0JZWxzZSB7CisJfSBlbHNlIHsKIAkJ
bGlzdF9kZWxfaW5pdCgmbWlkLT5xaGVhZCk7CiAJCW1pZC0+bWlkX2ZsYWdzIHw9IE1JRF9ERUxF
VEVEOworCQlzcGluX3VubG9jaygmR2xvYmFsTWlkX0xvY2spOwogCX0KLQlzcGluX3VubG9jaygm
R2xvYmFsTWlkX0xvY2spOwogfQogCiBzdGF0aWMgdW5zaWduZWQgaW50Cg==
--0000000000007c71bb05d08f9bc8--
