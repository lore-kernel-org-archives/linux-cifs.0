From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: remove /proc/fs/cifs/Experimental
Date: Tue, 7 Dec 2010 14:10:59 -0500
Message-ID: <20101207141059.0ddc6c7d@tlielax.poochiereds.net>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
	<1291731835-1120-5-git-send-email-jlayton@redhat.com>
	<20101207111328.6647c36c@tlielax.poochiereds.net>
	<AANLkTi=_5VYCXpd+WfwcKq50=kN3GRaGVgjfkReM9Ye0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=_5VYCXpd+WfwcKq50=kN3GRaGVgjfkReM9Ye0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Dec 2010 10:21:11 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The issue of how to prevent a page from being modified as it is
> written out (due to signing in our case) has been discussed on lkml a
> few times (e.g. T10 block devices).   We should hold off on changing
> this until we have a way of handling the case of:   we calculate the
> signature, but just before the page in the cache is remodified, we
> send it with the wrong signature ... obviously if we reissue the writ=
e
> we are fine (the data is fine) but there may be better ways to lock
> the page (and some suggestions have been made on lkml for similar
> sounding problems).
>=20

This behavior has been "Experimental" for years. At what point do we
remove this kludge? Who in their right mind is going to turn on a
switch called "Experimental" to enable this? As a user, I'd certainly
be reticent to do so. It's not clear what turning on "Experimental"
would give me.

If you think this behavior deserves to be switchable then let's put a
real usable switch on it. I don't think it ought to be hidden
as /proc/fs/cifs/Experimental. Perhaps a module parameter for
this would be more appropriate?

If so what would you name such a switch?

