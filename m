From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: don't overwrite dentry name in d_revalidate
Date: Wed, 15 Dec 2010 22:48:54 -0600
Message-ID: <AANLkTik4MFK70pP3bmW5epZvki9gH+tAr+RDVbMLH38x@mail.gmail.com>
References: <20101111074216.GA10159@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101111074216.GA10159@amd>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Thu, Nov 11, 2010 at 1:42 AM, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>
> Instead, use fatfs's method for dealing with negative dentries to
> preserve case, rather than overwrite dentry name in d_revalidate, whi=
ch
> is a bit ugly and also gets in the way of doing lock-free path walkin=
g.
>
> Signed-off-by: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
>
> Index: linux-2.6/fs/cifs/dir.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/cifs/dir.c =A0 =A0 =A0 =A02010-11-11 18:05:55.0=
00000000 +1100
> +++ linux-2.6/fs/cifs/dir.c =A0 =A0 2010-11-11 18:06:49.000000000 +11=
00
> @@ -656,22 +656,34 @@ cifs_lookup(struct inode *parent_dir_ino
> =A0static int
> =A0cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
> =A0{
> - =A0 =A0 =A0 int isValid =3D 1;
> -
> =A0 =A0 =A0 =A0if (direntry->d_inode) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_revalidate_dentry(direntry))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "neg dentry 0x%p name =3D %s",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0direntry, direntry->=
d_name.name);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies, direntry->d_tim=
e + HZ) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !lookupCacheEnabled) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_drop(direntry);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isValid =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* This may be nfsd (or something), anyway, we can't =
see the
> + =A0 =A0 =A0 =A0* intent of this. So, since this can be for creation=
, drop it.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!nd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Drop the negative dentry, in order to make sure to=
 use the
> + =A0 =A0 =A0 =A0* case sensitive name which is specified by user if =
this is
> + =A0 =A0 =A0 =A0* for creation.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nd->flags & (LOOKUP_CREATE | LOOKUP=
_RENAME_TARGET))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 return isValid;
> + =A0 =A0 =A0 if (time_after(jiffies, direntry->d_time + HZ) || !look=
upCacheEnabled)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 return 1;
> =A0}
>
> =A0/* static int cifs_d_delete(struct dentry *direntry)
> @@ -709,15 +721,8 @@ static int cifs_ci_compare(struct dentry
> =A0 =A0 =A0 =A0struct nls_table *codepage =3D CIFS_SB(dentry->d_inode=
->i_sb)->local_nls;
>
> =A0 =A0 =A0 =A0if ((a->len =3D=3D b->len) &&
> - =A0 =A0 =A0 =A0 =A0 (nls_strnicmp(codepage, a->name, b->name, a->le=
n) =3D=3D 0)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* To preserve case, don't let an exi=
sting negative dentry's
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* case take precedence. =A0If a is n=
ot a negative dentry, this
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* should have no side effects
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy((void *)a->name, b->name, a->len=
);
> + =A0 =A0 =A0 =A0 =A0 (nls_strnicmp(codepage, a->name, b->name, a->le=
n) =3D=3D 0))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return 1;
> =A0}
>



--
Thanks,

Steve
