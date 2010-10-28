From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/2] cifs: dereferencing first then checking
Date: Thu, 28 Oct 2010 05:44:34 +0200
Message-ID: <20101028034434.GR6062@bicker>
References: <20101027212253.GL6062@bicker> <20101027195123.0a712a53@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101027195123.0a712a53-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 27, 2010 at 07:51:23PM -0400, Jeff Layton wrote:
> 
> The above delta shouldn't be needed once the patches in Steve's tree
> are pushed to Linus. I think what we should probably do is wait for
> Steve to push to Linus and then do a patch to remove the first two
> checks.
> 
> Sound like a plan?
> 

Sounds like a plan.

regards,
dan carpenter

> -- 
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
