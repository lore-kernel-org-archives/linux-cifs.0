Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C4AC43214
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Aug 2021 05:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47084610E6
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Aug 2021 05:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhHUGAB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Aug 2021 02:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhHUGAB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 21 Aug 2021 02:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF6F2611EF
        for <linux-cifs@vger.kernel.org>; Sat, 21 Aug 2021 05:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629525562;
        bh=Sw2hx449bmsTssdmnNJySH0AaHwsHPlVLMQrshvGDo0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mki9eCXeWDLEByMTph2WLrVrz82wyEUjyTipBXSb2Hm940eKrtmlaHjQ09cH8FcfZ
         fnNOJeQcwNaea5Vbpry0ke1Regh5HWACrmnxyVdQoUTZC2dUEogWMKupNWJUVUICw6
         Ue8nb1LuDA3Z+uvPGwBGLsfcQk66E9xu6oUELZrI9KJyEYUme+tfHm0phboiZmNKH4
         WYGmXrLakQ0mbwt2IWVIGpB5tL84GWsMrh/ZpN/fcFYeIxPkDxUept0OmpU2MHFF4t
         l8fs6JQmu4SHLGOJzPF01jpxcamAjr4OmF4paZtmSOCLQCvDSxgvp5UuuE+bCwPxAf
         3APhG/nXKghCQ==
Received: by mail-ot1-f47.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so11218615otg.11
        for <linux-cifs@vger.kernel.org>; Fri, 20 Aug 2021 22:59:22 -0700 (PDT)
X-Gm-Message-State: AOAM530XQBQzbkG1cyA+/QgjzZBTtBVCqvapmtzK844B/sNizjWSPcl1
        zWBKkUjUWSSdHdCzYfvFFFeDZ1RnzSwirDvyOM4=
X-Google-Smtp-Source: ABdhPJy7QgrcyNGPOTIKkCrcaGZsRhi1AK8B6mpVnl0Zh1hj1XdMNVFOcTqoX+vh+kIUGjcw6ldc1HreoK58kz0Enn0=
X-Received: by 2002:aca:bfc6:: with SMTP id p189mr5342391oif.167.1629525562016;
 Fri, 20 Aug 2021 22:59:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Fri, 20 Aug 2021 22:59:21
 -0700 (PDT)
In-Reply-To: <20210819130136.zziq7yr4htiowb5n@wittgenstein>
References: <CGME20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c@epcas1p4.samsung.com>
 <20210816115605.178441-1-brauner@kernel.org> <008d01d792f6$c2735f30$475a1d90$@samsung.com>
 <20210818174539.ro2ryrbku3ozdjvi@wittgenstein> <000001d794a0$94ec20a0$bec461e0$@samsung.com>
 <20210819130136.zziq7yr4htiowb5n@wittgenstein>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 21 Aug 2021 14:59:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ON8-j9_uPTE4fi_kW9Zi_8ov++3ujJm5etnigiZ6uQw@mail.gmail.com>
