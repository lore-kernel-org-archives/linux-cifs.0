Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71775C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E12610F8
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhHXLhp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235125AbhHXLhp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Aug 2021 07:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EEA9610FB;
        Tue, 24 Aug 2021 11:36:58 +0000 (UTC)
Date:   Tue, 24 Aug 2021 13:36:55 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 11/11] ksmbd: defer notify_change() call
Message-ID: <20210824113655.hmoes2v56l5s5xke@wittgenstein>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
 <20210823151357.471691-12-brauner@kernel.org>
 <CAKYAXd_B1uJEh_Y_JRi1o_zucd92-tAvDFjJ8ZW2my2D86-Zsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKYAXd_B1uJEh_Y_JRi1o_zucd92-tAvDFjJ8ZW2my2D86-Zsg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 24, 2021 at 05:20:48PM +0900, Namjae Jeon wrote:
> 2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > When ownership is changed we might in certain scenarios loose the
> > ability to alter the inode after we changed ownership. This can e.g.
> > happen when we are on an idmapped mount where uid 0 is mapped to uid
> > 1000 and uid 1000 is mapped to uid 0.
> > A caller with fs*id 1000 will be able to create files as *id 1000 on
> > disk. They will also be able to change ownership of files owned by *id 0
> > to *id 1000 but they won't be able to change ownership in the other
> > direction. This means acl operations following notify_change() would
> > fail. Move the notify_change() call after the acls have been updated.
> > This guarantees that we don't end up with spurious "hash value diff"
> > warnings later on because we managed to change ownership but didn't
> > manage to alter acls.
> >
> > Cc: Steve French <stfrench@microsoft.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: linux-cifs@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> >  fs/ksmbd/smbacl.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> > index ef5896297607..8457a3c27c12 100644
> > --- a/fs/ksmbd/smbacl.c
> > +++ b/fs/ksmbd/smbacl.c
> > @@ -1334,25 +1334,27 @@ int set_info_sec(struct ksmbd_conn *conn, struct
> > ksmbd_tree_connect *tcon,
> >  	newattrs.ia_valid |= ATTR_MODE;
> >  	newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
> >
> > -	inode_lock(inode);
> > -	rc = notify_change(user_ns, path->dentry, &newattrs, NULL);
> > -	inode_unlock(inode);
> > -	if (rc)
> > -		goto out;
> > -
> >  	ksmbd_vfs_remove_acl_xattrs(user_ns, path->dentry);
> >  	/* Update posix acls */
> >  	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
> >  		rc = set_posix_acl(user_ns, inode,
> >  				   ACL_TYPE_ACCESS, fattr.cf_acls);
> > +		if (rc < 0)
> > +			ksmbd_debug(SMB,
> > +				    "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
> > +				    rc);
> >  		if (S_ISDIR(inode->i_mode) && fattr.cf_dacls)
> You seem to have missed adding braces after adding a debug print.
> I will directly update it if you don't mind.

Sounds good. Thanks!

Christian
