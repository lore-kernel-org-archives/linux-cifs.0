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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414D8C2B9F4
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 17:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1244D610CA
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 17:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhFSRbP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Jun 2021 13:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbhFSRbO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Jun 2021 13:31:14 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2821C061574
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 10:29:03 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id s22so18691421ljg.5
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 10:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=yEarzpgEbdZ22/YTEoU6aldugtTo2/E8eABkHttGMtQ=;
        b=fnWpw0fA3FJAS5w+jDQEwb1sYR/4pU+fd0sWLMvYy+TV8a2sefcUJhPWfANG64nKJf
         iwm/ekxPt17m3F9uxJK6J231ZmNML7E+SwRJNKhHhxRNo5+vFRui19g4Cmn8ZjL5fZvP
         IZXEj4oBBAme0PcOz8LsIKYyFNWZ9u7W7PoVYXUZcbXh5HDA8Md9dlwv2DmbM+s/pkCz
         PjmwfiEx8KJ06LfoEzESChONkNYbOrxq4CtiIHIu28z9qPqjbfJhKYz1jFDZE3njFh/p
         TM7hEsAbWQNdA8c8JYBj7evRjcnp5qlc+ripBddJLp4pzijNbrvbwIFbBDsm6lhUqGE9
         8kpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yEarzpgEbdZ22/YTEoU6aldugtTo2/E8eABkHttGMtQ=;
        b=sQSLoiS8y5JOCDTjYzz2Zua/Y1Bpg40KbagLjf7quyS1eR/gOJ5JLC1GWpBq4NV1pm
         13OUtFwPv1IERn0mGOrYYVS67SYEbmpivOA90BKa0/HiH6UpXie7YmUtLLVLEufrdnru
         c7qJu9yHpjgBCvPf+aPtUAtiH7VGNjfMqLjoFKZzJWy2/Ko8fhX/plQkOZZMxWpkuIBF
         clfoAqYcBPuAb0Ud0ivT3g6aAIO571+/sPRhird8qGOUQAzffmM8nokRzlkXYsp7uLPK
         5It+3HcJRKm+lze7I7IygLli+X9yhTVWKKiv1PXJwrWS37+AK9N+IIi5TpUpox8Jg0yW
         ujhQ==
X-Gm-Message-State: AOAM530KrZq5ZhPY3G1PiMtTuNR8r7d1RRqIfxHC4UFFFLuSsvRTKmjH
        1BEwa7TfBmGdj6UTCu7mv/cI2wvsIIjKeEf1xx1qqFpgCpMD4Q==
X-Google-Smtp-Source: ABdhPJxL1usFoCqgVeHHvYLwccfFS3ZS9Ps+/bjbSzrEHiHNJEuVnQuy5gKhM6nrg8JhxpoGOkyRHR/7zJhT5gcOT48=
X-Received: by 2002:a2e:509:: with SMTP id 9mr14650526ljf.6.1624123740425;
 Sat, 19 Jun 2021 10:29:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Jun 2021 12:28:49 -0500
Message-ID: <CAH2r5mt+yji_KjL8cfuU2kRSB823_Hbsjmwo3=43V6raoLyO_g@mail.gmail.com>
Subject: [SMB3][PATCH] fs/cifs/cifs_swn.c:468 cifs_swn_store_swn_addr() error:
 uninitialized symbol 'port'.
To:     CIFS <linux-cifs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Cabrero <scabrero@suse.de>
Content-Type: multipart/mixed; boundary="0000000000009ec02405c521c63c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009ec02405c521c63c
Content-Type: text/plain; charset="UTF-8"

fix uninitialized value for port in witness protocol move

Although in practice this can not occur (since IPv4 and IPv6 are the
only two cases currently supported), it is cleaner to avoid uninitialized
variable warnings.

Addresses smatch warning:
  fs/cifs/cifs_swn.c:468 cifs_swn_store_swn_addr() error:
uninitialized symbol 'port'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
CC: Samuel Cabrero <scabrero@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>


-- 
Thanks,

Steve

--0000000000009ec02405c521c63c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-uninitialized-value-for-port-in-witness-pro.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-uninitialized-value-for-port-in-witness-pro.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq41by730>
X-Attachment-Id: f_kq41by730

