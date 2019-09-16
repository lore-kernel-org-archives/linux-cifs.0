Return-Path: <SRS0=fTzl=XL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE51C4CEC4
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 03:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A375214AF
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 03:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fu7GVOWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfIPDmB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Sep 2019 23:42:01 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:38015 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfIPDmB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Sep 2019 23:42:01 -0400
Received: by mail-io1-f54.google.com with SMTP id k5so50176644iol.5
        for <linux-cifs@vger.kernel.org>; Sun, 15 Sep 2019 20:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uhrclg99FtPrREsCN0Bh1kEhIWWOCZyDK+/CFOr8kkA=;
        b=fu7GVOWPjKjJS3qCfCUMqFhxMrMEw52pm2Qnf9OVsOYZh7mxpeVkUiJxkP0EpGQMw6
         tonPYgzxixY6iQRV+8uBwQnlntfhizuLIrmbbnaRem6dgDCwwt//vBYGukQemHDm5418
         Ghn4u0ftoazil3qma55I8GQq/VtAOaAe+XNujYn69XaABZWtX1GGogAxTWGqeYMWpE0n
         JdY6Ov8vir4fCdQ3wzbEo1pv80l8wIYlZmTNqDo+/hsrjorAwrM2c1Wdu6wA4+I4hXCM
         PlQOO4E7QW8AgDXMEnY9SIu5HWlXstvdXZg3YBezdev58ai6na+G4Q43dNMPZrvQHGtt
         DKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uhrclg99FtPrREsCN0Bh1kEhIWWOCZyDK+/CFOr8kkA=;
        b=K/WZrj84q5NUsGNVV/b1ybGMofuImmSlVZsgvj2pnl6kqjc8SVoe1A6e8QGPIvUxRK
         4GTH9HQI8Y05meyPgAqTdEGtRfvXnup+uXqUlUi5f/ZrpQmm6QDuTAv0ZeAOb7PbrlIp
         L5V/VS8GhiGn6R+hKWJhNbN2pUjHAgDSdYG7Xv2ELqXbTNexgFNpUgo/SspMgAQ6eus6
         Pu9TocR5eOB7t3eyJT0lUoIoAuLwhWEtK36h9fpPPCHStQ0g29rls5EJx1pI7IlLDcQS
         QedAwPGPuBJTOmmcMl0dlcKx8PFrfX9tvoWgS5tsx20Jt7s8EbXSUxnxLR8nRZ/ThpfI
         2FPA==
X-Gm-Message-State: APjAAAU8w0xzIqau3Wffmud1RDqUFRrs8it7IYfIZP2FwBm5/cH5PxVa
        oHVSP9mfMJEG9Ame4sxv+es7ufkB+vz7xpBt9m1i0Wpv
X-Google-Smtp-Source: APXvYqxfPI2aOUmjiknkpWVbntJNoNhDjHYpczQqnRIuDtAJMcYAh98McomIpf2IsjOywd69hxicmXyHQnBfoZbEgPw=
X-Received: by 2002:a6b:c38f:: with SMTP id t137mr14717725iof.137.1568605318935;
 Sun, 15 Sep 2019 20:41:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 15 Sep 2019 22:41:47 -0500
Message-ID: <CAH2r5msvi8_+yaoJbEo0a-T46B+L84fV9Rai5p30Ny+RSsyNiA@mail.gmail.com>
Subject: [PATCH][SMB3] Add worker function for smb3 change notify
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d42b480592a362e8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d42b480592a362e8
Content-Type: text/plain; charset="UTF-8"

Fairly trivial



-- 
Thanks,

Steve

--000000000000d42b480592a362e8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-missing-worker-function-for-SMB3-change-not.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-missing-worker-function-for-SMB3-change-not.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0lv3jx10>
X-Attachment-Id: f_k0lv3jx10

