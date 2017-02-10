From: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Samba] cifs-utils: regression in (mulituser?) mounting 'CIFS
 VFS: Send error in SessSetup = -126'
Date: Fri, 10 Feb 2017 15:14:32 -0500
Message-ID: <1486757672.31734.25.camel@redhat.com>
References: <a13d9992-6be8-6f16-f4cb-98e83d2e140b@physics.wisc.edu>
         <mpsd1erijy1.fsf@aaptelpc.suse.de>
         <60de4c72-5278-04b3-5298-658fd11ad978@physics.wisc.edu>
         <106aff65-99f7-ede5-bc08-160b579abb9f@physics.wisc.edu>
         <1486746542.4233.14.camel@samba.org>
         <284d47c4-a3c7-a2c9-d7d1-e5444308922c@physics.wisc.edu>
         <1486748379.4233.16.camel@samba.org> <1486751411.4233.21.camel@samba.org>
         <1486754095.31734.20.camel@redhat.com> <1486754996.4233.23.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Nalin Dahyabhai <nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Simo Sorce <ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>,
        samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486754996.4233.23.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-02-10 at 14:29 -0500, Jeff Layton wrote:
> On Fri, 2017-02-10 at 14:14 -0500, Simo Sorce wrote:
> > On Fri, 2017-02-10 at 13:30 -0500, Jeff Layton wrote:
> > > On Fri, 2017-02-10 at 12:39 -0500, Jeff Layton wrote:
> > > > On Fri, 2017-02-10 at 11:15 -0600, Chad William Seys wrote:
> > > > > Hi Jeff,
> > > > > 
> > > > > > So we have a default credcache for the user for whom we are
> > > > > > operating
> > > > > > as, but we can't get the default principal name from it. My
> > > > > > guess is
> > > > > > that it's not finding the
> > > > > 
> > > > > This mount is run by root UID=0 and seems to be find that
> > > > > credential 
> > > > > cache without problem (earlier in the logs).  The problem
> > > > > seems
> > > > > to come 
> > > > > in when it tries to find the cache for user with UID=1494 .
> > > > > 
> > > > > I'm wondering if the scan of /tmp was helpful for finding
> > > > > caches
> > > > > of 
> > > > > non-same users.
> > > > > 
> > > > > (I'm a little surprised that there is any attempt to find
> > > > > credentials of 
> > > > > the non-root user at mount time - what happens if the non-
> > > > > root
> > > > > user 
> > > > > hasn't kinit-ed yet?  And yet that case worked in the
> > > > > past...)
> > > > > 
> > > > 
> > > > I'm more interested in what the trailing info in your credcache
> > > > name is.
> > > > In your log output for the working case, there are:
> > > > 
> > > > /tmp/krb5cc_0
> > > > /tmp/krb5cc_1494_sM11PG
> > > > 
> > > > So first one doesn't have that _XXXXXX trailing bit. Maybe
> > > > cifs.upcall
> > > > is not guessing that piece of the filename correctly?
> > > > 
> > > 
> > > (cc'ing Nalin, Simo and the linux-cifs ml)
> > > 
> > > Yeah, it seems pretty likely that that is the problem. My guess
> > > is
> > > that
> > > the extra stuff on the ccname is coming from pam_krb5, which
> > > seems to
> > > want to create a credcache that is session-specific.
> > > 
> > > You could play with setting a different ccname_template for
> > > pam_krb5
> > > that doesn't have the trailing stuff at the end, but it looks
> > > like it
> > > won't clean them up on logout if you do that. Caveat emptor.
> > > 
> > > I'm not sure what the right solution is there. For Simo and
> > > Nalin:
> > > 
> > > The upshot here is that we did a big clean up of the cifs-utils
> > > code
> > > recently, to get it out of the business of scanning /tmp for
> > > credcaches.
> > > That allows us to have better compatibility with other credcache
> > > types
> > > (keyring or whatever), and it was always rather nasty anyway.
> > > 
> > > pam_krb5 wants to make session-specific credcaches however, and
> > > cifs.upcall can't easily guess them. cifs.upcall is called from
> > > the
> > > kernel, so it can't look in the environment or anything to find
> > > the
> > > credcache.
> > > 
> > > What's the right approach to fix this? Are we stuck with scanning
> > > /tmp
> > > forever?
> > 
> > I think the right approach in the long run will be the KCM we are
> > building in SSSD and planning to make the default cache type for
> > F26.
> > 
> > For file ccaches you are out of luck, even scanning /tmp can fail
> > as
> > users can decide to put them elsewhere.
> > 
> > If a scan need to be made I would rather stat the files and look
> > which
> > one belong to the user that start with "/tmp/krb" rather than
> > trying to
> > guess the file name. Keep in mind predictable file names in /tmp
> > are
> > really not an option so pam_krb5 is doing the right thing in using
> > a
> > randomized file name given it runs as root.
> > 
> 
> Well, that's what we used to do -- do a readdir in /tmp, start
> looking for files that might be credcaches. Of course that meant we
> have to carry around a bunch of cruft for handling FILE: credcaches
> that doesn't really adapt well to DIR: or KEYRING: ones.
> 
> I guess I have a philosophical question: how is an application (like
> cifs.upcall), which is not descended from the user's session expected
> to find a user's credcache? Is that use-case just not really
> accounted for buy the krb5 libs?

Yeah it is not accounted for, it is assumed that applications are given
a ccache name by the caller or in KRB5CCNAME.
The fact the kernel operates this way was not on the radar in the
intial design.

> One thing we could do (though I really don't like it), is to take the
> pid value passed in the upcall and scrape that task's
> /proc/<pid>/environ file for KRB5CCNAME=. That really is pretty nasty
> though.

Yeah it is, and it is probably also not fully reliable, but it may be
the best way to go in the short term.

I think the only way will be the KCM, although it would be really nice
if the KCM could be given a session id of some kind, because it would
be nice to be able to have different ccaches in different sessions.
However for the general case and NFS/CIFS in particular I think KCM
will be the right way to go and will be sufficient to just talk to it
"as the user" (ie with a setuid like nfs utils does).

Simo.
