Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE4FC3A5A2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22D521897
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FkeQvs7K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfIDCZA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:25:00 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:39247 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfIDCZA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 22:25:00 -0400
Received: by mail-io1-f52.google.com with SMTP id d25so38195590iob.6
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 19:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=b9Oefijr97ob9N0SjnqspBlctoyErpMj+ykXifkNloY=;
        b=FkeQvs7KcaVc51+04eeuofL7499F1/wr3JIB7eZS+cvoo4U94YeqGsYrguYTg6QNcw
         QwfF/GQTj0hIYZZwVTy11m7E/V2HB99TdfcqxCXtdEB7vKFGYa0JccF3vLQvJG88q7Ew
         1g8rXxGcb4nglxj86x8xnwmU1tOTEo2vAjQIBPQrhFmrBF+Xcixbu/IVSib2hSq/nf9i
         TIT6jCB56gi7W4FJay67Tm0ydUuD9rXWHU31qaq97m5dfRG5lZ8bn4t601Tjqx1gbQP/
         KtkQRY7ITaYeGngwXJTdwEcq6UbnJ0Ma2pH6l7u6snZ3jg/u6z3oIF+4ubFA5JLoR7t5
         rIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b9Oefijr97ob9N0SjnqspBlctoyErpMj+ykXifkNloY=;
        b=FkbcKsSq/xD0puN4lEWqoKCtIpszrJ7Wk+SPppTlpDRe5fiMsCZI/ew+istYtlCIXj
         h5e0zhIlEqlW90T9dM/pzp0jxW2wwK2M/4fWA124p4HM8458eHARdzuTFgzGD38AxTjY
         a1TR+KhD5jCxS03NfUMmh9zV456uWeCF9h5Jdj9MwP337/3kOKJMlXG+YD7c2znYoZBE
         PzbT875yyD2q5agsqClel/F/qn0iiB07+KvheEqcfZpEQDrtIAk6IsEYX5tJ4xGRT/6A
         +iG2as7K5XQ4cp+KlvF964tg1QMBncC4EIbhAs5NSN5Ln1FXJcIbEPzb1LWzbtamY7gt
         tksA==
X-Gm-Message-State: APjAAAV8O9oQq4SumnQ/eKGJ27fDsZMllL4p3UlD8zkdFWpDT3X1HTlK
        K1wHeBrnRC+ZJwl6u1T53RYTea6x0pNXr3oyZzwTPAqCZ4c=
X-Google-Smtp-Source: APXvYqzUCmd/sl/b0IS9y7It6nY9Li3+OmD21RV72jJIVpaM7Sexh2xr770dZG1KDD2vaEPBqNVINnqK4ndY5KHenjQ=
X-Received: by 2002:a02:7f49:: with SMTP id r70mr37272119jac.85.1567563898607;
 Tue, 03 Sep 2019 19:24:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Sep 2019 21:24:47 -0500
Message-ID: <CAH2r5muznTsxD2BsyPBX8jfRP5SngyAYf-GFX-tEY+-1DfdMSg@mail.gmail.com>
Subject: [PATCH][SMB3] Allow skipping signing verification for perf sensitive
 use cases
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000057644b0591b0e9d3"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000057644b0591b0e9d3
Content-Type: text/plain; charset="UTF-8"

Add new mount option "signloosely" which enables signing but skips the
sometimes expensive signing checks in the responses (signatures are
calculated and sent correctly in the SMB2/SMB3 requests even with this
mount option but skipped in the responses).  Although weaker for security
(and also data integrity in case a packet were corrupted), this can provide
enough of a performance benefit (calculating the signature to verify a
packet can be expensive especially for large packets) to be useful in
some cases.


-- 
Thanks,

Steve

--00000000000057644b0591b0e9d3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-skipping-signature-verification-for-perf-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-skipping-signature-verification-for-perf-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k04n1dii0>
X-Attachment-Id: f_k04n1dii0

