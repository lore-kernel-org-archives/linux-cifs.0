Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE2BC4338F
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Aug 2021 06:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25FC60EE9
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Aug 2021 06:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhHAGCt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 1 Aug 2021 02:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHAGCs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 1 Aug 2021 02:02:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CFEC06175F
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 23:02:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p21so19844281edi.9
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 23:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FdVCL785kaedu7ZGqY5tSx5a+iew5oK7X7cQCHkPlLU=;
        b=abEmBWwYaT7eWTmPGpQX0mrX9Yv/Si62DhxeuRexXSVe6V/qbWXpZu2WTUf8YyGtlb
         glkHlCYYtqs3vL0U+3iIOSzWIyvKKZ10FHigvzQVpMw9W+TJbkkt0SnqGoSL4fPIaS5x
         ijkoiebK8VmA45n1VEOUM+aP3eAT+hAT+1xwDGlYl4tazTAudRS8d/dT8PIsDkjbSFve
         RGlm0GU6YZcSui0A0FcBMSgS0pPTy5X2CIVfy3ArBw3EInMjulGIZM9v2I0lOhja5exp
         tmU0ItB1zpOWDXSXA/BidnNz7+UA9WyaYOCjQG6/+UfxgMJE3pghorSNVTesPeXZf6qu
         qdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FdVCL785kaedu7ZGqY5tSx5a+iew5oK7X7cQCHkPlLU=;
        b=WhWVhWglcq2bh7TKKPrbltP0Bkr6donUsVR02cmImG3BexK9fKGO1VAoaCTQdZm8Uz
         lBMbUck74uzj/RlUL+bz8ug2wAo7GVR3lZ+mxDwSetgy4+9rWNulDC8imzwr6NnND226
         oncPZE+KopzWQxgafF0Db1QJKYqpcGxIT9j2CGN6OPSgRWNt1z/fA4s2mBu6Gw2LXxnV
         D8Y24/USWZGU9hds6az6M8mkpEwPTOrY+2Ta3VD6kQE7+ohXXm/HxnwYDM0Sf9MycbEu
         h4pc0d2AkRiqfjJVqZ2YTEQVsbOx7VFo29LG0NDDqEzn3rDSFeYnLgz0JwLHoZqxlRNd
         mP7g==
X-Gm-Message-State: AOAM530YDS96pwi4ODcDcAE2WbpM1ALI5TpzFzer8/yHKI6We2KT4q47
        JzDIB6KpJ5L0BXZeuUhqA852oB+pqSTuqH/kc90=
X-Google-Smtp-Source: ABdhPJyWSUkoJ2hxbjcsdtJi1xXYu4WaYPZJENJXaEr/gdyEFmTc4rBMHs4Ndp2PmTdVN4nVD468yRe66srAKi4cV94=
X-Received: by 2002:a05:6402:1c03:: with SMTP id ck3mr3501675edb.33.1627797758628;
 Sat, 31 Jul 2021 23:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <CANXojcy9sAY6Sd62Xs2nnjPNHWuUWQwcSpAAyAoT+VPDWizhOQ@mail.gmail.com>
 <CAN05THS_KtutZxOOap7xPU3d+XfEJJTe7XT9sZ1tVZFMcLAYEA@mail.gmail.com> <CANXojczOzWWebVJNDmS-b=cYSFOJ=0dSNSeNJ6T5+-FZfq_pNQ@mail.gmail.com>
In-Reply-To: <CANXojczOzWWebVJNDmS-b=cYSFOJ=0dSNSeNJ6T5+-FZfq_pNQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sun, 1 Aug 2021 16:02:26 +1000
Message-ID: <CAN05THQiDaAtCKFoem703U9FRkN-f+x69u26pPWmbh5QZVWFVw@mail.gmail.com>
Subject: Re: Question about parsing acl to get linux attributes.
To:     Stef Bon <stefbon@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Aug 1, 2021 at 2:12 PM Stef Bon <stefbon@gmail.com> wrote:
>
> Op za 31 jul. 2021 om 23:57 schreef ronnie sahlberg <ronniesahlberg@gmail.com>:
> >
> >
> >
> >
> > Example:
> > 1, S-1-2-ALICE                  ALLOW   READ
> > 2, S-1-2-BOB                     ALLOW  READ/WRITE
> > 3, S-1-2-EVERYBODY      ALLOW   READ/WRITE
> > 4, S-1-2-BOB                     DENY     WRITE
> >
> > In this case, even though there are two ACEs that would grant BOB
> > WRITE access (the ACE for BOB and EVERYBODY), BOB is still denied
> > write access due to the presence of a DENY ACE for WRITE.
> >
> > In this case the ACEs are evaluated in the following order
> > 4, 1, 2, 3
>
> Wow this will take a lot of time to process when listing a directory.
> After the readdir for every entry a lookup is done, for more details,
> and then this processing of a list has to be done.
>
> Is it really required to do this more than once? You mention looking
> first for the denies, and then the allow entries. But what happens if
> there no allow entries, then it will be denied I think. Is it
> something like iptables: there is a default policy which counts when
> no rule applies?

