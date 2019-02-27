Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB65C4360F
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311E921852
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIxzmejX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfB0GGo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:44 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:35399 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729824AbfB0GGn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 01:06:43 -0500
Received: by mail-pf1-f177.google.com with SMTP id j5so7479707pfa.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 22:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=X7A3SIi/jY9sow6pJz7he43k3UQxmVOwMmupuC6XJIo=;
        b=YIxzmejXwb1gAFNAOHjrAOtOTrXit4FtxqVvpI//xoc21qPug0Bf9ZOZQRBvC/oKpH
         6KmAMtcbhAEoUnvl0zBcAogYp5/JMh87DM+Mntg8bVOvuLce8fLu7lTe87lLjpZdzxMM
         XLxuh0ncrwGbXtSdw0wTBLcBKd0qO7+jSxlSTT9orkeojdgjqkBEtu/DeiF4MQ74L+kJ
         99ehgE23aYRVULZ6K4XQQHfq+ykdNsC+NQYKr5U6Zm6385KIFcp0ipYK+C5cbh56Ko+2
         Xru65OvLamkmpSA15VmDjqGAnBrqhCe3pFaM1yITPAKrdaLC+XhQaA81pAGVjElF7uwv
         8wPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=X7A3SIi/jY9sow6pJz7he43k3UQxmVOwMmupuC6XJIo=;
        b=Efos5yGjeOXKdPHrWgl0CG8Yw8ONfGmAHf+R2Dh2ot9/v0N7WybPuZl2pNVjJIxrnk
         h524R7Y9djaM6JzH7xUUnNBQb3KyQw+clcpUvXY/s7ODZuUKag0ChCa6TQYuum6euale
         d/O1KXAu24GDivatkUK41ZixTfpgnElcMnzBWpXfN3CirhY5IGTFIWUg1GZlsvrgAxuw
         sVAIAbVJeRUeQwvtUdrYAGMuyUf3UUel1rbXJb69SOCV9pziFoQpVTTuQT5s0ynCkASs
         z+4e7FqSg5x0oHijAoGDKlHSvPDtREaMWJoKNHuNij7udHyAgSSRQLDM1YqPM6YGJHhp
         BRsw==
X-Gm-Message-State: AHQUAubmy+z70XDdc1elAtuu4NiiAzHSS5rJhJrsxEzizTYBtPOWDQlq
        yAK1OfYn7hqxnZfxv1ByNpnQTcMmTYRFGYRT3CWcMsjt
X-Google-Smtp-Source: AHgI3IaQEWHCNrVEQnmICyRZdiQeHKw1twHRMsVfXVc2Ld0BiWuoiTnGhG8b7byEcpmlzwtXYEm4RRGKROmrALuPFkY=
X-Received: by 2002:a65:508b:: with SMTP id r11mr1408891pgp.242.1551247601914;
 Tue, 26 Feb 2019 22:06:41 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Feb 2019 00:06:30 -0600
Message-ID: <CAH2r5muZ4EQuFSsBA8FtMuj7_fbtUz+LT62bArMS0O0T=0pk0w@mail.gmail.com>
Subject: [PATCH] add dynamic trace points for compounded query/setinfo paths
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000045780e0582d9fa90"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000045780e0582d9fa90
Content-Type: text/plain; charset="UTF-8"

Add tracepoints for enter/exit (error or done without error)
for compounded query_info and set_info

Sample output (trace-cmd record -e smb3_*compound*):
    touch-30074 [005] .... 33989.459514: smb3_set_info_compound_enter:
xid=8 sid=0xbe534a7e tid=0x82c96a43
    touch-30074 [005] .N.. 33989.471834: smb3_set_info_compound_done:
xid=8 sid=0xbe534a7e tid=0x82c96a43
    mkdir-30076 [007] .... 33999.239926:
smb3_query_info_compound_enter: xid=10 sid=0xbe534a7e tid=0x82c96a43
    mkdir-30076 [007] .... 33999.247180:
