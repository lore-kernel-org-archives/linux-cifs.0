Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE623C49ED6
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 20:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A797420838
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 20:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pBba36Iw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfIKUHA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 16:07:00 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33586 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbfIKUHA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 16:07:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id a22so21370889ljd.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Sep 2019 13:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wTDLP1Ik8+k4lPMhXirhmEhSaw5Z4sdQBFbgISBbtLo=;
        b=pBba36IwiUGSf06xAqBOwWbrHg5Erdg+IcCU49ZNGAgyV136qmiKIowqV7zFq7lm6Q
         9IpsxXkAn9+L5rYCs+fsX3Ufavzb2c1u2KQ1BFWZctyBlqBpmLdBJRZn/QIpW7H+qt7Y
         corAVVguXXzJDFPhm7Db+ynD21/uZP63hRDfqQHrXwaDr3ke3ps0BK3BW69r8TX+sVe0
         DONqgxXeAcizpLLAkjrcHloT1N00m8+YmG4f7mab3xDtRK1JQaTBdR/bcEL/KIdyeApF
         dOURx8DKK9SyQRBFKfLNpwJ+Y+PwypNk3HAdFgc0wOz0OFX4GePXVPTAeytFGpGjT/tJ
         heag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wTDLP1Ik8+k4lPMhXirhmEhSaw5Z4sdQBFbgISBbtLo=;
        b=c5OTgWVk3YK0yiFWyP4+c06wNZWm+TEuuGyFp0e5YiCbPELOPiVfdkCHXCaIXcrxpW
         Tyay1Kf49vSg0HTAEfDDG3EeI6tb+zwMU+molsWv/CdVwv1Qu6jd6d+XHNQ1bQptlMR+
         fDxrWk0F2N17+VkvN5gt87xguzRt1hjRXTqd51TKt4oQv1ulkz3int/4iYIc+NNAmspq
         ADBl1jmLDdq8X1EEPewYuyCouxRY89Bz4BdCiYc43Nc+94SpjVImwBvbNyllORFD04tY
         gnautnWLretfwVSYVzLbsa9uJMhA7cdTDNXJiy7bqbjLCW8IUm42ahJPegLpDEHpVSIO
         UjEg==
X-Gm-Message-State: APjAAAXtVBsvxxtx29pfms/pL3L+cCj/VM7UgF4ubAXmCdjfEQvmI2gC
        1w/1i06KfBmhFK8pIeKq8EWXMKhCgM3VoPvWs5fWlw4=
X-Google-Smtp-Source: APXvYqyzvIgI6gii4fhn+a0wWHJz0PjrnhCXS4z7fh+leiOROgYcCnrD489dFKAF8OGXL8UJyZj96Vm1IuEt1f6gv8Y=
X-Received: by 2002:a2e:9555:: with SMTP id t21mr8005471ljh.93.1568232418063;
 Wed, 11 Sep 2019 13:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190829222546.11779-1-lsahlber@redhat.com>
In-Reply-To: <20190829222546.11779-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 11 Sep 2019 13:06:46 -0700
Message-ID: <CAKywueR3VUUJT_VqM=FVLGnzqx1whKOBCNAbKS2Gm7tmjaEQWw@mail.gmail.com>
Subject: Re: [PATCH] cifs: create a helper to find a writeable handle by path name
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 29 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 15:26, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> rename() takes a path for old_file and in SMB2 we used to just create
> a compound for create(old_path)/rename/close().
> If we already have a writable handle we can avoid the create() and close(=
)
> altogether and just use the existing handle.
>
> For this situation, as we avoid doing the create()
> we also avoid triggering an oplock break for the existing handle.

Hi Ronnie,

Another SMB2_CREATE from the same client shouldn't cause a lease break
if we ask for a lease with the same lease key. The lease key is
associated with the inode, all opens that can cause a break should ask
for the lease with the lease key.

Currently smb2_compound_op doesn't ask for a lease: see at the
beginning of the function:

oplock =3D SMB2_OPLOCK_LEVEL_NONE

What we need to do is to change this to SMB2_OPLOCK_LEVEL_BATCH for
operation that modifies the file like SET_EOF and SET_INFO. In this
case the lower layer will map it to the appropriate lease state. Note
that parms->fid->lease_key should be populated.

--
Best regards,
Pavel Shilovsky
