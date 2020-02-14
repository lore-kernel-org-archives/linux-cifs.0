Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBA0C2BA83
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 12:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928822168B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 12:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581683209;
	bh=PidKQNyrM3sHIFiFwwnXoclRaogibGnkeYPE3RMWjPY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=Vc0K4gcGg9Ib+DWM7VwMSoD5NgvvI7p+/6MT5WXfehB41OrGY4uwb1ycSuCPKklXT
	 3q6U1DGxOvqq3hqeOAHt6lLoNfqkVIXUsyZ/w0KF64NnKTZsJzQu3Ek1gJlc53AwLr
	 cYyTHrIj+z8Utd1rcMtwOjf1txSUeI+UI7pzkhdQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgBNM0t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 07:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgBNM0t (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Feb 2020 07:26:49 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F26242168B;
        Fri, 14 Feb 2020 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581683208;
        bh=PidKQNyrM3sHIFiFwwnXoclRaogibGnkeYPE3RMWjPY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e31p5DS9Ojgy/qeD3tr93Rop9ic4vFpb/KFyvX3itiTn3Vqkv+xOG4llaGRsvz/en
         uvh5NZyy9PWs0tCGyRrpQ0IYJTnf6zGiiMpC6t8n+D9nzX+SHYClm56SJowSqXkDCG
         Gtq4Ihg3WsfbI60wDzmWA1qogXoczNFgrtmOuN00=
Message-ID: <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
Subject: Re: [PATCH] CIFS: unlock file across process
From:   Jeff Layton <jlayton@kernel.org>
To:     Murphy Zhou <jencce.kernel@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>
Date:   Fri, 14 Feb 2020 07:26:46 -0500
In-Reply-To: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 2020-02-14 at 12:35 +0800, Murphy Zhou wrote:
> Now child can't unlock the same file that has been locked by
> parent. Fix this by not skipping unlock if requesting from
> different process.
> 
> Patch tested by LTP and xfstests using samba server.
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2file.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index afe1f03aabe3..b5bca0e13d51 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -151,8 +151,6 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>  		    (flock->fl_start + length) <
>  		    (li->offset + li->length))
>  			continue;
> -		if (current->tgid != li->pid)
> -			continue;
>  		if (cinode->can_cache_brlcks) {
>  			/*
>  			 * We can cache brlock requests - simply remove a lock

I'm not as familiar with this code as I once was, but...

From fork(2) manpage:

       *  The  child does not inherit process-associated record locks from its
          parent (fcntl(2)).  (On the other hand,  it  does  inherit  fcntl(2)
          open file description locks and flock(2) locks from its parent.)

It looks like cifs_setlk calls mand_unlock_range, and that gets called
from both fcntl and flock codepaths.

So, I'm not sure about just removing this. It seems like the pid check
is probably correct for traditional posix locks, but probably not for
OFD and flock locks? What ensures that completely unrelated tasks can't
unlock your locks?
-- 
Jeff Layton <jlayton@kernel.org>

