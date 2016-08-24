From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-utils PATCH 0/3] cifs-utils: overhaul of cifs.upcall krb5
 handling
Date: Wed, 24 Aug 2016 07:06:58 -0400
Message-ID: <1472036818.13763.5.camel@samba.org>
References: <1471868962-7312-1-git-send-email-jlayton@samba.org>
         <9A891926-AE7D-4916-AB71-A49D4A1588BC@fhcrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9A891926-AE7D-4916-AB71-A49D4A1588BC-q9hIisBwmLrYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-08-23 at 19:21 +0000, Dey, John F wrote:
> I have a newer version of the cifs-upcall patch which follows the
> linux coding standards.  I have taken a look at the use of
> krb5_context through out all the code and reduced the usage of
> krb5_context to one call.
>  
> 
> John Dey
> 
> 
> 

Ok. With this set, those patches may no longer be needed. You may want
to try building cifs-utils with them and see whether it fixes the
problem you were having.

The idea here is to get cifs-utils out of the business of looking for a
credcache in likely places at all, and to instead rely on the krb5 libs
to tell us where it thinks the credcache will be. That should make
cifs.upcall a lot more efficient, and better able to work with non
FILE: credcaches.

> 
> 
> 
> On 8/22/16, 5:29 AM, "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > 
> > The handling of krb5 in cifs.upcall has always been pretty klunky.
> > It
> > rolls through /tmp, trying to find the latest credcache and has
> > some
> > hacks to allow it to use DIR: caches as well, but none of that
> > really
> > works for KEYRING:, which is pretty common these days.
> > 
> > In practice, I doubt anyone relies on that behavior. What most
> > people
> > want is for cifs.upcall to find the default credcache for a user
> > given
> > krb5.conf -- full stop.
> > 
> > This patchset rips out most of the unneeded machinery in
> > cifs.upcall,
> > and just has it find the default credcache and verify that it has a
> > valid TGT. If not then we'll try to init it from the keytab as
> > before.
> > 
> > I think there's some more opportunity to clean up this code in the
> > future as well. Currently we pass around strings that represent the
> > credcache, and that could be made more efficient.  It might also be
> > good to just reimplement the whole thing with gssapi calls instead.
> > 
> > Still, this is a good step in that direction I think.
> > 
> > Jeff Layton (3):
> >  aclocal: fix typo in idmap.m4
> >  cifs.upcall: use krb5 routines to get default ccname
> >  cifs.upcall: make the krb5_context a static global variable
> > 
> > aclocal/idmap.m4 |   2 +-
> > cifs.upcall.c    | 185 ++++++++++--------------------------------
> > -------------
> > 2 files changed, 32 insertions(+), 155 deletions(-)
> > 
> > -- 
> > 2.7.4
> > 
> NrybXǧv^)޺{.n+{r'{ay
ʇڙ,jfhz
w
j:+vwjmzZ+ݢj"!
