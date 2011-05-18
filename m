From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: serverino by default?
Date: Wed, 18 May 2011 13:43:12 -0400
Message-ID: <20110518134312.39b9e505@corrin.poochiereds.net>
References: <BANLkTimDt8oOdzD9LpJAu4OyA6g8vOafrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimDt8oOdzD9LpJAu4OyA6g8vOafrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 May 2011 23:54:27 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> In mount.cifs.8 page we have: "Client generates inode numbers (rather
> than using the actual one from the server) by default", but if we look
> at the code we can see that
> we use server's numbers by default instead:
> 
> http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=blob;f=fs/cifs/connect.c;h=277262a8e82f282d4a32b0ddd4a244bc55e99472;hb=221d1d797202984cb874e3ed9f1388593d34ee22#l859
> 
> So, where is a error?
> 


I'm not sure it's an error per-se, but the manpage is unclear and
poorly-worded:

       noserverino
           Client generates inode numbers (rather than using the actual one
           from the server) by default.

I think that the intent was to say that when noserverino is used, it
generates it generates inode numbers by default. That makes it sounds
though like it may use server inode numbers in some cases which is of
course incorrect.

The default is to use server inode numbers (or uniqueid's) if they are
available and can reliably be used on the client (i.e. aren't
autodisabled). Care to propose a patch to clarify the manpage?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
