Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500BDC0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 19:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07AEB2075C
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 19:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpE6DwWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfGFTn2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 15:43:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40137 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfGFTn2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 15:43:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so5674592pfp.7
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jul 2019 12:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FmN4yILHrfN6FiYTx0Svu6VjNrg8gMXOxqvNNT+xLxo=;
        b=jpE6DwWdlpCHX0dVZvCAEb3rCJAcHoJj3/i/eQ7pX7wHwRONLAj16KGwc2VlrhMoRB
         N5TtB76q8xnVZhkAdz3c2AWvDI17fHfpT2kD8BCR0yphZn+ywxfyCb8et/pb6ceOh/Jq
         a8IH3v0yKAhqEltmYLeXQw1W+rNKAnODaRYMavYx0SZvoT8bP7eDbcTsH/vrwSfHE2ZX
         W6+FjKYnhz8yTNsoEiWZUUqTbPyvtZTZnm/B/J2AOP5wKWmQXYJWJu/9sdu4HIlGz2GC
         +5gYt0GZoOewMxZPzO53h4dXRJuQg6o0RyfSJy0UMCNQcC/AbaDvn/zXQWAByKl2SJ0R
         pFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FmN4yILHrfN6FiYTx0Svu6VjNrg8gMXOxqvNNT+xLxo=;
        b=gfXAvOpYEV1Kytr75Vl2ONhJXg7Vhgch+PQwdYEhUn18wmRf8nrFSw/Atpd47+dZ/V
         yHNE6MgqgSnTj+bYefXWGbfV7iLLmLDRW4EcrpLJFDVPYH0yjIevG83RsHIqlqg8cJNo
         WwzVY09TqHXE4zrr0pxIt0jNhqrBkEihPsJJEuBTSvAToc/9/BssaE+5S99fqmuaCMcz
         tZn5AG08OwGJoyyI9McLoUYrcZz1ZseWirgUm7RI8Zqg+Kn09H9Mrl5qHntizEDrCcIR
         lKs1GX3jXQy9FvkzvRjEg9PABixuyP2Od66pm00GVPgxSe00fvShW/A48AS33l+9tO9x
         tbNg==
X-Gm-Message-State: APjAAAX8hl1vAHTTgTMFYjv4WoQ7XgBtlMUy42whA6Qkroz+fFm/Ozlc
        9ezLtBjS+n96AGzh7/97ii8Et72gHvy6BuLSxjg=
X-Google-Smtp-Source: APXvYqyIyE/P95CXbeN+x1sJEE8mzPR5G7ijc5nuXKNBx8me3PVERK5TRUT14uEf3CrA+HSQsjg1G7YetLBLDFQ/B/0=
X-Received: by 2002:a63:500e:: with SMTP id e14mr12648338pgb.11.1562442206965;
 Sat, 06 Jul 2019 12:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtb_g1Hx4UPB+5XpSY3Ew_fn=bdjLnpRD=ZQymJxrUw0g@mail.gmail.com>
 <CAKywueQu8idf6120LybjsNwHqy7MOnXMcm=e8ug=UtiU4u0zWA@mail.gmail.com>
In-Reply-To: <CAKywueQu8idf6120LybjsNwHqy7MOnXMcm=e8ug=UtiU4u0zWA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Jul 2019 14:43:15 -0500
Message-ID: <CAH2r5msanfdnnpaaWR2oqu+x9UXKoE6uLvF0WneZj1yiwRegRw@mail.gmail.com>
Subject: Re: [PATCH] Improve performance of POSIX open - request query disk id
 open context
To:     Pavel Shilovsky <pavel.shilovsky@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000ba935d058d086c4a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ba935d058d086c4a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

minor updates to incorporate Pavel's suggestions


