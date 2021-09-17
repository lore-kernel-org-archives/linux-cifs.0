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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE56C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 14:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F3361130
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 14:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbhIQOOn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Sep 2021 10:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243416AbhIQOOQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Sep 2021 10:14:16 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A66C061767
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 07:12:54 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m3so31565677lfu.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 07:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GxgJ1UR/FEDFXbntWjC8y6Zj3nKKQilS4NGu2i73FM8=;
        b=EdbAx8SqKAK9kWdYHN9RRRYH5bz9lDooHAKA2nNzcGA6Iq9GyMyE8rgdorDZFZM+yZ
         o15DbG/1RW6nNRXEyF9Q2WO8NlQ0VgxlIqpTlo3yTXyjDwaq98ghId9vEfMeNooGnN3n
         wpfjw3SrM+vpo4vZ0hoC3EqIVhpfm/vOqeK3CXBGD53tziyyyvIf6fcJk1q+x4r6WR+O
         C//0Az/BS/K7KYDmcz1qkfcbOvc2kQKtvv26+3UHNoPKQ9LTKLwxUEyHNcABwpadtSOj
         hNW6M3I7r2nLlEMa9s/x0u11jdc5y3JiXDjwIHrNBeeVO6Eyne+JHvrIkzgb3PpXYgIK
         H0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GxgJ1UR/FEDFXbntWjC8y6Zj3nKKQilS4NGu2i73FM8=;
        b=0+VTvOP2WdZsLPxitjB6G1+2hIcaWZeeeiMzn11svcwbfldw1YVJfUBUm43QvCJ9+q
         JOJxEjRy1T54WxPb7na5SGoMlnR43lZNCe+GOIyr3YLhBCRr1hSoecSAW3KNnN/uWPRg
         Hcq2wbdM/7rDC5m2QQC5TMp6qkv4Nrac6T/Nvjfw9sru/UI1FQ7h78Y6/P6FPnkclm8l
         kBOxxFnJ2epLbJJ0XGhuZpCd0MwBCZqucQprW3epuaKXJy1IZM/AIQUILD308INGEach
         1kDeNYvrI+viJPeZqSOtHJIZgfL2mBCxSDty0myiBHYkErVG1pnY5UyVfTXJtKVNKOeA
         x9Rg==
X-Gm-Message-State: AOAM53231Z7wBCAAj+PxuBI67L2rtl8hUgANshL8WDiLR0F+gzwIVfcZ
        +4mZ2zd5hh8ZfqbCzlYsGNJFFePNjLtAB9vt12Y=
X-Google-Smtp-Source: ABdhPJwHdaiM6CeGC254v7UH2z4UglHsZ8R1iCFPt1WCw0XGTFrW1aObgc12rzepRN1WIXcbQhzjUVkrj3g9C0LYc50=
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr8240003lfo.595.1631887913181;
 Fri, 17 Sep 2021 07:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210917104913.5823-1-hyc.lee@gmail.com> <CAKYAXd9DRqvysX=VwGruB+QaqzHTEdcF1Ya=3Wwp2=nopyTK=w@mail.gmail.com>
In-Reply-To: <CAKYAXd9DRqvysX=VwGruB+QaqzHTEdcF1Ya=3Wwp2=nopyTK=w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Sep 2021 09:11:41 -0500
Message-ID: <CAH2r5ms4UXpWksLWpsSg=uGorkvfx=K97dMawAN7hR1FN-R67g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: prevent out of share access
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>, kernel-team@lge.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae's updated version merged into smb3-kernel cifsd-for-next branch.

Also starting additional tests on it

