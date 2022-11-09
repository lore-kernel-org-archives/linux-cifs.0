Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5368C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 18:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiKISiM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKISiL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 13:38:11 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A805F5B
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 10:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=/yIgJUKaHRITHQcdKsevWAjCd84QODiXTBt5cWXXEE0=; b=t45GWlRRBg7TS33Y4Z68+lJdsv
        5DfE8UgE3o6VY9gqWtvlbwjcFBZ8IHJnMtYEsfNBxlrEbjBD1YSCDj21Bz+iEZVetto56ciWKWRSC
        XLo9Ap2YH1dXqz/XEO0xSHW/UEHGRE9fg2KsvfV0HSJAtOH9gqhT/dI95mMJ+f2ZWEFcmaLIJwMku
        pwgUG+14RHH/64Ml1LqBQDQi3xE0xnyQb4AdhPsVh8g0suNsdg3CN2IY11/cW7Ui/VOKZAUQN7b0k
        dzqVQvsIPU4SK6+/SBVCarub7W0W70tFWYoo0AIkyXBlrLCBD/RhumhCh7ko4Yh8G66R2aUskjY0d
        Gd6xQlft2g0zVPHkGLxcwbPop0nGG8PbIX2j+59rCkOtOIq6vFVh69FPRh+PW0UtFcQrgKYfjMYc4
        IhCSj4Bj+MDWrCAkICweHgL+fLnIjKywWkVxOOoCIh97zvxgPy2CiDTe2D0dKiFCr6+z2gfPczqPp
        6Az+Vlps1CTdFVArtTuT+a3k;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ospxe-007t5W-AJ; Wed, 09 Nov 2022 18:38:06 +0000
Date:   Wed, 9 Nov 2022 10:38:02 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, Ralph Boehme <slow@samba.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2vzinRPFEBZyACg@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer>
 <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 09, 2022 at 11:32:30AM +0200, Amir Goldstein wrote:
>On Tue, Nov 8, 2022 at 7:53 PM Jeremy Allison via samba-technical
><samba-technical@lists.samba.org> wrote:
>>
>> On Mon, Nov 07, 2022 at 10:47:48PM -0800, Christoph Hellwig wrote:
>> >On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
>> >> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
>> >>
>> >> what ioctls are used for this in XFS ?
>> >>
>> >> We'd need a VFS module that implements them for XFS.
>> >
>> >That ioctl is now implemented in the Linux VFS and supported by btrfs,
>> >ocfs2, xfs, nfs (v4.2), cifs and overlayfs.
>>
>> I'm assuming it's this:
>>
>> https://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
>>
>> Yeah ? I'll write some test code and see if I can get it
>> into the vfs_default code.
>>
>
>Looks like this was already discussed during the work on generic
>implementation of FSCTL_SRV_COPYCHUNK:
>https://bugzilla.samba.org/show_bug.cgi?id=12033#c3
>
>Forgotten?

Yep :-).

>Left for later?

So looks like we do copy_file_range(), but not CLONE_RANGE,
or rather CLONE_RANGE only in btrfs.

So the code change needed is to move the logic in vfs_btrfs.c
into vfs_default.c, and change the call in vfs_btrfs.c:btrfs_offload_write_send()
to SMB_VFS_NEXT_OFFLOAD_WRITE_SEND() to call the old fallback code
inside vfs_default.c (vfswrap_offload_write_send()).

