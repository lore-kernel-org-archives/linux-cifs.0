From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Introduce cifs_copy_file_range()
Date: Wed, 08 Feb 2017 16:11:47 +0100
Message-ID: <mpsfujoiuoc.fsf@aaptelpc.suse.de>
References: <20170207113311.11474-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207113311.11474-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Sachin,

Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> The patch introduces the file_operations helper cifs_copy_file_range().
>
> The vfs helper vfs_copy_file_range() first calls clone_file_range
> which for cifs uses
> SMB2_ioctl(.., FSCTL_DUPLICATE_EXTENTS_TO_FILE, ..)
> to do a server side copy of the file. This ioctl is only supported on
> SMB3 and later versions.
>
> Once this call fails, vfs_copy_file_range() calls copy_file_range()
> corresponding to the cifs filesystem which is introduced by this patch.
> This calls the more widely available
> SMB2_ioctl(.., FSCTL_SRV_COPYCHUNK_WRITE, ..)

Sounds good.

> The upstream changes in this area was first made by the commit
> 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
> This commit also introduces the ioctls FICLONE and FICLONERANGE which

IIUC it also allows the copy_file_range syscall defined in
fs/read_write.c to take advantage of the dup extents fsctl, if
available, nice!

Now, I wonder if there is a way to implement the FIDEDUPERANGE ioctl in
SMB3, which does the same thing as a clone but it exits early if the
destination does not already match the source.

> removes the need for separate cifs ioctls to perform server side copies
> and hence can be removed.

Isn't this breaking userspace? I understand it was a private ioctl only
availaible in SMB3 so it's not a big issue but

> @@ -250,9 +146,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  				cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>  			}
>  			break;
> -		case CIFS_IOC_COPYCHUNK_FILE:
> -			rc = cifs_ioctl_clone(xid, filep, arg);
> -			break;
>  		case CIFS_IOC_SET_INTEGRITY:
>  			if (pSMBFile == NULL)
>  				break;

I believe the ioctl will return -ENOTTY now. I remember this story when
an error code was changed: https://lkml.org/lkml/2012/12/23/75 *gulp*
Maybe I'm overthinking this.

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
