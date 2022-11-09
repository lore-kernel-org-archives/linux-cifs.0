Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF1EC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 18:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiKISrt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiKISrs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 13:47:48 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98F6260F
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 10:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=rBbR3q5RjKpmgtaSd6E4JfI2QhqXJ3WwoAZpBNdiyGU=; b=n5PfLCV8F/7VjuxhurPIh51+MJ
        +RzS2e5jCjZ5i4ZeFyhpnPU6priBRxCSBZ7We4z0L//xWaU0UAv5k2qxmlPixYRavXTalXGbGrLbM
        MT2TjTdOXR6o5zfBRkCjT4fGfZOmOcBkDsqAcG3qoZEaecO76u5j+GGN9weAh52Y2Ia+cat1tcslq
        Szy/Hy3xPHG1UXPYLwXRUwaFmm4qHMUa7S2aCGcKSA9jbHpjAlnMzL+HHWwJwomzcZvlMMBt8c+oH
        D5qlxw7dA6aOXAcKV232j0djuEDhgcfcytMbCWtbImt5C1TBQ89EBlnLD5KFWlwawJAwX9DjpH5c1
        d04djKSknw7MBEcpbwfTXwMIV/gH/prVWOp/dH/mRb0CS6/Jl3fafbXkS6M9rFmWDCamfM0PMNXe5
        7G6oNx3DfYZNruTonj8A6nzrCRJWHnKSdy90+2Rix6+Ex71ZRDmEEXIjz/kvKpppgggBOWg91SrTn
        MIB8d7nVyqs+m364VrmFx9hr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1osq6y-007tAF-Fj; Wed, 09 Nov 2022 18:47:44 +0000
Date:   Wed, 9 Nov 2022 10:47:41 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     slow@samba.org, vl@samba.org, metze@samba.org
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2v1zQbnPoqg+0aj@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer>
 <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
 <Y2vzinRPFEBZyACg@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y2vzinRPFEBZyACg@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 09, 2022 at 10:38:02AM -0800, Jeremy Allison via samba-technical wrote:
>On Wed, Nov 09, 2022 at 11:32:30AM +0200, Amir Goldstein wrote:
>>On Tue, Nov 8, 2022 at 7:53 PM Jeremy Allison via samba-technical
>><samba-technical@lists.samba.org> wrote:
>>>
>>>On Mon, Nov 07, 2022 at 10:47:48PM -0800, Christoph Hellwig wrote:
>>>>On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
>>>>> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
>>>>>
>>>>> what ioctls are used for this in XFS ?
>>>>>
>>>>> We'd need a VFS module that implements them for XFS.
>>>>
>>>>That ioctl is now implemented in the Linux VFS and supported by btrfs,
>>>>ocfs2, xfs, nfs (v4.2), cifs and overlayfs.
>>>
>>>I'm assuming it's this:
>>>
>>>https://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
>>>
>>>Yeah ? I'll write some test code and see if I can get it
>>>into the vfs_default code.
>>>
>>
>>Looks like this was already discussed during the work on generic
>>implementation of FSCTL_SRV_COPYCHUNK:
>>https://bugzilla.samba.org/show_bug.cgi?id=12033#c3
>>
>>Forgotten?
>
>Yep :-).
>
>>Left for later?
>
>So looks like we do copy_file_range(), but not CLONE_RANGE,
>or rather CLONE_RANGE only in btrfs.
>
>So the code change needed is to move the logic in vfs_btrfs.c
>into vfs_default.c, and change the call in vfs_btrfs.c:btrfs_offload_write_send()
>to SMB_VFS_NEXT_OFFLOAD_WRITE_SEND() to call the old fallback code
>inside vfs_default.c (vfswrap_offload_write_send()).

Although looking at the current Linux kernel I find inside:

ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
			    struct file *file_out, loff_t pos_out,
			    size_t len, unsigned int flags)
{

https://github.com/torvalds/linux/blob/0adc313c4f20639f7e235b8d6719d96a2024cf91/fs/read_write.c#L1506

	/*
	 * Try cloning first, this is supported by more file systems, and
	 * more efficient if both clone and copy are supported (e.g. NFS).
	 */
	if (file_in->f_op->remap_file_range &&
	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
		loff_t cloned;

		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
				file_out, pos_out,
				min_t(loff_t, MAX_RW_COUNT, len),
				REMAP_FILE_CAN_SHORTEN);
		if (cloned > 0) {
			ret = cloned;

and looking at the code supporting int ioctl(int dest_fd, FICLONERANGE, struct file_clone_range *arg);
we have:

loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
			   struct file *file_out, loff_t pos_out,
			   loff_t len, unsigned int remap_flags)
...
	ret = file_in->f_op->remap_file_range(file_in, pos_in,
			file_out, pos_out, len, remap_flags);

So it *looks* like the copy_file_range() syscall will internally
call the equivalent of FICLONERANGE if the underlying file
system supports it.

So maybe the right fix is to remove the FICLONERANGE specific
code from our vfs_btrfs.c and just always use copy_file_range().

Any comments from other Samba Team members ?

Jeremy.
