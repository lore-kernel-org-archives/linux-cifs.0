Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA52FC3DA66
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 04:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjHYEvh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 00:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjHYEv0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 00:51:26 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF0F1FEB
        for <linux-cifs@vger.kernel.org>; Thu, 24 Aug 2023 21:51:24 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2bccda76fb1so7223931fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 24 Aug 2023 21:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692939082; x=1693543882;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OU2cC0WxHmWiio+6TOvKQFDXRjmAOqJ0sokDjVSRY/c=;
        b=saq5mjLrJlj3IRl7m+b3k+cMrU4GpJcRvPOsMLw4k7vPpiNWWsEaBq4gpST+i0M6vG
         nRpTkRqvtSndf48u8xzhWYfEAag7p6+tfmLgw0JJeyW3eysMWwAPdI/CgNIFg7bHJ6J4
         3z6X4Y3YXedF1imNTZlyZqF7rR5ghZ/jKs7pAU6JBxxGU4Y6Ic4PkHbqwtH2HgAVIdcA
         +EcwUbfriklbd5K9jD6XVh1DkCa223O+iFopLD3rS3mMH9EgtfnS+U0H5M+SsBuXuYcX
         RTyq1O/hjxnSHIPZ6gp7/FyWTHu2x/0sKKJKlZLwqxrHr1ipExocjjVyH8hJsSKsctwQ
         1aUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692939082; x=1693543882;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OU2cC0WxHmWiio+6TOvKQFDXRjmAOqJ0sokDjVSRY/c=;
        b=GSK31AW9k3r42hmZSrEVUvjwZw4wdyfgx+8lArG04D5n4uHqRZa/Zn+RAM4tOzd9u8
         CA4pZwzzeRk5zOu9DGosyDvezdYL2a5MWIrEj95LUvIvD5mwgp8AsdR4obCFKaqBrrOo
         0kc5sKk/IFjI6kM1N1zSaMwrn4C1iF+C4MTXPq/+Ml1L7ZMLQ61/pHji3Bj/uBqLpaLD
         4P+edLPpGYi8sQywere/o7EURxmyA4tZ9MxOlH5bgt8+oOOb71TbKDSJTB6k6JhpRFNx
         KvdKL6E1xNq0C7LH3jvaXODF/4L6/es1YZ5RBETC7oj/z++5HlLwFo73/Drh8o/V3Rfy
         pELw==
X-Gm-Message-State: AOJu0YzR3FJxMYKARdbugAj/yODWZ0HIuMKHA0nan31wEgT29KNqC8IY
        FYx+N/4IJcOAd0D36ivUdXMi1Rx1U1ee8h8xBlMtPm8SACLEYA==
X-Google-Smtp-Source: AGHT+IHS0VJzaK5kAeg2I4EV7kwxjVjg1xfBonaYXNEuBdgyVfuX6xW/Q8ZZdKEn7FqQqfSiplpUGC72DMLkPISI6WI=
X-Received: by 2002:a2e:8193:0:b0:2b6:d6e1:a191 with SMTP id
 e19-20020a2e8193000000b002b6d6e1a191mr14293694ljg.23.1692939082177; Thu, 24
 Aug 2023 21:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
In-Reply-To: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 24 Aug 2023 23:51:10 -0500
Message-ID: <CAH2r5mu75kYDVGPqe135pjZRjCS1SvdXqjOax+nyG9aTXmoJJw@mail.gmail.com>
Subject: Fwd: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000009ec2c30603b8189e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009ec2c30603b8189e
Content-Type: text/plain; charset="UTF-8"

The ChannelSequence field in the SMB3 header is supposed to be
increased after reconnect to allow the server to distinguish
requests from before and after the reconnect.  We had always
been setting it to zero.  There are cases where incrementing
ChannelSequence on requests after network reconnects can reduce
the chance of data corruptions.

See MS-SMB2 3.2.4.1 and 3.2.7.1

Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN"
used by this patch is confusing (has a confusing name) since
multichannel is not supported for older dialects like CIFS.  I will
fix that macro name in a followon patch.

-- 
Thanks,

Steve


-- 
Thanks,

Steve

--0000000000009ec2c30603b8189e
Content-Type: application/x-patch; 
	name="0001-SMB3-send-channel-sequence-number-in-SMB3-requests-a.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-send-channel-sequence-number-in-SMB3-requests-a.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_llq3oroc0>
