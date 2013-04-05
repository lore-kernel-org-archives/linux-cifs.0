From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 1/4] dcache: Don't take unnecessary lock in d_count
 update
Date: Fri, 5 Apr 2013 18:12:20 +0100
Message-ID: <20130405171220.GD4068@ZenIV.linux.org.uk>
References: <1365181061-30787-1-git-send-email-Waiman.Long@hp.com>
 <1365181061-30787-2-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>,
	Miklos Szeredi <mszeredi@suse.cz>, Ian Kent <raven@themaw.net>,
	Sage Weil <sage@inktank.com>, Steve French <sfrench@samba.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nfs@vger.kernel.org,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	"Norton, Scott J" <scott.norton@hp.com>,
	Andi Kleen <andi@firstfloor.org>,
	Dave Chinner <david@fromorbit.com>
To: Waiman Long <Waiman.Long@hp.com>
Return-path: <autofs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1365181061-30787-2-git-send-email-Waiman.Long@hp.com>
Sender: autofs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> @@ -635,22 +640,14 @@ struct dentry *dget_parent(struct dentry *dentry)
>  {
>  	struct dentry *ret;
>  
> -repeat:
> -	/*
> -	 * Don't need rcu_dereference because we re-check it was correct under
> -	 * the lock.
> -	 */
>  	rcu_read_lock();
> -	ret = dentry->d_parent;
> -	spin_lock(&ret->d_lock);
> -	if (unlikely(ret != dentry->d_parent)) {
> -		spin_unlock(&ret->d_lock);
> -		rcu_read_unlock();
> -		goto repeat;
> -	}
> +	ret = rcu_dereference(dentry->d_parent);
>  	rcu_read_unlock();
> +	if (dcount_inc_cmpxchg(ret))
> +		return ret;
> +	spin_lock(&ret->d_lock);

And WTF is going to protect your "ret" from being freed just as you'd done
rcu_read_unlock()?