On Fri, Sep 17, 2021 at 8:18 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-17 19:49 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Because of "..", files outside the share directory
> > could be accessed. To prevent this, normalize
> > the given path and remove all "." and ".."
> > components.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >  fs/ksmbd/misc.c    | 79 ++++++++++++++++++++++++++++++++++++++++------
> >  fs/ksmbd/misc.h    |  3 +-
> >  fs/ksmbd/smb2pdu.c | 14 +++++---
> >  3 files changed, 80 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> > index 0b307ca28a19..d599cb686415 100644
> > --- a/fs/ksmbd/misc.c
> > +++ b/fs/ksmbd/misc.c
> > @@ -191,19 +191,80 @@ int get_nlink(struct kstat *st)
> >       return nlink;
> >  }
> >
> > -void ksmbd_conv_path_to_unix(char *path)
> > +char *ksmbd_conv_path_to_unix(char *path)
> >  {
> > +     size_t path_len, remain_path_len, out_path_len;
> > +     char *out_path, *out_next;
> > +     int i, pre_dotdot_cnt = 0, slash_cnt = 0;
> > +     bool is_last;
> > +
> >       strreplace(path, '\\', '/');
> > -}
> > +     path_len = strlen(path);
> > +     remain_path_len = path_len;
> > +     if (path_len == 0)
> > +             return ERR_PTR(-EINVAL);
> >
> > -void ksmbd_strip_last_slash(char *path)
> > -{
> > -     int len = strlen(path);
> > +     out_path = kzalloc(path_len + 2, GFP_KERNEL);
> > +     if (!out_path)
> > +             return ERR_PTR(-ENOMEM);
> > +     out_path_len = 0;
> > +     out_next = out_path;
> > +
> > +     do {
> > +             char *name = path + path_len - remain_path_len;
> > +             char *next = strchrnul(name, '/');
> > +             size_t name_len = next - name;
> > +
> > +             is_last = !next[0];
> > +             if (name_len == 2 && name[0] == '.' && name[1] == '.') {
> > +                     pre_dotdot_cnt++;
> > +                     /* handle the case that path ends with "/.." */
> > +                     if (is_last)
> > +                             goto follow_dotdot;
> > +             } else {
> > +                     if (pre_dotdot_cnt) {
> > +follow_dotdot:
> > +                             slash_cnt = 0;
> > +                             for (i = out_path_len - 1; i >= 0; i--) {
> > +                                     if (out_path[i] == '/') {
> > +                                             slash_cnt++;
> > +                                             if (slash_cnt ==
> > +                                                 pre_dotdot_cnt + 1)
> > +                                                     break;
> > +                                     }
> checkpatch.pl warn:
>
> WARNING: Too many leading tabs - consider code refactoring
> #70: FILE: fs/ksmbd/misc.c:231:
> +                                               if (slash_cnt ==
>
> total: 0 errors, 1 warnings, 125 lines checked
>
> updated like this.
>
>                                         if (out_path[i] == '/' &&
>                                             ++slash_cnt == pre_dotdot_cnt + 1)
>                                                 break;
> Thanks.
>
> > +                             }
> > +
> > +                             if (i < 0 &&
> > +                                 slash_cnt != pre_dotdot_cnt) {
> > +                                     kfree(out_path);
> > +                                     return ERR_PTR(-EINVAL);
> > +                             }
> > +
> > +                             out_next = &out_path[i+1];
> > +                             *out_next = '\0';
> > +                             out_path_len = i + 1;
> >
> > -     while (len && path[len - 1] == '/') {
> > -             path[len - 1] = '\0';
> > -             len--;
> > -     }
> > +                     }
> > +
> > +                     if (name_len != 0 &&
> > +                         !(name_len == 1 && name[0] == '.') &&
> > +                         !(name_len == 2 && name[0] == '.' && name[1] == '.')) {
> > +                             next[0] = '\0';
> > +                             sprintf(out_next, "%s/", name);
> > +                             out_next += name_len + 1;
> > +                             out_path_len += name_len + 1;
> > +                             next[0] = '/';
> > +                     }
> > +                     pre_dotdot_cnt = 0;
> > +             }
> > +
> > +             remain_path_len -= name_len + 1;
> > +     } while (!is_last);
> > +
> > +     if (out_path_len > 0)
> > +             out_path[out_path_len-1] = '\0';
> > +     path[path_len] = '\0';
> > +     return out_path;
> >  }
> >
> >  void ksmbd_conv_path_to_windows(char *path)
> > diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> > index af8717d4d85b..b7b10139ada2 100644
> > --- a/fs/ksmbd/misc.h
> > +++ b/fs/ksmbd/misc.h
> > @@ -16,8 +16,7 @@ int ksmbd_validate_filename(char *filename);
> >  int parse_stream_name(char *filename, char **stream_name, int *s_type);
> >  char *convert_to_nt_pathname(char *filename, char *sharepath);
> >  int get_nlink(struct kstat *st);
> > -void ksmbd_conv_path_to_unix(char *path);
> > -void ksmbd_strip_last_slash(char *path);
> > +char *ksmbd_conv_path_to_unix(char *path);
> >  void ksmbd_conv_path_to_windows(char *path);
> >  char *ksmbd_extract_sharename(char *treename);
> >  char *convert_to_unix_name(struct ksmbd_share_config *share, char *name);
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index c86164dc70bb..46e0275a77a8 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -634,7 +634,7 @@ static char *
> >  smb2_get_name(struct ksmbd_share_config *share, const char *src,
> >             const int maxlen, struct nls_table *local_nls)
> >  {
> > -     char *name, *unixname;
> > +     char *name, *norm_name, *unixname;
> >
> >       name = smb_strndup_from_utf16(src, maxlen, 1, local_nls);
> >       if (IS_ERR(name)) {
> > @@ -643,11 +643,15 @@ smb2_get_name(struct ksmbd_share_config *share, const
> > char *src,
> >       }
> >
> >       /* change it to absolute unix name */
> > -     ksmbd_conv_path_to_unix(name);
> > -     ksmbd_strip_last_slash(name);
> > -
> > -     unixname = convert_to_unix_name(share, name);
> > +     norm_name = ksmbd_conv_path_to_unix(name);
> > +     if (IS_ERR(norm_name)) {
> > +             kfree(name);
> > +             return norm_name;
> > +     }
> >       kfree(name);
> > +
> > +     unixname = convert_to_unix_name(share, norm_name);
> > +     kfree(norm_name);
> >       if (!unixname) {
> >               pr_err("can not convert absolute name\n");
> >               return ERR_PTR(-ENOMEM);
> > --
> > 2.17.1
> >
> >



-- 
Thanks,

Steve
