Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16877C4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Nov 2023 21:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjKFVj2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Nov 2023 16:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjKFVj1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Nov 2023 16:39:27 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88492B0
        for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 13:39:22 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-5079f9ec8d9so5374698e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Nov 2023 13:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699306760; x=1699911560; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2IiMM4Oaussprxl7udp7Hu/HHoE1dkQSnG/jYi/NqA8=;
        b=MBtk+6NRgJ2CilbIsBhkPi9DNi5cEcoAMOqs7kQvIWqP18x0D2kpgDf1GmT0gLbkrR
         wyPIYXMFUQxGwKE1aFEYWAn1JalmIZ3OA/iW6v+KZxukvE9J0W3BogPeCTeKpFvqp3g6
         wqKkirrj9axf3DALLGNEr41Y/1lUK3/l5cNpiosQucc3dqCCZzz9XSHy7nKppGOWO26q
         YJldWkvn9WGZooZQSG4Ur9DEX0DdnFN82U6WWhZZyr+V5V3M+nlSuRXqxcWE0l52/4of
         1dylI4JxSHAq0z4g7uCPFe7Z2JiMQQhUD38ksqoNLe1xH5TE4X0GT7GTYF+/sVZw/0Nq
         Q+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699306760; x=1699911560;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2IiMM4Oaussprxl7udp7Hu/HHoE1dkQSnG/jYi/NqA8=;
        b=V/wd+69XhGLYDDRmn8FvsgG0yX+tfdgTqlexg0D/cu0HmZy5hnMxfPddW3ozjMxow1
         sDzhjSSispIKmIhGlwnpFq7HkW4MsUYFNzNftB/LHdd4eLxXzTd1K/YZ6xjubRma9+8K
         gh5lRosdEr+kR24Olsyjx8nA/bcg3lcz4zf6AJGnfhw5MhO/HAzWMbGuiFvX1Fkp5zKb
         g2KmKWiEdzfy1iEg6lR2ilG1TkmKsHG6H4o1T1/3kxJPSZ04gNBzQRp5PWypugWxBjXc
         zg8dTOMUenWNpKi+Hojb81CC6tL7iGJw9cHCSB3b5snV4c5QUXI9R69TKl25fhkpPP9q
         BkRg==
X-Gm-Message-State: AOJu0Yy6afvCw0ztX+KfEkInUMgG9s2w/lAeDzp1GOuMwTsXm707WMIL
        VwpNaA8k6SVIwYfWJFd/glvgS6zb4+JgxAU9ExRQc6Ser1eBog==
X-Google-Smtp-Source: AGHT+IEL6lMWteA2e1dA+NGcKS++jpLWpN88zVHAoO8W0yW9PQrQgY7ygA72PuTJ7xlfHWqvlXV8Lm92UFdtG3L+WdA=
X-Received: by 2002:ac2:4d90:0:b0:504:2345:1b23 with SMTP id
 g16-20020ac24d90000000b0050423451b23mr208796lfe.34.1699306760014; Mon, 06 Nov
 2023 13:39:20 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mu1TEV7hGG0_Bv8ukcG3bGc7PpATdYMRPZJCz1t1yFQZg@mail.gmail.com>
In-Reply-To: <CAH2r5mu1TEV7hGG0_Bv8ukcG3bGc7PpATdYMRPZJCz1t1yFQZg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 Nov 2023 15:39:08 -0600
Message-ID: <CAH2r5mtD0V-NT3fy5ZVRN=LJL3NWzF-SD1UYmPOAd--ENMRkBA@mail.gmail.com>
Subject: Re: Minor smbdirect cleanup
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000cbbf62060982af28"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cbbf62060982af28
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One more minor cleanup (of sess.c this time)


On Mon, Nov 6, 2023 at 1:37=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> See attached (minor rdma/smbdirect cleanup)
>
> spotted when ran checkpatch against cifs_debug.c
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000cbbf62060982af28
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-minor-cleanup-of-session-handling-code.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-minor-cleanup-of-session-handling-code.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lonfctxp0>
X-Attachment-Id: f_lonfctxp0

