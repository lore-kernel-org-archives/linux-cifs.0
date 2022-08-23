Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0000C32774
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 07:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiHWHmz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 03:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbiHWHmy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 03:42:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794094AD4B
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 00:42:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gb36so25695021ejc.10
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 00:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=uJhd1oybMv+ij0w4h+RApiv7TGpcybuCij1a8hf1bgI=;
        b=cEA3N4nY5BHX4RTWrl0zOqflEhaIZ8/+iOc5ZnUqXh8EyYU5a4sTBN2D+1cLlnpGoO
         a4VjgxAnccItoeow/TC8URuaHgDWv2IsCKLM/ZJ2vgeH046BuMz8W55XTTppZLmwwZJ9
         d0zG+0dFMcnyc/LdR0Eyz1ftFMAnfzgLlqqG6O6aGrFjKO/2EOt8kWwJ/dKTeDCVX4C8
         B6qs9YhQtTz41VuIFJDsN4JuKljm2rDdgQbx/S5msNcKB85yQnJ3oERvIGy2bSbEpgQa
         lv5srcRevpXb8ayoKIPxIHu/62eqe5sGUg6CD0JNirrOtV5kZMtscfl4rdRuZX6pwj7p
         Wm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=uJhd1oybMv+ij0w4h+RApiv7TGpcybuCij1a8hf1bgI=;
        b=Lvl1Cq7APg8cFbqyPtrpKv+5fgtZ3xONTMHnGr7s6sPaErhanUK03ySQa/RzC2p2Uw
         F4KpjXQnRrFyvbpBtYcw7HRaTXY7cuALR+f1v2+Efk3HaKWS58WmGrbrdViFeQ55+m1K
         TWaNJBHg2mBUw13jj8/RATOyL3xZEwfDmJBPrYnjbqHvzIZ8SqbIT35BVQqjHyTcDiNV
         dmT8DWrWzxK3HpEvom5xxfuEGu4oen1nXOIwXMUPkMUxKW4fziJtvXA4QHmtFAHINz3m
         tHyPeIrQ980Ke5LV/rTAfqFXtjbnRPgOrMNAB7/oRIGFQLaxnL6b8JPRv9s6L3WbMEof
         yPRQ==
X-Gm-Message-State: ACgBeo0RqAfJz6DRBwnBFpNo9MSebN0FDEerCRCDgEzFj8eBQBuEuyPt
        N86FA9T1nA2ps5OPnkPmhXXy7jqFhn2JMXyPaN2iBjHlWRDJKQ==
X-Google-Smtp-Source: AA6agR6o8BJ7MVsKPGvrdbf1Ku9+8d6RAuD14o+OajFHujIH60OLFIIEA/UeJksZrHF5sQh1P4J6HtoIFtMz2128YNA=
X-Received: by 2002:a17:906:4790:b0:73d:7d7a:94aa with SMTP id
 cw16-20020a170906479000b0073d7d7a94aamr6237880ejc.333.1661240571588; Tue, 23
 Aug 2022 00:42:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Aug 2022 02:42:40 -0500
Message-ID: <CAH2r5msk4Jc1HM=3ynEAYOAYYZZtM90Z9_c4myDeDbrQ3ecmCQ@mail.gmail.com>
Subject: [PATCH][SMB3] skip extra NULL byte in filenames
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="0000000000002837b605e6e3b67a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002837b605e6e3b67a
Content-Type: text/plain; charset="UTF-8"

Any comments on Paulo's recent patch below?

    Since commit:
     cifs: alloc_path_with_tree_prefix: do not append sep. if the path is empty
    alloc_path_with_tree_prefix() function was no longer including the
    trailing separator when @path is empty, although @out_len was still
    assuming a path separator thus adding an extra byte to the final
    filename.

    This has caused mount issues in some Synology servers due to the extra
    NULL byte in filenames when sending SMB2_CREATE requests with
    SMB2_FLAGS_DFS_OPERATIONS set.

    Fix this by checking if @path is not empty and then add extra byte for
    separator.  Also, do not include any trailing NULL bytes in filename
    as MS-SMB2 requires it to be 8-byte aligned and not NULL terminated.

--
Thanks,

Steve

