From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 00/10] locks/nfsd: internal lease API overhaul
Date: Tue, 26 Aug 2014 06:59:20 -0700
Message-ID: <20140826135920.GB18599@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <20140824161046.GI15908@infradead.org>
 <20140824214301.61019123@synchrony.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140824214301.61019123-08S845evdOaAjSkqwZiSMmfYqLom42DlXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 24, 2014 at 09:43:01PM -0400, Jeff Layton wrote:
> >  - add a return value to lm_break so that the lock manager can tell the
> >    core code "you can delete this lease right now".  That gets rid of
> >    the games with the timeout which require all kinds of race avoidance
> >    code in the users.
> > 
> 
> I'm not sure I understand what you're suggesting here. Isn't it just as
> simple to have lm_break call lease_modify to just remove the lease?

Unfortunately it's not.  lm_break gets a pointer to the file_lock,
and lease_modify needs a pointer to the list position of the file_lock.
