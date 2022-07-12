Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D560DC43334
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 05:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGLFef (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 01:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiGLFee (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 01:34:34 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052AD193ED
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 22:34:33 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id 189so6864160vsh.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 22:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LGs9JyoVpvCiq2kVkyuR1T4N2KrkXSFfXc1vKiYlBUw=;
        b=pZjMKJL1y+hW5NBl8ezagz/tDW6wST8LZ6Ly9iVT2VOcjbYSaYUkAfSu6hJr6IZbuk
         ENrx5D+6R480CP6BC9OWUmzG+QX45HB1WZ8Wa9kVh5UTaL4+t1KpNJFcbv9TU2wXz/Z5
         wi3BZdMaQPhI6fdEU5g6cPy5wiJElsPScqmnmFog+Rwmg/FiwKijBQeWnQMFdMIQR97f
         cpelQDlWRDwwg2MCMemv4GacM/xr5lVXjcis+gx+TWTNzsmpUke5UI+BylWhyzQzh/LS
         BHj9iDf5dujYOTrehxe44itVEcwgss5JP85/dw52qDMsqQnvpbBpSrVWN5oyt9agYgO2
         /CAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LGs9JyoVpvCiq2kVkyuR1T4N2KrkXSFfXc1vKiYlBUw=;
        b=yy8uVVK5EOsj1ZGrIJBgzfnNw2Mm+SIWXLaExf/Z6wZW6FwLvYzpM72zZertY0St6q
         RH7LiWJKd1BtZKrJLpjcIop+el7yXW3KSgfgV7B15bV5+VUynJDJayXAMKhI4ksB4qW9
         Dh7sherF1LSRH4cUVptdH4x3O5NabiwkpLTtZR5+uN8u+uYy4nYZXLQAd7E13trgIUJq
         coy4WDE2JAPWMrg/deH/yzVjJNj72TktR6aNEhLhGEkgpFXhw55p5b8AOoZqjLbW+DHg
         UMMuOSz6dWrTJUIA48a8NZtSFbtQk5QGbTsBvRcwmGHLfVgv7IzkUDqy89r4uCBpG8Dh
         zeEQ==
X-Gm-Message-State: AJIora+BeLkx1PhFwy75+9PNrNTHazog1ap51GlpoDQ1ZPpnuHllzYsd
        nRexRJDLOKp1cYOJ4LIRHO9be5IGWIdY1xQkfPOFVXMW+pE4vw==
X-Google-Smtp-Source: AGRyM1tuc1bOmS5NfSmyHLMQgHxXONpP1zjOIaaUQg0QsSlhadPuiPtNsxdBPtW0lYod8X1A8tu8Dpzijurv3Fq4ijk=
X-Received: by 2002:a67:6d86:0:b0:357:3d99:ec77 with SMTP id
 i128-20020a676d86000000b003573d99ec77mr6931141vsc.6.1657604071919; Mon, 11
 Jul 2022 22:34:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Jul 2022 00:34:21 -0500
Message-ID: <CAH2r5mtuN-yswT5VTbNPzj02fwiHYOCe2eR8mcgRgRE8Qpkjgw@mail.gmail.com>
Subject: [PATCH][SMB3] workaround negprot bug in some Samba servers by
 changing order of negcontexts sent by Linux kernel client
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Julian Sikorski <belegdol@gmail.com>,
        Brian Caine <brian.d.caine@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000e2ac8c05e39505f1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e2ac8c05e39505f1
Content-Type: text/plain; charset="UTF-8"

Starting with 5.18.8 (and 5.19-rc4) mount can now fail to older Samba
servers due to a server bug handling padding at the end of the last
negotiate context (negotiate contexts typically round up to 8 byte
lengths by adding padding if needed). This server bug can be avoided
by switching the order of negotiate contexts, placing a negotiate
context at the end that does not require padding (prior to the recent
netname context fix this was the case on the client).

Fixes: 73130a7b1ac9 ("smb3: fix empty netname context on secondary channels")

See attached fix to cifs.ko
-- 
Thanks,

Steve

--000000000000e2ac8c05e39505f1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-workaround-negprot-bug-in-some-Samba-servers.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-workaround-negprot-bug-in-some-Samba-servers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l5hqgxgu0>
X-Attachment-Id: f_l5hqgxgu0

RnJvbSBhOGQ4NTMyZTRjMzM1ZjBhMzFkZDIxM2FiZTRlMzE2ODJmMzQ2NDdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTIgSnVsIDIwMjIgMDA6MTE6NDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiB3b3JrYXJvdW5kIG5lZ3Byb3QgYnVnIGluIHNvbWUgU2FtYmEgc2VydmVycwoKTW91bnQg
Y2FuIG5vdyBmYWlsIHRvIG9sZGVyIFNhbWJhIHNlcnZlcnMgZHVlIHRvIGEgc2VydmVyCmJ1ZyBo
YW5kbGluZyBwYWRkaW5nIGF0IHRoZSBlbmQgb2YgdGhlIGxhc3QgbmVnb3RpYXRlCmNvbnRleHRz
IChuZWdvdGlhdGUgY29udGV4dHMgdHlwaWNhbGx5IHJvdW5kIHVwIHRvIDggYnl0ZQpsZW5ndGhz
IGJ5IGFkZGluZyBwYWRkaW5nIGlmIG5lZWRlZCkuIFRoaXMgc2VydmVyIGJ1ZyBjYW4KYmUgYXZv
aWRlZCBieSBzd2l0Y2hpbmcgdGhlIG9yZGVyIG9mIG5lZ290aWF0ZSBjb250ZXh0cywKcGxhY2lu
ZyBhIG5lZ290aWF0ZSBjb250ZXh0IGF0IHRoZSBlbmQgdGhhdCBkb2VzIG5vdApyZXF1aXJlIHBh
ZGRpbmcgKHByaW9yIHRvIHRoZSByZWNlbnQgbmV0bmFtZSBjb250ZXh0IGZpeAp0aGlzIHdhcyB0
aGUgY2FzZSBvbiB0aGUgY2xpZW50KS4KCkZpeGVzOiA3MzEzMGE3YjFhYzkgKCJzbWIzOiBmaXgg
ZW1wdHkgbmV0bmFtZSBjb250ZXh0IG9uIHNlY29uZGFyeSBjaGFubmVscyIpClJlcG9ydGVkLWJ5
OiBKdWxpYW4gU2lrb3Jza2kgPGJlbGVnZG9sQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5j
IHwgMTMgKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21i
MnBkdS5jCmluZGV4IDEyYjRkZGRhZWRiMC4uYzcwNWRlMzJlMjI1IDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtNTcxLDEwICs1NzEsNiBA
QCBhc3NlbWJsZV9uZWdfY29udGV4dHMoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSAqcmVxLAog
CSp0b3RhbF9sZW4gKz0gY3R4dF9sZW47CiAJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwogCi0JYnVp
bGRfcG9zaXhfY3R4dCgoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQp
OwotCSp0b3RhbF9sZW4gKz0gc2l6ZW9mKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsK
LQlwbmVnX2N0eHQgKz0gc2l6ZW9mKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKLQog
CS8qCiAJICogc2Vjb25kYXJ5IGNoYW5uZWxzIGRvbid0IGhhdmUgdGhlIGhvc3RuYW1lIGZpZWxk
IHBvcHVsYXRlZAogCSAqIHVzZSB0aGUgaG9zdG5hbWUgZmllbGQgaW4gdGhlIHByaW1hcnkgY2hh
bm5lbCBpbnN0ZWFkCkBAIC01ODYsOSArNTgyLDE0IEBAIGFzc2VtYmxlX25lZ19jb250ZXh0cyhz
dHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxICpyZXEsCiAJCQkJCSAgICAgIGhvc3RuYW1lKTsKIAkJ
KnRvdGFsX2xlbiArPSBjdHh0X2xlbjsKIAkJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwotCQluZWdf
Y29udGV4dF9jb3VudCA9IDQ7Ci0JfSBlbHNlIC8qIHNlY29uZCBjaGFubmVscyBkbyBub3QgaGF2
ZSBhIGhvc3RuYW1lICovCiAJCW5lZ19jb250ZXh0X2NvdW50ID0gMzsKKwl9IGVsc2UKKwkJbmVn
X2NvbnRleHRfY291bnQgPSAyOworCisJYnVpbGRfcG9zaXhfY3R4dCgoc3RydWN0IHNtYjJfcG9z
aXhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQpOworCSp0b3RhbF9sZW4gKz0gc2l6ZW9mKHN0cnVj
dCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKKwlwbmVnX2N0eHQgKz0gc2l6ZW9mKHN0cnVjdCBz
bWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKKwluZWdfY29udGV4dF9jb3VudCsrOwogCiAJaWYgKHNl
cnZlci0+Y29tcHJlc3NfYWxnb3JpdGhtKSB7CiAJCWJ1aWxkX2NvbXByZXNzaW9uX2N0eHQoKHN0
cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0ICopCi0tIAoyLjM0LjEK
Cg==
--000000000000e2ac8c05e39505f1--
