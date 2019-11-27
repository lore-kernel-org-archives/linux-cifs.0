Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F69C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 12:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B119C2068E
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 12:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK0MJH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 07:09:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:48040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbfK0MJH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Nov 2019 07:09:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93743AC44;
        Wed, 27 Nov 2019 12:09:05 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>
Subject: Re: [PATCH v3 08/11] cifs: Fix potential deadlock when updating vol
 in cifs_reconnect()
In-Reply-To: <20191127003634.14072-9-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
 <20191127003634.14072-9-pc@cjr.nz>
Date:   Wed, 27 Nov 2019 13:09:04 +0100
Message-ID: <871rttv7vj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> We can't acquire vol_lock while refreshing the DFS cache because
> cifs_reconnect() may call dfs_cache_update_vol() while we are walking
> through the volume list.
>
> To prevent that, make vol_info refcounted, create a temp list with all
> volumes eligible for refreshing, and then use it without any locks
> held.
>
> Also turn vol_lock into a spinlock rather than a mutex.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/dfs_cache.c | 104 +++++++++++++++++++++++++++++---------------
>  1 file changed, 69 insertions(+), 35 deletions(-)
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 1d1f7c03931b..629190926197 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -52,12 +52,14 @@ struct vol_info {
>  	struct smb_vol smb_vol;
>  	char *mntdata;
>  	struct list_head list;
> +	struct list_head rlist;
> +	int vol_count;
>  };

If vol_count is going to be accessed/modified from multiple threads
without locks there might be races. I think you should use kref

https://www.kernel.org/doc/Documentation/kref.txt

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