RnJvbSBiYzA1ZmQyNTQ4M2I5NGJiZDFlZmU0MDA2OTk4OTFiOTlhMzMyNjM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNiBOb3YgMjAyMyAxNTozNzowMyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IG1pbm9yIGNsZWFudXAgb2Ygc2Vzc2lvbiBoYW5kbGluZyBjb2RlCgpNaW5vciBjbGVhbnVw
IG9mIHN0eWxlIGlzc3VlcyBmb3VuZCBieSBjaGVja3BhdGNoCgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zZXNz
LmMgfCAxOCArKysrKysrKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc2Vzcy5jIGIv
ZnMvc21iL2NsaWVudC9zZXNzLmMKaW5kZXggOTMyZjZkM2I1Y2ZkLi45ZDcxYzIzZmUyMzQgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc2Vzcy5j
CkBAIC0xMDUsNiArMTA1LDcgQEAgY2lmc19jaGFuX2NsZWFyX2luX3JlY29ubmVjdChzdHJ1Y3Qg
Y2lmc19zZXMgKnNlcywKIAkJCSAgICAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQog
ewogCXVuc2lnbmVkIGludCBjaGFuX2luZGV4ID0gY2lmc19zZXNfZ2V0X2NoYW5faW5kZXgoc2Vz
LCBzZXJ2ZXIpOworCiAJaWYgKGNoYW5faW5kZXggPT0gQ0lGU19JTlZBTF9DSEFOX0lOREVYKQog
CQlyZXR1cm47CiAKQEAgLTExNiw2ICsxMTcsNyBAQCBjaWZzX2NoYW5faW5fcmVjb25uZWN0KHN0
cnVjdCBjaWZzX3NlcyAqc2VzLAogCQkJICBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIp
CiB7CiAJdW5zaWduZWQgaW50IGNoYW5faW5kZXggPSBjaWZzX3Nlc19nZXRfY2hhbl9pbmRleChz
ZXMsIHNlcnZlcik7CisKIAlpZiAoY2hhbl9pbmRleCA9PSBDSUZTX0lOVkFMX0NIQU5fSU5ERVgp
CiAJCXJldHVybiB0cnVlOwkvKiBlcnIgb24gdGhlIHNhZmVyIHNpZGUgKi8KIApAQCAtMTI3LDYg
KzEyOSw3IEBAIGNpZnNfY2hhbl9zZXRfbmVlZF9yZWNvbm5lY3Qoc3RydWN0IGNpZnNfc2VzICpz
ZXMsCiAJCQkgICAgIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIHsKIAl1bnNpZ25l
ZCBpbnQgY2hhbl9pbmRleCA9IGNpZnNfc2VzX2dldF9jaGFuX2luZGV4KHNlcywgc2VydmVyKTsK
KwogCWlmIChjaGFuX2luZGV4ID09IENJRlNfSU5WQUxfQ0hBTl9JTkRFWCkKIAkJcmV0dXJuOwog
CkBAIC0xNDAsNiArMTQzLDcgQEAgY2lmc19jaGFuX2NsZWFyX25lZWRfcmVjb25uZWN0KHN0cnVj
dCBjaWZzX3NlcyAqc2VzLAogCQkJICAgICAgIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZl
cikKIHsKIAl1bnNpZ25lZCBpbnQgY2hhbl9pbmRleCA9IGNpZnNfc2VzX2dldF9jaGFuX2luZGV4
KHNlcywgc2VydmVyKTsKKwogCWlmIChjaGFuX2luZGV4ID09IENJRlNfSU5WQUxfQ0hBTl9JTkRF
WCkKIAkJcmV0dXJuOwogCkBAIC0xNTMsNiArMTU3LDcgQEAgY2lmc19jaGFuX25lZWRzX3JlY29u
bmVjdChzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJCSAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyKQogewogCXVuc2lnbmVkIGludCBjaGFuX2luZGV4ID0gY2lmc19zZXNfZ2V0X2NoYW5f
aW5kZXgoc2VzLCBzZXJ2ZXIpOworCiAJaWYgKGNoYW5faW5kZXggPT0gQ0lGU19JTlZBTF9DSEFO
X0lOREVYKQogCQlyZXR1cm4gdHJ1ZTsJLyogZXJyIG9uIHRoZSBzYWZlciBzaWRlICovCiAKQEAg
LTE2NCw2ICsxNjksNyBAQCBjaWZzX2NoYW5faXNfaWZhY2VfYWN0aXZlKHN0cnVjdCBjaWZzX3Nl
cyAqc2VzLAogCQkJICBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiB7CiAJdW5zaWdu
ZWQgaW50IGNoYW5faW5kZXggPSBjaWZzX3Nlc19nZXRfY2hhbl9pbmRleChzZXMsIHNlcnZlcik7
CisKIAlpZiAoY2hhbl9pbmRleCA9PSBDSUZTX0lOVkFMX0NIQU5fSU5ERVgpCiAJCXJldHVybiB0
cnVlOwkvKiBlcnIgb24gdGhlIHNhZmVyIHNpZGUgKi8KIApAQCAtNjgyLDggKzY4OCw3IEBAIHN0
YXRpYyBfX3UzMiBjaWZzX3NzZXR1cF9oZHIoc3RydWN0IGNpZnNfc2VzICpzZXMsCiAKIAkvKiBO
b3cgbm8gbmVlZCB0byBzZXQgU01CRkxHX0NBU0VMRVNTIG9yIG9ic29sZXRlIENBTk9OSUNBTCBQ
QVRIICovCiAKLQkvKiBCQiB2ZXJpZnkgd2hldGhlciBzaWduaW5nIHJlcXVpcmVkIG9uIG5lZyBv
ciBqdXN0IG9uIGF1dGggZnJhbWUKLQkgICAoYW5kIE5UTE0gY2FzZSkgKi8KKwkvKiBCQiB2ZXJp
Znkgd2hldGhlciBzaWduaW5nIHJlcXVpcmVkIG9uIG5lZyBvciBqdXN0IGF1dGggZnJhbWUgKGFu
ZCBOVExNIGNhc2UpICovCiAKIAljYXBhYmlsaXRpZXMgPSBDQVBfTEFSR0VfRklMRVMgfCBDQVBf
TlRfU01CUyB8IENBUF9MRVZFTF9JSV9PUExPQ0tTIHwKIAkJCUNBUF9MQVJHRV9XUklURV9YIHwg
Q0FQX0xBUkdFX1JFQURfWDsKQEAgLTc0MCw4ICs3NDUsMTAgQEAgc3RhdGljIHZvaWQgdW5pY29k
ZV9kb21haW5fc3RyaW5nKGNoYXIgKipwYmNjX2FyZWEsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAog
CiAJLyogY29weSBkb21haW4gKi8KIAlpZiAoc2VzLT5kb21haW5OYW1lID09IE5VTEwpIHsKLQkJ
LyogU2VuZGluZyBudWxsIGRvbWFpbiBiZXR0ZXIgdGhhbiB1c2luZyBhIGJvZ3VzIGRvbWFpbiBu
YW1lIChhcwotCQl3ZSBkaWQgYnJpZWZseSBpbiAyLjYuMTgpIHNpbmNlIHNlcnZlciB3aWxsIHVz
ZSBpdHMgZGVmYXVsdCAqLworCQkvKgorCQkgKiBTZW5kaW5nIG51bGwgZG9tYWluIGJldHRlciB0
aGFuIHVzaW5nIGEgYm9ndXMgZG9tYWluIG5hbWUgKGFzCisJCSAqIHdlIGRpZCBicmllZmx5IGlu
IDIuNi4xOCkgc2luY2Ugc2VydmVyIHdpbGwgdXNlIGl0cyBkZWZhdWx0CisJCSAqLwogCQkqYmNj
X3B0ciA9IDA7CiAJCSooYmNjX3B0cisxKSA9IDA7CiAJCWJ5dGVzX3JldCA9IDA7CkBAIC03NjAs
OCArNzY3LDcgQEAgc3RhdGljIHZvaWQgdW5pY29kZV9zc2V0dXBfc3RyaW5ncyhjaGFyICoqcGJj
Y19hcmVhLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAljaGFyICpiY2NfcHRyID0gKnBiY2NfYXJl
YTsKIAlpbnQgYnl0ZXNfcmV0ID0gMDsKIAotCS8qIEJCIEZJWE1FIGFkZCBjaGVjayB0aGF0IHN0
cmluZ3MgdG90YWwgbGVzcwotCXRoYW4gMzM1IG9yIHdpbGwgbmVlZCB0byBzZW5kIHRoZW0gYXMg
YXJyYXlzICovCisJLyogQkIgRklYTUUgYWRkIGNoZWNrIHRoYXQgc3RyaW5ncyBsZXNzIHRoYW4g
MzM1IG9yIHdpbGwgbmVlZCB0byBzZW5kIGFzIGFycmF5cyAqLwogCiAJLyogY29weSB1c2VyICov
CiAJaWYgKHNlcy0+dXNlcl9uYW1lID09IE5VTEwpIHsKLS0gCjIuMzkuMgoK
--000000000000cbbf62060982af28--
