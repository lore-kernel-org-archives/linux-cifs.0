Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF15C433DB
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767F164DF8
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhBDIGc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhBDIGb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 03:06:31 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B188C0613ED
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 00:05:51 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id s61so2325354ybi.4
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 00:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VtJ9pYQADJOfRnPZPzEWDVU9ALqKDnGxE9AcnFOzlzc=;
        b=ZQkjLzj5jXUqcwJJVDUbXGSVnxlTHhMHDFQ60Hfe5tk2rxUR0BP9WpTNjNB/k+Tflx
         A7JX+CQPVc4oLiayo7utFHSdZo/9ro181LeKYaKCDHedwYvfp4TphRGm8VXlTMp7VDj8
         4KSwpdASQ29NhAE5nvD6nsMJz7vksxvT2nmLwZUxjIC+kPErw9KuiB6VBaBwcAUq25tV
         8MNmPprvVuZbJV3IvxbIFVSPd6A0aaoQJ0a7IGv9GFo93m5V30Tv3ilCEoiI67AWSXvY
         Hic5PrYtLlpz3NkM7Cj9aFkpp9gO2aX4nHKBlABeAjFXH4u4nbQ8+0Fci70Dg1JKRcaW
         Vcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VtJ9pYQADJOfRnPZPzEWDVU9ALqKDnGxE9AcnFOzlzc=;
        b=nMBzO61Nf6725sr6ajgORbFC4jLklmzwuYXx/mtzmY5TkEUuN8gzcLVkhNjF0DMzh5
         qha1nfixKm44D1ItgCOlult/C7vy9OKKcjP2EXKcoaEk7DKfUq9oudvKXIGQAl15YclF
         QxjFlj1Flw7ALPlZLvG++FDyA79tQVPMZAbgOG/tVBtEfSnq5L4O+iKjYf7Tyo+4vbry
         se7r6DugrAUXaoO6DTAK+Jd8/2lMlpCoL/gSpPLGH10KxGn4S/Skq8xf0RjupwH9JShn
         U8MhEmw/L6ThFYCU/ajrtmDkNovbGU2FrPSp/AG6rd66nnbFEcK63VM32RBC823+Burg
         T/VA==
X-Gm-Message-State: AOAM5331Uh+pU+jvyMI5KGN+VXDn8rpp3kLperz7i4xFtEbi5zuVLuwF
        M9uOONH6taaA8Y+AgmmB6SXVMfPbNKiF03qj9xiBJuoi0HTIyw==
X-Google-Smtp-Source: ABdhPJwfvtVoVWYLEq4JGDiRFS9p7c9ftkOWTE9gneM2EuBWM1JAnGSEiUarYnIP/vI2+qWryiL49JfRWbZGNIv1MMg=
X-Received: by 2002:a25:aa70:: with SMTP id s103mr10557293ybi.131.1612425950493;
 Thu, 04 Feb 2021 00:05:50 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 4 Feb 2021 00:05:39 -0800
Message-ID: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
Subject: [PATCH 1/4] cifs: New optype for session operations.
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000021caf05ba7e2c55"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000021caf05ba7e2c55
Content-Type: text/plain; charset="UTF-8"

Tested with SMB 3.1.1 and 3.0 with and without multichannel.
Also included some review comments from Aurelien.

-- 
Regards,
Shyam

--000000000000021caf05ba7e2c55
Content-Type: application/octet-stream; 
	name="0001-cifs-New-optype-for-session-operations.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-New-optype-for-session-operations.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkqkq2g40>
X-Attachment-Id: f_kkqkq2g40

