From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 18:59:10 -0500
Message-ID: <20110228235910.GD14237@fieldses.org>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
 <20110228224957.GB14237@fieldses.org>
 <AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
 <20110228234225.GC14237@fieldses.org>
 <AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M--JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrote:
> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields-uC3wQj2KruMpug/h7KTFAQ@public.gmane.org=
g> wrote:
> > On Mon, Feb 28, 2011 at 04:58:57PM -0600, Steve French wrote:
> >> On Mon, Feb 28, 2011 at 4:49 PM, J. Bruce Fields <bfields@fieldses=
=2Eorg> wrote:
> >> > On Mon, Feb 28, 2011 at 03:52:41PM -0600, shirishpargaonkar@gmai=
l.com wrote:
> >> >> +static struct dentry *
> >> >> +cifs_fh_to_dentry(struct super_block *sb, struct fid *fh,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int fh_len, int fh_type)
> >> >> +{
> >> >> + =C2=A0 =C2=A0 struct cifs_fid *cfid =3D (struct cifs_fid *)fh=
;
> >> >> + =C2=A0 =C2=A0 struct inode *inode =3D NULL;
> >> >> + =C2=A0 =C2=A0 struct cifs_fattr fattr;
> >> >> +
> >> >>
> >> >> -#endif /* CIFS_NFSD_EXPORT */
> >> >> + =C2=A0 =C2=A0 if (fh_type !=3D FILEID_INO32_GEN && fh_type !=3D=
 FILEID_INO32_GEN_PARENT) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "%s: Can'=
t handle fh type: %d", __func__, fh_type);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EIN=
VAL);
> >> >> + =C2=A0 =C2=A0 }
> >> >>
> >> >> + =C2=A0 =C2=A0 if (!cfid->cino)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(-EST=
ALE);
> >> >> +
> >> >> + =C2=A0 =C2=A0 fattr.cf_uniqueid =3D cfid->cino;
> >> >> + =C2=A0 =C2=A0 inode =3D iget5_locked(sb, cfid->cino, cifs_fin=
d_inode_id,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_in=
it_inode, &fattr);
> >> >> + =C2=A0 =C2=A0 if (IS_ERR(inode))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ERR_CAST(ino=
de);
> >> >> +
> >> >> + =C2=A0 =C2=A0 return d_obtain_alias(inode);
> >> >
> >> > Does the cifs protocol give the client a way to look up a file b=
y inode
> >> > number (or filehandle or equivalent?).
> >>
> >> There is a unique identifier similar to inode number returned by
> >> various info calls,
> >> but cifs calls use either a file handle (returned by an open) or p=
ath name to
> >> look up metadata on a file.
> >>
> >> Not sure whether the unique identifier can be passed in as input t=
o an
> >> ioctl useful here.
> >
> > OK. =C2=A0Then as things stand we're stuck returning ESTALE to the =
client
> > unless we happen to have the inode they're looking for in our cache=
?
>=20
> Yes - that seems right and consistent with what I remember other file
> systems doing.

No, other filesystems are able to look up the file on disk by inode
number (or by whatever identifier they use in the filehandle).  They
don't depend on already having the inode in core.

> IIRC LInux nfs clients handle this already.

The Linux nfs client will just pass along the ESTALE to the application=
=2E

--b.
