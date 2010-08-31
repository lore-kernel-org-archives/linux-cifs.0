From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: password visible in 'mount' output?
Date: Tue, 31 Aug 2010 15:43:01 -0400
Message-ID: <20100831154301.69a2274d@tlielax.poochiereds.net>
References: <4C7D3620.8070204@candelatech.com>
	<AANLkTi=ehgG3kxv1oBpvjzmLX0TLp-W8h=h7VJDWoBOb@mail.gmail.com>
	<4C7D5775.40206@candelatech.com>
	<AANLkTimZWTDZ--x9yNB0o93ET_EqkOro+v2oFrk4pjZ6@mail.gmail.com>
	<4C7D5A55.8090707@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7D5A55.8090707-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 31 Aug 2010 12:39:01 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> 
> >     Standard Fedora 13, as far as I can tell, and I have no mount.cifs
> >     in $PATH
> >
> >
> > You are right - if you are missing mount.cifs you will see what is
> > passed into previous mounts, including the password (and cifs can't
> > filter it out for you since this is being done by mount).   Not sure if
> > this is fixable though - you should have mount.cifs installed (when this
> > would not be a problem) and Fedora does package mount.cifs.
> 
> I installed 'cifs-utils', which provides /sbin/mount.cifs,
> but 'mount' output is the same.
> 
> [root@ct503-10G-09 lanforge]# mount.cifs -V
> mount.cifs version: 4.6
> 

Running "mount" without args just displays the contents of /etc/mtab.
If you did the mount previously and then installed mount.cifs, it won't
fix the contents of /etc/mtab. New mounts shouldn't store the password
in /etc/mtab though.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
