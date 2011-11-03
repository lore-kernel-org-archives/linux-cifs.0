From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] wait_event_freezekillable: use
 freezer_do_not_count/freezer_count
Date: Thu, 3 Nov 2011 08:30:27 -0700
Message-ID: <20111103153027.GE4417@google.com>
References: <20111101180601.GV18855@google.com>
 <20111101181329.GA6739@redhat.com>
 <20111101182753.GW18855@google.com>
 <20111101193923.GA9444@redhat.com>
 <20111101194601.GB9444@redhat.com>
 <20111101215710.GA13803@google.com>
 <20111102175327.GA4446@redhat.com>
 <20111103064215.48939e1a@tlielax.poochiereds.net>
 <20111103141354.GB4417@google.com>
 <20111103112704.4b905bfc@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111103112704.4b905bfc-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On Thu, Nov 03, 2011 at 11:27:04AM -0400, Jeff Layton wrote:
> Ok, note though that I also need to do a similar set of changes to the
> nfs and sunrpc code [1].
> 
> Those call sites do not use wait_event_* macros though. So I'll either
> need to add a separate set of functions/macros to handle those, or
> sprinkle freezer_do_not_count/freezer_count around the code there...

Yes, I still think it would be better to isolate implementation
details from users.  I really hate to see the 'count' functions
scattered around the kernel.

Thank you.

-- 
tejun
