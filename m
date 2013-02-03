From: Kjell Braden <afflux-7cISTWZqsW8RLla1DLYS2Q@public.gmane.org>
Subject: Re: [PATCH] cifs: ensure that cifs_get_root() only traverses directories
Date: Sun, 03 Feb 2013 17:49:38 +0100
Message-ID: <510E9522.8040508@pentabarf.de>
References: <1359749461-13458-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359749461-13458-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2013-02-01 21:11, Jeff Layton wrote:
> When walking down the path on the server, it's possible to hit a
> symlink. The path walking code assumes that the caller will handle that
> situation properly, but cifs_get_root() isn't set up for it. This patch
> prevents the oops by simply returning an error.
>
> A better solution would be to try and chase the symlinks here, but that's
> fairly complicated to handle.


Hi,

  let me add that mounting paths below symlinks worked with the old path 
walking before commit fec11dd9a0109fe52fd631e5c510778d6cbff6cc.

  While it's not a big deal to work around this once the oops is fixed, 
it would be great if the regression could be fixed.

-- 
Kjell
