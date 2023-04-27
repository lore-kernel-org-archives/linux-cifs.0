Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B326C77B61
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Apr 2023 16:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243466AbjD0QGA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Apr 2023 12:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0QF7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Apr 2023 12:05:59 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05A310EF
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 09:05:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so2763131e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 09:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682611556; x=1685203556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFuTTNboen+osXdL6MizTpPRmfSNeXAvH+okyPlYBek=;
        b=gS8Q4Z8h0iJurUnXEciKk4t5T3xG5oExmICUmfabeyjj3/DZesbpsGF+ebBx/7hQ4E
         VXqEEVQzVBRhBgdpxn1045kjO5jRLlilkUdRZsOLQka8OiwAFg4Zniz9YRE35Tk3ePGa
         UZz6y7vlKBztSOKJmg8H6/mTWyPiY25+Hn0PVcywZBTjxvGpjdN37zPWIuvGqrP4mey6
         i7RGT/oQCrZGxu5GWLn1BT9WFUC1FSxMHIy7wFUQ1yjjwTMJwadYrzqZ6kCpz97e3Hja
         lBm5dr7vKI8JTEaOrl7gndvqOwPRIljWauufJosVsTRd11POsNU6mYedOUwqNsBx4VxO
         ylsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682611556; x=1685203556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFuTTNboen+osXdL6MizTpPRmfSNeXAvH+okyPlYBek=;
        b=blyceV236PyhwUX59bs/b8+6V+WBKT7t5JhhXRAku6vSRLsQE/3Iv9CRW5MVZ8WLvX
         ukMd6p9iskvpqYrbG0Z9yHhcH24igYUuf0/9/p7nWgrXPblP5x1/BCqh9ogLDhpUck0l
         C17vOTC+TOYMpV1E4L7MGb1jp8BQ/PlxJv2nRdZFpC3gZ7ApLASLCoEs0m+RQy0Qe8KT
         GAGRqY6bkUN9PuuMV7Qm+yP57lLqTqgkYklIxZEFQO/ZSmrFRfc9/UY2gG7D1WswXGpN
         TFUuBoFG1FHE1wNzDsfkusLhchob26/oEd5sMcLeve0YlV1sWdLjAvu+IE9tqa34RINX
         aDDg==
X-Gm-Message-State: AC+VfDz6ZcwKfojQuPHY8SP3OYIaHa3gE2NMWe3L8W5eByg/dbRr2YBm
        MYoXW61ijIAZMM5mrmdVzSLJDvhvl5IKvnaeNvHfg0mG
X-Google-Smtp-Source: ACHHUZ6d7f4+3goF5sCWawvJrliJVfLthE7RKMEMaHJvkstY26OqjOCdYITabzX1vZIMIXekmhcAu4onxIj8uOyI1KE=
X-Received: by 2002:ac2:50cd:0:b0:4ef:ef67:65c9 with SMTP id
 h13-20020ac250cd000000b004efef6765c9mr679343lfm.23.1682611555833; Thu, 27 Apr
 2023 09:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230420160646.291053-1-bharathsm.hsk@gmail.com> <a63523569c379a1ec13a1f352687cdcf.pc@manguebit.com>
In-Reply-To: <a63523569c379a1ec13a1f352687cdcf.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Apr 2023 11:05:44 -0500
Message-ID: <CAH2r5mvuteP+gczbW-pLtY1Prmt8iN0dL_Z__ydEWA0Lwep+GQ@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Add missing locks to protect deferred close file list
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>, pc@cjr.nz, sfrench@samba.org,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added to cifs-2.6.git for-next now (with the 2 acked-bys)  that Fixes
tag is there

On Thu, Apr 20, 2023 at 1:08=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > From: Bharath SM <bharathsm@microsoft.com>
> >
> > cifs_del_deferred_close function has a critical section which modifies
> > the deferred close file list. We must acquire deferred_lock before
> > calling cifs_del_deferred_close function.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/cifs/misc.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index a0d286ee723d..89bbc12e2ca7 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -742,7 +742,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cif=
s_inode)
> >       list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
> >               if (delayed_work_pending(&cfile->deferred)) {
> >                       if (cancel_delayed_work(&cfile->deferred)) {
> > +
>
> No need for this extra blank line.  Please remove the below ones as
> well.
>
> With the "Fixes:" tag added as per Ronnie's suggestion,
>
> Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>
> > +                             spin_lock(&cifs_inode->deferred_lock);
> >                               cifs_del_deferred_close(cfile);
> > +                             spin_unlock(&cifs_inode->deferred_lock);
> >
> >                               tmp_list =3D kmalloc(sizeof(struct file_l=
ist), GFP_ATOMIC);
> >                               if (tmp_list =3D=3D NULL)
> > @@ -773,7 +776,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tc=
on)
> >       list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> >               if (delayed_work_pending(&cfile->deferred)) {
> >                       if (cancel_delayed_work(&cfile->deferred)) {
> > +
> > +                             spin_lock(&CIFS_I(d_inode(cfile->dentry))=
->deferred_lock);
> >                               cifs_del_deferred_close(cfile);
> > +                             spin_unlock(&CIFS_I(d_inode(cfile->dentry=
))->deferred_lock);
> >
> >                               tmp_list =3D kmalloc(sizeof(struct file_l=
ist), GFP_ATOMIC);
> >                               if (tmp_list =3D=3D NULL)
> > @@ -808,7 +814,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_=
tcon *tcon, const char *path)
> >               if (strstr(full_path, path)) {
> >                       if (delayed_work_pending(&cfile->deferred)) {
> >                               if (cancel_delayed_work(&cfile->deferred)=
) {
> > +
> > +                                     spin_lock(&CIFS_I(d_inode(cfile->=
dentry))->deferred_lock);
> >                                       cifs_del_deferred_close(cfile);
> > +                                     spin_unlock(&CIFS_I(d_inode(cfile=
->dentry))->deferred_lock);
> >
> >                                       tmp_list =3D kmalloc(sizeof(struc=
t file_list), GFP_ATOMIC);
> >                                       if (tmp_list =3D=3D NULL)
> > --
> > 2.34.1



--=20
Thanks,

Steve
