From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sun, 12 Sep 2010 16:19:46 -0500
Message-ID: <AANLkTi=x6gnS=++JtjEG6KVwq4_JPLfU+pKuCYgFd+xD@mail.gmail.com>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
	<AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
	<AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR-@mail.gmail.com>
	<20100910081549.41de32d1@corrin.poochiereds.net>
	<AANLkTi=5YgKzG=rXJ5MuV+R_MGkEd+2ERouUiEc8K5B8@mail.gmail.com>
	<20100910185002.73e61b8b@tlielax.poochiereds.net>
	<AANLkTik_=xi5Engkm4Xcrk_WUaXSsSAsWUhh=M8VYWer@mail.gmail.com>
	<20100912091659.73ef9cdb@tlielax.poochiereds.net>
	<AANLkTi=gSm+=djrj796Gfjx9FiRQ7s==6DSV=DhYOk7U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=gSm+=djrj796Gfjx9FiRQ7s==6DSV=DhYOk7U-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 12, 2010 at 9:55 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2010/9/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> That's just because our client is primitive in this regard. When an
>> oplock break comes in, it always drops the entire oplock rather than
>> trying to downgrade it.
>>
>> Notice that when the client sends the "reply" that it's actually a
>> request. The client never sends an actual "response" to an oplock
>> break. What it does is send a new LOCKING_ANDX request to the server
>> with a Lock Type of oplock break (0x02) and an oplock level of 0.
>>
>> My interpretation has always been that this "response" from the client
>> tells the server what new oplock level the client has elected to take.
>> In this case, it elected to drop the lock altogether so the server has
>> no need to send a new oplock break.
>
> You can find the code (misc.c, is_valid_oplock_break call) that
> downgrades the oplock for the client according to the field
> NewOplockLevel in Oplock Break sent by the server. But then you can
> see that in cifs_oplock_break call (file.c) the client simply sends
> acknowledge without setting any OplockLevel specific things.

We already downgrade olocks.  I don't think we have seen problems with the
downgrade from "cache everything" to "cache only reads" -  I don't think
the client "response" to the oplock downgrade has to set additional flags in
the "response" to the oplock break.

>> I'll concede though that the spec is nebulous here. It might be
>> worthwhile to make a dochelp request to MS on this point.



-- 
Thanks,

Steve
