From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: re-add NULL pointer check in cifs_save_resume_key
Date: Tue, 15 Nov 2011 07:32:43 -0500
Message-ID: <20111115123243.GA11156@infradead.org>
References: <1321356298-22132-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1321356298-22132-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 15, 2011 at 06:24:58AM -0500, Jeff Layton wrote:
> Prior to commit eaf35b1, cifs_save_resume_key had some NULL pointer
> checks at the top. It turns out that at least one of those NULL
> pointer checks is needed after all.
> 
> When the LastNameOffset in a FIND reply appears to be beyond the end of
> the buffer, CIFSFindFirst and CIFSFindNext will set srch_inf.last_entry
> to NULL. Since eaf35b1, the code will now oops in this situation.
> 
> This patch just readds the NULL pointer check for file_info in
> cifs_save_resume_key to prevent the code from oopsing.

Ooops. sorry.  Can you move the checks into the callers instead, to
make it more obvious what is going here, if needed including comments?
