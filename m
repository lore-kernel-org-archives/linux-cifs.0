Return-Path: <SRS0=PeaU=YD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61943C47404
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Oct 2019 00:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383D1206C0
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Oct 2019 00:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RfkUGHqd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJJAwD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 20:52:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37764 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731134AbfJJAwD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Oct 2019 20:52:03 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so9902084iob.4
        for <linux-cifs@vger.kernel.org>; Wed, 09 Oct 2019 17:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LMqbZvRkZHXlXYznW+BVaZPRHKsGHtqWKlDlyr8mWQ0=;
        b=RfkUGHqdjFLe4jjhmVzd/f6Y6fbNz3wqgtG6NtNDifw6Fab17btMohLyeDKbo/Ustb
         5U7ou0XSsuqBd3jE2ws/OZq2iKOxh3/MhLY6uZ3Oy/3QFLK7cZLqwbD8RM8uEE0gMIxc
         Erf0zRKmxgf8xgwYDP1JmzelQ5N52fwRlLN8NfoMiEXs2noKSP2aP04IcukxiyGJ5jCZ
         1s1shuCgj8fTX/dnWjm179h5AGsl5gk2nHQkJ8BHmHcdRhqWcbZ5DF6w0T092RqeJY8f
         vvsWG930drDDSxOjjz6qZH8yV5apFJFHys32LWld8bM7tbFizK93QhAXqO64cL5eQSB5
         ojAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LMqbZvRkZHXlXYznW+BVaZPRHKsGHtqWKlDlyr8mWQ0=;
        b=BpdxAQh+pHKEqNETIRLF/UYpHIAIlEcb0uwmCYw0NDGiGlczLc+5yT3Z6jugm4W72r
         ISUFQAHSI6WDXvEFsUr4sV7Y6UFh2cg0okpouJpL+WaWj0z7ip8xNEWAc6IrZ89xccNo
         XK7Hn3/HhiY7vyZgNAqJW7/as1Ob1OE0lu/VeLO1/ZlMWTNCgzMdskwY89i9XC7mtrrd
         u5xfNIQ5WDul/uQgd2scWFoOkXNg9/v82Ur6NGgCmqHq5xIjZuNx2H9cOKVW9lxOTRjl
         z+gipuafdmKisGs+C9mdHHy26KswmeVdJvcoWc2qqQpcwgVIE/pFTAkXl5t2eOoSJ47l
         FOyg==
X-Gm-Message-State: APjAAAUeUytWNQsD5J9GRNRKS0BYgBPK29kA4BQajBSxFo3ZEFCmlvNr
        Ohj+kGVP4HqpId7deYHqCZvFaYYZK0g7g9jwAduQ9Q==
X-Google-Smtp-Source: APXvYqyfnq4nwpZy7uqb1ekAw4serGw8wkyLHDZxgsBeMhO4mYGk1CbMp34Dzhzw3uK1MevaCFffHqr1ga3pFkovHnw=
X-Received: by 2002:a05:6602:2206:: with SMTP id n6mr6824868ion.272.1570668722549;
 Wed, 09 Oct 2019 17:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com>
 <87k19ef0si.fsf@suse.com> <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
In-Reply-To: <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 9 Oct 2019 17:51:50 -0700
Message-ID: <CAH2r5mt6mWe-rf3gYLO4HiHtcc57aX49QNU8JWmXWYF3m-gDAQ@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

or smb3-     =E2=80=A6. since "smb3" means more secure ...

On Wed, Oct 9, 2019 at 4:29 PM ronnie sahlberg <ronniesahlberg@gmail.com> w=
rote:
>
> On Thu, Oct 10, 2019 at 12:33 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wr=
ote:
> >
> >
> > A general comment on the script I have which I should have mentionned i=
n
> > my first email:
> >
> > Do we really need a separate script for this? I like that we have a
> > simple python example do this kind of stuff as an example and reference=
,
> > I think it's useful, but installing it makes it yet another utility wit=
h an
> > unconventionnal name instead of a new smbinfo subcommand.
>
> I think it would be good to have these tools as part of the actual instal=
l.
> They are in python so they are imho much more useful to the target users
> (sysadmins) than a utility written in C.
> (I kind of regret that smbinfo is in C, it should have been python too:-(=
 )
>
> Maybe we just need to decide on a naming prefix for these utilities
> and then there shouldn't be
> a problem to add many small useful tools.
> The nice thing with small python tools is that it is so easy to tweak
> them to specific usecases.
>
> I think they should be installed but perhaps be called:
> smb2-secdesc-ui.py
> smb2-quota.py
>
> regards
> ronnie
>
> >
> > For reminders, we already ship:
> >
> > - mount.cifs
> > - cifs.upcall
> > - cifscreds
> > - pam_cifscreds
> > - smbinfo
> > - getcifsacl
> > - setcifsacl
> > - cifs.idmap
> > - secdesc-ui.py (not installed)
> > - smb2quota.py (not installed)
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)



--=20
Thanks,

Steve
