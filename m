From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: New read cache mechanism
Date: Sat, 18 Sep 2010 11:51:29 -0400
Message-ID: <20100918155129.GA21337@infradead.org>
References: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> +	struct cifsInodeInfo *cinode;
> +
> +	if (filp && filp->f_path.dentry && filp->f_path.dentry->d_inode)
> +		cinode = CIFS_I(filp->f_path.dentry->d_inode);
> +	else
> +		return -ENOENT;

Totally pointless check.  Could you guys please stop putting in all
these utterly pointless cargo cult checks in cifs?

> +
> +	if (cinode->clientCanCacheRead)
> +		read = do_sync_read(filp, buf, len, ppos);
> +	else
> +		read = cifs_user_read(filp, buf, len, ppos);
> +
> +	return read;

And how do you enforce your caching semantics for aio or vectored reads?
