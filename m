From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 11:12:28 -0400
Message-ID: <20111011111228.7de52ca4@corrin.poochiereds.net>
References: <4E940E2B.4050705@suse.de>
	<20111011063236.3fb399e0@tlielax.poochiereds.net>
	<4E942399.8050807@suse.de>
	<CAH2r5muJ6xiW5iPALmdaSxh=vYKGfq6SdWoRcf7YFGDFnxnDWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muJ6xiW5iPALmdaSxh=vYKGfq6SdWoRcf7YFGDFnxnDWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 10:03:31 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 11, 2011 at 6:08 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
> > On 10/11/2011 04:02 PM, Jeff Layton wrote:
> >> On Tue, 11 Oct 2011 15:06:43 +0530
> >> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >>
> >>> Thus spake Jeff Layton:
> >>>
> >>> "Making that a module parm would allow you to set that parameter =
at boot
> >>> time without needing to add special startup scripts. IMO, all of =
the
> >>> procfile "switches" under /proc/fs/cifs should be module parms
> >>> instead."
> >>>
> >>> This seems reasonable so this patch makes OplockEnabled a module
> >>> parameter and rename it to enable_oplocks to comply with the codi=
ng
> >>> conventions. This patch removes the proc file handling pertaining=
 to
> >>> /proc/fs/cifs/OplockEnabled which would no longer be required if =
this
> >>> patch gets accepted.
> >>>
> >>> This patch doesn't alter the default behavior (Oplocks enabled by
> >>> default). To disable oplocks when loading the module, use
> >>>
> >>> =C2=A0 =C2=A0modprobe cifs enable_oplocks=3D0
> >>>
> >>> Note:
> >>> (a) I'm little worried about eliminating an already known interac=
e to
> >>> =C2=A0 =C2=A0 enable/disable Oplocks. An update to README file me=
ntioning this info
> >>> =C2=A0 =C2=A0 is planned. Do we need to warn users before pulling=
 it off? Any
> >>> =C2=A0 =C2=A0 suggestions on how we could do this?
> >>> (b) Most of the /proc/fs/cifs switches could be converted to a mo=
dule
> >>> =C2=A0 =C2=A0 param for e.g. LookupCacheEnabled, LinuxExtensionsE=
nabled,
> >>> =C2=A0 =C2=A0 MultiuserMount etc. I'll post further patches once =
this gets
> >>> =C2=A0 =C2=A0 accepted.
> >>>
> >>
> >> Yeah, I don't think we ought to just rip out these interfaces
> >> unannounced. What should probably happen is this:
> >>
> >> Add the new module parms, and a patch that makes a printk pop when=
 the
> >> old interfaces are used. The printk should announce something like=
:
> >>
> >> "The /proc/fs/cifs/foo interface will be removed in kernel version=
 3.x.
> >> Please migrate to using the 'enable_foo' module parameter in cifs.=
ko."
> >>
> >> Make the 3.x version be 2 releases out. Then have patches ready to=
 go
