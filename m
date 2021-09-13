Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8D3C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 09:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7876961029
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 09:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbhIMJsh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238757AbhIMJsg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Sep 2021 05:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC5576101B;
        Mon, 13 Sep 2021 09:47:19 +0000 (UTC)
Date:   Mon, 13 Sep 2021 11:47:17 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: potential uninitialized error code in
 set_file_basic_info()
Message-ID: <20210913094717.nt3dt53sdmdjvcpf@wittgenstein>
References: <20210907073340.GC18254@kili>
 <YTccRzi/j+7t2eB9@google.com>
 <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 07, 2021 at 05:09:08PM +0900, Namjae Jeon wrote:
> 2021-09-07 17:01 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> > On (21/09/07 10:33), Dan Carpenter wrote:
> >>
> >> Smatch complains that there are some paths where "rc" is not set.
> >>
> >> Fixes: eb5784f0c6ef ("ksmbd: ensure error is surfaced in
> >> set_file_basic_info()")
> >> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> ---
> >>  fs/ksmbd/smb2pdu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index a350e1cef7f4..c86164dc70bb 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -5444,7 +5444,7 @@ static int set_file_basic_info(struct ksmbd_file
> >> *fp, char *buf,
> >>  	struct file *filp;
> >>  	struct inode *inode;
> >>  	struct user_namespace *user_ns;
> >> -	int rc;
> >> +	int rc = 0;
> >>
> >>  	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
> >>  		return -EACCES;
> >
> > It sort of feels like that `rc' is not needed there at all. It's being used
> > in
> >
> >                rc = ksmbd_vfs_set_dos_attrib_xattr(user_ns,
> >                                                    filp->f_path.dentry,
> > &da);
> >                if (rc)
> >                       ksmbd_debug(SMB,
> >                                  "failed to restore file attribute in
> > EA\n");
> >
> > and in
> >
> >                rc = setattr_prepare(user_ns, dentry, &attrs);
> >                if (rc)
> >                         return -EINVAL;
> >
> > Either it should be used more, and probably be a return value, or we can
> > just remove it.
> This patch is correct. But I have already fixed it.
> You can understand it if you check #ksmbd-for-next branch, not master.
> 
> https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next

Thanks for fixing it. I was out on vacation last week.

Christian
