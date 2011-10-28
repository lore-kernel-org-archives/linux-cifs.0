From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Fri, 28 Oct 2011 09:58:34 -0400
Message-ID: <20111028095834.2a89660b@corrin.poochiereds.net>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
	<CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
	<20111027211515.GA1380@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111027211515.GA1380-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Oct 2011 17:15:15 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> I'm not complaining about Pavel - he has generally done outstanding
> work.
> 
> But patches posted the first time in that form two days ago (and the
> first time completely for a long time) are simply not suitable for
> this merge window.  I talked with Jeff about them very briefly at Kernel
> Summit and we will review them, and they will almost certainly need
> another respin or two.
> 
> Please learn the basic of kernel tree maintainance.

I agree. It's definitely premature to merge this series. The patches
themselves have never been posted to the list AFAICT, though Pavel has
on occasion posted a link to his git tree. That's not the same thing
however. As a general rule...

   "If it's not on the list, then it doesn't exist"

No one will do any comprehensive review of patches that have not been
sent to the list. I suggest you re-target the SMB2 series for 3.3 once
we've had an opportunity to review it.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
