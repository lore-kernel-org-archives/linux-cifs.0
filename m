From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: panic at umount in fscache code
Date: Fri, 23 Jul 2010 11:29:00 -0400
Message-ID: <20100723112900.2960b742@tlielax.poochiereds.net>
References: <20100723095229.2c5bd562@tlielax.poochiereds.net>
	<4C49B48D.9040302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C49B48D.9040302-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Jul 2010 20:56:05 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 07/23/2010 07:22 PM, Jeff Layton wrote:
> > I built a kernel based on Steve's tree, enabled the fscache option and
> > got the following panic at umount. I didn't mount with -o fsc or
> > anything. I have some other patches on top of Steve's tree, but I'm
> > fairly certain they wouldn't affect this.
> > 
> > For the record, here's the fstab entry (with anonymized names):
> > 
> > //server.example.com/scratch	/mnt/anonymous		cifs	sec=none,user,noperm,noauto 0 0
> > 
> > Disabling the fscache stuff at build time makes the problem go away.
> > 
> > ------------------------------[snip]------------------------------
> > 
> > general protection fault: 0000 [#1] SMP 
> > last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> 
> Could you please check whether the below patch fixes the problem?
> 
> Thanks,
> 
> 
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH] cifs: relinquish fscache cookie before freeing CIFSTconInfo
> 
> Doh, fix a use after free bug. 
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 399b601..5480025 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1842,8 +1842,8 @@ cifs_put_tcon(struct cifsTconInfo *tcon)
>  	CIFSSMBTDis(xid, tcon);
>  	_FreeXid(xid);
>  
> -	tconInfoFree(tcon);
>  	cifs_fscache_release_super_cookie(tcon);
> +	tconInfoFree(tcon);
>  	cifs_put_smb_ses(ses);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Yes. That seems to fix it and looks obviously correct.

Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
