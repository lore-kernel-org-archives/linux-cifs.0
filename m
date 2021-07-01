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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B9EC11F67
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 22:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6BF361154
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 22:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhGAWzx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Jul 2021 18:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhGAWzu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Jul 2021 18:55:50 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DE0C061762
        for <linux-cifs@vger.kernel.org>; Thu,  1 Jul 2021 15:53:19 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h6so10681287ljl.8
        for <linux-cifs@vger.kernel.org>; Thu, 01 Jul 2021 15:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0OOPFhTOrkLzDvdmQCeMlEth2/nPkgBqar5N15NOnZg=;
        b=K8dpYTFrYly8ENqFh0Uo+corPs29013CCteecULT4hW4gEA548hN+xLdP6Bu1T9ECu
         iiqbX4i0QAHx2iGwgJeIswHyEZWM5/WVm5VCzNzHZU6l+9IcpACHnKylrVzpXF+y7g62
         Yhy8GizHF3W64i3RJ0ks7nS6b1LD2UZnGO0eDb3MMO5Kvew/f7hOtjnMXuPE/Mt1lMuC
         Gc84Jds8yPBGm/NDbWXumFZXB/K10T5G2RWoXrPukE8xux4lYdgTps0yEHzOwx/SKlUY
         xdeUcPJmATMMFsna9DMGnPJsx5IyvwA4+sBRilp//XRfMfclC2p7hZFxdN/Q7OVWOzdw
         Gaew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0OOPFhTOrkLzDvdmQCeMlEth2/nPkgBqar5N15NOnZg=;
        b=UwqY27sATVBr0B5C2ar+XUQ72blwZ4OCzK2RPn7K7lawB7eSeRHa1bs5EVdTuOCgx9
         lEmdUevjYQtgBmNKAuIRLvm41v4Lhg5PfVrr9Q41Iu6qsZL4s+giPxvvJD90Mmrs9HS+
         p+Mo8wrURfmuywYtjujAMhUcMF81zRYPoL4y6IgOTM8UYXeUCxvGgW63Gv/7sQxviVI2
         piQW5AgFw2GgCl9h20dgjjojNP00U6RXENQ4fI7U0BUC55nac4nntumMcd8MRLTBLI7C
         BXUrliBy1FMJobqafn5jsRCJ2IwjDtHigwFO9FbvI9SJdGoQhs1hsN7QmMkMw8MoCjC4
         Bm+w==
X-Gm-Message-State: AOAM530ge1jPV9E3VZ1DFnUVVj5uqSTN2TtcDAV4fu+072PRvjRRIXLj
        kOBD1TganLHNzEWFg5WaoAKZuDhBXtpIIVW8re7Xg3Ipv1ihBg==
X-Google-Smtp-Source: ABdhPJxGW5MkIloVOuRZ6aHfAuTgG0maV0Q8LxHPnLNkEunljFFyKoKCNJUFkBJ7awJvRBb1Ok+/zUbLowxpJzK5Vuw=
X-Received: by 2002:a05:651c:a07:: with SMTP id k7mr1419169ljq.477.1625179997761;
 Thu, 01 Jul 2021 15:53:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Jul 2021 17:53:06 -0500
Message-ID: <CAH2r5mtHr8eQJo=L1of-PHHNa8iuGUQqWzAAFdpT0=14rvKSkQ@mail.gmail.com>
Subject: [PATCH] cifs: clarify SMB1 code for UnixCreateHardLink
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007688c105c617b456"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007688c105c617b456
Content-Type: text/plain; charset="UTF-8"

Coverity complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes).  This doesn't change the address but
makes it slightly clearer.

