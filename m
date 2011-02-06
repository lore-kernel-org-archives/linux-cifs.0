From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sun, 6 Feb 2011 13:44:20 -0500
Message-ID: <20110206134420.75ddcd5e@tlielax.poochiereds.net>
References: <AANLkTimnN_LKnGdVgqBC0rMBVApN+Qn5bzOzv28Y=9eh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimnN_LKnGdVgqBC0rMBVApN+Qn5bzOzv28Y=9eh-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 6 Feb 2011 10:45:33 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The following changes since commit afe8a887550f7cc24eb16449670b93f6b43c32d8:
> 
>   Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
> (2011-02-02 10:23:58 +1100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master
> 
> Jeff Layton (3):
>       cifs: fix length vs. total_read confusion in cifs_demultiplex_thread
>       cifs: enable signing flag in SMB header when server has it on
>       cifs: don't send an echo request unless NegProt has been done
> 

I don't think the last patch is quite ready, which is why I haven't
posted it to the list. In any case, I have some follow-on patches that
should fix it. Pushing to Linus now is fine, but we'll need to follow
up with another one soon.

Also, are you planning to push this patch to Linus in the near future?

    cifs: don't always drop malformed replies on the floor

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
