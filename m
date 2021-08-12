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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570E2C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 04:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3146A60F57
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 04:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhHLEbh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Aug 2021 00:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhHLEbg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Aug 2021 00:31:36 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDD7C061765
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 21:31:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y34so10858365lfa.8
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 21:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=p86OCZib7XVi9FE2ttEidowrz65EVobZnuQ1aOIavik=;
        b=llRkO0Hvh4Uty9oL8moZnXPl0rqNK1I9xTrFJ3RMTuVJBzRa0nR9iVO4tuY8DksoNO
         fGUuVjFfVOAhoYE7SMEVEGTTrb4qkB6zN1hcacybNwxtSp4VISbBf8uel8JY3BgODDbH
         IcygCe0+XZNsFv3z6jQn6FEIjUpFaJb7/pwgf1Xo34yT9gTXzyg2oar0Nv2BlYTT0flE
         oGjXsgSn41/XhwYTwPGdFXQUiEF55Bq3tGrP9ZiMbozQFyv4aNUHGlQiC8whcv306NJq
         is20F9ic9YD4FN9nOtMqNEsriHQiBcqv/Tzh+P21iUB7ry8zjrDMQ46JG4U/dc7r94YF
         gvUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p86OCZib7XVi9FE2ttEidowrz65EVobZnuQ1aOIavik=;
        b=MvLO7VhRPvmCyBeByDpBJX9Ig417LhsMxlNIFWYHJFB0fJtG6wNiRuu5R2KwjfJPw4
         tx8ZeTK2ojERrB8WduvoHvUKW78mft6JwRH90gI/jzOYiNJ6sHcxkutQK5jQk/eUO3ol
         WKyBPnUyf6P1iBU7jLYaPTnFaveOSQM2boYfjCNWpplpLOuAgdqqUAgMteywod8qb5jo
         2hWCG7TstCJly7qQrRvQr9Ywq6bQKkwUgmFKXRArHwbxU4+zcFnwCI0aILgQYDiY6qFH
         fvhuceuoQK/6Bndw+zVihADw4lOFA+dopUX9UDQhP/DF3ol2BxEaW8BnWlbrgQbDwQp9
         rmLQ==
X-Gm-Message-State: AOAM532wxcNZ6bYf5AasDGO2q67KctizlAVjt8SeDVPE7FhIeSpeNgMS
        enJ+Yjq/8iTfwcyF3XPxfdvRgh3353eTu82xgsIg2k+XuG+bjg==
X-Google-Smtp-Source: ABdhPJwHY/hPOs5yOOaHSjxmhP1QhKhFZ8Pjz885S/vVBHX22PODU7xzc5iCiVbs9076Vjpc4PHTXbuIF4GnIt6A1wg=
X-Received: by 2002:ac2:4350:: with SMTP id o16mr1232970lfl.184.1628742669874;
 Wed, 11 Aug 2021 21:31:09 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Aug 2021 23:30:59 -0500
Message-ID: <CAH2r5msb4s_Xdmspodrx7RLL=cHpUw5xB4yPETuBPuqe501CoQ@mail.gmail.com>
Subject: [PATCH][CIFS] avoid signed integer overflow in calculating blocks
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000044ce2205c95534a7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000044ce2205c95534a7
Content-Type: text/plain; charset="UTF-8"

xfstest generic/525 can generate the following warning:

 UBSAN: signed-integer-overflow in fs/cifs/file.c:2644:31
 9223372036854775807 + 511 cannot be represented in type 'long long int'

 Call Trace:
  dump_stack+0x8d/0xb5
  ubsan_epilogue+0x5/0x50
  handle_overflow+0xa3/0xb0
  cifs_write_end+0x424/0x440 [cifs]
  generic_perform_write+0xef/0x190

