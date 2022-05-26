Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D946C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 05:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiEZFBF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 01:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345684AbiEZFBC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 01:01:02 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A403584D
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 22:01:00 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id i186so413163vsc.9
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 22:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jkDGxYt5tjyAfi1g4D3NUT3V14AYH5IaeorVg4O4PhQ=;
        b=iQqqzTEKc9x2NK4Fb8tkGiePetfGuKBWobwUJoRs3hOsT4QhLdxjcyIosoOVnGpu8w
         OqrBurSwM9lwENirrKFasFSEr/CmiN71IZCjzz39LYgd+xpGAgxiATobdE3YGCrmeOJE
         zcgUU/nmp/TdESyPH4K0eC3sFtD/Y5WVEoBZm8fZbTxclNtbka6nkQhZGtx9haFYzH5J
         4c4NrosP54EmTpXRI5YkNM9MKjodhHP93miVkr8pkU0OpUiOzVQC/G/EasZPVAohZOFq
         rp+YTBtBSs+rNkeC6aZqvzqqiX0xynkoUOq61ypr2Q2DgZ3x+9i+on2VX0KfKs6azk3Z
         3fHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jkDGxYt5tjyAfi1g4D3NUT3V14AYH5IaeorVg4O4PhQ=;
        b=2ri9C+tY7dclGcpmu1sBud4GwLpeCeN1YF8luYUdaFo76u8l00Bwo0g+m7RQrIXTxH
         ymcUzNi3b9YpkDwvpytIGI+QfdMaDLUiLVjTFJ4qnkENiAyOVgVu98igHDpCS94AScb7
         RtMeT5pqWRXQiPdr2zZ664gy9F4zz6JnilCZlIT9hEhd2EJkWc3r3NlyDIF02awbsPJe
         tBgAEReIOiBGJ7WaEeEmh/F4W9sO3M+svB6Q4Ng5Z0/IC861AmBK5X5p/mRsL5nopSxL
         g6DKv+oO/0vr/cTonyivw+g/rNPe40tN7MWQ2CteDWq3nX+LAe98I3/U0hZE5Gu7OxzT
         UIGw==
X-Gm-Message-State: AOAM533bkj/6qxpQZ369httbXrFyfU6IitGE42YPxdhJUdPoqbsdc4qG
        7NK0qV2/xHQTx8KnJeMSj0A9WnrUb+FeRgGal54=
X-Google-Smtp-Source: ABdhPJxO4vL+ynistQTccvc/FXOsUZ/5efHfYI6wVivpyxtDrCeYNxXvMOlFdbfxiHkqIKrMuccP9FJPjJkFOV2SZb0=
X-Received: by 2002:a67:d601:0:b0:337:e4b9:d2e0 with SMTP id
 n1-20020a67d601000000b00337e4b9d2e0mr2743791vsj.61.1653541259965; Wed, 25 May
 2022 22:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <628e23acb5243_17eb1f2acf4460f9a8777f8@prd-scan-dashboard-0.mail> <CAH2r5mtR7kRcCw=iUo+PGg8G=r-1EkdnP=in_DneEWG+HxYAsg@mail.gmail.com>
In-Reply-To: <CAH2r5mtR7kRcCw=iUo+PGg8G=r-1EkdnP=in_DneEWG+HxYAsg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 26 May 2022 00:00:49 -0500
Message-ID: <CAH2r5mvM1i6EbdCHZ68BPV_wF3miEGTaLRyL6ZJSZEDJ1+UoJg@mail.gmail.com>
Subject: Re: New Defects reported by Coverity Scan for linux-next weekly scan
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006c0c6405dfe313aa"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006c0c6405dfe313aa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Patch to fix this warning attached.


