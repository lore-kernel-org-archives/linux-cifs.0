Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1E1C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 04:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04FC3207FD
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 04:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6H2AJt2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406351AbfIXEvB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 00:51:01 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:35696 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405468AbfIXEvB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 00:51:01 -0400
Received: by mail-io1-f49.google.com with SMTP id q10so1252454iop.2
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 21:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=K9NiVfbpskhHYlk5SvYE6t0BJTl3U6RG02ZbnZDdNqI=;
        b=p6H2AJt2hhtPqCOcUXnRTOSu6p/COkm3DsCen+FgVZ+7XjNIoTipJwA23xPXI6uv+M
         bQEWmVogncfnS5fQVw6rdXqT5GucU0IKXGB/WSPiXBY5RhJH8T/IUPrQSFQf1fU6ZSRx
         yKJAljGzgWDGAPRku6hTGHw0mIXc9v5ljhdnW4Ovqguxz1HeVOAH1sgRmy13NA1i2zcq
         dJNAXBILPO/9rh9R/V3saTKaL8PREChqaq2e1PeLwpwvLNPl1ypGISzzOHlWpwvWgvJR
         sVVgEycW1O6aLX5ynrZk8IRSa+4qVOpEsZhwjiFl2bpNk0qrIBoPKgHAiw3dgKVqCrXd
         Lfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=K9NiVfbpskhHYlk5SvYE6t0BJTl3U6RG02ZbnZDdNqI=;
        b=lbIXzSwzlSA9YoEYcTBrE64ElMt13vO3+FDXjn0SjwMRckRSoOJHbJIhW5uaVOOHYP
         jrCba6f4sEb+qCNtJBvOv5Psn/Bg3/1CtAxVHYV1mvQcM7RCi2rFL46VHkvFFbEiEEOX
         RABX2G+MznYt+N/Z2hsCXosZWo9fEuw5ncggi/qQLk1Uym4yjsl+CGFkTLWATrjqwg28
         V69ytKKXZl1NIKt/DYSlLAEEdWLiu2HnfCLZy++PSpn65pTs187iAO3t1tqa8KuH6msd
         fuOzpxpd4+n9Y60hu+tRTpFU5aCfZkilWvXpQsIvguQzJLxiCr+lV6/1tO1Z8nu/jPu9
         GFRg==
X-Gm-Message-State: APjAAAV+py5FQddoepr+KX4BkmRrXJOYd7SFQeqjKradtTgicgfWHRqP
        OigR2pWEFe4vjWc5AcYscphHDv4iVwNmDVCha9WXAkdE
X-Google-Smtp-Source: APXvYqwEKI0jfubpz/4z9udAQj78PIDjakYd9A0NPHf2SKMscMZ+zHBbwsHSJKjBp7GZ7bHIYtSdbQguerf0/zkHlJY=
X-Received: by 2002:a02:608:: with SMTP id 8mr1623916jav.88.1569300658192;
 Mon, 23 Sep 2019 21:50:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 23:50:46 -0500
Message-ID: <CAH2r5mvfb3nkdz8r8sAUXGJkx678XZkt4dn=4xiuq0UD2vxFrw@mail.gmail.com>
Subject: [PATCH] smbinfo dump encryption keys for using wireshark
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000047a2540593454896"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000047a2540593454896
Content-Type: text/plain; charset="UTF-8"

Updated with feedback from Aurelien and Pavel



-- 
Thanks,

Steve

--00000000000047a2540593454896
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbinfo-print-the-security-information-needed-to-dec.patch"
Content-Disposition: attachment; 
	filename="0001-smbinfo-print-the-security-information-needed-to-dec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0xd33510>
X-Attachment-Id: f_k0xd33510

