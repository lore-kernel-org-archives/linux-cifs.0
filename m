Return-Path: <SRS0=c9dP=4G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C3CC3404B
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 20:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B02042067D
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 20:08:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gyk9Tru2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBRT6h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:58:37 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33377 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgBRT6g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Feb 2020 14:58:36 -0500
Received: by mail-il1-f196.google.com with SMTP id s18so18424787iln.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 11:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KGsOjnXv3o0tdV1+AcGvevzH8L/uKqwDm6QGqd8qfWY=;
        b=Gyk9Tru2yCfPBmN5xwtZXqIMOwdgWdhKX/SfABLw6Borh0hyzcjY6mhkJonAbSFgdq
         Bon1sdqah5Fl4FsFrhzQBMTTxPGPKVeEyDIrVQm4YLJ9+HO+ITr91a8OaXdTbB5KNjwX
         XIDmOq8KRcLi1Ob8dlAWfK455K/GcUZGj0FZbBsUPl40XpL/gu5217af3Dbw8UVd1ZoX
         wePneo7Fim7diVBR4uDkcPagmtgX+eKFANrjB2DA8V3X3yhqg8k1Bq0QVPoile2VY8oI
         yOvb6Hl3ovEli+wyuu0VlvhQOUmV57L5rG4IgOOD/OIo/1gTvS3qrF+JUcJKrLAeQMw+
         NEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KGsOjnXv3o0tdV1+AcGvevzH8L/uKqwDm6QGqd8qfWY=;
        b=LjCf5PvpgM4PUyWgQMz6X0DaWW8JjQ5Z6btLNpPu5dLxXgtlYJmaXESJNYRpnkuOfH
         OMFPBBG/XJT5pJZt+Xvfy4j9EAZZ/9cMCIhFWuCmEAd//HiMlhSf2xevjzcirspnngN/
         y3eskxmVjC7iUreb6J+clccPBr44KNN7a2YjF69EEQeKalAYErQ82CXqJcmfks554p3R
         SojBFqF4G9usd0Fpjq9yh07vHcrp3LF8mQgvN34pp6Cj4brz2QXLGcsabwj2Dg5jB743
         IT7TLSTq7fCpO/n2EfYJHH+9qrsh/mqeNkeYIcky2ZJDknMiwicrTG95zkr2108YfpJc
         MSDw==
X-Gm-Message-State: APjAAAXS+gYAO7Z6ZouTLuyq9IaD02RKU0clMckJ/yEQVhig6fMkfWpi
        /BXnn2qzLtD+dfnWh6jfig32ab11hlKVBDuu+X4=
X-Google-Smtp-Source: APXvYqwFji+aE4czPWXMaxKW93O1H/eVyqIwnz+csVng2FtY/3iKmtq3PFxCYfa0FT8gVXSR+YaBeffbaRcvKEAVOuI=
X-Received: by 2002:a92:c886:: with SMTP id w6mr19910493ilo.219.1582055913890;
 Tue, 18 Feb 2020 11:58:33 -0800 (PST)
MIME-Version: 1.0
References: <20200218044829.15629-1-lsahlber@redhat.com> <878sl0azhv.fsf@suse.com>
In-Reply-To: <878sl0azhv.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 19 Feb 2020 05:58:23 +1000
Message-ID: <CAN05THQq3GW81ugfiXXEsobwyv0zW5Jk0gQx75-8m_n0EW5sFQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 18, 2020 at 9:47 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Hi Ronnie,
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > Fix this by re-trying the operation from within cifs_revalidate_dentry_=
attr()
> > if cifs_get_inode_info*() returns -EAGAIN.
>
> Would it make sense to use is_retryable_error() instead of checking for
> just EAGAIN? It also checks for interruption errors.

Makes sense. Thanks.

>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