On Wed, May 25, 2022 at 8:20 AM Steve French <smfrench@gmail.com> wrote:
>
>
> ---------- Forwarded message ---------
> From: <scan-admin@coverity.com>
> Date: Wed, May 25, 2022, 07:40
> Subject: New Defects reported by Coverity Scan for linux-next weekly scan
> To: <smfrench@gmail.com>
>
>
> Hi,
>
> Please find the latest report on new defect(s) introduced to linux-next w=
eekly scan, under component 'FS-CIFS',  found with Coverity Scan.
>
> 1 new defect(s) introduced to linux-next weekly scan, under component 'FS=
-CIFS',  found with Coverity Scan.
> 8 defect(s), reported by Coverity Scan earlier, were marked fixed in the =
recent build analyzed by Coverity Scan.
>
> New defect(s) Reported-by: Coverity Scan
> Showing 1 of 1 defect(s)
>
>
> ** CID 1518030:  Null pointer dereferences  (REVERSE_INULL)
> /fs/cifs/readdir.c: 1108 in cifs_readdir()
>
>
> _________________________________________________________________________=
_______________________________
> *** CID 1518030:  Null pointer dereferences  (REVERSE_INULL)
> /fs/cifs/readdir.c: 1108 in cifs_readdir()
> 1102            mutex_unlock(&cfid->dirents.de_mutex);
> 1103
> 1104            /* Drop the cache while calling initiate_cifs_search and
> 1105             * find_cifs_entry in case there will be reconnects durin=
g
> 1106             * query_directory.
> 1107             */
> >>>     CID 1518030:  Null pointer dereferences  (REVERSE_INULL)
> >>>     Null-checking "cfid" suggests that it may be null, but it has alr=
eady been dereferenced on all paths leading to the check.
> 1108            if (cfid) {
> 1109                    close_cached_dir(cfid);
> 1110                    cfid =3D NULL;
> 1111            }
> 1112
> 1113      cache_not_found:
>
>
> _________________________________________________________________________=
_______________________________
> To view the defects in Coverity Scan visit, https://u15810271.ct.sendgrid=
.net/ls/click?upn=3DHRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50ypWUaxuG23ar=
lAOMqBtlZty8jbpwvvNgxXk-2FmAsxmR9vW5nmNrMx1IpP6MDN1J2o1ZPwtxoZUPo2TKCoVE0eH=
SfAENI_Y7VRim-2Fxl9fmAdBRyG05vGZHoQCljkdhUYA-2FoqqLzdRcgL8NozXbXPTeip3E1wAS=
k61xAAnRXanfXB8LqcT-2FwRhZs3l5M6RJV5-2B2zB6Y0j8JQfWKe27e73bfQ89ydmxnVAo-2FN=
vbBaX8QEbpzR4h82JcBlVZ25OTy33cLsYDIu1bdssbL-2FRwadbu9lLJN4dI1rPIaINt6Tz-2FU=
s9gVfquk6Q-3D-3D
>
>   To manage Coverity Scan email notifications for "smfrench@gmail.com", c=
lick https://u15810271.ct.sendgrid.net/ls/click?upn=3DHRESupC-2F2Czv4BOaCWW=
Cy7my0P0qcxCbhZ31OYv50yped04pjJnmXOsUBtKYNIXxgDITOxfLjGd57Ifg09SfMSZeD9rHMt=
RaJqZq0ctXqp7fRP-2BE8DxRp97FczN2h9FJkLzTHr7qddqCt-2F0SoddBt8k3Bc5cgjF9mAUP8=
Y7F8MA-3DZijn_Y7VRim-2Fxl9fmAdBRyG05vGZHoQCljkdhUYA-2FoqqLzdRcgL8NozXbXPTei=
p3E1wASSXlY5Xi8QRgougxC7RmAR-2BgidemDBxQLu-2F-2FOpS2Zh8OHdzNbXM7fgjsc7G7CXW=
79mTq7LOgCUGW9AsSS2aHeMTf2wbRpkyvZyfZqM9bb3M7WbRjhjgXOfau8yW2ZBZRWbJ33EaXk-=
2FdabyWYlOoI-2B0Q-3D-3D
>


--=20
Thanks,

Steve

--0000000000006c0c6405dfe313aa
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-remove-unneeded-null-check-in-cifs_readdir.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-remove-unneeded-null-check-in-cifs_readdir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3mjr7v10>
X-Attachment-Id: f_l3mjr7v10

RnJvbSBmZjE3MmU0MWRmZmJkN2MzMTlkZjU5M2U4Yzg3ZWM4MTY2MjNjOTZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjUgTWF5IDIwMjIgMjM6NTY6MDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiByZW1vdmUgdW5uZWVkZWQgbnVsbCBjaGVjayBpbiBjaWZzX3JlYWRkaXIKCkNvdmVyaXR5
IHBvaW50ZWQgb3V0IGFuIHVubmVlZGVkIGNoZWNrLgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxNTE4
MDMwICgiTnVsbCBwb2ludGVyIGRlcmVmZXJlbmNlcyIpCkNjOiBSb25uaWUgU2FobGJlcmcgPGxz
YWhsYmVyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3JlYWRkaXIuYyB8IDYgKystLS0tCiBmcy9jaWZz
L3NtYjJvcHMuYyB8IDEgKwogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9yZWFkZGlyLmMgYi9mcy9jaWZzL3JlYWRk
aXIuYwppbmRleCBjY2YzNDQ4MWQ4MDEuLjM4NGNhYmRmNDdjYSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9yZWFkZGlyLmMKKysrIGIvZnMvY2lmcy9yZWFkZGlyLmMKQEAgLTExMDUsMTAgKzExMDUsOCBA
QCBpbnQgY2lmc19yZWFkZGlyKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgZGlyX2NvbnRleHQg
KmN0eCkKIAkgKiBmaW5kX2NpZnNfZW50cnkgaW4gY2FzZSB0aGVyZSB3aWxsIGJlIHJlY29ubmVj
dHMgZHVyaW5nCiAJICogcXVlcnlfZGlyZWN0b3J5LgogCSAqLwotCWlmIChjZmlkKSB7Ci0JCWNs
b3NlX2NhY2hlZF9kaXIoY2ZpZCk7Ci0JCWNmaWQgPSBOVUxMOwotCX0KKwljbG9zZV9jYWNoZWRf
ZGlyKGNmaWQpOworCWNmaWQgPSBOVUxMOwogCiAgY2FjaGVfbm90X2ZvdW5kOgogCS8qCmRpZmYg
LS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDA1N2Qz
ZjMyY2Y4Zi4uYmM5MGYwYmMxNDc1IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysg
Yi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNzcwLDYgKzc3MCw3IEBAIHNtYjJfY2FjaGVkX2xlYXNl
X2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIC8qCiAgKiBPcGVuIHRoZSBhbmQgY2Fj
aGUgYSBkaXJlY3RvcnkgaGFuZGxlLgogICogT25seSBzdXBwb3J0ZWQgZm9yIHRoZSByb290IGhh
bmRsZS4KKyAqIElmIGVycm9yIHRoZW4gKmNmaWQgaXMgbm90IGluaXRpYWxpemVkLgogICovCiBp
bnQgb3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sCiAJCWNvbnN0IGNoYXIgKnBhdGgsCi0tIAoyLjM0LjEKCg==
--0000000000006c0c6405dfe313aa--