Message-ID: <CAKYAXd9ON8-j9_uPTE4fi_kW9Zi_8ov++3ujJm5etnigiZ6uQw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix lookup on idmapped mounts
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Christian Brauner <brauner@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        David Sterba <dsterba@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-08-19 22:01 GMT+09:00, Christian Brauner <christian.brauner@ubuntu.com>:
> On Thu, Aug 19, 2021 at 11:19:04AM +0900, Namjae Jeon wrote:
>> > On Tue, Aug 17, 2021 at 08:30:55AM +0900, Namjae Jeon wrote:
>> > > > From: Christian Brauner <christian.brauner@ubuntu.com>
>> > > >
>> > > > It's great that the new in-kernel ksmbd server will support
>> > > > idmapped
>> > > > mounts out of the box! However, lookup is currently broken. Lookup
>> > > > helpers such as lookup_one_len() call inode_permission() internally
>> > > > to ensure that the caller is privileged over the inode of the base
>> > > > dentry they are trying to
>> > lookup under. So the permission checking here is currently wrong.
>> > > >
>> > > > Linux v5.15 will gain a new lookup helper lookup_one() that does
>> > > > take idmappings into account. I've added it as part of my patch
>> > > > series to make btrfs support idmapped mounts. The new helper is in
>> > > > linux- next as part of David's (Sterba) btrfs for-next branch as
>> > > > commit c972214c133b ("namei: add
>> > mapping aware lookup helper").
>> > > >
>> > > > I've said it before during one of my first reviews: I would very
>> > > > much recommend adding fstests to
>> > [1].
>> > > > It already seems to have very rudimentary cifs support. There is a
>> > > > completely generic idmapped mount testsuite that supports idmapped
>> > > > mounts.
>> > > >
>> > > > [1]: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
>> > > > Cc: Steve French <stfrench@microsoft.com>
>> > > > Cc: Christoph Hellwig <hch@infradead.org>
>> > > > Cc: Namjae Jeon <namjae.jeon@samsung.com>
>> > > > Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> > > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> > > > Cc: David Sterba <dsterba@suse.com>
>> > > > Cc: linux-cifs@vger.kernel.org
>> > > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>> > > > ---
>> > > Hi Christian,
>> > >
>> > > > I merged David's for-next tree into cifsd-next to test this. I did
>> > > > only compile test this. If someone gives me a clear set of
>> > > > instructions how to test ksmbd on my local machine I can at least
>> > > > try to cut some time out of my week to do more reviews. (I'd
>> > > > especially like to see acl behavior with ksmbd.)
>> > >
>> > > There is "How to run ksmbd" section in patch cover letter.
>> > >
>> > > https://protect2.fireeye.com/v1/url?k=65ecaaf0-3a779239-65ed21bf-0cc47
>> > > a336fae-53bc47005a1a97a9&q=1&e=e44c9f9f-d7ae-4768-8cc2-8f02d748fc6e&u=
>> > > https%3A%2F%2Flkml.org%2Flkml%2F2021%2F8%2F5%2F54
>> > >
>> > > Let me know if it doesn't work well even if you try to run it with
>> > > this step.
>> > > And We will also check whether your patch work fine.
>> > >
>> > > >
>> > > > One more thing, the tree for ksmbd was very hard to find. I had to
>> > > > do a lot archeology to end up
>> > at:
>> > > >
>> > > > git://git.samba.org/ksmbd.git
>> > > This is also in the patch cover letter. See "Mailing list and
>> > > repositories" section.
>> > > I think that you can use :
>> > >
>> > > https://protect2.fireeye.com/v1/url?k=8af83a5d-d5630294-8af9b112-0cc47
>> > > a336fae-e471ffbdb93d05b7&q=1&e=e44c9f9f-d7ae-4768-8cc2-8f02d748fc6e&u=
>> > > https%3A%2F%2Fgithub.com%2Fnamjaejeon%2Fsmb3-kernel%2Ftree%2Fksmbd-v7-
>> > > series
>> > >
>> > > >
>> > > > Would be appreciated if this tree could be reflected in MAINTAINERS
>> > > > or somewhere else. The github repos with the broken out
>> > > > patches/module aren't really that helpful.
>> > > Okay, I will add git address of ksmbd in MAINTAINERS on next spin.
>> > >
>> > > >
>> > > > Thanks!
>> > > > Christian
>> > > Really thanks for your review and I will apply this patch after
>> > > checking it.
>> >
>> > Thank your for the pointers.
>> >
>> > Ok, so I've been taking the time to look into cifs and ksmbd today. My
>> > mental model was wrong. There
>> > are two things to consider here:
>> >
>> > 1. server: idmapped mounts with ksmbd
>> > 2. client: idmapped mounts with cifs
>> >
>> > Your patchset adds support for 1.
>> Right.
>>
>> > Let's say I have the following ksmbd config:
>> >
>> > root@f2-vm:~# cat /etc/ksmbd/smb.conf
>> > [global]
>> >         netbios name = SMBD
>> >         server max protocol = SMB3
>> > [test]
>> >         path = /opt
>> >         writeable = yes
>> >         comment = TEST
>> >         read only = no
>> >
>> > So /opt can be an idmapped mount and ksmb would know how to deal with
>> > that correctly, i.e. you could
>> > do:
>> >
>> > mount-idmapped --map-mount=b:1000:0:1 /opt /opt
>> >
>> > ksmbd.mountd
>> >
>> > and ksmbd would take the idmapping of /opt into account.
>> Right.
>>
>> >
>> > That however is different from 2. which is cifs itself being
>> > idmappable.
>> Right.
>>
>> > Whether or not that makes sense or is needed will need some thinking.
>> >
>> > In any case, this has consequences for xfstests and now I understand
>> > your earlier confusion. In
>> > another mail you pointed out that cifs reports that idmapped mounts are
>> > not supported. That is correct
>> > insofar as it means 2. is not supported, i.e. you can't do:
>> Right.
>>
>> >
>> > mount -t cifs -o username=foo,password=bar //server/files /mnt
>> >
>> > and then
>> >
>> > mount-idmapped --map-mount=b:1000:0:1 /mnt /mnt
>> >
>> > but that's also not what you want in order to test for ksmbd. What you
>> > want is to test 1.
>> Right. So we have manually tested it, not xfstests.
>>
>> >
>> > So your test setup would require you to setup an idmapped mount and have
>> > ksmbd use that which can then
>> > be mounted by a client.
>> >
>> > With your instructions I was at least able to get a ksmb instance
>> > running and be able to mount a
>> > client with -t cifs. All on the same machine, i.e. my server is
>> > localhost.
>> Okay.
>>
>> >
>> > However, I need to dig a bit into the semantics to make better
>> > assertions about what's going on.
>> Okay. And I have applied your patch to ksmbd.
>>
>> >
>> > Are unix extension supported with ksmb? Everytime I try to use "posix"
>> > as a mount option with mount -t cifs -o //127.0.0.1/test /mnt I get
>> > "uid=0" and "gid=0" and "noposix".
>> > I do set "unix extensions = yes" in both the samba and ksmbd smb.conf.
>> With posix mount option, It should work. It worked well before but it is
>> strange now.
>>
>> I'm not sure this is the correct fix, But could you please try to mount
>> with the below change ?
>>
>> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
>> index eed59bc1d913..5fd0b0ddcc57 100644
>> --- a/fs/cifs/fs_context.c
>> +++ b/fs/cifs/fs_context.c
>> @@ -1268,8 +1268,10 @@ static int smb3_fs_context_parse_param(struct
>> fs_context *fc,
>>         case Opt_unix:
>>                 if (result.negated)
>>                         ctx->linux_ext = 0;
>> -               else
>> +               else {
>> +                       ctx->linux_ext = 1;
>>                         ctx->no_linux_ext = 1;
>> +               }
>>                 break;
>>         case Opt_nocase:
>>                 ctx->nocase = 1;
>
> That stops the bleeding indeed. :)
Okay, sorry for late response.
> I think a slightly nicer fix might be:
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index eed59bc1d913..424b8dc2232e 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -1269,7 +1269,8 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>                 if (result.negated)
>                         ctx->linux_ext = 0;
>                 else
> -                       ctx->no_linux_ext = 1;
> +                       ctx->linux_ext = 1;
> +               ctx->no_linux_ext = !ctx->linux_ext;
>                 break;
>         case Opt_nocase:
>                 ctx->nocase = 1;
>
> So with this patch applied I got unix permissions working after all. So
> I was able to do some more testing.
Okay.
>
> Just a few questions (independent of idmapped mounts):
>
> 1. Are the "uid=" and "gid=" mount options ignored when "username=" is
>    specified and "posix" is specified?
>
>    It seems that "uid=" and "gid=" have are silently ignored when
>    "posix' is set. They are neither used to report file ownership under
>    the cifs mountpoint nor are they relevant when determining ownership
>    on disk?
>
>    As an example, assume I have added a user "foo" with uid 1000 to
>    ksmbd via:
>
>            ksmbd.adduser -a foo
>
>    And I mounted a share via:
>
>            mount -t cifs -o
> username=foo,password=bar,posix,uid=1234,gid=1234,forceuid,forcegid
> //127.0.0.1/test /mnt
>
>    i) Ownership in /mnt appears posix-correct, i.e. "uid=" and "gid=" have
>       no effect on the reported ownership.
>
>    ii) Assume I'm logged in as the root user with uid 0. If I create
>        file or directory in /mnt it will be owned by user foo, i.e. uid
>        1000, i.e., the "uid=1234" and "gid=1234" mount option have zero
>        effect on the ownership of the files?
>
> 2. Are the "uid=" and "gid=" options ignored for permission checking
>    when "posix" is specified?
>
> 3. Am I correct in assuming that there is no mount option that makes
>    chown() or chmod() have an actual effect.
That will be an answer for 1,2, 3 question. There are mount options for this.
 1. modefromsid
 2. idsfromsid

You can use this mount option and please check it.
>
>    cifs seems to have support for it but the ksmbd server doesn't seem
>    to?
No, you need to use mount options for this as I said.
ksmbd have supported it but I found an issue related to chown and have fixed.

Could you please check the below git branch (pulled David'tree + ksmbd fixes) ?

  git clone --branch=for-christian https://github.com/namjaejeon/smb3-kernel

Thanks!
>
>    Both with "perm" and "noperm" chown() and chmod() report success but
>    without actually changing ownership or mode. That seems to be in line
>    with what I can gather from various mangpages.
>
> Christian
>
