Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09343C4CEC6
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 23:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD07220856
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 23:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yfdyl+RS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfILXKW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 19:10:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35494 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfILXKW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 19:10:22 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so58164576ion.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 16:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jbEFJLXBj4+RrNqguBbv/s6oOBHNgnaaJwvXHPGnRic=;
        b=Yfdyl+RSLlUcIiM3VLw/lWlI+MvfzOp4l3spPrJNepyYuHeVr0+awEMdufMDQErH1e
         +9O7hDktK44yA4XVWtqAHNH8OXCTnPO3GuCDoXHj/IjFsOboKIjH0yG/+tGp4zIDav9I
         0BieIjzL9enfcfclORmbBjDPMH8pHDBJm550UPfD+25EL90v0YLjNcZUIjM1u5qs1MlQ
         LK6/BRbjhUGgq1OBaXwQy44OXXcCd0H50EIHu5uqH53L92+9PxJEORURj9n6Xa9hIG8e
         AMjmuWNa1RbnCMAsLKDYXSSkZGxQjsp/Yr46k3vIiTzsEBs+f9DREDb8DiSY5hb5MBSI
         Gd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jbEFJLXBj4+RrNqguBbv/s6oOBHNgnaaJwvXHPGnRic=;
        b=dZbfIrfLPltwwkbiXmH2YnKDKcauo9rM6vcj+Lp9vf4gUI+4EMv0yA9x7TcvA7sMlE
         rJSMZdPtnZPRGvlDTu8qv20YbiREzpnhYCQ6vtUGdCnlG2cYRZlhrcuTKzWhRig9zMpI
         /RTTOZ7KSI4+WkweG5fC1gvDRXueeAyTVu8YSUTq3EwmiMCpHnjkFcKMpVey4GA88IFH
         PCpOa2ligAsNWkpJJlzKfU36H+q+qlCjTQBskaL9FK1CmvTrU2bHcfGAuK21R9SO2qrI
         ju/FJitZz3bBQBdudHCHvTT+BmyrCS+iilCBudgKAbIj2tmEcZZpFmNUbfYv9F79vPnM
         gvJw==
X-Gm-Message-State: APjAAAUI576xjFUqmzO/9Pn9MNS5lcQ+namd7apCgQ9GoYWx8h0/Yj+J
        QJJnPvFnM6HqQQmbebD3UTZNVtvCwX9vX0KukEF/wWby
X-Google-Smtp-Source: APXvYqxrt0ozdkHS2+mgDLZf1HPseqdGlRw6EU/IDVCCmwsqCYAnvEe0zBdM2KhzFwP4sz+BONL3fRWrtKTzf0XKXD8=
X-Received: by 2002:a6b:c38f:: with SMTP id t137mr861740iof.137.1568329820728;
 Thu, 12 Sep 2019 16:10:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Sep 2019 18:10:08 -0500
Message-ID: <CAH2r5mtpx88bvKPDZs24ipxH+pm_82ug_w2QPKpB+9Z0xjAYiA@mail.gmail.com>
Subject: [PATCH] smb3: fix unmount hang in open_shroot
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="000000000000db1e300592633dcf"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000db1e300592633dcf
Content-Type: text/plain; charset="UTF-8"

smb3: fix unmount hang in open_shroot

An earlier patch "CIFS: fix deadlock in cached root handling"
did not completely address the deadlock in open_shroot. This
patch addresses the deadlock.

In testing the recent patch:
  smb3: improve handling of share deleted (and share recreated)
we were able to reproduce the open_shroot deadlock to one
of the target servers in unmount in a delete share scenario.

Fixes: 7e5a70ad88b1e ("CIFS: fix deadlock in cached root handling")

Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/smb2ops.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3672ce0bfbaf..150327ebb2b4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -658,6 +658,15 @@ int open_shroot(unsigned int xid, struct
cifs_tcon *tcon, struct cifs_fid *pfid)
  return 0;
  }

+ /*
+ * We do not hold the lock for the open because in case
+ * SMB2_open needs to reconnect, it will end up calling
+ * cifs_mark_open_files_invalid() which takes the lock again
+ * thus causing a deadlock
+ */
+
+ mutex_unlock(&tcon->crfid.fid_mutex);
+
  if (smb3_encryption_required(tcon))
  flags |= CIFS_TRANSFORM_REQ;

@@ -696,14 +705,6 @@ int open_shroot(unsigned int xid, struct
cifs_tcon *tcon, struct cifs_fid *pfid)

  smb2_set_related(&rqst[1]);

- /*
- * We do not hold the lock for the open because in case
- * SMB2_open needs to reconnect, it will end up calling
- * cifs_mark_open_files_invalid() which takes the lock again
- * thus causing a deadlock
- */
-
- mutex_unlock(&tcon->crfid.fid_mutex);
  rc = compound_send_recv(xid, ses, flags, 2, rqst,
  resp_buftype, rsp_iov);
  mutex_lock(&tcon->crfid.fid_mutex);

