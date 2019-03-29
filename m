Return-Path: <SRS0=xN7r=SA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404A9C10F05
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 08:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D81721773
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 08:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="InNxiwuf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfC2IOZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 04:14:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33560 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfC2IOZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Mar 2019 04:14:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id i19so699499pfd.0;
        Fri, 29 Mar 2019 01:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPlcFaq2zjJPU211BGeBuuh/9QzZ84uW2qSiTFicvq0=;
        b=InNxiwufQn8CDMF60cqj1LCf7AX8AVXMQjSDaheyA0TfORCIFf9DsVafXewjnu2f7Z
         Pqnt+FbBwvZaPtRPtNaS1Zd4z10m0dLfGli5t3KEDP0BZ9U7Lbu6qdUcqkTJnENLrc+J
         ThwgIglOLtlUdL0mDs5GcjIigCj7/xrub8/RPFO2AF1SMIffC/yza36IxqHPt6j2bPGz
         TMsQ58WA7l4VM7ZZVTwG1pNueD68nqwktL2z4xOVPrHeRche91MlJKmdbjzvu90hxAi+
         byUlQLDv6yRUTRcLfQbcrCyhTHt+Xf9phW8oiN8XzL4yiQtobINEVudq1wXGO6CpJLWs
         JWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPlcFaq2zjJPU211BGeBuuh/9QzZ84uW2qSiTFicvq0=;
        b=krwYa4b1JWLn1SPsCfzc4PudANEAgKP0zK5Hxw6Efwx3C8tcfLnNigs5RZX7Rvm3Y/
         fTRS1m9loXnuloeFTVqi4gSEUcTRfluEpPoYw+P5Jj2Cccxnuuej4GkdJ12GMtWxtvWs
         XUd96ogLgKCuaxx9X1iaNCXhAYXdgx97qlaxdJQ6Tcm4tIYDji/nazeE3Letwvz4eWOi
         YjI6Oa8VBNRhGk51MedHLoLYp2ZcLuz3ROClP2+Caf4XKddSRdgXrR8XxBEOnRSIYfE4
         dVGx6mHDPnXDmhPiEUu3AU56Plz77Ns6YdA7rRO8XQeaLQPKoPDOUNDGDNtuTAbkixMw
         u9Vg==
X-Gm-Message-State: APjAAAV+LSVhw3OrrwS7IjUmerXqw0nx41NnDun66dRHJbDLR0RAqizK
        krQpn7LZ/tb/Tq49geiZRSI5RkicYn0XNcLsCrPGCA==
X-Google-Smtp-Source: APXvYqzFyE5iuAo6uv1kEbJbwKXznVdt535oevuERLCZxhrp5nfUBQBgDWz6KXBnNOxaoGjEhnFa6TE2cytmjglp0v8=
X-Received: by 2002:a62:1cc7:: with SMTP id c190mr24415626pfc.246.1553847263670;
 Fri, 29 Mar 2019 01:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
 <20190328170219.29c72cbf@echidna.suse.de>
In-Reply-To: <20190328170219.29c72cbf@echidna.suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 29 Mar 2019 03:14:11 -0500
Message-ID: <CAH2r5mvb=SbYV9Qmt=n_ht7toPgKs03Y2oHXpJE7=_byptstKg@mail.gmail.com>
Subject: Re: [PATCH][smbinfo cifsutils]
To:     David Disseldorp <ddiss@suse.de>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002fd33105853742ca"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002fd33105853742ca
Content-Type: text/plain; charset="UTF-8"

As requested I changed the buffer size malloced to be more obvious -
in this case to match exactly what is returned from the first call (ie
snapshot length + the sizeof the snapshot info structure which
precedes the snapshot list, ie 16 bytes).  The snapshot array size is
12 bytes, but rounding it to 8 byte boundary causes the minimum to be
16 bytes.