RnJvbSA0N2U2Yjk0M2ZiY2U2MDdiOTFkNDBlMDkwZWZiZGIyNzBlM2JmOGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTkgSnVuIDIwMjEgMTI6MjI6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggdW5pbml0aWFsaXplZCB2YWx1ZSBmb3IgcG9ydCBpbiB3aXRuZXNzIHByb3RvY29s
CiBtb3ZlCgpBbHRob3VnaCBpbiBwcmFjdGljZSB0aGlzIGNhbiBub3Qgb2NjdXIgKHNpbmNlIElQ
djQgYW5kIElQdjYgYXJlIHRoZQpvbmx5IHR3byBjYXNlcyBjdXJyZW50bHkgc3VwcG9ydGVkKSwg
aXQgaXMgY2xlYW5lciB0byBhdm9pZCB1bmluaXRpYWxpemVkCnZhcmlhYmxlIHdhcm5pbmdzLgoK
QWRkcmVzc2VzIHNtYXRjaCB3YXJuaW5nOgogIGZzL2NpZnMvY2lmc19zd24uYzo0NjggY2lmc19z
d25fc3RvcmVfc3duX2FkZHIoKSBlcnJvcjogdW5pbml0aWFsaXplZCBzeW1ib2wgJ3BvcnQnLgoK
UmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgpSZXBvcnRlZC1i
eTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPgpDQzogU2FtdWVsIENh
YnJlcm8gPHNjYWJyZXJvQHN1c2UuZGU+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNfc3duLmMgfCAxMCArKystLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19zd24uYyBiL2ZzL2NpZnMvY2lmc19zd24uYwppbmRleCBk
ODI5YjhiZjgzM2UuLjkzYjQ3ODE4YzZjMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX3N3bi5j
CisrKyBiL2ZzL2NpZnMvY2lmc19zd24uYwpAQCAtNDQ3LDE1ICs0NDcsMTMgQEAgc3RhdGljIGlu
dCBjaWZzX3N3bl9zdG9yZV9zd25fYWRkcihjb25zdCBzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSAq
bmV3LAogCQkJCSAgIGNvbnN0IHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlICpvbGQsCiAJCQkJICAg
c3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKmRzdCkKIHsKLQlfX2JlMTYgcG9ydDsKKwlfX2JlMTYg
cG9ydCA9IGNwdV90b19iZTE2KENJRlNfUE9SVCk7CiAKIAlpZiAob2xkLT5zc19mYW1pbHkgPT0g
QUZfSU5FVCkgewogCQlzdHJ1Y3Qgc29ja2FkZHJfaW4gKmlwdjQgPSAoc3RydWN0IHNvY2thZGRy
X2luICopb2xkOwogCiAJCXBvcnQgPSBpcHY0LT5zaW5fcG9ydDsKLQl9Ci0KLQlpZiAob2xkLT5z
c19mYW1pbHkgPT0gQUZfSU5FVDYpIHsKKwl9IGVsc2UgaWYgKG9sZC0+c3NfZmFtaWx5ID09IEFG
X0lORVQ2KSB7CiAJCXN0cnVjdCBzb2NrYWRkcl9pbjYgKmlwdjYgPSAoc3RydWN0IHNvY2thZGRy
X2luNiAqKW9sZDsKIAogCQlwb3J0ID0gaXB2Ni0+c2luNl9wb3J0OwpAQCAtNDY1LDkgKzQ2Myw3
IEBAIHN0YXRpYyBpbnQgY2lmc19zd25fc3RvcmVfc3duX2FkZHIoY29uc3Qgc3RydWN0IHNvY2th
ZGRyX3N0b3JhZ2UgKm5ldywKIAkJc3RydWN0IHNvY2thZGRyX2luICppcHY0ID0gKHN0cnVjdCBz
b2NrYWRkcl9pbiAqKW5ldzsKIAogCQlpcHY0LT5zaW5fcG9ydCA9IHBvcnQ7Ci0JfQotCi0JaWYg
KG5ldy0+c3NfZmFtaWx5ID09IEFGX0lORVQ2KSB7CisJfSBlbHNlIGlmIChuZXctPnNzX2ZhbWls
eSA9PSBBRl9JTkVUNikgewogCQlzdHJ1Y3Qgc29ja2FkZHJfaW42ICppcHY2ID0gKHN0cnVjdCBz
b2NrYWRkcl9pbjYgKiluZXc7CiAKIAkJaXB2Ni0+c2luNl9wb3J0ID0gcG9ydDsKLS0gCjIuMzAu
MgoK
--0000000000009ec02405c521c63c--
