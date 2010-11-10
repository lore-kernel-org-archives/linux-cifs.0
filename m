From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
Date: Wed, 10 Nov 2010 18:54:00 +0300
Message-ID: <AANLkTinLk9AUDGkuXQ6FX5zAg5VxN-sX9CQXoxCZAFg7@mail.gmail.com>
References: <1289403711-12965-4-git-send-email-piastryyy@gmail.com>
	<1289404251-13066-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289404251-13066-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/10 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On strict cache mode if we don't have Exclusive oplock we write a data to
> the server through cifs_user_write. Then if we Level II oplock store it in
> the cache, otherwise - invalidate inode pages affected by this writing.

I am very sorry about this spam. I am going to post right version of
the patch further.

-- 
Best regards,
Pavel Shilovsky.
