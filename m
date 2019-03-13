Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D30C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D167C2070D
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r4xkbdWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCMH3I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:29:08 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:36840 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfCMH3I (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 03:29:08 -0400
Received: by mail-pf1-f169.google.com with SMTP id n22so771610pfa.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2019 00:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7vu/SSiSlAq/xg2xWCta1KsTzvuxTMXVIwBlZPSSE2g=;
        b=r4xkbdWomt7eu1JTbnp6nFNEMNRE5MW3gHrmarbSMVstFnh1jvGWrgVHUTVB2Yu8y2
         YdmgjSoE8iCbx/VSrraifqZ1EKJD8omKlx/3QrEU7NxB8QFn+WG2s9d2RKwGbFAst58a
         3psZqv3l5U9wNb3hqPiD8RYJLZecA7WXOIMG4iJ29txLp9S0sjiBHiD9J6+2SHkkY5XS
         7HOpTQVX8wmcfWqGmo2esq5FWtVcCZamWUeqtgaXAJFjfh3bUFe+UN3TvjP3HwgTG1DB
         Nbji1pu30uA6j92eGO8Iwszb2bw3MY9YNiPyfeD3YndtGP6W70lcHJFgN5OqlLz+JTxh
         LXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7vu/SSiSlAq/xg2xWCta1KsTzvuxTMXVIwBlZPSSE2g=;
        b=EmGCB3bBcirM2SLXkAthE5K7m1vppXvBiGLvIyZCxq1jNdB/UrW4/ROEYMOdJwjkOG
         e0eSxmTCWR1NxA6q4NfHVMIcX/LBQ0sI4eW2xIdQT9rt1Na2TNISogAUT92jtweAHu51
         4RyTT3vZRWDAtXAxw+gcly9wGqG5yYRAhcjPj2ra17Kb7wrLYKVpC6ysf3w0ka4A7ybm
         9x8e7wvoIxHo3gfQrQsrqIo6HmzqjVjd7R3IabSVPNNS4LYih4VmhjmQOljZuAqACW5n
         DsQumsx5HCGLu9u2mZL+3x7nIg8b7syC9jAkNPgNeZ5qwZdTZjNYkVKO1cVu29xS9pTV
         pkcQ==
X-Gm-Message-State: APjAAAWEWKegWDmqxj6YZEJ6x65v5DnwC5Ey8+ySEAl/8mjW3Z0vyfP3
        ta/EiCLcTbEFrKBv+ePVCrTrNgsgtP4wVw6TzfSLllvJ
X-Google-Smtp-Source: APXvYqx+kzJ+IeEKk/l2RqRMFnqRszN+PdGYXw/v0hBhL74TKWMCWM0v6vJHswNb4HJi3ntWib1Z3xwIZZvHMnhP21Y=
X-Received: by 2002:a63:974a:: with SMTP id d10mr26831805pgo.344.1552462146784;
 Wed, 13 Mar 2019 00:29:06 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 02:28:55 -0500
Message-ID: <CAH2r5muDfiv2=VpUDTkbW3h+05ubMHsMe53nzjwp9apu=-1-tA@mail.gmail.com>
Subject: [SMB3][PATCH]
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000c97f420583f4c2ff"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c97f420583f4c2ff
Content-Type: text/plain; charset="UTF-8"

SMB3: passthru query info doesn't check for SMB3 FSCTL passthru

The passthrough queries from user space tools like smbinfo can be either
SMB3 QUERY_INFO or SMB3 FSCTL, but we are not checking for the latter.
Temporarily we return EOPNOTSUPP for SMB3 FSCTL passthrough requests
but once compounding fsctls is fixed we can remove the EOPNOTSUPP.


-- 
Thanks,

Steve

--000000000000c97f420583f4c2ff
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-passthru-query-info-doesn-t-check-for-SMB3-FSCT.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-passthru-query-info-doesn-t-check-for-SMB3-FSCT.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt6vv0yf0>
X-Attachment-Id: f_jt6vv0yf0

RnJvbSA3MGQyZGVjY2Y2ZmY4MmU4NzA5MDYxZmY5OThjZWMyNWQwNTBjZGY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTMgTWFyIDIwMTkgMDI6MjM6NDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBwYXNzdGhydSBxdWVyeSBpbmZvIGRvZXNuJ3QgY2hlY2sgZm9yIFNNQjMgRlNDVEwKIHBh
c3N0aHJ1CgpUaGUgcGFzc3Rocm91Z2ggcXVlcmllcyBmcm9tIHVzZXIgc3BhY2UgdG9vbHMgbGlr
ZSBzbWJpbmZvIGNhbiBiZSBlaXRoZXIKU01CMyBRVUVSWV9JTkZPIG9yIFNNQjMgRlNDVEwsIGJ1
dCB3ZSBhcmUgbm90IGNoZWNraW5nIGZvciB0aGUgbGF0dGVyLgpUZW1wb3JhcmlseSB3ZSByZXR1
cm4gRU9QTk9UU1VQUCBmb3IgU01CMyBGU0NUTCBwYXNzdGhyb3VnaCByZXF1ZXN0cwpidXQgb25j
ZSBjb21wb3VuZGluZyBmc2N0bHMgaXMgZml4ZWQgY2FuIGVuYWJsZS4KClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNf
aW9jdGwuaCB8ICAzICsrKwogZnMvY2lmcy9zbWIyb3BzLmMgICAgfCAyMyArKysrKysrKysrKysr
KysrKy0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19pb2N0bC5oIGIvZnMvY2lmcy9jaWZzX2lv
Y3RsLmgKaW5kZXggZDhiY2UyZjg2MmRlLi4wODZkZGM1MTA4YWYgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY2lmc19pb2N0bC5oCisrKyBiL2ZzL2NpZnMvY2lmc19pb2N0bC5oCkBAIC00Myw2ICs0Myw5
IEBAIHN0cnVjdCBzbWJfc25hcHNob3RfYXJyYXkgewogCS8qCXNuYXBzaG90c1tdOyAqLwogfSBf
X3BhY2tlZDsKIAorLyogcXVlcnlfaW5mbyBmbGFncyAqLworI2RlZmluZSBQQVNTVEhSVV9RVUVS
WV9JTkZPCTB4MDAwMDAwMDAKKyNkZWZpbmUgUEFTU1RIUlVfRlNDVEwJCTB4MDAwMDAwMDEKIHN0
cnVjdCBzbWJfcXVlcnlfaW5mbyB7CiAJX191MzIgICBpbmZvX3R5cGU7CiAJX191MzIgICBmaWxl
X2luZm9fY2xhc3M7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCmluZGV4IDgyM2E1ODU1MGRmZC4uNDNiM2E5YjAwOTZmIDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMTM5MCwxNSArMTM5MCwy
NiBAQCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAlzbWIy
X3NldF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbMF0pOwogCiAJLyogUXVlcnkgKi8KLQltZW1z
ZXQoJnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lvdikpOwotCXJxc3RbMV0ucnFfaW92ID0gcWlfaW92
OwotCXJxc3RbMV0ucnFfbnZlYyA9IDE7CisJaWYgKHFpLmZsYWdzICYgUEFTU1RIUlVfRlNDVEwp
IHsKKwkJLyogQ2FuIGV2ZW50dWFsbHkgcmVsYXggcGVybSBjaGVjayBzaW5jZSBzZXJ2ZXIgZW5m
b3JjZXMgdG9vICovCisJCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKKwkJCXJjID0gLUVQ
RVJNOworCQllbHNlICAvKiBUQkQ6IEFkZCBjb2RlIHRvIGNvbXBvdW5kIEZTQ1RMICovCisJCQly
YyA9IC1FT1BOT1RTVVBQOworCX0gZWxzZSBpZiAocWkuZmxhZ3MgIT0gUEFTU1RIUlVfUVVFUllf
SU5GTykgeworCQljaWZzX2RiZyhWRlMsICJpbnZhbGlkIHBhc3N0aHJ1IHF1ZXJ5IGZsYWdzOiAw
eCV4XG4iLCBxaS5mbGFncyk7CisJCXJjID0gLUVJTlZBTDsKKwl9IGVsc2UgeworCQltZW1zZXQo
JnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lvdikpOworCQlycXN0WzFdLnJxX2lvdiA9IHFpX2lvdjsK
KwkJcnFzdFsxXS5ycV9udmVjID0gMTsKIAotCXJjID0gU01CMl9xdWVyeV9pbmZvX2luaXQodGNv
biwgJnJxc3RbMV0sIENPTVBPVU5EX0ZJRCwgQ09NUE9VTkRfRklELAotCQkJCSAgcWkuZmlsZV9p
bmZvX2NsYXNzLCBxaS5pbmZvX3R5cGUsCi0JCQkJICBxaS5hZGRpdGlvbmFsX2luZm9ybWF0aW9u
LAorCQlyYyA9IFNNQjJfcXVlcnlfaW5mb19pbml0KHRjb24sICZycXN0WzFdLCBDT01QT1VORF9G
SUQsCisJCQkJICBDT01QT1VORF9GSUQsIHFpLmZpbGVfaW5mb19jbGFzcywKKwkJCQkgIHFpLmlu
Zm9fdHlwZSwgcWkuYWRkaXRpb25hbF9pbmZvcm1hdGlvbiwKIAkJCQkgIHFpLmlucHV0X2J1ZmZl
cl9sZW5ndGgsCiAJCQkJICBxaS5vdXRwdXRfYnVmZmVyX2xlbmd0aCwgYnVmZmVyKTsKKwl9CiAJ
aWYgKHJjKQogCQlnb3RvIGlxaW5mX2V4aXQ7CiAJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24s
ICZycXN0WzFdKTsKLS0gCjIuMTcuMQoK
--000000000000c97f420583f4c2ff--
