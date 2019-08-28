Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBEDC3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B922173E
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBswVoor"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfH1K1o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:27:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41164 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1K1o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 06:27:44 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so4788389ioj.8
        for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2019 03:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NBKVQSxC19OQVj/ZQoOdqJ1vAp7La0dUxNJUP9va7GA=;
        b=IBswVoorO8QSBrVXYMKyeasmh4ktPssAknvvW95Q+vw4E7PuVhAOQwydSRdDirRgWb
         ZDCvr+GyEdY24Ig48QwXIfTEOuPo96Nj68MVqwzbIw6HSWO+p56gK8tG//VgSEOoA6WR
         ZDzje20o17EBuKDKLvuzt3TMvjSGIl6nEvO8pFwlnlKbZjubg9ubkt3nV6/gkOJ+2CFP
         rMasy1YIBAnYaosOfrwtRln1bi7Tll5QwvhMbsQU4XLhI4R6ayNrruIUXv/mKNtJCq3F
         kI9smWjFXI8S345qB5UeieVhyjomPlj4mQJK2pS3YLwWAa0G9PdQ7FPwn+wG1xG0yI+1
         JXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NBKVQSxC19OQVj/ZQoOdqJ1vAp7La0dUxNJUP9va7GA=;
        b=arjotdEQeqe5XBdLCt0F+mVWzV4JPndHgSOWEi5gjWe1Rg1KW9uFznm9HN6Iyhvldl
         XLN4EqnTkN+3n729f0xgzSuJxAaffaxJoMcZAMUDWm1lYwMlfaGXuN19N407zoPczmTj
         f7MQkXVE9w420FT42Th61XpO9RM/9c6Bt0g5PjrkyAhtlRXHWIcoFs5MkJKxXdg7ESP6
         v71ZpX5NCSlBj4h1MzqUqqm73RGuPhx9zo1q88S8jUGEUm+myHlCu8MgKMoXo9nIe/ov
         gU6QOCJ51Ebzg5THpP+o7Yj1cSlMrnqrVA/eu2GB76trHjRtV3a1cJkoOFRxCfFm2VDK
         PiZg==
X-Gm-Message-State: APjAAAU2YKhbP3JVnNWGGESrlossZ2lnoOYedZcelN+mpaNxPXImS9xr
        9Vv6SX7CfuA1evgkGBMYg3FGj9XGv+l+SRByTeM=
X-Google-Smtp-Source: APXvYqxjNMBh3lpS/L2WW7bHUYqPAn5DkuMADZ2H4KvAOQUc1QJTcfwzIXrxT7xIdjVQ0mzvHimdrEbE60oqsm16dak=
X-Received: by 2002:a5e:c104:: with SMTP id v4mr3537262iol.209.1566988063820;
 Wed, 28 Aug 2019 03:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com>
 <87k1axlhf8.fsf@suse.com>
In-Reply-To: <87k1axlhf8.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 28 Aug 2019 20:27:32 +1000
Message-ID: <CAN05THSPmp3GtZifXK-mLtVntgQR0uwaYY-c5LS9Dhf_P78grA@mail.gmail.com>
Subject: Re: [RFC][SMB3][PATCH] Allow share to be mounted with "cache=ro" if
 immutable share
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 28, 2019 at 8:21 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> "Steve French" <smfrench@gmail.com> writes:
> > Increases performance a lot in cases where we know that the share is
> > not changing
>
> This is just adding the parsing of the option but it sounds like a good i=
dea.

You also have the magic happening in:
-#define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
+#define CIFS_CACHE_READ(cinode) ((cinode->oplock &
CIFS_CACHE_READ_FLG) ||
(CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags &
CIFS_MOUNT_RO_CACHE))

which makes things work. Still I would want this to be driven by
whether the server returns "this share is WRITEABLE or  not" flag
instead of a mount option.
A mount option only invites people to "I use this because it makes
thing faster"  then "why do my files look corrupted sometimes" ?

>
> > +#define CIFS_MOUNT_RO_CACHE  0x20000000  /* assumes share will not cha=
nge */
>
> This flag probably needs to be added to CIFS_MOUNT_MASK: if one cifs sb
> is using that flag, it should only be reused for new mounts that also
> require that flag.
>
> Cheers,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
