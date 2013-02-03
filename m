From: Kjell Braden <afflux-7cISTWZqsW8RLla1DLYS2Q@public.gmane.org>
Subject: Re: [PATCH] cifs: ensure that cifs_get_root() only traverses directories
Date: Sun, 03 Feb 2013 17:54:06 +0100
Message-ID: <510E962E.5090103@pentabarf.de>
References: <1359749461-13458-1-git-send-email-jlayton@redhat.com> <510E9522.8040508@pentabarf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510E9522.8040508-7cISTWZqsW8RLla1DLYS2Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2013-02-03 17:49, Kjell Braden wrote:
>    let me add that mounting paths below symlinks worked with the old path
> walking before commit fec11dd9a0109fe52fd631e5c510778d6cbff6cc.

Sorry, forgot specifics:

Consider the following tree:

   /srv/symtest
   /srv/symtest/dir
   /srv/symtest/dir/subdir/
   /srv/symtest/link -> dir/
   /srv/symtest/abslink -> /

this works:
    # mount.cifs //smbsrv/symtest/dir/subdir/ /mnt/

this causes oops but worked before fec11dd9a0:
    # mount.cifs //smbsrv/symtest/link/subdir/ /mnt/

this fails with ENOTDIR, both before fec11dd9a0 and after:
    # mount.cifs //smbsrv/symtest/abslink/srv/symtest/dir/subdir/ /mnt/
