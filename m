Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54768C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 21:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080CA2086A
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 21:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/C+x+/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfCQVGh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:06:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46005 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfCQVGh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 17:06:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id v21so9816595pfm.12;
        Sun, 17 Mar 2019 14:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=c74hnbM33Kw0VEYelm1s0/qHmPaMWGkAYQa/r0ee8JI=;
        b=O/C+x+/cnb9QhUdhakSqrr8igZ6dHerplspoTgZjxV10Hnh+nGNjvvZl5eET2RAqPR
         ogOwB7wIWzi+UKUFcOsdYBvvN43meGscoMmUhqSCwnc0/+D59zxdlohIwVJ6P2YXHHCZ
         18TCrsXKjza702Qy2kzcdAEpDYwO4jGxV8Q/jssuOSlzdtdn6Hj+sUUsnb2+IHQR3F3y
         WodgioP6Q5LiD0+axw0/W6UjcvdMVTsJrBtditYFB22fQGxheab1qUKRH32Ro2Y1M2oh
         SCqe+camNHfKugSnI1SkNQsv4DZxrHz7qyCvxti154GWdcySfYzgxRHOlNbbAHL6Nx0p
         G+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=c74hnbM33Kw0VEYelm1s0/qHmPaMWGkAYQa/r0ee8JI=;
        b=T0CJ9d++ibOX7OeecQsZB1kKhXhzvwf5zMh62SzBnclq/47fAQSbMHgn2ZwPe2R45i
         mQm6LSrjTSEJGqlaiMVcAAKbVhNdBwrRxHveZsgCz5JxKsbvxe0ui1K6Sv4JHkj/0Xz2
         2POF7b5v+tPYVUbsL8XpQgzYZfIg8CID/H8Ci9pWhpjLlmAl37P2xcSRX7ZHMIyVSnaT
         3HxnzERstG+enmQC+jgUaZTYvHyskfuwxxdAUXa3Ca1YVaIqEKzTwFfSxpZnOwdQB13Q
         DORC01zbaxronYSEDPlLdleKSqB30umaIPsEBn906IoCMmhqJbOgSHzLg5gkAVyvBUSp
         Er0g==
X-Gm-Message-State: APjAAAVigEEZVOCN/U5jicXk2hDS0zJf0GBPmYu7JSdyuc1kEZKbybcH
        LKqWeGnSAD3l0/fu84KvkhmCzrLQiXcIriyivZPdJXkw
X-Google-Smtp-Source: APXvYqyt5itSzYeDhR4UBgfI6xVZLloC6yR/pp637cnc4OpHCplzVpFXAK89m7fb7HddJjiC/fUokCHe5/2d5eciWok=
X-Received: by 2002:a65:508b:: with SMTP id r11mr14529005pgp.242.1552856795791;
 Sun, 17 Mar 2019 14:06:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Mar 2019 16:06:24 -0500
Message-ID: <CAH2r5mtfoktT3-yVgmT6=BSSyn9_wGpBgG5Yf3mf+Pedzji98A@mail.gmail.com>
Subject: [PATCH][SMB3] Fix incorrect status to errno code mapping for OBJECTID_NOT_FOUND
To:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000b37436058450a572"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b37436058450a572
Content-Type: text/plain; charset="UTF-8"

It was mapped to EIO which can be confusing when user space
queries for an object GUID for an object for which the server
file system doesn't support (or hasn't saved one).

As Amir Goldstein suggested this is similar to ENOATTR
(equivalently ENODATA in Linux errno definitions) so
changing NT STATUS code mapping for OBJECTID_NOT_FOUND
to ENODATA.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Amir Goldstein <amir73il@gmail.com>
---
 fs/cifs/smb2maperror.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 924269cec135..e32c264e3adb 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -1036,7 +1036,8 @@ static const struct status_to_posix_error
