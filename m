From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH RFC] cifs-utils: new plugin architecture for ID mapping
 code
Date: Thu, 6 Dec 2012 09:58:46 -0500
Message-ID: <20121206095846.52d59286@corrin.poochiereds.net>
References: <1354797458-5170-1-git-send-email-jlayton@samba.org>
	<1354801351.14719.18.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354801351.14719.18.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 06 Dec 2012 08:42:31 -0500
simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Thu, 2012-12-06 at 07:37 -0500, Jeff Layton wrote:
> > Currently, the ACL-related tools in cifs-utils call into the wbclient
> > libs directly in order to do their bidding. The wbclient developers want
> > to get away from needing to configure winbind on the clients and instead
> > allow sssd to handle the id-mapping. Less muss, less fuss...
> > 
> > This patch represents an initial step in that direction. It adds a
> > plugin architecture for cifs-utils, adds wrappers around the calls into
> > libwbclient that find an idmap plugin library to use and then has it
> > call into that plugin to do the actual ID mapping.
> > 
> > This patch should be considered an RFC on the overall design. Once I
> > have some positive feedback (or lack of negative feedback), I'll do the
> > same with cifs.idmap and setcifsacl.
> > 
> > This patch is still pretty rough, but should demonstrate the basic
> > design:
> > 
> > The application will call into a set of routines that find the correct
> > plugin and dlopen() it. Currently the plugin is located in a hardcoded
> > location that will eventually be settable via autoconf. That location is
> > intended to be a symlink that points to the real plugin (generally under
> > %libdir/cifs-utils).
> > 
> > The plugin will export a number of functions with well-known names. The
> > wrappers find those by using dlsym() and then call them.
> > 
> > I'm tracking progress on this work here:
> > 
> >     https://bugzilla.samba.org/show_bug.cgi?id=9203
> > 
> > Here are some questions to ponder:
> > 
> > 1/ Should we switch this code to use a config file of some sort instead
> > of this symlink? The symlink would probably be more efficient, but it
> > is a little odd and might confuse people. It also might make it hard to
> > expand the idmapping interfaces later.
> 
> I think a symlink is ok for starters, a config file can always be added
> later if needed.
> 

To play devil's advocate, a config file might make more sense. What if
a plugin wants to be able to set certain parameters globally (domain
names or something)?

Having that configuration in a single place might be less confusing
than having to set a symlink and set up a config file. Switching to a
config file later is a UI change and those are always more painful...

> > 2/ Should I switch this code to use libltdl for the plugin architecture?
> > I started to use that initially, but it was awfully complex to get working.
> > Since portability isn't really a concern with cifs-utils, I punted. Does
> > anyone see issues with rolling our own here?
> 
> Well the cifs kernel module is Linux only, I would leave the hassle of
> dealing with portability to whomever would like to port this.
> Using dlopen/dlsym is simple, so roll-your-own seem fine to me.
> 
> One thing though I would name-space the symbol, so instead of
> idmap_sid_to_str call it cifs_idmap_sid_to_str, in the plugin.
> Internally you can call whatever you want.
> 

Ok, the namespace thing is probably a good idea. Perhaps we should even
take a page out of the libltdl book, and prefix the symbols with the
name of the plugin? So in this patch, that would be something like
"idmapwb_sid_to_str". That way if we ever want to be able to stack
plugins, we can potentially do so without conflicts.

> Also I think you shouldn't resolve symbols each time,
> 
> Declare a function pointer in the data segment (so inited to NULL at
> startup) and do a lazy init only if it is NULL, by assigning it.
> 
> #define RESOLVE_SYMBOL(name) \
> do { \
>     if (name == NULL) { \
>         name = resolve_symbol("cifs_" # name); \
>         if (name == NULL) \
>             return -ENOSYS; \
>     } \
> } while(0);
> 
> sid_to_str()
> {
>     RESOLVE_SYMBOL(idmap_sid_to_str);
>     return idmap_sid_to_str(..);
> }
> 

Yep, I was planning to add that in a later patch. I just wanted to make
the initial patch simple to focus on the interfaces between components.

Thanks for the review so far...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
