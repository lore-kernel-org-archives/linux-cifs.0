Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52372C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 06:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9356103D
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 06:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhKJGQ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 01:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKJGQ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 01:16:26 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C79C061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 22:13:39 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id u25so435635ljo.12
        for <linux-cifs@vger.kernel.org>; Tue, 09 Nov 2021 22:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=8LDYDSILwReEKdK44P5QouSpkF5WXIdB3iZ2/ZYYpIo=;
        b=g6F0NO3EoCuuS0xnjzJI3d0oNkusO2K5dh2ZkkVxQLMSmeby2BX9Tq6FEv5Yr3HUud
         axbt0iiwvQt6Ug7iatlv051TVIBh67kZxVbHJgNaRZ4X6xRsN2nTey3iAtUo1HxJqbuo
         kOl67BymY/d/64qwJ5gkH77BaExw2etjAHxOOtVb68pd8SaIrel4nGmvNe8ZptN5EXB6
         Kk4wM3q6TAHGRZUdGkjO8CFhEbXvepRTLOnB09R7K6X3PXO9eilG32H0XLzMtkkTswtX
         T+J2XDDVQpIhYbLuaBPAx9/3xxW+bIRdKwUnPZzAmGQOSEGwmjXuqJfWXNExc6cOWiuD
         NdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8LDYDSILwReEKdK44P5QouSpkF5WXIdB3iZ2/ZYYpIo=;
        b=u0wZV+epjAq2cVIRiSDLpdSpEJ0hDLKbQKvTNVg6gQ0nZtAi5PyQcLRLM9P3BgPiEQ
         94mol/5jdg07CRIquNZm4cVeE9Ugfr5Z5F/8gSk2x134VWFhIpkm+ESRRujChHsi9+9E
         7scyj78ZpqYr4s8V3VhXMW/YdYbnCNRWGm3X7HTRvqG0bHPthVA4SfG/stUWdaKiwh37
         tJ2C2IKxorBebpGdqxzdxBAzEZho2NW7x6iBozR9wqutTyp7jBMh82Ahe1CQpAeX2uQa
         2oY2hNr/n4mkdzWmYH0+ZpoK2lZd2BFgS6xo27ECU+8iOHISLovVFlHH2S2ilnVxngP7
         fOVw==
X-Gm-Message-State: AOAM530QlqKTW1fheejcBb9P4zR/jo8dfcDvxi2r2srWXkf/8E6THXy6
        VCC0TEeC9yMfyo1f3EIDnNP8TOUp8gcByG2pnCM=
X-Google-Smtp-Source: ABdhPJxqvbv888+lkkFm6JMjwEgT1lWdy0h7DMeV3Jakh23HnPfxNNXSzAYR53OlilzA5NBqg0uMUhqZo24PDGAuV5U=
X-Received: by 2002:a2e:a588:: with SMTP id m8mr14250991ljp.23.1636524817695;
 Tue, 09 Nov 2021 22:13:37 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 00:13:26 -0600
Message-ID: <CAH2r5mtTjxz=09DqhSLHMK6VtwtwyT1uQidtpefXN6JAXdthHQ@mail.gmail.com>
Subject: Compounding patch
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006ceefa05d0692090"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006ceefa05d0692090
Content-Type: text/plain; charset="UTF-8"

Of the 8 compounding optimizations (to use an existing handle if we
already have it open), I removed 4 of the 8 sections, but merged the
other half.  See attached:


