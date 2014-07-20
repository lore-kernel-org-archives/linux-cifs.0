From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 05/16] CIFS: Fix wsize usage in writepages
Date: Sun, 20 Jul 2014 13:13:40 -0500
Message-ID: <CADT32eK15DRUnrogmFFv2TicqhOhcNA0Y62dUeM+41YtjrZwFg@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-6-git-send-email-pshilovsky@samba.org>
	<CADT32e+ce727VwQD6WmhY_SWG_Xm+2JxGuC2GnPZG==nv9FgxQ@mail.gmail.com>
	<CAKywueRP6y7gdyXCYVBCXQU3_65=rU7+cP-UdgBrO5cwx+_nCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRP6y7gdyXCYVBCXQU3_65=rU7+cP-UdgBrO5cwx+_nCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,

That is correct, this patch does not change that functionality. I was
thinking do we
go through the loop again to attempt to acquire handle (only to
perhaps receive EBADF)
or bail out of cifs_writepages() by marking rest of the pages (till
end) with error flags.


On Sun, Jul 20, 2014 at 12:41 PM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 2014-07-20 19:17 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> How do we handle EBADF returned by wdata_send_pages() in cifs_writepages()?
>
> If wdata_send_pages() returns -EBADF we do the same things like
> without this patch: walk through the array of pages in wdata and set
> page error flags.
>
> --
> Best regards,
> Pavel Shilovsky.
