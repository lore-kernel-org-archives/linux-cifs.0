From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Introduce cifs_copy_file_range()
Date: Wed, 8 Feb 2017 11:31:53 -0600
Message-ID: <CAH2r5msmRXO=KpF-pGW2K-vN5OWJ46pL6yOTCPuL+=q=yzjgPA@mail.gmail.com>
References: <20170207113311.11474-1-sprabhu@redhat.com> <mpsfujoiuoc.fsf@aaptelpc.suse.de>
 <1486572642.16541.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486572642.16541.11.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Feb 8, 2017 08:58, "Sachin Prabhu" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, 2017-02-08 at 16:11 +0100, Aur=C3=A9lien Aptel wrote:
> > Hi Sachin,
> >
> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > > The patch introduces the file_operations helper
> > > cifs_copy_file_range().
> > >
> > > The vfs helper vfs_copy_file_range() first calls clone_file_range
> > > which for cifs uses
> > > SMB2_ioctl(.., FSCTL_DUPLICATE_EXTENTS_TO_FILE, ..)
> > > to do a server side copy of the file. This ioctl is only supported
> > > on
> > > SMB3 and later versions.
> > >
> > > Once this call fails, vfs_copy_file_range() calls copy_file_range()
> > > corresponding to the cifs filesystem which is introduced by this
> > > patch.
> > > This calls the more widely available
> > > SMB2_ioctl(.., FSCTL_SRV_COPYCHUNK_WRITE, ..)
> >
> > Sounds good.
> >
> > > The upstream changes in this area was first made by the commit
> > > 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
> > > This commit also introduces the ioctls FICLONE and FICLONERANGE
> > > which
> >
> > IIUC it also allows the copy_file_range syscall defined in
> > fs/read_write.c to take advantage of the dup extents fsctl, if
> > available, nice!
>
> This already works with duplicate extents ie. the feature is only
> implemented using the
> FSCTL_DUPLICATE_EXTENTS_TO_FILE
> which at the moment only on Win 2016 with ReFs on SMB3+ versions.
>
> This patch uses FSCTL_SRV_COPYCHUNK_WRITE as fall back when duplicate
> extents is not available. This cifs ioctl is supported on SMB2+
> versions and is even used as a fall back for SMB3 when the backing
> filesystem support for duplicate extents is not available.
>
> >
> > Now, I wonder if there is a way to implement the FIDEDUPERANGE ioctl
> > in
> > SMB3, which does the same thing as a clone but it exits early if the
> > destination does not already match the source.
>
> I guess this is similar to the copy_on_share() flag COPY_FR_DEDUP
> https://lwn.net/Articles/659523/
> flags for copy_on_share() aren't implemented on the syscall yet. I
> guess that would be the way to go once those flags are used. We can use
> the ioctl method to implement it for the time being.
>
> removes the need for separate cifs ioctls to perform server side
> copies
> > > and hence can be removed.
> >
> > Isn't this breaking userspace? I understand it was a private ioctl
> > only
> > availaible in SMB3 so it's not a big issue but
>
> Yes. This is removed since we can now use the syscall to do the same
> thing. I am not aware of any utility which uses this. I am not sure if
> we need to first deprecate it before we remove it outright. Steve, can
> you please provide some advice here.


Although few tools were coded to use the ioctl, if an ioctl has more
specific behavior (calls a specific SMB fsctl in this case rather than
letting cifs.ko choose), it can have value, even if just for testing,
and also would make possible working around server file system bugs.


> > > @@ -250,9 +146,6 @@ long cifs_ioctl(struct file *filep, unsigned
> > > int command, unsigned long arg)
> > >                             cifs_dbg(FYI, "set compress flag
> > > rc %d\n", rc);
> > >                     }
> > >                     break;
> > > -           case CIFS_IOC_COPYCHUNK_FILE:
> > > -                   rc =3D cifs_ioctl_clone(xid, filep, arg);
> > > -                   break;
> > >             case CIFS_IOC_SET_INTEGRITY:
> > >                     if (pSMBFile =3D=3D NULL)
> > >                             break;
> >
> > I believe the ioctl will return -ENOTTY now. I remember this story
> > when
> > an error code was changed: https://lkml.org/lkml/2012/12/23/75 *gulp*
> > Maybe I'm overthinking this.
> >
> > Cheers,
> >
>
> Sachin Prabhu