RnJvbSA2YmY0MGZkMTQ2MDQ4OWE2NmEzMWI2ZmI0M2JjNDY2MWM4ZGM1OTdlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTkgU2VwIDIwMTkgMDQ6MjE6MTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJpbmZvOiBwcmludCB0aGUgc2VjdXJpdHkgaW5mb3JtYXRpb24gbmVlZGVkIHRvIGRlY3J5cHQK
IHdpcmVzaGFyayB0cmFjZQoKQ0NNIGVuY3J5cHRpb24KU2Vzc2lvbiBJZDogICBlMiAzZSBlYSBh
ZSAwMCAwMCAwMCAwMApTZXNzaW9uIEtleTogIDY1IDdlIDBlIGQ1IDNjIDA2IDVhIDA2IDUwIGEz
IGVmIDk2IGMxIDY0IDNkIDFmClNlcnZlciBFbmNyeXB0aW9uIEtleTogIDVlIDQyIGE3IGI1IDU3
IDc1IGQ2IDU2IDRhIDVkIDMzIDk3IGU2IDQ1IDA3IDc2ClNlcnZlciBEZWNyeXB0aW9uIEtleTog
IDFmIDY0IGRiIGEzIDBmIDI0IGUzIDRkIGI2IDMxIDAwIGFiIDlhIGFmIDIyIDQ3CgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogc21iaW5m
by5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA1MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvc21iaW5mby5jIGIvc21iaW5mby5jCmluZGV4IGY5ZGU3ZmQuLmM5NDcyZTkg
MTAwNjQ0Ci0tLSBhL3NtYmluZm8uYworKysgYi9zbWJpbmZvLmMKQEAgLTU0LDcgKzU0LDE3IEBA
IHN0cnVjdCBzbWJfcXVlcnlfaW5mbyB7CiAJLyogY2hhciBidWZmZXJbXTsgKi8KIH0gX19wYWNr
ZWQ7CiAKKyNkZWZpbmUgU01CM19TSUdOX0tFWV9TSVpFIDE2CitzdHJ1Y3Qgc21iM19rZXlfZGVi
dWdfaW5mbyB7CisJdWludDY0X3QgU3VpZDsKKwl1aW50MTZfdCBjaXBoZXJfdHlwZTsKKwl1aW50
OF90IGF1dGhfa2V5WzE2XTsgLyogU01CMl9OVExNVjJfU0VTU0tFWV9TSVpFICovCisJdWludDhf
dAlzbWIzZW5jcnlwdGlvbmtleVtTTUIzX1NJR05fS0VZX1NJWkVdOworCXVpbnQ4X3QJc21iM2Rl
Y3J5cHRpb25rZXlbU01CM19TSUdOX0tFWV9TSVpFXTsKK30gX19hdHRyaWJ1dGVfXygocGFja2Vk
KSk7CisKICNkZWZpbmUgQ0lGU19RVUVSWV9JTkZPIF9JT1dSKENJRlNfSU9DVExfTUFHSUMsIDcs
IHN0cnVjdCBzbWJfcXVlcnlfaW5mbykKKyNkZWZpbmUgQ0lGU19EVU1QX0tFWSBfSU9XUihDSUZT
X0lPQ1RMX01BR0lDLCA4LCBzdHJ1Y3Qgc21iM19rZXlfZGVidWdfaW5mbykKICNkZWZpbmUgSU5Q
VVRfQlVGRkVSX0xFTkdUSCAxNjM4NAogCiBpbnQgdmVyYm9zZTsKQEAgLTkyLDcgKzEwMiw5IEBA
IHVzYWdlKGNoYXIgKm5hbWUpCiAJCSIgIHF1b3RhOlxuIgogCQkiICAgICAgUHJpbnRzIHRoZSBx
dW90YSBmb3IgYSBjaWZzIGZpbGUuXG4iCiAJCSIgIHNlY2Rlc2M6XG4iCi0JCSIgICAgICBQcmlu
dHMgdGhlIHNlY3VyaXR5IGRlc2NyaXB0b3IgZm9yIGEgY2lmcyBmaWxlLlxuIiwKKwkJIiAgICAg
IFByaW50cyB0aGUgc2VjdXJpdHkgZGVzY3JpcHRvciBmb3IgYSBjaWZzIGZpbGUuXG4iCisJCSIg
IGtleXM6XG4iCisJCSIgICAgICBQcmludHMgdGhlIGRlY3J5cHRpb24gaW5mb3JtYXRpb24gbmVl
ZGVkIHRvIHZpZXcgZW5jcnlwdGVkIG5ldHdvcmsgdHJhY2VzLlxuIiwKIAkJbmFtZSk7CiAJZXhp
dCgxKTsKIH0KQEAgLTEwMTUsNiArMTAyNyw0MyBAQCBzdGF0aWMgdm9pZCBwcmludF9zbmFwc2hv
dHMoc3RydWN0IHNtYl9zbmFwc2hvdF9hcnJheSAqcHNuYXApCiAJcHJpbnRmKCJcbiIpOwogfQog
CitzdGF0aWMgdm9pZAorZHVtcF9rZXlzKGludCBmKQoreworCXN0cnVjdCBzbWIzX2tleV9kZWJ1
Z19pbmZvIGtleXNfaW5mbzsKKwl1aW50OF90ICpwc2Vzc19pZDsKKworCWlmIChpb2N0bChmLCBD
SUZTX0RVTVBfS0VZLCAma2V5c19pbmZvKSA8IDApIHsKKwkJZnByaW50ZihzdGRlcnIsICJRdWVy
eWluZyBrZXlzIGluZm9ybWF0aW9uIGZhaWxlZCB3aXRoICVzXG4iLCBzdHJlcnJvcihlcnJubykp
OworCQlleGl0KDEpOworCX0KKworCWlmIChrZXlzX2luZm8uY2lwaGVyX3R5cGUgPT0gMSkKKwkJ
cHJpbnRmKCJDQ00gZW5jcnlwdGlvbiIpOworCWVsc2UgaWYgKGtleXNfaW5mby5jaXBoZXJfdHlw
ZSA9PSAyKQorCQlwcmludGYoIkdDTSBlbmNyeXB0aW9uIik7CisJZWxzZSBpZiAoa2V5c19pbmZv
LmNpcGhlcl90eXBlID09IDApCisJCXByaW50ZigiU01CMy4wIENDTSBlbmNyeXB0aW9uIik7CisJ
ZWxzZQorCQlwcmludGYoInVua25vd24gZW5jcnlwdGlvbiB0eXBlIik7CisKKwlwcmludGYoIlxu
U2Vzc2lvbiBJZDogICIpOworCXBzZXNzX2lkID0gKHVpbnQ4X3QgKikma2V5c19pbmZvLlN1aWQ7
CisJZm9yIChpbnQgaSA9IDA7IGkgPCA4OyBpKyspCisJCXByaW50ZigiICUwMngiLCBwc2Vzc19p
ZFtpXSk7CisKKwlwcmludGYoIlxuU2Vzc2lvbiBLZXk6ICIpOworCWZvciAoaW50IGkgPSAwOyBp
IDwgMTY7IGkrKykKKwkJcHJpbnRmKCIgJTAyeCIsIGtleXNfaW5mby5hdXRoX2tleVtpXSk7CisJ
cHJpbnRmKCJcblNlcnZlciBFbmNyeXB0aW9uIEtleTogIik7CisJZm9yIChpbnQgaSA9IDA7IGkg
PCBTTUIzX1NJR05fS0VZX1NJWkU7IGkrKykKKwkJcHJpbnRmKCIgJTAyeCIsIGtleXNfaW5mby5z
bWIzZW5jcnlwdGlvbmtleVtpXSk7CisJcHJpbnRmKCJcblNlcnZlciBEZWNyeXB0aW9uIEtleTog
Iik7CisJZm9yIChpbnQgaSA9IDA7IGkgPCBTTUIzX1NJR05fS0VZX1NJWkU7IGkrKykKKwkJcHJp
bnRmKCIgJTAyeCIsIGtleXNfaW5mby5zbWIzZGVjcnlwdGlvbmtleVtpXSk7CisJcHJpbnRmKCJc
biIpOworfQorCiAjZGVmaW5lIENJRlNfRU5VTUVSQVRFX1NOQVBTSE9UUyBfSU9SKENJRlNfSU9D
VExfTUFHSUMsIDYsIHN0cnVjdCBzbWJfc25hcHNob3RfYXJyYXkpCiAKICNkZWZpbmUgTUlOX1NO
QVBTSE9UX0FSUkFZX1NJWkUgMTYgLyogU2VlIE1TLVNNQjIgc2VjdGlvbiAzLjMuNS4xNS4xICov
CkBAIC0xMTI0LDYgKzExNzMsOCBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQog
CQlxdW90YShmKTsKIAllbHNlIGlmICghc3RyY21wKGFyZ3Zbb3B0aW5kXSwgInNlY2Rlc2MiKSkK
IAkJc2VjZGVzYyhmKTsKKwllbHNlIGlmICghc3RyY21wKGFyZ3Zbb3B0aW5kXSwgImtleXMiKSkK
KwkJZHVtcF9rZXlzKGYpOwogCWVsc2UgewogCQlmcHJpbnRmKHN0ZGVyciwgIlVua25vd24gY29t
bWFuZCAlc1xuIiwgYXJndltvcHRpbmRdKTsKIAkJZXhpdCgxKTsKLS0gCjIuMjAuMQoK
--00000000000047a2540593454896--
