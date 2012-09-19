From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cifs:for-next 50/71] fs/cifs/file.c:3157:23-27: ERROR: invalid
 reference to the index variable of the iterator on line 3149
Date: Wed, 19 Sep 2012 06:25:08 -0700
Message-ID: <20120919062508.70ba65eb@corrin.poochiereds.net>
References: <20120919050802.GA28801@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120919050802.GA28801@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Sep 2012 13:08:02 +0800
Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Hi Jeff,
> 
> FYI, there are new coccinelle warnings show up in
> 
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   324b53bbcd1d9795062f00e92064296169c9b081
> commit: a4a23914d0d1736eb6d98049d303d551131df83c [50/71] cifs: turn the pages list in cifs_readdata into an array
> 
> All coccinelle warnings:
> 
> + fs/cifs/file.c:3157:23-27: ERROR: invalid reference to the index variable of the iterator on line 3149
> 
> vim +3157 fs/cifs/file.c
>   3147			rdata->marshal_iov = cifs_readpages_marshal_iov;
>   3148	
> > 3149			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
>   3150				list_del(&page->lru);
>   3151				rdata->pages[rdata->nr_pages++] = page;
>   3152			}
>   3153	
>   3154			rc = cifs_retry_async_readv(rdata);
>   3155			if (rc != 0) {
>   3156				for (i = 0; i < rdata->nr_pages; i++) {
> > 3157					lru_cache_add_file(page);
>   3158					unlock_page(page);
>   3159					page_cache_release(page);
>   3160				}
>   3161				kref_put(&rdata->refcount, cifs_readdata_release);
>   3162				break;
>   3163			}
>   3164	
>   3165			kref_put(&rdata->refcount, cifs_readdata_release);
>   3166		}
>   3167	
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu, Yuanhan Liu                              Intel Corporation


Thanks Wu, good catch. I've got a fix that I'll push to Steve today.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
