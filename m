Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2E6C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 18:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiAMSQK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jan 2022 13:16:10 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33500 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMSQK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jan 2022 13:16:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F26811F3A8;
        Thu, 13 Jan 2022 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642097768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEMkGZFTny77GzanwwTyqVq5KH9c4dC7tsjnN/z+W/c=;
        b=N/QFVPO0k+ZHQrMBCfRaRYAKH8SsoE8iWTyIsKnrqzInYA20gFfUInSmZeGpUPnJP1jqVY
        5Zj5tRKhkJzjo/d6cDPm2DDsJE7wnW3Hedl0mE039uN3wDCL9M5r80L2qM/rwTvNa1XfEx
        fWYuB6aV5Rypb9cLfxPBg68XwWxNC/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642097768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEMkGZFTny77GzanwwTyqVq5KH9c4dC7tsjnN/z+W/c=;
        b=UZY0NQZyhlarfyN0g0+Awo2NpFV/4oIkr6HQTqrbplEhyLqiFjhBPWYAAEMBVYtW/fM+3q
        za3kRDjX+TQP3XBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A89CA13EA7;
        Thu, 13 Jan 2022 18:16:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BZQGJ2hs4GGxYwAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 13 Jan 2022 18:16:08 +0000
Date:   Thu, 13 Jan 2022 19:16:07 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Jeremy Allison <jra@samba.org>, David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, Shyam Prasad N <nspmangalore@gmail.com>,
        jlayton@kernel.org, linux-cifs@vger.kernel.org
Subject: Re: Incorrect fallocate behaviour in cifs or samba?
Message-ID: <20220113191607.04e20180@suse.de>
In-Reply-To: <YeBkxLnh8+sUv968@jeremy-acer>
References: <1828480.1642079920@warthog.procyon.org.uk>
        <1856457.1642087232@warthog.procyon.org.uk>
        <YeBkxLnh8+sUv968@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Jeremy and David,

On Thu, 13 Jan 2022 09:43:32 -0800, Jeremy Allison wrote:

> On Thu, Jan 13, 2022 at 03:20:32PM +0000, David Howells wrote:
> >David Howells <dhowells@redhat.com> wrote:
> >  
> >> If I do the following:
> >>
> >> 	mount //carina/test /xfstest.test -o user=shares,pass=foobar,noperm,vers=3.0,mfsymlinks,actimeo=0
> >> 	/usr/sbin/xfs_io -f -t \
> >> 		-c "pwrite -S 0x41 0 4096"
> >> 		-c "pwrite -S 0x42 4096 4096"
> >> 		-c "fzero 0 4096" \
> >> 		-c "pread 0 8192" \
> >> 		/xfstest.test/008.7067
> >> ...
> >>    31 0.321638749  192.168.6.2 -> 192.168.6.1  SMB2 206 Ioctl Request FSCTL_SET_ZERO_DATA File: 008.7067  
> >
> >So what I see is that Samba does:
> >
> >	fallocate(24, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 0, 4096) = 0
> >
> >for this... but that's not what cifs was asked to do.  Should Samba be using
> >FALLOC_FL_ZERO_RANGE instead?  
> 
> This is from fsctl_zero_data() in Samba. We have:
> 
>          /*
>           * MS-FSCC <58> Section 2.3.67
>           * This FSCTL sets the range of bytes to zero (0) without extending the
>           * file size.
>           *
>           * The VFS_FALLOCATE_FL_KEEP_SIZE flag is used to satisfy this
>           * constraint.
>           */
> 
>          mode = VFS_FALLOCATE_FL_PUNCH_HOLE | VFS_FALLOCATE_FL_KEEP_SIZE;
>          ret = SMB_VFS_FALLOCATE(fsp, mode, zdata_info.file_off, len);
>          if (ret == -1)  {
>                  status = map_nt_error_from_unix_common(errno);
>                  DEBUG(2, ("zero-data fallocate(0x%x) failed: %s\n", mode,
>                        strerror(errno)));
>                  return status;
>          }
> 
>          if (!fsp->fsp_flags.is_sparse && lp_strict_allocate(SNUM(fsp->conn))) {
>                  /*
>                   * File marked non-sparse and "strict allocate" is enabled -
>                   * allocate the range that we just punched out.
>                   * In future FALLOC_FL_ZERO_RANGE could be used exclusively for
>                   * this, but it's currently only supported on XFS and ext4.
>                   *
>                   * The newly allocated range still won't be found by SEEK_DATA
>                   * for QAR, but stat.st_blocks will reflect it.
>                   */
>                  ret = SMB_VFS_FALLOCATE(fsp, VFS_FALLOCATE_FL_KEEP_SIZE,
>                                          zdata_info.file_off, len);
> 
> Note the "currently only supported on XFS and ext4" problem
> with FALLOC_FL_ZERO_RANGE.

FWIW, Samba's fsctl_zero_data semantics are based on observed Windows
server behaviour and the MS specs, which state(d at the time):
/*
 * 2.3.57 FSCTL_SET_ZERO_DATA Request
 *
 * How an implementation zeros data within a file is implementation-dependent.
 * A file system MAY choose to deallocate regions of disk space that have been
 * zeroed.<50>
 * <50>
 * ... NTFS might deallocate disk space in the file if the file is stored on an
 * NTFS volume, and the file is sparse or compressed. It will free any allocated
 * space in chunks of 64 kilobytes that begin at an offset that is a multiple of
 * 64 kilobytes. Other bytes in the file (prior to the first freed 64-kilobyte
 * chunk and after the last freed 64-kilobyte chunk) will be zeroed but not
 * deallocated.
 */

IIRC while implementing this I observed Windows deallocation behaviour
using FSCTL_QUERY_ALLOCATED_RANGES (referred to as QAR in the previous
code snippit).

Cheers, David
