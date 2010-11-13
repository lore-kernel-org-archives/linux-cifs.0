From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache mode
Date: Sat, 13 Nov 2010 21:07:41 +0300
Message-ID: <AANLkTinuJmeK5gL2smp9RiQ9gKxTr8bPY6Mhk3u1-Kj1@mail.gmail.com>
References: <1289403711-12965-1-git-send-email-piastryyy@gmail.com>
	<1289403711-12965-2-git-send-email-piastryyy@gmail.com>
	<20101113070735.060ac5ca@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101113070735.060ac5ca-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>
> I don't see why the above is necessary. cifs_revalidate_dentry should
> have taken care of invalidating the mapping when it revalidated the
> dentry.
>
> Also, you're leaving invalid_mapping set so you're almost certainly
> going to end up invalidating the mapping unnecessarily again.
>
> Finally, you're not considering the fscache case here. I think you need
> to look closely at how dentry/inode revalidation is handled -- in
> particular cifs_revalidate_dentry and cifs_invalidate_mapping.
>

Jeff, you are right about leaving invalid_mapping set - I noticed it
after some time I posted this patch. So - I reposted it in the list
again. Let's consider this version as invalid.

-- 
Best regards,
Pavel Shilovsky.
