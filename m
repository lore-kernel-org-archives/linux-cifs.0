From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 3/8] vfs: Add O_DENYREAD/WRITE flags support for open
 syscall
Date: Thu, 7 Feb 2013 09:41:56 -0500
Message-ID: <20130207144156.GB3222@fieldses.org>
References: <1358441584-8783-1-git-send-email-piastry@etersoft.ru>
 <1358441584-8783-3-git-send-email-piastry@etersoft.ru>
 <20130130221602.GC15584@fieldses.org>
 <CAKywueRh++TBazK8_kRN7AUb=EFhGv=Sv2CV0BESkfLFy+g5wA@mail.gmail.com>
 <20130205143514.GA9886@fieldses.org>
 <CAKywueS6oGNu9r_bypu32A89pOoiGb47kjXqw2ZcZQhZK+JV3g@mail.gmail.com>
 <20130207141832.GA3222@fieldses.org>
 <CAKywueTmU_L5cwwJSoUY6753eHf_38VtHadZGt9tcLS59sqmOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueTmU_L5cwwJSoUY6753eHf_38VtHadZGt9tcLS59sqmOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 07, 2013 at 06:32:38PM +0400, Pavel Shilovsky wrote:
> 2013/2/7 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> > On Thu, Feb 07, 2013 at 01:53:46PM +0400, Pavel Shilovsky wrote:
> >> Nothing prevents it. If somebody grabbed a share mode lock on a file
> >> before we call deny_lock_file, we simply close this file and return
> >> -ETXTBSY.
> >
> > But leave the newly-created file there--ugh.
> >
> >> We can't grab it before atomic_open because we don't have an
> >> inode there.
> >
> > If you can get the lock while still holding the directory i_mutex can't
> > you prevent anyone else from looking up the new file until you've gotten
> > the lock?
> >
> 
> Hm..., seems you are right, I missed this part:
> mutex_lock
> lookup_open -> atomic_open -> deny_lock_file
> mutex_unlock
> 
> that means that nobody can open and of course set flock on the newly
> created file (because flock is done through file descriptor). So, it
> should be fine to call flock after f_ops->atomic_open in atomic_open
> function. Thanks.

Whether that works may also depend on how the new dentry is set up?  If
it's hashed before you call flock then I suppose it's already visible to
others.

Not knowing that code as well as I should, I might test by introducing
an artificial delay there and trying to reproduce the race.

--b.
