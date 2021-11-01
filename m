Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAF3C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Nov 2021 15:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC98460EFF
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Nov 2021 15:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhKAPde (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Nov 2021 11:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhKAPdd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Nov 2021 11:33:33 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88147C061714
        for <linux-cifs@vger.kernel.org>; Mon,  1 Nov 2021 08:30:59 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j2so37074524lfg.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 Nov 2021 08:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/CBJQiXdJTz3MD4t5Jl4/qdcRZDBnIgkrELfZLk/Ho=;
        b=F8GbiU0KpGN+d+6+nqN739rX8LsqYwH3ukkHIlIjGlxZtbqyOzDNrwCFJqW/VMXO+H
         Mg2pJf7CahMoX21mPqVMWFnbLl0Oe0/BqWr/8ohetXgxUVyhayLMDUp2OUYMBBDCPMhr
         WSRQJAtE2kPWM9pPYmqX52GinBRsBk4dCUkra14de9RY89+h4tcmswYo6pr6tEm0gog0
         QkBhUr9+Hyq7bfk/nltGsvYEapsRY3+DUy6hL5p4P1d+FQ4y6eOa4Y+DiyO4G0D4KVhU
         8qybN00N62CSCgJv6uu3zGttmIfKU2sy9p3/wd4xsuRmPBshWfbhFRPjPRAUVbBz721i
         Qa7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/CBJQiXdJTz3MD4t5Jl4/qdcRZDBnIgkrELfZLk/Ho=;
        b=LR8G8KdWD3a5vYKRJ6IsKJ1Gh1v5G0QUqX8IrRX5Su+NrMXSQ31+w5wv4jKQoZtBrq
         DqtAfwNJAKN7N/6Xa6WQW3V27znQwr7l5I3xNPMRYSA1JWIn5DPpDgUHj1Qv1pWtgVK3
         27EWnCmbrSuqk9qyiHoMbXd2OuQgkfSpqrZ/WDk6bIxhyOvHSwQO94hVYqavPlAGph9l
         IE5/ASaoMroPwoBQk9pKzIaGNRiDI7UaOcrbuwydTSYfJgDQ7HMtTufLYt2jN0wr/3Oh
         S+fqxlivOTL8IBAUA2uGYWe0isqGEKHvN2U1Ir4OFcuBqj2OC7CVHkW3/Si9De3g6HPL
         oeBQ==
X-Gm-Message-State: AOAM532WWFEelXpndloepTYRAtNCj9G3FKJwFeRhIMAssvL3VhCcu5P2
        56zo8d2xbrB2Y2IBiKZ1X39AHVNNqBEfEdEDGApJquVCsZQ=
X-Google-Smtp-Source: ABdhPJz3+OaYSUgQbRoZcQLqTQuyIsKU5w6gdfi/41eXJPNoD81qk4jSHee3zik30tgZCI4SWG3hTBA9VjgVgyr/9NA=
X-Received: by 2002:a05:6512:3dac:: with SMTP id k44mr7936718lfv.545.1635780657044;
 Mon, 01 Nov 2021 08:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qBKEj5Nz_5Vwj0WWL7-V_78j6Fry5OjvDXGCrejnsu3Q@mail.gmail.com>
 <CANT5p=ovLNLKwxsnik4pNkCbaznydWKAJz1AbBp6EhBy=nGTiQ@mail.gmail.com> <CAH2r5mvWb4s22yN5adjnw14HGR11Az47WLk+UfKH_axuiB5r8Q@mail.gmail.com>
In-Reply-To: <CAH2r5mvWb4s22yN5adjnw14HGR11Az47WLk+UfKH_axuiB5r8Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Nov 2021 10:30:46 -0500
Message-ID: <CAH2r5muQzQaNRziKEzd6tnBz8OO5uHrn4XocX6QzOVqeq14+hg@mail.gmail.com>
Subject: Re: [PATCH] cifs: for compound requests, use open handle if possible
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000fe978f05cfbbdc78"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fe978f05cfbbdc78
Content-Type: text/plain; charset="UTF-8"

Ran buildbot regression tests with the compounding patch and see
failure (failure is repeatable) with the full patch:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/812

but got it to pass with a smaller version of the same patch

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/814

See attached diff, and updated (smaller version) of patch

Fixing compounding to use existing open handle is important, but would
be useful to understand why this fails

On Thu, Oct 14, 2021 at 12:35 PM Steve French <smfrench@gmail.com> wrote:
>
> tentatively merged the two you posted today into for-next pending testing etc.
>
> On Thu, Oct 14, 2021 at 5:41 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Hi Steve,
> >
> > I don't think this patch was taken. Can we take this?
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34c44cf16b97ee71b6d07720199b97ed328e7c97.patch
> >
> > Regards,
> > Shyam
> >
> > On Fri, Jul 30, 2021 at 10:44 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > Hi Steve,
> > >
> > > Please review the patch.
> > > It fixes the issue of some compound requests unnecessarily breaking leases held by the same client.
> > >
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/pull/2/commits/34bf1885b26db09a60bc276ea1a3f798f4cbb05f.patch
> > >
> > > We saw this yesterday when testing with generic/013 xfstests with the multichannel fixes.
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000fe978f05cfbbdc78
Content-Type: text/x-patch; charset="US-ASCII"; name="compounding-patch-section-removed.diff"
Content-Disposition: attachment; 
	filename="compounding-patch-section-removed.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kvgtf9q20>
X-Attachment-Id: f_kvgtf9q20

MWMxCjwgRnJvbSA5ODc1NWEzNTQzYzA3OTljY2JmMmEzNWE5MjM2MWFkYzQ3ZDg0NGFiIE1vbiBT
ZXAgMTcgMDA6MDA6MDAgMjAwMQotLS0KPiBGcm9tIGFlMjcyZTM0YmZhMTA0OTU4MTMxNzEyNTYx
MDFhNDk4MjRkMTJkYzcgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCjE2LDE3YzE2LDE3CjwgIGZz
L2NpZnMvc21iMmlub2RlLmMgfCAzNCArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
CjwgIDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQotLS0K
PiAgZnMvY2lmcy9zbWIyaW5vZGUuYyB8IDQyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKSwgOSBkZWxl
dGlvbnMoLSkKMjBjMjAKPCBpbmRleCA4Mjk3NzAzNDkyZWUuLjY5YWViNTQ4NzNmNyAxMDA2NDQK
LS0tCj4gaW5kZXggODI5NzcwMzQ5MmVlLi5iZWVjNDJmZjJiZjkgMTAwNjQ0CjEwMiwxMDNjMTAy
LDEyOQo8IC0tIAo8IDIuMzIuMAotLS0KPiBAQCAtNjk2LDkgKzcxMSwxMiBAQCBzbWIyX2NyZWF0
ZV9oYXJkbGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29u
LAo+ICAJCSAgICAgY29uc3QgY2hhciAqZnJvbV9uYW1lLCBjb25zdCBjaGFyICp0b19uYW1lLAo+
ICAJCSAgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYikKPiAgewo+ICsJc3RydWN0IGNp
ZnNGaWxlSW5mbyAqY2ZpbGU7Cj4gKwo+ICsJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0Y29uLCBm
cm9tX25hbWUsIEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwo+ICAJcmV0dXJuIHNtYjJfc2V0X3BhdGhf
YXR0cih4aWQsIHRjb24sIGZyb21fbmFtZSwgdG9fbmFtZSwgY2lmc19zYiwKPiAgCQkJCSAgRklM
RV9SRUFEX0FUVFJJQlVURVMsIFNNQjJfT1BfSEFSRExJTkssCj4gLQkJCQkgIE5VTEwpOwo+ICsJ
CQkJICBjZmlsZSk7Cj4gIH0KPiAgCj4gIGludAo+IEBAIC03MDcsMTAgKzcyNSwxMiBAQCBzbWIy
X3NldF9wYXRoX3NpemUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwKPiAgCQkgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBib29sIHNldF9hbGxv
YykKPiAgewo+ICAJX19sZTY0IGVvZiA9IGNwdV90b19sZTY0KHNpemUpOwo+ICsJc3RydWN0IGNp
ZnNGaWxlSW5mbyAqY2ZpbGU7Cj4gIAo+ICsJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0Y29uLCBm
dWxsX3BhdGgsIEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwo+ICAJcmV0dXJuIHNtYjJfY29tcG91bmRf
b3AoeGlkLCB0Y29uLCBjaWZzX3NiLCBmdWxsX3BhdGgsCj4gIAkJCQlGSUxFX1dSSVRFX0RBVEEs
IEZJTEVfT1BFTiwgMCwgQUNMX05PX01PREUsCj4gLQkJCQkmZW9mLCBTTUIyX09QX1NFVF9FT0Ys
IE5VTEwpOwo+ICsJCQkJJmVvZiwgU01CMl9PUF9TRVRfRU9GLCBjZmlsZSk7Cj4gIH0KPiAgCj4g
IGludAo=
--000000000000fe978f05cfbbdc78
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-for-compound-requests-use-open-handle-if-possib.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-for-compound-requests-use-open-handle-if-possib.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvgtiep01>
X-Attachment-Id: f_kvgtiep01

RnJvbSA5ODc1NWEzNTQzYzA3OTljY2JmMmEzNWE5MjM2MWFkYzQ3ZDg0NGFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDMwIEp1bCAyMDIxIDA2OjQzOjA5ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogZm9yIGNvbXBvdW5kIHJlcXVlc3RzLCB1c2Ugb3BlbiBoYW5kbGUgaWYgcG9zc2libGUK
CkZvciBzbWIyX2NvbXBvdW5kX29wLCBpdCBpcyBwb3NzaWJsZSB0byBwYXNzIGEgcmVmIHRvCmFu
IGFscmVhZHkgb3BlbiBmaWxlLiBXZSBzaG91bGQgYmUgcGFzc2luZyBpdCB3aGVuZXZlciBwb3Nz
aWJsZS4KaS5lLiBpZiBhIG1hdGNoaW5nIGhhbmRsZSBpcyBhbHJlYWR5IGtlcHQgb3Blbi4KCklm
IHdlIGRvbid0IGRvIHRoYXQsIHdlIHdpbGwgZW5kIHVwIGJyZWFraW5nIGxlYXNlcyBmb3IgZmls
ZXMKa2VwdCBvcGVuIG9uIHRoZSBzYW1lIGNsaWVudC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFBy
YXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJpbm9kZS5jIHwgMzQg
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI3IGlu
c2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5v
ZGUuYyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKaW5kZXggODI5NzcwMzQ5MmVlLi42OWFlYjU0ODcz
ZjcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5v
ZGUuYwpAQCAtNDYsNiArNDYsMTAgQEAgc3RydWN0IGNvcF92YXJzIHsKIAlzdHJ1Y3Qgc21iMl9m
aWxlX2xpbmtfaW5mbyBsaW5rX2luZm87CiB9OwogCisvKgorICogbm90ZTogSWYgY2ZpbGUgaXMg
cGFzc2VkLCB0aGUgcmVmZXJlbmNlIHRvIGl0IGlzIGRyb3BwZWQgaGVyZS4KKyAqIFNvIG1ha2Ug
c3VyZSB0aGF0IHlvdSBkbyBub3QgcmV1c2UgY2ZpbGUgYWZ0ZXIgcmV0dXJuIGZyb20gdGhpcyBm
dW5jLgorICovCiBzdGF0aWMgaW50CiBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCSBzdHJ1Y3QgY2lmc19zYl9pbmZvICpj
aWZzX3NiLCBjb25zdCBjaGFyICpmdWxsX3BhdGgsCkBAIC01MzYsMTAgKzU0MCwxMSBAQCBzbWIy
X3F1ZXJ5X3BhdGhfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQljcmVhdGVfb3B0aW9ucyB8PSBPUEVOX1JFUEFSU0VfUE9JTlQ7CiAKIAkJLyog
RmFpbGVkIG9uIGEgc3ltYm9saWMgbGluayAtIHF1ZXJ5IGEgcmVwYXJzZSBwb2ludCBpbmZvICov
CisJCWNpZnNfZ2V0X3JlYWRhYmxlX3BhdGgodGNvbiwgZnVsbF9wYXRoLCAmY2ZpbGUpOwogCQly
YyA9IHNtYjJfY29tcG91bmRfb3AoeGlkLCB0Y29uLCBjaWZzX3NiLCBmdWxsX3BhdGgsCiAJCQkJ
ICAgICAgRklMRV9SRUFEX0FUVFJJQlVURVMsIEZJTEVfT1BFTiwKIAkJCQkgICAgICBjcmVhdGVf
b3B0aW9ucywgQUNMX05PX01PREUsCi0JCQkJICAgICAgc21iMl9kYXRhLCBTTUIyX09QX1FVRVJZ
X0lORk8sIE5VTEwpOworCQkJCSAgICAgIHNtYjJfZGF0YSwgU01CMl9PUF9RVUVSWV9JTkZPLCBj
ZmlsZSk7CiAJfQogCWlmIChyYykKIAkJZ290byBvdXQ7CkBAIC01ODcsMTAgKzU5MiwxMSBAQCBz
bWIzMTFfcG9zaXhfcXVlcnlfcGF0aF9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJCWNyZWF0ZV9vcHRpb25zIHw9IE9QRU5fUkVQQVJTRV9QT0lO
VDsKIAogCQkvKiBGYWlsZWQgb24gYSBzeW1ib2xpYyBsaW5rIC0gcXVlcnkgYSByZXBhcnNlIHBv
aW50IGluZm8gKi8KKwkJY2lmc19nZXRfcmVhZGFibGVfcGF0aCh0Y29uLCBmdWxsX3BhdGgsICZj
ZmlsZSk7CiAJCXJjID0gc21iMl9jb21wb3VuZF9vcCh4aWQsIHRjb24sIGNpZnNfc2IsIGZ1bGxf
cGF0aCwKIAkJCQkgICAgICBGSUxFX1JFQURfQVRUUklCVVRFUywgRklMRV9PUEVOLAogCQkJCSAg
ICAgIGNyZWF0ZV9vcHRpb25zLCBBQ0xfTk9fTU9ERSwKLQkJCQkgICAgICBzbWIyX2RhdGEsIFNN
QjJfT1BfUE9TSVhfUVVFUllfSU5GTywgTlVMTCk7CisJCQkJICAgICAgc21iMl9kYXRhLCBTTUIy
X09QX1BPU0lYX1FVRVJZX0lORk8sIGNmaWxlKTsKIAl9CiAJaWYgKHJjKQogCQlnb3RvIG91dDsK
QEAgLTYwOCwxMCArNjE0LDEzIEBAIHNtYjJfbWtkaXIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGlub2RlICpwYXJlbnRfaW5vZGUsIHVtb2RlX3QgbW9kZSwKIAkgICBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLCBjb25zdCBjaGFyICpuYW1lLAogCSAgIHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IpCiB7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7CisKKwljaWZzX2dldF93
cml0YWJsZV9wYXRoKHRjb24sIG5hbWUsIEZJTkRfV1JfQU5ZLCAmY2ZpbGUpOwogCXJldHVybiBz
bWIyX2NvbXBvdW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwgbmFtZSwKIAkJCQlGSUxFX1dSSVRF
X0FUVFJJQlVURVMsIEZJTEVfQ1JFQVRFLAogCQkJCUNSRUFURV9OT1RfRklMRSwgbW9kZSwgTlVM
TCwgU01CMl9PUF9NS0RJUiwKLQkJCQlOVUxMKTsKKwkJCQljZmlsZSk7CiB9CiAKIHZvaWQKQEAg
LTY0MiwxOCArNjUxLDI0IEBAIGludAogc21iMl9ybWRpcihjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBjaGFyICpuYW1lLAogCSAgIHN0cnVjdCBj
aWZzX3NiX2luZm8gKmNpZnNfc2IpCiB7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7CisK
KwljaWZzX2dldF93cml0YWJsZV9wYXRoKHRjb24sIG5hbWUsIEZJTkRfV1JfV0lUSF9ERUxFVEUs
ICZjZmlsZSk7CiAJcmV0dXJuIHNtYjJfY29tcG91bmRfb3AoeGlkLCB0Y29uLCBjaWZzX3NiLCBu
YW1lLCBERUxFVEUsIEZJTEVfT1BFTiwKIAkJCQlDUkVBVEVfTk9UX0ZJTEUsIEFDTF9OT19NT0RF
LAotCQkJCU5VTEwsIFNNQjJfT1BfUk1ESVIsIE5VTEwpOworCQkJCU5VTEwsIFNNQjJfT1BfUk1E
SVIsIGNmaWxlKTsKIH0KIAogaW50CiBzbWIyX3VubGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBjaGFyICpuYW1lLAogCSAgICBzdHJ1Y3Qg
Y2lmc19zYl9pbmZvICpjaWZzX3NiKQogeworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOwor
CisJY2lmc19nZXRfd3JpdGFibGVfcGF0aCh0Y29uLCBuYW1lLCBGSU5EX1dSX1dJVEhfREVMRVRF
LCAmY2ZpbGUpOwogCXJldHVybiBzbWIyX2NvbXBvdW5kX29wKHhpZCwgdGNvbiwgY2lmc19zYiwg
bmFtZSwgREVMRVRFLCBGSUxFX09QRU4sCiAJCQkJQ1JFQVRFX0RFTEVURV9PTl9DTE9TRSB8IE9Q
RU5fUkVQQVJTRV9QT0lOVCwKLQkJCQlBQ0xfTk9fTU9ERSwgTlVMTCwgU01CMl9PUF9ERUxFVEUs
IE5VTEwpOworCQkJCUFDTF9OT19NT0RFLCBOVUxMLCBTTUIyX09QX0RFTEVURSwgY2ZpbGUpOwog
fQogCiBzdGF0aWMgaW50Ci0tIAoyLjMyLjAKCg==
--000000000000fe978f05cfbbdc78--
