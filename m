From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: implement clone_file_range operation
Date: Fri, 27 Nov 2015 11:42:32 +0100
Message-ID: <20151127114232.5b367b7b@g21.suse.de>
References: <1448563859-21922-1-git-send-email-hch@lst.de>
	<1448563859-21922-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448563859-21922-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Christoph,

On Thu, 26 Nov 2015 19:50:55 +0100, Christoph Hellwig wrote:

> And drop the fake support for the btrfs CLONE ioctl - SMB2 copies are
> chunked and do not actually implement clone semantics!

BTRFS_IOC_CLONE is implemented using the new ReFS
=46SCTL_DUPLICATE_EXTENTS_TO_FILE request, which was deemed to be COW
based[1]:

"The purpose of this operation is to make it look like a copy of a
 region from the source stream to the target stream has occurred when
 in reality no data is actually copied. This operation modifies the
 target stream=E2=80=99s extent list such that, the same clusters are p=
ointed
 to by both the source and target streams=E2=80=99 extent lists for the=
 region
 being copied."

I think that's about as close as we're going to get to clone semantics
for cifs. It's also dispatched as a single request covering the full
file - chunking only occurs for CIFS_IOC_COPYCHUNK_FILE based requests,
which are implemented using FSCTL_SRV_COPYCHUNK_WRITE, and not (always)
handled by the server as a COW clone.

It looks like there's also a minor cut 'n paste error here...

> @@ -942,6 +960,8 @@ const struct file_operations cifs_file_strict_ops=
 =3D {
>  	.splice_read =3D generic_file_splice_read,
>  	.llseek =3D cifs_llseek,
>  	.unlocked_ioctl	=3D cifs_ioctl,
> +	.copy_file_range =3D cifs_file_copy_range,
> +	.copy_file_range =3D cifs_file_copy_range,

Cheers, David

1. FSCTL_DUPLICATE_EXTENTS_TO_FILE discussion
https://lists.samba.org/archive/samba-technical/2015-February/105410.ht=
ml
