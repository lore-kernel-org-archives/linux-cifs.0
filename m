Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD29FC07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 19:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3EFC61CC2
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 19:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhGGTKu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 15:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhGGTKu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 15:10:50 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A976C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 12:08:08 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id q18so6791383lfc.7
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 12:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=N8o4s4S+U5bp6nCXpE01ZZjPN4ueWJ5Fv3glrcsfmXI=;
        b=G7wd1rJvXIQzZK4rkzpOFXRcsporoTWVCECpzGOF72qI+Uj81L+18f62EqKwRnFwZc
         WBMj1+NevPW5asSWfE6u5Rjhw0kqC2L6RfUZ042vYA00qEKB/QDdRriOgLwAY2dp9x8s
         W58gY4o/Wm0zJDVEltUZQob/vj3Wgt2JFZ1ZzOYDdWN5koti22iRJK43+gR6QOWX4l2W
         fjq1m1Sr5eslS+xbPEWlOxZc2cC0/XlXgzhWtCmpAD9B6Jy3MGZnyaaU9juN4yuJJTy0
         usaQPLf2VmnAj0aHvpqiEH0axx+aShTFsrUCSfWEskwvh6kJ7SbR/X+0HcIms9WxAnDs
         t+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=N8o4s4S+U5bp6nCXpE01ZZjPN4ueWJ5Fv3glrcsfmXI=;
        b=ahKG6LjwatC4RMxacziwWY2ydSdY/tl8AYrb4MorwUXvTmT3E6VKjKpfOPkgr5CXah
         ozfy4XRCmubIQKvHO3FHeGbuiU3S+75MVxPPhxz1w+8vM8yCT5+724N/Rqwnla1xp0fa
         0NhCXUUB0egZktQBgJxrX9wuaE2fsnpLOtesetM31IM+B7Ja7SHluOe28rwgZ1lAXSXY
         Rw7JzfK89dp8SlSTAbMwt+qkTnTNgJjAfU7zi9MrRyqanVkLzf+JRU2/VC9nI9B7tSjL
         fYp6YnsA3/MuFqmqJ9OJ+7y6QoAeBMQuHd7cuHKFRjsT1o9i8QBJexV291Ztn6wTYUOx
         52FA==
X-Gm-Message-State: AOAM530D+AagGOR+g/OzTz6tRJo/+QzjUlBQmaTf8N+TiyplNfTuHVwH
        B/DCMCZUwfZvNNYY2s+LBGQ5XrHyyZPZR5VTIFTfej6SN0Y=
X-Google-Smtp-Source: ABdhPJwbtGur3iZsbEz0GWm3URo77ph0dLZIO/69eymcWukkjJYF2c2yc2Nhb1taalWjGyHVNjm4BxcZAtAqHsXpIu0=
X-Received: by 2002:a19:5043:: with SMTP id z3mr19121679lfj.282.1625684884967;
 Wed, 07 Jul 2021 12:08:04 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 14:07:52 -0500
Message-ID: <CAH2r5mtA8psGCcH_=JQbXw--im8f6e+bqy12YRRdww9gEyy6uw@mail.gmail.com>
Subject: [PATCH][CIFS] Clarify SMB1 code for POSIX Lock
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000015ebe305c68d424a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000015ebe305c68d424a
Content-Type: text/plain; charset="UTF-8"

Another trivial (Coverity reported issue) patch ...

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes) for SMB1 PosixLock. This changeset
doesn't change the address but makes it slightly clearer.

Addresses-Coverity: 711520 ("Out of bounds write")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 16bd4cf3bceb..f72e3b3dca69 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2537,8 +2537,9 @@ CIFSSMBPosixLock(const unsigned int xid, struct
cifs_tcon *tcon,
  pSMB->TotalDataCount = pSMB->DataCount;
  pSMB->TotalParameterCount = pSMB->ParameterCount;
  pSMB->ParameterOffset = cpu_to_le16(param_offset);
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
  parm_data = (struct cifs_posix_lock *)
- (((char *) &pSMB->hdr.Protocol) + offset);
+ (((char *)pSMB) + offset + 4);

  parm_data->lock_type = cpu_to_le16(lock_type);
  if (waitFlag) {


-- 
Thanks,

Steve

--00000000000015ebe305c68d424a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-POSIX-Lock.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-POSIX-Lock.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqtusc920>
X-Attachment-Id: f_kqtusc920

RnJvbSA3YjdhMTFhN2I1YTg2NTM5MDYyMWQxNTZiZDE2OWEwYTIyZGJlYWY5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNyBKdWwgMjAyMSAxNDowMzo1NCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IENsYXJpZnkgU01CMSBjb2RlIGZvciBQT1NJWCBMb2NrCgpDb3Zlcml0eSBhbHNvIGNvbXBs
YWlucyBhYm91dCB0aGUgd2F5IHdlIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0CihzdGFydGluZyBmcm9t
IHRoZSBhZGRyZXNzIG9mIGEgNCBieXRlIGFycmF5IHdpdGhpbiB0aGUKaGVhZGVyIHN0cnVjdHVy
ZSByYXRoZXIgdGhhbiBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgdGhlIHN0cnVjdApwbHVzIDQgYnl0
ZXMpIGZvciBTTUIxIFBvc2l4TG9jay4gVGhpcyBjaGFuZ2VzZXQKZG9lc24ndCBjaGFuZ2UgdGhl
IGFkZHJlc3MgYnV0IG1ha2VzIGl0IHNsaWdodGx5IGNsZWFyZXIuCgpBZGRyZXNzZXMtQ292ZXJp
dHk6IDcxMTUyMCAoIk91dCBvZiBib3VuZHMgd3JpdGUiKQpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzc21iLmMgfCAz
ICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMKaW5kZXggMTZi
ZDRjZjNiY2ViLi5mNzJlM2IzZGNhNjkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3NtYi5jCisr
KyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0yNTM3LDggKzI1MzcsOSBAQCBDSUZTU01CUG9zaXhM
b2NrKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcFNN
Qi0+VG90YWxEYXRhQ291bnQgPSBwU01CLT5EYXRhQ291bnQ7CiAJcFNNQi0+VG90YWxQYXJhbWV0
ZXJDb3VudCA9IHBTTUItPlBhcmFtZXRlckNvdW50OwogCXBTTUItPlBhcmFtZXRlck9mZnNldCA9
IGNwdV90b19sZTE2KHBhcmFtX29mZnNldCk7CisJLyogU01CIG9mZnNldHMgYXJlIGZyb20gdGhl
IGJlZ2lubmluZyBvZiBTTUIgd2hpY2ggaXMgNCBieXRlcyBpbiwgYWZ0ZXIgUkZDMTAwMSBmaWVs
ZCAqLwogCXBhcm1fZGF0YSA9IChzdHJ1Y3QgY2lmc19wb3NpeF9sb2NrICopCi0JCQkoKChjaGFy
ICopICZwU01CLT5oZHIuUHJvdG9jb2wpICsgb2Zmc2V0KTsKKwkJCSgoKGNoYXIgKilwU01CKSAr
IG9mZnNldCArIDQpOwogCiAJcGFybV9kYXRhLT5sb2NrX3R5cGUgPSBjcHVfdG9fbGUxNihsb2Nr
X3R5cGUpOwogCWlmICh3YWl0RmxhZykgewotLSAKMi4zMC4yCgo=
--00000000000015ebe305c68d424a--
