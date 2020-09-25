Return-Path: <SRS0=Llk7=DC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66432C4363D
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 07:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B902235FA
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 07:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWh4P3T5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgIYHdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Sep 2020 03:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYHdr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Sep 2020 03:33:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5635EC0613CE
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2020 00:33:47 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z4so2445550wrr.4
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2020 00:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZqH9RVQbQo/+iLh8Xe4b9uNdTAPidEZ2lqSQIX7pnM=;
        b=MWh4P3T53SFqbGBh3XjXrUAyh2N1MxU6++xMhuJbxmqSD3P3QhhdnWDk80MrM6wHm8
         lPE45od5HeGtNNQSIjI51faz84uHba5Y6nZRbDaRBEVg43s1eFpHcEP9UpX5p3MDaWrA
         cRY4BqaPMrbtuH8VOJ3IY/yWTajBwqWkFv2V1kAHGL6D3iuqXJD8DsQQEhEm7uZbpiLo
         0sN2jd35zmbwG4oguLgwe0UsMN4RoLieH4mN99yxc1ZxhyJd6PmKKVxcgSZYgdPnSbI/
         em7mGPfx5CsVxOJ6p8K9fmlT+w84YYn2jIiWtojy1xQvrLb0hwHTIKTVHfO+LoGKfF72
         Ue8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZqH9RVQbQo/+iLh8Xe4b9uNdTAPidEZ2lqSQIX7pnM=;
        b=jMDrqwHi5OIEpr/NZ9k5RhlThy05VgQStIppyDn20Res7xMJRCX3MtcBHDV/DefUO0
         Zajg0uWJdI0QzMbUt6Q+YdU0USozUlDsOseseloLpzpqxl8rTIbrmWvKDueH5xYxvPWh
         BrizHC6EQnqJTgmXtF7cJhRfutJOKLa8qofVP4FQVgSULAX2Gu0ddQSklJ3W0Hu+4vqT
         OaiCIip9jubMaAFPI4n7RUGU/NQSm/0gj9VfU5Mo2ssOnQHmwE1ZPAHLvv1gwNdYOsZT
         ksjgY9s0n56TeO/le1xbjn3DcmSbYHNQkffoHiObabeZDjwImnBmy0rr9AMisrB4RiqL
         8oNQ==
X-Gm-Message-State: AOAM532s97Eq7jWeHD4oESQvEYOF6AtqfoVS3jtlFw7IoowBdsVxZzcg
        k0QSY7CCyUykAphB8f2OFc4oR00cLQ8N0seiR+Y=
X-Google-Smtp-Source: ABdhPJyR1GZC+nMcXY44/CfvjOceMqDqXURKirZTCCLVKrdTJlDz3UdXr+fNofNgefnYFvvZkF597boRvC80gqh+Rbw=
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr2859459wrn.43.1601019226086;
 Fri, 25 Sep 2020 00:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
 <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com> <CAH2r5mvZLCMtPVHFu1-Rb5EaP5-1ZiYFaNALm51e5Ui07x9taQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvZLCMtPVHFu1-Rb5EaP5-1ZiYFaNALm51e5Ui07x9taQ@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Fri, 25 Sep 2020 13:03:34 +0530
Message-ID: <CACdtm0bKJMuWPUisM8Ogfc8AH052-Y8Cgcdz5gNbVD2nLtJZ_w@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003fffd505b01e5623"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003fffd505b01e5623
Content-Type: text/plain; charset="UTF-8"

As this status code is returned when there is an internal
unavailability. So for any transaction, this status code can be
returned and EJUKEBOX check needs to be added at many places to
support this.

Respined the patch with signoff flag and attached.