RnJvbSAyZWRmYWJjYjZlMzFlM2RlNTQzYTA2NmIzODg2ZjJkYjhkODRjZTQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMyBTZXAgMjAxOSAyMToxODo0OSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFsbG93IHNraXBwaW5nIHNpZ25hdHVyZSB2ZXJpZmljYXRpb24gZm9yIHBlcmYKIHNlbnNp
dGl2ZSBjb25maWd1cmF0aW9ucwoKQWRkIG5ldyBtb3VudCBvcHRpb24gInNpZ25sb29zZWx5IiB3
aGljaCBlbmFibGVzIHNpZ25pbmcgYnV0IHNraXBzIHRoZQpzb21ldGltZXMgZXhwZW5zaXZlIHNp
Z25pbmcgY2hlY2tzIGluIHRoZSByZXNwb25zZXMgKHNpZ25hdHVyZXMgYXJlCmNhbGN1bGF0ZWQg
YW5kIHNlbnQgY29ycmVjdGx5IGluIHRoZSBTTUIyL1NNQjMgcmVxdWVzdHMgZXZlbiB3aXRoIHRo
aXMKbW91bnQgb3B0aW9uIGJ1dCBza2lwcGVkIGluIHRoZSByZXNwb25zZXMpLiAgQWx0aG91Z2gg
d2Vha2VyIGZvciBzZWN1cml0eQooYW5kIGFsc28gZGF0YSBpbnRlZ3JpdHkgaW4gY2FzZSBhIHBh
Y2tldCB3ZXJlIGNvcnJ1cHRlZCksIHRoaXMgY2FuIHByb3ZpZGUKZW5vdWdoIG9mIGEgcGVyZm9y
bWFuY2UgYmVuZWZpdCAoY2FsY3VsYXRpbmcgdGhlIHNpZ25hdHVyZSB0byB2ZXJpZnkgYQpwYWNr
ZXQgY2FuIGJlIGV4cGVuc2l2ZSBlc3BlY2lhbGx5IGZvciBsYXJnZSBwYWNrZXRzKSB0byBiZSB1
c2VmdWwgaW4Kc29tZSBjYXNlcy4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggICAgICB8ICAyICsrCiBm
cy9jaWZzL2Nvbm5lY3QuYyAgICAgICB8IDEzICsrKysrKysrKystLS0KIGZzL2NpZnMvc21iMnRy
YW5zcG9ydC5jIHwgIDEgKwogMyBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lm
c2dsb2IuaAppbmRleCBmYTVhYmUzYTg1MTQuLmVkMzEyNjRmZWVhMyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNTQyLDYgKzU0Miw3
IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAl1bW9kZV90IGRpcl9tb2RlOwogCWVudW0gc2VjdXJpdHlF
bnVtIHNlY3R5cGU7IC8qIHNlY3R5cGUgcmVxdWVzdGVkIHZpYSBtbnQgb3B0cyAqLwogCWJvb2wg
c2lnbjsgLyogd2FzIHNpZ25pbmcgcmVxdWVzdGVkIHZpYSBtbnQgb3B0cz8gKi8KKwlib29sIGln
bm9yZV9zaWduYXR1cmU7CiAJYm9vbCByZXRyeToxOwogCWJvb2wgaW50cjoxOwogCWJvb2wgc2V0
dWlkczoxOwpAQCAtNjgxLDYgKzY4Miw3IEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gewogCWNo
YXIgc2VydmVyX0dVSURbMTZdOwogCV9fdTE2IHNlY19tb2RlOwogCWJvb2wgc2lnbjsgLyogaXMg
c2lnbmluZyBlbmFibGVkIG9uIHRoaXMgY29ubmVjdGlvbj8gKi8KKwlib29sIGlnbm9yZV9zaWdu
YXR1cmU7IC8qIHNraXAgdmFsaWRhdGlvbiBvZiBzaWduYXR1cmVzIGluIFNNQjIvMyByc3AgKi8K
IAlib29sIHNlc3Npb25fZXN0YWI7IC8qIG1hcmsgd2hlbiB2ZXJ5IGZpcnN0IHNlc3MgaXMgZXN0
YWJsaXNoZWQgKi8KIAlpbnQgZWNob19jcmVkaXRzOyAgLyogZWNobyByZXNlcnZlZCBzbG90cyAq
LwogCWludCBvcGxvY2tfY3JlZGl0czsgIC8qIG9wbG9jayBicmVhayByZXNlcnZlZCBzbG90cyAq
LwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRl
eCA4NWY4ZDk0M2EwNWEuLjE3ODgyY2VkZTE5NyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0
LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTkxLDcgKzkxLDcgQEAgZW51bSB7CiAJT3B0
X3NlcnZlcmlubywgT3B0X25vc2VydmVyaW5vLAogCU9wdF9yd3BpZGZvcndhcmQsIE9wdF9jaWZz
YWNsLCBPcHRfbm9jaWZzYWNsLAogCU9wdF9hY2wsIE9wdF9ub2FjbCwgT3B0X2xvY2FsbGVhc2Us
Ci0JT3B0X3NpZ24sIE9wdF9zZWFsLCBPcHRfbm9hYywKKwlPcHRfc2lnbiwgT3B0X2lnbm9yZV9z
aWduYXR1cmUsIE9wdF9zZWFsLCBPcHRfbm9hYywKIAlPcHRfZnNjLCBPcHRfbWZzeW1saW5rcywK
IAlPcHRfbXVsdGl1c2VyLCBPcHRfc2xvcHB5LCBPcHRfbm9zaGFyZXNvY2ssCiAJT3B0X3BlcnNp
c3RlbnQsIE9wdF9ub3BlcnNpc3RlbnQsCkBAIC0xODMsNiArMTgzLDcgQEAgc3RhdGljIGNvbnN0
IG1hdGNoX3RhYmxlX3QgY2lmc19tb3VudF9vcHRpb25fdG9rZW5zID0gewogCXsgT3B0X25vYWNs
LCAibm9hY2wiIH0sCiAJeyBPcHRfbG9jYWxsZWFzZSwgImxvY2FsbGVhc2UiIH0sCiAJeyBPcHRf
c2lnbiwgInNpZ24iIH0sCisJeyBPcHRfaWdub3JlX3NpZ25hdHVyZSwgInNpZ25sb29zZWx5IiB9
LAogCXsgT3B0X3NlYWwsICJzZWFsIiB9LAogCXsgT3B0X25vYWMsICJub2FjIiB9LAogCXsgT3B0
X2ZzYywgImZzYyIgfSwKQEAgLTE4NzcsNiArMTg3OCwxMCBAQCBjaWZzX3BhcnNlX21vdW50X29w
dGlvbnMoY29uc3QgY2hhciAqbW91bnRkYXRhLCBjb25zdCBjaGFyICpkZXZuYW1lLAogCQljYXNl
IE9wdF9zaWduOgogCQkJdm9sLT5zaWduID0gdHJ1ZTsKIAkJCWJyZWFrOworCQljYXNlIE9wdF9p
Z25vcmVfc2lnbmF0dXJlOgorCQkJdm9sLT5zaWduID0gdHJ1ZTsKKwkJCXZvbC0+aWdub3JlX3Np
Z25hdHVyZSA9IHRydWU7CisJCQlicmVhazsKIAkJY2FzZSBPcHRfc2VhbDoKIAkJCS8qIHdlIGRv
IG5vdCBkbyB0aGUgZm9sbG93aW5nIGluIHNlY0ZsYWdzIGJlY2F1c2Ugc2VhbAogCQkJICogaXMg
YSBwZXIgdHJlZSBjb25uZWN0aW9uIChtb3VudCkgbm90IGEgcGVyIHNvY2tldApAQCAtMjYwOCw2
ICsyNjEzLDkgQEAgc3RhdGljIGludCBtYXRjaF9zZXJ2ZXIoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLCBzdHJ1Y3Qgc21iX3ZvbCAqdm9sKQogCWlmIChzZXJ2ZXItPnJkbWEgIT0gdm9s
LT5yZG1hKQogCQlyZXR1cm4gMDsKIAorCWlmIChzZXJ2ZXItPmlnbm9yZV9zaWduYXR1cmUgIT0g
dm9sLT5pZ25vcmVfc2lnbmF0dXJlKQorCQlyZXR1cm4gMDsKKwogCXJldHVybiAxOwogfQogCkBA
IC0yNzg1LDcgKzI3OTMsNyBAQCBjaWZzX2dldF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qgc21iX3ZvbCAq
dm9sdW1lX2luZm8pCiAJdGNwX3Nlcy0+dGNwU3RhdHVzID0gQ2lmc05lZWROZWdvdGlhdGU7CiAK
IAl0Y3Bfc2VzLT5ucl90YXJnZXRzID0gMTsKLQorCXRjcF9zZXMtPmlnbm9yZV9zaWduYXR1cmUg
PSB2b2x1bWVfaW5mby0+aWdub3JlX3NpZ25hdHVyZTsKIAkvKiB0aHJlYWQgc3Bhd25lZCwgcHV0
IGl0IG9uIHRoZSBsaXN0ICovCiAJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAJbGlz
dF9hZGQoJnRjcF9zZXMtPnRjcF9zZXNfbGlzdCwgJmNpZnNfdGNwX3Nlc19saXN0KTsKQEAgLTMy
MzUsNyArMzI0Myw2IEBAIGNpZnNfZ2V0X3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyLCBzdHJ1Y3Qgc21iX3ZvbCAqdm9sdW1lX2luZm8pCiAKIAlzZXMtPnNlY3R5cGUgPSB2
b2x1bWVfaW5mby0+c2VjdHlwZTsKIAlzZXMtPnNpZ24gPSB2b2x1bWVfaW5mby0+c2lnbjsKLQog
CW11dGV4X2xvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CiAJcmMgPSBjaWZzX25lZ290aWF0ZV9w
cm90b2NvbCh4aWQsIHNlcyk7CiAJaWYgKCFyYykKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRy
YW5zcG9ydC5jIGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKaW5kZXggYjAyMjQyZWFjYjU1Li4x
NDhkNzk0MmM3OTYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCisrKyBiL2Zz
L2NpZnMvc21iMnRyYW5zcG9ydC5jCkBAIC01MjIsNiArNTIyLDcgQEAgc21iMl92ZXJpZnlfc2ln
bmF0dXJlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyKQogCWlmICgoc2hkci0+Q29tbWFuZCA9PSBTTUIyX05FR09USUFURSkgfHwKIAkgICAgKHNo
ZHItPkNvbW1hbmQgPT0gU01CMl9TRVNTSU9OX1NFVFVQKSB8fAogCSAgICAoc2hkci0+Q29tbWFu
ZCA9PSBTTUIyX09QTE9DS19CUkVBSykgfHwKKwkgICAgc2VydmVyLT5pZ25vcmVfc2lnbmF0dXJl
IHx8CiAJICAgICghc2VydmVyLT5zZXNzaW9uX2VzdGFiKSkKIAkJcmV0dXJuIDA7CiAKLS0gCjIu
MjAuMQoK
--00000000000057644b0591b0e9d3--