smb3_query_info_compound_done: xid=10 sid=0xbe534a7e tid=0x82c96a43



-- 
Thanks,

Steve

--00000000000045780e0582d9fa90
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-points-for-compound-query-and.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-points-for-compound-query-and.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsmsr52r0>
X-Attachment-Id: f_jsmsr52r0

RnJvbSA3ODU3YzJmNmExNzg1MWFhYzEwMjMyZGE5MTYyYjY4OGIzNWRjMzY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjcgRmViIDIwMTkgMDA6MDE6MzUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZSBwb2ludHMgZm9yIGNvbXBvdW5kIHF1ZXJ5IGFuZCBzZXRp
bmZvCgpBZGQgdHJhY2Vwb2ludHMgZm9yIGVudGVyL2V4aXQgKGVycm9yIG9yIGRvbmUgd2l0aG91
dCBlcnJvcikKZm9yIGNvbXBvdW5kZWQgcXVlcnlfaW5mbyBhbmQgc2V0X2luZm8KClNhbXBsZSBv
dXRwdXQgKHRyYWNlLWNtZCByZWNvcmQgLWUgc21iM18qY29tcG91bmQqKToKICAgIHRvdWNoLTMw
MDc0IFswMDVdIC4uLi4gMzM5ODkuNDU5NTE0OiBzbWIzX3NldF9pbmZvX2NvbXBvdW5kX2VudGVy
OiB4aWQ9OCBzaWQ9MHhiZTUzNGE3ZSB0aWQ9MHg4MmM5NmE0MwogICAgdG91Y2gtMzAwNzQgWzAw
NV0gLk4uLiAzMzk4OS40NzE4MzQ6IHNtYjNfc2V0X2luZm9fY29tcG91bmRfZG9uZTogeGlkPTgg
c2lkPTB4YmU1MzRhN2UgdGlkPTB4ODJjOTZhNDMKICAgIG1rZGlyLTMwMDc2IFswMDddIC4uLi4g
MzM5OTkuMjM5OTI2OiBzbWIzX3F1ZXJ5X2luZm9fY29tcG91bmRfZW50ZXI6IHhpZD0xMCBzaWQ9
MHhiZTUzNGE3ZSB0aWQ9MHg4MmM5NmE0MwogICAgbWtkaXItMzAwNzYgWzAwN10gLi4uLiAzMzk5
OS4yNDcxODA6IHNtYjNfcXVlcnlfaW5mb19jb21wb3VuZF9kb25lOiB4aWQ9MTAgc2lkPTB4YmU1
MzRhN2UgdGlkPTB4ODJjOTZhNDMKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJpbm9kZS5jIHwgMTkgKysrKysrKysr
KysrKy0KIGZzL2NpZnMvdHJhY2UuaCAgICAgfCA2NCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgODIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMmlub2RlLmMgYi9mcy9jaWZz
L3NtYjJpbm9kZS5jCmluZGV4IDAxYTc2YmNjZGI4ZC4uYjY0NWI4NjI2ZTdkIDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJpbm9kZS5jCisrKyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKQEAgLTExMiw2
ICsxMTIsNyBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJCSAgUEFUSF9NQVggKiAyLCAwLCBOVUxMKTsKIAkJc21i
Ml9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNtYjJfc2V0X3Jl
bGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3F1ZXJ5X2luZm9fY29tcG91
bmRfZW50ZXIoeGlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCk7CiAJCWJyZWFrOwogCWNhc2UgU01C
Ml9PUF9ERUxFVEU6CiAJCWJyZWFrOwpAQCAtMTY2LDYgKzE2Nyw3IEBAIHNtYjJfY29tcG91bmRf
b3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJ
U01CMl9PX0lORk9fRklMRSwgMCwgZGF0YSwgc2l6ZSk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFu
ZCh0Y29uLCAmcnFzdFtudW1fcnFzdF0pOwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9y
cXN0KytdKTsKKwkJdHJhY2Vfc21iM19zZXRfaW5mb19jb21wb3VuZF9lbnRlcih4aWQsIHRjb24t
PnRpZCwgc2VzLT5TdWlkKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1JFTkFNRToKIAkJbWVt
c2V0KCZzaV9pb3YsIDAsIHNpemVvZihzaV9pb3YpKTsKQEAgLTI0Nyw3ICsyNDksMTEgQEAgc21i
Ml9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCQkJCWxlMzJfdG9fY3B1KHFpX3JzcC0+T3V0cHV0QnVmZmVyTGVuZ3RoKSwKIAkJCQkm
cnNwX2lvdlsxXSwgc2l6ZW9mKHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2luZm8pLAogCQkJCXB0cik7
Ci0JCX0KKwkJCXRyYWNlX3NtYjNfcXVlcnlfaW5mb19jb21wb3VuZF9kb25lKHhpZCwgdGNvbi0+
dGlkLAorCQkJCQkJCSAgICAgc2VzLT5TdWlkKTsKKwkJfSBlbHNlCisJCQl0cmFjZV9zbWIzX3F1
ZXJ5X2luZm9fY29tcG91bmRfZXJyKHhpZCwgdGNvbi0+dGlkLAorCQkJCQkJCSAgIHNlcy0+U3Vp
ZCwgcmMpOwogCQlpZiAocnFzdFsxXS5ycV9pb3YpCiAJCQlTTUIyX3F1ZXJ5X2luZm9fZnJlZSgm
cnFzdFsxXSk7CiAJCWlmIChycXN0WzJdLnJxX2lvdikKQEAgLTI2MiwxMSArMjY4LDIyIEBAIHNt
YjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwKIAljYXNlIFNNQjJfT1BfUkVOQU1FOgogCWNhc2UgU01CMl9PUF9STURJUjoKIAljYXNl
IFNNQjJfT1BfU0VUX0VPRjoKKwkJaWYgKHJxc3RbMV0ucnFfaW92KQorCQkJU01CMl9zZXRfaW5m
b19mcmVlKCZycXN0WzFdKTsKKwkJaWYgKHJxc3RbMl0ucnFfaW92KQorCQkJU01CMl9jbG9zZV9m
cmVlKCZycXN0WzJdKTsKKwkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1NFVF9JTkZPOgogCQlpZiAo
cnFzdFsxXS5ycV9pb3YpCiAJCQlTTUIyX3NldF9pbmZvX2ZyZWUoJnJxc3RbMV0pOwogCQlpZiAo
cnFzdFsyXS5ycV9pb3YpCiAJCQlTTUIyX2Nsb3NlX2ZyZWUoJnJxc3RbMl0pOworCQlpZiAocmMp
CisJCQl0cmFjZV9zbWIzX3NldF9pbmZvX2NvbXBvdW5kX2Vycih4aWQsIHRjb24tPnRpZCwKKwkJ
CQkJCQkgICBzZXMtPlN1aWQsIHJjKTsKKwkJZWxzZQorCQkJdHJhY2Vfc21iM19zZXRfaW5mb19j
b21wb3VuZF9kb25lKHhpZCwgdGNvbi0+dGlkLAorCQkJCQkJCSAgIHNlcy0+U3VpZCk7CiAJCWJy
ZWFrOwogCX0KIAlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBlWzBdLCByc3BfaW92WzBdLmlvdl9i
YXNlKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRl
eCBkOGIwNDlhZmE2MDYuLmE4ODM3ZDZlZmJjMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5o
CisrKyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtMjQyLDYgKzI0Miw3MCBAQCBERUZJTkVfU01CM19J
TkZfRVJSX0VWRU5UKHF1ZXJ5X2luZm9fZXJyKTsKIERFRklORV9TTUIzX0lORl9FUlJfRVZFTlQo
c2V0X2luZm9fZXJyKTsKIERFRklORV9TTUIzX0lORl9FUlJfRVZFTlQoZnNjdGxfZXJyKTsKIAor
REVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2luZl9jb21wb3VuZF9lbnRlcl9jbGFzcywKKwlUUF9Q
Uk9UTyh1bnNpZ25lZCBpbnQgeGlkLAorCQlfX3UzMgl0aWQsCisJCV9fdTY0CXNlc2lkKSwKKwlU
UF9BUkdTKHhpZCwgdGlkLCBzZXNpZCksCisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19maWVsZCh1
bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19maWVsZChfX3UzMiwgdGlkKQorCQlfX2ZpZWxkKF9fdTY0
LCBzZXNpZCkKKwkpLAorCVRQX2Zhc3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJ
CV9fZW50cnktPnRpZCA9IHRpZDsKKwkJX19lbnRyeS0+c2VzaWQgPSBzZXNpZDsKKwkpLAorCVRQ
X3ByaW50aygieGlkPSV1IHNpZD0weCVsbHggdGlkPTB4JXgiLAorCQlfX2VudHJ5LT54aWQsIF9f
ZW50cnktPnNlc2lkLCBfX2VudHJ5LT50aWQpCispCisKKyNkZWZpbmUgREVGSU5FX1NNQjNfSU5G
X0NPTVBPVU5EX0VOVEVSX0VWRU5UKG5hbWUpICAgICBcCitERUZJTkVfRVZFTlQoc21iM19pbmZf
Y29tcG91bmRfZW50ZXJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJVFBfUFJPVE8odW5zaWdu
ZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJc2VzaWQpLAkJCVwKKwlU
UF9BUkdTKHhpZCwgdGlkLCBzZXNpZCkpCisKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRF
Ul9FVkVOVChxdWVyeV9pbmZvX2NvbXBvdW5kX2VudGVyKTsKK0RFRklORV9TTUIzX0lORl9DT01Q
T1VORF9FTlRFUl9FVkVOVChxdWVyeV9pbmZvX2NvbXBvdW5kX2RvbmUpOworREVGSU5FX1NNQjNf
SU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9pbmZvX2NvbXBvdW5kX2VudGVyKTsKK0RFRklO
RV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChzZXRfaW5mb19jb21wb3VuZF9kb25lKTsK
KworREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2luZl9jb21wb3VuZF9lcnJfY2xhc3MsCisJVFBf
UFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNpZCwKKwkJ
aW50CXJjKSwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgcmMpLAorCVRQX1NUUlVDVF9fZW50
cnkoCisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkK
KwkJX19maWVsZChfX3U2NCwgc2VzaWQpCisJCV9fZmllbGQoaW50LCByYykKKwkpLAorCVRQX2Zh
c3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJCV9fZW50cnktPnRpZCA9IHRpZDsK
KwkJX19lbnRyeS0+c2VzaWQgPSBzZXNpZDsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkpLAorCVRQ
X3ByaW50aygieGlkPSV1IHNpZD0weCVsbHggdGlkPTB4JXggcmM9JWQiLAorCQlfX2VudHJ5LT54
aWQsIF9fZW50cnktPnNlc2lkLCBfX2VudHJ5LT50aWQsIF9fZW50cnktPnJjKQorKQorCisjZGVm
aW5lIERFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQobmFtZSkgICAgIFwKK0RFRklO
RV9FVkVOVChzbWIzX2luZl9jb21wb3VuZF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJ
VFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJ
c2VzaWQsCQkJXAorCQlpbnQgcmMpLAkJCVwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgcmMp
KQorCitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHF1ZXJ5X2luZm9fY29tcG91
bmRfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQoc2V0X2luZm9fY29t
cG91bmRfZXJyKTsKKwogLyoKICAqIEZvciBsb2dnaW5nIFNNQjMgU3RhdHVzIGNvZGUgYW5kIENv
bW1hbmQgZm9yIHJlc3BvbnNlcyB3aGljaCByZXR1cm4gZXJyb3JzCiAgKi8KLS0gCjIuMTcuMQoK
--00000000000045780e0582d9fa90--
