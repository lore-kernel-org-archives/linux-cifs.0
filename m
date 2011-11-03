From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] wait_event_freezekillable: use
 freezer_do_not_count/freezer_count
Date: Thu, 3 Nov 2011 07:13:54 -0700
Message-ID: <20111103141354.GB4417@google.com>
References: <20111101163059.GR18855@google.com>
 <20111101175953.GB5358@redhat.com>
 <20111101180601.GV18855@google.com>
 <20111101181329.GA6739@redhat.com>
 <20111101182753.GW18855@google.com>
 <20111101193923.GA9444@redhat.com>
 <20111101194601.GB9444@redhat.com>
 <20111101215710.GA13803@google.com>
 <20111102175327.GA4446@redhat.com>
 <20111103064215.48939e1a@tlielax.poochiereds.net>
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
In-Reply-To: <20111103064215.48939e1a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On Thu, Nov 03, 2011 at 06:42:15AM -0400, Jeff Layton wrote:
> I'm not sure we really need this macro anymore since this is much
> simpler. I could just move cifs back to using wait_event_killable and
> simply wrap it in freezer_do_not_count/freezer_count (with some
> comments to explain why we're doing that).
> 
> In any event, I plan to test this scheme out today and will let you
> know whether it works...

I think it would be better to put this in a macro as the
implementation is likely to change in future and I really don't want
to see FREEZER_SKIP scattered around the tree.

Thank you.

-- 
tejun
