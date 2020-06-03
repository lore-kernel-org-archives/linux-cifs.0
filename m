Return-Path: <SRS0=lqiH=7Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21EEC433DF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 06:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03FC206C3
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 06:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iw8+znI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgFCGiy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jun 2020 02:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgFCGix (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jun 2020 02:38:53 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F15C05BD43
        for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2020 23:38:53 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id a80so517144ybg.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jun 2020 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8QhEYCy/WaCxm+YdxbbTg4BqfGOuasnYWr56/C1UfVw=;
        b=iw8+znI1wWTX4shj6A3MFKekzWTFYBn24wPsdXiKK6OhU+5XqBj6gtsM0mIG82q5PP
         bBlhdP3AqLSxBXXd2VF7bKifKpuZRWM532HHiMoTONzZ9/OYbWJw83XDsc8oLky/7qTm
         +FIHyCcwJUNIESYBNfhcTdBeWQD1y+DEHBcZ03BLOL+Znk185dt/Y0xvYhVIQSKYKNCY
         AxK5lVTzyeklu8dYNjEme/o9KrIIZFXWYDYpPWebQ2gPx6fK9jygKzdJs7DCfmRgycPr
         1r1hSwoJLEVphJraX+vY36aDVx8QGHEBRuymMuOK2giPRpSbNaRBl//u7KgPePrl5q6e
         kIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8QhEYCy/WaCxm+YdxbbTg4BqfGOuasnYWr56/C1UfVw=;
        b=YfcPWtrrxoiMVwyjCTekPQw1DcaDjnmk8MCW9yzGOOxnXZlYQAkoRFZOQ5XGiD79Hy
         FMiPqAT8U1omo5WOYH2bvMYfjM3UE2btRnH8V4JSKp+R/P4mX5RQB4gjCEoWcXw163ey
         jWjaj8IE9najF1oCmqMsgoVM74ISpjpoy7qxOXaF/FRc6ii1/6/MvEtIjFQmaHvgzSjW
         XqQUJz8F+OEn06d++zaHNE3jQ6lqb9P3lOFm5bLslPIEnLh4wT1K8yyMyLQjWRdQq4Of
         Qx2RwjNzjKb92TWwMQttAYbRBRgfRXka4CwjlA7C+MT2bQWCHbI6lO1aWOpXI9B3OoOo
         kygQ==
X-Gm-Message-State: AOAM531gvOWS+/couEAxSNCiQu0wAp4yuAgAnUqPnjDBQgpChGXuookE
        BLeg2ybg4RRBTSfkH+Hvzgh9YjwFnKh0VoA+N0p2hRuu38U=
X-Google-Smtp-Source: ABdhPJx3Lbc7MG3UqVNA9FW3d8e2kurLokHJsuEbAWbjoEp+mE+nGCurOYfAPieoKcZKq/m6hAyfONtgin5RF6yxopg=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr7190595ybh.364.1591166332740;
 Tue, 02 Jun 2020 23:38:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Jun 2020 01:38:41 -0500
Message-ID: <CAH2r5muKMaDQmfVEWyuVj798Yc1r1_j6hvRmxQhxZibfQ37VpA@mail.gmail.com>
Subject: [PATCH][SMB3] fix incorrect number of credits when ioctl
 MaxOutputResponse > 64K
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000000ad87905a728489e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000ad87905a728489e
Content-Type: text/plain; charset="UTF-8"

    We were not checking to see if ioctl requests asked for more than
    64K (ie when CIFSMaxBufSize was > 64K) so when setting larger
    CIFSMaxBufSize then ioctls would fail with invalid parameter errors.
    When requests ask for more than 64K in MaxOutputResponse then we
    need to ask for more than 1 credit.

    Signed-off-by: Steve French <stfrench@microsoft.com>
    CC: Stable <stable@vger.kernel.org>


-- 
Thanks,

Steve

--0000000000000ad87905a728489e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-incorrect-number-of-credits-when-ioctl-can-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-incorrect-number-of-credits-when-ioctl-can-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kayzcdar0>
X-Attachment-Id: f_kayzcdar0

RnJvbSA4ZjQyMDEwNDY4ODZmMGY3ZDNmMmE3ODYyMGQwY2VmMGEyZGVhYzJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMyBKdW4gMjAyMCAwMTozMzo1OCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBpbmNvcnJlY3QgbnVtYmVyIG9mIGNyZWRpdHMgd2hlbiBpb2N0bCBjYW4gcmVxdWVz
dAogPiA2NEsKCldlIHdlcmUgbm90IGNoZWNraW5nIHRvIHNlZSBpZiBpb2N0bCByZXF1ZXN0cyBh
c2tlZCBmb3IgbW9yZSB0aGFuCjY0SyAoaWUgd2hlbiBDSUZTTWF4QnVmU2l6ZSB3YXMgPiA2NEsp
IHNvIHdoZW4gc2V0dGluZyBsYXJnZXIKQ0lGU01heEJ1ZlNpemUgdGhlbiBpb2N0bHMgd291bGQg
ZmFpbCB3aXRoIGludmFsaWQgcGFyYW1ldGVyIGVycm9ycy4KV2hlbiByZXF1ZXN0cyBhc2sgZm9y
IG1vcmUgdGhhbiA2NEsgdGhlbiB3ZSBuZWVkIHRvIGFzayBmb3IgbW9yZQp0aGFuIDEgY3JlZGl0
LgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpD
QzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgotLS0KIGZzL2NpZnMvc21iMnBkdS5j
IHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBh
ZjA2N2ZkMzBkZGIuLmRlZDk2YjUyOWE0ZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMK
KysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTI5NzMsNyArMjk3Myw3IEBAIFNNQjJfaW9jdGxf
aW5pdChzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXIsCiAJICogcmVzcG9uc2Ugc2l6ZSBzbWFsbGVyLgogCSAqLwogCXJlcS0+TWF4T3V0cHV0UmVz
cG9uc2UgPSBjcHVfdG9fbGUzMihtYXhfcmVzcG9uc2Vfc2l6ZSk7Ci0KKwlyZXEtPnN5bmNfaGRy
LkNyZWRpdENoYXJnZSA9IGNwdV90b19sZTE2KERJVl9ST1VORF9VUChtYXhfcmVzcG9uc2Vfc2l6
ZSwgU01CMl9NQVhfQlVGRkVSX1NJWkUpKTsKIAlpZiAoaXNfZnNjdGwpCiAJCXJlcS0+RmxhZ3Mg
PSBjcHVfdG9fbGUzMihTTUIyXzBfSU9DVExfSVNfRlNDVEwpOwogCWVsc2UKLS0gCjIuMjUuMQoK
--0000000000000ad87905a728489e--