I left out mkdir and unlink since in those cases the open is what is
doing the work.   For the hardlink case I wanted to verify the
permissions needed (you are checking for a writable handle but the
code doesn't appear to be requesting that when no handle is found) so
I wanted to look at that in more detail (and also the rmdir case -
although that may be one we want to add back).

Even with those changes I see a few examples were we appear to not
reuse the already open handle in e.g. revalidate - so there may be
additional compounding optimizations that we can do.
-- 
Thanks,

Steve

--0000000000006ceefa05d0692090
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-for-compound-requests-use-open-handle-if-possib.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-for-compound-requests-use-open-handle-if-possib.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvt4gkzn0>
X-Attachment-Id: f_kvt4gkzn0

RnJvbSA2MGE2NDhhNDRiZDAxZTViN2E4OTRjNWVmOTY0YzcyNTRjMTU5MzI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDMwIEp1bCAyMDIxIDA2OjQzOjA5ICswMDAwClN1YmplY3Q6IFtQQVRDSCAx
LzJdIGNpZnM6IGZvciBjb21wb3VuZCByZXF1ZXN0cywgdXNlIG9wZW4gaGFuZGxlIGlmIHBvc3Np
YmxlCgpGb3Igc21iMl9jb21wb3VuZF9vcCwgaXQgaXMgcG9zc2libGUgdG8gcGFzcyBhIHJlZiB0
bwphbiBhbHJlYWR5IG9wZW4gZmlsZS4gV2Ugc2hvdWxkIGJlIHBhc3NpbmcgaXQgd2hlbmV2ZXIg
cG9zc2libGUuCmkuZS4gaWYgYSBtYXRjaGluZyBoYW5kbGUgaXMgYWxyZWFkeSBrZXB0IG9wZW4u
CgpJZiB3ZSBkb24ndCBkbyB0aGF0LCB3ZSB3aWxsIGVuZCB1cCBicmVha2luZyBsZWFzZXMgZm9y
IGZpbGVzCmtlcHQgb3BlbiBvbiB0aGUgc2FtZSBjbGllbnQuCgpTaWduZWQtb2ZmLWJ5OiBTaHlh
bSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyaW5vZGUuYyB8
IDIyICsrKysrKysrKysrKysrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMmlub2RlLmMgYi9m
cy9jaWZzL3NtYjJpbm9kZS5jCmluZGV4IDgyOTc3MDM0OTJlZS4uZmU1YmZhMjQ1ZmE3IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJpbm9kZS5jCisrKyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKQEAg
LTQ2LDYgKzQ2LDEwIEBAIHN0cnVjdCBjb3BfdmFycyB7CiAJc3RydWN0IHNtYjJfZmlsZV9saW5r
X2luZm8gbGlua19pbmZvOwogfTsKIAorLyoKKyAqIG5vdGU6IElmIGNmaWxlIGlzIHBhc3NlZCwg
dGhlIHJlZmVyZW5jZSB0byBpdCBpcyBkcm9wcGVkIGhlcmUuCisgKiBTbyBtYWtlIHN1cmUgdGhh
dCB5b3UgZG8gbm90IHJldXNlIGNmaWxlIGFmdGVyIHJldHVybiBmcm9tIHRoaXMgZnVuYy4KKyAq
Lwogc3RhdGljIGludAogc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwg
Y29uc3QgY2hhciAqZnVsbF9wYXRoLApAQCAtNTM2LDEwICs1NDAsMTEgQEAgc21iMl9xdWVyeV9w
YXRoX2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IAkJY3JlYXRlX29wdGlvbnMgfD0gT1BFTl9SRVBBUlNFX1BPSU5UOwogCiAJCS8qIEZhaWxlZCBv
biBhIHN5bWJvbGljIGxpbmsgLSBxdWVyeSBhIHJlcGFyc2UgcG9pbnQgaW5mbyAqLworCQljaWZz
X2dldF9yZWFkYWJsZV9wYXRoKHRjb24sIGZ1bGxfcGF0aCwgJmNmaWxlKTsKIAkJcmMgPSBzbWIy
X2NvbXBvdW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwgZnVsbF9wYXRoLAogCQkJCSAgICAgIEZJ
TEVfUkVBRF9BVFRSSUJVVEVTLCBGSUxFX09QRU4sCiAJCQkJICAgICAgY3JlYXRlX29wdGlvbnMs
IEFDTF9OT19NT0RFLAotCQkJCSAgICAgIHNtYjJfZGF0YSwgU01CMl9PUF9RVUVSWV9JTkZPLCBO
VUxMKTsKKwkJCQkgICAgICBzbWIyX2RhdGEsIFNNQjJfT1BfUVVFUllfSU5GTywgY2ZpbGUpOwog
CX0KIAlpZiAocmMpCiAJCWdvdG8gb3V0OwpAQCAtNTg3LDEwICs1OTIsMTEgQEAgc21iMzExX3Bv
c2l4X3F1ZXJ5X3BhdGhfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogCQljcmVhdGVfb3B0aW9ucyB8PSBPUEVOX1JFUEFSU0VfUE9JTlQ7CiAKIAkJ
LyogRmFpbGVkIG9uIGEgc3ltYm9saWMgbGluayAtIHF1ZXJ5IGEgcmVwYXJzZSBwb2ludCBpbmZv
ICovCisJCWNpZnNfZ2V0X3JlYWRhYmxlX3BhdGgodGNvbiwgZnVsbF9wYXRoLCAmY2ZpbGUpOwog
CQlyYyA9IHNtYjJfY29tcG91bmRfb3AoeGlkLCB0Y29uLCBjaWZzX3NiLCBmdWxsX3BhdGgsCiAJ
CQkJICAgICAgRklMRV9SRUFEX0FUVFJJQlVURVMsIEZJTEVfT1BFTiwKIAkJCQkgICAgICBjcmVh
dGVfb3B0aW9ucywgQUNMX05PX01PREUsCi0JCQkJICAgICAgc21iMl9kYXRhLCBTTUIyX09QX1BP
U0lYX1FVRVJZX0lORk8sIE5VTEwpOworCQkJCSAgICAgIHNtYjJfZGF0YSwgU01CMl9PUF9QT1NJ
WF9RVUVSWV9JTkZPLCBjZmlsZSk7CiAJfQogCWlmIChyYykKIAkJZ290byBvdXQ7CkBAIC03MDcs
MTAgKzcxMywxMiBAQCBzbWIyX3NldF9wYXRoX3NpemUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19z
YiwgYm9vbCBzZXRfYWxsb2MpCiB7CiAJX19sZTY0IGVvZiA9IGNwdV90b19sZTY0KHNpemUpOwor
CXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOwogCisJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0
Y29uLCBmdWxsX3BhdGgsIEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwogCXJldHVybiBzbWIyX2NvbXBv
dW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwgZnVsbF9wYXRoLAogCQkJCUZJTEVfV1JJVEVfREFU
QSwgRklMRV9PUEVOLCAwLCBBQ0xfTk9fTU9ERSwKLQkJCQkmZW9mLCBTTUIyX09QX1NFVF9FT0Ys
IE5VTEwpOworCQkJCSZlb2YsIFNNQjJfT1BfU0VUX0VPRiwgY2ZpbGUpOwogfQogCiBpbnQKQEAg
LTcxOSw2ICs3MjcsOCBAQCBzbWIyX3NldF9maWxlX2luZm8oc3RydWN0IGlub2RlICppbm9kZSwg
Y29uc3QgY2hhciAqZnVsbF9wYXRoLAogewogCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2Ig
PSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKIAlzdHJ1Y3QgdGNvbl9saW5rICp0bGluazsKKwlzdHJ1
Y3QgY2lmc190Y29uICp0Y29uOworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOwogCWludCBy
YzsKIAogCWlmICgoYnVmLT5DcmVhdGlvblRpbWUgPT0gMCkgJiYgKGJ1Zi0+TGFzdEFjY2Vzc1Rp
bWUgPT0gMCkgJiYKQEAgLTcyOSwxMCArNzM5LDEyIEBAIHNtYjJfc2V0X2ZpbGVfaW5mbyhzdHJ1
Y3QgaW5vZGUgKmlub2RlLCBjb25zdCBjaGFyICpmdWxsX3BhdGgsCiAJdGxpbmsgPSBjaWZzX3Ni
X3RsaW5rKGNpZnNfc2IpOwogCWlmIChJU19FUlIodGxpbmspKQogCQlyZXR1cm4gUFRSX0VSUih0
bGluayk7CisJdGNvbiA9IHRsaW5rX3Rjb24odGxpbmspOwogCi0JcmMgPSBzbWIyX2NvbXBvdW5k
X29wKHhpZCwgdGxpbmtfdGNvbih0bGluayksIGNpZnNfc2IsIGZ1bGxfcGF0aCwKKwljaWZzX2dl
dF93cml0YWJsZV9wYXRoKHRjb24sIGZ1bGxfcGF0aCwgRklORF9XUl9BTlksICZjZmlsZSk7CisJ
cmMgPSBzbWIyX2NvbXBvdW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwgZnVsbF9wYXRoLAogCQkJ
ICAgICAgRklMRV9XUklURV9BVFRSSUJVVEVTLCBGSUxFX09QRU4sCi0JCQkgICAgICAwLCBBQ0xf
Tk9fTU9ERSwgYnVmLCBTTUIyX09QX1NFVF9JTkZPLCBOVUxMKTsKKwkJCSAgICAgIDAsIEFDTF9O
T19NT0RFLCBidWYsIFNNQjJfT1BfU0VUX0lORk8sIGNmaWxlKTsKIAljaWZzX3B1dF90bGluayh0
bGluayk7CiAJcmV0dXJuIHJjOwogfQotLSAKMi4zMi4wCgo=
--0000000000006ceefa05d0692090
Content-Type: text/x-patch; charset="US-ASCII"; name="sections-left-out-of-compounding.patch"
Content-Disposition: attachment; 
	filename="sections-left-out-of-compounding.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvt4h0ih1>
X-Attachment-Id: f_kvt4h0ih1

QEAgLTYwOCwxMCArNjE0LDEzIEBAIHNtYjJfbWtkaXIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGlub2RlICpwYXJlbnRfaW5vZGUsIHVtb2RlX3QgbW9kZSwKIAkgICBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLCBjb25zdCBjaGFyICpuYW1lLAogCSAgIHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IpCiB7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7CisKKwljaWZzX2dldF93
cml0YWJsZV9wYXRoKHRjb24sIG5hbWUsIEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwogCXJldHVybiBz
bWIyX2NvbXBvdW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwgbmFtZSwKIAkJCQlGSUxFX1dSSVRF
X0FUVFJJQlVURVMsIEZJTEVfQ1JFQVRFLAogCQkJCUNSRUFURV9OT1RfRklMRSwgbW9kZSwgTlVM
TCwgU01CMl9PUF9NS0RJUiwKLQkJCQlOVUxMKTsKKwkJCQljZmlsZSk7CiB9CiAKIHZvaWQKIHN0
YXRpYyBpbnQKIEBAIC02NDIsMTggKzY1MSwyNCBAQCBpbnQKIHNtYjJfcm1kaXIoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3QgY2hhciAqbmFtZSwK
IAkgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogeworCXN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlOworCisJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0Y29uLCBuYW1lLCBGSU5EX1dS
X1dJVEhfREVMRVRFLCAmY2ZpbGUpOwogCXJldHVybiBzbWIyX2NvbXBvdW5kX29wKHhpZCwgdGNv
biwgY2lmc19zYiwgbmFtZSwgREVMRVRFLCBGSUxFX09QRU4sCiAJCQkJQ1JFQVRFX05PVF9GSUxF
LCBBQ0xfTk9fTU9ERSwKLQkJCQlOVUxMLCBTTUIyX09QX1JNRElSLCBOVUxMKTsKKwkJCQlOVUxM
LCBTTUIyX09QX1JNRElSLCBjZmlsZSk7CiB9CiAKIGludAogc21iMl91bmxpbmsoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3QgY2hhciAqbmFtZSwK
IAkgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYikKIHsKKwlzdHJ1Y3QgY2lmc0ZpbGVJ
bmZvICpjZmlsZTsKKworCWNpZnNfZ2V0X3dyaXRhYmxlX3BhdGgodGNvbiwgbmFtZSwgRklORF9X
Ul9XSVRIX0RFTEVURSwgJmNmaWxlKTsKIAlyZXR1cm4gc21iMl9jb21wb3VuZF9vcCh4aWQsIHRj
b24sIGNpZnNfc2IsIG5hbWUsIERFTEVURSwgRklMRV9PUEVOLAogCQkJCUNSRUFURV9ERUxFVEVf
T05fQ0xPU0UgfCBPUEVOX1JFUEFSU0VfUE9JTlQsCi0JCQkJQUNMX05PX01PREUsIE5VTEwsIFNN
QjJfT1BfREVMRVRFLCBOVUxMKTsKKwkJCQlBQ0xfTk9fTU9ERSwgTlVMTCwgU01CMl9PUF9ERUxF
VEUsIGNmaWxlKTsKIH0KIAogc3RhdGljIGludApAQCAtNjk2LDkgKzcxMSwxMiBAQCBzbWIyX2Ny
ZWF0ZV9oYXJkbGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCQkgICAgIGNvbnN0IGNoYXIgKmZyb21fbmFtZSwgY29uc3QgY2hhciAqdG9fbmFtZSwK
IAkJICAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogeworCXN0cnVjdCBjaWZzRmls
ZUluZm8gKmNmaWxlOworCisJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0Y29uLCBmcm9tX25hbWUs
IEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwogCXJldHVybiBzbWIyX3NldF9wYXRoX2F0dHIoeGlkLCB0
Y29uLCBmcm9tX25hbWUsIHRvX25hbWUsIGNpZnNfc2IsCiAJCQkJICBGSUxFX1JFQURfQVRUUklC
VVRFUywgU01CMl9PUF9IQVJETElOSywKLQkJCQkgIE5VTEwpOworCQkJCSAgY2ZpbGUpOwogfQog
CiBpbnQK
--0000000000006ceefa05d0692090--
