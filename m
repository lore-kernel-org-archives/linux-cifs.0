Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2933C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 02:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiFBCjY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiFBCjX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 22:39:23 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE26B5F94
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 19:39:22 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id f13so3420837vsp.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 19:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Js3IruM4BXSFN0IJZZDQA8cDZgJKRjJtKo73/Xc1HJc=;
        b=GhucqSSJJ1V+g6OtPFpDWMhKdX/V3waFjsAd9uH2r8bf4AZ388ai0+42OgDIWFxr56
         bRW2V4Z57++TphOsWrRQPeltbSgr+lunV/4EJMPsJq2LF08hXoWecvvYfPCMogPu81NF
         S1jJ0RWeoTKqHG0fXTUJ/useBMNbhKcngc46i4MrTGApyvfWyeoYgeZwxM+rQwpUIyHY
         UXHNe1ZYQQItjZ2I+iUH6ORfIgPwl4ok4SWdOfXip9QUvnPl3e8+FJn/nUSk/Pjfm9qp
         N757Xw4kTht912+jzOgWAcU76vBbf7S1XcdxXu7EcHsb/Hdk61YQ2Dp8Skkud2dB1p3R
         CSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Js3IruM4BXSFN0IJZZDQA8cDZgJKRjJtKo73/Xc1HJc=;
        b=g4D+wK22GKqtpQi5R+IUlaNX2DKAfaJ8PVjmhCo/cBzjtY4Xsy2ilZANmw9ZIvjzj0
         OjQkVF71+Z6p7awey3GIIEfGyY3uncKxpxhwOx4uqOuYwMskc9jgVnZBKk5q1KfYtyDz
         +89BelxQEwHB/U4bh1oPDE6m257tvnVEfy0L7STuoiYGxd5coDpoypXWUkQ6Vyo2qxkV
         u12NqBnHeKYmQZ4v+XQ6dSYdqdivEwqYhQ20ikLZOuAztJxzu6H9/ClIi67CNux1Fps7
         L+FwDUBFj0feFX7vUm+qWaYcE7yvM1TUKYEt44Nh08sExfUvkY4jqByZq8T2BHDY3pPi
         oJYA==
X-Gm-Message-State: AOAM531diKzEZMS0UKtjy2H1sgdzGWpMhEJVQEhyWCStFTgAALc7vvMk
        GRA209CHt9+7bBrmzRoVM1RDjf+NX0goDZw+hOv8+Xtj1yI=
X-Google-Smtp-Source: ABdhPJwxMazGjzBhXnzi8qQSEJ4yxSyjgKkZ8xHA1Fi9YlXSowrFH7r4Q4PT6rNRPPrtDbURnB4WYuqHvIFaOLpD+Zw=
X-Received: by 2002:a67:b607:0:b0:337:b5b7:adc9 with SMTP id
 d7-20020a67b607000000b00337b5b7adc9mr1283599vsm.17.1654137561435; Wed, 01 Jun
 2022 19:39:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 Jun 2022 21:39:10 -0500
Message-ID: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
Subject: [PATCH][CIFS] Do not build smb1ops.c if legacy support is disabled
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c269b905e06de92b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c269b905e06de92b
Content-Type: text/plain; charset="UTF-8"

We should not be including unused SMB1/CIFS functions when legacy
support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
off), but especially obvious is not needing to build smb1ops.c
at all when legacy support is disabled. Over time we can move
more SMB1/CIFS and SMB2.0 legacy functions into ifdefs but this
is a good start (and shrinks the module size a few percent).

-- 
Thanks,

Steve

--000000000000c269b905e06de92b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-do-not-build-smb1ops-if-legacy-support-is-disab.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-do-not-build-smb1ops-if-legacy-support-is-disab.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3weqxgp0>
X-Attachment-Id: f_l3weqxgp0