On Thu, Mar 28, 2019 at 11:02 AM David Disseldorp <ddiss@suse.de> wrote:
>
> On Thu, 28 Mar 2019 05:05:35 -0500, Steve French wrote:
>
> > +     /* Now that we know the size, query the list from the server */
> > +
> > +     /* Make sure the buf size is big enough even to handle unexpected server behavior */
> > +     buf = malloc(snap_inf.snapshot_array_size + 300);
>
> The buffer length calculations seem pretty arbitrary here, wouldn't it
> make sense to use something like the following (with a maximum limit)?
> sizeof(struct smb_snapshot_array) +
>         (snap_inf.number_of_snapshots * GMT_TOKEN_LEN)
>
> Cheers, David



-- 
Thanks,

Steve

--0000000000002fd33105853742ca
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbinfo-Add-ability-to-query-snapshots-previous-vers.patch"
Content-Disposition: attachment; 
	filename="0001-smbinfo-Add-ability-to-query-snapshots-previous-vers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jttsh5ep0>
X-Attachment-Id: f_jttsh5ep0

RnJvbSBkYTA4YjI5YTgyNzhmNDllZGZmZGQ0ZWJlMjEzMmI3NDc4NmRkYTZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjkgTWFyIDIwMTkgMDM6MDU6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJpbmZvOiBBZGQgYWJpbGl0eSB0byBxdWVyeSBzbmFwc2hvdHMgKHByZXZpb3VzIHZlcnNpb25z
KQoKQWxsb3cgbGlzdGluZyBTTUIzIHNuYXBzaG90cyAocHJldmlvdXMgdmVyc2lvbnMgb2Ygc2hh
cmVzKQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgotLS0K
IHNtYmluZm8uYyB8IDg3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA4NyBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvc21iaW5mby5jIGIvc21iaW5mby5jCmluZGV4IDMzZmNhOTUuLjdjZmZiODQgMTAwNjQ0
Ci0tLSBhL3NtYmluZm8uYworKysgYi9zbWJpbmZvLmMKQEAgLTg5LDYgKzg5LDggQEAgdXNhZ2Uo
Y2hhciAqbmFtZSkKIAkJIiAgICAgIFByaW50cyB0aGUgc2VjdXJpdHkgZGVzY3JpcHRvciBmb3Ig
YSBjaWZzIGZpbGUuXG4iCiAJCSIgIHF1b3RhOlxuIgogCQkiICAgICAgUHJpbnRzIHRoZSBxdW90
YSBmb3IgYSBjaWZzIGZpbGUuXG4iCisJCSIgIGxpc3Qtc25hcHNob3RzOlxuIgorCQkiICAgICAg
TGlzdCB0aGUgcHJldmlvdXMgdmVyc2lvbnMgb2YgdGhlIHZvbHVtZSB0aGF0IGJhY2tzIHRoaXMg
ZmlsZS5cbiIKIAkJIiAgZnNjdGwtZ2V0b2JqaWQ6XG4iCiAJCSIgICAgICBQcmludHMgdGhlIG9i
amVjdGlkIG9mIHRoZSBmaWxlIGFuZCBHVUlEIG9mIHRoZSB1bmRlcmx5aW5nIHZvbHVtZS5cbiIs
CiAJCW5hbWUpOwpAQCAtOTY2LDYgKzk2OCw4OSBAQCBxdW90YShpbnQgZikKIAlmcmVlKHFpKTsK
IH0KIAorCitzdHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5IHsKKwlpbnQzMl90CW51bWJlcl9vZl9z
bmFwc2hvdHM7CisJaW50MzJfdAludW1iZXJfb2Zfc25hcHNob3RzX3JldHVybmVkOworCWludDMy
X3QJc25hcHNob3RfYXJyYXlfc2l6ZTsKKwljaGFyIHNuYXBzaG90X2RhdGFbMF07Cit9OworCisK
K3N0YXRpYyB2b2lkIHByaW50X3NuYXBzaG90cyhzdHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5ICpw
c25hcCkKK3sKKwlpbnQgY3VycmVudF9zbmFwc2hvdF9lbnRyeSA9IDA7CisKKwlwcmludGYoIk51
bWJlciBvZiBzbmFwc2hvdHM6ICVkIE51bWJlciBvZiBzbmFwc2hvdHMgcmV0dXJuZWQ6ICVkXG4i
LAorCQlwc25hcC0+bnVtYmVyX29mX3NuYXBzaG90cywKKwkJcHNuYXAtPm51bWJlcl9vZl9zbmFw
c2hvdHNfcmV0dXJuZWQpOworCXByaW50ZigiU25hcHNob3QgbGlzdDoiKTsKKworCWZvciAoaW50
IGkgPSAwOyBpIDwgcHNuYXAtPnNuYXBzaG90X2FycmF5X3NpemU7IGkrKykgeworCQlpZiAocHNu
YXAtPnNuYXBzaG90X2RhdGFbaV0gPT0gJ0AnKSB7CisJCQljdXJyZW50X3NuYXBzaG90X2VudHJ5
Kys7CisJCQlwcmludGYoIlxuJWQpICIsIGN1cnJlbnRfc25hcHNob3RfZW50cnkpOworCQl9CisJ
CXByaW50ZigiJWMiLCBwc25hcC0+c25hcHNob3RfZGF0YVtpXSk7CisJfQorCXByaW50ZigiXG4i
KTsKK30KKworI2RlZmluZSBDSUZTX0VOVU1FUkFURV9TTkFQU0hPVFMgX0lPUihDSUZTX0lPQ1RM
X01BR0lDLCA2LCBzdHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5KQorCisjZGVmaW5lIE1JTl9TTkFQ
U0hPVF9BUlJBWV9TSVpFIDE2IC8qIFNlZSBNUy1TTUIyIHNlY3Rpb24gMy4zLjUuMTUuMSAqLwor
CitzdGF0aWMgdm9pZAorbGlzdF9zbmFwc2hvdHMoaW50IGYpCit7CisKKwlzdHJ1Y3Qgc21iX3Nu
YXBzaG90X2FycmF5IHNuYXBfaW5mOworCXN0cnVjdCBzbWJfc25hcHNob3RfYXJyYXkgKmJ1ZjsK
KworCS8qCisJICogV2hlbiBmaXJzdCBmaWVsZCBpbiBzdHJ1Y3R1cmUgd2UgcGFzcyBpbiBoZXJl
IGlzIHplcm8sIGNpZnMua28gY2FuCisJICogcmVjb2duaXplIHRoYXQgdGhpcyBpcyB0aGUgZmly
c3QgcXVlcnkgYW5kIHRoYXQgaXQgbXVzdCBzZXQgdGhlIFNNQjMKKwkgKiBGU0NUTCByZXNwb25z
ZSBidWZmZXIgc2l6ZSAoaW4gdGhlIHJlcXVlc3QpIHRvIGV4YWN0bHkgMTYgYnl0ZXMKKwkgKiAo
d2hpY2ggaXMgcmVxdWlyZWQgYnkgc29tZSBzZXJ2ZXJzIHRvIHByb2Nlc3MgdGhlIGluaXRpYWwg
cXVlcnkpCisJICovCisJc25hcF9pbmYubnVtYmVyX29mX3NuYXBzaG90cyA9IDA7CisJc25hcF9p
bmYubnVtYmVyX29mX3NuYXBzaG90c19yZXR1cm5lZCA9IDA7CisJc25hcF9pbmYuc25hcHNob3Rf
YXJyYXlfc2l6ZSA9IHNpemVvZihzdHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5KTsKKworCS8qIFF1
ZXJ5IHRoZSBudW1iZXIgb2Ygc25hcHNob3RzIHNvIHdlIGtub3cgaG93IG11Y2ggdG8gYWxsb2Nh
dGUgKi8KKwlpZiAoaW9jdGwoZiwgQ0lGU19FTlVNRVJBVEVfU05BUFNIT1RTLCAmc25hcF9pbmYp
IDwgMCkgeworCQlmcHJpbnRmKHN0ZGVyciwgIlF1ZXJ5aW5nIHNuYXBzaG90cyBmYWlsZWQgd2l0
aCAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsKKwkJZXhpdCgxKTsKKwl9CisKKwlpZiAoc25hcF9p
bmYubnVtYmVyX29mX3NuYXBzaG90cyA9PSAwKQorCQlyZXR1cm47CisKKwkvKiBOb3cgdGhhdCB3
ZSBrbm93IHRoZSBzaXplLCBxdWVyeSB0aGUgbGlzdCBmcm9tIHRoZSBzZXJ2ZXIgKi8KKworCWJ1
ZiA9IG1hbGxvYyhzbmFwX2luZi5zbmFwc2hvdF9hcnJheV9zaXplICsgTUlOX1NOQVBTSE9UX0FS
UkFZX1NJWkUpOworCisJaWYgKGJ1ZiA9PSBOVUxMKSB7CisJCXByaW50ZigiRmFpbGVkLCBvdXQg
b2YgbWVtb3J5LlxuIik7CisJCWV4aXQoMSk7CisJfQorCS8qCisJICogZmlyc3QgcGFybSBpcyBu
b24temVybyB3aGljaCBhbGxvd3MgY2lmcy5rbyB0byByZWNvZ25pemUgdGhhdCB0aGlzIGlzCisJ
ICogdGhlIHNlY29uZCBxdWVyeSAoaXQgaGFzIHRvIHNldCByZXNwb25zZSBidWYgc2l6ZSBsYXJn
ZXIpCisJICovCisJYnVmLT5udW1iZXJfb2Zfc25hcHNob3RzID0gc25hcF9pbmYubnVtYmVyX29m
X3NuYXBzaG90czsKKworCWJ1Zi0+c25hcHNob3RfYXJyYXlfc2l6ZSA9IHNuYXBfaW5mLnNuYXBz
aG90X2FycmF5X3NpemU7CisKKwlpZiAoaW9jdGwoZiwgQ0lGU19FTlVNRVJBVEVfU05BUFNIT1RT
LCBidWYpIDwgMCkgeworCQlmcHJpbnRmKHN0ZGVyciwgIlF1ZXJ5aW5nIHNuYXBzaG90cyBmYWls
ZWQgd2l0aCAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsKKwkJZXhpdCgxKTsKKwl9CisKKwlwcmlu
dF9zbmFwc2hvdHMoYnVmKTsKKwlmcmVlKGJ1Zik7Cit9CisKIGludCBtYWluKGludCBhcmdjLCBj
aGFyICphcmd2W10pCiB7CiAJaW50IGM7CkBAIC0xMDE2LDYgKzExMDEsOCBAQCBpbnQgbWFpbihp
bnQgYXJnYywgY2hhciAqYXJndltdKQogCQlzZWNkZXNjKGYpOwogCWVsc2UgaWYgKCFzdHJjbXAo
YXJndltvcHRpbmRdLCAicXVvdGEiKSkKIAkJcXVvdGEoZik7CisJZWxzZSBpZiAoIXN0cmNtcChh
cmd2W29wdGluZF0sICJsaXN0LXNuYXBzaG90cyIpKQorCQlsaXN0X3NuYXBzaG90cyhmKTsKIAll
bHNlIGlmICghc3RyY21wKGFyZ3ZbMV0sICJmc2N0bC1nZXRvYmppZCIpKQogCQlmc2N0bGdldG9i
amlkKGYpOwogCWVsc2UgewotLSAKMi4xNy4xCgo=
--0000000000002fd33105853742ca--