RnJvbSA3NDQxOGE0OGFmNTA5NDBjYWQzMGZjYjhkN2E2ZDkwZWZlZWE5MmVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMjI6NDk6NTIgLTA4MDAKU3ViamVjdDogW1BBVENIIDEv
NF0gY2lmczogTmV3IG9wdHlwZSBmb3Igc2Vzc2lvbiBvcGVyYXRpb25zLgoKV2UgdXNlZCB0byBz
aGFyZSB0aGUgQ0lGU19ORUdfT1AgZmxhZyBiZXR3ZWVuIG5lZ290aWF0ZSBhbmQKc2Vzc2lvbiBh
dXRoZW50aWNhdGlvbi4gVGhlcmUgd2FzIGFuIGFzc3VtcHRpb24gaW4gdGhlIGNvZGUgdGhhdApD
SUZTX05FR19PUCBpcyB1c2VkIGJ5IG5lZ290aWF0ZSBvbmx5LiBTbyBpbnRyb2N1ZGVkIENJRlNf
U0VTU19PUAphbmQgdXNlZCBpdCBmb3Igc2Vzc2lvbiBzZXR1cCBvcHR5cGVzLgoKU2lnbmVkLW9m
Zi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L2NpZnNnbG9iLmggIHwgMyArKy0KIGZzL2NpZnMvc21iMnBkdS5jICAgfCAyICstCiBmcy9jaWZz
L3RyYW5zcG9ydC5jIHwgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwg
NCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZz
L2NpZnNnbG9iLmgKaW5kZXggNTBmY2I2NTkyMGU4Li4xYTFmOWY0YWU4MGEgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTE3MDQsNyAr
MTcwNCw4IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpc19yZXRyeWFibGVfZXJyb3IoaW50IGVycm9y
KQogI2RlZmluZSAgIENJRlNfRUNIT19PUCAgICAgIDB4MDgwICAgIC8qIGVjaG8gcmVxdWVzdCAq
LwogI2RlZmluZSAgIENJRlNfT0JSRUFLX09QICAgMHgwMTAwICAgIC8qIG9wbG9jayBicmVhayBy
ZXF1ZXN0ICovCiAjZGVmaW5lICAgQ0lGU19ORUdfT1AgICAgICAweDAyMDAgICAgLyogbmVnb3Rp
YXRlIHJlcXVlc3QgKi8KLSNkZWZpbmUgICBDSUZTX09QX01BU0sgICAgIDB4MDM4MCAgICAvKiBt
YXNrIHJlcXVlc3QgdHlwZSAqLworI2RlZmluZSAgIENJRlNfU0VTU19PUCAgICAgMHgyMDAwICAg
IC8qIHNlc3Npb24gc2V0dXAgcmVxdWVzdCAqLworI2RlZmluZSAgIENJRlNfT1BfTUFTSyAgICAg
MHgyMzgwICAgIC8qIG1hc2sgcmVxdWVzdCB0eXBlICovCiAKICNkZWZpbmUgICBDSUZTX0hBU19D
UkVESVRTIDB4MDQwMCAgICAvKiBhbHJlYWR5IGhhcyBjcmVkaXRzICovCiAjZGVmaW5lICAgQ0lG
U19UUkFOU0ZPUk1fUkVRIDB4MDgwMCAgICAvKiB0cmFuc2Zvcm0gcmVxdWVzdCBiZWZvcmUgc2Vu
ZGluZyAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUu
YwppbmRleCBlMTM5MWJkOTI3NjguLjRiYmI2MTI2YjE0ZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9z
bWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTEyNjEsNyArMTI2MSw3IEBAIFNN
QjJfc2Vzc19zZW5kcmVjZWl2ZShzdHJ1Y3QgU01CMl9zZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAkJ
CSAgICBjaWZzX3Nlc19zZXJ2ZXIoc2Vzc19kYXRhLT5zZXMpLAogCQkJICAgICZycXN0LAogCQkJ
ICAgICZzZXNzX2RhdGEtPmJ1ZjBfdHlwZSwKLQkJCSAgICBDSUZTX0xPR19FUlJPUiB8IENJRlNf
TkVHX09QLCAmcnNwX2lvdik7CisJCQkgICAgQ0lGU19MT0dfRVJST1IgfCBDSUZTX1NFU1NfT1As
ICZyc3BfaW92KTsKIAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKHNlc3NfZGF0YS0+aW92WzBdLmlv
dl9iYXNlKTsKIAltZW1jcHkoJnNlc3NfZGF0YS0+aW92WzBdLCAmcnNwX2lvdiwgc2l6ZW9mKHN0
cnVjdCBrdmVjKSk7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMgYi9mcy9jaWZz
L3RyYW5zcG9ydC5jCmluZGV4IDRhMmI4MzZlYjAxNy4uNDEyMjNhOWVlMDg2IDEwMDY0NAotLS0g
YS9mcy9jaWZzL3RyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKQEAgLTExNzEs
NyArMTE3MSw3IEBAIGNvbXBvdW5kX3NlbmRfcmVjdihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkvKgogCSAqIENvbXBvdW5kaW5nIGlzIG5ldmVyIHVzZWQg
ZHVyaW5nIHNlc3Npb24gZXN0YWJsaXNoLgogCSAqLwotCWlmICgoc2VzLT5zdGF0dXMgPT0gQ2lm
c05ldykgfHwgKG9wdHlwZSAmIENJRlNfTkVHX09QKSkKKwlpZiAoKHNlcy0+c3RhdHVzID09IENp
ZnNOZXcpIHx8IChvcHR5cGUgJiBDSUZTX05FR19PUCkgfHwgKG9wdHlwZSAmIENJRlNfU0VTU19P
UCkpCiAJCXNtYjMxMV91cGRhdGVfcHJlYXV0aF9oYXNoKHNlcywgcnFzdFswXS5ycV9pb3YsCiAJ
CQkJCSAgIHJxc3RbMF0ucnFfbnZlYyk7CiAKQEAgLTEyMzYsNyArMTIzNiw3IEBAIGNvbXBvdW5k
X3NlbmRfcmVjdihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywK
IAkvKgogCSAqIENvbXBvdW5kaW5nIGlzIG5ldmVyIHVzZWQgZHVyaW5nIHNlc3Npb24gZXN0YWJs
aXNoLgogCSAqLwotCWlmICgoc2VzLT5zdGF0dXMgPT0gQ2lmc05ldykgfHwgKG9wdHlwZSAmIENJ
RlNfTkVHX09QKSkgeworCWlmICgoc2VzLT5zdGF0dXMgPT0gQ2lmc05ldykgfHwgKG9wdHlwZSAm
IENJRlNfTkVHX09QKSB8fCAob3B0eXBlICYgQ0lGU19TRVNTX09QKSkgewogCQlzdHJ1Y3Qga3Zl
YyBpb3YgPSB7CiAJCQkuaW92X2Jhc2UgPSByZXNwX2lvdlswXS5pb3ZfYmFzZSwKIAkJCS5pb3Zf
bGVuID0gcmVzcF9pb3ZbMF0uaW92X2xlbgotLSAKMi4yNS4xCgo=
--000000000000021caf05ba7e2c55--