X-Attachment-Id: f_llq3oroc0

RnJvbSBmNWJhZTMwYTFjNmEwMTBiNzFlZWVhZDkyOWU1MjIxOWFjNzM2NmQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjQgQXVnIDIwMjMgMjM6Mjk6MTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
U01CM10gc2VuZCBjaGFubmVsIHNlcXVlbmNlIG51bWJlciBpbiBTTUIzIHJlcXVlc3RzIGFmdGVy
CiByZWNvbm5lY3RzCgpUaGUgQ2hhbm5lbFNlcXVlbmNlIGZpZWxkIGluIHRoZSBTTUIzIGhlYWRl
ciBpcyBzdXBwb3NlZCB0byBiZQppbmNyZWFzZWQgYWZ0ZXIgcmVjb25uZWN0IHRvIGFsbG93IHRo
ZSBzZXJ2ZXIgdG8gZGlzdGluZ3Vpc2gKcmVxdWVzdHMgZnJvbSBiZWZvcmUgYW5kIGFmdGVyIHRo
ZSByZWNvbm5lY3QuICBXZSBoYWQgYWx3YXlzCmJlZW4gc2V0dGluZyBpdCB0byB6ZXJvLiAgVGhl
cmUgYXJlIGNhc2VzIHdoZXJlIGluY3JlbWVudGluZwpDaGFubmVsU2VxdWVuY2Ugb24gcmVxdWVz
dHMgYWZ0ZXIgbmV0d29yayByZWNvbm5lY3RzIGNhbiByZWR1Y2UKdGhlIGNoYW5jZSBvZiBkYXRh
IGNvcnJ1cHRpb25zLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDUuMTYrCi0tLQogZnMvc21i
L2NsaWVudC9jaWZzZ2xvYi5oIHwgIDEgKwogZnMvc21iL2NsaWVudC9jb25uZWN0LmMgIHwgIDEg
KwogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgIHwgMTEgKysrKysrKysrKy0KIGZzL3NtYi9jbGll
bnQvc21iMnBkdS5jICB8IDExICsrKysrKysrKysrCiBmcy9zbWIvY29tbW9uL3NtYjJwZHUuaCAg
fCAyMiArKysrKysrKysrKysrKysrKysrKysrCiA1IGZpbGVzIGNoYW5nZWQsIDQ1IGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9i
LmggYi9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKaW5kZXggMTU4OGY5ODY2MGFhLi4zMjcxYmU2
NWZkNmYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaAorKysgYi9mcy9zbWIv
Y2xpZW50L2NpZnNnbG9iLmgKQEAgLTc0Nyw2ICs3NDcsNyBAQCBzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvIHsKIAkgKi8KICNkZWZpbmUgQ0lGU19TRVJWRVJfSVNfQ0hBTihzZXJ2ZXIpCSghIShzZXJ2
ZXIpLT5wcmltYXJ5X3NlcnZlcikKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpwcmltYXJ5X3Nl
cnZlcjsKKwlfX3UxNiBjaGFubmVsX3NlcXVlbmNlX251bTsgIC8qIGluY3JlbWVudGVkIG9uIHBy
aW1hcnkgY2hhbm5lbCBvbiBlYWNoIGNoYW4gcmVjb25uZWN0ICovCiAKICNpZmRlZiBDT05GSUdf
Q0lGU19TV05fVVBDQUxMCiAJYm9vbCB1c2Vfc3duX2RzdGFkZHI7CmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IGUxOWE5
YzgxYTVmYS4uZjJkMDhkMGY5MzczIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3Qu
YworKysgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpAQCAtMTY4Niw2ICsxNjg2LDcgQEAgY2lm
c19nZXRfdGNwX3Nlc3Npb24oc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4LAogCQljdHgtPnRh
cmdldF9yZmMxMDAxX25hbWUsIFJGQzEwMDFfTkFNRV9MRU5fV0lUSF9OVUxMKTsKIAl0Y3Bfc2Vz
LT5zZXNzaW9uX2VzdGFiID0gZmFsc2U7CiAJdGNwX3Nlcy0+c2VxdWVuY2VfbnVtYmVyID0gMDsK
Kwl0Y3Bfc2VzLT5jaGFubmVsX3NlcXVlbmNlX251bSA9IDA7IC8qIG9ubHkgdHJhY2tlZCBmb3Ig
cHJpbWFyeSBjaGFubmVsICovCiAJdGNwX3Nlcy0+cmVjb25uZWN0X2luc3RhbmNlID0gMTsKIAl0
Y3Bfc2VzLT5sc3RycCA9IGppZmZpZXM7CiAJdGNwX3Nlcy0+Y29tcHJlc3NfYWxnb3JpdGhtID0g
Y3B1X3RvX2xlMTYoY3R4LT5jb21wcmVzc2lvbik7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50
L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IDM4YmM5MjM3MTU2MC4u
MjVhMjUxOTNmOTYyIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYworKysgYi9m
cy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtMTcyLDggKzE3MiwxNyBAQCBzbWIyX3NldF9jcmVk
aXRzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgY29uc3QgaW50IHZhbCkKIAogCXNw
aW5fbG9jaygmc2VydmVyLT5yZXFfbG9jayk7CiAJc2VydmVyLT5jcmVkaXRzID0gdmFsOwotCWlm
ICh2YWwgPT0gMSkKKwlpZiAodmFsID09IDEpIHsKIAkJc2VydmVyLT5yZWNvbm5lY3RfaW5zdGFu
Y2UrKzsKKwkJLyoKKwkJICogQ2hhbm5lbFNlcXVlbmNlIHVwZGF0ZWQgZm9yIGFsbCBjaGFubmVs
cyBpbiBwcmltYXJ5IGNoYW5uZWwgc28gdGhhdCBjb25zaXN0ZW50CisJCSAqIGFjcm9zcyBTTUIz
IHJlcXVlc3RzIHNlbnQgb24gYW55IGNoYW5uZWwuIFNlZSBNUy1TTUIyIDMuMi40LjEgYW5kIDMu
Mi43LjEKKwkJICovCisJCWlmIChDSUZTX1NFUlZFUl9JU19DSEFOKHNlcnZlcikpCisJCQlzZXJ2
ZXItPnByaW1hcnlfc2VydmVyLT5jaGFubmVsX3NlcXVlbmNlX251bSsrOworCQllbHNlCisJCQlz
ZXJ2ZXItPmNoYW5uZWxfc2VxdWVuY2VfbnVtKys7CisJfQogCXNjcmVkaXRzID0gc2VydmVyLT5j
cmVkaXRzOwogCWluX2ZsaWdodCA9IHNlcnZlci0+aW5fZmxpZ2h0OwogCXNwaW5fdW5sb2NrKCZz
ZXJ2ZXItPnJlcV9sb2NrKTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jIGIv
ZnMvc21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggYTQ1N2YwN2Y4MjBkLi45YzdlNDZiN2U3Yzcg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
c21iMnBkdS5jCkBAIC04OCw5ICs4OCwyMCBAQCBzbWIyX2hkcl9hc3NlbWJsZShzdHJ1Y3Qgc21i
Ml9oZHIgKnNoZHIsIF9fbGUxNiBzbWIyX2NtZCwKIAkJICBjb25zdCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkgIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIHsKKwlzdHJ1Y3Qg
c21iM19oZHJfcmVxICpzbWIzX2hkcjsKIAlzaGRyLT5Qcm90b2NvbElkID0gU01CMl9QUk9UT19O
VU1CRVI7CiAJc2hkci0+U3RydWN0dXJlU2l6ZSA9IGNwdV90b19sZTE2KDY0KTsKIAlzaGRyLT5D
b21tYW5kID0gc21iMl9jbWQ7CisJaWYgKHNlcnZlci0+ZGlhbGVjdCA+PSBTTUIzMF9QUk9UX0lE
KSB7CisJCS8qIEFmdGVyIHJlY29ubmVjdCBTTUIzIG11c3Qgc2V0IENoYW5uZWxTZXF1ZW5jZSBv
biBzdWJzZXF1ZW50IHJlcXMgKi8KKwkJc21iM19oZHIgPSAoc3RydWN0IHNtYjNfaGRyX3JlcSAq
KXNoZHI7CisJCS8qIGlmIHByaW1hcnkgY2hhbm5lbCBpcyBub3Qgc2V0IHlldCwgdXNlIGRlZmF1
bHQgY2hhbm5lbCBmb3IgY2hhbiBzZXF1ZW5jZSBudW0gKi8KKwkJaWYgKENJRlNfU0VSVkVSX0lT
X0NIQU4oc2VydmVyKSkKKwkJCXNtYjNfaGRyLT5DaGFubmVsU2VxdWVuY2UgPQorCQkJCWNwdV90
b19sZTE2KHNlcnZlci0+cHJpbWFyeV9zZXJ2ZXItPmNoYW5uZWxfc2VxdWVuY2VfbnVtKTsKKwkJ
ZWxzZQorCQkJc21iM19oZHItPkNoYW5uZWxTZXF1ZW5jZSA9IGNwdV90b19sZTE2KHNlcnZlci0+
Y2hhbm5lbF9zZXF1ZW5jZV9udW0pOworCX0KIAlpZiAoc2VydmVyKSB7CiAJCXNwaW5fbG9jaygm
c2VydmVyLT5yZXFfbG9jayk7CiAJCS8qIFJlcXVlc3QgdXAgdG8gMTAgY3JlZGl0cyBidXQgZG9u
J3QgZ28gb3ZlciB0aGUgbGltaXQuICovCmRpZmYgLS1naXQgYS9mcy9zbWIvY29tbW9uL3NtYjJw
ZHUuaCBiL2ZzL3NtYi9jb21tb24vc21iMnBkdS5oCmluZGV4IGJhZTU5MGVlYzg3MS4uMjY4MDI1
MWI5YWFjIDEwMDY0NAotLS0gYS9mcy9zbWIvY29tbW9uL3NtYjJwZHUuaAorKysgYi9mcy9zbWIv
Y29tbW9uL3NtYjJwZHUuaApAQCAtMTUzLDYgKzE1MywyOCBAQCBzdHJ1Y3Qgc21iMl9oZHIgewog
CV9fdTggICBTaWduYXR1cmVbMTZdOwogfSBfX3BhY2tlZDsKIAorc3RydWN0IHNtYjNfaGRyX3Jl
cSB7CisJX19sZTMyIFByb3RvY29sSWQ7CS8qIDB4RkUgJ1MnICdNJyAnQicgKi8KKwlfX2xlMTYg
U3RydWN0dXJlU2l6ZTsJLyogNjQgKi8KKwlfX2xlMTYgQ3JlZGl0Q2hhcmdlOwkvKiBNQlogKi8K
KwlfX2xlMTYgQ2hhbm5lbFNlcXVlbmNlOyAvKiBTZWUgTVMtU01CMiAzLjIuNC4xIGFuZCAzLjIu
Ny4xICovCisJX19sZTE2IFJlc2VydmVkOworCV9fbGUxNiBDb21tYW5kOworCV9fbGUxNiBDcmVk
aXRSZXF1ZXN0OwkvKiBDcmVkaXRSZXNwb25zZSAqLworCV9fbGUzMiBGbGFnczsKKwlfX2xlMzIg
TmV4dENvbW1hbmQ7CisJX19sZTY0IE1lc3NhZ2VJZDsKKwl1bmlvbiB7CisJCXN0cnVjdCB7CisJ
CQlfX2xlMzIgUHJvY2Vzc0lkOworCQkJX19sZTMyICBUcmVlSWQ7CisJCX0gX19wYWNrZWQgU3lu
Y0lkOworCQlfX2xlNjQgIEFzeW5jSWQ7CisJfSBfX3BhY2tlZCBJZDsKKwlfX2xlNjQgIFNlc3Np
b25JZDsKKwlfX3U4ICAgU2lnbmF0dXJlWzE2XTsKK30gX19wYWNrZWQ7CisKIHN0cnVjdCBzbWIy
X3BkdSB7CiAJc3RydWN0IHNtYjJfaGRyIGhkcjsKIAlfX2xlMTYgU3RydWN0dXJlU2l6ZTI7IC8q
IHNpemUgb2Ygd2N0IGFyZWEgKHZhcmllcywgcmVxdWVzdCBzcGVjaWZpYykgKi8KLS0gCjIuMzQu
MQoK
--0000000000009ec2c30603b8189e--
