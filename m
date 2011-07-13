From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [stable] [PATCH] cifs: fix wsize negotiation for 2.6.39 stable
Date: Wed, 13 Jul 2011 04:26:19 +0200
Message-ID: <20110713022619.GA11043@kroah.com>
References: <1310520281-17467-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, helge.hafting-CND4fxrytsY@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1310520281-17467-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 12, 2011 at 09:24:41PM -0400, Jeff Layton wrote:
> I sent this a week or so ago, but it apparently missed the recent
> 2.6.39.y release. Resending to make sure it gets into the next one.
> 
> Prior to 2.6.39, when signing was enabled on a socket the client only
> sent single-page writes. This changed with commit ca83ce3d5b, which
> made signed and unsigned connections use the same codepaths for write
> calls.
> 
> This caused a regression when working with windows servers. Windows
> machines will reject writes larger than the MaxBufferSize when signing
> is active, but does not clear the CAP_LARGE_WRITE_X flag in the
> negotiation.
> 
> This patch backports 2 patches that fix this problem in 3.0 kernels,
> and changes a couple of the constants to values appropriate for the
> writeback code in 2.6.39.

Why not just tell me the 2 patches in upstream that need to be
backported as Documentation/stable_kernel_rules.txt say to do instead?

thanks,

greg k-h
