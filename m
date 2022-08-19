Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9709FC32771
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 21:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiHSVeD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 17:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiHSVeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 17:34:02 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830BB108942
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 14:34:00 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id q190so5697084vsb.7
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 14:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VxOPcHxh8eGq2vSFlO+tjt+sRBrcDbO0/llLKuzKSJY=;
        b=pWAGbGacp1Nev/eVt6U/jJhtCHUiDnE9d/n061+FC1QY91Pzr8uRTwzCZQ269vBaql
         M9dUMrcagFuICmn83RB/bS6+1v+xa/8gIeuAHeZnAK2qWkN7wNG6JIAplRJ5Tw6KdmHU
         qGD0dFlS9Q5Tp7vg2SHU4gYPnofgLOADSWWv3b7I3k9Q+blTT+256ssXn1YLXDPraXRs
         ANC7ipR39+/l3oiMVOCAQ5HXbuoEmWNNNCZXJZytMYxKyinfgt8ZxemZuEHcvjXv/4Tv
         5iRQDbA9WpW7cMLLPQdS3j8MB+mylYVDR9KlEEMQP/TWnx9OavBYWPHJ/rkso/bCBLJl
         DdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VxOPcHxh8eGq2vSFlO+tjt+sRBrcDbO0/llLKuzKSJY=;
        b=OwuzhnZaAOMA5JlLYM2b9yHx4wAQU4A1aHmXDmQa8gm619yHAfF3AWqSfoyT6EXdhY
         jmOgd/QOrgLN3+3kW3A3st/daeSfnSrBrBpvvLtsYN2h/AsiPZGlUD5+jtEk8mYoAxHS
         IiEBSp0TN+NGaXMNRZZXTK8kGFjDDux8N3IWStAi+inpv4yI5u3GMmuJPWUN14nN9ltl
         pYMMWqwNg1T481wOoEO6a4amUDUf/BSscmP7ezTf0pjvzl+aZto/RXju7FDgDob11szE
         cUTSuspqZ0jAxbOJRQ9uoF65OkM0W7Rcad5FY6TLTJte2zi8gFryeaSE6Bbqd0O21FSQ
         hg/w==
X-Gm-Message-State: ACgBeo0I/9Vn5NnwifqbR1TKgG1V9clRaeRokSKPCky/6DfPWjC5s+So
        L2MRuMkMooaEfuzGN5XWTuFksf8hGm8LUE6jSaGYjNZdqQ4=
X-Google-Smtp-Source: AA6agR4pNj/ci/edKi9ckuhAZyVK8xVjZ77zEyWi0W/zA1cBMh8RHprO+GqGik9ckiYh23+DHobZNnf7KKTHYOnlXcY=
X-Received: by 2002:a05:6102:3e82:b0:38a:ab1a:2702 with SMTP id
 m2-20020a0561023e8200b0038aab1a2702mr3779881vsv.29.1660944839359; Fri, 19 Aug
 2022 14:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvShnJidFDQkdULTDQFteSKimcphT_GGfVb0zXx9PkNcQ@mail.gmail.com>
 <CAH2r5msA0T5ABYT_aKWqWbmDZKQaL9pJ6ehNCMcRPuNaLKzRPA@mail.gmail.com>
In-Reply-To: <CAH2r5msA0T5ABYT_aKWqWbmDZKQaL9pJ6ehNCMcRPuNaLKzRPA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Aug 2022 16:33:48 -0500
Message-ID: <CAH2r5mvb7PR--1uX6LytZHZeT8WFFum9Ln=JZ0jUhrGAqBfwaA@mail.gmail.com>
Subject: Re: missing update to deferred_close_scheduled field
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch seems to cause an rmmod failure (after unmount) - will need
to test it more

On Fri, Aug 19, 2022 at 2:24 PM Steve French <smfrench@gmail.com> wrote:
>
> forgot to attach the correct version of the patch (had a cut-n-paste
> error on one line)
>
>
> On Fri, Aug 19, 2022 at 11:48 AM Steve French <smfrench@gmail.com> wrote:
> >
> > > we are missing a line like this:
> > >
> > >        cfile->deferred_close_scheduled = false;
> > >
> > > in cifs_open here:
> > >
> > >         /* Get the cached handle as SMB2 close is deferred */
> > >         rc = cifs_get_readable_path(tcon, full_path, &cfile);
> > >         if (rc == 0) {
> > >                 if (file->f_flags == cfile->f_flags) {
> > >                         file->private_data = cfile;
> > >                         spin_lock(&CIFS_I(inode)->deferred_lock);
> > >                         cifs_del_deferred_close(cfile);
> > >                         spin_unlock(&CIFS_I(inode)->deferred_lock);
> > >                         goto use_cache;
> >
> > So move set of deferred_close_scheduled = false into cifs_del_deferred_close
> >
> > See attached
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
