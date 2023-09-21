Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C9DCD4938
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Sep 2023 00:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjIUA6K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Sep 2023 20:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjIUA6J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Sep 2023 20:58:09 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED23CC
        for <linux-cifs@vger.kernel.org>; Wed, 20 Sep 2023 17:58:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-50337b43ee6so777872e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 Sep 2023 17:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695257881; x=1695862681; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xQp6NPpMjIDcwcELwd21rx92WrdKUlmXQ9Ig4slWdfc=;
        b=X7gNG7aveHbF8DQ+KooI1pAltg8e/Heivyy4laQHBw9XiJPM5zqEQDGuWU6u0QIYV3
         kJp5PB60gRsYeJxwDGW+QAjg1igqFcN4zE3UGaKAe9/zogE5bfjAl1pDFc+tmT41qmUY
         X6a9QLSWxn1Ji8KLGNEawjdvSsthgRRoKJhonhCaU0J9jFlwWPswJ9bTGTifHL62vbir
         yRlAGkkSNVbXiiUA8E9liGeXw9ny0ZaOwGjBXkdAThImPksX7akH/MINhi4R+xNzv5bL
         cF2F2hsTkGaZSHCTy+YBPHQeLkJ3bBhcno0ZvoaXvuLe0gSRl8C+sYLJ74LUBJt0TU6x
         Lx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695257881; x=1695862681;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xQp6NPpMjIDcwcELwd21rx92WrdKUlmXQ9Ig4slWdfc=;
        b=kq9PBdksg5lFrLO7RKZfomyK9SzO4W6T3vgYgZDBAekUW1shoySsMlaszaLHL3h+Zf
         jKUrK4uIAwbwHW3mc6Ai/NT4DZe6O+qCQAQc75eDdKvhdOp9SwIq1371wRXGhJmZZaVn
         tlRbAcV0xx1HXN9RUQ9uw8K9HFhip5uPwMzX6kSWGiDBEq2mprlwVp8TxpF3w66ic10p
         buLYleWYTy+dDFIFp2mFoOFXmmK3h9NDvAxpS59XT++F9YbHm30LRr6wy9Ou1iZh2iCY
         VUgxqaksCoo72LYT66rl0uBOpJUVBbHOS9FmGBsMktobzjT/jtdyohVuiDU+SHBT5t06
         QvtA==
X-Gm-Message-State: AOJu0YzCz23LZ+DITNoRhdWVeI2OYj8qnYFu8hk40zSA7MBjQhOyfwmT
        35A3Wf3CySBwURiYeGdbH32fltp8eyKk+6fpTFFYYenp76w=
X-Google-Smtp-Source: AGHT+IHEWttHCT7JVMZUzgenouxbP3SdeCrC42tESfioDdiCV8IpREj9pon+VJkBMyEFRamknirBSLBP09/Ohoy9YMk=
X-Received: by 2002:a05:6512:36d1:b0:503:3587:fd15 with SMTP id
 e17-20020a05651236d100b005033587fd15mr3069418lfs.61.1695257880471; Wed, 20
 Sep 2023 17:58:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Sep 2023 19:57:49 -0500
Message-ID: <CAH2r5mvXAy=p8HiPQxr5QdhyvZOB1_YvEDudWrUTa9veSNTYuQ@mail.gmail.com>
Subject: [PATCH][SMB3] Fix confusing warning message about mode not specified
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000c4e35b0605d3fb3b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c4e35b0605d3fb3b
Content-Type: text/plain; charset="UTF-8"

smb3: fix confusing debug message

The message said it was an invalid mode, when it was intentionally
not set.  Fix confusing message logged to dmesg.

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 405ea324f28d..c75a80bb6d9e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -848,7 +848,7 @@ add_posix_context(struct kvec *iov, unsigned int
*num_iovec, umode_t mode)

  iov[num].iov_base = create_posix_buf(mode);
  if (mode == ACL_NO_MODE)
- cifs_dbg(FYI, "Invalid mode\n");
+ cifs_dbg(FYI, "%s: no mode\n", __func__);
  if (iov[num].iov_base == NULL)
  return -ENOMEM;
  iov[num].iov_len = sizeof(struct create_posix);

-- 
Thanks,

Steve

--000000000000c4e35b0605d3fb3b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-confusing-debug-message.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-confusing-debug-message.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmsgrh430>
X-Attachment-Id: f_lmsgrh430

RnJvbSBjOGViZjA3N2ZiZWJkYTNhMjQzMzU2NjBkZWQ3Y2ZmNGI5MDMzMWI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjAgU2VwIDIwMjMgMTk6NTA6MDUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggY29uZnVzaW5nIGRlYnVnIG1lc3NhZ2UKClRoZSBtZXNzYWdlIHNhaWQgaXQgd2Fz
IGFuIGludmFsaWQgbW9kZSwgd2hlbiBpdCB3YXMgaW50ZW50aW9uYWxseQpub3Qgc2V0LiAgRml4
IGNvbmZ1c2luZyBtZXNzYWdlIGxvZ2dlZCB0byBkbWVzZy4KClJldmlld2VkLWJ5OiBQYXVsbyBB
bGNhbnRhcmEgKFNVU0UpIDxwY0BtYW5ndWViaXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWIycGR1
LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21i
MnBkdS5jCmluZGV4IDQwNWVhMzI0ZjI4ZC4uYzc1YTgwYmI2ZDllIDEwMDY0NAotLS0gYS9mcy9z
bWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtODQ4
LDcgKzg0OCw3IEBAIGFkZF9wb3NpeF9jb250ZXh0KHN0cnVjdCBrdmVjICppb3YsIHVuc2lnbmVk
IGludCAqbnVtX2lvdmVjLCB1bW9kZV90IG1vZGUpCiAKIAlpb3ZbbnVtXS5pb3ZfYmFzZSA9IGNy
ZWF0ZV9wb3NpeF9idWYobW9kZSk7CiAJaWYgKG1vZGUgPT0gQUNMX05PX01PREUpCi0JCWNpZnNf
ZGJnKEZZSSwgIkludmFsaWQgbW9kZVxuIik7CisJCWNpZnNfZGJnKEZZSSwgIiVzOiBubyBtb2Rl
XG4iLCBfX2Z1bmNfXyk7CiAJaWYgKGlvdltudW1dLmlvdl9iYXNlID09IE5VTEwpCiAJCXJldHVy
biAtRU5PTUVNOwogCWlvdltudW1dLmlvdl9sZW4gPSBzaXplb2Yoc3RydWN0IGNyZWF0ZV9wb3Np
eCk7Ci0tIAoyLjM5LjIKCg==
--000000000000c4e35b0605d3fb3b--
