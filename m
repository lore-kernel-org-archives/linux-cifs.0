Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3F9C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 14:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE0361157
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 14:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbhHSOQZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Aug 2021 10:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238495AbhHSOQY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Aug 2021 10:16:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695936113D;
        Thu, 19 Aug 2021 14:15:46 +0000 (UTC)
Date:   Thu, 19 Aug 2021 16:15:42 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        David Sterba <dsterba@suse.com>, linux-cifs@vger.kernel.org
Subject: Re: ksmbd: fix lookup on idmapped mounts
Message-ID: <20210819141542.7temhlbcbz2wjq3t@wittgenstein>
References: <abe632a9-cde9-25b4-f336-4ff128bf7fd9@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abe632a9-cde9-25b4-f336-4ff128bf7fd9@canonical.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 19, 2021 at 02:11:43PM +0100, Colin Ian King wrote:
> Hi,
> 
> Static analysis on linux-next with Coverity has detected a potential
> issue in fs/ksmbd/smb2pdu.c with the following commit:
> 
> commit 4b499755e1024f97e75411920a404b357af6e153
> Author: Christian Brauner <christian.brauner@ubuntu.com>
> Date:   Mon Aug 16 13:56:05 2021 +0200
> 
>     ksmbd: fix lookup on idmapped mounts
> 
> The analysis is as follows:
> 
> 5626 static int set_rename_info(struct ksmbd_work *work, struct
> ksmbd_file *fp,
> 5627                           char *buf)
> 5628 {
> 
>     1. var_decl: Declaring variable user_ns without initializer.
> 
> 5629        struct user_namespace *user_ns;
> 5630        struct ksmbd_file *parent_fp;
> 5631        struct dentry *parent;
> 5632        struct dentry *dentry = fp->filp->f_path.dentry;
> 5633        int ret;
> 5634
> 
>     2. Condition !(fp->daccess & 65536U /* (__le32)(__u32)65536 */),
> taking false branch.
> 
> 5635        if (!(fp->daccess & FILE_DELETE_LE)) {
> 5636                pr_err("no right to delete : 0x%x\n", fp->daccess);
> 5637                return -EACCES;
> 5638        }
> 5639
> 
>     3. Condition ksmbd_stream_fd(fp), taking true branch.
> 
> 5640        if (ksmbd_stream_fd(fp))
> 
>     4. Jumping to label next.
> 
> 5641                goto next;
> 5642
> 5643        user_ns = file_mnt_user_ns(fp->filp);
> 5644        parent = dget_parent(dentry);
> 5645        ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
> 5646        if (ret) {
> 5647                dput(parent);
> 5648                return ret;
> 5649        }
> 5650
> 5651        parent_fp = ksmbd_lookup_fd_inode(d_inode(parent));
> 5652        inode_unlock(d_inode(parent));
> 5653        dput(parent);
> 5654
> 5655        if (parent_fp) {
> 5656                if (parent_fp->daccess & FILE_DELETE_LE) {
> 5657                        pr_err("parent dir is opened with delete
> access\n");
> 5658                        return -ESHARE;
> 5659                }
> 5660        }
> 5661 next:
> 
>     Uninitialized pointer read (UNINIT)
>     5. uninit_use_in_call: Using uninitialized value user_ns when
> calling smb2_rename.
> 
> 5662        return smb2_rename(work, fp, user_ns,
> 5663                           (struct smb2_file_rename_info *)buf,
> 5664                           work->sess->conn->local_nls);
> 5665 }
> 
> The pointer user_ns is not initialized and the goto on line 5641 will
> cause this uninitialized pointer value to be passed to smb2_rename.
> 
> I suspect user_ns = file_mnt_user_ns(fp->filp) should be moved to line
> 5639 as a fix, but I'm concerned that this is not a suitable fix.

Thanks for the report, Colin.
No, the fix you propose is correct. Ugh, the goto in this function is
rather messy:

	if (ksmbd_stream_fd(fp))
		goto next;

	user_ns = file_mnt_user_ns(fp->filp);
	parent = dget_parent(dentry);
	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);

I'll send a fixed version of this patch later today.

Thanks!
Christian
