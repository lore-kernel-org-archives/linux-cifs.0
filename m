From: Dan Aloni <dan-HWkDggknmVpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH stable] cifs: empty TargetInfo leads to crash on recovery
Date: Sun, 28 Jan 2018 16:52:20 +0200
Message-ID: <20180128145220.GA47771@gmail.com>
References: <20180127200741.57298-1-dan@kernelim.com>
 <20180128144348.GA19937@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128144348.GA19937-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jan 28, 2018 at 03:43:48PM +0100, Greg KH wrote:
> On Sat, Jan 27, 2018 at 10:07:41PM +0200, Dan Aloni wrote:
> > commit cabfb3680f78 upstream.
> 
> Are you sure?
> $ gsr cabfb3680f78
> cabfb3680f78 ("CIFS: Enable encryption during session setup phase")
> 
> Doesn't seem to match up at all here :(

That's only because it fixed the issue unknownly, accordingly to
git-bisectings I've done. Should I have not added 'commit <githash>
upstream.' in that case? stable_kernel_rules.txt is not so clear
about it.

-- 
Dan Aloni
