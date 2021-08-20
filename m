Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434A9C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Aug 2021 23:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A07F61175
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Aug 2021 23:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhHTXTq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Aug 2021 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhHTXTm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Aug 2021 19:19:42 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A12C061575;
        Fri, 20 Aug 2021 16:19:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id n7so19786231ljq.0;
        Fri, 20 Aug 2021 16:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=injNyqk0O05AWAjdLiK5Yd2rg5V8yrPBZJK/UIJi/0o=;
        b=OhxktmJd+PAjFzfrGtZaXuFU/maWnJT19lhfCcPO/L8J8X+Oo/ESSzcDGrn4sYcoMk
         kPS4N3xChJi2pDtasRzktUbuMMqZXEAJPH8gLv6BXeGnRaW7cJjI0LMtaezF1G9bH6lU
         WzkRpPRR6a7udCiBtXnRy/ybXzqlb65uC3/GWpQA/G+d4DsX4AFUmkxAtyWV9iaVkSzj
         CcGrhkBuVfsY4013/Bft+F+a4d3+G6z0bkGvNKhmeFdCMacMv7WTHpC/zfDTgyF/6PXk
         DwUdQcy3j3prh7pR1+s7zLIyIPMDjfC8htOkA5m+1sHQV4Rvdea7qOOnjpTGzTXt8lzE
         RaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=injNyqk0O05AWAjdLiK5Yd2rg5V8yrPBZJK/UIJi/0o=;
        b=RpHWOi17CSHdGAH+pG0gAiEB8CJNRg1WMqdVEmrnYtpolNqElBfFVHcHvrKFrBaLJs
         as4b210f1MOazaKUkw4OlsCPnlNpfAborqiHx6iTEz5DOI+r2k3x5MJtKZi7nITFsObK
         GoxMI/pQ4v94nkYUnKsnLNhDmHF60Uxdw4wXXHYymr/RJZyOA/wiFO9wbKJdNq61VS1i
         /kKecMJPXzx/lSBX2pV5MSPCZvB6lmdPd8l0hHze7IxrQXYFgM9XlfrJ8ojSX+xI2Ogy
         mA6ZRYb4GkwepSLk78W8IpXd9HS6L+yVj9sUbiND/9iqsjGH24CcOm1mwMPIerGhf/sy
         UTdQ==
X-Gm-Message-State: AOAM533oP8AbwDxERndFxh3CSAqYv8j5nym6Vj0K+8O5S4yOMVB8g6pQ
        WfeMF9AR05qIAN+R3WQJokxR191wBZarMlShTi9AJXCiNWp/fw==
X-Google-Smtp-Source: ABdhPJzyeII4XBwTu1jh+7vIYJxM4YYTmKb9f2YNy+vDAz9XkX6KruBe+a/aKqw7IhEh0xoyZPVueZ3V2sNx4Y8AX0k=
X-Received: by 2002:a2e:2417:: with SMTP id k23mr17886463ljk.256.1629501541700;
 Fri, 20 Aug 2021 16:19:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 20 Aug 2021 18:18:50 -0500