due to overflowing loff_t (a signed 64 bit) when it is rounded up
to calculate number of 512 byte blocks in a file

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0166f39f1888..3cc17871471a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2641,7 +2641,8 @@ static int cifs_write_end(struct file *file,
struct address_space *mapping,
  spin_lock(&inode->i_lock);
  if (pos > inode->i_size) {
  i_size_write(inode, pos);
- inode->i_blocks = (512 - 1 + pos) >> 9;
+ /* round up to block boundary, avoid overflow loff_t */
+ inode->i_blocks = ((__u64)pos + (512 - 1)) >> 9;
  }
  spin_unlock(&inode->i_lock);
  }

-- 
Thanks,

Steve

--00000000000044ce2205c95534a7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-avoid-signed-integer-overflow-in-calculating-bl.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-avoid-signed-integer-overflow-in-calculating-bl.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks8fbo8a0>
X-Attachment-Id: f_ks8fbo8a0

RnJvbSAyOTNjMjY2ZTU3ZDRjYzE0ZjRiOTZhYWZmN2EwODhlZjhmMWQwODc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTEgQXVnIDIwMjEgMjM6MjM6MDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhdm9pZCBzaWduZWQgaW50ZWdlciBvdmVyZmxvdyBpbiBjYWxjdWxhdGluZyBibG9ja3MK
Cnhmc3Rlc3QgZ2VuZXJpYy81MjUgY2FuIGdlbmVyYXRlIHRoZSBmb2xsb3dpbmcgd2FybmluZzoK
CiBVQlNBTjogc2lnbmVkLWludGVnZXItb3ZlcmZsb3cgaW4gZnMvY2lmcy9maWxlLmM6MjY0NDoz
MQogOTIyMzM3MjAzNjg1NDc3NTgwNyArIDUxMSBjYW5ub3QgYmUgcmVwcmVzZW50ZWQgaW4gdHlw
ZSAnbG9uZyBsb25nIGludCcKCiBDYWxsIFRyYWNlOgogIGR1bXBfc3RhY2srMHg4ZC8weGI1CiAg
dWJzYW5fZXBpbG9ndWUrMHg1LzB4NTAKICBoYW5kbGVfb3ZlcmZsb3crMHhhMy8weGIwCiAgY2lm
c193cml0ZV9lbmQrMHg0MjQvMHg0NDAgW2NpZnNdCiAgZ2VuZXJpY19wZXJmb3JtX3dyaXRlKzB4
ZWYvMHgxOTAKCmR1ZSB0byBvdmVyZmxvd2luZyBsb2ZmX3QgKGEgc2lnbmVkIDY0IGJpdCkgd2hl
biBpdCBpcyByb3VuZGVkIHVwCnRvIGNhbGN1bGF0ZSBudW1iZXIgb2YgNTEyIGJ5dGUgYmxvY2tz
IGluIGEgZmlsZQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvZmlsZS5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBi
L2ZzL2NpZnMvZmlsZS5jCmluZGV4IDAxNjZmMzlmMTg4OC4uM2NjMTc4NzE0NzFhIDEwMDY0NAot
LS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMjY0MSw3ICsyNjQx
LDggQEAgc3RhdGljIGludCBjaWZzX3dyaXRlX2VuZChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0
IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsCiAJCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7CiAJ
CWlmIChwb3MgPiBpbm9kZS0+aV9zaXplKSB7CiAJCQlpX3NpemVfd3JpdGUoaW5vZGUsIHBvcyk7
Ci0JCQlpbm9kZS0+aV9ibG9ja3MgPSAoNTEyIC0gMSArIHBvcykgPj4gOTsKKwkJCS8qIHJvdW5k
IHVwIHRvIGJsb2NrIGJvdW5kYXJ5LCBhdm9pZCBvdmVyZmxvdyBsb2ZmX3QgKi8KKwkJCWlub2Rl
LT5pX2Jsb2NrcyA9ICgoX191NjQpcG9zICsgKDUxMiAtIDEpKSA+PiA5OwogCQl9CiAJCXNwaW5f
dW5sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAl9Ci0tIAoyLjMwLjIKCg==
--00000000000044ce2205c95534a7--
