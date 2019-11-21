Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415B0C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 23:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C7B220674
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 23:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fguTswre"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfKUX35 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 18:29:57 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:38924 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfKUX35 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 18:29:57 -0500
Received: by mail-io1-f41.google.com with SMTP id k1so5594873ioj.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 15:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BGK3nktBWdQF19efdzCopVrZpMUHW7hGUEQVypCgK4Y=;
        b=fguTswreFq+OmTH4/PZGTIDWQbWIJDgcc5G4IG3xPF6Ca2SXTJwdp8Y+eY93gu/Og4
         5Bk/B4SZKupfVDIzCvTencm81hBs9pfFBQHhgr4Aw1fTrfI3bv9xHfZPhmTQW0eV9Fev
         A0xO/eo7o40K8x3G65o7MGvf651xinzlbDgw6ojDneC9YJaqvrX5bfh/C2rGkcymuHny
         gVlSblAfch2fHKwYRoETsHA4axM3y04uLmNtQ4NkyR8TMfRfyPENmjCZX5o8ZsJeIUWm
         73LlQ6E22BdGwZmRJNFHviTi+sg25YJ+NwzFigcVsUBX/f0p/8rLxk9DaOunQsHdr6PH
         SNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BGK3nktBWdQF19efdzCopVrZpMUHW7hGUEQVypCgK4Y=;
        b=Lh3N7yLRtreJYFaRfXcAzLgpAZd/ZlSmwIlUX0Wu9v7GYdCGy3rGiDyynU7rO12p2j
         76wQxceUIm4X78zkXwwd0+tJFrGymSw9F9Ocp5ldztTiMLemqSei+pQoxLOn7UFOinK+
         SBVQp4BKeIfNjEgzWSQF5JdUK+9UUY6eQep+fj+Yc0Ilm8VRPHuMsDbN3BxXj92vL9iK
         m7L6yJBMrLf6iDIAGWezvj7Bgya6WGBBFpE8M+qMWm5pXx80WmM3GhKFLbp1Fz4SQIKG
         2SkQcBFU9arvcbgbZTh4GJCWz4dCmU5gqvcRCBNvTz4+rqj7ExCU6Oa8J2uthaPDH11V
         CFkQ==
X-Gm-Message-State: APjAAAWjv60/O7sQjfbqfzOEHZeFowrB8OCE6JdrDZrqvB1XA/I3nixM
        HXLEa+f3o6oGiHtPVviaaMo6RsJfJlh9J7CnZgM=
X-Google-Smtp-Source: APXvYqxUbW1uqFJtrPlooulAB0eRHT9CqB+B68eJmz8NXO1KIhEkTWTuRZAyoHqV/DlRGbV12K0xIDq3Uyjgb0hNiAw=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr9617025iom.5.1574378996147;
 Thu, 21 Nov 2019 15:29:56 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Nov 2019 17:29:45 -0600
Message-ID: <CAH2r5munzGbsOs-WGxgo+023_becDWoSVeXzVNJB25K6mvtRLw@mail.gmail.com>
Subject: [PATCH][SMB3] move num_waiters and in_send counters from
 CONFIG_CIFS_STAT2 to default
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000cf25c30597e3ac77"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cf25c30597e3ac77
Content-Type: text/plain; charset="UTF-8"

