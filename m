Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E215EC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 22 May 2022 23:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiEVXgy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 19:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbiEVXgx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 19:36:53 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ADCD7A
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 16:36:52 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id i25so1412314vkr.8
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 16:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ooe+mKEXt9RL6Fgaj75WWsNFXYoZHf4wod9h5uNnXtI=;
        b=Y3dzzf2CT4uLS6NRrHof3JLM2nKA58c+lKyD/P9W/zGstVwl5j0uxEgar8S6xmckQb
         gUwFr831Soss6lV+ih33d3CUoyQTE4/OKdHc7Ret9rg+aJF4b4ZWEYs+owY21aV8qDfr
         CTpDd5zY7Et8S+rybKTfl2qOxp/yTKOk5BLdAhPSje101ytULl1/GrQ/Mcsx4GXxecO6
         DY13zusudre0VaJZQrL3R53iS8v+IU/SF070P/EdJLaM/p59O8mcGK0lwD5iPrvxMeNq
         OYRAtoN5NO/hpfdRu3SNoAdrpaYg08YZ2yTdjggl5gjBAMiwOy4D1bvIFussuqPTJ+O6
         5zMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ooe+mKEXt9RL6Fgaj75WWsNFXYoZHf4wod9h5uNnXtI=;
        b=gk+TqvNpawT/j1sbNsJevOTUWqnnZto0N+1GghDK7Co/jGJPOiqgqzF4hfbMHn5wHT
         yWP+JA2viRr6JNvcZRRQLdYBJ5HfQQ3Ywe5M4i1UD2EG3ceeYOWUgRCcIIMEP0+j89y9
         s4HCrgXUJCxd7432CHcpW1VV3Qbfl0KcLZB8XCpvoOXzq5G9z7mrjJWo4hlNlf7hm6hl
         WMxPMqrs52HZQSYz74PniigvK5mcbaiUAOq0v6IXd9MZM/hGHRn3QUsgZnjzZ/riLkVb
         gjzTCs0Cy3wvo/ItnG4m++NvzpEYXkt77R/2TKUXuAnJ8/tXrqeevTShKfOKR6LwKr1q
         0Zow==
X-Gm-Message-State: AOAM531TvapeC1E8JL58aUum2uBrqOo2L2tsRwGrWNRp6gNBTwoBrNIR
        z8KeZYezUPwUtj1sdELtrk+LQLFr8rHWSyC14u0T8xL1pA4=
X-Google-Smtp-Source: ABdhPJz2HoZxeivpjO7mZFAafKrnP3SNAyfaxavpbtwoDPNMSg+8Gkrx2cihRD9oH+UNaKPN87M/OcmaCVQIR6R6MJc=
X-Received: by 2002:a1f:a7d5:0:b0:34e:4447:6309 with SMTP id
 q204-20020a1fa7d5000000b0034e44476309mr6968204vke.38.1653262610639; Sun, 22
 May 2022 16:36:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 May 2022 18:36:39 -0500
Message-ID: <CAH2r5muiMW76Xt2zRNJWTcQVuewEj3Qs3p4oc8tvEyw5f6528g@mail.gmail.com>
Subject: [PATCH][SMB3] Add defines for various newer FSCTLs
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000a0cd9205dfa23245"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a0cd9205dfa23245
Content-Type: text/plain; charset="UTF-8"

Checking MS-FSCC section 2.3 found six FSCTL defines that were missing

See attached
-- 
Thanks,

Steve

--000000000000a0cd9205dfa23245
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-defines-for-various-newer-FSCTLs.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-defines-for-various-newer-FSCTLs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3hxukgx0>
X-Attachment-Id: f_l3hxukgx0