On Sat, Jul 6, 2019 at 11:34 AM Pavel Shilovsky
<pavel.shilovsky@gmail.com> wrote:
>
> Good idea! See some comments below.
>
> When adding new context, the following defines need to be changed:
>
> 689 /*
> 690  * Maximum size of a SMB2_CREATE response is 64 (smb2 header) +
> 691  * 88 (fixed part of create response) + 520 (path) + 150 (contexts) +
> 692  * 2 bytes of padding.
> 693  */
> 694 #define MAX_SMB2_CREATE_RESPONSE_SIZE 824
>
> and
>
> 657 /*
> 658  * Maximum number of iovs we need for an open/create request.
> 659  * [0] : struct smb2_create_req
> 660  * [1] : path
> 661  * [2] : lease context
> 662  * [3] : durable context
> 663  * [4] : posix context
> 664  * [5] : time warp context
> 665  * [6] : compound padding
> 666  */
> 667 #define SMB2_CREATE_IOV_SIZE 7
>
> +       if (n_iov > 2) {
> +               struct create_context *ccontext =3D
> +                       (struct create_context *)iov[n_iov-1].iov_base;
> +               ccontext->Next =3D cpu_to_le32(iov[n_iov-1].iov_len);
> +       }
> +       add_query_id_context(iov, &n_iov);
>
> I think we should add a check if iov has enough capacity to keep all
> the contexts. Right now it will oops if it wasn't allocated right in
> the upper layer.
>
> In general, I think having a complete patch that adds the whole
> functionality is better for future git bisect and looks more logical
> instead of breaking such small features into parts.
>
> Best regards,
> Pavel Shilovskiy
>
> =D0=BF=D1=82, 5 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 23:14, Steve Fren=
ch via samba-technical
> <samba-technical@lists.samba.org>:
> >
> > We can cut the number of roundtrips on open (may also
> > help some rename cases as well) by returning the inode
> > number in the SMB2 open request itself instead of
> > querying it afterwards via a query FILE_INTERNAL_INFO.
> > This should significantly improve the performance of
> > posix open.
> >
> > Add SMB2_CREATE_QUERY_ON_DISK_ID create context request
> > on open calls so that when server supports this we
> > can save a roundtrip for QUERY_INFO on every open.
> >
> > Follow on patch will add the response processing for
> > SMB2_CREATE_QUERY_ON_DISK_ID context and optimize
> > smb2_open_file to avoid the extra network roundtrip
> > on every posix open. This patch adds the context on
> > SMB2/SMB3 open requests.
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--000000000000ba935d058d086c4a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-query-inode-number-on-open-via-create-context.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-query-inode-number-on-open-via-create-context.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxrxqo9n0>
X-Attachment-Id: f_jxrxqo9n0

