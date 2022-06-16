Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406F9C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jun 2022 03:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbiFPDtV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jun 2022 23:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350832AbiFPDtU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jun 2022 23:49:20 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDC84552B
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jun 2022 20:49:18 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id x190so118336vkc.9
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jun 2022 20:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=VAiVbI8s/KsUYIkE9//lPGymx+h7NW6JIVMINIo8pQU=;
        b=cHKqmSJXqiOoBvYk6hipNKHCnvDUB907pcylaOa2dLEfCFuPk/cxTUDdvLOW6qR555
         1UydbfbcXzuPpbd13rfLrZCLwm6pvyb5a8KP+SShE2YqWx1CWsf5wPP4DI92HpbSdIBe
         jovGhKFea4MtFNQdFwXMGKAntFnZ8a8PByX+N27fQkhJwNVii3qmo4TZJm9p7qkeKs9a
         ekINZIZcuHf1dsAgwd5NFFpZXUQWWEAWzQzPBb9hzVBqjs15Q9HGG34DUZp3S8Gm0C5B
         EyCiVTNG4YeF8xW7dJr9nDL7Bwtyscq2vDxC3RSUIJ1GrMGPTs0cYISXcm/MJKmZVgz6
         CRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VAiVbI8s/KsUYIkE9//lPGymx+h7NW6JIVMINIo8pQU=;
        b=VfFe02aofLuL8u1okuqUASGQIvmSWhNZ0f5xlaVOF0xg++f6gDKAboD2rP6nA17Ciw
         aWLkYzeLc6MoESNj4yPYZmSwlv5pYumBXwnyOMNQ2msCJZcIUF8+AeoLsFfxiS0YayM4
         iT/GW4MvftxOWgE/J39F0/olM1/gF4oYczRD0VfB1ehYwgm1gSBiUyTTHOK1m87q+1G1
         aPNqsJuN7RkpLNDfRqfHWz7NYvveqKtUdXLQQXR5QE3XJ876lUZpxNUL2mk4S8/Kt4Uu
         7RgpzjkjtPlshc5Akd9pXOju/+0mPVs+LNSMq3SgHIqStCYX7h4Rei87IgzkW9M31QWl
         UNcw==
X-Gm-Message-State: AJIora+ZckB9wBW75P1eOYeBjGdII6IbiwFV64sFnri4Tz2JbtcPVD1Z
        yw92Ji6AzXCUrwxspTKPY1dhnlffg2JOqTkELsBgG40S2MI=
X-Google-Smtp-Source: AGRyM1uEuDCH8zTR2x9AeomwAkWR585xM9gzrWur6un6h5MUj2mB035/9sBf5GaynHSYr/s8BSyLiMUQoDSsSTvHp8s=
X-Received: by 2002:ac5:cb4f:0:b0:368:d0d7:7617 with SMTP id
 s15-20020ac5cb4f000000b00368d0d77617mr1355439vkl.38.1655351357585; Wed, 15
 Jun 2022 20:49:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jun 2022 22:49:05 -0500
Message-ID: <CAH2r5msPtTtDqkZHax3G5K3NVCzxN+aBdy7_bmj5FgjJC_uGRw@mail.gmail.com>
Subject: [PATCH][SMB3] add dynamic trace point smb3_set_eof
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a60fc705e1888589"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a60fc705e1888589
Content-Type: text/plain; charset="UTF-8"

In order to debug problems with file size being reported incorrectly
temporarily (in this case xfstest generic/584 intermittent failure)
we need to add trace point for the non-compounded code path where
we set the file size (SMB2_set_eof).  The new trace point is:
     "smb3_set_eof"

Here is sample output from the tracepoint:

                TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
                  | |         |   |||||     |         |
       xfs_io-75403   [002] ..... 95219.189835: smb3_set_eof: xid=221
sid=0xeef1cbd2 tid=0x27079ee6 fid=0x52edb58c offset=0x100000
 aio-dio-append--75418   [010] ..... 95219.242402: smb3_set_eof:
xid=226 sid=0xeef1cbd2 tid=0x27079ee6 fid=0xae89852d offset=0x0


-- 
Thanks,

Steve

--000000000000a60fc705e1888589
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-trace-point-for-SMB2_set_eof.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-trace-point-for-SMB2_set_eof.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l4ghfrv50>
X-Attachment-Id: f_l4ghfrv50

RnJvbSA3YzVlN2JjNDAyMmNmMDY3NDJhYzBlYjllZDBiNTgzZDNkN2M5YjI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTUgSnVuIDIwMjIgMjI6NDA6MjMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgdHJhY2UgcG9pbnQgZm9yIFNNQjJfc2V0X2VvZgoKSW4gb3JkZXIgdG8gZGVidWcg
cHJvYmxlbXMgd2l0aCBmaWxlIHNpemUgYmVpbmcgcmVwb3J0ZWQgaW5jb3JyZWN0bHkKdGVtcG9y
YXJpbHkgKGluIHRoaXMgY2FzZSB4ZnN0ZXN0IGdlbmVyaWMvNTg0IGludGVybWl0dGVudCBmYWls
dXJlKQp3ZSBuZWVkIHRvIGFkZCB0cmFjZSBwb2ludCBmb3IgdGhlIG5vbi1jb21wb3VuZGVkIGNv
ZGUgcGF0aCB3aGVyZQp3ZSBzZXQgdGhlIGZpbGUgc2l6ZSAoU01CMl9zZXRfZW9mKS4gIFRoZSBu
ZXcgdHJhY2UgcG9pbnQgaXM6CiAgICJzbWIzX3NldF9lb2YiCgpIZXJlIGlzIHNhbXBsZSBvdXRw
dXQgZnJvbSB0aGUgdHJhY2Vwb2ludDoKCiAgICAgICAgICAgIFRBU0stUElEICAgICBDUFUjICB8
fHx8fCAgVElNRVNUQU1QICBGVU5DVElPTgogICAgICAgICAgICAgIHwgfCAgICAgICAgIHwgICB8
fHx8fCAgICAgfCAgICAgICAgIHwKICAgICAgICAgIHhmc19pby03NTQwMyAgIFswMDJdIC4uLi4u
IDk1MjE5LjE4OTgzNTogc21iM19zZXRfZW9mOiB4aWQ9MjIxIHNpZD0weGVlZjFjYmQyIHRpZD0w
eDI3MDc5ZWU2IGZpZD0weDUyZWRiNThjIG9mZnNldD0weDEwMDAwMAogYWlvLWRpby1hcHBlbmQt
LTc1NDE4ICAgWzAxMF0gLi4uLi4gOTUyMTkuMjQyNDAyOiBzbWIzX3NldF9lb2Y6IHhpZD0yMjYg
c2lkPTB4ZWVmMWNiZDIgdGlkPTB4MjcwNzllZTYgZmlkPTB4YWU4OTg1MmQgb2Zmc2V0PTB4MAoK
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvc21iMnBkdS5jIHwgIDIgKysKIGZzL2NpZnMvdHJhY2UuaCAgIHwgMzggKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgNDAgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIy
cGR1LmMKaW5kZXggZWFmOTc1ZjFhZDg5Li5iNTE1MTQwYmFkOGQgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC01MTU0LDYgKzUxNTQsOCBA
QCBTTUIyX3NldF9lb2YoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwgdTY0IHBlcnNpc3RlbnRfZmlkLAogCWRhdGEgPSAmaW5mbzsKIAlzaXplID0gc2l6ZW9m
KHN0cnVjdCBzbWIyX2ZpbGVfZW9mX2luZm8pOwogCisJdHJhY2Vfc21iM19zZXRfZW9mKHhpZCwg
cGVyc2lzdGVudF9maWQsIHRjb24tPnRpZCwgdGNvbi0+c2VzLT5TdWlkLCBsZTY0X3RvX2NwdSgq
ZW9mKSk7CisKIAlyZXR1cm4gc2VuZF9zZXRfaW5mbyh4aWQsIHRjb24sIHBlcnNpc3RlbnRfZmlk
LCB2b2xhdGlsZV9maWQsCiAJCQlwaWQsIEZJTEVfRU5EX09GX0ZJTEVfSU5GT1JNQVRJT04sIFNN
QjJfT19JTkZPX0ZJTEUsCiAJCQkwLCAxLCAmZGF0YSwgJnNpemUpOwpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy90cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCmluZGV4IDJiZTVlMGM4NTY0ZC4uNmI4OGRj
MmUzNjRmIDEwMDY0NAotLS0gYS9mcy9jaWZzL3RyYWNlLmgKKysrIGIvZnMvY2lmcy90cmFjZS5o
CkBAIC0xMjEsNiArMTIxLDQ0IEBAIERFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQocXVlcnlfZGly
X2RvbmUpOwogREVGSU5FX1NNQjNfUldfRE9ORV9FVkVOVCh6ZXJvX2RvbmUpOwogREVGSU5FX1NN
QjNfUldfRE9ORV9FVkVOVChmYWxsb2NfZG9uZSk7CiAKKy8qIEZvciBsb2dnaW5nIHN1Y2Nlc3Nm
dWwgc2V0IEVPRiAodHJ1bmNhdGUpICovCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfZW9mX2Ns
YXNzLAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQsCisJCV9fdTY0CWZpZCwKKwkJX191MzIJ
dGlkLAorCQlfX3U2NAlzZXNpZCwKKwkJX191NjQJb2Zmc2V0KSwKKwlUUF9BUkdTKHhpZCwgZmlk
LCB0aWQsIHNlc2lkLCBvZmZzZXQpLAorCVRQX1NUUlVDVF9fZW50cnkoCisJCV9fZmllbGQodW5z
aWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191NjQsIGZpZCkKKwkJX19maWVsZChfX3UzMiwg
dGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19maWVsZChfX3U2NCwgb2Zmc2V0KQor
CSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJX19lbnRyeS0+
ZmlkID0gZmlkOworCQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNlc2lkID0gc2Vz
aWQ7CisJCV9fZW50cnktPm9mZnNldCA9IG9mZnNldDsKKwkpLAorCVRQX3ByaW50aygieGlkPSV1
IHNpZD0weCVsbHggdGlkPTB4JXggZmlkPTB4JWxseCBvZmZzZXQ9MHglbGx4IiwKKwkJX19lbnRy
eS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwgX19lbnRyeS0+dGlkLCBfX2VudHJ5LT5maWQsCisJCV9f
ZW50cnktPm9mZnNldCkKKykKKworI2RlZmluZSBERUZJTkVfU01CM19FT0ZfRVZFTlQobmFtZSkg
ICAgICAgICBcCitERUZJTkVfRVZFTlQoc21iM19lb2ZfY2xhc3MsIHNtYjNfIyNuYW1lLCAgIFwK
KwlUUF9QUk9UTyh1bnNpZ25lZCBpbnQgeGlkLAkJXAorCQlfX3U2NAlmaWQsCQkJXAorCQlfX3Uz
Mgl0aWQsCQkJXAorCQlfX3U2NAlzZXNpZCwJCQlcCisJCV9fdTY0CW9mZnNldCksCQlcCisJVFBf
QVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCwgb2Zmc2V0KSkKKworREVGSU5FX1NNQjNfRU9GX0VW
RU5UKHNldF9lb2YpOworCiAvKgogICogRm9yIGhhbmRsZSBiYXNlZCBjYWxscyBvdGhlciB0aGFu
IHJlYWQgYW5kIHdyaXRlLCBhbmQgZ2V0L3NldCBpbmZvCiAgKi8KLS0gCjIuMzQuMQoK
--000000000000a60fc705e1888589--