--
Thanks,

Steve

--000000000000db1e300592633dcf
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-unmount-hang-in-open_shroot.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-unmount-hang-in-open_shroot.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0hb23k70>
X-Attachment-Id: f_k0hb23k70

RnJvbSAxZjE2YmIwNDgzYTEzMzg4MmRjMmY0MDVkZmNjMjZkYWEzMGI5MTE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTIgU2VwIDIwMTkgMTc6NTI6NTQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggdW5tb3VudCBoYW5nIGluIG9wZW5fc2hyb290CgpBbiBlYXJsaWVyIHBhdGNoICJD
SUZTOiBmaXggZGVhZGxvY2sgaW4gY2FjaGVkIHJvb3QgaGFuZGxpbmciCmRpZCBub3QgY29tcGxl
dGVseSBhZGRyZXNzIHRoZSBkZWFkbG9jayBpbiBvcGVuX3Nocm9vdC4gVGhpcwpwYXRjaCBhZGRy
ZXNzZXMgdGhlIGRlYWRsb2NrLgoKSW4gdGVzdGluZyB0aGUgcmVjZW50IHBhdGNoOgogIHNtYjM6
IGltcHJvdmUgaGFuZGxpbmcgb2Ygc2hhcmUgZGVsZXRlZCAoYW5kIHNoYXJlIHJlY3JlYXRlZCkK
d2Ugd2VyZSBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgb3Blbl9zaHJvb3QgZGVhZGxvY2sgdG8gb25l
Cm9mIHRoZSB0YXJnZXQgc2VydmVycyBpbiB1bm1vdW50IGluIGEgZGVsZXRlIHNoYXJlIHNjZW5h
cmlvLgoKRml4ZXM6IDdlNWE3MGFkODhiMWUgKCJDSUZTOiBmaXggZGVhZGxvY2sgaW4gY2FjaGVk
IHJvb3QgaGFuZGxpbmciKQoKU3VnZ2VzdGVkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZA
bWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNy
b3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29m
dC5jb20+CkNDOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpDQzogU3RhYmxlIDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgMTcgKysrKysr
KysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwpp
bmRleCAzNjcyY2UwYmZiYWYuLjE1MDMyN2ViYjJiNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIy
b3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTY1OCw2ICs2NTgsMTUgQEAgaW50IG9w
ZW5fc2hyb290KHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVj
dCBjaWZzX2ZpZCAqcGZpZCkKIAkJcmV0dXJuIDA7CiAJfQogCisJLyoKKwkgKiBXZSBkbyBub3Qg
aG9sZCB0aGUgbG9jayBmb3IgdGhlIG9wZW4gYmVjYXVzZSBpbiBjYXNlCisJICogU01CMl9vcGVu
IG5lZWRzIHRvIHJlY29ubmVjdCwgaXQgd2lsbCBlbmQgdXAgY2FsbGluZworCSAqIGNpZnNfbWFy
a19vcGVuX2ZpbGVzX2ludmFsaWQoKSB3aGljaCB0YWtlcyB0aGUgbG9jayBhZ2FpbgorCSAqIHRo
dXMgY2F1c2luZyBhIGRlYWRsb2NrCisJICovCisKKwltdXRleF91bmxvY2soJnRjb24tPmNyZmlk
LmZpZF9tdXRleCk7CisKIAlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pKQogCQlm
bGFncyB8PSBDSUZTX1RSQU5TRk9STV9SRVE7CiAKQEAgLTY5NiwxNCArNzA1LDYgQEAgaW50IG9w
ZW5fc2hyb290KHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVj
dCBjaWZzX2ZpZCAqcGZpZCkKIAogCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbMV0pOwogCi0JLyoK
LQkgKiBXZSBkbyBub3QgaG9sZCB0aGUgbG9jayBmb3IgdGhlIG9wZW4gYmVjYXVzZSBpbiBjYXNl
Ci0JICogU01CMl9vcGVuIG5lZWRzIHRvIHJlY29ubmVjdCwgaXQgd2lsbCBlbmQgdXAgY2FsbGlu
ZwotCSAqIGNpZnNfbWFya19vcGVuX2ZpbGVzX2ludmFsaWQoKSB3aGljaCB0YWtlcyB0aGUgbG9j
ayBhZ2FpbgotCSAqIHRodXMgY2F1c2luZyBhIGRlYWRsb2NrCi0JICovCi0KLQltdXRleF91bmxv
Y2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7CiAJcmMgPSBjb21wb3VuZF9zZW5kX3JlY3YoeGlk
LCBzZXMsIGZsYWdzLCAyLCBycXN0LAogCQkJCXJlc3BfYnVmdHlwZSwgcnNwX2lvdik7CiAJbXV0
ZXhfbG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4KTsKLS0gCjIuMjAuMQoK
--000000000000db1e300592633dcf--