On Fri, Sep 25, 2020 at 11:42 AM Steve French <smfrench@gmail.com> wrote:
>
> Ronnie also mentioned EJUKEBOX as a possibly better error mapping to
> return (and then check for).  EJUKEBOX implies waiting and then
> backoff.
>
> On Fri, Sep 18, 2020 at 1:20 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Fri, Sep 18, 2020 at 4:08 PM rohiths msft <rohiths.msft@gmail.com> wrote:
> > >
> > > Hi All,
> > >
> > > This fix is to handle STATUS_IO_TIMEOUT status code. This status code
> > > is returned by the server in case of unavailability(internal
> > > disconnects,etc) and is not treated by linux clients as retriable. So,
> > > this fix maps the status code as retriable error and also has a check
> > > to drop the connection to not overload the server.
> > >
> >
> > Do we need a new method for this? Wouldn't it be enough to just do the
> > remap-to-EAGAIN and have it handled as all other retryable errors?
> >
> >
> > > Regards,
> > > Rohith
>
>
>
> --
> Thanks,
>
> Steve

--0000000000003fffd505b01e5623
Content-Type: application/octet-stream; 
	name="0001-Handle-STATUS_IO_TIMEOUT-gracefully.patch"
Content-Disposition: attachment; 
	filename="0001-Handle-STATUS_IO_TIMEOUT-gracefully.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kfhxi1iz0>
