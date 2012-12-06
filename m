From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH RFC] cifs-utils: new plugin architecture for ID mapping
 code
Date: Thu, 06 Dec 2012 10:34:10 -0500
Message-ID: <1354808050.14719.27.camel@pico.ipa.ssimo.org>
References: <1354797458-5170-1-git-send-email-jlayton@samba.org>
	 <1354801351.14719.18.camel@pico.ipa.ssimo.org>
	 <20121206095846.52d59286@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121206095846.52d59286-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-12-06 at 09:58 -0500, Jeff Layton wrote:
> On Thu, 06 Dec 2012 08:42:31 -0500
> simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > On Thu, 2012-12-06 at 07:37 -0500, Jeff Layton wrote:
> > > Currently, the ACL-related tools in cifs-utils call into the wbclient
> > > libs directly in order to do their bidding. The wbclient developers want
> > > to get away from needing to configure winbind on the clients and instead
> > > allow sssd to handle the id-mapping. Less muss, less fuss...
> > > 
> > > This patch represents an initial step in that direction. It adds a
> > > plugin architecture for cifs-utils, adds wrappers around the calls into
> > > libwbclient that find an idmap plugin library to use and then has it
> > > call into that plugin to do the actual ID mapping.
> > > 
> > > This patch should be considered an RFC on the overall design. Once I
> > > have some positive feedback (or lack of negative feedback), I'll do the
> > > same with cifs.idmap and setcifsacl.
> > > 
> > > This patch is still pretty rough, but should demonstrate the basic
> > > design:
> > > 
> > > The application will call into a set of routines that find the correct
> > > plugin and dlopen() it. Currently the plugin is located in a hardcoded
> > > location that will eventually be settable via autoconf. That location is
> > > intended to be a symlink that points to the real plugin (generally under
> > > %libdir/cifs-utils).
> > > 
> > > The plugin will export a number of functions with well-known names. The
> > > wrappers find those by using dlsym() and then call them.
> > > 
> > > I'm tracking progress on this work here:
> > > 
> > >     https://bugzilla.samba.org/show_bug.cgi?id=9203
> > > 
> > > Here are some questions to ponder:
> > > 
> > > 1/ Should we switch this code to use a config file of some sort instead
> > > of this symlink? The symlink would probably be more efficient, but it
> > > is a little odd and might confuse people. It also might make it hard to
> > > expand the idmapping interfaces later.
> > 
> > I think a symlink is ok for starters, a config file can always be added
> > later if needed.
> > 
> 
> To play devil's advocate, a config file might make more sense. What if
> a plugin wants to be able to set certain parameters globally (domain
> names or something)?

Then the plugin will have it's own file.

Which made me understand what looked strange in your code. You are not
calling an initialization function which is customary to do, so plugins
can do their setup.
Of course plugins can also do lazy init the first time you call any of
their function, but calling a init plugin explicitly may be useful, esp
if you pass in a 'interface version number', so that should you require
changes to the interface in future the plugin may adapt and you can use
the same with multiple cifs versions.

> Having that configuration in a single place might be less confusing
> than having to set a symlink and set up a config file. Switching to a
> config file later is a UI change and those are always more painful...

If you defer configuration to the plugin it is not your problem, and I
think that would be the correct way to go, otherwise you need to provide
methods for the plugins to read this config file and it quickly winds
down becoming a complex and more tightly coupled interface.

I think you want to stay out of plugins configuration business, they can
take care of that on their own.

If you want to make things easier maybe call an initializer function and
expect an opaque handle out of it.
Then always pass that handle back in any plugin function. This way the
interface can also be thread safe w/o forcing the plugin to use mutexes,
should you ever need thread safety.

> > > 2/ Should I switch this code to use libltdl for the plugin architecture?
> > > I started to use that initially, but it was awfully complex to get working.
> > > Since portability isn't really a concern with cifs-utils, I punted. Does
> > > anyone see issues with rolling our own here?
> > 
> > Well the cifs kernel module is Linux only, I would leave the hassle of
> > dealing with portability to whomever would like to port this.
> > Using dlopen/dlsym is simple, so roll-your-own seem fine to me.
> > 
> > One thing though I would name-space the symbol, so instead of
> > idmap_sid_to_str call it cifs_idmap_sid_to_str, in the plugin.
> > Internally you can call whatever you want.
> > 
> 
> Ok, the namespace thing is probably a good idea. Perhaps we should even
> take a page out of the libltdl book, and prefix the symbols with the
> name of the plugin? So in this patch, that would be something like
> "idmapwb_sid_to_str". That way if we ever want to be able to stack
> plugins, we can potentially do so without conflicts.

It is not really needed, because you are not going to load the symbols
as is, but you assign them to an internal name.
And I do not think you are ever going to support multiple idmappers, but
even if you do by using dlsym() you shouldn't really care about names,
because you have handle to a specific shared object and you can assign
and rename those symbols when you resolve them (as i showed in my
example) so you still do not get a conflict issue).

Namespacing using plugin names is needed if you want to just dlopen()
and then use the plugin's names directly without an explicit dlsym().
In that case name conflicts would arise.

> > Also I think you shouldn't resolve symbols each time,
> > 
> > Declare a function pointer in the data segment (so inited to NULL at
> > startup) and do a lazy init only if it is NULL, by assigning it.
> > 
> > #define RESOLVE_SYMBOL(name) \
> > do { \
> >     if (name == NULL) { \
> >         name = resolve_symbol("cifs_" # name); \
> >         if (name == NULL) \
> >             return -ENOSYS; \
> >     } \
> > } while(0);
> > 
> > sid_to_str()
> > {
> >     RESOLVE_SYMBOL(idmap_sid_to_str);
> >     return idmap_sid_to_str(..);
> > }
> > 
> 
> Yep, I was planning to add that in a later patch. I just wanted to make
> the initial patch simple to focus on the interfaces between components.
> 
> Thanks for the review so far...

YW,
HTH.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
