From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: oplock break problem
Date: Fri, 13 Jul 2012 17:12:51 +0400
Message-ID: <CAKywueQRbQQGq41E8KRaQ4m0dj7H+4YZ-emQ3sQEAp9s66qUUA@mail.gmail.com>
References: <CAKywueS6zSQr_8cvQ64XNrVXR23Kwz4tc_BAd-9aP2wJGa0hMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS6zSQr_8cvQ64XNrVXR23Kwz4tc_BAd-9aP2wJGa0hMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/13 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi there!
>
> I faced with an interesting problem:
> Windows 7 send lease break just after granted lease on open - so, we
> don't have time to populate cifsFileInfo structure and can't determine
> oplock break because we simply don't find appropriate fid. I think
> this problem can be happen for CIFS/SMB2.0 too (e.g. if another client
> opens the file just after us).
>
> So, what do you think about creating delegating the oplock break
> processing to workqueue and return to demultiplex thread immideately?
> It give us a small timeout itself and we can set another defined
> timeout explicitly.
>
> --
> Best regards,
> Pavel Shilovsky.

I created a patch that fixes the problem for lease breaks - we can do
smth similiar for oplock breaks too:

http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=b918551247997057f4467dfc332d47c547449ddd

-- 
Best regards,
Pavel Shilovsky.
