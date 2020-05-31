Return-Path: <SRS0=/VLE=7N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22441C433DF
	for <linux-cifs@archiver.kernel.org>; Sun, 31 May 2020 19:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1EA6206A1
	for <linux-cifs@archiver.kernel.org>; Sun, 31 May 2020 19:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vC1upYum"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEaTp2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 31 May 2020 15:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgEaTp2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 31 May 2020 15:45:28 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC30C061A0E
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2020 12:45:28 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id u17so4116306ybi.0
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2020 12:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=PWWGgV7lOf0aD0UjcTv3kbIjxrM4iXu+/Zc9puPkmX4=;
        b=vC1upYumMb0seoMA5NdXQVviiFqNsiat+9LpiROpqCfl9zu9dQgW0tYDlsHlot4Bnm
         vrxhYx4cvab5TEl0yJ5unwQHaRNOF+FJqZurGqnS5UrcFERkIWaylLFyCJoyNM9pbDNL
         aXti6bIUpifTpT+u25rVcvqOOLOnO1IYZKwrraW9Dhhkn5Q01KIYH2z57Km0mSFB0guZ
         eP4Da2Q6iIc6XIW7pwN/N8mu0vDGLFOT46PX9+s3q8JEOnExCXEkiW7V8iC6E0fhNw3w
         OcQReCIq7E22EwgDulqLwLxNanyidA3sXr6BfTNoBeLLzeY/C757BX+5mGJPXErIMs23
         VKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PWWGgV7lOf0aD0UjcTv3kbIjxrM4iXu+/Zc9puPkmX4=;
        b=XVG5BgLHh5axmN1M6xfpW0TxspED8YHLOSr4/Q2qQUbWkeGS58I7F1Sbcp2D0LRr3L
         RX2S1o6TMH0FivBKYdxrD//ioRSyxO1aWhqTG5cnEpzkZIu3IYCS6boIZS5EKmIbUl/8
         796VksYJWEyC49iOZ9Egd9F7uBs6bZ8kkvzd73w//WFeqnbW8+/XvJzDL4SFo02LeluC
         a3tLI3be+xHk3TNVG/02XyDo+/AGowo9defN2FUoQhchFbSbJviYSDCY+J11gizIndHj
         SI1vp2A2oRsCJtV1n55GzDTrZx9Ma0PMn2SVE4OyZquPuxZB/KLZGa1GJvpzmerKaopI
         KaIA==
X-Gm-Message-State: AOAM530pPauww16N6LrnU2dLpaCaI4QsnEWgJlIsolfSn93MSGvzshS6
        MDL6JQDxUlpO6HLzqZ4Z1y7gUeMYl4Se3aGH4JW5V8a2c7Y=
X-Google-Smtp-Source: ABdhPJykTErxvEEZcSzdGQv5bZxmAx451ZE21qYuI2+iA+dOv+H9lcNYNeVmyyovP9D1bGUZTLc6z570smDzKNXsMaA=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr18013684ybg.375.1590954326932;
 Sun, 31 May 2020 12:45:26 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 31 May 2020 14:45:16 -0500
Message-ID: <CAH2r5ms6z3ApsMhCBCh5kOO=ezqCwePUpV=dmOUT-HLus5wr5Q@mail.gmail.com>
Subject: [PATCH 4 of 4][SMB3] multichannel: try to rebind when reconnecting a channel
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000082e4e805a6f6eb2f"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000082e4e805a6f6eb2f
Content-Type: text/plain; charset="UTF-8"

Here is the final patch of Aurelien's 4 patch series for improving
multichannel performance.  There is still some work to do (on
additional reconnect improvements e.g.) but the performance numbers in
my testing looked really good.

first steps in trying to make channels properly reconnect.

* add cifs_ses_find_chan() function to find the enclosing cifs_chan
  struct it belongs to
* while we have the session lock and are redoing negprot and
  sess.setup in smb2_reconnect() redo the binding of channels.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

-- 
Thanks,

Steve

