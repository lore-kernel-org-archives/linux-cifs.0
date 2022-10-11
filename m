Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EABC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 20:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJKUq7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 16:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiJKUq6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 16:46:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653DA80BC6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 13:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665521213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eggq5Zm5Jhd0GdsHLgJS9qfO87bBHHCJ6/NgmulmP54=;
        b=Y0z6UY5zMjYCz6nkaMi1YymbIuDjNyuP3pdB05vOH8eWJyRIhZdgOw82d/sXFH2dCqV9Bx
        WqwZoFS2qv6duBLBPGjdmnupfEBm3pKngsWGU0SYduTQBLw0lx1IQ10kJ8FsOQubwRJTwz
        DMJhMbBk9KWVPiMxnIOVeTrM7cGwn+4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-YC9ydUyjMNGvhpPlhMTgdg-1; Tue, 11 Oct 2022 16:46:52 -0400
X-MC-Unique: YC9ydUyjMNGvhpPlhMTgdg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-132254f73bdso7510653fac.14
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 13:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eggq5Zm5Jhd0GdsHLgJS9qfO87bBHHCJ6/NgmulmP54=;
        b=sz5yosZUqiObb4OHaKRUFVddIL/13BGyMq6E/kjc/5imT/8xpP8e4KMEZIW4aTn7wd
         SmZuXB1xe7qDr0a32YLN3DXdRKDFOKx8sQNHyXtMbsUCI1m96k3CGy4HthZIUGPkYsDC
         BjmEq+IdFZYWLGJW707WdV9nCnvGWvYKKCOkl8W1ZM+12gEP/l2zHqYh6z5ENvf42pXS
         mIP4j2Tc2qC+zEa5Mmyk6Hw13Xt0JXB4AY4gA7eamFCdkVMhIKVzhzRL/+DVgzoeaKIg
         StoCN5D6N9XrsOAHpwwvFwylSDtohk4j+YYxo+KHakE3fq7JKkw9pBoFo/UNGX6kIi1r
         4KGw==
X-Gm-Message-State: ACrzQf2qy/Cpix3FddKrAwOLFTcKPz4rtWDeUzkudX062zn9/wMtlJFb
        wqHh1aamoi63LuaAQ503MGc/V11JwphcRIJ7x0kVvX7Ugm3cHVHR7kTgM4aD0iifYlsPQcBW4pU
        VB+T8EMdRC1qXxZBTDUpRYs2IED93HsGCqNyK2g==
X-Received: by 2002:a05:6870:b021:b0:132:d79b:6ad4 with SMTP id y33-20020a056870b02100b00132d79b6ad4mr619418oae.1.1665521210291;
        Tue, 11 Oct 2022 13:46:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5JCFJc6Sa4pyoGK7sFJNZYLzdSinHkAYUOL52/xWXHqY1c9gfVImC6J+scaPqo0ZD1TNSTZNjGlG36QGg3BAs=
X-Received: by 2002:a05:6870:b021:b0:132:d79b:6ad4 with SMTP id
 y33-20020a056870b02100b00132d79b6ad4mr619411oae.1.1665521210028; Tue, 11 Oct
 2022 13:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com>
 <20221011185714.5elxjbut7cvfed6x@suse.de> <CAGvGhF7f-UFNDN9ZZPLdvQZV95G3NpdN_ftouKuTBTecm9MDRQ@mail.gmail.com>
In-Reply-To: <CAGvGhF7f-UFNDN9ZZPLdvQZV95G3NpdN_ftouKuTBTecm9MDRQ@mail.gmail.com>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 12 Oct 2022 06:46:39 +1000
Message-ID: <CAGvGhF7tPaa3AtDzGbU5dtQYLmDoPP8FJfchu8bAefYY+3B+dg@mail.gmail.com>
Subject: Re: A patch to implement the already documented "sep" option for the
 CIFS file system.
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>,
        Dmitry Telegin <dmitry.s.telegin@gmail.com>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 12, 2022 at 6:41 AM Leif Sahlberg <lsahlber@redhat.com> wrote:
>
> On Wed, Oct 12, 2022 at 4:58 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > On 10/11, Steve French wrote:
> > >makes sense.
> > >
> > >Did anyone else review this yet?  (the mount.cifs version of the patch)
> >
> > At a glance, the patch seems ok and solves a real problem.
> >
> > However, I think a better approach would be to parse the string in user
> > space, i.e. it's much easier for mount.cifs to fetch what's the
> > UNC/password string if they're passed quoted (shell handles it), and
> > then use 0x1E (ASCII Record Separator) instead of a comma.  Then, in
> > the kernel, we'd only need to strsep() by 0x1E.  Since 0x1E is a
> > non-printable ASCII character, I have a hard assumption it's not allowed
> > as UNC/password in most systems.  Also since it would be only used
> > internally between mount.cifs and cifs.ko, users would not need to know
> > nor care about it.
> >
> > Thoughts?
>
> The trouble with changing to 0x1e is that that would create a
> dependency between mount.cifs and the kernel.
> And that we would need to upgrade, or downgrade, them in lockstep
> which will cause a lot of pain.
> Old version of mount.cifs can not talk to new version of kernel and v.v.
>
> I think a better way to handle this would be to use an escape-character for ','.
> (and remove all traces of "sep=")

