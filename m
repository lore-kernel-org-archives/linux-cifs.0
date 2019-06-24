Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F14C43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 07:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB93205F4
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 07:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCSlw9dg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfFXHMJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:12:09 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:35027 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfFXHMJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 03:12:09 -0400
Received: by mail-pf1-f178.google.com with SMTP id d126so6973156pfd.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=A6uW0hXAqPubh3icQhzVpx2t4ATg1HeTv3nyz8U5pxI=;
        b=mCSlw9dgDuHeQ+z69PIZglNE3wfxVjYSFWHGiKGvRPnZmWS/jyrFF0FlwcdJ7XbRav
         vT8TCMzLXMMPlnn3B017v206qkwBaQOEmyypSFUybC54isPH7+M4uBReVXTB7MBo3IR3
         AwAglyuxLgvlMnAumtxteFfoXNql1/b//XsbzLnN8LIvf+RJbzxRdd216daMLsqY3QVC
         YIC9aloOJXJNn82/6N5bvoMpcF8jEWQsDuxbrBvURaF3Q7JS6IKFCmDBoUpO6sttPoMl
         tXbgAxJf7DXBjNR+gEHV5re6N0zgb9/4udrdDLaJRfAuP4scYw6aeLWCMrFdFGgyNy7W
         av4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=A6uW0hXAqPubh3icQhzVpx2t4ATg1HeTv3nyz8U5pxI=;
        b=gTWrcWh4MWiComMFTe2rqZE/RdwBD2GW2VGgPkReZzikStr0DuSagH7p+05+5z/7qX
         h9RYHY+8goGcFPiMZlys2+fJVlIXJAz71bfJdlp5MMZAJ00BI+WlMRJvDlbogw+ijV2R
         YeIjJLBc5KZHibF/LtNyfcwKXYlazZyKdxXn/xisApu9S0168W5dyrNHsW97Ogpp+UER
         vKkQY7zdXQs4UKjIxfG1r5PGOQfa2Jz6/Jx5Y3tdfXBxmS1QkSxLGJ56VVb6ObLOma2A
         aScpFGxThWv2OBzJhUfHCJeNavi2qhfhO6CLk9kfI8Iys1yauJBr0mkZx9xttnoMcCvw
         Ndcw==
X-Gm-Message-State: APjAAAU3P+qZvY7+Tyisw0363s/PbCDVxbzPb+NzheKjXNTIDbZ06bOV
        x9Wh9Yb0WfNvKYnRnoxO5XK/29370PXX7557fCeVIbty
X-Google-Smtp-Source: APXvYqy3w0+BIgSoEeP0jvigDFlf82PcsV2379Rm6pdGQZI7nqs46p+x5KHIxSR6LXBcjPUkBGyDSDSZqfUZyJcZjco=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr23633706pje.12.1561360328520;
 Mon, 24 Jun 2019 00:12:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 02:11:57 -0500
Message-ID: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
Subject: [SMB3][PATCH] add mount option to allow retrieving POSIX mode from
 special ACE
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000bf992b058c0c8786"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bf992b058c0c8786
Content-Type: text/plain; charset="UTF-8"

See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh509017(v=ws.10)

where it describes use of an ACE with special SID S-1-5-88-3 to store the mode.

Followon patches will add the support for chmod and query_info (stat)



-- 
Thanks,

Steve

--000000000000bf992b058c0c8786
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-new-mount-option-to-retrieve-mode-from-spec.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-new-mount-option-to-retrieve-mode-from-spec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxa1m8cl0>
X-Attachment-Id: f_jxa1m8cl0

