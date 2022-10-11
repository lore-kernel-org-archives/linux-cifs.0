Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EA4C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 20:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiJKUly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 16:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJKUlw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 16:41:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58466FA0B
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 13:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665520909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z8D2twBBFA9vweuQUYyj0t1dMUN3BWI02gvM+zj823g=;
        b=Bys1P0k8dBJ1GZ2brbg0ZlZQWtG74BLw113rcY/dK7ThHgUsbge+PoN4afiRPWoS+Ej45/
        6GtY3XwMrwgwYdU01kzpWNKLu0hGeDETrySNAUNzjie5IlJN3aHHIemqdPjaiMigO3+MdK
        v+FgoFnpOK9wbEkTNFlBXsN8MSYIApc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-140-BwRRoW_oPBKsyZPrk7pkSg-1; Tue, 11 Oct 2022 16:41:48 -0400
X-MC-Unique: BwRRoW_oPBKsyZPrk7pkSg-1
Received: by mail-oi1-f199.google.com with SMTP id s8-20020a0568080b0800b00354d7ce1b4fso161015oij.8
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 13:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z8D2twBBFA9vweuQUYyj0t1dMUN3BWI02gvM+zj823g=;
        b=xwAyaoehzMkULFzR5NLj2FjpwDlC5AKyHKZsplXwKR1qbTmX+j+aTqxVweeX9thoW3
         IArZ7h+8/gg+P/reGbLmoaoUIE7Zk2d/m/sUcI/Pg2e3UPzvJ0xYg+VI4rQT3MwwIOC3
         2NJTYj8OOsrghCSy7M+uvvxbKvpXz4BMhMua5gzVcxXx1ILCFdK72bjoKDFZpQBn5d0r
         2l0rPZ7z3ywe5Pn84y3hXvOlWUylUPHu8ztunEi2xSRrk7rPxB7vUHv5WPhP3XuYGm88
         /OLpRrjPO1sh6OQztoPn0iAe/xSXqQo02fHREzgDi2JgFqYQVTNhLOdPvwYOetI4XQaa
         nHCw==
X-Gm-Message-State: ACrzQf2DIwLLUWMBNNDKlxyeY5GPZ1jJAZZRIdTu44eomnacyyVU4qz4
        MpPA0RfrWMgwlulAex00E7iqCHR1PETMxaoLIi+bnIYqpZi8CqThHLI+63psmzlF8WyAFjr0ExJ
        qZuFCEn9AcdzRcUs8YVT4E7oiwhrL/DDyuE0EfQ==
X-Received: by 2002:a05:6830:2647:b0:659:ed73:8781 with SMTP id f7-20020a056830264700b00659ed738781mr11332192otu.352.1665520907913;
        Tue, 11 Oct 2022 13:41:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4rk4YKtyJmaWegBHXXpvY5cAR0rzp+SA4zyCRRDDPnNr9F6z+2HZU2RypPgJwLS8aB6vissLJU2m8ZviDJ9YA=
X-Received: by 2002:a05:6830:2647:b0:659:ed73:8781 with SMTP id
 f7-20020a056830264700b00659ed738781mr11332181otu.352.1665520907660; Tue, 11
 Oct 2022 13:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com> <20221011185714.5elxjbut7cvfed6x@suse.de>
In-Reply-To: <20221011185714.5elxjbut7cvfed6x@suse.de>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 12 Oct 2022 06:41:36 +1000
Message-ID: <CAGvGhF7f-UFNDN9ZZPLdvQZV95G3NpdN_ftouKuTBTecm9MDRQ@mail.gmail.com>
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

On Wed, Oct 12, 2022 at 4:58 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 10/11, Steve French wrote:
> >makes sense.
> >
> >Did anyone else review this yet?  (the mount.cifs version of the patch)
>
> At a glance, the patch seems ok and solves a real problem.
>
> However, I think a better approach would be to parse the string in user
> space, i.e. it's much easier for mount.cifs to fetch what's the
> UNC/password string if they're passed quoted (shell handles it), and
> then use 0x1E (ASCII Record Separator) instead of a comma.  Then, in
> the kernel, we'd only need to strsep() by 0x1E.  Since 0x1E is a
> non-printable ASCII character, I have a hard assumption it's not allowed
> as UNC/password in most systems.  Also since it would be only used
> internally between mount.cifs and cifs.ko, users would not need to know
> nor care about it.
>
> Thoughts?

