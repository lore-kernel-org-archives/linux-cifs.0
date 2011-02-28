From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 17:52:09 -0600
Message-ID: <AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110228224957.GB14237@fieldses.org>
	<AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
	<20110228234225.GC14237@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110228234225.GC14237-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> On Mon, Feb 28, 2011 at 04:58:57PM -0600, Steve French wrote:
>> On Mon, Feb 28, 2011 at 4:49 PM, J. Bruce Fields <bfields@fieldses.o=
rg> wrote:
>> > On Mon, Feb 28, 2011 at 03:52:41PM -0600, shirishpargaonkar@gmail.=
com wrote:
>> >> +static struct dentry *
>> >> +cifs_fh_to_dentry(struct super_block *sb, struct fid *fh,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int fh_len, int fh_type=
)
>> >> +{
>> >> + =A0 =A0 struct cifs_fid *cfid =3D (struct cifs_fid *)fh;
>> >> + =A0 =A0 struct inode *inode =3D NULL;
>> >> + =A0 =A0 struct cifs_fattr fattr;
>> >> +
>> >>
>> >> -#endif /* CIFS_NFSD_EXPORT */
>> >> + =A0 =A0 if (fh_type !=3D FILEID_INO32_GEN && fh_type !=3D FILEI=
D_INO32_GEN_PARENT) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't handle fh type: %d=
", __func__, fh_type);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EINVAL);
>> >> + =A0 =A0 }
>> >>
>> >> + =A0 =A0 if (!cfid->cino)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ESTALE);
>> >> +
>> >> + =A0 =A0 fattr.cf_uniqueid =3D cfid->cino;
>> >> + =A0 =A0 inode =3D iget5_locked(sb, cfid->cino, cifs_find_inode_=
id,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_init_inode, &fattr);
>> >> + =A0 =A0 if (IS_ERR(inode))
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(inode);
>> >> +
>> >> + =A0 =A0 return d_obtain_alias(inode);
>> >
>> > Does the cifs protocol give the client a way to look up a file by =
inode
>> > number (or filehandle or equivalent?).
>>
>> There is a unique identifier similar to inode number returned by
>> various info calls,
>> but cifs calls use either a file handle (returned by an open) or pat=
h name to
>> look up metadata on a file.
>>
>> Not sure whether the unique identifier can be passed in as input to =
an
>> ioctl useful here.
>
> OK. =A0Then as things stand we're stuck returning ESTALE to the clien=
t
> unless we happen to have the inode they're looking for in our cache?

Yes - that seems right and consistent with what I remember other file
systems doing.
IIRC LInux nfs clients handle this already.

--=20
Thanks,

Steve