RnJvbSAyNmUyYWM5NDc2OTI1ZjllMmU2NzMwNmRmNjI4ZWZhZDAwMjU3MTJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgNiBKdWwgMjAxOSAxNDo0MTozOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IHF1ZXJ5IGlub2RlIG51bWJlciBvbiBvcGVuIHZpYSBjcmVhdGUgY29udGV4dAoKV2UgY2Fu
IGN1dCB0aGUgbnVtYmVyIG9mIHJvdW5kdHJpcHMgb24gb3BlbiAobWF5IGFsc28KaGVscCBzb21l
IHJlbmFtZSBjYXNlcyBhcyB3ZWxsKSBieSByZXR1cm5pbmcgdGhlIGlub2RlCm51bWJlciBpbiB0
aGUgU01CMiBvcGVuIHJlcXVlc3QgaXRzZWxmIGluc3RlYWQgb2YKcXVlcnlpbmcgaXQgYWZ0ZXJ3
YXJkcyB2aWEgYSBxdWVyeSBGSUxFX0lOVEVSTkFMX0lORk8uClRoaXMgc2hvdWxkIHNpZ25pZmlj
YW50bHkgaW1wcm92ZSB0aGUgcGVyZm9ybWFuY2Ugb2YKcG9zaXggb3Blbi4KCkFkZCBTTUIyX0NS
RUFURV9RVUVSWV9PTl9ESVNLX0lEIGNyZWF0ZSBjb250ZXh0IHJlcXVlc3QKb24gb3BlbiBjYWxs
cyBzbyB0aGF0IHdoZW4gc2VydmVyIHN1cHBvcnRzIHRoaXMgd2UKY2FuIHNhdmUgYSByb3VuZHRy
aXAgZm9yIFFVRVJZX0lORk8gb24gZXZlcnkgb3Blbi4KCkZvbGxvdyBvbiBwYXRjaCB3aWxsIGFk
ZCB0aGUgcmVzcG9uc2UgcHJvY2Vzc2luZyBmb3IKU01CMl9DUkVBVEVfUVVFUllfT05fRElTS19J
RCBjb250ZXh0IGFuZCBvcHRpbWl6ZQpzbWIyX29wZW5fZmlsZSB0byBhdm9pZCB0aGUgZXh0cmEg
bmV0d29yayByb3VuZHRyaXAKb24gZXZlcnkgcG9zaXggb3Blbi4gVGhpcyBwYXRjaCBhZGRzIHRo
ZSBjb250ZXh0IG9uClNNQjIvU01CMyBvcGVuIHJlcXVlc3RzLgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5j
IHwgNDggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZz
L2NpZnMvc21iMnBkdS5oIHwgMTcgKysrKysrKysrKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwg
NjAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nt
YjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDM0ZDUzOTdhMTk4OS4uZjU4ZTRkYzM5
ODdiIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUu
YwpAQCAtMjExOCw2ICsyMTE4LDQ4IEBAIGFkZF90d2FycF9jb250ZXh0KHN0cnVjdCBrdmVjICpp
b3YsIHVuc2lnbmVkIGludCAqbnVtX2lvdmVjLCBfX3U2NCB0aW1ld2FycCkKIAlyZXR1cm4gMDsK
IH0KIAorc3RhdGljIHN0cnVjdCBjcnRfcXVlcnlfaWRfY3R4dCAqCitjcmVhdGVfcXVlcnlfaWRf
YnVmKHZvaWQpCit7CisJc3RydWN0IGNydF9xdWVyeV9pZF9jdHh0ICpidWY7CisKKwlidWYgPSBr
emFsbG9jKHNpemVvZihzdHJ1Y3QgY3J0X3F1ZXJ5X2lkX2N0eHQpLCBHRlBfS0VSTkVMKTsKKwlp
ZiAoIWJ1ZikKKwkJcmV0dXJuIE5VTEw7CisKKwlidWYtPmNjb250ZXh0LkRhdGFPZmZzZXQgPSBj
cHVfdG9fbGUxNigwKTsKKwlidWYtPmNjb250ZXh0LkRhdGFMZW5ndGggPSBjcHVfdG9fbGUzMigw
KTsKKwlidWYtPmNjb250ZXh0Lk5hbWVPZmZzZXQgPSBjcHVfdG9fbGUxNihvZmZzZXRvZgorCQkJ
CShzdHJ1Y3QgY3J0X3F1ZXJ5X2lkX2N0eHQsIE5hbWUpKTsKKwlidWYtPmNjb250ZXh0Lk5hbWVM
ZW5ndGggPSBjcHVfdG9fbGUxNig0KTsKKwkvKiBTTUIyX0NSRUFURV9RVUVSWV9PTl9ESVNLX0lE
IGlzICJRRmlkIiAqLworCWJ1Zi0+TmFtZVswXSA9ICdRJzsKKwlidWYtPk5hbWVbMV0gPSAnRic7
CisJYnVmLT5OYW1lWzJdID0gJ2knOworCWJ1Zi0+TmFtZVszXSA9ICdkJzsKKwlyZXR1cm4gYnVm
OworfQorCisvKiBTZWUgTVMtU01CMiAyLjIuMTMuMi45ICovCitzdGF0aWMgaW50CithZGRfcXVl
cnlfaWRfY29udGV4dChzdHJ1Y3Qga3ZlYyAqaW92LCB1bnNpZ25lZCBpbnQgKm51bV9pb3ZlYykK
K3sKKwlzdHJ1Y3Qgc21iMl9jcmVhdGVfcmVxICpyZXEgPSBpb3ZbMF0uaW92X2Jhc2U7CisJdW5z
aWduZWQgaW50IG51bSA9ICpudW1faW92ZWM7CisKKwlpb3ZbbnVtXS5pb3ZfYmFzZSA9IGNyZWF0
ZV9xdWVyeV9pZF9idWYoKTsKKwlpZiAoaW92W251bV0uaW92X2Jhc2UgPT0gTlVMTCkKKwkJcmV0
dXJuIC1FTk9NRU07CisJaW92W251bV0uaW92X2xlbiA9IHNpemVvZihzdHJ1Y3QgY3J0X3F1ZXJ5
X2lkX2N0eHQpOworCWlmICghcmVxLT5DcmVhdGVDb250ZXh0c09mZnNldCkKKwkJcmVxLT5DcmVh
dGVDb250ZXh0c09mZnNldCA9IGNwdV90b19sZTMyKAorCQkJCXNpemVvZihzdHJ1Y3Qgc21iMl9j
cmVhdGVfcmVxKSArCisJCQkJaW92W251bSAtIDFdLmlvdl9sZW4pOworCWxlMzJfYWRkX2NwdSgm
cmVxLT5DcmVhdGVDb250ZXh0c0xlbmd0aCwgc2l6ZW9mKHN0cnVjdCBjcnRfcXVlcnlfaWRfY3R4
dCkpOworCSpudW1faW92ZWMgPSBudW0gKyAxOworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50
CiBhbGxvY19wYXRoX3dpdGhfdHJlZV9wcmVmaXgoX19sZTE2ICoqb3V0X3BhdGgsIGludCAqb3V0
X3NpemUsIGludCAqb3V0X2xlbiwKIAkJCSAgICBjb25zdCBjaGFyICp0cmVlbmFtZSwgY29uc3Qg
X19sZTE2ICpwYXRoKQpAQCAtMjQ0Niw2ICsyNDg4LDEyIEBAIFNNQjJfb3Blbl9pbml0KHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwgX191OCAqb3Bsb2NrLAog
CQkJcmV0dXJuIHJjOwogCX0KIAorCWlmIChuX2lvdiA+IDIpIHsKKwkJc3RydWN0IGNyZWF0ZV9j
b250ZXh0ICpjY29udGV4dCA9CisJCQkoc3RydWN0IGNyZWF0ZV9jb250ZXh0ICopaW92W25faW92
LTFdLmlvdl9iYXNlOworCQljY29udGV4dC0+TmV4dCA9IGNwdV90b19sZTMyKGlvdltuX2lvdi0x
XS5pb3ZfbGVuKTsKKwl9CisJYWRkX3F1ZXJ5X2lkX2NvbnRleHQoaW92LCAmbl9pb3YpOwogCiAJ
cnFzdC0+cnFfbnZlYyA9IG5faW92OwogCXJldHVybiAwOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCAwNTNlYzYyMWU3YjkuLjQ1OGJhZDAx
Y2E3NCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIycGR1
LmgKQEAgLTY2Miw5ICs2NjIsMTAgQEAgc3RydWN0IHNtYjJfdHJlZV9kaXNjb25uZWN0X3JzcCB7
CiAgKiBbM10gOiBkdXJhYmxlIGNvbnRleHQKICAqIFs0XSA6IHBvc2l4IGNvbnRleHQKICAqIFs1
XSA6IHRpbWUgd2FycCBjb250ZXh0Ci0gKiBbNl0gOiBjb21wb3VuZCBwYWRkaW5nCisgKiBbNl0g
OiBxdWVyeSBpZCBjb250ZXh0CisgKiBbN10gOiBjb21wb3VuZCBwYWRkaW5nCiAgKi8KLSNkZWZp
bmUgU01CMl9DUkVBVEVfSU9WX1NJWkUgNworI2RlZmluZSBTTUIyX0NSRUFURV9JT1ZfU0laRSA4
CiAKIHN0cnVjdCBzbWIyX2NyZWF0ZV9yZXEgewogCXN0cnVjdCBzbWIyX3N5bmNfaGRyIHN5bmNf
aGRyOwpAQCAtNjg4LDEwICs2ODksMTAgQEAgc3RydWN0IHNtYjJfY3JlYXRlX3JlcSB7CiAKIC8q
CiAgKiBNYXhpbXVtIHNpemUgb2YgYSBTTUIyX0NSRUFURSByZXNwb25zZSBpcyA2NCAoc21iMiBo
ZWFkZXIpICsKLSAqIDg4IChmaXhlZCBwYXJ0IG9mIGNyZWF0ZSByZXNwb25zZSkgKyA1MjAgKHBh
dGgpICsgMTUwIChjb250ZXh0cykgKworICogODggKGZpeGVkIHBhcnQgb2YgY3JlYXRlIHJlc3Bv
bnNlKSArIDUyMCAocGF0aCkgKyAyMDggKGNvbnRleHRzKSArCiAgKiAyIGJ5dGVzIG9mIHBhZGRp
bmcuCiAgKi8KLSNkZWZpbmUgTUFYX1NNQjJfQ1JFQVRFX1JFU1BPTlNFX1NJWkUgODI0CisjZGVm
aW5lIE1BWF9TTUIyX0NSRUFURV9SRVNQT05TRV9TSVpFIDg4MAogCiBzdHJ1Y3Qgc21iMl9jcmVh
dGVfcnNwIHsKIAlzdHJ1Y3Qgc21iMl9zeW5jX2hkciBzeW5jX2hkcjsKQEAgLTgxOCw3ICs4MTks
NyBAQCBzdHJ1Y3QgZHVyYWJsZV9yZWNvbm5lY3RfY29udGV4dF92MiB7CiBzdHJ1Y3Qgb25fZGlz
a19pZCB7CiAJX19sZTY0IERpc2tGaWxlSWQ7CiAJX19sZTY0IFZvbHVtZUlkOwotCV9fdTY0ICBS
ZXNlcnZlZFs0XTsKKwlfX3UzMiAgUmVzZXJ2ZWRbNF07CiB9IF9fcGFja2VkOwogCiAvKiBTZWUg
TVMtU01CMiAyLjIuMTQuMi4xMiAqLwpAQCAtODQxLDYgKzg0MiwxMiBAQCBzdHJ1Y3QgY3J0X3R3
YXJwX2N0eHQgewogCiB9IF9fcGFja2VkOwogCisvKiBTZWUgTVMtU01CMiAyLjIuMTMuMi45ICov
CitzdHJ1Y3QgY3J0X3F1ZXJ5X2lkX2N0eHQgeworCXN0cnVjdCBjcmVhdGVfY29udGV4dCBjY29u
dGV4dDsKKwlfX3U4CU5hbWVbOF07Cit9IF9fcGFja2VkOworCiAjZGVmaW5lIENPUFlfQ0hVTktf
UkVTX0tFWV9TSVpFCTI0CiBzdHJ1Y3QgcmVzdW1lX2tleV9yZXEgewogCWNoYXIgUmVzdW1lS2V5
W0NPUFlfQ0hVTktfUkVTX0tFWV9TSVpFXTsKLS0gCjIuMjAuMQoK
--000000000000ba935d058d086c4a--
