From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: re-add NULL pointer check in cifs_save_resume_key
Date: Tue, 15 Nov 2011 08:05:30 -0500
Message-ID: <20111115080530.22d15e19@tlielax.poochiereds.net>
References: <1321356298-22132-1-git-send-email-jlayton@redhat.com>
	<20111115123243.GA11156@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115123243.GA11156-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Nov 2011 07:32:43 -0500
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Tue, Nov 15, 2011 at 06:24:58AM -0500, Jeff Layton wrote:
> > Prior to commit eaf35b1, cifs_save_resume_key had some NULL pointer
> > checks at the top. It turns out that at least one of those NULL
> > pointer checks is needed after all.
> > 
> > When the LastNameOffset in a FIND reply appears to be beyond the end of
> > the buffer, CIFSFindFirst and CIFSFindNext will set srch_inf.last_entry
> > to NULL. Since eaf35b1, the code will now oops in this situation.
> > 
> > This patch just readds the NULL pointer check for file_info in
> > cifs_save_resume_key to prevent the code from oopsing.
> 
> Ooops. sorry.  Can you move the checks into the callers instead, to
> make it more obvious what is going here, if needed including comments?
> 

No problem, it's really hard to tell which NULL pointer checks in the
cifs code are meaningful since it's littered with useless ones.

That's a good point about moving the check into the callers. I just
resent a respun patch that I think will do the right thing...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
