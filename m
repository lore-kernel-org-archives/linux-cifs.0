Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC264C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 12:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A972082F
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 12:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfKYMBl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:01:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:42312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfKYMBk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 07:01:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73716B16E;
        Mon, 25 Nov 2019 12:01:39 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>
Subject: Re: [PATCH 5/7] cifs: Fix potential deadlock when updating vol in
 cifs_reconnect()
In-Reply-To: <20191122153057.6608-6-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-6-pc@cjr.nz>
Date:   Mon, 25 Nov 2019 13:01:38 +0100
Message-ID: <87a78kw4f1.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:

> We can't hold the vol_lock spinlock while refreshing the DFS cache
> because cifs_reconnect() may call dfs_cache_update_vol() while we are
> walking through the volume list.
>
> Create a temp list with all volumes eligible for refreshing and then
> use it without any locks held.

Commit msg should mention it makes the vol_info refcounted.

> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/dfs_cache.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index b082603c793a..5b9d7281dd67 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -49,6 +49,8 @@ struct vol_info {
>  	struct smb_vol smb_vol;
>  	char *mntdata;
>  	struct list_head list;
> +	struct list_head rlist;
> +	int vol_count;
>  };
>  
>  static struct kmem_cache *cache_slab __read_mostly;
> @@ -516,13 +518,15 @@ static struct cache_entry *lookup_cache_entry(const char *path,
>  	return ce;
>  }
>  
> -static inline void free_vol(struct vol_info *vi)
> +static void put_vol(struct vol_info *vi)
>  {
> -	list_del(&vi->list);
> -	kfree(vi->fullpath);
> -	kfree(vi->mntdata);
> -	cifs_cleanup_volume_info_contents(&vi->smb_vol);
> -	kfree(vi);
> +	if (!--vi->vol_count) {
> +		list_del_init(&vi->list);
> +		kfree(vi->fullpath);
> +		kfree(vi->mntdata);
> +		cifs_cleanup_volume_info_contents(&vi->smb_vol);
> +		kfree(vi);
> +	}
>  }

Can we document that put_vol() assumes vol_lock is held?


-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
