From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 7/7] NFSD: Pass share reservations flags to VFS
Date: Mon, 11 Mar 2013 16:08:44 -0400
Message-ID: <20130311160844.7dedf15a@corrin.poochiereds.net>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-8-git-send-email-piastry@etersoft.ru>
	<20130311150540.119abd63@corrin.poochiereds.net>
	<20130311193638.GB642@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130311193638.GB642-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Mar 2013 15:36:38 -0400
"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:

> On Mon, Mar 11, 2013 at 03:05:40PM -0400, Jeff Layton wrote:
> > knfsd has some code already to handle share reservations internally.
> > Nothing outside of knfsd is aware of these reservations, of course so
> > moving to a vfs-level object for it would be a marked improvement.
> > 
> > It doesn't look like this patch removes any of that old code though. I
> > think it probably should, or there ought to be some consideration of
> > how this new stuff will mesh with it.
> > 
> > I think you have 2 choices here:
> > 
> > 1/ rip out the old share reservation code altogether and require that
> > filesystems mount with -o sharemand or whatever if they want to allow
> > their enforcement
> > 
> > 2/ make knfsd fall back to using the internal share reservation code
> > when the mount option isn't enabled
> > 
> > Personally, I think #1 would be fine, but Bruce may want to weigh in on
> > what he'd prefer.
> 
> #1 sounds good.  Clients that use deny bits are few.  My preference
> would be to return an error to such clients in the case share locks
> aren't available.
> 
> (We're a little out of spec there, so I'm not sure which error.  I think
> the goal is to notify a human there's a problem with minimal collateral
> damange.
> 
> NFS4ERR_SERVERFAULT ("I'm a buggy server, sorry about that!") would
> probably result in an IO error to the application.
> 
> SHARE_DENIED strikes me as unsafe: an application would be in its rights
> not to even check for that e.g. in the case of an exclusive create.
> 
> Maybe DELAY?  Kind of ridiculous, but blocking the application
> indefinitely would probably get someone's attention quickly enough
> without doing any damnage.)
> 

I agree that we should return an error, but hadn't considered what
error. Given that hardly any NFS clients use them, I'd probably just go
with NFS4ERR_SERVERFAULT, and maybe throw a printk or something on the
server about enabling share reservations for superblock x:y.

Pavel, as a side note, you may want to consider adding a patch to hook
this stuff up in the NFS client as well.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