Any objections? (Was needed for one of Aurelien's patches)

-- 
Thanks,

Steve

--000000000000cf25c30597e3ac77
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-dump-in_send-and-num_waiters-stats-counters-by-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-dump-in_send-and-num_waiters-stats-counters-by-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k39clczs0>
X-Attachment-Id: f_k39clczs0

RnJvbSBkYWQ0NjM5YmUyZjQzMGY2ZGRmMDNiNWU5YmNkY2I0NjE5Y2Q1NDA3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjEgTm92IDIwMTkgMTc6MjY6MzUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkdW1wIGluX3NlbmQgYW5kIG51bV93YWl0ZXJzIHN0YXRzIGNvdW50ZXJzIGJ5IGRlZmF1
bHQKCk51bWJlciBvZiByZXF1ZXN0cyBpbl9zZW5kIGFuZCB0aGUgbnVtYmVyIG9mIHdhaXRlcnMg
b24gc2VuZFJlY3YKYXJlIHVzZWZ1bCBjb3VudGVycyBpbiB2YXJpb3VzIGNhc2VzLCBtb3ZlIHRo
ZW0gZnJvbQpDT05GSUdfQ0lGU19TVEFUUzIgdG8gYmUgb24gYnkgZGVmYXVsdCBlc3BlY2lhbGx5
IHdpdGggbXVsdGljaGFubmVsCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2RlYnVnLmMgfCAgMyArLS0KIGZzL2Np
ZnMvY2lmc2dsb2IuaCAgIHwgMjIgKysrLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvY2lmc19kZWJ1Zy5jIGIvZnMvY2lmcy9jaWZzX2RlYnVnLmMKaW5kZXggYzJkZDA3OTAzZDU2
Li42NDEyMWYzNGFjZDAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCisrKyBiL2Zz
L2NpZnMvY2lmc19kZWJ1Zy5jCkBAIC0zODYsMTEgKzM4NiwxMCBAQCBzdGF0aWMgaW50IGNpZnNf
ZGVidWdfZGF0YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogCQkJCSAg
IHNlcnZlci0+c3J2X2NvdW50LAogCQkJCSAgIHNlcnZlci0+c2VjX21vZGUsIGluX2ZsaWdodChz
ZXJ2ZXIpKTsKIAotI2lmZGVmIENPTkZJR19DSUZTX1NUQVRTMgogCQkJc2VxX3ByaW50ZihtLCAi
IEluIFNlbmQ6ICVkIEluIE1heFJlcSBXYWl0OiAlZCIsCiAJCQkJYXRvbWljX3JlYWQoJnNlcnZl
ci0+aW5fc2VuZCksCiAJCQkJYXRvbWljX3JlYWQoJnNlcnZlci0+bnVtX3dhaXRlcnMpKTsKLSNl
bmRpZgorCiAJCQkvKiBkdW1wIHNlc3Npb24gaWQgaGVscGZ1bCBmb3IgdXNlIHdpdGggbmV0d29y
ayB0cmFjZSAqLwogCQkJc2VxX3ByaW50ZihtLCAiIFNlc3Npb25JZDogMHglbGx4Iiwgc2VzLT5T
dWlkKTsKIAkJCWlmIChzZXMtPnNlc3Npb25fZmxhZ3MgJiBTTUIyX1NFU1NJT05fRkxBR19FTkNS
WVBUX0RBVEEpCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNn
bG9iLmgKaW5kZXggMmZjM2Q3NzQ2M2QzLi5kMzRhNGVkOGM1N2QgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTc0MywxMiArNzQzLDEy
IEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gewogCS8qIFRvdGFsIHNpemUgb2YgdGhpcyBQRFUu
IE9ubHkgdmFsaWQgZnJvbSBjaWZzX2RlbXVsdGlwbGV4X3RocmVhZCAqLwogCXVuc2lnbmVkIGlu
dCBwZHVfc2l6ZTsKIAl1bnNpZ25lZCBpbnQgdG90YWxfcmVhZDsgLyogdG90YWwgYW1vdW50IG9m
IGRhdGEgcmVhZCBpbiB0aGlzIHBhc3MgKi8KKwlhdG9taWNfdCBpbl9zZW5kOyAvKiByZXF1ZXN0
cyB0cnlpbmcgdG8gc2VuZCAqLworCWF0b21pY190IG51bV93YWl0ZXJzOyAgIC8qIGJsb2NrZWQg
d2FpdGluZyB0byBnZXQgaW4gc2VuZHJlY3YgKi8KICNpZmRlZiBDT05GSUdfQ0lGU19GU0NBQ0hF
CiAJc3RydWN0IGZzY2FjaGVfY29va2llICAgKmZzY2FjaGU7IC8qIGNsaWVudCBpbmRleCBjYWNo
ZSBjb29raWUgKi8KICNlbmRpZgogI2lmZGVmIENPTkZJR19DSUZTX1NUQVRTMgotCWF0b21pY190
IGluX3NlbmQ7IC8qIHJlcXVlc3RzIHRyeWluZyB0byBzZW5kICovCi0JYXRvbWljX3QgbnVtX3dh
aXRlcnM7ICAgLyogYmxvY2tlZCB3YWl0aW5nIHRvIGdldCBpbiBzZW5kcmVjdiAqLwogCWF0b21p
Y190IG51bV9jbWRzW05VTUJFUl9PRl9TTUIyX0NPTU1BTkRTXTsgLyogdG90YWwgcmVxdWVzdHMg
YnkgY21kICovCiAJYXRvbWljX3Qgc21iMnNsb3djbWRbTlVNQkVSX09GX1NNQjJfQ09NTUFORFNd
OyAvKiBjb3VudCByZXNwcyA+IDEgc2VjICovCiAJX191NjQgdGltZV9wZXJfY21kW05VTUJFUl9P
Rl9TTUIyX0NPTU1BTkRTXTsgLyogdG90YWwgdGltZSBwZXIgY21kICovCkBAIC0xNjA2LDggKzE2
MDYsNiBAQCBzdHJ1Y3QgY2xvc2VfY2FuY2VsbGVkX29wZW4gewogCiAvKglNYWtlIGNvZGUgaW4g
dHJhbnNwb3J0LmMgYSBsaXR0bGUgY2xlYW5lciBieSBtb3ZpbmcKIAl1cGRhdGUgb2Ygb3B0aW9u
YWwgc3RhdHMgaW50byBmdW5jdGlvbiBiZWxvdyAqLwotI2lmZGVmIENPTkZJR19DSUZTX1NUQVRT
MgotCiBzdGF0aWMgaW5saW5lIHZvaWQgY2lmc19pbl9zZW5kX2luYyhzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIpCiB7CiAJYXRvbWljX2luYygmc2VydmVyLT5pbl9zZW5kKTsKQEAgLTE2
MjgsMjYgKzE2MjYsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIGNpZnNfbnVtX3dhaXRlcnNfZGVj
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAlhdG9taWNfZGVjKCZzZXJ2ZXItPm51
bV93YWl0ZXJzKTsKIH0KIAorI2lmZGVmIENPTkZJR19DSUZTX1NUQVRTMgogc3RhdGljIGlubGlu
ZSB2b2lkIGNpZnNfc2F2ZV93aGVuX3NlbnQoc3RydWN0IG1pZF9xX2VudHJ5ICptaWQpCiB7CiAJ
bWlkLT53aGVuX3NlbnQgPSBqaWZmaWVzOwogfQogI2Vsc2UKLXN0YXRpYyBpbmxpbmUgdm9pZCBj
aWZzX2luX3NlbmRfaW5jKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKLXsKLX0KLXN0
YXRpYyBpbmxpbmUgdm9pZCBjaWZzX2luX3NlbmRfZGVjKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlcikKLXsKLX0KLQotc3RhdGljIGlubGluZSB2b2lkIGNpZnNfbnVtX3dhaXRlcnNfaW5j
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKLXsKLX0KLQotc3RhdGljIGlubGluZSB2
b2lkIGNpZnNfbnVtX3dhaXRlcnNfZGVjKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikK
LXsKLX0KLQogc3RhdGljIGlubGluZSB2b2lkIGNpZnNfc2F2ZV93aGVuX3NlbnQoc3RydWN0IG1p
ZF9xX2VudHJ5ICptaWQpCiB7CiB9Ci0tIAoyLjIzLjAKCg==
--000000000000cf25c30597e3ac77--