smb2_error_map_table[] = {
     {STATUS_UNFINISHED_CONTEXT_DELETED, -EIO,
     "STATUS_UNFINISHED_CONTEXT_DELETED"},
     {STATUS_NO_TGT_REPLY, -EIO, "STATUS_NO_TGT_REPLY"},
-    {STATUS_OBJECTID_NOT_FOUND, -EIO, "STATUS_OBJECTID_NOT_FOUND"},
+    /* Note that ENOATTTR and ENODATA are the same errno */
+    {STATUS_OBJECTID_NOT_FOUND, -ENODATA, "STATUS_OBJECTID_NOT_FOUND"},
     {STATUS_NO_IP_ADDRESSES, -EIO, "STATUS_NO_IP_ADDRESSES"},
     {STATUS_WRONG_CREDENTIAL_HANDLE, -EIO,
     "STATUS_WRONG_CREDENTIAL_HANDLE"},

-- 
Thanks,

Steve

--000000000000b37436058450a572
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-fix-incorrect-error-code-mapping-for-OBJECTID_N.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-fix-incorrect-error-code-mapping-for-OBJECTID_N.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtdes2pg0>
X-Attachment-Id: f_jtdes2pg0

RnJvbSBlODRiODM3MmYwNDE4NTE2ZGZlNzE2OTc0OWVmZjhjNTlmMmU3YjViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTcgTWFyIDIwMTkgMTU6NTg6MzggLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
U01CM10gZml4IGluY29ycmVjdCBlcnJvciBjb2RlIG1hcHBpbmcgZm9yCiBPQkpFQ1RJRF9OT1Rf
Rk9VTkQKCkl0IHdhcyBtYXBwZWQgdG8gRUlPIHdoaWNoIGNhbiBiZSBjb25mdXNpbmcgd2hlbiB1
c2VyIHNwYWNlCnF1ZXJpZXMgZm9yIGFuIG9iamVjdCBHVUlEIGZvciBhbiBvYmplY3QgZm9yIHdo
aWNoIHRoZSBzZXJ2ZXIKZmlsZSBzeXN0ZW0gZG9lc24ndCBzdXBwb3J0IChvciBoYXNuJ3Qgc2F2
ZWQgb25lKS4KCkFzIEFtaXIgR29sZHN0ZWluIHN1Z2dlc3RlZCB0aGlzIGlzIHNpbWlsYXIgdG8g
RU5PQVRUUgooZXF1aXZhbGVudGx5IEVOT0RBVEEgaW4gTGludXggZXJybm8gZGVmaW5pdGlvbnMp
IHNvCmNoYW5naW5nIE5UIFNUQVRVUyBjb2RlIG1hcHBpbmcgZm9yIE9CSkVDVElEX05PVF9GT1VO
RAp0byBFTk9EQVRBLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgpDQzogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBm
cy9jaWZzL3NtYjJtYXBlcnJvci5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtYXBlcnJvci5j
IGIvZnMvY2lmcy9zbWIybWFwZXJyb3IuYwppbmRleCA5MjQyNjljZWMxMzUuLmUzMmMyNjRlM2Fk
YiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIybWFwZXJyb3IuYworKysgYi9mcy9jaWZzL3NtYjJt
YXBlcnJvci5jCkBAIC0xMDM2LDcgKzEwMzYsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN0YXR1
c190b19wb3NpeF9lcnJvciBzbWIyX2Vycm9yX21hcF90YWJsZVtdID0gewogCXtTVEFUVVNfVU5G
SU5JU0hFRF9DT05URVhUX0RFTEVURUQsIC1FSU8sCiAJIlNUQVRVU19VTkZJTklTSEVEX0NPTlRF
WFRfREVMRVRFRCJ9LAogCXtTVEFUVVNfTk9fVEdUX1JFUExZLCAtRUlPLCAiU1RBVFVTX05PX1RH
VF9SRVBMWSJ9LAotCXtTVEFUVVNfT0JKRUNUSURfTk9UX0ZPVU5ELCAtRUlPLCAiU1RBVFVTX09C
SkVDVElEX05PVF9GT1VORCJ9LAorCS8qIE5vdGUgdGhhdCBFTk9BVFRUUiBhbmQgRU5PREFUQSBh
cmUgdGhlIHNhbWUgZXJybm8gKi8KKwl7U1RBVFVTX09CSkVDVElEX05PVF9GT1VORCwgLUVOT0RB
VEEsICJTVEFUVVNfT0JKRUNUSURfTk9UX0ZPVU5EIn0sCiAJe1NUQVRVU19OT19JUF9BRERSRVNT
RVMsIC1FSU8sICJTVEFUVVNfTk9fSVBfQUREUkVTU0VTIn0sCiAJe1NUQVRVU19XUk9OR19DUkVE
RU5USUFMX0hBTkRMRSwgLUVJTywKIAkiU1RBVFVTX1dST05HX0NSRURFTlRJQUxfSEFORExFIn0s
Ci0tIAoyLjE3LjEKCg==
--000000000000b37436058450a572--
