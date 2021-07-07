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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCE7C07E96
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 02:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6408361CA2
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 02:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGGCe7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGCe6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jul 2021 22:34:58 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B6FC061574
        for <linux-cifs@vger.kernel.org>; Tue,  6 Jul 2021 19:32:18 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id e20so688665ljn.8
        for <linux-cifs@vger.kernel.org>; Tue, 06 Jul 2021 19:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=J6edy1Q3uFiMOoeNC4ijFGchxRUA2b/DRCKTIWpJrXs=;
        b=bsqB684MOtWpLXxeB1PoFHCipmdHwk+fl/KtrDldGIldqUXjRCjBGNzwIGBAY3Eu2S
         UgQrs5rkpX1nuPfoQOyYLd8Kmhn35LJlPtUkURJDqm2tXQWhdfEkqMqAqJCXLTe2GKya
         A7nx5AsUYwgSToai/VabFU9Bz53VbBD6Gx1nnOMK7RX9OljvHAYO4v+fhFDaQu+uMZ+K
         T8GrJXTxJJl/FkpsmmdtJkTo+XQiiTrYbTv1Dn9opOAhwlebtEiCCLzD/m43rxZwmawQ
         ySO13jWCpDxIqSH0fCrXNnuR3nDCxyRTx/4/j8qV98EGSijyA0c1F+7/LaN2ue5RWhEf
         /j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=J6edy1Q3uFiMOoeNC4ijFGchxRUA2b/DRCKTIWpJrXs=;
        b=Ea+LMw2potZ4HRUZb6phK+WurmMrNK6NuSfXb1flcZp8qgIJAvf815wh2CkqQOr/5U
         fWmWE1TqNFcip9/McYk+Bt8w/83GCuw+uw2EgGKq6OkUdllDq/R19LTb4OPTvxSsVvTk
         0zJ2CfgWaNe1IAVq78HpCT0C/xXuQq42BJ2G23FYKfuzR3MtKUvEttax3x8DeibiIOAN
         m6XltzrXODpBF1czGNHq4OQ9sKLaYvSVbeaR1bz9MdladmP/8XgC+adv2HJ/TxAdtLXX
         yIqBOrZgGJ5hPnqi3FjhxIWlVXxgNWZz1Z0SvQt9DSF8GVrBxcakinauxJqc/E8mzWrO
         TnXw==
X-Gm-Message-State: AOAM5339t3kaenm9O28OaKUh2RXS4/RnVr4w2mSXMRitwHKAf9Yr97Ls
        oaKeGRA+7tbgIzW+IFPSPLEW909bnq3vZ43MFSTngIGJaSw=
X-Google-Smtp-Source: ABdhPJxPCaprH5i5qQH1j6P36UAM/qJbPSiNzQDfIY0t9uMoc8Ztr7hbzUhXG+/uWIRJNYXjXCVMWtIbMF+Ch6rmEoY=
X-Received: by 2002:a2e:140e:: with SMTP id u14mr9944014ljd.148.1625625136264;
 Tue, 06 Jul 2021 19:32:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Jul 2021 21:32:02 -0500
Message-ID: <CAH2r5muHMjdmmK1GvhqEuqdvvncTvWYwWcd8avER1iQoGAt7LQ@mail.gmail.com>
Subject: [PATCH][CIFS] Clarify code for SMB1 SetFileSize
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c92d0105c67f58ee"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c92d0105c67f58ee
Content-Type: text/plain; charset="UTF-8"

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the header
structure rather than from the beginning of the struct plus
4 bytes) for setting the file size using SMB1. This changeset
doesn't change the address but makes it slightly clearer.

