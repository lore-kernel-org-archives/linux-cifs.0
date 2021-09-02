Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9D5C432BE
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 13:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC086109E
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 13:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhIBNof (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 09:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhIBNof (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 2 Sep 2021 09:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8EA161059;
        Thu,  2 Sep 2021 13:43:34 +0000 (UTC)
Date:   Thu, 2 Sep 2021 15:43:32 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 10/11] ksmbd: remove setattr preparations in
 set_file_basic_info()
Message-ID: <20210902134332.awyifebalkuurzl7@wittgenstein>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
 <20210823151357.471691-11-brauner@kernel.org>
 <CAKYAXd8MAk2hO7fdM1PSSh5czdaT+BGuidcm3Q3RFKBqzD5tLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKYAXd8MAk2hO7fdM1PSSh5czdaT+BGuidcm3Q3RFKBqzD5tLA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 01, 2021 at 09:47:17PM +0900, Namjae Jeon wrote:
> 2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > Permission checking and copying over ownership information is the task
> > of the underlying filesystem not ksmbd. The order is also wrong here.
> > This modifies the inode before notify_change(). If notify_change() fails
> > this will have changed ownership nonetheless. All of this is unnecessary
> > though since the underlying filesystem's ->setattr handler will do all
> > this (if required) by itself.
> >
> > Cc: Steve French <stfrench@microsoft.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: linux-cifs@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> >  fs/ksmbd/smb2pdu.c | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index 1148e52a4037..059764753aaa 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -5521,12 +5521,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
> > char *buf,
> >  		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> >  			return -EACCES;
> >
> > -		rc = setattr_prepare(user_ns, dentry, &attrs);
> > -		if (rc)
> > -			return -EINVAL;
> > -
> >  		inode_lock(inode);
> > -		setattr_copy(user_ns, inode, &attrs);
> >  		attrs.ia_valid &= ~ATTR_CTIME;
> >  		rc = notify_change(user_ns, dentry, &attrs, NULL);
> setattr_prepare() was used for updating ->ctime to ChangeTime in set
> file basic info request. but notify_change() have just updated it to
> current time. So some of smbtorture tests failed.
> Could you please review the below change ?
> https://github.com/namjaejeon/smb3-kernel/commit/831bcdeaa5231a8d8125f6155833f1cb5dc0f8ca

Ok, looks good.

Christian