Message-ID: <CAH2r5mvxX6BqLvgWO18QE+rQsAZoAzopvu5S3fyy45a+Y-w_MQ@mail.gmail.com>
Subject: [PATCH] oid_registry: Add OIDs for missing Spnego auth mechanisms to Macs
To:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000008def7405ca05e408"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008def7405ca05e408
Content-Type: text/plain; charset="UTF-8"

 In testing mounts to Macs, noticed that the OIDS for some
 GSSAPI/SPNEGO auth mechanisms sent by the server were not
 recognized and were missing from the header.

 Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 3d8db1f6a5db..2728842721bc 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -70,6 +70,9 @@ enum OID {

        OID_spnego,                     /* 1.3.6.1.5.5.2 */

+       OID_IAKerb,                     /* 1.3.6.1.5.2.5 */
+       OID_PKU2U                       /* 1.3.5.1.5.2.7 */
+       OID_Scram,                      /* 1.3.6.1.5.5.14 */
        OID_certAuthInfoAccess,         /* 1.3.6.1.5.5.7.1.1 */
        OID_sha1,                       /* 1.3.14.3.2.26 */
        OID_id_ansip384r1,              /* 1.3.132.0.34 */
@@ -104,6 +107,10 @@ enum OID {
        OID_authorityKeyIdentifier,     /* 2.5.29.35 */
        OID_extKeyUsage,                /* 2.5.29.37 */

+       /* Heimdal mechanisms */
+       OID_NetlogonMechanism,          /* 1.2.752.43.14.2 */
+       OID_appleLocalKdcSupported,     /* 1.2.752.43.14.3 */
+
        /* EC-RDSA */
        OID_gostCPSignA,                /* 1.2.643.2.2.35.1 */
        OID_gostCPSignB,                /* 1.2.643.2.2.35.2 */


-- 
Thanks,

Steve

--0000000000008def7405ca05e408
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-oid_registry-Add-OIDs-for-missing-Spnego-auth-mechan.patch"
Content-Disposition: attachment; 
	filename="0001-oid_registry-Add-OIDs-for-missing-Spnego-auth-mechan.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kskz4e7j0>
X-Attachment-Id: f_kskz4e7j0

RnJvbSBmNDRlODEzYmVlNDdhOTA3YTA2MmE4NjNiMWYwMWZmZTJhOGY5ODY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjAgQXVnIDIwMjEgMTg6MTA6MzYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBv
aWRfcmVnaXN0cnk6IEFkZCBPSURzIGZvciBtaXNzaW5nIFNwbmVnbyBhdXRoIG1lY2hhbmlzbXMg
dG8KIE1hY3MKCkluIHRlc3RpbmcgbW91bnRzIHRvIE1hY3MsIG5vdGljZWQgdGhhdCB0aGUgT0lE
UyBmb3Igc29tZQpHU1NBUEkvU1BORUdPIGF1dGggbWVjaGFuaXNtcyBzZW50IGJ5IHRoZSBzZXJ2
ZXIgd2VyZSBub3QKcmVjb2duaXplZCBhbmQgd2VyZSBtaXNzaW5nIGZyb20gdGhlIGhlYWRlci4K
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBpbmNsdWRlL2xpbnV4L29pZF9yZWdpc3RyeS5oIHwgNyArKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9vaWRfcmVnaXN0
cnkuaCBiL2luY2x1ZGUvbGludXgvb2lkX3JlZ2lzdHJ5LmgKaW5kZXggM2Q4ZGIxZjZhNWRiLi4y
NzI4ODQyNzIxYmMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvb2lkX3JlZ2lzdHJ5LmgKKysr
IGIvaW5jbHVkZS9saW51eC9vaWRfcmVnaXN0cnkuaApAQCAtNzAsNiArNzAsOSBAQCBlbnVtIE9J
RCB7CiAKIAlPSURfc3BuZWdvLAkJCS8qIDEuMy42LjEuNS41LjIgKi8KIAorCU9JRF9JQUtlcmIs
CQkJLyogMS4zLjYuMS41LjIuNSAqLworCU9JRF9QS1UyVQkJCS8qIDEuMy41LjEuNS4yLjcgKi8K
KwlPSURfU2NyYW0sCQkJLyogMS4zLjYuMS41LjUuMTQgKi8KIAlPSURfY2VydEF1dGhJbmZvQWNj
ZXNzLAkJLyogMS4zLjYuMS41LjUuNy4xLjEgKi8KIAlPSURfc2hhMSwJCQkvKiAxLjMuMTQuMy4y
LjI2ICovCiAJT0lEX2lkX2Fuc2lwMzg0cjEsCQkvKiAxLjMuMTMyLjAuMzQgKi8KQEAgLTEwNCw2
ICsxMDcsMTAgQEAgZW51bSBPSUQgewogCU9JRF9hdXRob3JpdHlLZXlJZGVudGlmaWVyLAkvKiAy
LjUuMjkuMzUgKi8KIAlPSURfZXh0S2V5VXNhZ2UsCQkvKiAyLjUuMjkuMzcgKi8KIAorCS8qIEhl
aW1kYWwgbWVjaGFuaXNtcyAqLworCU9JRF9OZXRsb2dvbk1lY2hhbmlzbSwJCS8qIDEuMi43NTIu
NDMuMTQuMiAqLworCU9JRF9hcHBsZUxvY2FsS2RjU3VwcG9ydGVkLAkvKiAxLjIuNzUyLjQzLjE0
LjMgKi8KKwogCS8qIEVDLVJEU0EgKi8KIAlPSURfZ29zdENQU2lnbkEsCQkvKiAxLjIuNjQzLjIu
Mi4zNS4xICovCiAJT0lEX2dvc3RDUFNpZ25CLAkJLyogMS4yLjY0My4yLjIuMzUuMiAqLwotLSAK
Mi4zMC4yCgo=
--0000000000008def7405ca05e408--