> On Tue, Dec 7, 2010 at 10:13 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Tue, =A07 Dec 2010 09:23:55 -0500
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> This flag only affects a couple of places in the write codepath, a=
nd
> >> it's not entirely clear to me what the purpose of it is. I've neve=
r
> >> known anyone (even developers) to use this knob, so let's remove i=
t.
> >>
> >> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifs_debug.c | =A0 42 ---------------------------------=
---------
> >> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/cifsglob.h =A0 | =A0 =A01 -
> >> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 =A06 +++---
> >> =A04 files changed, 3 insertions(+), 47 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> >> index 103ab8b..04eecb2 100644
> >> --- a/fs/cifs/cifs_debug.c
> >> +++ b/fs/cifs/cifs_debug.c
> >> @@ -425,7 +425,6 @@ static const struct file_operations cifs_looku=
p_cache_proc_fops;
> >> =A0static const struct file_operations traceSMB_proc_fops;
> >> =A0static const struct file_operations cifs_multiuser_mount_proc_f=
ops;
> >> =A0static const struct file_operations cifs_security_flags_proc_fo=
ps;
> >> -static const struct file_operations cifs_experimental_proc_fops;
> >> =A0static const struct file_operations cifs_linux_ext_proc_fops;
> >>
> >> =A0void
> >> @@ -443,8 +442,6 @@ cifs_proc_init(void)
> >> =A0 =A0 =A0 proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_=
fops);
> >> =A0 =A0 =A0 proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_pro=
c_fops);
> >> =A0 =A0 =A0 proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_op=
lock_proc_fops);
> >> - =A0 =A0 proc_create("Experimental", 0, proc_fs_cifs,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cifs_experimental_proc_fops);
> >> =A0 =A0 =A0 proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cifs_linux_ext_proc_fops);
> >> =A0 =A0 =A0 proc_create("MultiuserMount", 0, proc_fs_cifs,
> >> @@ -552,45 +549,6 @@ static const struct file_operations cifs_oplo=
ck_proc_fops =3D {
> >> =A0 =A0 =A0 .write =A0 =A0 =A0 =A0 =A0=3D cifs_oplock_proc_write,
> >> =A0};
> >>
> >> -static int cifs_experimental_proc_show(struct seq_file *m, void *=
v)
> >> -{
> >> - =A0 =A0 seq_printf(m, "%d\n", experimEnabled);
> >> - =A0 =A0 return 0;
> >> -}
> >> -
> >> -static int cifs_experimental_proc_open(struct inode *inode, struc=
t file *file)
> >> -{
> >> - =A0 =A0 return single_open(file, cifs_experimental_proc_show, NU=
LL);
> >> -}
> >> -
> >> -static ssize_t cifs_experimental_proc_write(struct file *file,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 const char __user *buffer, size_t count,=
 loff_t *ppos)
> >> -{
> >> - =A0 =A0 char c;
> >> - =A0 =A0 int rc;
> >> -
> >> - =A0 =A0 rc =3D get_user(c, buffer);
> >> - =A0 =A0 if (rc)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> - =A0 =A0 if (c =3D=3D '0' || c =3D=3D 'n' || c =3D=3D 'N')
> >> - =A0 =A0 =A0 =A0 =A0 =A0 experimEnabled =3D 0;
> >> - =A0 =A0 else if (c =3D=3D '1' || c =3D=3D 'y' || c =3D=3D 'Y')
> >> - =A0 =A0 =A0 =A0 =A0 =A0 experimEnabled =3D 1;
> >> - =A0 =A0 else if (c =3D=3D '2')
> >> - =A0 =A0 =A0 =A0 =A0 =A0 experimEnabled =3D 2;
> >> -
> >> - =A0 =A0 return count;
> >> -}
> >> -
> >> -static const struct file_operations cifs_experimental_proc_fops =3D=
 {
> >> - =A0 =A0 .owner =A0 =A0 =A0 =A0 =A0=3D THIS_MODULE,
> >> - =A0 =A0 .open =A0 =A0 =A0 =A0 =A0 =3D cifs_experimental_proc_ope=
n,
> >> - =A0 =A0 .read =A0 =A0 =A0 =A0 =A0 =3D seq_read,
> >> - =A0 =A0 .llseek =A0 =A0 =A0 =A0 =3D seq_lseek,
> >> - =A0 =A0 .release =A0 =A0 =A0 =A0=3D single_release,
> >> - =A0 =A0 .write =A0 =A0 =A0 =A0 =A0=3D cifs_experimental_proc_wri=
te,
> >> -};
> >> -
> >> =A0static int cifs_linux_ext_proc_show(struct seq_file *m, void *v=
)
> >> =A0{
> >> =A0 =A0 =A0 seq_printf(m, "%d\n", linuxExtEnabled);
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 48582b7..932a347 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -53,7 +53,6 @@ int cifsFYI =3D 0;
> >> =A0int cifsERROR =3D 1;
> >> =A0int traceSMB =3D 0;
> >> =A0unsigned int oplockEnabled =3D 1;
> >> -unsigned int experimEnabled =3D 0;
> >> =A0unsigned int linuxExtEnabled =3D 1;
> >> =A0unsigned int lookupCacheEnabled =3D 1;
> >> =A0unsigned int multiuser_mount =3D 0;
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 37fb246..5ab6701 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -777,7 +777,6 @@ GLOBAL_EXTERN unsigned int multiuser_mount; /*=
 if enabled allows new sessions
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 have t=
he uid/password or Kerberos credential
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 or equ=
ivalent for current user */
> >> =A0GLOBAL_EXTERN unsigned int oplockEnabled;
> >> -GLOBAL_EXTERN unsigned int experimEnabled;
> >> =A0GLOBAL_EXTERN unsigned int lookupCacheEnabled;
> >> =A0GLOBAL_EXTERN unsigned int global_secflags; =A0/* if on, sessio=
n setup sent
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 with m=
ore secure ntlmssp2 challenge/resp */
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 5a28660..5f6907e 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1054,10 +1054,10 @@ static ssize_t cifs_write(struct cifsFileI=
nfo *open_file,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc=
 !=3D 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (experimEnabled || (p=
Tcon->ses->server &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pTcon->ses->server &=
&
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pTco=
n->ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMO=
DE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D 0=
))) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D 0=
)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 kvec iov[2];
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsign=
ed int len;
> >>
> >> @@ -1319,7 +1319,7 @@ static int cifs_writepages(struct address_sp=
ace *mapping,
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
> >> - =A0 =A0 if (!experimEnabled && tcon->ses->server->secMode &
> >> + =A0 =A0 if (tcon->ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED=
 | SECMODE_SIGN_ENABLED)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(open_file);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(iov);
> >
> > Just noticed that this misses removing the de-registration of
> > "Experimental", so it'll need to be respun.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
