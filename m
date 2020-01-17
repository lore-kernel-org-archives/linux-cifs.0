Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E422BC33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0EDB20748
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bn/Z2jwF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgAQA4b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 19:56:31 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35802 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733306AbgAQA4b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 19:56:31 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so24144284iob.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 16:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BnnTFLLH5M3MnpawQt1z+MpdIcaaaVYFZM5SWHkNlqM=;
        b=Bn/Z2jwFxEgjUeuXox3bGjyC60OA8nfzAvIFZFxuETdQX5KdkuzYR8KleDht3aFMp5
         j9xZuXjELjx67hCkTGBfVFtmOuJlf7lKYDWWIKPEpJL4Sx4ORpFDntKfF366nGrgw0ld
         xwUmH8wGheV1x9K2dvY5mfdSdQFdvXAtG3iuc77VkANFVAtXOHjmya+oCHQ6Xjeka3ar
         71m8S/0p5wEAel0KCvL6C1+1sptxwDHUes53tBIS3xUZ2dQ3DE/0HDVDkj+3JFA5a+3B
         6g4J0bcDAqca24heFqFU6rF6nMUnSKH4ZauvGRvaYjtylnWvfGS0Ub6fo1sxB67SzG+e
         LSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BnnTFLLH5M3MnpawQt1z+MpdIcaaaVYFZM5SWHkNlqM=;
        b=s4VZ/90s1u4tqNTN9fQY+BxNsRBcxrThperJkCSjZXKA6ei6D4LuVL4ix1Px/ReyYR
         1F9o4B48zHOvkD1BJekD3CofTkFJfG6HpaXMcfckhHVtwp/hPD89eeMQKZmfh+KJhGQS
         cbh79rGsSDQpzWohJxlNT4H0SB2ZtNTCVd9tuACy9kvWX70tYhLwg2VIUV0SC6ncWis/
         C83P9iQ4LfEKW5eZYpl5ep3WpYnuIkR24XAhianVVavrMbEvebbN0p5nOXa08lJ5JGU1
         0UdOKdAD4MR0hMDb8jygY9egvRhYlSosrTpfIdyngjFEYNTa734Ma0mbEGgFWgPRLdg6
         0p2Q==
X-Gm-Message-State: APjAAAUxhtokanDA1hWXHpY5gbpFY1WKX9zP+TcteRcwnxdg/rZpK0OM
        EFz4fHj7/5p/iSkPdsbiRJ0FoqbJWzWgba1LuaA=
X-Google-Smtp-Source: APXvYqyulxGyzN9lk4qnyeUV7XJbEGf35UmNpqu4ZIltAItopjmHRuiuhbK4ASGoZdqzki5LAbeBgW+tc38VLoThKoM=
X-Received: by 2002:a6b:fe0f:: with SMTP id x15mr27639669ioh.219.1579222590184;
 Thu, 16 Jan 2020 16:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
 <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
 <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com>
 <CAH2r5mumEjNcCT=Dc4CMatjprWgBDGVS-3nsds2QqPoZMs8xZQ@mail.gmail.com>
 <CAN05THRbNrd=ZmSMO4yE8oHD3Xn93zNTMBRXnJBuf7J3C5Cmow@mail.gmail.com> <CAKywueTB28BQDdBPo=RDHxjPydrKcniRJmbHGaJ3jOD0KKTzVA@mail.gmail.com>
In-Reply-To: <CAKywueTB28BQDdBPo=RDHxjPydrKcniRJmbHGaJ3jOD0KKTzVA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 17 Jan 2020 10:56:19 +1000
Message-ID: <CAN05THS80kOBNha3Cia2ufaf_WOyLJ-ebR43WupHSvN6Hb8NBg@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jan 17, 2020 at 10:27 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>

Thanks.

> =D1=87=D1=82, 16 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 01:05, ronnie sa=
hlberg <ronniesahlberg@gmail.com>:
> >
> > The bug is basically that if we extend a file by fallocate mode=3D=3D0
> > and immediately afterwards mmap() the file we will only mmap() as much
> > as end-of-file was
> > prior to the truncate  and then if we try to touch any
> > address in this extended region userspace dies with bus error.
> >
> > The patch added "extend a file with fallocate mode=3D=3D0 for NON-Spars=
e
> > files" and caused xfstest to fail.
> > The fix is to force us to revalidate the file attributes (the size is
> > the important one) when we extend the file so
> > mmap() will work properly.
> > I have fixed this in the patch and will resend tomorrow after some more=
 testing.
> >
> > Looking for other SMB2_set_eof() callsites I see we already had the
> > same bug for the case of extending a SPARSE
>
> I agree that regardless of file being sparse or not, we should somehow
> update a size in the VFS after calling SMB2_set_eof().
>
> > file using fallocate mode=3D=3D0. I fixed that too and will audit all
> > other plases where we use SMB2_set_eof()
> > to see if they are safe or not before resending.
>
> One of those places where SMB2_set_eof() is called is
> cifs_set_file_size() which does call the following after getting a
> successful response from the server:
>
> 2250 >-------if (rc =3D=3D 0) {
> 2251 >------->-------cifsInode->server_eof =3D attrs->ia_size;
> 2252 >------->-------cifs_setsize(inode, attrs->ia_size);
> 2253 >------->-------cifs_truncate_page(inode->i_mapping, inode->i_size);
> 2254 >-------}
>
> This is called by cifs_setattr_[no]unix() which does the following afterw=
ards:
>
> 2569 >-------if ((attrs->ia_valid & ATTR_SIZE) &&
> 2570 >-------    attrs->ia_size !=3D i_size_read(inode))
> 2571 >------->-------truncate_setsize(inode, attrs->ia_size);
>
> truncate_setsize() does  similar things as cifs_setsize() besides
> setting cinode->time to 0. This code path probably needs to be
> refactored. But putting this aside, for the current fallocate fix I
> think we should use the same existing mechanism to update a file size
> in the VFS without revalidating the inode.

I can do that change. Note however that since we are still setting
cinode->time to 0
we are still going to trigger a revalidation at some stage.

>
> --
> Best regards,
> Pavel Shilovsky