--0000000000002837b605e6e3b67a
Content-Type: application/x-patch; name="git.cjr.nz.patch"
Content-Disposition: attachment; filename="git.cjr.nz.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l75vh09b0>
X-Attachment-Id: f_l75vh09b0

RnJvbSAzMjk3Y2RhZjk4NmZiMTZlMzdiZmFkMjY3MDIyNmMxMGMzM2E1NjM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogRnJp
LCAxOSBBdWcgMjAyMiAxNzowMDoxOSAtMDMwMApTdWJqZWN0OiBjaWZzOiBza2lwIGV4dHJhIE5V
TEwgYnl0ZSBpbiBmaWxlbmFtZXMKCkFmdGVyIDdlYWNiYTNiMDBhMyAoImNpZnM6IGFsbG9jX3Bh
dGhfd2l0aF90cmVlX3ByZWZpeDogZG8gbm90IGFwcGVuZCBzZXAuIGlmIHRoZSBwYXRoIGlzIGVt
cHR5IiksCmFsbG9jX3BhdGhfd2l0aF90cmVlX3ByZWZpeCgpIGZ1bmN0aW9uIHdhcyBubyBsb25n
ZXIgaW5jbHVkaW5nIHRoZQp0cmFpbGluZyBzZXBhcmF0b3Igd2hlbiBAcGF0aCBpcyBlbXB0eSwg
YWx0aG91Z2ggQG91dF9sZW4gd2FzIHN0aWxsCmFzc3VtaW5nIGEgcGF0aCBzZXBhcmF0b3IgdGh1
cyBhZGRpbmcgYW4gZXh0cmEgYnl0ZSB0byB0aGUgZmluYWwKZmlsZW5hbWUuCgpUaGlzIGhhcyBj
YXVzZWQgbW91bnQgaXNzdWVzIGluIHNvbWUgU3lub2xvZ3kgc2VydmVycyBkdWUgdG8gdGhlIGV4
dHJhCk5VTEwgYnl0ZSBpbiBmaWxlbmFtZXMgd2hlbiBzZW5kaW5nIFNNQjJfQ1JFQVRFIHJlcXVl
c3RzIHdpdGgKU01CMl9GTEFHU19ERlNfT1BFUkFUSU9OUyBzZXQuCgpGaXggdGhpcyBieSBjaGVj
a2luZyBpZiBAcGF0aCBpcyBub3QgZW1wdHkgYW5kIHRoZW4gYWRkIGV4dHJhIGJ5dGUgZm9yCnNl
cGFyYXRvci4gIEFsc28sIGRvIG5vdCBpbmNsdWRlIGFueSB0cmFpbGluZyBOVUxMIGJ5dGVzIGlu
IGZpbGVuYW1lCmFzIE1TLVNNQjIgcmVxdWlyZXMgaXQgdG8gYmUgOC1ieXRlIGFsaWduZWQgYW5k
IG5vdCBOVUxMIHRlcm1pbmF0ZWQuCgpGaXhlczogN2VhY2JhM2IwMGEzICgiY2lmczogYWxsb2Nf
cGF0aF93aXRoX3RyZWVfcHJlZml4OiBkbyBub3QgYXBwZW5kIHNlcC4gaWYgdGhlIHBhdGggaXMg
ZW1wdHkiKQpTaWduZWQtb2ZmLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0BjanIubno+
Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAxNiArKysrKystLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDkxY2ZjNWI0N2FjNy4uMTI4
ZTQ0ZTU3NTI4IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3Nt
YjJwZHUuYwpAQCAtMjU3MiwxOSArMjU3MiwxNSBAQCBhbGxvY19wYXRoX3dpdGhfdHJlZV9wcmVm
aXgoX19sZTE2ICoqb3V0X3BhdGgsIGludCAqb3V0X3NpemUsIGludCAqb3V0X2xlbiwKIAogCXBh
dGhfbGVuID0gVW5pU3Rybmxlbigod2NoYXJfdCAqKXBhdGgsIFBBVEhfTUFYKTsKIAotCS8qCi0J
ICogbWFrZSByb29tIGZvciBvbmUgcGF0aCBzZXBhcmF0b3IgYmV0d2VlbiB0aGUgdHJlZW5hbWUg
YW5kCi0JICogcGF0aAotCSAqLwotCSpvdXRfbGVuID0gdHJlZW5hbWVfbGVuICsgMSArIHBhdGhf
bGVuOworCS8qIG1ha2Ugcm9vbSBmb3Igb25lIHBhdGggc2VwYXJhdG9yIG9ubHkgaWYgQHBhdGgg
aXNuJ3QgZW1wdHkgKi8KKwkqb3V0X2xlbiA9IHRyZWVuYW1lX2xlbiArIChwYXRoWzBdID8gMSA6
IDApICsgcGF0aF9sZW47CiAKIAkvKgotCSAqIGZpbmFsIHBhdGggbmVlZHMgdG8gYmUgbnVsbC10
ZXJtaW5hdGVkIFVURjE2IHdpdGggYQotCSAqIHNpemUgYWxpZ25lZCB0byA4CisJICogZmluYWwg
cGF0aCBuZWVkcyB0byBiZSA4LWJ5dGUgYWxpZ25lZCBhcyBzcGVjaWZpZWQgaW4KKwkgKiBNUy1T
TUIyIDIuMi4xMyBTTUIyIENSRUFURSBSZXF1ZXN0LgogCSAqLwotCi0JKm91dF9zaXplID0gcm91
bmR1cCgoKm91dF9sZW4rMSkqMiwgOCk7Ci0JKm91dF9wYXRoID0ga3phbGxvYygqb3V0X3NpemUs
IEdGUF9LRVJORUwpOworCSpvdXRfc2l6ZSA9IHJvdW5kdXAoKm91dF9sZW4gKiBzaXplb2YoX19s
ZTE2KSwgOCk7CisJKm91dF9wYXRoID0ga3phbGxvYygqb3V0X3NpemUgKyBzaXplb2YoX19sZTE2
KSAvKiBudWxsICovLCBHRlBfS0VSTkVMKTsKIAlpZiAoISpvdXRfcGF0aCkKIAkJcmV0dXJuIC1F
Tk9NRU07CiAKLS0gCmNnaXQgdjEuMi4xCgo=
--0000000000002837b605e6e3b67a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-skip-extra-NULL-byte-in-filenames.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-skip-extra-NULL-byte-in-filenames.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l75vq4ya1>
X-Attachment-Id: f_l75vq4ya1

