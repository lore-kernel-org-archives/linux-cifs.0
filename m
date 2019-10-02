Return-Path: <SRS0=Gq5t=X3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B490C352AA
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 02:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6195220B7C
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 02:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o1VFHMjz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJBCaJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 22:30:09 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:44538 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfJBCaJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 22:30:09 -0400
Received: by mail-io1-f51.google.com with SMTP id w12so25254397iol.11
        for <linux-cifs@vger.kernel.org>; Tue, 01 Oct 2019 19:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=igvbDSEnc5xtHS7c+cMc3cTpOIKK/QoLC7DTfC7XNXA=;
        b=o1VFHMjzP/C+dN2PUeIns7ZrTPkJOyPlCZHI123wkBa5jBO6JBc/Bw/8NOC9YagxmE
         7Afw+i4MfMUqFOx+KIIwFXGz4t2Rw/3sg00I+kDg3VKTGe/74M+Va8ev6Z6VomFxQhRL
         oFGARLkNCXGsc7quGSLwymTCQC9JQzEl5xVeKdPchFLdRKWlqz8wggq6bbl6MARHCN2L
         pIhpQHYD7YCmoHBCUFoAQTJjbRW8JVUiaKpLk0vyxhmSXyvKBap5L5/20I51Hy9HBEyB
         1SCn9jzxvPMbWJXF1eElSL2xXEhtOVXESAoV1lfTNeO7m0XuplX/476YaQe6pPYIxnlj
         1weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=igvbDSEnc5xtHS7c+cMc3cTpOIKK/QoLC7DTfC7XNXA=;
        b=I/EkwS3cogXhsSJpfJ0xQltX8zbH63RpS8zg3jy9XoHWiZNyCX3eXwFHnyg4Bo1tD2
         PiTRmUc+O9hd8wRdXjuidt+Ts4Y0EgpqmyLRyV3qD6XPr8JOZrpzKf+kqzoSsEbNLUqN
         jlq/ZCKP2J05LZZoJP17eTfpZAJ9jXPR8TWKPwaqbcaW+MNJoF6rLTb++CKlajX96Cqy
         LQqJYqJ6/dnR6s3ANJi2HyGTSy6HWv5LdYp0hoVs6qRoLVS9QDYZLXCYj8auCroe30Ik
         S7S6HrEZPLgB5rbzDMWLaREm+3xDwnR84pbfdXUWJ5WniPZjeUrnYhMxsJ9H8+JrMOhj
         R2VQ==
X-Gm-Message-State: APjAAAUrj3GUEmwoj5YcTlXgjgoxBd0q09tauFi7kdF0ckElDWDRgIcb
        xgyZrRB2lIcTNKnrneXhfkWqBD1XQjrSmQYrz0yPb7eg
X-Google-Smtp-Source: APXvYqwa9MLywqy5ZJG1tSWNQWsnlg5J4GPsdZxSbhiaQQPH6b7kyVKCzYJIWCSDEVntluWy1ctPCYJ6ncuzYBqC6Zo=
X-Received: by 2002:a92:c00d:: with SMTP id q13mr1443473ild.169.1569983407912;
 Tue, 01 Oct 2019 19:30:07 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 1 Oct 2019 21:29:57 -0500
Message-ID: <CAH2r5mu8idWYkmRA8+64zqL+nXX9++tbBKiJvGtxEjyqZ_2pog@mail.gmail.com>
Subject: [PATCH][SMB3] cleanup a couple minor recent endian errors spotted by sparse
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005559e00593e43f1b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005559e00593e43f1b
Content-Type: text/plain; charset="UTF-8"

Now that I can run sparse again, spotted two recent minor endian
errors that it flagged.



-- 
Thanks,

Steve

--0000000000005559e00593e43f1b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-cleanup-some-recent-endian-errors-spotted-by-up.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-cleanup-some-recent-endian-errors-spotted-by-up.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k18nkpbj0>
X-Attachment-Id: f_k18nkpbj0

