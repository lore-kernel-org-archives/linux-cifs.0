From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add wine mount option (try #2)
Date: Fri, 15 Apr 2011 13:50:14 +0400
Message-ID: <BANLkTimbrHCPWPw9uT=dsGLZrj-zp48JPg@mail.gmail.com>
References: <1302435874-11073-1-git-send-email-piastry@etersoft.ru>
	<20110412101649.0d760e94@corrin.poochiereds.net>
	<BANLkTinvjvUV2UUyo=7B+ZCLfOY7qAabHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinvjvUV2UUyo=7B+ZCLfOY7qAabHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/12 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> 2011/4/12 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> On Sun, 10 Apr 2011 15:44:34 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> Add wine mount option that switches on WINE-capability mode - forward
>>> pid of a process who opened a file to any read and write operation.
>>>
>>> This can prevent WINE program from failing on read or write operation
>>> on a previously locked file region from the same file descriptor, because
>>> while a run of WINE program two processes work on the same file descriptor:
>>> 1) WINE-application does read and write on a file;
>>> 2) WINE-server does open and lock.
>>>
>>> Also switch on strictcache and forcemand modes because WINE needs to work
>>> with mandatory brlocks and does read and write operations correctly with
>>> them.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>
>> As a general rule, I'm not too fond of enshrining application behavior
>> into a mount option like this. What if wine changes their
>> implementation in the future?
>
> I don't think that WINE will change such an architecture thing but, if
> it will happen, I don't see any problems to change 'wine' mount
> options behavior for cifs too. Anyway, it is better to support
> existing WINE than don't do it, I think.
>
>>
>> Would it make more sense to have one mount option that enables this
>> new mode of PID handling, and keep forcemand and strictcache separate?
>
> So, I agree that having these mount options separately is more
> flexible, but I can't imagine how WINE can be correctly used without
> forcemand and strictcache mount options on cifs for applications that
> use brlocks actively. Anyway, I don't insist on it. Steve, Shirish,
> Suresh, what do you think about it?

What's about this?

-- 
Best regards,
Pavel Shilovsky.
