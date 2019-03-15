Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AE1C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 00:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8838721873
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 00:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVdufyIu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfCOAVn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 20:21:43 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:35637 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfCOAVn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 20:21:43 -0400
Received: by mail-pg1-f176.google.com with SMTP id e17so5130284pgd.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 17:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=CPnlFNf1PIk3YiY8CRjoJoVELXWMUs/B2X/31THIKDk=;
        b=aVdufyIuIPuYarSsrEHCiXacuw5YjEdG2TRH/1CV8xxfHU/y1ITVlUso/i1EM+WWEq
         Oh3B4lXzsaEytO1mvGhdGFWSSQFx/qCZoXDuXhxPfl0Yomh7lUpYajDWReeiK20R4aEo
         Tx555Q44pYDYSdl+u6CXiZbnW/VM63M4uUYnWPQrwgId6sHx6m7Z8WQnoOc80BmYBVtD
         DN9j+NHFiF2Bh2UNSsDbzXy2qJ7/i18sQGEsrRBH2iECG68IMmSPl6KNZAuleuIXPqUq
         Sl3PYXFr5NVBMkDqVNmCj1gKjwMuODChb6KxbV68QsTpJw+btq+PFm6/dKkOW3elDwK8
         Z2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CPnlFNf1PIk3YiY8CRjoJoVELXWMUs/B2X/31THIKDk=;
        b=MYIz1gEemHBXyOb+7bYomREp36C1qqMB9Z4wSnLTWrf3eufG9ncxp/uGfJITHmcHq+
         hqdXsnnQne80vRLPjD9st8pyY7DfTZRQmS+Vrap5kTMlTOK3StOq9Vw3x1XLR1r2Q851
         +Zpi30XWMZmVFHcwvLBmxBF1kN0/D2CT3MJAKqN3GSYAohIaFhf293JEv3zdRpUmYSvo
         W8HGE5W5IYd+VFtQKOi/VeQ9Fbm0t8CJmxwQIBx6Po/4Jc4xr70sx6NhpDnJ/cmwtAWn
         0XUm+XTHMdbwAwhRLAodT6ExVm1A1hVizoUUFxNy0PgJ8s0cztUDT/XLnK/4FqAWPEam
         6G4g==
X-Gm-Message-State: APjAAAVMnnG3cs5/gzBu4LRAaHsg21zdz2XubHpqsvZw0u7oK8drUL4X
        D4VKs8qUZSMAS5Ld98NrKSUCC1SE3YbCBab9bj0KxsQd
X-Google-Smtp-Source: APXvYqwoSKYJkawdjQ4V/oICO3LqmN0aSvFwfg3PhNUKiaFyYmZal82G0CzofJF80F4x7Mu4JD6qw/kmGSJcPDH1T14=
X-Received: by 2002:a17:902:147:: with SMTP id 65mr1162683plb.18.1552609301382;
 Thu, 14 Mar 2019 17:21:41 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 19:21:29 -0500
Message-ID: <CAH2r5ms=Mb8Ogx2+5jdzXOkTwfexKB0Xn=ukb6LroBbq2F+Q=Q@mail.gmail.com>
Subject: [SMB3] [PATCH] Pass through FSCTL for tools like smbinfo
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000e28ee505841705ca"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e28ee505841705ca
Content-Type: text/plain; charset="UTF-8"

Forwarding Ronnie's patch to the broader list

