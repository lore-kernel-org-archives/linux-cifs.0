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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C958FC4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 07:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ECCE23B79
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 07:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgLIHYd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 02:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgLIHYd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 02:24:33 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F8C0613CF
        for <linux-cifs@vger.kernel.org>; Tue,  8 Dec 2020 23:23:52 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id h19so1697973lfc.12
        for <linux-cifs@vger.kernel.org>; Tue, 08 Dec 2020 23:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ywxX6eCHKkJKxEsUvMOdH5R1/382UTrHcuYIUV0eKE4=;
        b=AZ9bFh4vKpquNV+I5YEF5KjBO/o/6auzhMj+/fG36G3+MAuLBqWr+6S611mgOzbF3q
         LjlGzpK9/0sHOgKsYIHFjnqVSJnGYVbhGU7h9jaYMdapRo7QrGuadCrimlhy9VsclF4A
         kxWJ6vW7imewPFNWfBX/hoM3PRaC14pMt9pz+M10iuXFojZkXq9UWL59tWIA8zzjDnFV
         xscBubmg2ZKaP5P6oZaEq3FIR6MTxHb07HLER5Hq6Kxw+JHZzuY7ejb5e67KWTF212Cy
         jrJrBghL0KQ1e3ClRPeTZyaBdB9qklUy9SURwpJsbdgoXlDP3DSLO7P42U22/51101Wr
         hE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ywxX6eCHKkJKxEsUvMOdH5R1/382UTrHcuYIUV0eKE4=;
        b=i1IUVE/UT4lqMk8n97Qqn7a6gWRuKl1rNe3xl7VrSsgLncLOhIfIq0mUQYae4+s+xG
         2aDWXiGzN3mI8J7MXzqhG3bl4ASm07c/p6N4vKkyyKDOPvgkcPzzyxJo71BsU9uJBame
         itJOWinweSguPBPtiaST73B3XnAW2XVyPe/2Iy/rFs3tv+iSoi9VwLg5ft0ZXVT2E9B6
         DWvlfNRnjrmQsRwekbnNEx6AKy0+lnNT5tOMJdsYDElII2IBYEHvaQzVu+0CCWa0662x
         YHt1OLKyHqt0mmX1lxY6YEBELO4rOjE+Wa29/upt+RktTk5k3sMVQUFlcY+Tuf8EzwGl
         XFeg==
X-Gm-Message-State: AOAM533QiC1KAZgI6cQtTYj0ZOhLW4tsKa8I/OdjuzhHqGQzFaayi6ge
        ZpOaXz7VahlukgxPo2oNhron85tL4RqkHwxtycZq5ikGLHzHCQ==
X-Google-Smtp-Source: ABdhPJwPriR4xKyQTtk72xPxtjgEwlkGCt9f32RzaXUYg+UB8syAiJ9OyNg73+4H5svLxTwbaMPsEDkQrfJy6PRBEq4=
X-Received: by 2002:ac2:48b2:: with SMTP id u18mr563098lfg.313.1607498630472;
 Tue, 08 Dec 2020 23:23:50 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 9 Dec 2020 01:23:39 -0600
Message-ID: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO info
 on negprot rsp
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d8bf0805b602f0ea"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d8bf0805b602f0ea
Content-Type: text/plain; charset="UTF-8"

Azure does not send an SPNEGO blob in the negotiate protocol response,
so we shouldn't assume that it is there when validating the location
of the first negotiate context.  This avoids the potential confusing
mount warning:

   CIFS: Invalid negotiate context offset

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2misc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d88e2683626e..513507e4c4ad 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
smb2_sync_hdr *hdr, __u32 len,

  /* Make sure that negotiate contexts start after gss security blob */
  nc_offset = le32_to_cpu(pneg_rsp->NegotiateContextOffset);