X-Attachment-Id: f_kfhxi1iz0

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
aWxpdHkuCgpTaWduZWQtb2ZmLWJ5OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggICAgIHwgIDIgKysKIGZzL2NpZnMvY29u
bmVjdC5jICAgICAgfCAxNSArKysrKysrKysrKysrKy0KIGZzL2NpZnMvc21iMm1hcGVycm9yLmMg
fCAgMiArLQogZnMvY2lmcy9zbWIyb3BzLmMgICAgICB8IDE1ICsrKysrKysrKysrKysrKwogNCBm
aWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBiNTY1ZDgz
YmE4OWUuLjk5Y2IwZGVhMjVkMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBi
L2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNTEwLDYgKzUxMCw4IEBAIHN0cnVjdCBzbWJfdmVyc2lv
bl9vcGVyYXRpb25zIHsKIAkJICAgICAgc3RydWN0IGZpZW1hcF9leHRlbnRfaW5mbyAqLCB1NjQs
IHU2NCk7CiAJLyogdmVyc2lvbiBzcGVjaWZpYyBsbHNlZWsgaW1wbGVtZW50YXRpb24gKi8KIAls
b2ZmX3QgKCpsbHNlZWspKHN0cnVjdCBmaWxlICosIHN0cnVjdCBjaWZzX3Rjb24gKiwgbG9mZl90
LCBpbnQpOworCS8qIENoZWNrIGZvciBTVEFUVVNfSU9fVElNRU9VVCAqLworCWJvb2wgKCppc19z
dGF0dXNfaW9fdGltZW91dCkgKGNoYXIgKik7CiB9OwogCiBzdHJ1Y3Qgc21iX3ZlcnNpb25fdmFs
dWVzIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMK
aW5kZXggYTU3MzFkZDZlNjU2Li4xYTNiNzc5MzA5NWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29u
bmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC02OSw2ICs2OSw5IEBAIGV4dGVybiBi
b29sIGRpc2FibGVfbGVnYWN5X2RpYWxlY3RzOwogI2RlZmluZSBUTElOS19FUlJPUl9FWFBJUkUJ
KDEgKiBIWikKICNkZWZpbmUgVExJTktfSURMRV9FWFBJUkUJKDYwMCAqIEhaKQogCisvKiBEcm9w
IHRoZSBjb25uZWN0aW9uIHRvIG5vdCBvdmVybG9hZCB0aGUgc2VydmVyICovCisjZGVmaW5lIE5V
TV9TVEFUVVNfSU9fVElNRU9VVCAgIDUKKwogZW51bSB7CiAJLyogTW91bnQgb3B0aW9ucyB0aGF0
IHRha2Ugbm8gYXJndW1lbnRzICovCiAJT3B0X3VzZXJfeGF0dHIsIE9wdF9ub3VzZXJfeGF0dHIs
CkBAIC0xMTE3LDcgKzExMjAsNyBAQCBjaWZzX2RlbXVsdGlwbGV4X3RocmVhZCh2b2lkICpwKQog
CXN0cnVjdCB0YXNrX3N0cnVjdCAqdGFza190b193YWtlID0gTlVMTDsKIAlzdHJ1Y3QgbWlkX3Ff
ZW50cnkgKm1pZHNbTUFYX0NPTVBPVU5EXTsKIAljaGFyICpidWZzW01BWF9DT01QT1VORF07Ci0J
dW5zaWduZWQgaW50IG5vcmVjbGFpbV9mbGFnOworCXVuc2lnbmVkIGludCBub3JlY2xhaW1fZmxh
ZywgbnVtX2lvX3RpbWVvdXQgPSAwOwogCiAJbm9yZWNsYWltX2ZsYWcgPSBtZW1hbGxvY19ub3Jl
Y2xhaW1fc2F2ZSgpOwogCWNpZnNfZGJnKEZZSSwgIkRlbXVsdGlwbGV4IFBJRDogJWRcbiIsIHRh
c2tfcGlkX25yKGN1cnJlbnQpKTsKQEAgLTEyMTMsNiArMTIxNiwxNiBAQCBjaWZzX2RlbXVsdGlw
bGV4X3RocmVhZCh2b2lkICpwKQogCQkJY29udGludWU7CiAJCX0KIAorCQlpZiAoc2VydmVyLT5v
cHMtPmlzX3N0YXR1c19pb190aW1lb3V0ICYmCisJCSAgICBzZXJ2ZXItPm9wcy0+aXNfc3RhdHVz
X2lvX3RpbWVvdXQoYnVmKSkgeworCQkJbnVtX2lvX3RpbWVvdXQrKzsKKwkJCWlmIChudW1faW9f
dGltZW91dCA+IE5VTV9TVEFUVVNfSU9fVElNRU9VVCkgeworCQkJCWNpZnNfcmVjb25uZWN0KHNl
cnZlcik7CisJCQkJbnVtX2lvX3RpbWVvdXQgPSAwOworCQkJCWNvbnRpbnVlOworCQkJfQorCQl9
CisKIAkJc2VydmVyLT5sc3RycCA9IGppZmZpZXM7CiAKIAkJZm9yIChpID0gMDsgaSA8IG51bV9t
aWRzOyBpKyspIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMgYi9mcy9jaWZz
L3NtYjJtYXBlcnJvci5jCmluZGV4IDdmZGUzNzc1Y2I1Ny4uYjAwNGNmODc2OTJhIDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJtYXBlcnJvci5jCisrKyBiL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMK
QEAgLTQ4OCw3ICs0ODgsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN0YXR1c190b19wb3NpeF9l
cnJvciBzbWIyX2Vycm9yX21hcF90YWJsZVtdID0gewogCXtTVEFUVVNfUElQRV9DT05ORUNURUQs
IC1FSU8sICJTVEFUVVNfUElQRV9DT05ORUNURUQifSwKIAl7U1RBVFVTX1BJUEVfTElTVEVOSU5H
LCAtRUlPLCAiU1RBVFVTX1BJUEVfTElTVEVOSU5HIn0sCiAJe1NUQVRVU19JTlZBTElEX1JFQURf
TU9ERSwgLUVJTywgIlNUQVRVU19JTlZBTElEX1JFQURfTU9ERSJ9LAotCXtTVEFUVVNfSU9fVElN
RU9VVCwgLUVUSU1FRE9VVCwgIlNUQVRVU19JT19USU1FT1VUIn0sCisJe1NUQVRVU19JT19USU1F
T1VULCAtRUFHQUlOLCAiU1RBVFVTX0lPX1RJTUVPVVQifSwKIAl7U1RBVFVTX0ZJTEVfRk9SQ0VE
X0NMT1NFRCwgLUVJTywgIlNUQVRVU19GSUxFX0ZPUkNFRF9DTE9TRUQifSwKIAl7U1RBVFVTX1BS
T0ZJTElOR19OT1RfU1RBUlRFRCwgLUVJTywgIlNUQVRVU19QUk9GSUxJTkdfTk9UX1NUQVJURUQi
fSwKIAl7U1RBVFVTX1BST0ZJTElOR19OT1RfU1RPUFBFRCwgLUVJTywgIlNUQVRVU19QUk9GSUxJ
TkdfTk9UX1NUT1BQRUQifSwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lm
cy9zbWIyb3BzLmMKaW5kZXggMzJmOTBkYzgyYzg0Li44OGY3NjJhOTIxYjkgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0yMzQ2LDYgKzIz
NDYsMTcgQEAgc21iMl9pc19zZXNzaW9uX2V4cGlyZWQoY2hhciAqYnVmKQogCXJldHVybiB0cnVl
OwogfQogCitzdGF0aWMgYm9vbAorc21iMl9pc19zdGF0dXNfaW9fdGltZW91dChjaGFyICpidWYp
Cit7CisJc3RydWN0IHNtYjJfc3luY19oZHIgKnNoZHIgPSAoc3RydWN0IHNtYjJfc3luY19oZHIg
KilidWY7CisKKwlpZiAoc2hkci0+U3RhdHVzID09IFNUQVRVU19JT19USU1FT1VUKQorCQlyZXR1
cm4gdHJ1ZTsKKwllbHNlCisJCXJldHVybiBmYWxzZTsKK30KKwogc3RhdGljIGludAogc21iMl9v
cGxvY2tfcmVzcG9uc2Uoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IGNpZnNfZmlkICpm
aWQsCiAJCSAgICAgc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZSkKQEAgLTQ4MDksNiArNDgy
MCw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIwX29wZXJhdGlvbnMgPSB7
CiAJLm1ha2Vfbm9kZSA9IHNtYjJfbWFrZV9ub2RlLAogCS5maWVtYXAgPSBzbWIzX2ZpZW1hcCwK
IAkubGxzZWVrID0gc21iM19sbHNlZWssCisJLmlzX3N0YXR1c19pb190aW1lb3V0ID0gc21iMl9p
c19zdGF0dXNfaW9fdGltZW91dCwKIH07CiAKIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25z
IHNtYjIxX29wZXJhdGlvbnMgPSB7CkBAIC00OTA5LDYgKzQ5MjEsNyBAQCBzdHJ1Y3Qgc21iX3Zl
cnNpb25fb3BlcmF0aW9ucyBzbWIyMV9vcGVyYXRpb25zID0gewogCS5tYWtlX25vZGUgPSBzbWIy
X21ha2Vfbm9kZSwKIAkuZmllbWFwID0gc21iM19maWVtYXAsCiAJLmxsc2VlayA9IHNtYjNfbGxz
ZWVrLAorCS5pc19zdGF0dXNfaW9fdGltZW91dCA9IHNtYjJfaXNfc3RhdHVzX2lvX3RpbWVvdXQs
CiB9OwogCiBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMF9vcGVyYXRpb25zID0g
ewpAQCAtNTAxOSw2ICs1MDMyLDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21i
MzBfb3BlcmF0aW9ucyA9IHsKIAkubWFrZV9ub2RlID0gc21iMl9tYWtlX25vZGUsCiAJLmZpZW1h
cCA9IHNtYjNfZmllbWFwLAogCS5sbHNlZWsgPSBzbWIzX2xsc2VlaywKKwkuaXNfc3RhdHVzX2lv
X3RpbWVvdXQgPSBzbWIyX2lzX3N0YXR1c19pb190aW1lb3V0LAogfTsKIAogc3RydWN0IHNtYl92
ZXJzaW9uX29wZXJhdGlvbnMgc21iMzExX29wZXJhdGlvbnMgPSB7CkBAIC01MTMwLDYgKzUxNDQs
NyBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMTFfb3BlcmF0aW9ucyA9IHsK
IAkubWFrZV9ub2RlID0gc21iMl9tYWtlX25vZGUsCiAJLmZpZW1hcCA9IHNtYjNfZmllbWFwLAog
CS5sbHNlZWsgPSBzbWIzX2xsc2VlaywKKwkuaXNfc3RhdHVzX2lvX3RpbWVvdXQgPSBzbWIyX2lz
X3N0YXR1c19pb190aW1lb3V0LAogfTsKIAogc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVlcyBzbWIy
MF92YWx1ZXMgPSB7Ci0tIAoyLjI1LjEKCg==
--0000000000003fffd505b01e5623--
