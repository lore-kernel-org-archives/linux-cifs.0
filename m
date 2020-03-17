Return-Path: <SRS0=Uqea=5C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B75C10F29
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Mar 2020 07:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67825206EC
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Mar 2020 07:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="olE5qSaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgCQHAH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Mar 2020 03:00:07 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:41520 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgCQHAG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Mar 2020 03:00:06 -0400
Received: by mail-qk1-f178.google.com with SMTP id s11so19452562qks.8
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2020 00:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YyP5/uYDqMbCadMIux2UsmVfY9d250YvoW2fEJzqdFM=;
        b=olE5qSaXa2r5wam1wT7beEWZlu0g4GoB25ymqdg63uHMu+oSacmuXCO6ggcH5BWwVv
         4qIxkNG1E4SXYjVGOEYccDZqrhmjXJ7UucC7kU0oM50m5Y0SGdvEOohY6K3oy8LHQhlN
         S76hB0Xr1XZFA+NR8jxyZS8H21540wbL1zGk0TvLv9HAuP0591GJUNV2W0YWDJZ1OGho
         gnLRPKGgIcu+6vzpnNb6ZqfdSDa1QyYOXod7d7zVgvzTF/9przmpUJTmMWFf8UXQi2KQ
         7DNtsDhaQD/MJ/3ODRimTt1mWCfoa+BVlae/x5sGhdB/tYSrz3YA7X3wtoZoLvDn+QJj
         qgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YyP5/uYDqMbCadMIux2UsmVfY9d250YvoW2fEJzqdFM=;
        b=L95QywW0vMvU4mUfrdvUgu7crLQSkbRv+ooZGNiNwyHrqeDOwySnyXLEp11rzubivi
         Ng7B/fBOgpehxdUL6NfoNMGbbP6I7vUisBd9fOj6VxbYM7kyfl6NPxM0MhN7LSxpSSCt
         cOGLownbjzuaAooMvAMjA1PcqQ0v1Zqk4NbV5wXVKsDNOyPyv7PGjWXI8QBFINPWBysR
         1KIUSftR1t+b2SZoNdM9PxYJRNaKSNnpX2qTz4FwWna/7Fd6scZkU8V1wEIZS27N1TZP
         9Zs3hqDQxjziPo/xRpLcU9c1rbKZvMfQ3qiYRYXodr7P7IL1q8C4iiHGoAsJ/qvJgni7
         0Whg==
X-Gm-Message-State: ANhLgQ2qdjFmoR7bkdl7ZKypgh+nkSkVIPM+79YOHXTh2yr9XIn04DEZ
        Z0YpvMo2Ip1R1DjmQpSwGhOO9gmlRhbcW5m+3nBdoRxKT4A=
X-Google-Smtp-Source: ADFU+vs+t7cmamUAkGeCPZWQe15f2ARDCtA+sEcR09v1mN9nu4YPLisboW8MtmXo1p91yD88U0YX5V1/ZhA65GJMf2M=
X-Received: by 2002:a05:6902:685:: with SMTP id i5mr5840971ybt.376.1584428404767;
 Tue, 17 Mar 2020 00:00:04 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Mar 2020 01:59:53 -0500
Message-ID: <CAH2r5mtLBZJA+xcyOF9MsPL5ikM+omELUq4Uj6BadueVgHoRMg@mail.gmail.com>
Subject: [PATCH][SMB3] Add two missing flags and minor cleanup to smb2pdu.h
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000003d1b4605a1077cbb"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003d1b4605a1077cbb
Content-Type: text/plain; charset="UTF-8"

Minor cleanup and add one missing define (COMPRESSION_TRANSFORM_ID)
and flag (TRANSFORM_FLAG_ENCRYPTED)


-- 
Thanks,

Steve

--0000000000003d1b4605a1077cbb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Minor-cleanup-of-protocol-definitions.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Minor-cleanup-of-protocol-definitions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7vjr53l0>
X-Attachment-Id: f_k7vjr53l0

