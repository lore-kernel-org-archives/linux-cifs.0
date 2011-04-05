From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: slash appended to filesystem when mtab symlinked to proc
Date: Tue, 5 Apr 2011 08:51:47 -0700
Message-ID: <20110405085147.22dc6829@corrin.poochiereds.net>
References: <4D99D6A1.7080101@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D99D6A1.7080101-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 04 Apr 2011 16:33:05 +0200
Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:

> Hi
> 
> A Debian user reported a bug that a slash gets appended to the
> filesystem when he mounts a share. This only happens when mtab is
> symlinked to proc which I can reproduce:
> 
> $ grep cifs /etc/fstab
> //<host>/<path>	/mnt	cifs	user,user=<username>	0	0
> 
> $ mount /mnt
> 
> $ grep cifs /etc/mtab
> //<host>/<path>/ /mnt cifs
> rw,nosuid,nodev,relatime,unc=\\<host>\<path>,username=<username>,uid=1000,forceuid,gid=1000,forcegid,addr=<ip>,file_mode=0755,dir_mode=0755,serverino,rsize=16384,wsize=57344
> 0 0
> 
> $ umount /mnt
> umount: /mnt mount disagrees with the fstab
> 
> There does not seem to be any other filesystems that append a slash to
> the filesystem in proc. Does cifsfs do that intentionally (in which case
> the client should cope with it: by means of umount.cifs?) or should it
> get fixed in the kernel (maybe the client should still cope with it)?
> 
> Can you give me a hand in identifying the code that would need to be
> updated to fix this so I can prepare a patch?
> 
> Cheers
> 
> Luk

mount.cifs will convert the delimiters in the "device string" to
forward slashes (in case someone specifies a UNC with backslashes) and
then passes it down to the kernel. When it does this, it adds an
unnecessary '/' to the end. Probably what we need to do is make it pass
down the "original" device string to the kernel mount() call.

The reason mount.cifs does this though is because /proc/mounts turns
'\\' into an escaped number string. So, in addition to changing
mount.cifs to fix this, the kernel routines that format /proc/mounts
should also be fixed to handle backslashes correctly.

Cheers,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
