Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43A9C33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F5B2077B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTpUtiee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgAQA1a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 19:27:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32856 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgAQA1a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 19:27:30 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so17028888lfl.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 16:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IBtspxAHnbaMfQ3JtefCYVNfriVlJvE+7wnC6Cw2PnU=;
        b=FTpUtieeAaLYMsw/8uZX5npMVbyT1plJEBi1wu9i3GZPVPH6+e87Fhvt551mLYssIh
         Sf75qolpL5JwVnW+w1AWpq7yGLuL9NGskVcIRGHkx03YtADcMWBLx2MKPpqKoAQ4zOzJ
         eR7Vh4qB8/aMvbYXlVgnYj1/zD+zsEphhxIlnN+8z8Voo31AwQai2rGYk/tAMDV9z40+
         rG6r3NZ7fYKnr3oDe9luqbmfYCN+IQpT1Fm1eeUVpmv1WbRAkShbxJp76oTMGGPcYqu3
         0+1g+ItDZbGjIn84M1obEzyUMoWnfuw6A7adxpHfrkM6H/866l3EP6VBurScV9HD+x+l
         R4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IBtspxAHnbaMfQ3JtefCYVNfriVlJvE+7wnC6Cw2PnU=;
        b=UgA9LNRJKwR4zj1RQOaBsDIQOR4sAs1WS0HfRMnavyY6bb1hh4X1Ta87OV1HuLgLVi
         BFYtfh33K7EBcgCzrVzhUI6OKGDv90QkyOXfIL+lDYX0ttpVVnSQDscJjxVFSzUpgrrv
         hTwmwOmj7+5kaK5qOrq+tRhWIU12+5PL/bDvPUnu4hoofP8rQGhxfQgnkaVFgeyqRnns
         nDGZ07GIEY2Z48sVI+iIv1ablWQDE9ezarldHALfSMM/Tte0I2OpWDh70rOfLNfbBAYO
         1eAOc3e7R+wBDLoezYax/DGt6/6i/yMcc38R8qOGuoM6HfMeFe0HvSzwaDeGYNGiHC/Q
         AyIQ==
X-Gm-Message-State: APjAAAVrHFrcxs8Mz/6HYuD2CeHqUr8jRkiA3xQbXEKMWWjsdjfGA5Zf
        KUowyAyYHFq88fihcyjx4CTPt7LNnnFxEWkNPw==
X-Google-Smtp-Source: APXvYqxZMUNsbMSeDJegBcC1PrunwvnujOX17/ffXb7ppT3CGR/zsEam+kBT2PfB7jzkixtY6c0QIkpQ5u8iTGT24yQ=
X-Received: by 2002:ac2:5287:: with SMTP id q7mr3911220lfm.66.1579220848167;
 Thu, 16 Jan 2020 16:27:28 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
 <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
 <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com>
 <CAH2r5mumEjNcCT=Dc4CMatjprWgBDGVS-3nsds2QqPoZMs8xZQ@mail.gmail.com> <CAN05THRbNrd=ZmSMO4yE8oHD3Xn93zNTMBRXnJBuf7J3C5Cmow@mail.gmail.com>
In-Reply-To: <CAN05THRbNrd=ZmSMO4yE8oHD3Xn93zNTMBRXnJBuf7J3C5Cmow@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 16 Jan 2020 16:27:16 -0800
Message-ID: <CAKywueTB28BQDdBPo=RDHxjPydrKcniRJmbHGaJ3jOD0KKTzVA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 16 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 01:05, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> The bug is basically that if we extend a file by fallocate mode=3D=3D0
> and immediately afterwards mmap() the file we will only mmap() as much
> as end-of-file was
> prior to the truncate  and then if we try to touch any
> address in this extended region userspace dies with bus error.
>
> The patch added "extend a file with fallocate mode=3D=3D0 for NON-Sparse
> files" and caused xfstest to fail.
> The fix is to force us to revalidate the file attributes (the size is
> the important one) when we extend the file so
> mmap() will work properly.
> I have fixed this in the patch and will resend tomorrow after some more t=
esting.
>
> Looking for other SMB2_set_eof() callsites I see we already had the
> same bug for the case of extending a SPARSE

I agree that regardless of file being sparse or not, we should somehow
update a size in the VFS after calling SMB2_set_eof().

> file using fallocate mode=3D=3D0. I fixed that too and will audit all
> other plases where we use SMB2_set_eof()
> to see if they are safe or not before resending.

One of those places where SMB2_set_eof() is called is
cifs_set_file_size() which does call the following after getting a
successful response from the server:

2250 >-------if (rc =3D=3D 0) {
2251 >------->-------cifsInode->server_eof =3D attrs->ia_size;
2252 >------->-------cifs_setsize(inode, attrs->ia_size);
2253 >------->-------cifs_truncate_page(inode->i_mapping, inode->i_size);
2254 >-------}

This is called by cifs_setattr_[no]unix() which does the following afterwar=
ds:

2569 >-------if ((attrs->ia_valid & ATTR_SIZE) &&
2570 >-------    attrs->ia_size !=3D i_size_read(inode))
2571 >------->-------truncate_setsize(inode, attrs->ia_size);

truncate_setsize() does  similar things as cifs_setsize() besides
setting cinode->time to 0. This code path probably needs to be
refactored. But putting this aside, for the current fallocate fix I
think we should use the same existing mechanism to update a file size
in the VFS without revalidating the inode.

--
Best regards,
Pavel Shilovsky
