From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 22 Sep 2016 10:27:56 -0500
Message-ID: <20160922152756.GB127053@ubuntu-hedt>
References: <20160922150918.GA127053@ubuntu-hedt>
 <1474557429.14139.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474557429.14139.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 22, 2016 at 04:17:09PM +0100, Sachin Prabhu wrote:
> On Thu, 2016-09-22 at 10:09 -0500, Seth Forshee wrote:
> > We've received reports from users of a cifs mount regression in our
> > 4.4-based kernel, e.g. [1]. It is fixed by reverting the follwing
> > commit
> > from 4.8 which was applied to 4.4 stable:
> > 
> >  a6b5058 fs/cifs: make share unaccessible at root level mountable
> > 
> > Testing against 4.8-rc7 shows that the problem is present there as
> > well.
> > 
> > Thanks,
> > Seth
> > 
> > [1] http://bugs.launchpad.net/bugs/1626112
> 
> Hello Seth, 
> 
> We have identified some regressions introduced by the mentioned patch
> These include

I saw those, but none of the ones already in Linus's tree fix the
problem.

> a) mounting of DFS shares breaks. The fix is included in Steve's tree
> at
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=de5233745cd59c
> f5853d963ad216067788a87594

However this one isn't in Linus's tree yet.

I'm not certain what circumstances cause the failure, but based on what
I see in dmesg it looks likely that this one is the fix. I'll get some
testing with this applied.

Since the broken patch was applied to stable kernels, all of these
kernels need to receive those fixes as well.

Thanks,
Seth
