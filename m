From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Tue, 9 Aug 2011 07:38:00 +0100
Message-ID: <20110809063800.GE2203@ZenIV.linux.org.uk>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
 <CAKywueRT9cGPu5pCiiYONd7DruBaE2TDvHVVyyELYwM_Ft5e+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueRT9cGPu5pCiiYONd7DruBaE2TDvHVVyyELYwM_Ft5e+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 09, 2011 at 09:41:33AM +0400, Pavel Shilovsky wrote:
> > ? ? ? ? ? ? ? ?mutex_unlock(&dir->i_mutex);
> > ? ? ? ? ? ? ? ?dput(dentry);
> > ? ? ? ? ? ? ? ?dentry = child;
> > + ? ? ? ? ? ? ? if (!dentry->d_inode) {
> 
> dentry can be NULL here (returned from lookup_one_len) and it can
> cause a null pointer dereference.

Not NULL, ERR_PTR(...).  IOW, we need to check IS_ERR(dentry) to protect
that check of dentry->d_inode.