RnJvbSA4MmE3MGUzNDFiOTRmZGYwMmE2MWVmNzExOGFiMzRhOWMxNWY5ZjRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjIgTWF5IDIwMjIgMTg6MzA6MzggLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
U01CM10gQWRkIGRlZmluZXMgZm9yIHZhcmlvdXMgbmV3ZXIgRlNDVExzCgpDaGVja2luZyBNUy1G
U0NDIHNlY3Rpb24gMi4zIGZvdW5kIHNpeCBGU0NUTCBkZWZpbmVzCnRoYXQgd2VyZSBtaXNzaW5n
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvc21iZnNfY29tbW9uL3NtYmZzY3RsLmggfCA2ICsrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYmZzX2NvbW1vbi9zbWJmc2N0bC5o
IGIvZnMvc21iZnNfY29tbW9uL3NtYmZzY3RsLmgKaW5kZXggZDUxOTM5YzQzYWQ3Li45ZTllODZk
ZTk1ZjYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYmZzX2NvbW1vbi9zbWJmc2N0bC5oCisrKyBiL2ZzL3Nt
YmZzX2NvbW1vbi9zbWJmc2N0bC5oCkBAIC04OCwyMSArODgsMjcgQEAKICNkZWZpbmUgRlNDVExf
UkVBRF9SQVdfRU5DUllQVEVEICAgICAweDAwMDkwMEUzIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNk
ZWZpbmUgRlNDVExfUkVBRF9GSUxFX1VTTl9EQVRBICAgICAweDAwMDkwMEVCIC8qIEJCIGFkZCBz
dHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfV1JJVEVfVVNOX0NMT1NFX1JFQ09SRCAweDAwMDkwMEVG
IC8qIEJCIGFkZCBzdHJ1Y3QgKi8KKyNkZWZpbmUgRlNDVExfTUFSS19IQU5ETEUJICAgICAweDAw
MDkwMEZDIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfU0lTX0NPUFlGSUxFICAg
ICAgICAgICAweDAwMDkwMTAwIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfUkVD
QUxMX0ZJTEUgICAgICAgICAgICAweDAwMDkwMTE3IC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZp
bmUgRlNDVExfUVVFUllfU1BBUklOR19JTkZPICAgICAweDAwMDkwMTM4IC8qIEJCIGFkZCBzdHJ1
Y3QgKi8KKyNkZWZpbmUgRlNDVExfUVVFUllfT05fRElTS19WT0xVTUVfSU5GTyAweDAwMDkxM0MK
ICNkZWZpbmUgRlNDVExfU0VUX1pFUk9fT05fREVBTExPQyAgICAweDAwMDkwMTk0IC8qIEJCIGFk
ZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfU0VUX1NIT1JUX05BTUVfQkVIQVZJT1IgMHgwMDA5
MDFCNCAvKiBCQiBhZGQgc3RydWN0ICovCiAjZGVmaW5lIEZTQ1RMX0dFVF9JTlRFR1JJVFlfSU5G
T1JNQVRJT04gMHgwMDA5MDI3QworI2RlZmluZSBGU0NUTF9RVUVSWV9GSUxFX1JFR0lPTlMgICAg
IDB4MDAwOTAyODQKICNkZWZpbmUgRlNDVExfR0VUX1JFRlNfVk9MVU1FX0RBVEEgICAweDAwMDkw
MkQ4IC8qIFNlZSBNUy1GU0NDIDIuMy4yNCAqLwogI2RlZmluZSBGU0NUTF9TRVRfSU5URUdSSVRZ
X0lORk9STUFUSU9OX0VYVCAweDAwMDkwMzgwCiAjZGVmaW5lIEZTQ1RMX0dFVF9SRVRSSUVWQUxf
UE9JTlRFUlNfQU5EX1JFRkNPVU5UIDB4MDAwOTAzZDMKICNkZWZpbmUgRlNDVExfR0VUX1JFVFJJ
RVZBTF9QT0lOVEVSX0NPVU5UIDB4MDAwOTA0MmIKICNkZWZpbmUgRlNDVExfUkVGU19TVFJFQU1f
U05BUFNIT1RfTUFOQUdFTUVOVCAweDAwMDkwNDQwCiAjZGVmaW5lIEZTQ1RMX1FVRVJZX0FMTE9D
QVRFRF9SQU5HRVMgMHgwMDA5NDBDRgorI2RlZmluZSBGU0NUTF9PRkZMT0FEX1JFQUQJMHgwMDA5
NDI2NCAvKiBCQiBhZGQgc3RydWN0ICovCisjZGVmaW5lIEZTQ1RMX09GRkxPQURfV1JJVEUJMHgw
MDA5ODI2OCAvKiBCQiBhZGQgc3RydWN0ICovCiAjZGVmaW5lIEZTQ1RMX1NFVF9ERUZFQ1RfTUFO
QUdFTUVOVCAgMHgwMDA5ODEzNCAvKiBCQiBhZGQgc3RydWN0ICovCiAjZGVmaW5lIEZTQ1RMX0ZJ
TEVfTEVWRUxfVFJJTSAgICAgICAgMHgwMDA5ODIwOCAvKiBCQiBhZGQgc3RydWN0ICovCiAjZGVm
aW5lIEZTQ1RMX0RVUExJQ0FURV9FWFRFTlRTX1RPX0ZJTEUgMHgwMDA5ODM0NAorI2RlZmluZSBG
U0NUTF9EVVBMSUNBVEVfRVhURU5UU19UT19GSUxFX0VYIDB4MDAwOTgzRTgKICNkZWZpbmUgRlND
VExfU0lTX0xJTktfRklMRVMgICAgICAgICAweDAwMDlDMTA0CiAjZGVmaW5lIEZTQ1RMX1NFVF9J
TlRFR1JJVFlfSU5GT1JNQVRJT04gMHgwMDA5QzI4MAogI2RlZmluZSBGU0NUTF9QSVBFX1BFRUsg
ICAgICAgICAgICAgIDB4MDAxMTQwMEMgLyogQkIgYWRkIHN0cnVjdCAqLwotLSAKMi4zNC4xCgo=
--000000000000a0cd9205dfa23245--
