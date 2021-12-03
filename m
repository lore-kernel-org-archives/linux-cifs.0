Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B8EC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 04:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhLCFDQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 00:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhLCFDQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 00:03:16 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FCDC06174A
        for <linux-cifs@vger.kernel.org>; Thu,  2 Dec 2021 20:59:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v1so6789023edx.2
        for <linux-cifs@vger.kernel.org>; Thu, 02 Dec 2021 20:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kw29GGHQceiTidepg/nhhodwhUX3on7UghVCvOXG9kg=;
        b=Y0Q443uyO3z86yRW2G43F8gXASjvfH5Kco4fg5W154FAgbbSXo34jMdXZ5AeoY8aqc
         Lcv1qytY5pVTrUWe4nWGHrwJjUq3v4d+L592NQDHGV8272frTzFvDAqVqu315fH9Nmmg
         vv2xIxGC4DRaNbl0S5besIZiA2en/Jh0qpSxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kw29GGHQceiTidepg/nhhodwhUX3on7UghVCvOXG9kg=;
        b=PRPJO/G/Zh4MH7lNAVC8yfy25oQfVFMBC5f3wgz0S9IILaT2RWnjZ4ZAihQLFo+KIO
         Gy5M1m68rBSl+kZbmWAlespNwdPbpg61JNCBbWn6lTj6K5upF/oKK9gRK7ptiEf3vosw
         eQXZhZTlU6/iHqQlrBuvjPJ+6JG4pPo13e6BlpYwU8w5GEb9tgc0vvxxTPWw/d7L9K9n
         TaTr+0P49h5X1G6HwKDBiqDZtmiw+WFLLJ+b1/BGYfXYZdZW4a/sfB4maAYkQy6APee+
         Gxj+/Vp3iq5m1Hxzi9aFvb5Td12dib4jk8JtsXQcrNkcOco9//ofZ0tUEymZ2d0b7v7c
         QlFQ==
X-Gm-Message-State: AOAM533BmKUntzf0dUtpbBwE5JHl76TeHMZ/Akjy3yGxoy+8wT+gYHTD
        8bPMwbtZI68VanGm51TocBM/Ml8oJKN4X1tcUovX6A==
X-Google-Smtp-Source: ABdhPJy6cHEGk5/N7PgetgcVLwOayx54NYwfifzTXV9JtKJ2CYXAsWerpuqoC7biS0PzPqVDG3iK9Yb2JST23tsHK0k=
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr23863866edz.36.1638507590966;
 Thu, 02 Dec 2021 20:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com> <20211201165728.r3jvaan2hw5icfvp@cyberdelia>
In-Reply-To: <20211201165728.r3jvaan2hw5icfvp@cyberdelia>
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Date:   Fri, 3 Dec 2021 13:59:40 +0900
Message-ID: <CA+_sPar2eifjAt_+gbLfdH9ns+YmWtQG3HhXVep5dx0=wqGs_w@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

On Thu, Dec 2, 2021 at 1:57 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> > ...
> > The intention is to make it more like other modern tools (e.g. git,
> > nvme, virsh, etc) which have more clear user interface, readable
> > commands, and also makes it easier to script.
> >
> > Example commands:
> >   # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
> >   # ksmbdctl user add myuser
> >   # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
> >   # ksmbdctl daemon start
> >
> > Besides adding a new "share list" command, any previously working
> > functionality shouldn't be affected.
>
> - clearer user interface: having a single binary looks much clearer than
>    having several separate programs when, e.g. the user is looking which
>    program does what.
>
> - more readable commands: continuing from topic above, the situation is
>    improved especially when you see that, e.g., the ksmbd.addshare program
>    also updates and deletes shares. With this unification, it is way more
>    intuitive to use:

I've always preferred the UNIX way: one app does one thing and one thing only.
This is why we have cp and mv, mkdir and touch, etc. we don't have a
single vfs-ctl
app that takes several hundred arguments and whose man page is basically a
small book (20+ pages long). This way we:
- keep manpages short and clear
- avoid params conflicts and ambiguity
- keep eggs in different baskets

> I ask you to consider the applications I used as inspiration for such change, such as git

Git is a tricky example. But OK. If this will be implemented in a way
git builtins are
implemented - then I don't see why we would not want this.

git builtins are basically independent apps (they even link all
commands into separate
binaries and then symlink them during installation) which have been
rewritten from either
shell/perl scripts or standalone binaries in C and put into builtins/
directory, for performance
reasons. There are still a handful of shell/perl and standalone
binaries - e.g. git-remote-ftp,
git-http-fetch, git-http-push, ./git-bisect is a shell script. And so on.

Built-in commands are, basically, independent binaris that have a
common ancestor with the
only exception that git does not fork/exec them (not all of them).
They even have entry points
that resemble main() - they take "int argc, const char **argv" - and
git passes its argc and argv
down to built-ins.

Schematically

git: main(int argc, char **argv) {
      builtin = lookup_builtin_command();
      builtin->run(argc, argv);
}

Is this what you have in mind?

>   # ksmbdctl daemon start

Is this going to fork ksmb daemon? Otherwise this looks confusing. I'd
say that ksmbd daemon
needs to have a different name that will clearly show that it's a ksmb
daemon, not the "control"
tool that adds shares and deletes users.