RnJvbSA5MmIxY2RlOWY2MzZhZWQ4MjBhNmE3NTkzMTZiYTA5Njk0YTE0MTkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTcgTWFyIDIwMjAgMDE6NTM6MzkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBNaW5vciBjbGVhbnVwIG9mIHByb3RvY29sIGRlZmluaXRpb25zCgpBbmQgYWRkIG9uZSBt
aXNzaW5nIGRlZmluZSAoQ09NUFJFU1NJT05fVFJBTlNGT1JNX0lEKSBhbmQKZmxhZyAoVFJBTlNG
T1JNX0ZMQUdfRU5DUllQVEVEKQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgMTUgKysrKysrKysrKyst
LS0tCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDhi
OWY1NDZkZDg0Mi4uZGRhOTI4ZDA1YzEzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAor
KysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtOTEsNiArOTEsNyBAQAogCiAjZGVmaW5lIFNNQjJf
UFJPVE9fTlVNQkVSIGNwdV90b19sZTMyKDB4NDI0ZDUzZmUpCiAjZGVmaW5lIFNNQjJfVFJBTlNG
T1JNX1BST1RPX05VTSBjcHVfdG9fbGUzMigweDQyNGQ1M2ZkKQorI2RlZmluZSBTTUIyX0NPTVBS
RVNTSU9OX1RSQU5TRk9STV9JRCBjcHVfdG9fbGUzMigweDQyNGQ1M2ZjKQogCiAvKgogICogU01C
MiBIZWFkZXIgRGVmaW5pdGlvbgpAQCAtMTI3LDEzICsxMjgsMTUgQEAgc3RydWN0IHNtYjJfc3lu
Y19wZHUgewogI2RlZmluZSBTTUIzX0FFUzEyOENDTV9OT05DRSAxMQogI2RlZmluZSBTTUIzX0FF
UzEyOEdDTV9OT05DRSAxMgogCisvKiBUcmFuc2Zvcm0gZmxhZ3MgKGZvciAzLjAgZGlhbGVjdCB0
aGlzIGZsYWcgaW5kaWNhdGVzIENDTSAqLworI2RlZmluZSBUUkFOU0ZPUk1fRkxBR19FTkNSWVBU
RUQJMHgwMDAxCiBzdHJ1Y3Qgc21iMl90cmFuc2Zvcm1faGRyIHsKIAlfX2xlMzIgUHJvdG9jb2xJ
ZDsJLyogMHhGRCAnUycgJ00nICdCJyAqLwogCV9fdTggICBTaWduYXR1cmVbMTZdOwogCV9fdTgg
ICBOb25jZVsxNl07CiAJX19sZTMyIE9yaWdpbmFsTWVzc2FnZVNpemU7CiAJX191MTYgIFJlc2Vy
dmVkMTsKLQlfX2xlMTYgRmxhZ3M7IC8qIEVuY3J5cHRpb25BbGdvcml0aG0gKi8KKwlfX2xlMTYg
RmxhZ3M7IC8qIEVuY3J5cHRpb25BbGdvcml0aG0gZm9yIDMuMCwgZW5jIGVuYWJsZWQgZm9yIDMu
MS4xICovCiAJX191NjQgIFNlc3Npb25JZDsKIH0gX19wYWNrZWQ7CiAKQEAgLTIwNyw2ICsyMTAs
MTAgQEAgc3RydWN0IHNtYjJfZXJyb3JfY29udGV4dF9yc3AgewogCV9fdTggIEVycm9yQ29udGV4
dERhdGE7IC8qIEVycm9yRGF0YUxlbmd0aCBsb25nIGFycmF5ICovCiB9IF9fcGFja2VkOwogCisv
KiBFcnJvcklkIHZhbHVlcyAqLworI2RlZmluZSBTTUIyX0VSUk9SX0lEX0RFRkFVTFQJCTB4MDAw
MDAwMDAKKyNkZWZpbmUgU01CMl9FUlJPUl9JRF9TSEFSRV9SRURJUkVDVAljcHVfdG9fbGUzMigw
eDcyNjQ1MjUzKQkvKiAicmRSUyIgKi8KKwogLyogRGVmaW5lcyBmb3IgVHlwZSBmaWVsZCBiZWxv
dyAoc2VlIE1TLVNNQjIgMi4yLjIuMi4yLjEpICovCiAjZGVmaW5lIE1PVkVfRFNUX0lQQUREUl9W
NAljcHVfdG9fbGUzMigweDAwMDAwMDAxKQogI2RlZmluZSBNT1ZFX0RTVF9JUEFERFJfVjYJY3B1
X3RvX2xlMzIoMHgwMDAwMDAwMikKQEAgLTQyNyw3ICs0MzQsNyBAQCBzdHJ1Y3Qgc21iMl9sb2dv
ZmZfcnNwIHsKIHN0cnVjdCBzbWIyX3RyZWVfY29ubmVjdF9yZXEgewogCXN0cnVjdCBzbWIyX3N5
bmNfaGRyIHN5bmNfaGRyOwogCV9fbGUxNiBTdHJ1Y3R1cmVTaXplOwkvKiBNdXN0IGJlIDkgKi8K
LQlfX2xlMTYgUmVzZXJ2ZWQ7IC8qIEZsYWdzIGluIFNNQjMuMS4xICovCisJX19sZTE2IEZsYWdz
OyAvKiBSZXNlcnZlZCBNQlogZm9yIGRpYWxlY3RzIHByaW9yIHRvIFNNQjMuMS4xICovCiAJX19s
ZTE2IFBhdGhPZmZzZXQ7CiAJX19sZTE2IFBhdGhMZW5ndGg7CiAJX191OCAgIEJ1ZmZlclsxXTsJ
LyogdmFyaWFibGUgbGVuZ3RoICovCkBAIC02NTQsNyArNjYxLDcgQEAgc3RydWN0IHNtYjJfdHJl
ZV9kaXNjb25uZWN0X3JzcCB7CiAJCQl8IEZJTEVfV1JJVEVfRUFfTEUgfCBGSUxFX1dSSVRFX0FU
VFJJQlVURVNfTEUpCiAjZGVmaW5lIEZJTEVfRVhFQ19SSUdIVFNfTEUgKEZJTEVfRVhFQ1VURV9M
RSkKIAotLyogSW1wZXJzb25hdGlvbiBMZXZlbHMgKi8KKy8qIEltcGVyc29uYXRpb24gTGV2ZWxz
LiBTZWUgTVMtV1BPIHNlY3Rpb24gOS43IGFuZCBNU0ROLUlNUEVSUyAqLwogI2RlZmluZSBJTF9B
Tk9OWU1PVVMJCWNwdV90b19sZTMyKDB4MDAwMDAwMDApCiAjZGVmaW5lIElMX0lERU5USUZJQ0FU
SU9OCWNwdV90b19sZTMyKDB4MDAwMDAwMDEpCiAjZGVmaW5lIElMX0lNUEVSU09OQVRJT04JY3B1
X3RvX2xlMzIoMHgwMDAwMDAwMikKQEAgLTc2MCw3ICs3NjcsNyBAQCBzdHJ1Y3QgY3JlYXRlX2Nv
bnRleHQgewogI2RlZmluZSBTTUIyX0xFQVNFX0hBTkRMRV9DQUNISU5HCWNwdV90b19sZTMyKDB4
MDIpCiAjZGVmaW5lIFNNQjJfTEVBU0VfV1JJVEVfQ0FDSElORwljcHVfdG9fbGUzMigweDA0KQog
Ci0jZGVmaW5lIFNNQjJfTEVBU0VfRkxBR19CUkVBS19JTl9QUk9HUkVTUyBjcHVfdG9fbGUzMigw
eDAyKQorI2RlZmluZSBTTUIyX0xFQVNFX0ZMQUdfQlJFQUtfSU5fUFJPR1JFU1MgY3B1X3RvX2xl
MzIoMHgwMDAwMDAwMikKICNkZWZpbmUgU01CMl9MRUFTRV9GTEFHX1BBUkVOVF9MRUFTRV9LRVlf
U0VUIGNwdV90b19sZTMyKDB4MDAwMDAwMDQpCiAKICNkZWZpbmUgU01CMl9MRUFTRV9LRVlfU0la
RSAxNgotLSAKMi4yMC4xCgo=
--0000000000003d1b4605a1077cbb--
