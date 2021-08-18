Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C19C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 17:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A4260EFE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 17:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhHRRqV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 13:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhHRRqV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 13:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53A20610CB;
        Wed, 18 Aug 2021 17:45:44 +0000 (UTC)
Date:   Wed, 18 Aug 2021 19:45:39 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'Christian Brauner' <brauner@kernel.org>,
        'Sergey Senozhatsky' <senozhatsky@chromium.org>,
        'David Sterba' <dsterba@suse.com>,
        'Steve French' <stfrench@microsoft.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Hyunchul Lee' <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix lookup on idmapped mounts
Message-ID: <20210818174539.ro2ryrbku3ozdjvi@wittgenstein>
References: <CGME20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c@epcas1p4.samsung.com>
 <20210816115605.178441-1-brauner@kernel.org>
 <008d01d792f6$c2735f30$475a1d90$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <008d01d792f6$c2735f30$475a1d90$@samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 17, 2021 at 08:30:55AM +0900, Namjae Jeon wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> > 
> > It's great that the new in-kernel ksmbd server will support idmapped mounts out of the box! However,
> > lookup is currently broken. Lookup helpers such as lookup_one_len() call inode_permission() internally
> > to ensure that the caller is privileged over the inode of the base dentry they are trying to lookup
> > under. So the permission checking here is currently wrong.
> > 
> > Linux v5.15 will gain a new lookup helper lookup_one() that does take idmappings into account. I've
> > added it as part of my patch series to make btrfs support idmapped mounts. The new helper is in linux-
> > next as part of David's (Sterba) btrfs for-next branch as commit c972214c133b ("namei: add mapping
> > aware lookup helper").
> > 
> > I've said it before during one of my first reviews: I would very much recommend adding fstests to [1].
> > It already seems to have very rudimentary cifs support. There is a completely generic idmapped mount
> > testsuite that supports idmapped mounts.
> > 
> > [1]: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
> > Cc: Steve French <stfrench@microsoft.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: David Sterba <dsterba@suse.com>
> > Cc: linux-cifs@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> Hi Christian,
> 
> > I merged David's for-next tree into cifsd-next to test this. I did only compile test this. If someone
> > gives me a clear set of instructions how to test ksmbd on my local machine I can at least try to cut
> > some time out of my week to do more reviews. (I'd especially like to see acl behavior with ksmbd.)
> 
> There is "How to run ksmbd" section in patch cover letter.
>  https://lkml.org/lkml/2021/8/5/54
> 
> Let me know if it doesn't work well even if you try to run it with this step.
> And We will also check whether your patch work fine.
> 
> > 
> > One more thing, the tree for ksmbd was very hard to find. I had to do a lot archeology to end up at:
> > 
> > git://git.samba.org/ksmbd.git
> This is also in the patch cover letter. See "Mailing list and repositories" section.
> I think that you can use :
>     https://github.com/namjaejeon/smb3-kernel/tree/ksmbd-v7-series
> 
> > 
> > Would be appreciated if this tree could be reflected in MAINTAINERS or somewhere else. The github
> > repos with the broken out patches/module aren't really that helpful.
> Okay, I will add git address of ksmbd in MAINTAINERS on next spin.
> 
> > 
> > Thanks!
> > Christian
> Really thanks for your review and I will apply this patch after checking it.

Thank your for the pointers.

Ok, so I've been taking the time to look into cifs and ksmbd today. My
mental model was wrong. There are two things to consider here:

1. server: idmapped mounts with ksmbd
2. client: idmapped mounts with cifs

Your patchset adds support for 1.
Let's say I have the following ksmbd config:

root@f2-vm:~# cat /etc/ksmbd/smb.conf
[global]
        netbios name = SMBD
        server max protocol = SMB3
[test]
        path = /opt
        writeable = yes
        comment = TEST
        read only = no

So /opt can be an idmapped mount and ksmb would know how to deal with
that correctly, i.e. you could do:

mount-idmapped --map-mount=b:1000:0:1 /opt /opt

ksmbd.mountd

and ksmbd would take the idmapping of /opt into account.

That however is different from 2. which is cifs itself being idmappable.
Whether or not that makes sense or is needed will need some thinking.

In any case, this has consequences for xfstests and now I understand
your earlier confusion. In another mail you pointed out that cifs
reports that idmapped mounts are not supported. That is correct insofar
as it means 2. is not supported, i.e. you can't do:

mount -t cifs -o username=foo,password=bar //server/files /mnt

and then

mount-idmapped --map-mount=b:1000:0:1 /mnt /mnt

but that's also not what you want in order to test for ksmbd. What you
want is to test 1.

So your test setup would require you to setup an idmapped mount and have
ksmbd use that which can then be mounted by a client.

With your instructions I was at least able to get a ksmb instance
running and be able to mount a client with -t cifs. All on the same
machine, i.e. my server is localhost.

However, I need to dig a bit into the semantics to make better
assertions about what's going on.

Are unix extension supported with ksmb? Everytime I try to use "posix"
as a mount option with mount -t cifs -o //127.0.0.1/test /mnt I get
"uid=0" and "gid=0" and "noposix". I do set "unix extensions = yes" in
both the samba and ksmbd smb.conf.

Christian
