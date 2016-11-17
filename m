From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 17 Nov 2016 15:41:44 +0530
Message-ID: <1479377504.8725.6.camel@redhat.com>
References: <20160922150918.GA127053@ubuntu-hedt>
         <1474557429.14139.10.camel@redhat.com>
         <20160922152756.GB127053@ubuntu-hedt> <20160923120145.GA51563@ubuntu-hedt>
         <20161117094725.GB2116@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117094725.GB2116-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-11-17 at 10:47 +0100, Greg Kroah-Hartman wrote:
> On Fri, Sep 23, 2016 at 07:01:45AM -0500, Seth Forshee wrote:
> > 
> > On Thu, Sep 22, 2016 at 10:27:56AM -0500, Seth Forshee wrote:
> > > 
> > > On Thu, Sep 22, 2016 at 04:17:09PM +0100, Sachin Prabhu wrote:
> > > > 
> > > > On Thu, 2016-09-22 at 10:09 -0500, Seth Forshee wrote:
> > > > > 
> > > > > We've received reports from users of a cifs mount regression
> > > > > in our
> > > > > 4.4-based kernel, e.g. [1]. It is fixed by reverting the
> > > > > follwing
> > > > > commit
> > > > > from 4.8 which was applied to 4.4 stable:
> > > > > 
> > > > >  a6b5058 fs/cifs: make share unaccessible at root level
> > > > > mountable
> > > > > 
> > > > > Testing against 4.8-rc7 shows that the problem is present
> > > > > there as
> > > > > well.
> > > > > 
> > > > > Thanks,
> > > > > Seth
> > > > > 
> > > > > [1] http://bugs.launchpad.net/bugs/1626112
> > > > 
> > > > Hello Seth, 
> > > > 
> > > > We have identified some regressions introduced by the mentioned
> > > > patch
> > > > These include
> > > 
> > > I saw those, but none of the ones already in Linus's tree fix the
> > > problem.
> > > 
> > > > 
> > > > a) mounting of DFS shares breaks. The fix is included in
> > > > Steve's tree
> > > > at
> > > > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=de5233
> > > > 745cd59c
> > > > f5853d963ad216067788a87594
> > > 
> > > However this one isn't in Linus's tree yet.
> > > 
> > > I'm not certain what circumstances cause the failure, but based
> > > on what
> > > I see in dmesg it looks likely that this one is the fix. I'll get
> > > some
> > > testing with this applied.
> > 
> > Looks like this is is the fix we need. Thanks for your help.
> 
> What ever happened with this?  Did the patch end up in Linus's
> tree?  If
> so, what 
> was the git commit id?
> 

Hello Greg,

The upstream commit is
Fix regression which breaks DFS mounting
d171356ff11ab1825e456dfb979755e01b3c54a1

This was marked for stable and should have been sent for inclusion in
the stable trees.

Thanks

Sachin Prabhu

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