RnJvbSA0MWRiN2E5ZTI4ZjA5ZDU3YzE0NWRmODE0ZjBmYjZmMjAwYzhkMmE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMSBKdW4gMjAyMiAyMToyNTo0MyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGRvIG5vdCBidWlsZCBzbWIxb3BzIGlmIGxlZ2FjeSBzdXBwb3J0IGlzIGRpc2FibGVkCgpX
ZSBzaG91bGQgbm90IGJlIGluY2x1ZGluZyB1bnVzZWQgU01CMS9DSUZTIGZ1bmN0aW9ucyB3aGVu
IGxlZ2FjeQpzdXBwb3J0IGlzIGRpc2FibGVkIChDT05GSUdfQ0lGU19BTExPV19JTlNFQ1VSRV9M
RUdBQ1kgdHVybmVkCm9mZiksIGJ1dCBlc3BlY2lhbGx5IG9idmlvdXMgaXMgbm90IG5lZWRpbmcg
dG8gYnVpbGQgc21iMW9wcy5jCmF0IGFsbCB3aGVuIGxlZ2FjeSBzdXBwb3J0IGlzIGRpc2FibGVk
LiBPdmVyIHRpbWUgd2UgY2FuIG1vdmUKbW9yZSBTTUIxL0NJRlMgYW5kIFNNQjIuMCBsZWdhY3kg
ZnVuY3Rpb25zIGludG8gaWZkZWZzIGJ1dCB0aGlzCmlzIGEgZ29vZCBzdGFydCAoYW5kIHNocmlu
a3MgdGhlIG1vZHVsZSBzaXplIGEgZmV3IHBlcmNlbnQpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUg
RnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvTWFrZWZpbGUgfCA0
ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL01ha2VmaWxlIGIvZnMvY2lmcy9NYWtlZmlsZQppbmRleCBjYzhm
ZGNiMzViNzEuLjhjOWYyYzAwYmU3MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9NYWtlZmlsZQorKysg
Yi9mcy9jaWZzL01ha2VmaWxlCkBAIC04LDcgKzgsNyBAQCBvYmotJChDT05GSUdfQ0lGUykgKz0g
Y2lmcy5vCiBjaWZzLXkgOj0gdHJhY2UubyBjaWZzZnMubyBjaWZzc21iLm8gY2lmc19kZWJ1Zy5v
IGNvbm5lY3QubyBkaXIubyBmaWxlLm8gXAogCSAgaW5vZGUubyBsaW5rLm8gbWlzYy5vIG5ldG1p
c2MubyBzbWJlbmNyeXB0Lm8gdHJhbnNwb3J0Lm8gXAogCSAgY2lmc191bmljb2RlLm8gbnRlcnIu
byBjaWZzZW5jcnlwdC5vIFwKLQkgIHJlYWRkaXIubyBpb2N0bC5vIHNlc3MubyBleHBvcnQubyBz
bWIxb3BzLm8gdW5jLm8gd2ludWNhc2UubyBcCisJICByZWFkZGlyLm8gaW9jdGwubyBzZXNzLm8g
ZXhwb3J0Lm8gdW5jLm8gd2ludWNhc2UubyBcCiAJICBzbWIyb3BzLm8gc21iMm1hcGVycm9yLm8g
c21iMnRyYW5zcG9ydC5vIFwKIAkgIHNtYjJtaXNjLm8gc21iMnBkdS5vIHNtYjJpbm9kZS5vIHNt
YjJmaWxlLm8gY2lmc2FjbC5vIGZzX2NvbnRleHQubyBcCiAJICBkbnNfcmVzb2x2ZS5vIGNpZnNf
c3BuZWdvX25lZ3Rva2VuaW5pdC5hc24xLm8gYXNuMS5vCkBAIC0zMCwzICszMCw1IEBAIGNpZnMt
JChDT05GSUdfQ0lGU19GU0NBQ0hFKSArPSBmc2NhY2hlLm8KIGNpZnMtJChDT05GSUdfQ0lGU19T
TUJfRElSRUNUKSArPSBzbWJkaXJlY3QubwogCiBjaWZzLSQoQ09ORklHX0NJRlNfUk9PVCkgKz0g
Y2lmc3Jvb3QubworCitjaWZzLSQoQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZKSAr
PSBzbWIxb3BzLm8KLS0gCjIuMzQuMQoK
--000000000000c269b905e06de92b--
