From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Invaldate remote inode on the last close
Date: Tue, 21 Sep 2010 20:17:30 +0400
Message-ID: <AANLkTinc=U--c53LOyAtfSv1zwzouy_+EoEjYxJdVNyn@mail.gmail.com>
References: <AANLkTinQO5yM7uSPFhz3NYrQNAiyWbHcEi_3o4mBMUZy@mail.gmail.com>
	<20100918073718.17c04a83@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100918073718.17c04a83-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This doesn't look complete. cifs_open_inode_helper will not get called
> in the POSIX open case. It would also be good to accompany this change
> with a cleanup patch that definitively sets the clientCanCache flags in
> single place (or places). Right now, it gets set in both the
> *open_inode_helper routines and in cifs_new_fileinfo. One of those
> places should be eliminated.
>

Yes, I missed posix part. What's about different places where we set
clietnCachCache fields - it seems like it fixed by patch "cifs: fix
broken oplock handling" sent by Suresh Jayaraman.

-- 
Best regards,
Pavel Shilovsky.
