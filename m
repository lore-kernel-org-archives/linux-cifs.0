Return-Path: <SRS0=CwqD=5A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9598C10DCE
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 22:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B77206BE
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 22:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3eCO7z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgCOWuX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Mar 2020 18:50:23 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:35333 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbgCOWuW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Mar 2020 18:50:22 -0400
Received: by mail-qk1-f170.google.com with SMTP id d8so23048542qka.2
        for <linux-cifs@vger.kernel.org>; Sun, 15 Mar 2020 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1yhoUv4kMXivgY0Sb7etbcjFy39MOeOnu80PF6qEXxU=;
        b=W3eCO7z8rT4gPvjr2fsnZMo6/ZhY+NdcFkyZPqJpyWJMzWopnoYOnwvjjL8yYKqabI
         vWlKE3jBP8ZjU4j5qX56GymNVL2TIdfECJZ9EyOqRcsmgFXGhsQoCd8hGu2CkYnChA3j
         phL4t5vBVcyHoTUiZysNh7EZvBqXTBICRRTCIO7mRAINNFH3WjDKu9oyE7+9PlUwPPv8
         WqFnuGxrBO0ZFSjC3a4WjOHAz78xJR2RcVnASfFCJxCthO4t1l01axYJrdFxBfP4zlZe
         5Z7K+S3mE2OBXQSjTLc0fORZlvGrEpjhhiOCEIZiLjE1LwXsj/Y2+g55uhxU34y15RmY
         M9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1yhoUv4kMXivgY0Sb7etbcjFy39MOeOnu80PF6qEXxU=;
        b=EUvT0ew2kcaLufVnxYj6xKYX49BnOA7ex6qAm4/2i0XATMrdMI1V32170egfBiVkG1
         lYAp89g6Y/ENwetFPZjTnniCMlmIZ8wMf76ASPuea1bbGDH6HYcC7Jlq6URmogSVJATm
         tCxFQO+hotXkAdE1/WNk9T528KGKqtts5n+zAy+z8f1ZlvFxgP5z6bpwUTjBq2LTXpbO
         bXmK84lEKVYmsFLQLLJI9rc8S5/Q8bfLFn8jlbCB7bxbRSI5ijorHI7H22EII+J5AQAP
         H+MnkWbVJmUX3shVPkS3uzbw9jD8c+O5xGUM8ClpXXaFHespvqj/91J0P67X6gKaDpBv
         1/lw==
X-Gm-Message-State: ANhLgQ1lDoStPSrFEyqcZBGqxp7y5Xl+YewbKouP5/F7qg57NDeagivg
        5rhQas2yfJNAYAWWT5q521p+BUQsCKD5Apw8jfLGfXjK
X-Google-Smtp-Source: ADFU+vtdKxen4Ixwp1iR7WDaYWja5LFL8CFEtu1wHKEsxR5juGB1Z3gJoq/bLxbmVT6yLXtIQxmLsoDJt32n7Q2rVOc=
X-Received: by 2002:a25:f20f:: with SMTP id i15mr30560794ybe.364.1584312621004;
 Sun, 15 Mar 2020 15:50:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 15 Mar 2020 17:50:09 -0500
Message-ID: <CAH2r5ms_oxqwHm56nzabM-x2XMR1Ni-WD1_LEYYxOW_NkswsOQ@mail.gmail.com>
Subject: [SMB3] New compression flags
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000fd147c05a0ec86f9"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fd147c05a0ec86f9
Content-Type: text/plain; charset="UTF-8"

Some compression related flags I noticed were added in the latest MS-SMB2



-- 
Thanks,

Steve

--000000000000fd147c05a0ec86f9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-new-compression-flags.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-new-compression-flags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7tmte1v0>
X-Attachment-Id: f_k7tmte1v0

RnJvbSAxMjgzN2FlMDkxZDUzM2I1OGM4MGEwZGE0M2I5Mjk4MGI3ZmY1YjZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTUgTWFyIDIwMjAgMTc6NDI6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBBZGQgbmV3IGNvbXByZXNzaW9uIGZsYWdzCgpBZGRpdGlvbmFsIGNvbXByZXNzaW9uIGNh
cGFiaWxpdGllcyBjYW4gbm93IGJlIG5lZ290aWF0ZWQgYW5kIGEKbmV3IGNvbXByZXNzaW9uIGFs
Z29yaXRobS4gIEFkZCB0aGUgZmxhZ3MgZm9yIHRoZXNlLgoKU2VlIG5ld2x5IHVwZGF0ZWQgTVMt
U01CMiBzZWN0aW9ucyAzLjEuNC40LjEgYW5kIDIuMi4zLjEuMwoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5o
IHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgK
aW5kZXggODE3YmMwNTMxNTM2Li40YTdkMTU0ZmZmYWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21i
MnBkdS5oCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5oCkBAIC0zMDcsMTEgKzMwNywxNyBAQCBzdHJ1
Y3Qgc21iMl9lbmNyeXB0aW9uX25lZ19jb250ZXh0IHsKICNkZWZpbmUgU01CM19DT01QUkVTU19M
Wk5UMQljcHVfdG9fbGUxNigweDAwMDEpCiAjZGVmaW5lIFNNQjNfQ09NUFJFU1NfTFo3NwljcHVf
dG9fbGUxNigweDAwMDIpCiAjZGVmaW5lIFNNQjNfQ09NUFJFU1NfTFo3N19IVUZGCWNwdV90b19s
ZTE2KDB4MDAwMykKKy8qIFBhdHRlcm4gc2Nhbm5pbmcgYWxnb3JpdGhtIFNlZSBNUy1TTUIyIDMu
MS40LjQuMSAqLworI2RlZmluZSBTTUIzX0NPTVBSRVNTX1BBVFRFUk4JY3B1X3RvX2xlMTYoMHgw
MDA0KQorCisvKiBDb21wcmVzc2lvbiBGbGFncyAqLworI2RlZmluZSBTTUIyX0NPTVBSRVNTSU9O
X0NBUEFCSUxJVElFU19GTEFHX05PTkUJCWNwdV90b19sZTMyKDB4MDAwMDAwMDApCisjZGVmaW5l
IFNNQjJfQ09NUFJFU1NJT05fQ0FQQUJJTElUSUVTX0ZMQUdfQ0hBSU5FRAljcHVfdG9fbGUzMigw
eDAwMDAwMDAxKQogCiBzdHJ1Y3Qgc21iMl9jb21wcmVzc2lvbl9jYXBhYmlsaXRpZXNfY29udGV4
dCB7CiAJX19sZTE2CUNvbnRleHRUeXBlOyAvKiAzICovCiAJX19sZTE2ICBEYXRhTGVuZ3RoOwot
CV9fdTMyCVJlc2VydmVkOworCV9fdTMyCUZsYWdzOwogCV9fbGUxNglDb21wcmVzc2lvbkFsZ29y
aXRobUNvdW50OwogCV9fdTE2CVBhZGRpbmc7CiAJX191MzIJUmVzZXJ2ZWQxOwotLSAKMi4yMC4x
Cgo=
--000000000000fd147c05a0ec86f9--
