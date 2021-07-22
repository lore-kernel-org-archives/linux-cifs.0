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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8F8C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 19:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A26DA60E74
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 18:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhGVSSg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGVSSf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 14:18:35 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFAEC061575
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 11:59:10 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g22so10140042lfu.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Bew8qUCK1VrN0VQJNLhW1NacYLqOiV0G6ii2zRK6mP0=;
        b=uypBeevdTvwWnMmNZlZszMhb3q9+r02yVw4KuvotbRhfCuE3QQ3BxYbBwtMzH45j2L
         aR981j/HBMyy8yqRTXlSPzglQN6qvW3PGTNjtTgZepNrdGCKdHaHikUe4N4JK/OXWm0U
         H67aFvW3M4tbvMJVJll6DVmz/mxIyNhzePp5RCbwn4SH1B4kRfd3RFKWeoEPNnxGY2a3
         5U8ri1nG0+/6zzbjPZVRz+lRvfAFk9kTtg1sQMZTnD2ap9u1GQPsMAVBEly732m36iGG
         ptRkjONGMWSINH2B4ZXCiJE63ijdUJz4BEVzIJMy/GWRiV3Sngn+XGpCYEtxfpjRpNU0
         2FOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Bew8qUCK1VrN0VQJNLhW1NacYLqOiV0G6ii2zRK6mP0=;
        b=Jal7dB8dP+qliK3B5tS0mMx2PNf5MxWkOpXqcVBTB9Lx9qPgaL39mEVL0ZpEZ8GU95
         Pm7gpsPlIWXT+xt6+fJdM4Jvg9EVTEZZoYADrmIzjQyoxAAX/08v5v5erMllkShrPR+3
         qtWqHvbluxx7C9iNT/Iz7PXFm6aeH47YrOl67YuMuUQhaEIdHTdifoZUU10ayojF8emn
         Oumis3HhtcagJ2KIHVThYGwfkiJdnqbe6HRfFwmOiyIQS5vHrNud6nurxeIS8U4lg9Um
         7ug0g4N5jvoqcUoH0BwrAuSh3wlszJmbaA7C8HXwA8Kf1qzahLn/p2z+siXILzbMtJd0
         405w==
X-Gm-Message-State: AOAM532e4yWUblK0dfNsoZyOBnSiAl7CoFFjMU5DfFtg+IZmByakb6kz
        xbAoCjj35Bz7bCGKhmrv0YinS1dlNA2sYjRVyEyBJDOj+dPCEg==
X-Google-Smtp-Source: ABdhPJwCtB7SK5idQ/dcJEn0xU3T5BcRgQp3ucW5tUe4kqSn6Gx5Rw3rGl4BsKa3Z+Qnb1Xs+2fS4HXx1kRDJ8y85p4=
X-Received: by 2002:a19:5e15:: with SMTP id s21mr608554lfb.282.1626980348304;
 Thu, 22 Jul 2021 11:59:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jul 2021 13:58:35 -0500
Message-ID: <CAH2r5mtF8THo1w_j--jGTLByKWHgq+TJgAX8ZbZyLcCxvfP3KA@mail.gmail.com>
Subject: [PATCH][CIFS] Clarify SMB1 code for POSIX Create
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b7de0805c7bae110"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b7de0805c7bae110
Content-Type: text/plain; charset="UTF-8"

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes) for SMB1 CIFSPOSIXCreate. This changeset
doesn't change the address but makes it slightly clearer.

Addresses-Coverity: 711518 ("Out of bounds write")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f72e3b3dca69..d4144c182604 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1081,7 +1081,8 @@ CIFSPOSIXCreate(const unsigned int xid, struct
cifs_tcon *tcon,
  param_offset = offsetof(struct smb_com_transaction2_spi_req,
  InformationLevel) - 4;
  offset = param_offset + params;
- pdata = (OPEN_PSX_REQ *)(((char *)&pSMB->hdr.Protocol) + offset);
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
+ pdata = (OPEN_PSX_REQ *)((char *)(pSMB) + offset + 4);
  pdata->Level = cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC);
  pdata->Permissions = cpu_to_le64(mode);
  pdata->PosixOpenFlags = cpu_to_le32(posix_flags);

-- 
Thanks,

Steve

--000000000000b7de0805c7bae110
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-POSIX-Create.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-POSIX-Create.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krfa0zlb0>
X-Attachment-Id: f_krfa0zlb0

RnJvbSAyMWE2NDkxMDk5N2UwYzFkMjY4YmViZjliMTIxN2JhNTgwNGQ1OTJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjIgSnVsIDIwMjEgMTM6NTA6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBD
SUZTOiBDbGFyaWZ5IFNNQjEgY29kZSBmb3IgUE9TSVggQ3JlYXRlCgpDb3Zlcml0eSBhbHNvIGNv
bXBsYWlucyBhYm91dCB0aGUgd2F5IHdlIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0CihzdGFydGluZyBm
cm9tIHRoZSBhZGRyZXNzIG9mIGEgNCBieXRlIGFycmF5IHdpdGhpbiB0aGUKaGVhZGVyIHN0cnVj
dHVyZSByYXRoZXIgdGhhbiBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgdGhlIHN0cnVjdApwbHVzIDQg
Ynl0ZXMpIGZvciBTTUIxIENJRlNQT1NJWENyZWF0ZS4gVGhpcyBjaGFuZ2VzZXQKZG9lc24ndCBj
aGFuZ2UgdGhlIGFkZHJlc3MgYnV0IG1ha2VzIGl0IHNsaWdodGx5IGNsZWFyZXIuCgpBZGRyZXNz
ZXMtQ292ZXJpdHk6IDcxMTUxOCAoIk91dCBvZiBib3VuZHMgd3JpdGUiKQpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZz
c21iLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMK
aW5kZXggZjcyZTNiM2RjYTY5Li5kNDE0NGMxODI2MDQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0xMDgxLDcgKzEwODEsOCBAQCBDSUZT
UE9TSVhDcmVhdGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKIAlwYXJhbV9vZmZzZXQgPSBvZmZzZXRvZihzdHJ1Y3Qgc21iX2NvbV90cmFuc2FjdGlvbjJf
c3BpX3JlcSwKIAkJCQlJbmZvcm1hdGlvbkxldmVsKSAtIDQ7CiAJb2Zmc2V0ID0gcGFyYW1fb2Zm
c2V0ICsgcGFyYW1zOwotCXBkYXRhID0gKE9QRU5fUFNYX1JFUSAqKSgoKGNoYXIgKikmcFNNQi0+
aGRyLlByb3RvY29sKSArIG9mZnNldCk7CisJLyogU01CIG9mZnNldHMgYXJlIGZyb20gdGhlIGJl
Z2lubmluZyBvZiBTTUIgd2hpY2ggaXMgNCBieXRlcyBpbiwgYWZ0ZXIgUkZDMTAwMSBmaWVsZCAq
LworCXBkYXRhID0gKE9QRU5fUFNYX1JFUSAqKSgoY2hhciAqKShwU01CKSArIG9mZnNldCArIDQp
OwogCXBkYXRhLT5MZXZlbCA9IGNwdV90b19sZTE2KFNNQl9RVUVSWV9GSUxFX1VOSVhfQkFTSUMp
OwogCXBkYXRhLT5QZXJtaXNzaW9ucyA9IGNwdV90b19sZTY0KG1vZGUpOwogCXBkYXRhLT5Qb3Np
eE9wZW5GbGFncyA9IGNwdV90b19sZTMyKHBvc2l4X2ZsYWdzKTsKLS0gCjIuMzAuMgoK
--000000000000b7de0805c7bae110--