For debugging purposes we often have to be able to query
additional information only available via SMB3 FSCTL
from the server from user space tools (e.g. like
cifs-utils's smbinfo).  See MS-FSCC and MS-SMB2 protocol
specifications for more details.

-- 
Thanks,

Steve

--000000000000e28ee505841705ca
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Allow-SMB3-FSCTL-queries-to-be-sent-to-server-f.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Allow-SMB3-FSCTL-queries-to-be-sent-to-server-f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt9baa1h0>
X-Attachment-Id: f_jt9baa1h0

RnJvbSA3NWVjZmUzYzkxZDViMzFlNjI3ZGVkOTM2YzUzMzFiODM0MzZlYTcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IEZyaSwgMTUgTWFyIDIwMTkgMDk6MDc6MjIgKzEwMDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBBbGxvdyBTTUIzIEZTQ1RMIHF1ZXJpZXMgdG8gYmUgc2VudCB0byBzZXJ2ZXIgZnJvbQog
dG9vbHMKCkZvciBkZWJ1Z2dpbmcgcHVycG9zZXMgd2Ugb2Z0ZW4gaGF2ZSB0byBiZSBhYmxlIHRv
IHF1ZXJ5CmFkZGl0aW9uYWwgaW5mb3JtYXRpb24gb25seSBhdmFpbGFibGUgdmlhIFNNQjMgRlND
VEwKZnJvbSB0aGUgc2VydmVyIGZyb20gdXNlciBzcGFjZSB0b29scyAoZS5nLiBsaWtlCmNpZnMt
dXRpbHMncyBzbWJpbmZvKS4gIFNlZSBNUy1GU0NDIGFuZCBNUy1TTUIyIHByb3RvY29sCnNwZWNp
ZmljYXRpb25zIGZvciBtb3JlIGRldGFpbHMuCgpTaWduZWQtb2ZmLWJ5OiBSb25uaWUgU2FobGJl
cmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDYyICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
NDYgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCAxYzhkMzY4NGJiOGIuLjgxMDI0MDlk
MTBlNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3Bz
LmMKQEAgLTEzMzAsNyArMTMzMCw4IEBAIHNtYjJfaW9jdGxfcXVlcnlfaW5mbyhjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLAogCXN0cnVjdCBzbWJfcXVlcnlfaW5mbyBfX3VzZXIgKnBxaTsKIAlpbnQg
cmMgPSAwOwogCWludCBmbGFncyA9IDA7Ci0Jc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKnJz
cCA9IE5VTEw7CisJc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKnFpX3JzcCA9IE5VTEw7CisJ
c3RydWN0IHNtYjJfaW9jdGxfcnNwICppb19yc3AgPSBOVUxMOwogCXZvaWQgKmJ1ZmZlciA9IE5V
TEw7CiAJc3RydWN0IHNtYl9ycXN0IHJxc3RbM107CiAJaW50IHJlc3BfYnVmdHlwZVszXTsKQEAg
LTEzNDAsNiArMTM0MSw3IEBAIHNtYjJfaW9jdGxfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLAogCXU4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX05PTkU7CiAJc3RydWN0IGNp
ZnNfZmlkIGZpZDsKIAlzdHJ1Y3Qga3ZlYyBxaV9pb3ZbMV07CisJc3RydWN0IGt2ZWMgaW9faW92
W1NNQjJfSU9DVExfSU9WX1NJWkVdOwogCXN0cnVjdCBrdmVjIGNsb3NlX2lvdlsxXTsKIAogCW1l
bXNldChycXN0LCAwLCBzaXplb2YocnFzdCkpOwpAQCAtMTM5NCw4ICsxMzk2LDE2IEBAIHNtYjJf
aW9jdGxfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAogCQkvKiBDYW4gZXZlbnR1
YWxseSByZWxheCBwZXJtIGNoZWNrIHNpbmNlIHNlcnZlciBlbmZvcmNlcyB0b28gKi8KIAkJaWYg
KCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQogCQkJcmMgPSAtRVBFUk07Ci0JCWVsc2UgIC8qIFRC
RDogQWRkIGNvZGUgdG8gY29tcG91bmQgRlNDVEwgKi8KLQkJCXJjID0gLUVPUE5PVFNVUFA7CisJ
CWVsc2UgIHsKKwkJCW1lbXNldCgmaW9faW92LCAwLCBzaXplb2YoaW9faW92KSk7CisJCQlycXN0
WzFdLnJxX2lvdiA9IGlvX2lvdjsKKwkJCXJxc3RbMV0ucnFfbnZlYyA9IFNNQjJfSU9DVExfSU9W
X1NJWkU7CisKKwkJCXJjID0gU01CMl9pb2N0bF9pbml0KHRjb24sICZycXN0WzFdLAorCQkJCQkg
ICAgIENPTVBPVU5EX0ZJRCwgQ09NUE9VTkRfRklELAorCQkJCQkgICAgIHFpLmluZm9fdHlwZSwg
dHJ1ZSwgTlVMTCwKKwkJCQkJICAgICAwKTsKKwkJfQogCX0gZWxzZSBpZiAocWkuZmxhZ3MgPT0g
UEFTU1RIUlVfUVVFUllfSU5GTykgewogCQltZW1zZXQoJnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lv
dikpOwogCQlycXN0WzFdLnJxX2lvdiA9IHFpX2lvdjsKQEAgLTE0MzAsMjQgKzE0NDAsNDQgQEAg
c21iMl9pb2N0bF9xdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiAJCQkJcmVzcF9i
dWZ0eXBlLCByc3BfaW92KTsKIAlpZiAocmMpCiAJCWdvdG8gaXFpbmZfZXhpdDsKLQlwcWkgPSAo
c3RydWN0IHNtYl9xdWVyeV9pbmZvIF9fdXNlciAqKWFyZzsKLQlyc3AgPSAoc3RydWN0IHNtYjJf
cXVlcnlfaW5mb19yc3AgKilyc3BfaW92WzFdLmlvdl9iYXNlOwotCWlmIChsZTMyX3RvX2NwdShy
c3AtPk91dHB1dEJ1ZmZlckxlbmd0aCkgPCBxaS5pbnB1dF9idWZmZXJfbGVuZ3RoKQotCQlxaS5p
bnB1dF9idWZmZXJfbGVuZ3RoID0gbGUzMl90b19jcHUocnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgp
OwotCWlmIChjb3B5X3RvX3VzZXIoJnBxaS0+aW5wdXRfYnVmZmVyX2xlbmd0aCwgJnFpLmlucHV0
X2J1ZmZlcl9sZW5ndGgsCi0JCQkgc2l6ZW9mKHFpLmlucHV0X2J1ZmZlcl9sZW5ndGgpKSkgewot
CQlyYyA9IC1FRkFVTFQ7Ci0JCWdvdG8gaXFpbmZfZXhpdDsKLQl9Ci0JaWYgKGNvcHlfdG9fdXNl
cihwcWkgKyAxLCByc3AtPkJ1ZmZlciwgcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCkpIHsKLQkJcmMg
PSAtRUZBVUxUOwotCQlnb3RvIGlxaW5mX2V4aXQ7CisJaWYgKHFpLmZsYWdzICYgUEFTU1RIUlVf
RlNDVEwpIHsKKwkJcHFpID0gKHN0cnVjdCBzbWJfcXVlcnlfaW5mbyBfX3VzZXIgKilhcmc7CisJ
CWlvX3JzcCA9IChzdHJ1Y3Qgc21iMl9pb2N0bF9yc3AgKilyc3BfaW92WzFdLmlvdl9iYXNlOwor
CQlpZiAobGUzMl90b19jcHUoaW9fcnNwLT5PdXRwdXRDb3VudCkgPCBxaS5pbnB1dF9idWZmZXJf
bGVuZ3RoKQorCQkJcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCA9IGxlMzJfdG9fY3B1KGlvX3JzcC0+
T3V0cHV0Q291bnQpOworCQlpZiAoY29weV90b191c2VyKCZwcWktPmlucHV0X2J1ZmZlcl9sZW5n
dGgsICZxaS5pbnB1dF9idWZmZXJfbGVuZ3RoLAorCQkJCSBzaXplb2YocWkuaW5wdXRfYnVmZmVy
X2xlbmd0aCkpKSB7CisJCQlyYyA9IC1FRkFVTFQ7CisJCQlnb3RvIGlxaW5mX2V4aXQ7CisJCX0K
KwkJaWYgKGNvcHlfdG9fdXNlcihwcWkgKyAxLCAmaW9fcnNwWzFdLCBxaS5pbnB1dF9idWZmZXJf
bGVuZ3RoKSkgeworCQkJcmMgPSAtRUZBVUxUOworCQkJZ290byBpcWluZl9leGl0OworCQl9CisJ
fSBlbHNlIHsKKwkJcHFpID0gKHN0cnVjdCBzbWJfcXVlcnlfaW5mbyBfX3VzZXIgKilhcmc7CisJ
CXFpX3JzcCA9IChzdHJ1Y3Qgc21iMl9xdWVyeV9pbmZvX3JzcCAqKXJzcF9pb3ZbMV0uaW92X2Jh
c2U7CisJCWlmIChsZTMyX3RvX2NwdShxaV9yc3AtPk91dHB1dEJ1ZmZlckxlbmd0aCkgPCBxaS5p
bnB1dF9idWZmZXJfbGVuZ3RoKQorCQkJcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCA9IGxlMzJfdG9f
Y3B1KHFpX3JzcC0+T3V0cHV0QnVmZmVyTGVuZ3RoKTsKKwkJaWYgKGNvcHlfdG9fdXNlcigmcHFp
LT5pbnB1dF9idWZmZXJfbGVuZ3RoLCAmcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCwKKwkJCQkgc2l6
ZW9mKHFpLmlucHV0X2J1ZmZlcl9sZW5ndGgpKSkgeworCQkJcmMgPSAtRUZBVUxUOworCQkJZ290
byBpcWluZl9leGl0OworCQl9CisJCWlmIChjb3B5X3RvX3VzZXIocHFpICsgMSwgcWlfcnNwLT5C
dWZmZXIsIHFpLmlucHV0X2J1ZmZlcl9sZW5ndGgpKSB7CisJCQlyYyA9IC1FRkFVTFQ7CisJCQln
b3RvIGlxaW5mX2V4aXQ7CisJCX0KIAl9CiAKICBpcWluZl9leGl0OgogCWtmcmVlKGJ1ZmZlcik7
CiAJU01CMl9vcGVuX2ZyZWUoJnJxc3RbMF0pOwotCVNNQjJfcXVlcnlfaW5mb19mcmVlKCZycXN0
WzFdKTsKKwlpZiAocWkuZmxhZ3MgJiBQQVNTVEhSVV9GU0NUTCkKKwkJU01CMl9pb2N0bF9mcmVl
KCZycXN0WzFdKTsKKwllbHNlCisJCVNNQjJfcXVlcnlfaW5mb19mcmVlKCZycXN0WzFdKTsKKwog
CVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsyXSk7CiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZVsw
XSwgcnNwX2lvdlswXS5pb3ZfYmFzZSk7CiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZVsxXSwg
cnNwX2lvdlsxXS5pb3ZfYmFzZSk7Ci0tIAoyLjE3LjEKCg==
--000000000000e28ee505841705ca--
