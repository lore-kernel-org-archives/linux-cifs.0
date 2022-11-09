Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D22EC433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 19:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiKITYf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKITYe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 14:24:34 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A953224BCA
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 11:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=XBs3bjUZiNYkifCXFD1RVOznIoSyZrp4MHUED3s7f6c=; b=wL4t3w/cMnksA4rvNFobUrCm9T
        vZA7qWFbP32KJb4zY2IGTnNFjNj1BwmryCml0gnU/MufK4FCYW/LHM9hPvxNicen3yrUkZitx45cn
        Jt7GdIKlalYNSnr9hjBUYtK7d1SLOFrvCE9zIRuSc5yer3pDrtDQj3YgsBPZLbQL06vYq0rbtkuqb
        CMg6rNK0Z9XABhATtZ9jnlHC60gtuF82MJgKDtAz8BnHTsykA6i4xxz+y1sXL32O49+RIO3F0o1EK
        Gr5cSa0g2mZWksUx5XUAnaxkT5Gn6C4iWu024uzLcnofeD39cKajCiWfTv8zgRmZyCBq40uZ473Nn
        23g9/XIt+n1aUp70h9qZLplH0mnHKFgHMlq2lqN++MW0ExXSYTgRgk4yR9qJHWueTkXINyvZQtHc5
        8XBZE5TjiIr4vwN/drueVYrnhURim9CCeZgp3SCcuzsDHJapuaUV/5FINwOd0OAbqJa0Bk0DhkIce
        94kDHxg7YSvEH6Z0RrywqbiP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1osqgY-007tOE-BT; Wed, 09 Nov 2022 19:24:30 +0000
Date:   Wed, 9 Nov 2022 11:24:26 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, slow@samba.org, vl@samba.org,
        metze@samba.org
Cc:     slow@samba.org, vl@samba.org, metze@samba.org
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2v+au3rvWOUOr1t@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
 <Y2qXLNM5xvxZHuLQ@jeremy-acer>
 <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
 <Y2vzinRPFEBZyACg@jeremy-acer>
 <Y2v1zQbnPoqg+0aj@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y2v1zQbnPoqg+0aj@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 09, 2022 at 10:47:41AM -0800, Jeremy Allison wrote:
>
>So it *looks* like the copy_file_range() syscall will internally
>call the equivalent of FICLONERANGE if the underlying file
>system supports it.
>
>So maybe the right fix is to remove the FICLONERANGE specific
>code from our vfs_btrfs.c and just always use copy_file_range().
>
>Any comments from other Samba Team members ?

So right now Steve what is preventing FSCTL_DUP_EXTENTS_TO_FILE
=66rom working against anything other then btrfs on Samba is the
following code:

source3/smbd/smb2_ioctl_filesys.c:fsctl_dup_extents_send()

180         if ((dst_fsp->conn->fs_capabilities
181                                 & FILE_SUPPORTS_BLOCK_REFCOUNTING) =3D=
=3D 0) {
182                 DBG_INFO("FS does not advertise block refcounting suppo=
rt\n");
183                 tevent_req_nterror(req, NT_STATUS_INVALID_DEVICE_REQUES=
T);
184                 return tevent_req_post(req, ev);
185         }

because currently only the vfs_btrfs module reports FILE_SUPPORTS_BLOCK_REF=
COUNTING,
not vfs_default.

and also in:

source3/modules/vfs_default.c:vfswrap_offload_write_send()

2194         case FSCTL_DUP_EXTENTS_TO_FILE:
2195                 DBG_DEBUG("COW clones not supported by vfs_default\n");
2196                 tevent_req_nterror(req, NT_STATUS_INVALID_PARAMETER);
2197                 return tevent_req_post(req, ev);

but looking at vfs_btrfs it looks like that code should
probably also be in vfswrap_offload_read_send() as well
and the error code should be NT_STATUS_INVALID_DEVICE_REQUEST.

We also need to duplicate the logic in vfs_btrfs for
handling FSCTL_DUP_EXTENTS_TO_FILE into VFS default,
gated on support for the copy_file_range() system
call (which would set FILE_SUPPORTS_BLOCK_REFCOUNTING
in the fs_capabilities return from vfs_default).

I think this is doable with some work...