The trouble with changing to 0x1e is that that would create a
dependency between mount.cifs and the kernel.
And that we would need to upgrade, or downgrade, them in lockstep
which will cause a lot of pain.
Old version of mount.cifs can not talk to new version of kernel and v.v.

I think a better way to handle this would be to use an escape-character for ','.
(and remove all traces of "sep=")

>
>
> Enzo
>
> >On Sat, Oct 8, 2022 at 2:41 PM Dmitry Telegin
> ><dmitry.s.telegin@gmail.com> wrote:
> >>
> >> DESCRIPTION OF THE PROBLEM
> >>
> >> Some users are accustomed to using shared folders in Windows with a
> >> comma in the name, for example: "//server3/Block 3,4".
> >> When they try to migrate to Linux, they cannot mount such paths.
> >>
> >> An example of the line generated by "mount.cifs" for the kernel when
> >> mounting "//server3/Block 3,4":
> >> "ip=10.0.2.212,unc=\\server3\Block 3,4,iocharset=utf8,user=user1,domain=AD"
> >> Accordingly, due to the extra comma, we have an error:
> >> "Sep 7 21:57:18 S1 kernel: [ 795.604821] CIFS: Unknown mount option "4""
> >>
> >>
> >> DOCUMENTATION
> >>
> >> https://www.kernel.org/doc/html/latest/admin-guide/cifs/usage.html
> >> The "sep" parameter is described here to specify a new delimiter
> >> instead of a comma.
> >> I quote:
> >>    "sep
> >>    if first mount option (after the -o), overrides the comma as the
> >> separator between the mount parms. e.g.:
> >>    -o user=myname,password=mypassword,domain=mydom
> >>    could be passed instead with period as the separator by:
> >>    -o sep=.user=myname.password=mypassword.domain=mydom
> >>    this might be useful when comma is contained within username or
> >> password or domain."
> >>
> >>
> >> RESEARCH WORK
> >>
> >> I looked at the "mount.cifs" code. There is no provision for the use
> >> of a comma by the user, since the comma is used to form the parameter
> >> string to the kernel (man 2 mount). This line can be seen by adding
> >> the "--verbose" flag to the mount.
> >> "mount.cifs --help" lists "sep" as a possible option, but does not
> >> implement it in the code and does not describe it in "man 8
> >> mount.cifs".
> >>
> >> I looked at the "pam-mount" code - the mount options are assembled
> >> with a wildcard comma. The result is a text line: "mount -t cifs ...".
> >>
> >> The handling of options in the "mount" utility is based on the
> >> "libmount" library, which is hardcoded to use only a comma as a
> >> delimiter.
> >>
> >> I tried to mount "//server3/Block 3,4" with my own program (man 2
> >> mount) by specifying "sep=!" - successfully.
> >>
> >>
> >> SOLUTION
> >>
> >> It would be nice if we add in "mount.cifs", in "mount" utility and in
> >> "pam-mount" the ability to set a custom mount option separator. In
> >> other words, we need to implement the already documented "sep" option.
> >>
> >> 1. For "mount.cifs" I did it in:
> >> https://github.com/dmitry-telegin/cifs-utils in branch
> >> "custom_option_separator". Commit:
> >> https://github.com/dmitry-telegin/cifs-utils/commit/04325b842a82edf655a14174e763bc0b2a6870e1
> >>
> >> 2. For "mount" utility I did it in:
> >> https://github.com/dmitry-telegin/util-linux in branch
> >> "custom_option_separator". Commit:
> >> https://github.com/dmitry-telegin/util-linux/commit/5e0ecd2498edae0bf0bcab4ba6a68a9803b34ccf
> >>
> >> 3. For "pam-mount" I did it in:
> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/master/tree/ in branch
> >> "custom_option_separator". Commit:
> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/9860f9234977f1110230482b5d87bdcb8bc6ce03/
> >>
> >> I checked the work on the Linux 5.10 kernel.
> >>
> >> --
> >> Dmitry Telegin
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve
>

