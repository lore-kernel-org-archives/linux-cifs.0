From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 05/16] CIFS: Fix wsize usage in writepages
Date: Mon, 21 Jul 2014 11:03:59 +0400
Message-ID: <CAKywueTp2W4unkYaV2xcCJ=6rLut4jOQPyd+xj4ZJ+1eqwYa4g@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-6-git-send-email-pshilovsky@samba.org>
	<CADT32e+ce727VwQD6WmhY_SWG_Xm+2JxGuC2GnPZG==nv9FgxQ@mail.gmail.com>
	<CAKywueRP6y7gdyXCYVBCXQU3_65=rU7+cP-UdgBrO5cwx+_nCA@mail.gmail.com>
	<CADT32eK15DRUnrogmFFv2TicqhOhcNA0Y62dUeM+41YtjrZwFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK15DRUnrogmFFv2TicqhOhcNA0Y62dUeM+41YtjrZwFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-20 22:13 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel,
>
> That is correct, this patch does not change that functionality. I was
> thinking do we
> go through the loop again to attempt to acquire handle (only to
> perhaps receive EBADF)
> or bail out of cifs_writepages() by marking rest of the pages (till
> end) with error flags.

Understand. Probably we don't need to go through the loop since
find_writable_file() has it's own loop inside (it goes to the start of
the search if cifs_reopen_file() fails). So, the existing logic seems
right.
-- 
Best regards,
Pavel Shilovsky.