> >> to remove those interfaces when the 3.x merge window opens.
> >
> > Makes sense. Thanks.
> >
> >>> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
> >>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/cifs_debug.c | =C2=A0 40 --------------------------=
--------------
> >>> =C2=A0fs/cifs/cifsfs.c =C2=A0 =C2=A0 | =C2=A0 =C2=A04 +++-
> >>> =C2=A0fs/cifs/cifsglob.h =C2=A0 | =C2=A0 =C2=A04 +++-
> >>> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02 +=
-
> >>> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A04 ++--
> >>> =C2=A05 files changed, 9 insertions(+), 45 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> >>> index 2fe3cf1..393b37b 100644
> >>> --- a/fs/cifs/cifs_debug.c
> >>> +++ b/fs/cifs/cifs_debug.c
> >>> @@ -418,7 +418,6 @@ static const struct file_operations cifs_stat=
s_proc_fops =3D {
> >>>
> >>> =C2=A0static struct proc_dir_entry *proc_fs_cifs;
> >>> =C2=A0static const struct file_operations cifsFYI_proc_fops;
> >>> -static const struct file_operations cifs_oplock_proc_fops;
> >>> =C2=A0static const struct file_operations cifs_lookup_cache_proc_=
fops;
> >>> =C2=A0static const struct file_operations traceSMB_proc_fops;
> >>> =C2=A0static const struct file_operations cifs_multiuser_mount_pr=
oc_fops;
> >>> @@ -439,7 +438,6 @@ cifs_proc_init(void)
> >>> =C2=A0#endif /* STATS */
> >>> =C2=A0 =C2=A0 =C2=A0proc_create("cifsFYI", 0, proc_fs_cifs, &cifs=
=46YI_proc_fops);
> >>> =C2=A0 =C2=A0 =C2=A0proc_create("traceSMB", 0, proc_fs_cifs, &tra=
ceSMB_proc_fops);
> >>> - =C2=A0 =C2=A0proc_create("OplockEnabled", 0, proc_fs_cifs, &cif=
s_oplock_proc_fops);
> >>> =C2=A0 =C2=A0 =C2=A0proc_create("LinuxExtensionsEnabled", 0, proc=
_fs_cifs,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&ci=
fs_linux_ext_proc_fops);
> >>> =C2=A0 =C2=A0 =C2=A0proc_create("MultiuserMount", 0, proc_fs_cifs=
,
> >>> @@ -463,7 +461,6 @@ cifs_proc_clean(void)
> >>> =C2=A0 =C2=A0 =C2=A0remove_proc_entry("Stats", proc_fs_cifs);
> >>> =C2=A0#endif
> >>> =C2=A0 =C2=A0 =C2=A0remove_proc_entry("MultiuserMount", proc_fs_c=
ifs);
> >>> - =C2=A0 =C2=A0remove_proc_entry("OplockEnabled", proc_fs_cifs);
> >>> =C2=A0 =C2=A0 =C2=A0remove_proc_entry("SecurityFlags", proc_fs_ci=
fs);
> >>> =C2=A0 =C2=A0 =C2=A0remove_proc_entry("LinuxExtensionsEnabled", p=
roc_fs_cifs);
> >>> =C2=A0 =C2=A0 =C2=A0remove_proc_entry("LookupCacheEnabled", proc_=
fs_cifs);
> >>> @@ -509,43 +506,6 @@ static const struct file_operations cifsFYI_=
proc_fops =3D {
> >>> =C2=A0 =C2=A0 =C2=A0.write =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =
cifsFYI_proc_write,
> >>> =C2=A0};
> >>>
> >>> -static int cifs_oplock_proc_show(struct seq_file *m, void *v)
> >>> -{
> >>> - =C2=A0 =C2=A0seq_printf(m, "%d\n", oplockEnabled);
> >>> - =C2=A0 =C2=A0return 0;
> >>> -}
> >>> -
> >>> -static int cifs_oplock_proc_open(struct inode *inode, struct fil=
e *file)
> >>> -{
> >>> - =C2=A0 =C2=A0return single_open(file, cifs_oplock_proc_show, NU=
LL);
> >>> -}
> >>> -
> >>> -static ssize_t cifs_oplock_proc_write(struct file *file,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char __user *buf=
fer, size_t count, loff_t *ppos)
> >>> -{
> >>> - =C2=A0 =C2=A0char c;
> >>> - =C2=A0 =C2=A0int rc;
> >>> -
> >>> - =C2=A0 =C2=A0rc =3D get_user(c, buffer);
> >>> - =C2=A0 =C2=A0if (rc)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >>> - =C2=A0 =C2=A0if (c =3D=3D '0' || c =3D=3D 'n' || c =3D=3D 'N')
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0oplockEnabled =3D 0;
> >>> - =C2=A0 =C2=A0else if (c =3D=3D '1' || c =3D=3D 'y' || c =3D=3D =
'Y')
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0oplockEnabled =3D 1;
> >>> -
> >>> - =C2=A0 =C2=A0return count;
> >>> -}
> >>> -
> >>> -static const struct file_operations cifs_oplock_proc_fops =3D {
> >>> - =C2=A0 =C2=A0.owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D THIS_=
MODULE,
> >>> - =C2=A0 =C2=A0.open =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D cifs_=
oplock_proc_open,
> >>> - =C2=A0 =C2=A0.read =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D seq_r=
ead,
> >>> - =C2=A0 =C2=A0.llseek =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D seq_lseek,
> >>> - =C2=A0 =C2=A0.release =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D single_rel=
ease,
> >>> - =C2=A0 =C2=A0.write =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D cifs_=
oplock_proc_write,
> >>> -};
> >>> -
> >>> =C2=A0static int cifs_linux_ext_proc_show(struct seq_file *m, voi=
d *v)
> >>> =C2=A0{
> >>> =C2=A0 =C2=A0 =C2=A0seq_printf(m, "%d\n", linuxExtEnabled);
> >>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >>> index 3e29899..37c2fbb 100644
> >>> --- a/fs/cifs/cifsfs.c
> >>> +++ b/fs/cifs/cifsfs.c
> >>> @@ -52,7 +52,6 @@
> >>> =C2=A0int cifsFYI =3D 0;
> >>> =C2=A0int cifsERROR =3D 1;
> >>> =C2=A0int traceSMB =3D 0;
> >>> -unsigned int oplockEnabled =3D 1;
> >>> =C2=A0unsigned int linuxExtEnabled =3D 1;
> >>> =C2=A0unsigned int lookupCacheEnabled =3D 1;
> >>> =C2=A0unsigned int multiuser_mount =3D 0;
> >>> @@ -81,6 +80,9 @@ module_param(echo_retries, ushort, 0644);
> >>> =C2=A0MODULE_PARM_DESC(echo_retries, "Number of echo attempts bef=
ore giving up and "
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "reconnecting server. Default: 5. 0 mea=
ns "
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "never reconnect.");
> >>> +unsigned int enable_oplocks =3D 1;
> >>> +module_param(enable_oplocks, bool, 0644);
> >>> +MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (boo=
l). Default: 1.");
> >>
> >> I think you want this as "Default: true" since this is a bool?
> >>
> >
> > No. From the definition of module_param:
> >
> > (snip)
> > =C2=A0* Standard types are:
> > =C2=A0* =C2=A0 =C2=A0 =C2=A0byte, short, ushort, int, uint, long, u=
long
> > =C2=A0* =C2=A0 =C2=A0 =C2=A0charp: a character pointer
> > =C2=A0* =C2=A0 =C2=A0 =C2=A0bool: a bool, values 0/1, y/n, Y/N.
> > =C2=A0*/
> > #define module_param(name, type, perm) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0module_param_named(name, name, type, per=
m)
> >
> > I should perhaps add y/Y.
>=20
> I don't mind adding a module parm to change the default but it seems
> odd, and removing the ability to temporarily turn off oplock seems to
> make things worse not better.  But I am not convinced of a good use
> case for disabling oplocks on module load (rather than the more
> granular "forcedirectio" on mount, or the temporary ie at runtime via
> /proc).   If oplock/caching on the client were broken, then we would
> fix the bug rather than ask users to load with oplock off, if oplock
> were broken on a server, we would not want to disable it for mounts t=
o
> all servers (as would a module parm) but just to workaround the broke=
n
> server.
>=20

This doesn't prevent you from changing this setting after the module is
loaded. It just moves the control to a more standard location
(/sys/module/cifs/parameters).

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
