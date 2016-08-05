From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: nfs/cifs mountinfo differences (was: Re: [PATCH] libmount: Skip
 root comparison for cifs in mnt_table_is_fs_mounted())
Date: Fri, 5 Aug 2016 19:22:34 +0200
Message-ID: <20160805192234.2c9d5b7d@aaptelpc>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz>
	<5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4z/nGxxA=b/YqAYJhmE2LMg"; protocol="application/pgp-signature"
Cc: util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5eb96b3e-d463-bf11-49de-f614247d6b29-AlSwsSmVLrQ@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/4z/nGxxA=b/YqAYJhmE2LMg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have looked a bit more into it.

Linux provides filesystems a way to show their own thing in the 4th
column (documented as "root of the mount within the filesystem"). The
presence of this mechanism makes me think this info wasn't made only to
be altered by bind-mounts.

The mechanism in question is the superblock operation 'show_path'. If a
filesystem doesn't provide one, linux default is to walk the dentry
connected to the mount points until it reaches the fs root and print
that. This is what happens in (recent) CIFS.

                                  +------------------+
                                  | cifs super_block |
+------------------+              +------------------+
|rootfs super_block|              |      s_root      |
+------------------+              +------------------+
|      s_root      |                       |
+------------------+                       v
         |                           [ dentry "/" ]
         |                                 |
         |                                 v
         v                           [ dentry "sub" ]
    [dentry "/"]                           |
         v                                 v
   [dentry "mnt"] -----magic------>  [ dentry "dir" ]
                                           |
                                          vvv
                               [ content of "/sub/dir/" ]


CIFS doesn't override the default show_path so mountinfo walks from
"dir" to "/" and prints "/sub/dir".

NFS on the other hand overides the show_path operation to:

int nfs_show_path(struct seq_file *m, struct dentry *dentry)
{
	seq_puts(m, "/");
	return 0;
}

ie. *always* prints "/".

Now correct me if I'm wrong (I really am not sure) but I think 'mount
-a' assumes only bind-mounts should print a subdir path instead of "/".

So either

(A) we make that assumption explicit and consider it the Truth:

- we update the kernel documentation of that column in
  Documentation/filesystems/proc.txt to read something like "path
  binded within the filesystem"
- like NFS, we override show_path to always return "/".
- leave mount utility unchanged.

or (B) we consider the current kernel doc as the Truth:

- we make NFS do like CIFS
- leave CIFS unchanged [1]
- figure out what to do with mount utility (back to initial problem I
  guess)

Personal opinion: the way the current doc is written and again, the fact
that linux lets you override the path on a per-filesystem basis makes me
think solution B is the way to go.

Also, I don't understand why

On Wed, 3 Aug 2016 19:23:06 +0200 Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
wrote:
> > Skipping root comparison in mnt_table_is_fs_mounted() makes things
> > better, however it still does not cover all possible setups.

and

> > diff --git a/libmount/src/tab.c b/libmount/src/tab.c
> > index 155c65e..aa9185a 100644
> > --- a/libmount/src/tab.c
> > +++ b/libmount/src/tab.c
> > @@ -1562,7 +1562,10 @@ int mnt_table_is_fs_mounted(struct
> > libmnt_table *tb, struct libmnt_fs *fstab_fs) #endif
> >  		}
> >
> > -		if (root) {
> > +		/* For cifs, root contains a relative path to the
> > exported volume,
> > +		 * i. e. something we cannot compare.
> > +		 */
> > +		if (root && strcmp(mnt_fs_get_fstype(fs), "cifs"))
> > { const char *r =3D mnt_fs_get_root(fs);
> >  			if (!r || strcmp(r, root) !=3D 0)
> >  				continue;
> >

We can't we compare in this case? Isn't it just a matter of
concatenating the source with the subdir?

1: I believe we should still override show_path in CIFS
   to take recent flag CIFS_USE_PREFIX_PATH into account because the
   default show_path assumes a different dentry structure

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/4z/nGxxA=b/YqAYJhmE2LMg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXpMtbAAoJEDIGO5Hchq/84Q0P/jgv0xQlx4zHhhbA0GMmHgSa
zuGLSkj2ZPFy+/9TB8ZosP7Z6j0U73W5pAVylXaweU7ONABZtNryFvnKijq+Hj/Y
l/0oK7jRxVz6Ebt5ZiE8Qd2UkjPLyeECj5pNahtdAzhDehX1ea2uEjfsKuv3mCzr
QSMeh2nLnnq2MD6AR+bKBpzAMwWNT4cX1Ci0TLut8uJn7T/SzjCeevCRURcQBayy
DkWEQbJ5ezMAdxGoMcbv9iwupkBHynP0EZ7dhWyq1JlfaXoX0VqF9UAoFqffTbuY
1+/CDNkpW6zkZIZWmIM2JxG5KXI2GMkz3MVXizzYqhKPlirlnN113ZE6YGeVKKGs
dJcpqvTfJnLPQbEPmdcNthjA40+/cskAW53+gnPIde/nVxaQtHYqS6WEmYxcAKcu
W6Pi32tkt/jBl3k4yvadrLKdztpi0SzOB6IkA1sX4EEQmR4OaLH89p/0ipfjqFp+
n9npRcNpKfS8OVvM6Tg+/Dzmg2iVrQZXxDbxNwfK7kP+PmIWS3GzT7kCMN674v5/
XITM9A/O4vUGqoP5HDXJxdh5tCqho3P5PJa835S7LVQSIMpUNr897MKa31WQY6iU
GEtJjykHyqvXyE3b38qZ+plXLFBJ6IaNxUw+9PErm9Dtj8GpkaZVHCB2KqP2b2s9
Wz4AdPlVfYT9VqP9nti3
=F0HA
-----END PGP SIGNATURE-----

--Sig_/4z/nGxxA=b/YqAYJhmE2LMg--
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
