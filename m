Return-Path: <SRS0=brIg=XR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D767C3A5A2
	for <linux-cifs@archiver.kernel.org>; Sun, 22 Sep 2019 05:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F5D0208C2
	for <linux-cifs@archiver.kernel.org>; Sun, 22 Sep 2019 05:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="guvV7eK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfIVF6x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 Sep 2019 01:58:53 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:32841 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfIVF6x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 Sep 2019 01:58:53 -0400
Received: by mail-io1-f48.google.com with SMTP id z19so3334064ior.0
        for <linux-cifs@vger.kernel.org>; Sat, 21 Sep 2019 22:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=T4LA4/s7ff192gBHOhgGMcu7Jos+Q8MAxyMgrv4ETZ8=;
        b=guvV7eK/Zh0VHBz+YLj5+0BNujEGk5+eTHqwYtxgPa/ZUsldIJjEtxt1QMv360vhq6
         jpMhCH0+q72b4r6qY/nJ2BpPYoiB4L7W4XH14a38Io2/pjSuXxTBPivPgRXFTeFfRoGS
         V3b3xdKmBJzKOtY3jP8UQnOZ7hog9QCJaDPzYZSE0HdFqxH19fXLETDYqyozNJ1yl8WY
         PVzLAaCheN4gdD1vxc8V+8MBa41Gw4MG3JRqecE6fxbqn96gH0/7QV6gQbmD5iq8UbV5
         9pudBZWscvDK4lTq72RljWHP3G1joQw+75B9yum5GtjB7LiDXA1wPoWhnGlEzcrGVsQm
         bAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=T4LA4/s7ff192gBHOhgGMcu7Jos+Q8MAxyMgrv4ETZ8=;
        b=UwLK3f8FriVO/lYsktd5wQyVxmfY4DRi/rNEEEbF5PpDgPKczfyz9dmSYVxlNtxJxM
         LsjUuwAilRhW9cUyfsZhlyjAOqCdvEEGFi4d8cEb5Qw2fjpDogxuCuk9NArnmmUshkMd
         5P6QuAghg6DzJpD6VmpYYx+9sCC0UU6MWFAWJXSg03G53Z31oaI88hG1nXBvDq4crnMD
         zTlBnb0INEOu5gE4r+NUaiC1xmvo+06MGTP9IOM7vXUBCxVRvPfN48SbVWCArw7u1Q1+
         fFxjRjQu6eP/kSKErD6byz8UUgRxwUagHMwkx51dL4IC1JS+QkmhmYoap8dEfK6vGbLR
         0wFg==
X-Gm-Message-State: APjAAAWSlEerr8KJwMFzJUu4PLoch6uR4Hj2WT0zQ8N8SEkX9w1chjmt
        WGTfIAMzB0WIy+aicMYJ4UrwZRfb8UFuqtP8nBE=
X-Google-Smtp-Source: APXvYqwwNpNuf/E7Cfi5mwfkg+3cx4GoYLnPef7AaoZrY2KkbCSmw85s+UXowozkHM3UbBiClLqi8b8FWsaKu2q+7bw=
X-Received: by 2002:a6b:a0d:: with SMTP id z13mr27447603ioi.5.1569131932424;
 Sat, 21 Sep 2019 22:58:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 Sep 2019 00:58:41 -0500
Message-ID: <CAH2r5mv6x_aJQJ_N9f+9zYFgFN7FkmpR1=sNzCR8Ln5m=kGL-Q@mail.gmail.com>
Subject: Fix for "requests in flight" showing negative
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000070392b05931dff56"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000070392b05931dff56
Content-Type: text/plain; charset="UTF-8"

Requests in flight could display as negative when should be zero

-- 
Thanks,

Steve

--00000000000070392b05931dff56
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-leak-in-requests-in-flight-perf-counter.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-leak-in-requests-in-flight-perf-counter.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0ukm6ww0>
X-Attachment-Id: f_k0ukm6ww0

