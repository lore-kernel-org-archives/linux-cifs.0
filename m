Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14163C3A5A2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D322322CEA
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZLAYut+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfIDC7M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:59:12 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:44851 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbfIDC7M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 22:59:12 -0400
Received: by mail-io1-f45.google.com with SMTP id j4so40820090iog.11
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 19:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovjwrf0iKT3DE6Uc1ak5RX9akpPb019cUWCHAzal2ss=;
        b=IZLAYut+R9mlWWWNZIDvciUu3Xx2JhobC8pURc51951do36Kdas66D538BdbOcl5ll
         u4Byd5aFr5/4tTpvD5VjKD58EUI4s/QLL8ZNqoeS6/K/C8IANiIerwj2JCnW3kgsdgLf
         f+exHsHRn9mJKwCVFOf4OkslZaf5yBe6OzPh3hzlgmB0/Mf4ErtXhJmGig7H491kO3Gp
         GORe3zFr/fnYJAMjFw6kEn0Wjv8bWWeDpVRw5QJn3+WHTRqmNLxFqtz4SqvLGqhGVhiX
         hM9qcKCiAWmH44JKv+/aX4EealL0gYfMCpByIMK9zvKapH8xfTRG0vGMJqDYzm0X2q0A
         iPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovjwrf0iKT3DE6Uc1ak5RX9akpPb019cUWCHAzal2ss=;
        b=XnNajKk54ua5ZDdb8PDktaTDFIElTdxcsgNdkzJQzYtmGkC1Yx8PHVADiDxREGx+pp
         +SyGD3Aq92wV83AX43H8SGGE7Ab8y5uYfwfAhSZFQTOMcZpf2GoKP94XuNO36UkjGHyX
         JTlI5gLHbj3904vHkJnJ4oKYFCA7FENrZQ9HRsYDSKGTHjsl10fNzlVrHKDcXtrGXXgY
         OCXoe9x6ZTxS+VURSad3ceDhfVL7PNn64Ttek4B9oYFlK/9huiEDvxhVs2hHlP45XPjk
         ghnz1VD6qDdl8i9sKiptR2U0efjosFp4I9+TBn/jim/wytrr5XjNotfp5MsQsBbAuYTx
         t8ng==
X-Gm-Message-State: APjAAAXy6DvgGBMoVaRaJ/OhhiaDTLHRtkanul0UUmiwV/Kwwp/IxdAX
        vecaWw9T7uT1RaQ8kSEQzBgLMcQBhTG0xhgYa/k=
X-Google-Smtp-Source: APXvYqxMhZcC6+M4fgfiSbyiBLLH0Ths+Q8ucv+UC3/tipH/zv6lqVQuNGmJyl8IvNgUpMX/P6Ms6rKMqLAzWPM+Ims=
X-Received: by 2002:a6b:6303:: with SMTP id p3mr1947858iog.169.1567565950849;
 Tue, 03 Sep 2019 19:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muznTsxD2BsyPBX8jfRP5SngyAYf-GFX-tEY+-1DfdMSg@mail.gmail.com>
 <CAN05THTAvysJEiXp3mXaxTSzZOyRSd3y22Pw2MMJe8gQXdwZhQ@mail.gmail.com> <CAH2r5msuaE_nuEBzxN0LLpriQzv8fYuBkZDUMo09eFqzyfUf9w@mail.gmail.com>
In-Reply-To: <CAH2r5msuaE_nuEBzxN0LLpriQzv8fYuBkZDUMo09eFqzyfUf9w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Sep 2019 21:58:59 -0500
Message-ID: <CAH2r5mv9UTz8CPWz1B3Rk-NdCziX-JmBieNypF9vgoV9T=Bwow@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Allow skipping signing verification for perf
 sensitive use cases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ad596c0591b1630d"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ad596c0591b1630d
Content-Type: text/plain; charset="UTF-8"

Updated patch


On Tue, Sep 3, 2019 at 9:53 PM Steve French <smfrench@gmail.com> wrote:
>
> Ok. Will fix the bool. I don't think it belongs in mount mask since it is a server not superblock parm
>
> On Tue, Sep 3, 2019, 21:37 ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>> Change
>> bool ignore_signature;
>> to
>> bool ignore_signature:1;
>>
>> And shouldn't this be part of CIFS_MOUNT_MASK too ?
>>
>>
>> On Wed, Sep 4, 2019 at 12:25 PM Steve French <smfrench@gmail.com> wrote:
>> >
>> > Add new mount option "signloosely" which enables signing but skips the
>> > sometimes expensive signing checks in the responses (signatures are
>> > calculated and sent correctly in the SMB2/SMB3 requests even with this
>> > mount option but skipped in the responses).  Although weaker for security
>> > (and also data integrity in case a packet were corrupted), this can provide
>> > enough of a performance benefit (calculating the signature to verify a
>> > packet can be expensive especially for large packets) to be useful in
>> > some cases.
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve



-- 
Thanks,

Steve

--000000000000ad596c0591b1630d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-skipping-signature-verification-for-perf-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-skipping-signature-verification-for-perf-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k04oa9zc0>
X-Attachment-Id: f_k04oa9zc0

RnJvbSA4YWI4ZGJlMjY0NzdkMGFmOGFmNmJmN2I4YWU1ZGYxNTk0YzZjZmEwIE1vbiBTZXAgMTcg
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
Y2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJA
cmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggICAgICB8ICAyICsrCiBmcy9jaWZz
L2Nvbm5lY3QuYyAgICAgICB8IDEzICsrKysrKysrKystLS0KIGZzL2NpZnMvc21iMnRyYW5zcG9y
dC5jIHwgIDEgKwogMyBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2Iu
aAppbmRleCBmYTVhYmUzYTg1MTQuLjFmNTNkZWUyMTFkOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNTQyLDYgKzU0Miw3IEBAIHN0
cnVjdCBzbWJfdm9sIHsKIAl1bW9kZV90IGRpcl9tb2RlOwogCWVudW0gc2VjdXJpdHlFbnVtIHNl
Y3R5cGU7IC8qIHNlY3R5cGUgcmVxdWVzdGVkIHZpYSBtbnQgb3B0cyAqLwogCWJvb2wgc2lnbjsg
Lyogd2FzIHNpZ25pbmcgcmVxdWVzdGVkIHZpYSBtbnQgb3B0cz8gKi8KKwlib29sIGlnbm9yZV9z
aWduYXR1cmU6MTsKIAlib29sIHJldHJ5OjE7CiAJYm9vbCBpbnRyOjE7CiAJYm9vbCBzZXR1aWRz
OjE7CkBAIC02ODEsNiArNjgyLDcgQEAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyB7CiAJY2hhciBz
ZXJ2ZXJfR1VJRFsxNl07CiAJX191MTYgc2VjX21vZGU7CiAJYm9vbCBzaWduOyAvKiBpcyBzaWdu
aW5nIGVuYWJsZWQgb24gdGhpcyBjb25uZWN0aW9uPyAqLworCWJvb2wgaWdub3JlX3NpZ25hdHVy
ZToxOyAvKiBza2lwIHZhbGlkYXRpb24gb2Ygc2lnbmF0dXJlcyBpbiBTTUIyLzMgcnNwICovCiAJ
Ym9vbCBzZXNzaW9uX2VzdGFiOyAvKiBtYXJrIHdoZW4gdmVyeSBmaXJzdCBzZXNzIGlzIGVzdGFi
bGlzaGVkICovCiAJaW50IGVjaG9fY3JlZGl0czsgIC8qIGVjaG8gcmVzZXJ2ZWQgc2xvdHMgKi8K
IAlpbnQgb3Bsb2NrX2NyZWRpdHM7ICAvKiBvcGxvY2sgYnJlYWsgcmVzZXJ2ZWQgc2xvdHMgKi8K
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
ODVmOGQ5NDNhMDVhLi4xNzg4MmNlZGUxOTcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC05MSw3ICs5MSw3IEBAIGVudW0gewogCU9wdF9z
ZXJ2ZXJpbm8sIE9wdF9ub3NlcnZlcmlubywKIAlPcHRfcndwaWRmb3J3YXJkLCBPcHRfY2lmc2Fj
bCwgT3B0X25vY2lmc2FjbCwKIAlPcHRfYWNsLCBPcHRfbm9hY2wsIE9wdF9sb2NhbGxlYXNlLAot
CU9wdF9zaWduLCBPcHRfc2VhbCwgT3B0X25vYWMsCisJT3B0X3NpZ24sIE9wdF9pZ25vcmVfc2ln
bmF0dXJlLCBPcHRfc2VhbCwgT3B0X25vYWMsCiAJT3B0X2ZzYywgT3B0X21mc3ltbGlua3MsCiAJ
T3B0X211bHRpdXNlciwgT3B0X3Nsb3BweSwgT3B0X25vc2hhcmVzb2NrLAogCU9wdF9wZXJzaXN0
ZW50LCBPcHRfbm9wZXJzaXN0ZW50LApAQCAtMTgzLDYgKzE4Myw3IEBAIHN0YXRpYyBjb25zdCBt
YXRjaF90YWJsZV90IGNpZnNfbW91bnRfb3B0aW9uX3Rva2VucyA9IHsKIAl7IE9wdF9ub2FjbCwg
Im5vYWNsIiB9LAogCXsgT3B0X2xvY2FsbGVhc2UsICJsb2NhbGxlYXNlIiB9LAogCXsgT3B0X3Np
Z24sICJzaWduIiB9LAorCXsgT3B0X2lnbm9yZV9zaWduYXR1cmUsICJzaWdubG9vc2VseSIgfSwK
IAl7IE9wdF9zZWFsLCAic2VhbCIgfSwKIAl7IE9wdF9ub2FjLCAibm9hYyIgfSwKIAl7IE9wdF9m
c2MsICJmc2MiIH0sCkBAIC0xODc3LDYgKzE4NzgsMTAgQEAgY2lmc19wYXJzZV9tb3VudF9vcHRp
b25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAqZGV2bmFtZSwKIAkJY2FzZSBP
cHRfc2lnbjoKIAkJCXZvbC0+c2lnbiA9IHRydWU7CiAJCQlicmVhazsKKwkJY2FzZSBPcHRfaWdu
b3JlX3NpZ25hdHVyZToKKwkJCXZvbC0+c2lnbiA9IHRydWU7CisJCQl2b2wtPmlnbm9yZV9zaWdu
YXR1cmUgPSB0cnVlOworCQkJYnJlYWs7CiAJCWNhc2UgT3B0X3NlYWw6CiAJCQkvKiB3ZSBkbyBu
b3QgZG8gdGhlIGZvbGxvd2luZyBpbiBzZWNGbGFncyBiZWNhdXNlIHNlYWwKIAkJCSAqIGlzIGEg
cGVyIHRyZWUgY29ubmVjdGlvbiAobW91bnQpIG5vdCBhIHBlciBzb2NrZXQKQEAgLTI2MDgsNiAr
MjYxMyw5IEBAIHN0YXRpYyBpbnQgbWF0Y2hfc2VydmVyKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlciwgc3RydWN0IHNtYl92b2wgKnZvbCkKIAlpZiAoc2VydmVyLT5yZG1hICE9IHZvbC0+
cmRtYSkKIAkJcmV0dXJuIDA7CiAKKwlpZiAoc2VydmVyLT5pZ25vcmVfc2lnbmF0dXJlICE9IHZv
bC0+aWdub3JlX3NpZ25hdHVyZSkKKwkJcmV0dXJuIDA7CisKIAlyZXR1cm4gMTsKIH0KIApAQCAt
Mjc4NSw3ICsyNzkzLDcgQEAgY2lmc19nZXRfdGNwX3Nlc3Npb24oc3RydWN0IHNtYl92b2wgKnZv
bHVtZV9pbmZvKQogCXRjcF9zZXMtPnRjcFN0YXR1cyA9IENpZnNOZWVkTmVnb3RpYXRlOwogCiAJ
dGNwX3Nlcy0+bnJfdGFyZ2V0cyA9IDE7Ci0KKwl0Y3Bfc2VzLT5pZ25vcmVfc2lnbmF0dXJlID0g
dm9sdW1lX2luZm8tPmlnbm9yZV9zaWduYXR1cmU7CiAJLyogdGhyZWFkIHNwYXduZWQsIHB1dCBp
dCBvbiB0aGUgbGlzdCAqLwogCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWxpc3Rf
YWRkKCZ0Y3Bfc2VzLT50Y3Bfc2VzX2xpc3QsICZjaWZzX3RjcF9zZXNfbGlzdCk7CkBAIC0zMjM1
LDcgKzMyNDMsNiBAQCBjaWZzX2dldF9zbWJfc2VzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNl
cnZlciwgc3RydWN0IHNtYl92b2wgKnZvbHVtZV9pbmZvKQogCiAJc2VzLT5zZWN0eXBlID0gdm9s
dW1lX2luZm8tPnNlY3R5cGU7CiAJc2VzLT5zaWduID0gdm9sdW1lX2luZm8tPnNpZ247Ci0KIAlt
dXRleF9sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOwogCXJjID0gY2lmc19uZWdvdGlhdGVfcHJv
dG9jb2woeGlkLCBzZXMpOwogCWlmICghcmMpCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJ0cmFu
c3BvcnQuYyBiL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCmluZGV4IGIwMjI0MmVhY2I1NS4uMTQ4
ZDc5NDJjNzk2IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYworKysgYi9mcy9j
aWZzL3NtYjJ0cmFuc3BvcnQuYwpAQCAtNTIyLDYgKzUyMiw3IEBAIHNtYjJfdmVyaWZ5X3NpZ25h
dHVyZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZl
cikKIAlpZiAoKHNoZHItPkNvbW1hbmQgPT0gU01CMl9ORUdPVElBVEUpIHx8CiAJICAgIChzaGRy
LT5Db21tYW5kID09IFNNQjJfU0VTU0lPTl9TRVRVUCkgfHwKIAkgICAgKHNoZHItPkNvbW1hbmQg
PT0gU01CMl9PUExPQ0tfQlJFQUspIHx8CisJICAgIHNlcnZlci0+aWdub3JlX3NpZ25hdHVyZSB8
fAogCSAgICAoIXNlcnZlci0+c2Vzc2lvbl9lc3RhYikpCiAJCXJldHVybiAwOwogCi0tIAoyLjIw
LjEKCg==
--000000000000ad596c0591b1630d--