- if (nc_offset < non_ctxlen) {
- pr_warn_once("Invalid negotiate context offset\n");
+ if (nc_offset + 1 < non_ctxlen) {
+ pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
  return 0;
- }
- size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;
+ } else if (nc_offset + 1 == non_ctxlen) {
+ cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
+ size_of_pad_before_neg_ctxts = 0;
+ } else
+ size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;

  /* Verify that at least minimal negotiate contexts fit within frame */
  if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_context))) {

-- 
Thanks,

Steve

--000000000000d8bf0805b602f0ea
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-remove-confusing-mount-warning-when-no-SPNE.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-remove-confusing-mount-warning-when-no-SPNE.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kih3652g0>
X-Attachment-Id: f_kih3652g0

RnJvbSBhMjZjNjc3NDRiMWFkMDYyMDlkYmYwYjM3YWFjMzA2YzFmM2M3YThkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBEZWMgMjAyMCAwMToxMjozNSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiByZW1vdmUgY29uZnVzaW5nIG1vdW50IHdhcm5pbmcgd2hlbiBubyBTUE5FR08gaW5m
bwogb24gbmVncHJvdCByc3AKCkF6dXJlIGRvZXMgbm90IHNlbmQgYW4gU1BORUdPIGJsb2IgaW4g
dGhlIG5lZ290aWF0ZSBwcm90b2NvbCByZXNwb25zZSwKc28gd2Ugc2hvdWxkbid0IGFzc3VtZSB0
aGF0IGl0IGlzIHRoZXJlIHdoZW4gdmFsaWRhdGluZyB0aGUgbG9jYXRpb24Kb2YgdGhlIGZpcnN0
IG5lZ290aWF0ZSBjb250ZXh0LiAgVGhpcyBhdm9pZHMgdGhlIHBvdGVudGlhbCBjb25mdXNpbmcK
bW91bnQgd2FybmluZzoKCiAgIENJRlM6IEludmFsaWQgbmVnb3RpYXRlIGNvbnRleHQgb2Zmc2V0
CgpDQzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIybWlzYy5j
IHwgMTEgKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIybWlzYy5jIGIvZnMvY2lmcy9zbWIy
bWlzYy5jCmluZGV4IGQ4OGUyNjgzNjI2ZS4uNTEzNTA3ZTRjNGFkIDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJtaXNjLmMKKysrIGIvZnMvY2lmcy9zbWIybWlzYy5jCkBAIC0xMDksMTEgKzEwOSwx
NCBAQCBzdGF0aWMgX191MzIgZ2V0X25lZ19jdHh0X2xlbihzdHJ1Y3Qgc21iMl9zeW5jX2hkciAq
aGRyLCBfX3UzMiBsZW4sCiAKIAkvKiBNYWtlIHN1cmUgdGhhdCBuZWdvdGlhdGUgY29udGV4dHMg
c3RhcnQgYWZ0ZXIgZ3NzIHNlY3VyaXR5IGJsb2IgKi8KIAluY19vZmZzZXQgPSBsZTMyX3RvX2Nw
dShwbmVnX3JzcC0+TmVnb3RpYXRlQ29udGV4dE9mZnNldCk7Ci0JaWYgKG5jX29mZnNldCA8IG5v
bl9jdHhsZW4pIHsKLQkJcHJfd2Fybl9vbmNlKCJJbnZhbGlkIG5lZ290aWF0ZSBjb250ZXh0IG9m
ZnNldFxuIik7CisJaWYgKG5jX29mZnNldCArIDEgPCBub25fY3R4bGVuKSB7CisJCXByX3dhcm5f
b25jZSgiSW52YWxpZCBuZWdvdGlhdGUgY29udGV4dCBvZmZzZXQgJWRcbiIsIG5jX29mZnNldCk7
CiAJCXJldHVybiAwOwotCX0KLQlzaXplX29mX3BhZF9iZWZvcmVfbmVnX2N0eHRzID0gbmNfb2Zm
c2V0IC0gbm9uX2N0eGxlbjsKKwl9IGVsc2UgaWYgKG5jX29mZnNldCArIDEgPT0gbm9uX2N0eGxl
bikgeworCQljaWZzX2RiZyhGWUksICJubyBTUE5FR08gc2VjdXJpdHkgYmxvYiBpbiBuZWdwcm90
IHJzcFxuIik7CisJCXNpemVfb2ZfcGFkX2JlZm9yZV9uZWdfY3R4dHMgPSAwOworCX0gZWxzZQor
CQlzaXplX29mX3BhZF9iZWZvcmVfbmVnX2N0eHRzID0gbmNfb2Zmc2V0IC0gbm9uX2N0eGxlbjsK
IAogCS8qIFZlcmlmeSB0aGF0IGF0IGxlYXN0IG1pbmltYWwgbmVnb3RpYXRlIGNvbnRleHRzIGZp
dCB3aXRoaW4gZnJhbWUgKi8KIAlpZiAobGVuIDwgbmNfb2Zmc2V0ICsgKG5lZ19jb3VudCAqIHNp
emVvZihzdHJ1Y3Qgc21iMl9uZWdfY29udGV4dCkpKSB7Ci0tIAoyLjI3LjAKCg==
--000000000000d8bf0805b602f0ea--