RnJvbSA0Yzk2OGQ4Y2FiZGI1NDNjZmZmM2UyODBhMWNjMjA0OTc2ZjY2NmRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMSBPY3QgMjAxOSAyMToyNTo0NiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGNsZWFudXAgc29tZSByZWNlbnQgZW5kaWFuIGVycm9ycyBzcG90dGVkIGJ5IHVwZGF0ZWQK
IHNwYXJzZQoKTm93IHRoYXQgc3BhcnNlIGhhcyBiZWVuIGZpeGVkLCBpdCBzcG90dGVkIGEgY291
cGxlIHJlY2VudCBtaW5vcgplbmRpYW4gZXJyb3JzIChhbmQgcmVtb3ZlZCBvbmUgYWRkaXRpb25h
bCBzcGFyc2Ugd2FybmluZykuCgpUaGFua3MgdG8gTHVjIFZhbiBPb3N0ZW5yeWNrIGZvciBoaXMg
aGVscCBmaXhpbmcgc3BhcnNlLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jICAgfCAyICstCiBmcy9jaWZz
L3NtYjJwZHUuYyAgIHwgMyArKy0KIGZzL2NpZnMvc21iMnByb3RvLmggfCA0ICsrKysKIDMgZmls
ZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggMjg1MGMzY2U0Mzkx
Li5iNzI0MjI3Yjg1M2MgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCkBAIC00MjY0LDcgKzQyNjQsNyBAQCBzdGF0aWMgaW50IG1vdW50X2dldF9j
b25ucyhzdHJ1Y3Qgc21iX3ZvbCAqdm9sLCBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAog
CQlzZXJ2ZXItPm9wcy0+cWZzX3Rjb24oKnhpZCwgdGNvbik7CiAJCWlmIChjaWZzX3NiLT5tbnRf
Y2lmc19mbGFncyAmIENJRlNfTU9VTlRfUk9fQ0FDSEUpIHsKIAkJCWlmICh0Y29uLT5mc0Rldklu
Zm8uRGV2aWNlQ2hhcmFjdGVyaXN0aWNzICYKLQkJCSAgICBGSUxFX1JFQURfT05MWV9ERVZJQ0Up
CisJCQkgICAgY3B1X3RvX2xlMzIoRklMRV9SRUFEX09OTFlfREVWSUNFKSkKIAkJCQljaWZzX2Ri
ZyhWRlMsICJtb3VudGVkIHRvIHJlYWQgb25seSBzaGFyZVxuIik7CiAJCQllbHNlIGlmICgoY2lm
c19zYi0+bW50X2NpZnNfZmxhZ3MgJgogCQkJCSAgQ0lGU19NT1VOVF9SV19DQUNIRSkgPT0gMCkK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXgg
ODVmOWQ2MTRkOTY4Li5mZDVmMmI0Yjc1ODIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5j
CisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0zMjE3LDcgKzMyMTcsOCBAQCBTTUIyX25vdGlm
eV9pbml0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwKIAog
CXJlcS0+UGVyc2lzdGVudEZpbGVJZCA9IHBlcnNpc3RlbnRfZmlkOwogCXJlcS0+Vm9sYXRpbGVG
aWxlSWQgPSB2b2xhdGlsZV9maWQ7Ci0JcmVxLT5PdXRwdXRCdWZmZXJMZW5ndGggPSBTTUIyX01B
WF9CVUZGRVJfU0laRSAtIE1BWF9TTUIyX0hEUl9TSVpFOworCXJlcS0+T3V0cHV0QnVmZmVyTGVu
Z3RoID0KKwkJY3B1X3RvX2xlMzIoU01CMl9NQVhfQlVGRkVSX1NJWkUgLSBNQVhfU01CMl9IRFJf
U0laRSk7CiAJcmVxLT5Db21wbGV0aW9uRmlsdGVyID0gY3B1X3RvX2xlMzIoY29tcGxldGlvbl9m
aWx0ZXIpOwogCWlmICh3YXRjaF90cmVlKQogCQlyZXEtPkZsYWdzID0gY3B1X3RvX2xlMTYoU01C
Ml9XQVRDSF9UUkVFKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnByb3RvLmggYi9mcy9jaWZz
L3NtYjJwcm90by5oCmluZGV4IGRhM2E2ZDU4MDgwOC4uNzFiMjkzMGI4ZTBiIDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJwcm90by5oCisrKyBiL2ZzL2NpZnMvc21iMnByb3RvLmgKQEAgLTE1MCw2
ICsxNTAsMTAgQEAgZXh0ZXJuIGludCBTTUIyX2lvY3RsX2luaXQoc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwgc3RydWN0IHNtYl9ycXN0ICpycXN0LAogCQkJICAgYm9vbCBpc19mc2N0bCwgY2hhciAq
aW5fZGF0YSwgdTMyIGluZGF0YWxlbiwKIAkJCSAgIF9fdTMyIG1heF9yZXNwb25zZV9zaXplKTsK
IGV4dGVybiB2b2lkIFNNQjJfaW9jdGxfZnJlZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOworZXh0
ZXJuIGludCBTTUIyX2NoYW5nZV9ub3RpZnkoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKKwkJCXU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxlX2Zp
ZCwgYm9vbCB3YXRjaF90cmVlLAorCQkJdTMyIGNvbXBsZXRpb25fZmlsdGVyKTsKKwogZXh0ZXJu
IGludCBTTUIyX2Nsb3NlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCiAJCSAgICAgIHU2NCBwZXJzaXN0ZW50X2ZpbGVfaWQsIHU2NCB2b2xhdGlsZV9maWxl
X2lkKTsKIGV4dGVybiBpbnQgU01CMl9jbG9zZV9mbGFncyhjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAotLSAKMi4yMC4xCgo=
--0000000000005559e00593e43f1b--
