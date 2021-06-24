Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A37C48BC2
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B88760230
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 00:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFXAgl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 20:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFXAgl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 20:36:41 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC6C061574
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:34:21 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id s22so5352172ljg.5
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 17:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hk+YazeOrM1TvhfpjXxa7gPB1CxLdSPaM5dcB35PdHY=;
        b=L5GWiUCNAi806L7BnvD1GLLw82q9hWKreJEXJHoxh3PlRFBU58sX1LFVcTgpExbMA6
         qM0CEouXjbyNGkCGfp+DMR+9nwH6VNFqAVem1VVC3EYaIe8zyeeJErlpA4Dn87sWK07+
         Rg/roPGFBZFQFOb9G4U80kR7TFTwefl3le7cgIyg9aovHU3mwQk3osBtbaUYhtSKzSfi
         FWTByCV7QSnok83NAq+A/FDlHM6i+2RHcU5xWiQGECs+YDv0oW3IKICZHHJthse85JJD
         mThdbhPK4O5B5uFKUliUcQiFdwqarke62ZnFr05AHAPuq4OFVUDk2//ubXA4DQbysThK
         rKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hk+YazeOrM1TvhfpjXxa7gPB1CxLdSPaM5dcB35PdHY=;
        b=ZpYowhGyqY1zXSSz3eEwM1Ock1gYaWrfrwOpBtRXCoiYNr0Oj0RCP8I+WlM9HPgaUv
         1FdcS1B+RSk5v0nyjIyqY28FLSAnMlthWTdVQ80DsTNV24L9BQGY37mtQmkuUqreTaUd
         PDg5v5oSc9CssQn1LKjb7ycf01FC+LBYT0Biv11+watLwlcWnwIamIsblf+oS9prHSkW
         7QJEUOM4TnJg9W0XmbVSjWvtpHICkz0NAl5FnRNw7HzCsYryvkOAFP9uDQBbELTo5Ah1
         Btg0ZADGzRsCD4p8uB178ZUFcVacBWniU9laRvVXRzTyB4hE9lVoFDweNAJ010EGglxi
         O+UQ==
X-Gm-Message-State: AOAM531nD23exjJYIabn0ZaSZfQcVifp0c5MaODhQK6eiy67s8wzcPU6
        c5ltwae/EqgzbFGe2JJrDBNyOETlMK3ALVhYAHVbYjgD3Tw=
X-Google-Smtp-Source: ABdhPJxyS74p73v5JQ9kuTWAoZO0VbZW2SRWfXXwCNrn7tYlQWPWM7ahofb+LQ94EX+xy1P1LpVNKfJKhxEo5EH25uc=
X-Received: by 2002:a2e:a234:: with SMTP id i20mr1770931ljm.272.1624494859975;
 Wed, 23 Jun 2021 17:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
 <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
In-Reply-To: <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Jun 2021 19:34:08 -0500
Message-ID: <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000011962905c5782f8c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000011962905c5782f8c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch attached with Aurelien's suggestion.

On Wed, Jun 23, 2021 at 7:17 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Agreed.
>
> On June 23, 2021 8:48:24 AM GMT-03:00, "Aur=C3=A9lien Aptel" <aaptel@suse=
.com> wrote:
> >Steve French <smfrench@gmail.com> writes:
> >> We weren't checking if tcon is null before setting dfs path,
> >> although we check for null tcon in an earlier assignment statement.
> >
> >If tcon is NULL there is no point in continuing in that function, we
> >should have exited earlier.
> >
> >If tcon is NULL it means mount_get_conns() failed so presumably rc will
> >be !=3D 0 and we would goto error.
> >
> >I don't think this is needed. We could change the existing check after
> >the loop to this you really want to be safe:
> >
> >       if (rc || !tcon)
> >               goto error;
> >
> >
> >Cheers,



--=20
Thanks,

Steve

--00000000000011962905c5782f8c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-null-pointer-check-in-cifs_mount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-null-pointer-check-in-cifs_mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqa69f0w0>
X-Attachment-Id: f_kqa69f0w0

RnJvbSAxNjIwMDRhMmY3ZWY1Yzc3NjAwZTM2NGRjNGU5MzE1YjBlNmNhMzg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjMgSnVuIDIwMjEgMTk6MzI6MjQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIG51bGwgcG9pbnRlciBjaGVjayBpbiBjaWZzX21vdW50CgpXZSB3ZXJlbid0
IGNoZWNraW5nIGlmIHRjb24gaXMgbnVsbCBiZWZvcmUgc2V0dGluZyBkZnMgcGF0aCwKYWx0aG91
Z2ggd2UgY2hlY2sgZm9yIG51bGwgdGNvbiBpbiBhbiBlYXJsaWVyIGFzc2lnbm1lbnQgc3RhdGVt
ZW50LgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxNDc2NDExICgiRGVyZWZlcmVuY2UgYWZ0ZXIgbnVs
bCBjaGVjayIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5j
IGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggOGQ5NTYwN2E5MzEyLi5jODA3OTM3NmQyOTQgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0z
NDUxLDcgKzM0NTEsNyBAQCBpbnQgY2lmc19tb3VudChzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZz
X3NiLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJCQlyYyA9IC1FTE9PUDsKIAl9IHdo
aWxlIChyYyA9PSAtRVJFTU9URSk7CiAKLQlpZiAocmMpCisJaWYgKHJjIHx8ICF0Y29uKQogCQln
b3RvIGVycm9yOwogCiAJa2ZyZWUocmVmX3BhdGgpOwotLSAKMi4zMC4yCgo=
--00000000000011962905c5782f8c--
