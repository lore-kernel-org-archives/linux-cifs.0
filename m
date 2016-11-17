From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 17 Nov 2016 11:31:00 +0100
Message-ID: <20161117103100.GA3043@kroah.com>
References: <20160922150918.GA127053@ubuntu-hedt>
 <1474557429.14139.10.camel@redhat.com>
 <20160922152756.GB127053@ubuntu-hedt>
 <20160923120145.GA51563@ubuntu-hedt>
 <20161117094725.GB2116@kroah.com>
 <1479377504.8725.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Steve French <sfrench@samba.org>,
        Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To: Sachin Prabhu <sprabhu@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479377504.8725.6.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Nov 17, 2016 at 03:41:44PM +0530, Sachin Prabhu wrote:
> On Thu, 2016-11-17 at 10:47 +0100, Greg Kroah-Hartman wrote:
> > On Fri, Sep 23, 2016 at 07:01:45AM -0500, Seth Forshee wrote:
> > > 
> > > On Thu, Sep 22, 2016 at 10:27:56AM -0500, Seth Forshee wrote:
> > > > 
> > > > On Thu, Sep 22, 2016 at 04:17:09PM +0100, Sachin Prabhu wrote:
> > > > > 
> > > > > On Thu, 2016-09-22 at 10:09 -0500, Seth Forshee wrote:
> > > > > > 
> > > > > > We've received reports from users of a cifs mount regression
> > > > > > in our
> > > > > > 4.4-based kernel, e.g. [1]. It is fixed by reverting the
> > > > > > follwing
> > > > > > commit
> > > > > > from 4.8 which was applied to 4.4 stable:
> > > > > > 
> > > > > >  a6b5058 fs/cifs: make share unaccessible at root level
> > > > > > mountable
> > > > > > 
> > > > > > Testing against 4.8-rc7 shows that the problem is present
> > > > > > there as
> > > > > > well.
> > > > > > 
> > > > > > Thanks,
> > > > > > Seth
> > > > > > 
> > > > > > [1] http://bugs.launchpad.net/bugs/1626112
> > > > > 
> > > > > Hello Seth, 
> > > > > 
> > > > > We have identified some regressions introduced by the mentioned
> > > > > patch
> > > > > These include
> > > > 
> > > > I saw those, but none of the ones already in Linus's tree fix the
> > > > problem.
> > > > 
> > > > > 
> > > > > a) mounting of DFS shares breaks. The fix is included in
> > > > > Steve's tree
> > > > > at
> > > > > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=de5233
> > > > > 745cd59c
> > > > > f5853d963ad216067788a87594
> > > > 
> > > > However this one isn't in Linus's tree yet.
> > > > 
> > > > I'm not certain what circumstances cause the failure, but based
> > > > on what
> > > > I see in dmesg it looks likely that this one is the fix. I'll get
> > > > some
> > > > testing with this applied.
> > > 
> > > Looks like this is is the fix we need. Thanks for your help.
> > 
> > What ever happened with this?  Did the patch end up in Linus's
> > tree?  If
> > so, what 
> > was the git commit id?
> > 
> 
> Hello Greg,
> 
> The upstream commit is
> Fix regression which breaks DFS mounting
> d171356ff11ab1825e456dfb979755e01b3c54a1
> 
> This was marked for stable and should have been sent for inclusion in
> the stable trees.

Ah, good, thanks for this, yes, it's already in the released kernels.

greg k-h