--00000000000082e4e805a6f6eb2f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0004-cifs-multichannel-try-to-rebind-when-reconnecting-a-.patch"
Content-Disposition: attachment; 
	filename="0004-cifs-multichannel-try-to-rebind-when-reconnecting-a-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kavh4bsz0>
X-Attachment-Id: f_kavh4bsz0

RnJvbSAyZDgyZWMyZWZmMDdiNTQ1YzA5MzA5N2JiNWJiOTA0M2M1MjVhNWU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBGcmksIDI0IEFwciAyMDIwIDE2OjU1OjMxICswMjAwClN1YmplY3Q6IFtQQVRDSCA0LzRdIGNp
ZnM6IG11bHRpY2hhbm5lbDogdHJ5IHRvIHJlYmluZCB3aGVuIHJlY29ubmVjdGluZyBhCiBjaGFu
bmVsCgpmaXJzdCBzdGVwcyBpbiB0cnlpbmcgdG8gbWFrZSBjaGFubmVscyBwcm9wZXJseSByZWNv
bm5lY3QuCgoqIGFkZCBjaWZzX3Nlc19maW5kX2NoYW4oKSBmdW5jdGlvbiB0byBmaW5kIHRoZSBl
bmNsb3NpbmcgY2lmc19jaGFuCiAgc3RydWN0IGl0IGJlbG9uZ3MgdG8KKiB3aGlsZSB3ZSBoYXZl
IHRoZSBzZXNzaW9uIGxvY2sgYW5kIGFyZSByZWRvaW5nIG5lZ3Byb3QgYW5kCiAgc2Vzcy5zZXR1
cCBpbiBzbWIyX3JlY29ubmVjdCgpIHJlZG8gdGhlIGJpbmRpbmcgb2YgY2hhbm5lbHMuCgpTaWdu
ZWQtb2ZmLWJ5OiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZz
cHJvdG8uaCB8ICAyICsrCiBmcy9jaWZzL3Nlc3MuYyAgICAgIHwgMTYgKysrKysrKysrKysrKysr
KwogZnMvY2lmcy9zbWIycGR1LmMgICB8IDE2ICsrKysrKysrKysrKysrKysKIDMgZmlsZXMgY2hh
bmdlZCwgMzQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgg
Yi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IDhmZDQ0NjQ1ZTliNS4uNTg1MmQ3NGMxZGRlIDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgK
QEAgLTU5Miw2ICs1OTIsOCBAQCB2b2lkIGNpZnNfZnJlZV9oYXNoKHN0cnVjdCBjcnlwdG9fc2hh
c2ggKipzaGFzaCwgc3RydWN0IHNkZXNjICoqc2Rlc2MpOwogCiBleHRlcm4gdm9pZCBycXN0X3Bh
Z2VfZ2V0X2xlbmd0aChzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsIHVuc2lnbmVkIGludCBwYWdlLAog
CQkJCXVuc2lnbmVkIGludCAqbGVuLCB1bnNpZ25lZCBpbnQgKm9mZnNldCk7CitzdHJ1Y3QgY2lm
c19jaGFuICoKK2NpZnNfc2VzX2ZpbmRfY2hhbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKTsKIGludCBjaWZzX3RyeV9hZGRpbmdfY2hhbm5lbHMo
c3RydWN0IGNpZnNfc2VzICpzZXMpOwogaW50IGNpZnNfc2VzX2FkZF9jaGFubmVsKHN0cnVjdCBj
aWZzX3NlcyAqc2VzLAogCQkJCXN0cnVjdCBjaWZzX3NlcnZlcl9pZmFjZSAqaWZhY2UpOwpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9zZXNzLmMgYi9mcy9jaWZzL3Nlc3MuYwppbmRleCA5YTQyNmRiMjFm
YWUuLmFlNmE4MTI1ZThjZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zZXNzLmMKKysrIGIvZnMvY2lm
cy9zZXNzLmMKQEAgLTE1MCw2ICsxNTAsMjIgQEAgaW50IGNpZnNfdHJ5X2FkZGluZ19jaGFubmVs
cyhzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIAlyZXR1cm4gc2VzLT5jaGFuX2NvdW50IC0gb2xkX2No
YW5fY291bnQ7CiB9CiAKKy8qCisgKiBJZiBzZXJ2ZXIgaXMgYSBjaGFubmVsIG9mIHNlcywgcmV0
dXJuIHRoZSBjb3JyZXNwb25kaW5nIGVuY2xvc2luZworICogY2lmc19jaGFuIG90aGVyd2lzZSBy
ZXR1cm4gTlVMTC4KKyAqLworc3RydWN0IGNpZnNfY2hhbiAqCitjaWZzX3Nlc19maW5kX2NoYW4o
c3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKK3sK
KwlpbnQgaTsKKworCWZvciAoaSA9IDA7IGkgPCBzZXMtPmNoYW5fY291bnQ7IGkrKykgeworCQlp
ZiAoc2VzLT5jaGFuc1tpXS5zZXJ2ZXIgPT0gc2VydmVyKQorCQkJcmV0dXJuICZzZXMtPmNoYW5z
W2ldOworCX0KKwlyZXR1cm4gTlVMTDsKK30KKwogaW50CiBjaWZzX3Nlc19hZGRfY2hhbm5lbChz
dHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZSkKIHsK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXgg
ZTQxY2ZmZDhjOTViLi4zNDFkMWI2MGM1YTYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5j
CisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0zNTUsMTUgKzM1NSwzMSBAQCBzbWIyX3JlY29u
bmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlnb3Rv
IG91dDsKIAl9CiAKKwkvKgorCSAqIElmIHdlIGFyZSByZWNvbm5lY3RpbmcgYW4gZXh0cmEgY2hh
bm5lbCwgYmluZAorCSAqLworCWlmIChzZXJ2ZXItPmlzX2NoYW5uZWwpIHsKKwkJc2VzLT5iaW5k
aW5nID0gdHJ1ZTsKKwkJc2VzLT5iaW5kaW5nX2NoYW4gPSBjaWZzX3Nlc19maW5kX2NoYW4oc2Vz
LCBzZXJ2ZXIpOworCX0KKwogCXJjID0gY2lmc19uZWdvdGlhdGVfcHJvdG9jb2woMCwgdGNvbi0+
c2VzKTsKIAlpZiAoIXJjICYmIHRjb24tPnNlcy0+bmVlZF9yZWNvbm5lY3QpIHsKIAkJcmMgPSBj
aWZzX3NldHVwX3Nlc3Npb24oMCwgdGNvbi0+c2VzLCBubHNfY29kZXBhZ2UpOwogCQlpZiAoKHJj
ID09IC1FQUNDRVMpICYmICF0Y29uLT5yZXRyeSkgewogCQkJcmMgPSAtRUhPU1RET1dOOworCQkJ
c2VzLT5iaW5kaW5nID0gZmFsc2U7CisJCQlzZXMtPmJpbmRpbmdfY2hhbiA9IE5VTEw7CiAJCQlt
dXRleF91bmxvY2soJnRjb24tPnNlcy0+c2Vzc2lvbl9tdXRleCk7CiAJCQlnb3RvIGZhaWxlZDsK
IAkJfQogCX0KKwkvKgorCSAqIEVuZCBvZiBjaGFubmVsIGJpbmRpbmcKKwkgKi8KKwlzZXMtPmJp
bmRpbmcgPSBmYWxzZTsKKwlzZXMtPmJpbmRpbmdfY2hhbiA9IE5VTEw7CisKIAlpZiAocmMgfHwg
IXRjb24tPm5lZWRfcmVjb25uZWN0KSB7CiAJCW11dGV4X3VubG9jaygmdGNvbi0+c2VzLT5zZXNz
aW9uX211dGV4KTsKIAkJZ290byBvdXQ7Ci0tIAoyLjIwLjEKCg==
--00000000000082e4e805a6f6eb2f--