Addresses-Coverity: 711525 ("Out of bounds write")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 22b8c12962fa..a513a89aad1a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5628,9 +5628,9 @@ CIFSSMBSetFileSize(const unsigned int xid,
struct cifs_tcon *tcon,
  pSMB->TotalDataCount = pSMB->DataCount;
  pSMB->TotalParameterCount = pSMB->ParameterCount;
  pSMB->ParameterOffset = cpu_to_le16(param_offset);
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
  parm_data =
- (struct file_end_of_file_info *) (((char *) &pSMB->hdr.Protocol)
- + offset);
+ (struct file_end_of_file_info *)(((char *)pSMB) + offset + 4);
  pSMB->DataOffset = cpu_to_le16(offset);
  parm_data->FileSize = cpu_to_le64(size);
  pSMB->Fid = cfile->fid.netfid;

-- 
Thanks,

Steve

--000000000000c92d0105c67f58ee
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-SetFileSize.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-SetFileSize.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqsv82qj0>
X-Attachment-Id: f_kqsv82qj0

RnJvbSAxMTk0MTI4ZTM3ZWRmODZjN2UyYmJiNjFmODc4NTczZjU0ZmIwZTgwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNiBKdWwgMjAyMSAyMToyNzoyNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IENsYXJpZnkgU01CMSBjb2RlIGZvciBTZXRGaWxlU2l6ZQoKQ292ZXJpdHkgYWxzbyBjb21w
bGFpbnMgYWJvdXQgdGhlIHdheSB3ZSBjYWxjdWxhdGUgdGhlIG9mZnNldAooc3RhcnRpbmcgZnJv
bSB0aGUgYWRkcmVzcyBvZiBhIDQgYnl0ZSBhcnJheSB3aXRoaW4gdGhlIGhlYWRlcgpzdHJ1Y3R1
cmUgcmF0aGVyIHRoYW4gZnJvbSB0aGUgYmVnaW5uaW5nIG9mIHRoZSBzdHJ1Y3QgcGx1cwo0IGJ5
dGVzKSBmb3Igc2V0dGluZyB0aGUgZmlsZSBzaXplIHVzaW5nIFNNQjEuIFRoaXMgY2hhbmdlc2V0
CmRvZXNuJ3QgY2hhbmdlIHRoZSBhZGRyZXNzIGJ1dCBtYWtlcyBpdCBzbGlnaHRseSBjbGVhcmVy
LgoKQWRkcmVzc2VzLUNvdmVyaXR5OiA3MTE1MjUgKCJPdXQgb2YgYm91bmRzIHdyaXRlIikKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L2NpZnMvY2lmc3NtYi5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lm
cy9jaWZzc21iLmMKaW5kZXggMjJiOGMxMjk2MmZhLi5hNTEzYTg5YWFkMWEgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC01NjI4LDkgKzU2
MjgsOSBAQCBDSUZTU01CU2V0RmlsZVNpemUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAlwU01CLT5Ub3RhbERhdGFDb3VudCA9IHBTTUItPkRhdGFDb3Vu
dDsKIAlwU01CLT5Ub3RhbFBhcmFtZXRlckNvdW50ID0gcFNNQi0+UGFyYW1ldGVyQ291bnQ7CiAJ
cFNNQi0+UGFyYW1ldGVyT2Zmc2V0ID0gY3B1X3RvX2xlMTYocGFyYW1fb2Zmc2V0KTsKKwkvKiBT
TUIgb2Zmc2V0cyBhcmUgZnJvbSB0aGUgYmVnaW5uaW5nIG9mIFNNQiB3aGljaCBpcyA0IGJ5dGVz
IGluLCBhZnRlciBSRkMxMDAxIGZpZWxkICovCiAJcGFybV9kYXRhID0KLQkJKHN0cnVjdCBmaWxl
X2VuZF9vZl9maWxlX2luZm8gKikgKCgoY2hhciAqKSAmcFNNQi0+aGRyLlByb3RvY29sKQotCQkJ
CSsgb2Zmc2V0KTsKKwkJKHN0cnVjdCBmaWxlX2VuZF9vZl9maWxlX2luZm8gKikoKChjaGFyICop
cFNNQikgKyBvZmZzZXQgKyA0KTsKIAlwU01CLT5EYXRhT2Zmc2V0ID0gY3B1X3RvX2xlMTYob2Zm
c2V0KTsKIAlwYXJtX2RhdGEtPkZpbGVTaXplID0gY3B1X3RvX2xlNjQoc2l6ZSk7CiAJcFNNQi0+
RmlkID0gY2ZpbGUtPmZpZC5uZXRmaWQ7Ci0tIAoyLjMwLjIKCg==
--000000000000c92d0105c67f58ee--
