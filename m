Return-Path: <SRS0=aWno=RN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CB9C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 00:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C89206DF
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 00:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bpdf6FeB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfCJAXN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Mar 2019 19:23:13 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:41600 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfCJAXN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Mar 2019 19:23:13 -0500
Received: by mail-pf1-f169.google.com with SMTP id d25so925226pfn.8
        for <linux-cifs@vger.kernel.org>; Sat, 09 Mar 2019 16:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KJj/pPkmQoATCB7b4zJnVbAJtRQifucpkxu2p3DaKK0=;
        b=Bpdf6FeB1bAURACJ0DZPiown+HGUV36ZMVerWuprYzEtBlkEIKZxBAeYt/Bq+jbqWt
         dBbMHu0RE9sVAi7eVguQigW/N7P+OMsdRlNiEynYoOsqLodQb4SL7nIOs19jq9zD3gRK
         YF+mDbgoQqoFeXYPEdFvS4q7yzj0N/V8SDtLJc6MHgjZcDlNguITltO9rjPKOfXwl1J3
         wDCFerxZ1kdB+NUT8SutAeDsJiIWc99/6Q9g1hioZvTfFrdaqTA5V6Gh4jI+kH92l6q/
         6a9iOZWPhVDC9DlnUDsPqbN8aEk0HvtJoJ8okJg1Oebah4Mtn67dfzfntOqnV/sJxcbC
         WDBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KJj/pPkmQoATCB7b4zJnVbAJtRQifucpkxu2p3DaKK0=;
        b=ecUeHvkG1QpzmRtb3LUxz26uAyve/O/J0P2SjH9XQxEKApaPYOenITyGZ9cHbY3NNR
         FwPvwDr2E/V27Ze+Eq56ckAUMQVObU4uB2dXbc/WOB/NWxdoZspp2+2yUAVh4SmUbCob
         Ue0P9bxeAkQWQLKIT7gtAsCVKzxY/St8yv80J5vsIV6ZfzMFv1tIa0uRgIjDNwXPFLWX
         oMUknNk+uPcJv1+48wgnxUFcHThguHLK9eyJ9aooqyA2mbTKBmxKQ5UcV4UoqmLLpDvz
         d2C8ZNMfbjbZvaLabNv2lE98z0g8YlPEK4BGNXXj2egUG7kwB0RxQP1myLDmf+HC2xjA
         Sg5Q==
X-Gm-Message-State: APjAAAVacCCH0cCyUdOWc4yvDUqranAT934B4cNh7Uhc3bFZAJjXSfmn
        5w8HIOxQPxLOWRnvfot9XcxKvfFUuPteYs377bo=
X-Google-Smtp-Source: APXvYqyDRL306DppNVNGHc08qSx9VAD0A2B7hu1uxJLsdaQUTOL/hykZ65rWrdxzILND23egz/UIMj9wE9H9hiJ7C/w=
X-Received: by 2002:a63:1053:: with SMTP id 19mr23700229pgq.55.1552177391747;
 Sat, 09 Mar 2019 16:23:11 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 9 Mar 2019 18:22:59 -0600
Message-ID: <CAH2r5mtRcrwx03ZV0X99-zC4rRdughAt=AoJeWw+oBFmePVOoA@mail.gmail.com>
Subject: [PATCH][SMB3] Display security information (encrypted/signed) more
 accurately in /proc/fs/cifs/DebugData
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000106cb30583b2768c"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000106cb30583b2768c
Content-Type: text/plain; charset="UTF-8"

We could also update /proc/mounts with additional flags for the mount,
but since these are often autonegotiated rather than specified on the
mount, it may be more important to dump the accurate debug information
in /proc/fs/cifs/DebugData (distinct from what was specified on the
mount e.g. "seal")

-- 
Thanks,

Steve

--000000000000106cb30583b2768c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-display-security-information-in-proc-fs-cifs-De.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-display-security-information-in-proc-fs-cifs-De.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt26a5tv0>
X-Attachment-Id: f_jt26a5tv0