RnJvbSA5M2JiYjJjMjdkODU0M2FiYjAzMjU0YTBiNWQ5NTNjNWYzZjBiNTAxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogRnJp
LCAxOSBBdWcgMjAyMiAxNzowMDoxOSAtMDMwMApTdWJqZWN0OiBbUEFUQ0hdIGNpZnM6IHNraXAg
ZXh0cmEgTlVMTCBieXRlIGluIGZpbGVuYW1lcwoKU2luY2UgY29tbWl0OgogY2lmczogYWxsb2Nf
cGF0aF93aXRoX3RyZWVfcHJlZml4OiBkbyBub3QgYXBwZW5kIHNlcC4gaWYgdGhlIHBhdGggaXMg
ZW1wdHkKYWxsb2NfcGF0aF93aXRoX3RyZWVfcHJlZml4KCkgZnVuY3Rpb24gd2FzIG5vIGxvbmdl
ciBpbmNsdWRpbmcgdGhlCnRyYWlsaW5nIHNlcGFyYXRvciB3aGVuIEBwYXRoIGlzIGVtcHR5LCBh
bHRob3VnaCBAb3V0X2xlbiB3YXMgc3RpbGwKYXNzdW1pbmcgYSBwYXRoIHNlcGFyYXRvciB0aHVz
IGFkZGluZyBhbiBleHRyYSBieXRlIHRvIHRoZSBmaW5hbApmaWxlbmFtZS4KClRoaXMgaGFzIGNh
dXNlZCBtb3VudCBpc3N1ZXMgaW4gc29tZSBTeW5vbG9neSBzZXJ2ZXJzIGR1ZSB0byB0aGUgZXh0
cmEKTlVMTCBieXRlIGluIGZpbGVuYW1lcyB3aGVuIHNlbmRpbmcgU01CMl9DUkVBVEUgcmVxdWVz
dHMgd2l0aApTTUIyX0ZMQUdTX0RGU19PUEVSQVRJT05TIHNldC4KCkZpeCB0aGlzIGJ5IGNoZWNr
aW5nIGlmIEBwYXRoIGlzIG5vdCBlbXB0eSBhbmQgdGhlbiBhZGQgZXh0cmEgYnl0ZSBmb3IKc2Vw
YXJhdG9yLiAgQWxzbywgZG8gbm90IGluY2x1ZGUgYW55IHRyYWlsaW5nIE5VTEwgYnl0ZXMgaW4g
ZmlsZW5hbWUKYXMgTVMtU01CMiByZXF1aXJlcyBpdCB0byBiZSA4LWJ5dGUgYWxpZ25lZCBhbmQg
bm90IE5VTEwgdGVybWluYXRlZC4KCkZpeGVzOiA3ZWFjYmEzYjAwYTMgKCJjaWZzOiBhbGxvY19w
YXRoX3dpdGhfdHJlZV9wcmVmaXg6IGRvIG5vdCBhcHBlbmQgc2VwLiBpZiB0aGUgcGF0aCBpcyBl
bXB0eSIpClNpZ25lZC1vZmYtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4K
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvc21iMnBkdS5jIHwgMTYgKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCA5MWNmYzViNDdhYzcuLjEyOGU0NGU1
NzUyOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1
LmMKQEAgLTI1NzIsMTkgKzI1NzIsMTUgQEAgYWxsb2NfcGF0aF93aXRoX3RyZWVfcHJlZml4KF9f
bGUxNiAqKm91dF9wYXRoLCBpbnQgKm91dF9zaXplLCBpbnQgKm91dF9sZW4sCiAKIAlwYXRoX2xl
biA9IFVuaVN0cm5sZW4oKHdjaGFyX3QgKilwYXRoLCBQQVRIX01BWCk7CiAKLQkvKgotCSAqIG1h
a2Ugcm9vbSBmb3Igb25lIHBhdGggc2VwYXJhdG9yIGJldHdlZW4gdGhlIHRyZWVuYW1lIGFuZAot
CSAqIHBhdGgKLQkgKi8KLQkqb3V0X2xlbiA9IHRyZWVuYW1lX2xlbiArIDEgKyBwYXRoX2xlbjsK
KwkvKiBtYWtlIHJvb20gZm9yIG9uZSBwYXRoIHNlcGFyYXRvciBvbmx5IGlmIEBwYXRoIGlzbid0
IGVtcHR5ICovCisJKm91dF9sZW4gPSB0cmVlbmFtZV9sZW4gKyAocGF0aFswXSA/IDEgOiAwKSAr
IHBhdGhfbGVuOwogCiAJLyoKLQkgKiBmaW5hbCBwYXRoIG5lZWRzIHRvIGJlIG51bGwtdGVybWlu
YXRlZCBVVEYxNiB3aXRoIGEKLQkgKiBzaXplIGFsaWduZWQgdG8gOAorCSAqIGZpbmFsIHBhdGgg
bmVlZHMgdG8gYmUgOC1ieXRlIGFsaWduZWQgYXMgc3BlY2lmaWVkIGluCisJICogTVMtU01CMiAy
LjIuMTMgU01CMiBDUkVBVEUgUmVxdWVzdC4KIAkgKi8KLQotCSpvdXRfc2l6ZSA9IHJvdW5kdXAo
KCpvdXRfbGVuKzEpKjIsIDgpOwotCSpvdXRfcGF0aCA9IGt6YWxsb2MoKm91dF9zaXplLCBHRlBf
S0VSTkVMKTsKKwkqb3V0X3NpemUgPSByb3VuZHVwKCpvdXRfbGVuICogc2l6ZW9mKF9fbGUxNiks
IDgpOworCSpvdXRfcGF0aCA9IGt6YWxsb2MoKm91dF9zaXplICsgc2l6ZW9mKF9fbGUxNikgLyog
bnVsbCAqLywgR0ZQX0tFUk5FTCk7CiAJaWYgKCEqb3V0X3BhdGgpCiAJCXJldHVybiAtRU5PTUVN
OwogCi0tIAoyLjM0LjEKCg==
--0000000000002837b605e6e3b67a--
