From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: proper fix for integer overflow in parse_dacl()
Date: Wed, 3 Oct 2012 15:43:39 +0300
Message-ID: <20121003124339.GA4671@elgon.mountain>
References: <20120927204908.GA13222@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120927204908.GA13222-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 27, 2012 at 11:49:08PM +0300, Dan Carpenter wrote:
> I tried to fix this before by adding the ULONG_MAX check, but num_aces
> is an unsigned int so it should have been UINT_MAX.  Sorry for that.
> These days we can just call kmalloc_array() which has the overflow check
> built in.
> 

Uh...  It turns out that I still suck at understanding C.  My first
patch was fine.  Sorry for the noise.

regards,
dan carpenter