RnJvbSA3MjdhYzA2Y2M3MDA3YWZlYTcyOWJmZjA0Y2U0NGY1NDk5NWE4NzQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTUgU2VwIDIwMTkgMjI6Mzg6NTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbWlzc2luZyB3b3JrZXIgZnVuY3Rpb24gZm9yIFNNQjMgY2hhbmdlIG5vdGlmeQoK
U01CMyBjaGFuZ2Ugbm90aWZ5IGlzIGltcG9ydGFudCB0byBhbGxvdyBhcHBsaWNhdGlvbnMgdG8g
d2FpdApvbiBkaXJlY3RvcnkgY2hhbmdlIGV2ZW50cyBvZiBkaWZmZXJlbnQgdHlwZXMgKGUuZy4g
YWRkaW5nCmFuZCBkZWxldGluZyBmaWxlcyBmcm9tIG90aGVycyBzeXN0ZW1zKS4gQWRkIHdvcmtl
ciBmdW5jdGlvbnMKZm9yIHRoaXMuCgpBY2tlZC1ieTogQXVyZWxpZW4gQXB0ZWwgPGFhcHRlbEBz
dXNlLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5jIHwgODUgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvdHJhY2UuaCAgIHwgIDMgKysKIDIgZmls
ZXMgY2hhbmdlZCwgODggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBk
dS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggY2U2NDdjZmRjMDRmLi44NzA2NmYxYWYxMmMg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBA
IC0zMTc1LDYgKzMxNzUsOTEgQEAgU01CMl9nZXRfc3J2X251bShjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJICAodm9pZCAqKikmdW5pcXVlaWQsIE5V
TEwpOwogfQogCisvKgorICogQ0hBTkdFX05PVElGWSBSZXF1ZXN0IGlzIHNlbnQgdG8gZ2V0IG5v
dGlmaWNhdGlvbnMgb24gY2hhbmdlcyB0byBhIGRpcmVjdG9yeQorICogU2VlIE1TLVNNQjIgMi4y
LjM1IGFuZCAyLjIuMzYKKyAqLworCitpbnQKK1NNQjJfbm90aWZ5X2luaXQoY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IHNtYl9ycXN0ICpycXN0LAorCQlzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLCB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQsCisJCXUzMiBjb21wbGV0
aW9uX2ZpbHRlciwgYm9vbCB3YXRjaF90cmVlKQoreworCXN0cnVjdCBzbWIyX2NoYW5nZV9ub3Rp
ZnlfcmVxICpyZXE7CisJc3RydWN0IGt2ZWMgKmlvdiA9IHJxc3QtPnJxX2lvdjsKKwl1bnNpZ25l
ZCBpbnQgdG90YWxfbGVuOworCWludCByYzsKKworCXJjID0gc21iMl9wbGFpbl9yZXFfaW5pdChT
TUIyX0NIQU5HRV9OT1RJRlksIHRjb24sICh2b2lkICoqKSAmcmVxLCAmdG90YWxfbGVuKTsKKwlp
ZiAocmMpCisJCXJldHVybiByYzsKKworCXJlcS0+UGVyc2lzdGVudEZpbGVJZCA9IHBlcnNpc3Rl
bnRfZmlkOworCXJlcS0+Vm9sYXRpbGVGaWxlSWQgPSB2b2xhdGlsZV9maWQ7CisJcmVxLT5PdXRw
dXRCdWZmZXJMZW5ndGggPSBTTUIyX01BWF9CVUZGRVJfU0laRSAtIE1BWF9TTUIyX0hEUl9TSVpF
OworCXJlcS0+Q29tcGxldGlvbkZpbHRlciA9IGNwdV90b19sZTMyKGNvbXBsZXRpb25fZmlsdGVy
KTsKKwlpZiAod2F0Y2hfdHJlZSkKKwkJcmVxLT5GbGFncyA9IGNwdV90b19sZTE2KFNNQjJfV0FU
Q0hfVFJFRSk7CisJZWxzZQorCQlyZXEtPkZsYWdzID0gMDsKKworCWlvdlswXS5pb3ZfYmFzZSA9
IChjaGFyICopcmVxOworCWlvdlswXS5pb3ZfbGVuID0gdG90YWxfbGVuOworCisJcmV0dXJuIDA7
Cit9CisKK2ludAorU01CMl9jaGFuZ2Vfbm90aWZ5KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJCXU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxl
X2ZpZCwgYm9vbCB3YXRjaF90cmVlLAorCQl1MzIgY29tcGxldGlvbl9maWx0ZXIpCit7CisJc3Ry
dWN0IGNpZnNfc2VzICpzZXMgPSB0Y29uLT5zZXM7CisJc3RydWN0IHNtYl9ycXN0IHJxc3Q7CisJ
c3RydWN0IGt2ZWMgaW92WzFdOworCXN0cnVjdCBrdmVjIHJzcF9pb3YgPSB7TlVMTCwgMH07CisJ
aW50IHJlc3BfYnVmdHlwZSA9IENJRlNfTk9fQlVGRkVSOworCWludCBmbGFncyA9IDA7CisJaW50
IHJjID0gMDsKKworCWNpZnNfZGJnKEZZSSwgImNoYW5nZSBub3RpZnlcbiIpOworCWlmICghc2Vz
IHx8ICEoc2VzLT5zZXJ2ZXIpKQorCQlyZXR1cm4gLUVJTzsKKworCWlmIChzbWIzX2VuY3J5cHRp
b25fcmVxdWlyZWQodGNvbikpCisJCWZsYWdzIHw9IENJRlNfVFJBTlNGT1JNX1JFUTsKKworCW1l
bXNldCgmcnFzdCwgMCwgc2l6ZW9mKHN0cnVjdCBzbWJfcnFzdCkpOworCW1lbXNldCgmaW92LCAw
LCBzaXplb2YoaW92KSk7CisJcnFzdC5ycV9pb3YgPSBpb3Y7CisJcnFzdC5ycV9udmVjID0gMTsK
KworCXJjID0gU01CMl9ub3RpZnlfaW5pdCh4aWQsICZycXN0LCB0Y29uLCBwZXJzaXN0ZW50X2Zp
ZCwgdm9sYXRpbGVfZmlkLAorCQkJICAgICAgY29tcGxldGlvbl9maWx0ZXIsIHdhdGNoX3RyZWUp
OworCWlmIChyYykKKwkJZ290byBjbm90aWZ5X2V4aXQ7CisKKwl0cmFjZV9zbWIzX25vdGlmeV9l
bnRlcih4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCwKKwkJCQkodTgp
d2F0Y2hfdHJlZSwgY29tcGxldGlvbl9maWx0ZXIpOworCXJjID0gY2lmc19zZW5kX3JlY3YoeGlk
LCBzZXMsICZycXN0LCAmcmVzcF9idWZ0eXBlLCBmbGFncywgJnJzcF9pb3YpOworCisJaWYgKHJj
ICE9IDApIHsKKwkJY2lmc19zdGF0c19mYWlsX2luYyh0Y29uLCBTTUIyX0NIQU5HRV9OT1RJRllf
SEUpOworCQl0cmFjZV9zbWIzX25vdGlmeV9lcnIoeGlkLCBwZXJzaXN0ZW50X2ZpZCwgdGNvbi0+
dGlkLCBzZXMtPlN1aWQsCisJCQkJKHU4KXdhdGNoX3RyZWUsIGNvbXBsZXRpb25fZmlsdGVyLCBy
Yyk7CisJfSBlbHNlCisJCXRyYWNlX3NtYjNfbm90aWZ5X2RvbmUoeGlkLCBwZXJzaXN0ZW50X2Zp
ZCwgdGNvbi0+dGlkLAorCQkJCXNlcy0+U3VpZCwgKHU4KXdhdGNoX3RyZWUsIGNvbXBsZXRpb25f
ZmlsdGVyKTsKKworIGNub3RpZnlfZXhpdDoKKwlpZiAocnFzdC5ycV9pb3YpCisJCWNpZnNfc21h
bGxfYnVmX3JlbGVhc2UocnFzdC5ycV9pb3ZbMF0uaW92X2Jhc2UpOyAvKiByZXF1ZXN0ICovCisJ
ZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgcnNwX2lvdi5pb3ZfYmFzZSk7CisJcmV0dXJuIHJj
OworfQorCisKKwogLyoKICAqIFRoaXMgaXMgYSBuby1vcCBmb3Igbm93LiBXZSdyZSBub3QgcmVh
bGx5IGludGVyZXN0ZWQgaW4gdGhlIHJlcGx5LCBidXQKICAqIHJhdGhlciBpbiB0aGUgZmFjdCB0
aGF0IHRoZSBzZXJ2ZXIgc2VudCBvbmUgYW5kIHRoYXQgc2VydmVyLT5sc3RycApkaWZmIC0tZ2l0
IGEvZnMvY2lmcy90cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCmluZGV4IGYxMzM5ZjRhMmQwNy4u
ZTdlMzUwYjEzZDZhIDEwMDY0NAotLS0gYS9mcy9jaWZzL3RyYWNlLmgKKysrIGIvZnMvY2lmcy90
cmFjZS5oCkBAIC0yMzUsNiArMjM1LDggQEAgREVGSU5FX0VWRU5UKHNtYjNfaW5mX2VudGVyX2Ns
YXNzLCBzbWIzXyMjbmFtZSwgICAgXAogCiBERUZJTkVfU01CM19JTkZfRU5URVJfRVZFTlQocXVl
cnlfaW5mb19lbnRlcik7CiBERUZJTkVfU01CM19JTkZfRU5URVJfRVZFTlQocXVlcnlfaW5mb19k
b25lKTsKK0RFRklORV9TTUIzX0lORl9FTlRFUl9FVkVOVChub3RpZnlfZW50ZXIpOworREVGSU5F
X1NNQjNfSU5GX0VOVEVSX0VWRU5UKG5vdGlmeV9kb25lKTsKIAogREVDTEFSRV9FVkVOVF9DTEFT
UyhzbWIzX2luZl9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKQEAgLTI4
MSw2ICsyODMsNyBAQCBERUZJTkVfRVZFTlQoc21iM19pbmZfZXJyX2NsYXNzLCBzbWIzXyMjbmFt
ZSwgICAgXAogCiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5UKHF1ZXJ5X2luZm9fZXJyKTsKIERF
RklORV9TTUIzX0lORl9FUlJfRVZFTlQoc2V0X2luZm9fZXJyKTsKK0RFRklORV9TTUIzX0lORl9F
UlJfRVZFTlQobm90aWZ5X2Vycik7CiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5UKGZzY3RsX2Vy
cik7CiAKIERFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19pbmZfY29tcG91bmRfZW50ZXJfY2xhc3Ms
Ci0tIAoyLjIwLjEKCg==
--000000000000d42b480592a362e8--