RnJvbSA5NTJmMzBiMzFjOTAzZjhmNmY0Y2EwMjMwNjFjMTA4ZDE2Y2M2ZGY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMDI6MDE6NDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbmV3IG1vdW50IG9wdGlvbiB0byByZXRyaWV2ZSBtb2RlIGZyb20gc3BlY2lhbCBB
Q0UKClRoZXJlIGlzIGEgc3BlY2lhbCBBQ0UgdXNlZCBieSBzb21lIHNlcnZlcnMgdG8gYWxsb3cg
dGhlIG1vZGUKYml0cyB0byBiZSBzdG9yZWQuICBUaGlzIGNhbiBiZSBlc3BlY2lhbGx5IGhlbHBm
dWwgaW4gc2NlbmFyaW9zCmluIHdoaWNoIHRoZSBjbGllbnQgaXMgdHJ1c3RlZCwgYW5kIGFjY2Vz
cyBjaGVja2luZyBvbiB0aGUKY2xpZW50IHZzIHRoZSBQT1NJWCBtb2RlIGJpdHMgaXMgc3VmZmlj
aWVudC4KCkFkZCBtb3VudCBvcHRpb24gdG8gYWxsb3cgZW5hYmxpbmcgdGhpcyBiZWhhdmlvci4K
Rm9sbG93IG9uIHBhdGNoIHdpbGwgYWRkIHRoZSBzdXBwb3J0IHRvIGFkZCBjaG1vZCBhbmQgcXVl
cnlpbmZvCihzdGF0KSBzdXBwb3J0IGZvciByZXRyaWV2aW5nIHRoZSBQT1NJWCBtb2RlIGJpdHMg
ZnJvbSB0aGUKc3BlY2lhbCBBQ0UsIFNJRDogUy0xLTUtODgtMwoKU2VlIGUuZy4KaHR0cHM6Ly9k
b2NzLm1pY3Jvc29mdC5jb20vZW4tdXMvcHJldmlvdXMtdmVyc2lvbnMvd2luZG93cy9pdC1wcm8v
d2luZG93cy1zZXJ2ZXItMjAwOC1SMi1hbmQtMjAwOC9oaDUwOTAxNyh2PXdzLjEwKQoKU2lnbmVk
LW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2Np
ZnMvY2lmc19mc19zYi5oIHwgMSArCiBmcy9jaWZzL2NpZnNmcy5jICAgICB8IDIgKysKIGZzL2Np
ZnMvY2lmc2dsb2IuaCAgIHwgMiArLQogZnMvY2lmcy9jb25uZWN0LmMgICAgfCA2ICsrKysrKwog
NCBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jaWZzX2ZzX3NiLmggYi9mcy9jaWZzL2NpZnNfZnNfc2IuaAppbmRleCBh
ZmE1NjIzN2EwYzMuLjc0NGU0OGJkY2I2YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2ZzX3Ni
LmgKKysrIGIvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKQEAgLTUyLDYgKzUyLDcgQEAKICNkZWZpbmUg
Q0lGU19NT1VOVF9VSURfRlJPTV9BQ0wgMHgyMDAwMDAwIC8qIHRyeSB0byBnZXQgVUlEIHZpYSBz
cGVjaWFsIFNJRCAqLwogI2RlZmluZSBDSUZTX01PVU5UX05PX0hBTkRMRV9DQUNIRSAweDQwMDAw
MDAgLyogZGlzYWJsZSBjYWNoaW5nIGRpciBoYW5kbGVzICovCiAjZGVmaW5lIENJRlNfTU9VTlRf
Tk9fREZTIDB4ODAwMDAwMCAvKiBkaXNhYmxlIERGUyByZXNvbHZpbmcgKi8KKyNkZWZpbmUgQ0lG
U19NT1VOVF9NT0RFX0ZST01fQUNFIDB4MTAwMDAwMDAgLyogcmV0cmlldmUgbW9kZSBmcm9tIHNw
ZWNpYWwgQUNFICovCiAKIHN0cnVjdCBjaWZzX3NiX2luZm8gewogCXN0cnVjdCByYl9yb290IHRs
aW5rX3RyZWU7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMu
YwppbmRleCBkYzVmZDdhNjQ4ZjAuLmUzM2RhNzNiZDMwMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC01MjYsNiArNTI2LDggQEAgY2lmc19z
aG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCQlz
ZXFfcHV0cyhzLCAiLG5vYnJsIik7CiAJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lG
U19NT1VOVF9OT19IQU5ETEVfQ0FDSEUpCiAJCXNlcV9wdXRzKHMsICIsbm9oYW5kbGVjYWNoZSIp
OworCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTU9ERV9GUk9NX0FD
RSkKKwkJc2VxX3B1dHMocywgIixtb2RlZnJvbWFjZSIpOwogCWlmIChjaWZzX3NiLT5tbnRfY2lm
c19mbGFncyAmIENJRlNfTU9VTlRfQ0lGU19BQ0wpCiAJCXNlcV9wdXRzKHMsICIsY2lmc2FjbCIp
OwogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfRFlOUEVSTSkKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCAx
NmYyNDA5MTExOTIuLjJjODc1NDdlNDJhYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5o
CisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNjE4LDcgKzYxOCw3IEBAIHN0cnVjdCBzbWJf
dm9sIHsKIAkJCSBDSUZTX01PVU5UX01VTFRJVVNFUiB8IENJRlNfTU9VTlRfU1RSSUNUX0lPIHwg
XAogCQkJIENJRlNfTU9VTlRfQ0lGU19CQUNLVVBVSUQgfCBDSUZTX01PVU5UX0NJRlNfQkFDS1VQ
R0lEIHwgXAogCQkJIENJRlNfTU9VTlRfVUlEX0ZST01fQUNMIHwgQ0lGU19NT1VOVF9OT19IQU5E
TEVfQ0FDSEUgfCBcCi0JCQkgQ0lGU19NT1VOVF9OT19ERlMpCisJCQkgQ0lGU19NT1VOVF9OT19E
RlMgfCBDSUZTX01PVU5UX01PREVfRlJPTV9BQ0UpCiAKIC8qKgogICogR2VuZXJpYyBWRlMgc3Vw
ZXJibG9jayBtb3VudCBmbGFncyAoc19mbGFncykgdG8gY29uc2lkZXIgd2hlbgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBiOGE2MDA2MGQz
MjkuLmY3YmM4NTc3NWY5NiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMv
Y2lmcy9jb25uZWN0LmMKQEAgLTE3NSw2ICsxNzUsNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFi
bGVfdCBjaWZzX21vdW50X29wdGlvbl90b2tlbnMgPSB7CiAJeyBPcHRfc2VydmVyaW5vLCAic2Vy
dmVyaW5vIiB9LAogCXsgT3B0X25vc2VydmVyaW5vLCAibm9zZXJ2ZXJpbm8iIH0sCiAJeyBPcHRf
cndwaWRmb3J3YXJkLCAicndwaWRmb3J3YXJkIiB9LAorCXsgT3B0X21vZGVhY2UsICJtb2RlZnJv
bWFjZSIgfSwKIAl7IE9wdF9jaWZzYWNsLCAiY2lmc2FjbCIgfSwKIAl7IE9wdF9ub2NpZnNhY2ws
ICJub2NpZnNhY2wiIH0sCiAJeyBPcHRfYWNsLCAiYWNsIiB9LApAQCAtMTgzMCw2ICsxODMxLDkg
QEAgY2lmc19wYXJzZV9tb3VudF9vcHRpb25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3Qg
Y2hhciAqZGV2bmFtZSwKIAkJY2FzZSBPcHRfcndwaWRmb3J3YXJkOgogCQkJdm9sLT5yd3BpZGZv
cndhcmQgPSAxOwogCQkJYnJlYWs7CisJCWNhc2UgT3B0X21vZGVhY2U6CisJCQl2b2wtPm1vZGVf
YWNlID0gMTsKKwkJCWJyZWFrOwogCQljYXNlIE9wdF9jaWZzYWNsOgogCQkJdm9sLT5jaWZzX2Fj
bCA9IDE7CiAJCQlicmVhazsKQEAgLTM5NzYsNiArMzk4MCw4IEBAIGludCBjaWZzX3NldHVwX2Np
ZnNfc2Ioc3RydWN0IHNtYl92b2wgKnB2b2x1bWVfaW5mbywKIAkJY2lmc19zYi0+bW50X2NpZnNf
ZmxhZ3MgfD0gQ0lGU19NT1VOVF9OT1BPU0lYQlJMOwogCWlmIChwdm9sdW1lX2luZm8tPnJ3cGlk
Zm9yd2FyZCkKIAkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9SV1BJREZP
UldBUkQ7CisJaWYgKHB2b2x1bWVfaW5mby0+bW9kZV9hY2UpCisJCWNpZnNfc2ItPm1udF9jaWZz
X2ZsYWdzIHw9IENJRlNfTU9VTlRfTU9ERV9GUk9NX0FDRTsKIAlpZiAocHZvbHVtZV9pbmZvLT5j
aWZzX2FjbCkKIAkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9DSUZTX0FD
TDsKIAlpZiAocHZvbHVtZV9pbmZvLT5iYWNrdXB1aWRfc3BlY2lmaWVkKSB7Ci0tIAoyLjIwLjEK
Cg==
--000000000000bf992b058c0c8786--
