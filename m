From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 05/16] CIFS: Fix wsize usage in writepages
Date: Sun, 20 Jul 2014 21:41:23 +0400
Message-ID: <CAKywueRP6y7gdyXCYVBCXQU3_65=rU7+cP-UdgBrO5cwx+_nCA@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-6-git-send-email-pshilovsky@samba.org>
	<CADT32e+ce727VwQD6WmhY_SWG_Xm+2JxGuC2GnPZG==nv9FgxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+ce727VwQD6WmhY_SWG_Xm+2JxGuC2GnPZG==nv9FgxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-20 19:17 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> How do we handle EBADF returned by wdata_send_pages() in cifs_writepages()?

If wdata_send_pages() returns -EBADF we do the same things like
without this patch: walk through the array of pages in wdata and set
page error flags.

-- 
Best regards,
Pavel Shilovsky.
