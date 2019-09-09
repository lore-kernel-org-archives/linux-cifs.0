Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0532C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 04:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802D72196F
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 04:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXGB1Roy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfIIEeu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 00:34:50 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:42587 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfIIEet (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Sep 2019 00:34:49 -0400
Received: by mail-io1-f54.google.com with SMTP id n197so25650990iod.9
        for <linux-cifs@vger.kernel.org>; Sun, 08 Sep 2019 21:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vDeQsoGeSDu3BMWFqP1/c8McFmci2Qci2i2DDhVUaqE=;
        b=iXGB1RoyzKU4rhMAk4N5X5zi4oj4JXsmFIzLGsvSUqIcZzIFP9IJwoGqC3JhvP9Or3
         YGh35ZWlcwi05itisidkFCTVY0AbEQ+3PoMCbIN7iM4KMmk7RBKU8qh8oV3eZ6BvgzTo
         IkrMe3VVLTRj8afYdmhEEbFtDmBctHqVwJU8rg9NIjbExH5alfbFNfMRT+0YQ2dtO/Rz
         Ke34vrPkfMSy7Sjmi60tfqGw+d8GfVXbFlUOL4NxoQnCrQ8uhr0I99qjZEJ0yz3MbFc7
         PyylXu5WR2ZZ66YI67SQn3E8S/tIGZITAEe0xA59eD6SQ7bpQU7z493ucPQU4WXgQMSf
         cwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vDeQsoGeSDu3BMWFqP1/c8McFmci2Qci2i2DDhVUaqE=;
        b=qTQm7sry7kL9a4VBJxnmE3t/ioGwCdHkEJQwGNmcyEI76l8Q92dPntsymzKnP7ae4m
         4DSVxw2DlEtfpeMU/rY83JKCGsNYrJIMtbC9XHxAk83y6vLWtMC3izZeGxXWwRqE9eV8
         W7VubiG+9CffQfg2bhcNCcoc8VYpAevL4luRiSN4VI0qJn/htJypr/Ua7aplOjXHINa8
         yhYfX2iqELSmYbCzL6s/7Bo4tlW/hXef9Dsl5nSNG3FrPUeQZsWrNRp5+ej9DxQC9OxT
         Jo8Qn1k1O9hMRvO7GBs+HP6BumdvKWRBGi8nP6eVfRYU9Pc92pZap3T59BOykDaOTolM
         vgDg==
X-Gm-Message-State: APjAAAXav7LjAV60RDNR1G/Mpr6eNB0aS81XaJn9y9t1K2qq6QYIThYX
        UjUV8FE72Z8dP7dX+uwtiAMSFWaQawEJpm4XKYvm111O
X-Google-Smtp-Source: APXvYqwEEsLSUYa0n+C1K8vQTWEihZA62evoIELon8lnKcPtU1pj8vWVnKsSz/lJENhhFIO/vbrLlWbMCv9ZaCLer6I=
X-Received: by 2002:a02:3786:: with SMTP id r128mr617608jar.76.1568003686950;
 Sun, 08 Sep 2019 21:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msbRyGMY2XQifbxB0iU3a3EPp8UcemO8QE5bhq9HPMqBQ@mail.gmail.com>
In-Reply-To: <CAH2r5msbRyGMY2XQifbxB0iU3a3EPp8UcemO8QE5bhq9HPMqBQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Sep 2019 23:34:35 -0500
Message-ID: <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com>
Subject: Re: [SMB3][PATCHes] parallelizing decryption of large read responses
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c495de0592174e65"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c495de0592174e65
Content-Type: text/plain; charset="UTF-8"

Had a minor typo in patch 2 - fixed in attached

On Sun, Sep 8, 2019 at 11:31 PM Steve French <smfrench@gmail.com> wrote:
>
> I am seeing very good performance benefit from offload of decryption
> of encrypted SMB3 read responses to a pool of worker threads
> (optionally).  See attached patches.
>
> I plan to add another patch to only offload when number of requests in
> flight is > 1 (since there is no point offloading and doing a thread
> switch if no other responses would overlap in the cifsd thread reading
> from the socket).
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000c495de0592174e65
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-enable-offload-of-decryption-of-large-reads-via.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-enable-offload-of-decryption-of-large-reads-via.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0bww7l80>
X-Attachment-Id: f_k0bww7l80

RnJvbSBlNWRlNzJkOGI2OTIwZmQ2Mzk3NTEyYzdmZWQ1OTc4MGZhMjczYWRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgOCBTZXAgMjAxOSAyMzoyMjowMiAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBzbWIzOiBlbmFibGUgb2ZmbG9hZCBvZiBkZWNyeXB0aW9uIG9mIGxhcmdlIHJlYWRzIHZpYQog
bW91bnQgb3B0aW9uCgpEaXNhYmxlIG9mZmxvYWQgb2YgdGhlIGRlY3J5cHRpb24gb2YgZW5jcnlw
dGVkIHJlYWQgcmVzcG9uc2VzCmJ5IGRlZmF1bHQgKGVxdWl2YWxlbnQgdG8gc2V0dGluZyB0aGlz
IG5ldyBtb3VudCBvcHRpb24gImVzaXplPTAiKS4KCkFsbG93IHNldHRpbmcgdGhlIG1pbmltdW0g
ZW5jcnlwdGVkIHJlYWQgcmVzcG9uc2Ugc2l6ZSB0aGF0IHdlCndpbGwgY2hvb3NlIHRvIG9mZmxv
YWQgdG8gYSB3b3JrZXIgdGhyZWFkIC0gaXQgaXMgbm93IGNvbmZpZ3VyYWJsZQp2aWEgb24gYSBu
ZXcgbW91bnQgb3B0aW9uICJlc2l6ZT0iCgpEZXBlbmRpbmcgb24gd2hpY2ggZW5jcnlwdGlvbiBt
ZWNoYW5pc20gKEdDTSB2cy4gQ0NNKSBhbmQKdGhlIG51bWJlciBvZiByZWFkcyB0aGF0IHdpbGwg
YmUgaXNzdWVkIGluIHBhcmFsbGVsIGFuZCB0aGUKcGVyZm9ybWFuY2Ugb2YgdGhlIG5ldHdvcmsg
YW5kIENQVSBvbiB0aGUgY2xpZW50LCBpdCBtYXkgbWFrZQpzZW5zZSB0byBlbmFibGUgdGhpcyBz
aW5jZSBpdCBjYW4gcHJvdmlkZSBzdWJzdGFudGlhbCBiZW5lZml0IHdoZW4KbXVsdGlwbGUgbGFy
Z2UgcmVhZHMgYXJlIGluIGZsaWdodCBhdCB0aGUgc2FtZSB0aW1lLgoKU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2Zz
LmMgICB8ICAyICsrCiBmcy9jaWZzL2NpZnNnbG9iLmggfCAgMiArKwogZnMvY2lmcy9jb25uZWN0
LmMgIHwgMTMgKysrKysrKysrKysrKwogZnMvY2lmcy9zbWIyb3BzLmMgIHwgIDQgKystLQogNCBm
aWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IGIwZWEzMzJhZjM1
Yy4uZWJmODVhNWQ5NWU0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2Np
ZnMvY2lmc2ZzLmMKQEAgLTU1OSw2ICs1NTksOCBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qg
c2VxX2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJvb3QpCiAJc2VxX3ByaW50ZihzLCAiLHJzaXpl
PSV1IiwgY2lmc19zYi0+cnNpemUpOwogCXNlcV9wcmludGYocywgIix3c2l6ZT0ldSIsIGNpZnNf
c2ItPndzaXplKTsKIAlzZXFfcHJpbnRmKHMsICIsYnNpemU9JXUiLCBjaWZzX3NiLT5ic2l6ZSk7
CisJaWYgKHRjb24tPnNlcy0+c2VydmVyLT5taW5fb2ZmbG9hZCkKKwkJc2VxX3ByaW50ZihzLCAi
LGVzaXplPSV1IiwgdGNvbi0+c2VzLT5zZXJ2ZXItPm1pbl9vZmZsb2FkKTsKIAlzZXFfcHJpbnRm
KHMsICIsZWNob19pbnRlcnZhbD0lbHUiLAogCQkJdGNvbi0+c2VzLT5zZXJ2ZXItPmVjaG9faW50
ZXJ2YWwgLyBIWik7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMv
Y2lmc2dsb2IuaAppbmRleCBkNjYxMDZhYzAzMWEuLjY5ODdmYmM1YTI0YSAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNTkyLDYgKzU5
Miw3IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAl1bnNpZ25lZCBpbnQgYnNpemU7CiAJdW5zaWduZWQg
aW50IHJzaXplOwogCXVuc2lnbmVkIGludCB3c2l6ZTsKKwl1bnNpZ25lZCBpbnQgbWluX29mZmxv
YWQ7CiAJYm9vbCBzb2Nrb3B0X3RjcF9ub2RlbGF5OjE7CiAJdW5zaWduZWQgbG9uZyBhY3RpbWVv
OyAvKiBhdHRyaWJ1dGUgY2FjaGUgdGltZW91dCAoamlmZmllcykgKi8KIAlzdHJ1Y3Qgc21iX3Zl
cnNpb25fb3BlcmF0aW9ucyAqb3BzOwpAQCAtNzQ1LDYgKzc0Niw3IEBAIHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gewogI2VuZGlmIC8qIFNUQVRTMiAqLwogCXVuc2lnbmVkIGludAltYXhfcmVhZDsK
IAl1bnNpZ25lZCBpbnQJbWF4X3dyaXRlOworCXVuc2lnbmVkIGludAltaW5fb2ZmbG9hZDsKIAlf
X2xlMTYJY29tcHJlc3NfYWxnb3JpdGhtOwogCV9fbGUxNgljaXBoZXJfdHlwZTsKIAkgLyogc2F2
ZSBpbml0aXRhbCBuZWdwcm90IGhhc2ggKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5j
IGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggMTc4ODJjZWRlMTk3Li40MDNiNWNlYmMxNTIgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0x
MDMsNiArMTAzLDcgQEAgZW51bSB7CiAJT3B0X2JhY2t1cHVpZCwgT3B0X2JhY2t1cGdpZCwgT3B0
X3VpZCwKIAlPcHRfY3J1aWQsIE9wdF9naWQsIE9wdF9maWxlX21vZGUsCiAJT3B0X2Rpcm1vZGUs
IE9wdF9wb3J0LAorCU9wdF9taW5fZW5jX29mZmxvYWQsCiAJT3B0X2Jsb2Nrc2l6ZSwgT3B0X3Jz
aXplLCBPcHRfd3NpemUsIE9wdF9hY3RpbWVvLAogCU9wdF9lY2hvX2ludGVydmFsLCBPcHRfbWF4
X2NyZWRpdHMsIE9wdF9oYW5kbGV0aW1lb3V0LAogCU9wdF9zbmFwc2hvdCwKQEAgLTIwNyw2ICsy
MDgsNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCBjaWZzX21vdW50X29wdGlvbl90b2tl
bnMgPSB7CiAJeyBPcHRfZGlybW9kZSwgImRpcm1vZGU9JXMiIH0sCiAJeyBPcHRfZGlybW9kZSwg
ImRpcl9tb2RlPSVzIiB9LAogCXsgT3B0X3BvcnQsICJwb3J0PSVzIiB9LAorCXsgT3B0X21pbl9l
bmNfb2ZmbG9hZCwgImVzaXplPSVzIiB9LAogCXsgT3B0X2Jsb2Nrc2l6ZSwgImJzaXplPSVzIiB9
LAogCXsgT3B0X3JzaXplLCAicnNpemU9JXMiIH0sCiAJeyBPcHRfd3NpemUsICJ3c2l6ZT0lcyIg
fSwKQEAgLTIwMTYsNiArMjAxOCwxMyBAQCBjaWZzX3BhcnNlX21vdW50X29wdGlvbnMoY29uc3Qg
Y2hhciAqbW91bnRkYXRhLCBjb25zdCBjaGFyICpkZXZuYW1lLAogCQkJfQogCQkJcG9ydCA9ICh1
bnNpZ25lZCBzaG9ydClvcHRpb247CiAJCQlicmVhazsKKwkJY2FzZSBPcHRfbWluX2VuY19vZmZs
b2FkOgorCQkJaWYgKGdldF9vcHRpb25fdWwoYXJncywgJm9wdGlvbikpIHsKKwkJCQljaWZzX2Ri
ZyhWRlMsICJJbnZhbGlkIG1pbmltdW0gZW5jcnlwdGVkIHJlYWQgb2ZmbG9hZCBzaXplIChlc2l6
ZSlcbiIpOworCQkJCWdvdG8gY2lmc19wYXJzZV9tb3VudF9lcnI7CisJCQl9CisJCQl2b2wtPm1p
bl9vZmZsb2FkID0gb3B0aW9uOworCQkJYnJlYWs7CiAJCWNhc2UgT3B0X2Jsb2Nrc2l6ZToKIAkJ
CWlmIChnZXRfb3B0aW9uX3VsKGFyZ3MsICZvcHRpb24pKSB7CiAJCQkJY2lmc19kYmcoVkZTLCAi
JXM6IEludmFsaWQgYmxvY2tzaXplIHZhbHVlXG4iLApAQCAtMjYxNiw2ICsyNjI1LDkgQEAgc3Rh
dGljIGludCBtYXRjaF9zZXJ2ZXIoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1
Y3Qgc21iX3ZvbCAqdm9sKQogCWlmIChzZXJ2ZXItPmlnbm9yZV9zaWduYXR1cmUgIT0gdm9sLT5p
Z25vcmVfc2lnbmF0dXJlKQogCQlyZXR1cm4gMDsKIAorCWlmIChzZXJ2ZXItPm1pbl9vZmZsb2Fk
ICE9IHZvbC0+bWluX29mZmxvYWQpCisJCXJldHVybiAwOworCiAJcmV0dXJuIDE7CiB9CiAKQEAg
LTI3OTAsNiArMjgwMiw3IEBAIGNpZnNfZ2V0X3RjcF9zZXNzaW9uKHN0cnVjdCBzbWJfdm9sICp2
b2x1bWVfaW5mbykKIAkJbW9kdWxlX3B1dChUSElTX01PRFVMRSk7CiAJCWdvdG8gb3V0X2Vycl9j
cnlwdG9fcmVsZWFzZTsKIAl9CisJdGNwX3Nlcy0+bWluX29mZmxvYWQgPSB2b2x1bWVfaW5mby0+
bWluX29mZmxvYWQ7CiAJdGNwX3Nlcy0+dGNwU3RhdHVzID0gQ2lmc05lZWROZWdvdGlhdGU7CiAK
IAl0Y3Bfc2VzLT5ucl90YXJnZXRzID0gMTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5j
IGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggNjRmZTBkOTNjNDQyLi4wNDcwNjY0OTM4MzIgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC00
MTI1LDggKzQxMjUsOCBAQCByZWNlaXZlX2VuY3J5cHRlZF9yZWFkKHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICoqbWlkLAogCSAqIHVzZSBtb3JlIGNv
cmVzIGRlY3J5cHRpbmcgd2hpY2ggY2FuIGJlIGV4cGVuc2l2ZQogCSAqLwogCi0JLyogVE9ETzog
bWFrZSB0aGUgc2l6ZSBsaW1pdCB0byBlbmFibGUgZGVjcnlwdCBvZmZsb2FkIGNvbmZpZ3VyYWJs
ZSAqLwotCWlmIChzZXJ2ZXItPnBkdV9zaXplID4gKDUxMiAqIDEwMjQpKSB7CisJaWYgKChzZXJ2
ZXItPm1pbl9vZmZsb2FkKSAmJgorCSAgICAoc2VydmVyLT5wZHVfc2l6ZSA+PSBzZXJ2ZXItPm1p
bl9vZmZsb2FkKSkgewogCQlkdyA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBzbWIyX2RlY3J5cHRf
d29yayksIEdGUF9LRVJORUwpOwogCQlpZiAoZHcgPT0gTlVMTCkKIAkJCWdvdG8gbm9uX29mZmxv
YWRlZF9kZWNyeXB0OwotLSAKMi4yMC4xCgo=
--000000000000c495de0592174e65--