RnJvbSA1OWQ3YmZlNWEzNmRkNTI5OWQzNWZmMmNkZWI1NTk1M2RmMjcxNTE4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgOSBNYXIgMjAxOSAxODoxMjoxOCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGRpc3BsYXkgc2VjdXJpdHkgaW5mb3JtYXRpb24gaW4gL3Byb2MvZnMvY2lmcy9EZWJ1Z0Rh
dGEKIG1vcmUgYWNjdXJhdGVseQoKV2hlbiB0aGUgc2VydmVyIHJlcXVpcmVkIGVuY3J5cHRpb24g
KGJ1dCB3ZSBkaWRuJ3QgY29ubmVjdCB0byBpdCB3aXRoIHRoZQoic2VhbCIgbW91bnQgb3B0aW9u
KSB3ZSB3ZXJlbid0IGRpc3BsYXlpbmcgaW4gL3Byb2MvZnMvY2lmcy9EZWJ1Z0RhdGEgdGhhdAp0
aGUgdGNvbiBmb3IgdGhhdCBzaGFyZSB3YXMgZW5jcnlwdGVkLiBTaW1pbGFybHkgd2Ugd2VyZSBu
b3QgZGlzcGxheWluZwp0aGF0IHNpZ25pbmcgd2FzIHJlcXVpcmVkIHdoZW4gc2VzLT5zaWduIHdh
cyBlbmFibGVkICh3ZSBvbmx5CmNoZWNrZWQgc2VzLT5zZXJ2ZXItPnNpZ24pLiAgVGhpcyBtYWtl
cyBpdCBlYXNpZXIgdG8gZGVidWcgd2hlbiBpbgpmYWN0IHRoZSBjb25uZWN0aW9uIGlzIHNpZ25l
ZCAob3Igc2VhbGVkKSwgd2hldGhlciBmb3IgcGVyZm9ybWFuY2UKb3Igc2VjdXJpdHkgcXVlc3Rp
b25zLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL2NpZnMvY2lmc19kZWJ1Zy5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lm
c19kZWJ1Zy5jIGIvZnMvY2lmcy9jaWZzX2RlYnVnLmMKaW5kZXggZTkyYTJmZWUzYzU3Li5mNDE3
YjJiN2M5ZTUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCisrKyBiL2ZzL2NpZnMv
Y2lmc19kZWJ1Zy5jCkBAIC0xMTUsNyArMTE1LDkgQEAgc3RhdGljIHZvaWQgY2lmc19kZWJ1Z190
Y29uKHN0cnVjdCBzZXFfZmlsZSAqbSwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKIAkJc2VxX3B1
dHMobSwgIiB0eXBlOiBDRFJPTSAiKTsKIAllbHNlCiAJCXNlcV9wcmludGYobSwgIiB0eXBlOiAl
ZCAiLCBkZXZfdHlwZSk7Ci0JaWYgKHRjb24tPnNlYWwpCisJaWYgKCh0Y29uLT5zZWFsKSB8fAor
CSAgICAodGNvbi0+c2VzLT5zZXNzaW9uX2ZsYWdzICYgU01CMl9TRVNTSU9OX0ZMQUdfRU5DUllQ
VF9EQVRBKSB8fAorCSAgICAodGNvbi0+c2hhcmVfZmxhZ3MgJiBTSEkxMDA1X0ZMQUdTX0VOQ1JZ
UFRfREFUQSkpCiAJCXNlcV9wcmludGYobSwgIiBFbmNyeXB0ZWQiKTsKIAlpZiAodGNvbi0+bm9j
YXNlKQogCQlzZXFfcHJpbnRmKG0sICIgbm9jYXNlIik7CkBAIC0zNzEsNiArMzczLDEwIEBAIHN0
YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZv
aWQgKnYpCiAJCQkJYXRvbWljX3JlYWQoJnNlcnZlci0+aW5fc2VuZCksCiAJCQkJYXRvbWljX3Jl
YWQoJnNlcnZlci0+bnVtX3dhaXRlcnMpKTsKICNlbmRpZgorCQkJaWYgKHNlcy0+c2Vzc2lvbl9m
bGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0VOQ1JZUFRfREFUQSkKKwkJCQlzZXFfcHV0cyhtLCAi
IGVuY3J5cHRlZCIpOworCQkJaWYgKHNlcy0+c2lnbikKKwkJCQlzZXFfcHV0cyhtLCAiIHNpZ25l
ZCIpOwogCiAJCQlzZXFfcHV0cyhtLCAiXG5cdFNoYXJlczoiKTsKIAkJCWogPSAwOwotLSAKMi4x
Ny4xCgo=
--000000000000106cb30583b2768c--