RnJvbSBlMzk3N2E2YWI2NDZiNzA5NmE0N2I3ZGM4YWY2MWYzMWI4ZWY4YWNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjIgU2VwIDIwMTkgMDA6NTU6NDYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggbGVhayBpbiAicmVxdWVzdHMgaW4gZmxpZ2h0IiBwZXJmIGNvdW50ZXIKCldlIHdl
cmUgbm90IGJ1bXBpbmcgInJlcXVlc3RzIGluIGZsaWdodCIgdXAgaW4gc29tZSBjYXNlcwpvbiBv
cGVucyBvZiB0aGUgc2hhcmUgcm9vdCBzbyAicmVxdWVzdHMgaW4gZmxpZ2h0IiBjb3VsZAplbmQg
dXAgc2hvd2luZyBhcyBhIG5lZ2F0aXZlIGNvdW50ZXIuCgpDQzogU3RhYmxlIDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCA1ICsrKysrCiBmcy9jaWZzL3NtYjJw
ZHUuYyB8IDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDBlNjZkYzFhYTFj
OS4uOTAxZjJlZDNmZTgyIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9j
aWZzL3NtYjJvcHMuYwpAQCAtNzYyLDYgKzc2Miw4IEBAIGludCBvcGVuX3Nocm9vdCh1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3QgY2lmc19maWQgKnBmaWQp
CiAJCWdvdG8gb3Nocl9leGl0OwogCX0KIAorCWF0b21pY19pbmMoJnRjb24tPm51bV9yZW1vdGVf
b3BlbnMpOworCiAJb19yc3AgPSAoc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAqKXJzcF9pb3ZbMF0u
aW92X2Jhc2U7CiAJb3Bhcm1zLmZpZC0+cGVyc2lzdGVudF9maWQgPSBvX3JzcC0+UGVyc2lzdGVu
dEZpbGVJZDsKIAlvcGFybXMuZmlkLT52b2xhdGlsZV9maWQgPSBvX3JzcC0+Vm9sYXRpbGVGaWxl
SWQ7CkBAIC0xMTg3LDYgKzExODksNyBAQCBzbWIyX3NldF9lYShjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiAJcmMgPSBjb21wb3VuZF9zZW5kX3JlY3Yo
eGlkLCBzZXMsIGZsYWdzLCAzLCBycXN0LAogCQkJCXJlc3BfYnVmdHlwZSwgcnNwX2lvdik7CisJ
Lyogbm8gbmVlZCB0byBidW1wIG51bV9yZW1vdGVfb3BlbnMgYmVjYXVzZSBoYW5kbGUgaW1tZWRp
YXRlbHkgY2xvc2VkICovCiAKICBzZWFfZXhpdDoKIAlrZnJlZShlYSk7CkBAIC0xNTI5LDYgKzE1
MzIsOCBAQCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAkJ
CQlyZXNwX2J1ZnR5cGUsIHJzcF9pb3YpOwogCWlmIChyYykKIAkJZ290byBpcWluZl9leGl0Owor
CisJLyogTm8gbmVlZCB0byBidW1wIG51bV9yZW1vdGVfb3BlbnMgc2luY2UgaGFuZGxlIGltbWVk
aWF0ZWx5IGNsb3NlZCAqLwogCWlmIChxaS5mbGFncyAmIFBBU1NUSFJVX0ZTQ1RMKSB7CiAJCXBx
aSA9IChzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8gX191c2VyICopYXJnOwogCQlpb19yc3AgPSAoc3Ry
dWN0IHNtYjJfaW9jdGxfcnNwICopcnNwX2lvdlsxXS5pb3ZfYmFzZTsKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggOGJjYjI3OGZkYjBhLi42
ZWEyNDMwMjQwZjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMv
c21iMnBkdS5jCkBAIC0yMzcyLDYgKzIzNzIsNyBAQCBpbnQgc21iMzExX3Bvc2l4X21rZGlyKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJcnFzdC5ycV9pb3Yg
PSBpb3Y7CiAJcnFzdC5ycV9udmVjID0gbl9pb3Y7CiAKKwkvKiBubyBuZWVkIHRvIGluYyBudW1f
cmVtb3RlX29wZW5zIGJlY2F1c2Ugd2UgY2xvc2UgaXQganVzdCBiZWxvdyAqLwogCXRyYWNlX3Nt
YjNfcG9zaXhfbWtkaXJfZW50ZXIoeGlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCwgQ1JFQVRFX05P
VF9GSUxFLAogCQkJCSAgICBGSUxFX1dSSVRFX0FUVFJJQlVURVMpOwogCS8qIHJlc291cmNlICM0
OiByZXNwb25zZSBidWZmZXIgKi8KLS0gCjIuMjAuMQoK
--00000000000070392b05931dff56--