Addresses-Coverity: 711529 ("Out of bounds read")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifspdu.h | 1 +
 fs/cifs/cifssmb.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 0923f72d27e9..f6e235001358 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1785,6 +1785,7 @@ struct smb_com_transaction2_sfi_req {
  __u16 Fid;
  __le16 InformationLevel;
  __u16 Reserved4;
+ __u8  payload[];
 } __attribute__((packed));

 struct smb_com_transaction2_sfi_rsp {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 58ebec4d4413..ea12fa6eacb6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3009,7 +3009,8 @@ CIFSUnixCreateHardLink(const unsigned int xid,
struct cifs_tcon *tcon,
  InformationLevel) - 4;
  offset = param_offset + params;

- data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
+ data_offset = (char *)pSMB + offset + 4;
  if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
  name_len_target =
      cifsConvertToUTF16((__le16 *) data_offset, fromName,

-- 
Thanks,

Steve

--0000000000007688c105c617b456
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-clarify-SMB1-code-for-UnixCreateHardLink.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-clarify-SMB1-code-for-UnixCreateHardLink.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqli6dfq0>
X-Attachment-Id: f_kqli6dfq0

RnJvbSAxNmU3OTBiMzUyNTVjMWU3MDk2NGZkNmVlOTI3MmJjNjAzNjE0YWExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMSBKdWwgMjAyMSAxNzo0NjoyMyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGNsYXJpZnkgU01CMSBjb2RlIGZvciBVbml4Q3JlYXRlSGFyZExpbmsKCkNvdmVyaXR5IGNv
bXBsYWlucyBhYm91dCB0aGUgd2F5IHdlIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0CihzdGFydGluZyBm
cm9tIHRoZSBhZGRyZXNzIG9mIGEgNCBieXRlIGFycmF5IHdpdGhpbiB0aGUKaGVhZGVyIHN0cnVj
dHVyZSByYXRoZXIgdGhhbiBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgdGhlIHN0cnVjdApwbHVzIDQg
Ynl0ZXMpLiAgVGhpcyBkb2Vzbid0IGNoYW5nZSB0aGUgYWRkcmVzcyBidXQKbWFrZXMgaXQgc2xp
Z2h0bHkgY2xlYXJlci4KCkFkZHJlc3Nlcy1Db3Zlcml0eTogNzExNTI5ICgiT3V0IG9mIGJvdW5k
cyByZWFkIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvY2lmc3BkdS5oIHwgMSArCiBmcy9jaWZzL2NpZnNzbWIuYyB8IDMg
KystCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1LmgKaW5kZXggMDky
M2Y3MmQyN2U5Li5mNmUyMzUwMDEzNTggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3BkdS5oCisr
KyBiL2ZzL2NpZnMvY2lmc3BkdS5oCkBAIC0xNzg1LDYgKzE3ODUsNyBAQCBzdHJ1Y3Qgc21iX2Nv
bV90cmFuc2FjdGlvbjJfc2ZpX3JlcSB7CiAJX191MTYgRmlkOwogCV9fbGUxNiBJbmZvcm1hdGlv
bkxldmVsOwogCV9fdTE2IFJlc2VydmVkNDsKKwlfX3U4ICBwYXlsb2FkW107CiB9IF9fYXR0cmli
dXRlX18oKHBhY2tlZCkpOwogCiBzdHJ1Y3Qgc21iX2NvbV90cmFuc2FjdGlvbjJfc2ZpX3JzcCB7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jCmluZGV4
IDU4ZWJlYzRkNDQxMy4uZWExMmZhNmVhY2I2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIu
YworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtMzAwOSw3ICszMDA5LDggQEAgQ0lGU1VuaXhD
cmVhdGVIYXJkTGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCQkJCUluZm9ybWF0aW9uTGV2ZWwpIC0gNDsKIAlvZmZzZXQgPSBwYXJhbV9vZmZzZXQg
KyBwYXJhbXM7CiAKLQlkYXRhX29mZnNldCA9IChjaGFyICopICgmcFNNQi0+aGRyLlByb3RvY29s
KSArIG9mZnNldDsKKwkvKiBTTUIgb2Zmc2V0cyBhcmUgZnJvbSB0aGUgYmVnaW5uaW5nIG9mIFNN
QiB3aGljaCBpcyA0IGJ5dGVzIGluLCBhZnRlciBSRkMxMDAxIGZpZWxkICovCisJZGF0YV9vZmZz
ZXQgPSAoY2hhciAqKXBTTUIgKyBvZmZzZXQgKyA0OwogCWlmIChwU01CLT5oZHIuRmxhZ3MyICYg
U01CRkxHMl9VTklDT0RFKSB7CiAJCW5hbWVfbGVuX3RhcmdldCA9CiAJCSAgICBjaWZzQ29udmVy
dFRvVVRGMTYoKF9fbGUxNiAqKSBkYXRhX29mZnNldCwgZnJvbU5hbWUsCi0tIAoyLjMwLjIKCg==
--0000000000007688c105c617b456--
