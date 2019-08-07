Return-Path: <SRS0=Za1z=WD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A582BC433FF
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Aug 2019 21:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF57217F5
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Aug 2019 21:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnrMuNhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfHGVoO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Aug 2019 17:44:14 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35368 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGVoN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Aug 2019 17:44:13 -0400
Received: by mail-lf1-f67.google.com with SMTP id p197so65119489lfa.2
        for <linux-cifs@vger.kernel.org>; Wed, 07 Aug 2019 14:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q5jK87YhYZNOaWzTfw++1d+YQ3T928GwlhtiOGkC6Wc=;
        b=HnrMuNhITT/CIBMMioNglNQVzFq9FGZK8yMSWkDmTLXtMSU3A9UfwWTEHSKfzm6u+E
         gt9nGWNRzbk2+EZz+aWYlMm5cBajX+r+Y061XJjdSYvWfqDdbTI8EV0fUc5SAEFaQISx
         rxzuk8evZOzU1x6NWD/6bXku5ND78PDYWanFMJQaDIxSzzPwxuI+I3MNXVqdtMmbupR3
         HUmscgt3vGfhshys9eCHh+2VcO6DltKwi8XT8puLEQw0gl+zNvIzsuAGyQ6HbuiNqkgD
         khg79jjZj7mCABWcMMue2y9Ll+PjW0+UdTuN+ezl6DkGKKCGBQsNQVVknbWMnKHNoU40
         ORuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q5jK87YhYZNOaWzTfw++1d+YQ3T928GwlhtiOGkC6Wc=;
        b=Tazv+VppoeiOYSKPBDDKP3FmhBihFSquVjexhJHKFPzsnZBBAbk3jKRRi7fGxBe5Cb
         t7gAbJVfqyeEQMsFIKCJZ2UABkww6+cxqL5JfwcKskjOmBAgLZBRGCI1jWbt4Q6EYnht
         Y5iuBnzoK5SUHPQNtVSCqIXuoaB9FcZTBEN9bscnm9++xcStKvssOOBj27VuNOURTyz1
         h6R9kqzSvg/5W+xyjW8UZsubFgFzI+LCk84cn7UKYaueMMeeqm3yymny0mtcC+TcYjdb
         pKnIZJZDfmnfdXoFuTMqjj9BZswJiQk+bmbnMMpfHKhCa8+iHhkwn+g6aSsKOCxCYTYl
         SZTQ==
X-Gm-Message-State: APjAAAUPqqOJ1133jCcALHAbTBmIc79PLWx46jLP8Aic4x5MwOvIlZH6
        ig7hf3yjsv6bDea7ejpizX9LzAmYyq19PKw2QQ==
X-Google-Smtp-Source: APXvYqycw3K/dbWcSwvcL9I0i+wpiEKphjC05F+XMoOJt72ki3kvnjya8Txpl55AR3e7Z78NZGypystbMCwfzF3qB8c=
X-Received: by 2002:ac2:549b:: with SMTP id t27mr6953161lfk.25.1565214251834;
 Wed, 07 Aug 2019 14:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <0f780b18-0b1c-e2ff-31b1-1d697becd142@huawei.com> <CAKywueT6C=O-1tosijf5vm5pg0YozMeEiKP56=unv370L=zzRQ@mail.gmail.com>
In-Reply-To: <CAKywueT6C=O-1tosijf5vm5pg0YozMeEiKP56=unv370L=zzRQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 7 Aug 2019 14:44:00 -0700
Message-ID: <CAKywueTfnmsZm7scQmDhews_g2TwYw0NRYCstaYnSb_zE91oUA@mail.gmail.com>
Subject: Re: [PATCH cifs-utils v2] mount.cifs.c: fix memory leaks in main func
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        liujiawen10@huawei.com, Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Alexander Bokovoy <ab@samba.org>,
        Paulo Alcantara <palcantara@suse.de>, dujin1@huawei.com,
        Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into "next" with one minor change - removed a trailing white
space. Thanks.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 6 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 09:49, Pavel Shilov=
sky <piastryyy@gmail.com>:

>
> =D0=BF=D0=BD, 5 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 19:36, Zhiqiang L=
iu <liuzhiqiang26@huawei.com>:
> >
> > From: Jiawen Liu <liujiawen10@huawei.com>
> >
> > In mount.cifs module, orgoptions and mountpoint in the main func
> > point to the memory allocated by func realpath and strndup respectively=
.
> > However, they are not freed before the main func returns so that the
> > memory leaks occurred.
> >
> > The memory leak problem is reported by LeakSanitizer tool.
> > LeakSanitizer url: "https://github.com/google/sanitizers"
> >
> > Here I free the pointers orgoptions and mountpoint before main
> > func returns.
> >
> > Fixes=EF=BC=9A7549ad5e7126 ("memory leaks: caused by func realpath and =
strndup")
> > Signed-off-by: Jiawen Liu <liujiawen10@huawei.com>
> > Reported-by: Jin Du <dujin1@huawei.com>
> > Reviewed-by: Saisai Zhang <zhangsaisai@huawei.com>
> > Reviewed-by: Aur=C3=A9lien Aptel <aaptel@suse.com>
> > ---
> > v1->v2:
> > - free orgoptions in main func as suggested by Aur=C3=A9lien Aptel
> > - free mountpoint in acquire_mountpoint func as suggested by Aur=C3=A9l=
ien Aptel
> >
> >  mount.cifs.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index ae7a899..656d353 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -1891,7 +1891,10 @@ restore_privs:
> >                 uid_t __attribute__((unused)) uignore =3D setfsuid(oldf=
suid);
> >                 gid_t __attribute__((unused)) gignore =3D setfsgid(oldf=
sgid);
> >         }
> > -
> > +
> > +       if (rc) {
> > +               free(*mountpointp);
> > +       }
> >         return rc;
> >  }
> >
> > @@ -1994,8 +1997,10 @@ int main(int argc, char **argv)
> >
> >         /* chdir into mountpoint as soon as possible */
> >         rc =3D acquire_mountpoint(&mountpoint);
> > -       if (rc)
> > +       if (rc) {
> > +               free(orgoptions);
> >                 return rc;
> > +       }
> >
> >         /*
> >          * mount.cifs does privilege separation. Most of the code to ha=
ndle
> > @@ -2014,6 +2019,8 @@ int main(int argc, char **argv)
> >                 /* child */
> >                 rc =3D assemble_mountinfo(parsed_info, thisprogram, mou=
ntpoint,
> >                                         orig_dev, orgoptions);
> > +               free(orgoptions);
> > +               free(mountpoint);
> >                 return rc;
> >         } else {
> >                 /* parent */
> > @@ -2149,5 +2156,6 @@ mount_exit:
> >         }
> >         free(options);
> >         free(orgoptions);
> > +       free(mountpoint);
> >         return rc;
> >  }
> > --
> > 2.7.4
> >
>
> Thanks for the patch! I will apply it to my github tree shortly.
>
> --
> Best regards,
> Pavel Shilovsky
