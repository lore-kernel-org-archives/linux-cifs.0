Return-Path: <SRS0=kqF3=C3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E17C43463
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 06:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4912F2084C
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 06:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTSpnRwh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIRGId (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Sep 2020 02:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRGIc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Sep 2020 02:08:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85984C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 23:08:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id q9so4121060wmj.2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 23:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y1FLGOcRF0mpBcOPfXsYVDWobAhIMkM4fH8Wuntpdy4=;
        b=TTSpnRwhjFkDXjPGsNdUKFwoLuty0KpLFSPnpG1QX5jfyyn+pGZm4P5r3YCMTeKFlX
         EiCxlJZH5yRE63ridYIB8wsGIVx14Vxcls9HJXkjooW7qmC6sc4otKcYCfZZ8mwEWiLb
         Jh0IBdq7cGbqULvs4iclhhqcc4tlccg0yW197O5anlmjOk6rLlz/gXdcjv2N1rBeImNa
         clxQ+alLRBrMwxtgTDTo5w1FyGTS2aroD2OZa5oKQv/oArBLwX1Z9uSC9FORckehWHRg
         5nHRFdP5ch69ItcQYlzgWRD3BrVQY84G7Cdw9FvAK+7KQlYT1tywysU/93TRhgJpsSku
         zhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y1FLGOcRF0mpBcOPfXsYVDWobAhIMkM4fH8Wuntpdy4=;
        b=jnbmsZS425+mywKQ34h+JTemlozSIHFoxtI9upX+xouePTaY8FDAVBQV/Xh87E548l
         JD/qQ9pbNG4i/oqjhQXsG5CWPC87xdUo683DAhW2Ax+LZTkyRGbtmijzQoAblAC4TRwK
         +3n/MXCXL09oJHUbzCnXRxNj0PQ3XBSafg6uC7rvtuH5whltKODPZGxqo3HyuYqZhY1V
         LkYY3V1C1awc3nK73b1/jEmBq7Oz3YPeSQQ4t/X4j2A8rOCtsdmnVbhEJ16JDGeivt+m
         e7QXGBXFaTlZWTLxWhH1wOUKVA5HlhCipcef+BCqdVS2vo0BlJGkuIOSkLvNuSbYf6tR
         89SQ==
X-Gm-Message-State: AOAM5317uNFiAKh0hprD3r0qBuP8pgzk8kcCt0VGKfRqCxGDxgvEyOzP
        N08IcnPcvl7y/Su8f53LdkzPB9OufreKK+u2qnA=
X-Google-Smtp-Source: ABdhPJyv9zgOxaPXTQteW7UUZQWMBYtC3F4T7JGD0zZw9EEHTVD+zuaLIVGinm+SG2bFxFlNeJbuoJMqV8lxm3Pbu5M=
X-Received: by 2002:a1c:7f8b:: with SMTP id a133mr14538720wmd.155.1600409311185;
 Thu, 17 Sep 2020 23:08:31 -0700 (PDT)
MIME-Version: 1.0
From:   rohiths msft <rohiths.msft@gmail.com>
Date:   Fri, 18 Sep 2020 11:38:19 +0530
Message-ID: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
Subject: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     smfrench@gmail.com, piastryyy@gmail.com, nspmangalore@gmail.com,
        sribhat.msa@outlook.com, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000007d508105af905431"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007d508105af905431
Content-Type: text/plain; charset="UTF-8"

Hi All,

This fix is to handle STATUS_IO_TIMEOUT status code. This status code
is returned by the server in case of unavailability(internal
disconnects,etc) and is not treated by linux clients as retriable. So,
this fix maps the status code as retriable error and also has a check
to drop the connection to not overload the server.

Regards,
Rohith

--0000000000007d508105af905431
Content-Type: application/octet-stream; 
	name="0001-Handle-STATUS_IO_TIMEOUT-gracefully.patch"
Content-Disposition: attachment; 
	filename="0001-Handle-STATUS_IO_TIMEOUT-gracefully.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kf7u8gp30>
X-Attachment-Id: f_kf7u8gp30

RnJvbSBlZjM0ZjNmY2RjYzdlZDY2N2U5MzJmM2VhOGRjMTRhZWYyNjlmMDMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogRnJpLCAxOCBTZXAgMjAyMCAwNTozNzoyOCArMDAwMApTdWJqZWN0OiBbUEFU
Q0hdIEhhbmRsZSBTVEFUVVNfSU9fVElNRU9VVCBncmFjZWZ1bGx5CgpDdXJyZW50bHkgU1RBVFVT
X0lPX1RJTUVPVVQgaXMgbm90IHRyZWF0ZWQgYXMgcmV0cmlhYmxlIGVycm9yLgpJdCBpcyBjdXJy
ZW50bHkgbWFwcGVkIHRvIEVUSU1FRE9VVCBhbmQgcmV0dXJuZWQgdG8gdXNlcnNwYWNlCmZvciBt
b3N0IHN5c3RlbSBjYWxscy4gU1RBVFVTX0lPX1RJTUVPVVQgaXMgcmV0dXJuZWQgYnkgc2VydmVy
CmluIGNhc2Ugb2YgdW5hdmFpbGFiaWxpdHkgb3IgdGhyb3R0bGluZyBlcnJvcnMuCgpUaGlzIHBh
dGNoIHdpbGwgbWFwIHRoZSBTVEFUVVNfSU9fVElNRU9VVCB0byBFQUdBSU4sIHNvIHRoYXQgaXQK
Y2FuIGJlIHJldHJpZWQuIEFsc28sIGFkZGVkIGEgY2hlY2sgdG8gZHJvcCB0aGUgY29ubmVjdGlv
biB0bwpub3Qgb3ZlcmxvYWQgdGhlIHNlcnZlciBpbiBjYXNlIG9mIG9uZ29pbmcgdW5hdmFpbGFi
aWxpdHkuCi0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oICAgICB8ICAyICsrCiBmcy9jaWZzL2Nvbm5l
Y3QuYyAgICAgIHwgMTUgKysrKysrKysrKysrKystCiBmcy9jaWZzL3NtYjJtYXBlcnJvci5jIHwg
IDIgKy0KIGZzL2NpZnMvc21iMm9wcy5jICAgICAgfCAxNSArKysrKysrKysrKysrKysKIDQgZmls
ZXMgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggYjU2NWQ4M2Jh
ODllLi45OWNiMGRlYTI1ZDAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9m
cy9jaWZzL2NpZnNnbG9iLmgKQEAgLTUxMCw2ICs1MTAsOCBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25f
b3BlcmF0aW9ucyB7CiAJCSAgICAgIHN0cnVjdCBmaWVtYXBfZXh0ZW50X2luZm8gKiwgdTY0LCB1
NjQpOwogCS8qIHZlcnNpb24gc3BlY2lmaWMgbGxzZWVrIGltcGxlbWVudGF0aW9uICovCiAJbG9m
Zl90ICgqbGxzZWVrKShzdHJ1Y3QgZmlsZSAqLCBzdHJ1Y3QgY2lmc190Y29uICosIGxvZmZfdCwg
aW50KTsKKwkvKiBDaGVjayBmb3IgU1RBVFVTX0lPX1RJTUVPVVQgKi8KKwlib29sICgqaXNfc3Rh
dHVzX2lvX3RpbWVvdXQpIChjaGFyICopOwogfTsKIAogc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVl
cyB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmlu
ZGV4IGE1NzMxZGQ2ZTY1Ni4uMWEzYjc3OTMwOTVlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5l
Y3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtNjksNiArNjksOSBAQCBleHRlcm4gYm9v
bCBkaXNhYmxlX2xlZ2FjeV9kaWFsZWN0czsKICNkZWZpbmUgVExJTktfRVJST1JfRVhQSVJFCSgx
ICogSFopCiAjZGVmaW5lIFRMSU5LX0lETEVfRVhQSVJFCSg2MDAgKiBIWikKIAorLyogRHJvcCB0
aGUgY29ubmVjdGlvbiB0byBub3Qgb3ZlcmxvYWQgdGhlIHNlcnZlciAqLworI2RlZmluZSBOVU1f
U1RBVFVTX0lPX1RJTUVPVVQgICA1CisKIGVudW0gewogCS8qIE1vdW50IG9wdGlvbnMgdGhhdCB0
YWtlIG5vIGFyZ3VtZW50cyAqLwogCU9wdF91c2VyX3hhdHRyLCBPcHRfbm91c2VyX3hhdHRyLApA
QCAtMTExNyw3ICsxMTIwLDcgQEAgY2lmc19kZW11bHRpcGxleF90aHJlYWQodm9pZCAqcCkKIAlz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2tfdG9fd2FrZSA9IE5VTEw7CiAJc3RydWN0IG1pZF9xX2Vu
dHJ5ICptaWRzW01BWF9DT01QT1VORF07CiAJY2hhciAqYnVmc1tNQVhfQ09NUE9VTkRdOwotCXVu
c2lnbmVkIGludCBub3JlY2xhaW1fZmxhZzsKKwl1bnNpZ25lZCBpbnQgbm9yZWNsYWltX2ZsYWcs
IG51bV9pb190aW1lb3V0ID0gMDsKIAogCW5vcmVjbGFpbV9mbGFnID0gbWVtYWxsb2Nfbm9yZWNs
YWltX3NhdmUoKTsKIAljaWZzX2RiZyhGWUksICJEZW11bHRpcGxleCBQSUQ6ICVkXG4iLCB0YXNr
X3BpZF9ucihjdXJyZW50KSk7CkBAIC0xMjEzLDYgKzEyMTYsMTYgQEAgY2lmc19kZW11bHRpcGxl
eF90aHJlYWQodm9pZCAqcCkKIAkJCWNvbnRpbnVlOwogCQl9CiAKKwkJaWYgKHNlcnZlci0+b3Bz
LT5pc19zdGF0dXNfaW9fdGltZW91dCAmJgorCQkgICAgc2VydmVyLT5vcHMtPmlzX3N0YXR1c19p
b190aW1lb3V0KGJ1ZikpIHsKKwkJCW51bV9pb190aW1lb3V0Kys7CisJCQlpZiAobnVtX2lvX3Rp
bWVvdXQgPiBOVU1fU1RBVFVTX0lPX1RJTUVPVVQpIHsKKwkJCQljaWZzX3JlY29ubmVjdChzZXJ2
ZXIpOworCQkJCW51bV9pb190aW1lb3V0ID0gMDsKKwkJCQljb250aW51ZTsKKwkJCX0KKwkJfQor
CiAJCXNlcnZlci0+bHN0cnAgPSBqaWZmaWVzOwogCiAJCWZvciAoaSA9IDA7IGkgPCBudW1fbWlk
czsgaSsrKSB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtYXBlcnJvci5jIGIvZnMvY2lmcy9z
bWIybWFwZXJyb3IuYwppbmRleCA3ZmRlMzc3NWNiNTcuLmIwMDRjZjg3NjkyYSAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIybWFwZXJyb3IuYworKysgYi9mcy9jaWZzL3NtYjJtYXBlcnJvci5jCkBA
IC00ODgsNyArNDg4LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzdGF0dXNfdG9fcG9zaXhfZXJy
b3Igc21iMl9lcnJvcl9tYXBfdGFibGVbXSA9IHsKIAl7U1RBVFVTX1BJUEVfQ09OTkVDVEVELCAt
RUlPLCAiU1RBVFVTX1BJUEVfQ09OTkVDVEVEIn0sCiAJe1NUQVRVU19QSVBFX0xJU1RFTklORywg
LUVJTywgIlNUQVRVU19QSVBFX0xJU1RFTklORyJ9LAogCXtTVEFUVVNfSU5WQUxJRF9SRUFEX01P
REUsIC1FSU8sICJTVEFUVVNfSU5WQUxJRF9SRUFEX01PREUifSwKLQl7U1RBVFVTX0lPX1RJTUVP
VVQsIC1FVElNRURPVVQsICJTVEFUVVNfSU9fVElNRU9VVCJ9LAorCXtTVEFUVVNfSU9fVElNRU9V
VCwgLUVBR0FJTiwgIlNUQVRVU19JT19USU1FT1VUIn0sCiAJe1NUQVRVU19GSUxFX0ZPUkNFRF9D
TE9TRUQsIC1FSU8sICJTVEFUVVNfRklMRV9GT1JDRURfQ0xPU0VEIn0sCiAJe1NUQVRVU19QUk9G
SUxJTkdfTk9UX1NUQVJURUQsIC1FSU8sICJTVEFUVVNfUFJPRklMSU5HX05PVF9TVEFSVEVEIn0s
CiAJe1NUQVRVU19QUk9GSUxJTkdfTk9UX1NUT1BQRUQsIC1FSU8sICJTVEFUVVNfUFJPRklMSU5H
X05PVF9TVE9QUEVEIn0sCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMv
c21iMm9wcy5jCmluZGV4IDMyZjkwZGM4MmM4NC4uODhmNzYyYTkyMWI5IDEwMDY0NAotLS0gYS9m
cy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjM0Niw2ICsyMzQ2
LDE3IEBAIHNtYjJfaXNfc2Vzc2lvbl9leHBpcmVkKGNoYXIgKmJ1ZikKIAlyZXR1cm4gdHJ1ZTsK
IH0KIAorc3RhdGljIGJvb2wKK3NtYjJfaXNfc3RhdHVzX2lvX3RpbWVvdXQoY2hhciAqYnVmKQor
eworCXN0cnVjdCBzbWIyX3N5bmNfaGRyICpzaGRyID0gKHN0cnVjdCBzbWIyX3N5bmNfaGRyICop
YnVmOworCisJaWYgKHNoZHItPlN0YXR1cyA9PSBTVEFUVVNfSU9fVElNRU9VVCkKKwkJcmV0dXJu
IHRydWU7CisJZWxzZQorCQlyZXR1cm4gZmFsc2U7Cit9CisKIHN0YXRpYyBpbnQKIHNtYjJfb3Bs
b2NrX3Jlc3BvbnNlKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBjaWZzX2ZpZCAqZmlk
LAogCQkgICAgIHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaW5vZGUpCkBAIC00ODA5LDYgKzQ4MjAs
NyBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIyMF9vcGVyYXRpb25zID0gewog
CS5tYWtlX25vZGUgPSBzbWIyX21ha2Vfbm9kZSwKIAkuZmllbWFwID0gc21iM19maWVtYXAsCiAJ
Lmxsc2VlayA9IHNtYjNfbGxzZWVrLAorCS5pc19zdGF0dXNfaW9fdGltZW91dCA9IHNtYjJfaXNf
c3RhdHVzX2lvX3RpbWVvdXQsCiB9OwogCiBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBz
bWIyMV9vcGVyYXRpb25zID0gewpAQCAtNDkwOSw2ICs0OTIxLDcgQEAgc3RydWN0IHNtYl92ZXJz
aW9uX29wZXJhdGlvbnMgc21iMjFfb3BlcmF0aW9ucyA9IHsKIAkubWFrZV9ub2RlID0gc21iMl9t
YWtlX25vZGUsCiAJLmZpZW1hcCA9IHNtYjNfZmllbWFwLAogCS5sbHNlZWsgPSBzbWIzX2xsc2Vl
aywKKwkuaXNfc3RhdHVzX2lvX3RpbWVvdXQgPSBzbWIyX2lzX3N0YXR1c19pb190aW1lb3V0LAog
fTsKIAogc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3BlcmF0aW9ucyA9IHsK
QEAgLTUwMTksNiArNTAzMiw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjMw
X29wZXJhdGlvbnMgPSB7CiAJLm1ha2Vfbm9kZSA9IHNtYjJfbWFrZV9ub2RlLAogCS5maWVtYXAg
PSBzbWIzX2ZpZW1hcCwKIAkubGxzZWVrID0gc21iM19sbHNlZWssCisJLmlzX3N0YXR1c19pb190
aW1lb3V0ID0gc21iMl9pc19zdGF0dXNfaW9fdGltZW91dCwKIH07CiAKIHN0cnVjdCBzbWJfdmVy
c2lvbl9vcGVyYXRpb25zIHNtYjMxMV9vcGVyYXRpb25zID0gewpAQCAtNTEzMCw2ICs1MTQ0LDcg
QEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzExX29wZXJhdGlvbnMgPSB7CiAJ
Lm1ha2Vfbm9kZSA9IHNtYjJfbWFrZV9ub2RlLAogCS5maWVtYXAgPSBzbWIzX2ZpZW1hcCwKIAku
bGxzZWVrID0gc21iM19sbHNlZWssCisJLmlzX3N0YXR1c19pb190aW1lb3V0ID0gc21iMl9pc19z
dGF0dXNfaW9fdGltZW91dCwKIH07CiAKIHN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMgc21iMjBf
dmFsdWVzID0gewotLSAKMi4yNS4xCgo=
--0000000000007d508105af905431--
