From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 06/16] CIFS: Fix cifs_writev_requeue when wsize changes
Date: Mon, 21 Jul 2014 10:43:18 +0400
Message-ID: <CAKywueRa9t5kdM1dGhTro-U5uqzV8a9r40u38VpWU6tghKFMhA@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-7-git-send-email-pshilovsky@samba.org>
	<CADT32e+kGf-b989EFr4c_-e9+_MCVMkDShkh_30an8YKLiD6Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+kGf-b989EFr4c_-e9+_MCVMkDShkh_30an8YKLiD6Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-20 23:49 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> why bother setting rc (to ENOTSUPP, ENOMEM) if those errors are not returned
> once we break out of do while loop?
> Instead perhaps log an error message?

Good point, thanks. It seems like we should call
mapping_set_error(mapping, rc) in the end of the function. In this
case setting rc looks ok. Also, I think we don't need to log messages
in this case.

-- 
Best regards,
Pavel Shilovsky.
