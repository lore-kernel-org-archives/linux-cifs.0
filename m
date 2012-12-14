From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounting CIFS with root not accessible - permission denied
Date: Thu, 13 Dec 2012 21:54:23 -0500
Message-ID: <20121213215423.6ad89bc6@corrin.poochiereds.net>
References: <50CA5561.8090405@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Xu <alex_y_xu-FFYn/CNdgSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CA5561.8090405-FFYn/CNdgSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Dec 2012 17:23:29 -0500
Alex Xu <alex_y_xu-FFYn/CNdgSA@public.gmane.org> wrote:

> Basic explanation: Mounting a SMB share with CIFS fails saying in the
> kernel log that it can't traverse up to the root directory if the root
> directory is not accessible (in my case with NTFS ACLs), even if
> prefixpath is used.
> 
> Read a few earlier threads on this that said this was fixed, but it
> seems to still be a problem for me on 3.7.0-rc8+.
> 


Nope, not fixed. With current kernels, you need to be able to access
the entire path down from the root of the share. I'd be happy to help
review patches if someone does fix it however...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