If there are no allow entres, then the access will be denied.

> If this is the case you do not have to do it twice:
> - if the policy is deny, you only have to look for allow rules
> - and vica versa if the policy is allow, you will have to look for deny rules

The point of checking the DENY entries first is to make sure that a
mistakenly too wide entry will not allow
unintended people access.
Or, for use cases where for example you want ALL users access, EXCEPT
for a special group, like a group where all temp contractors are
members of.
It also makes it less likely to make mistakes since you are not
dependent on the ordering of the ACEs.

And you could then do this with an ACL such as this:
1, S-1-2-EVERYONE                                    ALLOW   READ
2, S-1-2-NOT_FULL_TIME_EMPLOYEES   DENY      READ

This is a pretty common way to manage ACLs in large windows shares.
You have one entry that gives broad access   then a sharper entry that
excludes people.


So for correctness in a client, you would need to always check both.
But, you could take shortcuts. After all, the permissions you return
to the application
are just "cosmetics" for the application anyway.
Every access you do will be evaluated and enforced on the server anyway,
so if you get this mapping wrong (which will happen because it is
impossible to map an NTFS security descriptor onto a posix acl
perfectly for every corner case)  the worst thing this will lead to is
for example that you told the application "here is the acl, the acl
says you can read/..."  but once the application tries to do so it
gets ACCESS_DENIED back from the server, which may surprise the app.

So, clientside, it is not strictly that important to get the mapping
when reading an ACL perfect.
Writing the ACL on the other hand, that is where things get a lot more
complicated. For that case it is probably best to never write the ACL
from posix and only do it from the windows explorer, you know what
actual permissions are set.


Aside from the ACLs and mapping the ACEs into a posix ACL, you will
also need to think about how
uid mapping should work.
In NTFS/SMB you don't have uids/gids  instead you have SIDs.
There is no standard way on doing this type of mapping and there are
several different ways to do so, depending on
requirements. Even samba itself has multiple different ways you can do
this. And none of them are better than the other. They are all
different and imperfect due to the underlying differences in security
model.
For unix/windows integration, deciding on how and which type of
mapping to use is often very difficult and something that takes a lot
of work and preparations to decide on.

So for the process of usermapping, you need a method to map a
user/group SID into a unix uid/gid. You could do this yourself by just
creating a persistent database between SIDs that you encounter and
just assign them new uids as you discover the SIDs.
You could also use the LookupSIDs call in the libsmb2 dce/rpc
implementation. This is an RPC to the server that tries to resolve a
SID into an account/group name, and then you could instead have a
database that maps between names and uid/gid.
An easier path would be to use winbindd or sshd and have the Linux
system joined to the domain and then winbindd/sshd will do this
mapping for you.
But then you have an external dependency with a sometimes complex
configuration you have to set up first.


Don't get me wrong. But usermapping and translation between NT and
Posix ACLs is very complex. It is well worth doing if you want to
but it is a massive project.
I would personally just do something very simple like :
1, tell the application that the permissions are 0777 for everything, always
2, tell the application that the uid/gid is the same as the current
process, always
3, hope that most applications will deal with it gracefully. Most will.

(This just because I have worked in the smb fileserver space for a
long long time and doing full usermapping and acl translation could
well be a multi-person-year project.)

> Stef
>
> PS it is sophisticated, but (I read somewhere) no system administrator
> will use the fine grained rules, use defaults (which make them
> predictable).

They absolutely do. But they won't be setting these ACL for every
single file or directory.
From am admin standpoint you mostly set these controls on a directory
level and then flag the ACE entries to be inherited.
Those settings will then at runtime also apply to all files and
directories below that directory.

When reading ACLs from the server for an object, you will not have to
do these scans recursively, it is done for you.
So if you do a "get acl for /foo/bar/baz" then the server will check
the ACL for all three of foo, bar and baz and on demand compute
what the total ACL would be for baz, taking into consideration
inheritable ACEs from foo and bar.

Reading ACLs is a pretty expensive operation server side for this reason.
But it is rich   and very powerful.


Taking inheritance into account, it might not be uncommon for the
resulting ACL for files in a large environment to have hundreds or
even thousands of ACE entries.


regards
ronnie sahlberg
