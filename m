From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 3/4] sunrpc: make rpc_wait_bit_killable handle freeze
 events
Date: Tue, 11 Oct 2011 08:19:23 +0200
Message-ID: <20111011061923.GC1377@ucw.cz>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
 <1317210761-11518-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org,
	linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-D0fwSNaahy58zQARNC3f2A@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1317210761-11518-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Wed 2011-09-28 07:52:40, Jeff Layton wrote:
> Allow the wait_on_bit_killable sleeps in SUNRPC layer to respect the
> freezer. This should allow suspend and hibernate events to occur, even
> when there are RPC's pending on the wire.

Will the RPC protocols used handle that correctly? What will happen
during resume?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
