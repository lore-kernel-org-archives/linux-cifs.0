From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Stable-review] [26/34] CIFS: Fix compile error with __init in
 cifs_init_dns_resolver() definition
Date: Fri, 6 Aug 2010 14:06:19 -0700
Message-ID: <20100806210619.GA5863@suse.de>
References: <20100806185836.185076461@clark.site>
 <1281127997.7543.0.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, stable-review-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1281127997.7543.0.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 06, 2010 at 09:53:17PM +0100, Ben Hutchings wrote:
> On Fri, 2010-08-06 at 11:57 -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> >  [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
> > 
> > From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
> > 
> > An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> > 
> > fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'
> > 
> > This adds the correct header file to fix this.
> [...]
> 
> Why <linux/module.h> and not <linux/init.h>?

Heh, it works :)

Michael?

thanks,

greg k-h
