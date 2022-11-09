Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCE6C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 19:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiKITuX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiKITuX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 14:50:23 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E55C2DA
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 11:50:22 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id t14so17889263vsr.9
        for <linux-cifs@vger.kernel.org>; Wed, 09 Nov 2022 11:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+h9TeuXidQ3k3GadIkmIwetO2wxfA+tn4yVL6CUdhTE=;
        b=TAF9aLLERtUQpMOOENrH8ApjEVl2youzkshjHlbAlmt9IPId5J9Kq/A+vWpzx4uI37
         IxbWwY35T60bgcWGT4g3czY4yJ67CrXW3NISnBBOZ7WDxfhSr3y+3MAm8UZbzbfWbDSi
         Rvnu0N2g2Mjs9c0gGbk6CoH51uBoe1ezxePAKeoqhwYn7hD8pyFPjO4vB74p5rmRH/mg
         +DHB0Uo9uKMD/nEjCmh6PHwMgp71NNNuZGmvyLQEKrav6vlt4ldekPerHmRGCJBNyD4x
         46SntTv7yib2/aNQcreX8j7vZiCD6SiRsaAWExH1Qmsd94SU3wj3Pd+yAF3rS1biDX+x
         Q5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+h9TeuXidQ3k3GadIkmIwetO2wxfA+tn4yVL6CUdhTE=;
        b=N53v4MElbYiF00pyKtGOm9YEZ64lEct0g5BiPBCXg70FM3TD4THoOgq4UhydFwTfzc
         tP9PjK4Eo6qJvIvfmTGL7PcmI9wN6eLZcdF+dxmhrRaN48mznRhWHce6ynyFCB+nHOO5
         h+F07E8Is+Z0zN91R+NZb7uyMpmSG02X/4NjDOqsDiXEdpTPDnEHW8vKdTMoy+pV6jcl
         ncScla6Qs5fXn17dZdf0diCtquM/uOXNwCQIUc2UUgjkQm8SYRu2ixRoT2bvK+ca4gWk
         B7fH/hEbvU8GLpXm7Tao/N2t2HUcHYMRzM0eIUiuhKim0NdfI91/bv3KvUfC5hTLZ9GV
         ZZpA==
X-Gm-Message-State: ACrzQf23pX5WR5eUTrEWC8b10CLrKRvP4reJ0M9yiRcFX+/mf1/WI6nC
        v+c2mayY5U5QCLhI2v5Zsi/wMaUd8obR2ddnKbM=
X-Google-Smtp-Source: AMsMyM6wRN+ImRqI49lqp6pnZC2Pbrx8v/hIDBjOjnnfTn231cAWSc1OfwYkSDc7E8/cMiaYAuPnk/I620eh8BOGWTM=
X-Received: by 2002:a67:edc9:0:b0:3a9:ee9c:f9c4 with SMTP id
 e9-20020a67edc9000000b003a9ee9cf9c4mr31484653vsp.71.1668023421217; Wed, 09
 Nov 2022 11:50:21 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer> <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer> <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
 <Y2vzinRPFEBZyACg@jeremy-acer> <Y2v1zQbnPoqg+0aj@jeremy-acer>
In-Reply-To: <Y2v1zQbnPoqg+0aj@jeremy-acer>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 9 Nov 2022 21:50:09 +0200
Message-ID: <CAOQ4uxiDrtgrMeY_a0sq15PVNkjBJuT9STcBP7UuzZzdT8z4sw@mail.gmail.com>
Subject: Re: reflink support and Samba running over XFS
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, slow@samba.org, vl@samba.org,
        metze@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 9, 2022 at 8:47 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Wed, Nov 09, 2022 at 10:38:02AM -0800, Jeremy Allison via samba-technical wrote:
> >On Wed, Nov 09, 2022 at 11:32:30AM +0200, Amir Goldstein wrote:
> >>On Tue, Nov 8, 2022 at 7:53 PM Jeremy Allison via samba-technical
> >><samba-technical@lists.samba.org> wrote:
> >>>
> >>>On Mon, Nov 07, 2022 at 10:47:48PM -0800, Christoph Hellwig wrote:
> >>>>On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
> >>>>> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
> >>>>>
> >>>>> what ioctls are used for this in XFS ?
> >>>>>
> >>>>> We'd need a VFS module that implements them for XFS.
> >>>>
> >>>>That ioctl is now implemented in the Linux VFS and supported by btrfs,
> >>>>ocfs2, xfs, nfs (v4.2), cifs and overlayfs.
> >>>
> >>>I'm assuming it's this:
> >>>
> >>>https://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
> >>>
> >>>Yeah ? I'll write some test code and see if I can get it
> >>>into the vfs_default code.
> >>>
> >>
> >>Looks like this was already discussed during the work on generic
> >>implementation of FSCTL_SRV_COPYCHUNK:
> >>https://bugzilla.samba.org/show_bug.cgi?id=12033#c3
> >>
> >>Forgotten?
> >
> >Yep :-).
> >
> >>Left for later?
> >
> >So looks like we do copy_file_range(), but not CLONE_RANGE,
> >or rather CLONE_RANGE only in btrfs.
> >
> >So the code change needed is to move the logic in vfs_btrfs.c
> >into vfs_default.c, and change the call in vfs_btrfs.c:btrfs_offload_write_send()
> >to SMB_VFS_NEXT_OFFLOAD_WRITE_SEND() to call the old fallback code
> >inside vfs_default.c (vfswrap_offload_write_send()).
>
> Although looking at the current Linux kernel I find inside:
>
> ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>                             struct file *file_out, loff_t pos_out,
>                             size_t len, unsigned int flags)
> {
>
> https://github.com/torvalds/linux/blob/0adc313c4f20639f7e235b8d6719d96a2024cf91/fs/read_write.c#L1506
>
>         /*
>          * Try cloning first, this is supported by more file systems, and
>          * more efficient if both clone and copy are supported (e.g. NFS).
>          */
>         if (file_in->f_op->remap_file_range &&
>             file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
>                 loff_t cloned;
>
>                 cloned = file_in->f_op->remap_file_range(file_in, pos_in,
>                                 file_out, pos_out,
>                                 min_t(loff_t, MAX_RW_COUNT, len),
>                                 REMAP_FILE_CAN_SHORTEN);
>                 if (cloned > 0) {
>                         ret = cloned;
>
> and looking at the code supporting int ioctl(int dest_fd, FICLONERANGE, struct file_clone_range *arg);
> we have:
>
> loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>                            struct file *file_out, loff_t pos_out,
>                            loff_t len, unsigned int remap_flags)
> ...
>         ret = file_in->f_op->remap_file_range(file_in, pos_in,
>                         file_out, pos_out, len, remap_flags);
>
> So it *looks* like the copy_file_range() syscall will internally
> call the equivalent of FICLONERANGE if the underlying file
> system supports it.
>

It's true.
Unless you have some SMB command that requires the clone to be
a clone (what is VFS_COPY_CHUNK_FL_MUST_CLONE in the
referred comment?)
because currently there is no flag that can be passed to
copy_file_range() to request only clone.

Thanks,
Amir.

> So maybe the right fix is to remove the FICLONERANGE specific
> code from our vfs_btrfs.c and just always use copy_file_range().
>
> Any comments from other Samba Team members ?
>
> Jeremy.
