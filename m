From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix dentry refcount leak when opening a FIFO on lookup
Date: Sun, 26 Feb 2012 23:16:10 -0600
Message-ID: <CAH2r5mtd5Ae18OCtLdeLLwgB8KRQQvWvnPYsV_A82Wbpv1w4Eg@mail.gmail.com>
References: <1330007865-19962-1-git-send-email-jlayton@redhat.com>
	<CADT32eLr1B5XPkBqE3Lmj7v1sa1yoXE3MNNiJ+ubPf3t+UJSWg@mail.gmail.com>
	<20120224131203.287c15d0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120224131203.287c15d0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Fri, Feb 24, 2012 at 12:12 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Fri, 24 Feb 2012 11:59:25 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Feb 23, 2012 at 8:37 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > The cifs code will attempt to open files on lookup under certain
>> > circumstances. What happens though if we find that the file we ope=
ned
>> > was actually a FIFO or other special file?
>> >
>> > Currently, the open filehandle just ends up being leaked leading t=
o
>> > a dentry refcount mismatch and oops on umount. Fix this by having =
the
>> > code close the filehandle on the server if it turns out not to be =
a
>> > regular file. While we're at it, change this spaghetti if statemen=
t
>> > into a switch too.
>> >
>> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > Reported-by: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/dir.c | =A0 20 ++++++++++++++++++--
>> > =A01 files changed, 18 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> > index 63a196b..bc7e244 100644
>> > --- a/fs/cifs/dir.c
>> > +++ b/fs/cifs/dir.c
>> > @@ -584,10 +584,26 @@ cifs_lookup(struct inode *parent_dir_inode, =
struct dentry *direntry,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * If either that o=
r op not supported returned, follow
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * the normal looku=
p.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rc =3D=3D 0) ||=
 (rc =3D=3D -ENOENT))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (rc) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 The server may allow us to open things like
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 FIFOs, but the client isn't set up to deal
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 with that. If it's not a regular file, just
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 close it and proceed as if it were a normal
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 lookup.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=
newInode && !S_ISREG(newInode->i_mode)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 CIFSSMBClose(xid, pTcon, fileHandle);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -ENOENT:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pos=
ix_open =3D true;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if ((rc =3D=3D =
-EINVAL) || (rc !=3D -EOPNOTSUPP))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -EOPNOTSUPP:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brea=
k;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pTc=
on->broken_posix_open =3D true;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!posix_open)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_ino=
de_info_unix(&newInode, full_path,
>> > --
>> > 1.7.7.6
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>> One =A0more thing, should CIFSPOSIXDelFile should be called to match
>> CIFSPOSIXOpen or CIFSMBClose is just as good enough?
>
> I don't think so...
>
> If the FIFO was already there, then you clearly don't want to remove
> it. Note that in this case, we're not failing anything -- just gettin=
g
> rid of the open filehandle and corresponding CIFS open when we realiz=
e
> that it's not a normal file.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
