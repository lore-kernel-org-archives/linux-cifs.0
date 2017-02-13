From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC][cifs-utils PATCH] cifs.upcall: allow scraping of
 KRB5CCNAME out of initiating task's /proc/<pid>/environ file
Date: Mon, 13 Feb 2017 07:52:01 -0500
Message-ID: <1486990321.2739.4.camel@samba.org>
References: <20170211134149.8135-1-jlayton@samba.org>
         <1486826166.4233.36.camel@samba.org> <1486980171.31734.33.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org
To: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486980171.31734.33.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2017-02-13 at 05:02 -0500, Simo Sorce wrote:
> On Sat, 2017-02-11 at 10:16 -0500, Jeff Layton wrote:
> > On Sat, 2017-02-11 at 08:41 -0500, Jeff Layton wrote:
> > > Chad reported that he was seeing a regression in cifs-utils-6.6.
> > > Prior
> > > to that, cifs.upcall was able to find credcaches in non-default
> > > FILE:
> > > locations, but with the rework of that code, that ability was lost.
> > > 
> > > Unfortunately, the krb5 library design doesn't really take into
> > > account
> > > the fact that we might need to find a credcache in a process that
> > > isn't
> > > descended from the session.
> > > 
> > > When the kernel does an upcall, it passes several bits of info
> > > about the
> > > task that initiated the upcall. One of those things is the PID (the
> > > tgid, in particular). We can use that info to reach into the
> > > /proc/<pid>/environ file for the process, and grab whatever value
> > > of
> > > KRB5CCNAME is there.  This patch adds this ability to cifs.upcall.
> > > 
> > > I'm not 100% convinced that this is a good idea however, so for
> > > now,
> > > this is disabled unless the command line has a '-e' switch. Anyone
> > > wishing to play with this should edit their /etc/request-key.conf
> > > files
> > > accordingly.
> > > 
> > 
> > Meant to put a Reported-by: here for Chad. I'll do that before
> > merging.
> > 
> > > > > > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > > ---
> > >  cifs.upcall.8.in |  10 ++++
> > >  cifs.upcall.c    | 148
> > > ++++++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  2 files changed, 152 insertions(+), 6 deletions(-)
> > > 
> > 
> > FWIW, this patch works as expected in cursory, light testing. This
> > should be superior to the earlier method where we scanned in /tmp as
> > well -- more efficient, and also able to find non-FILE: credcaches,
> > as
> > well as ones that lie in other places besides /tmp.
> > 
> > My main concern is that we have to do the environ file scraping while
> > privileged, and that we end up trusting some info from a userland
> > process that triggered the upcall in KRB5CCNAME. Does this open any
> > potential attack vectors that I'm not considering?
> 
> Well you are operating as the user however I have not seen a setgid
> operation, does this mean cifs.upcall is running with group id 0 ?
> 
> This may give access to files the original user should not be able to
> access or cause files to be created with improper permission.
> 

Yeah, ick. The kernel doesn't send down the gid, so we can't just add
that in directly...

We could do a getpwuid(uid), and then setgid(pw_gid). That might be
problematic for applications that have done a setgid(), but those ought
to be very rare.

> Another thing people may need to pay attention to is SELinux context, I
> am not sure what selinux context cifs.upcall runs into the difference
> may matter in some cases, but in those I think proper SELinux policy
> should be devised, I see no need to change how cifs.upcall operates.
> 

Yeah, that's a different matter. It would be nice to confine
cifs.upcall, but we'd need an SELinux policy for that. Honestly, I'd
rather see us move to gssproxy before spending time on that.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