A good escape character would possibly be something i the range 0xf8
to 0xff as these
byte values can not exist in utf8 encoded streams.


>
> >
> >
> > Enzo
> >
> > >On Sat, Oct 8, 2022 at 2:41 PM Dmitry Telegin
> > ><dmitry.s.telegin@gmail.com> wrote:
> > >>
> > >> DESCRIPTION OF THE PROBLEM
> > >>
> > >> Some users are accustomed to using shared folders in Windows with a
> > >> comma in the name, for example: "//server3/Block 3,4".
> > >> When they try to migrate to Linux, they cannot mount such paths.
> > >>
> > >> An example of the line generated by "mount.cifs" for the kernel when
> > >> mounting "//server3/Block 3,4":
> > >> "ip=10.0.2.212,unc=\\server3\Block 3,4,iocharset=utf8,user=user1,domain=AD"
> > >> Accordingly, due to the extra comma, we have an error:
> > >> "Sep 7 21:57:18 S1 kernel: [ 795.604821] CIFS: Unknown mount option "4""
> > >>
> > >>
> > >> DOCUMENTATION
> > >>
> > >> https://www.kernel.org/doc/html/latest/admin-guide/cifs/usage.html
> > >> The "sep" parameter is described here to specify a new delimiter
> > >> instead of a comma.
> > >> I quote:
> > >>    "sep
> > >>    if first mount option (after the -o), overrides the comma as the
> > >> separator between the mount parms. e.g.:
> > >>    -o user=myname,password=mypassword,domain=mydom
> > >>    could be passed instead with period as the separator by:
> > >>    -o sep=.user=myname.password=mypassword.domain=mydom
> > >>    this might be useful when comma is contained within username or
> > >> password or domain."
> > >>
> > >>
> > >> RESEARCH WORK
> > >>
> > >> I looked at the "mount.cifs" code. There is no provision for the use
> > >> of a comma by the user, since the comma is used to form the parameter
> > >> string to the kernel (man 2 mount). This line can be seen by adding
> > >> the "--verbose" flag to the mount.
> > >> "mount.cifs --help" lists "sep" as a possible option, but does not
> > >> implement it in the code and does not describe it in "man 8
> > >> mount.cifs".
> > >>
> > >> I looked at the "pam-mount" code - the mount options are assembled
> > >> with a wildcard comma. The result is a text line: "mount -t cifs ...".
> > >>
> > >> The handling of options in the "mount" utility is based on the
> > >> "libmount" library, which is hardcoded to use only a comma as a
> > >> delimiter.
> > >>
> > >> I tried to mount "//server3/Block 3,4" with my own program (man 2
> > >> mount) by specifying "sep=!" - successfully.
> > >>
> > >>
> > >> SOLUTION
> > >>
> > >> It would be nice if we add in "mount.cifs", in "mount" utility and in
> > >> "pam-mount" the ability to set a custom mount option separator. In
> > >> other words, we need to implement the already documented "sep" option.
> > >>
> > >> 1. For "mount.cifs" I did it in:
> > >> https://github.com/dmitry-telegin/cifs-utils in branch
> > >> "custom_option_separator". Commit:
> > >> https://github.com/dmitry-telegin/cifs-utils/commit/04325b842a82edf655a14174e763bc0b2a6870e1
> > >>
> > >> 2. For "mount" utility I did it in:
> > >> https://github.com/dmitry-telegin/util-linux in branch
> > >> "custom_option_separator". Commit:
> > >> https://github.com/dmitry-telegin/util-linux/commit/5e0ecd2498edae0bf0bcab4ba6a68a9803b34ccf
> > >>
> > >> 3. For "pam-mount" I did it in:
> > >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/master/tree/ in branch
> > >> "custom_option_separator". Commit:
> > >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/9860f9234977f1110230482b5d87bdcb8bc6ce03/
> > >>
> > >> I checked the work on the Linux 5.10 kernel.
> > >>
> > >> --
> > >> Dmitry Telegin
> > >
> > >
> > >
> > >--
> > >Thanks,
> > >
> > >Steve
> >

