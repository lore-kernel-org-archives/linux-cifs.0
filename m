From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 22 Sep 2016 17:15:47 +0200
Message-ID: <20160922151547.GA3565@kroah.com>
References: <20160922150918.GA127053@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160922150918.GA127053@ubuntu-hedt>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:09:18AM -0500, Seth Forshee wrote:
> We've received reports from users of a cifs mount regression in our
> 4.4-based kernel, e.g. [1]. It is fixed by reverting the follwing commit
> from 4.8 which was applied to 4.4 stable:
> 
>  a6b5058 fs/cifs: make share unaccessible at root level mountable
> 
> Testing against 4.8-rc7 shows that the problem is present there as well.
> 
> Thanks,
> Seth
> 
> [1] http://bugs.launchpad.net/bugs/1626112

Thanks, I'll wait for the fix to land in Linus's tree before doing
anything in the stable trees.

greg k-h
