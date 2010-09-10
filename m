From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Thu, 9 Sep 2010 19:50:36 -0500
Message-ID: <AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 9, 2010 at 1:34 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> 2010/9/9 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Note that metadata caching is common for most network file systems
>> (not unique to cifs or nfs) - and is usually done on a timer.
>>
>> NFSv3 data caching is unsafe - no guarantees data makes it to server
>> until sync or close. =A0Generally if a file has not changed between
>> close and open - seems reasonable to keep the cached copy. =A0 If we
>
> As I mentioned in the first email, CIFS servers doesn't update mtime
> of a file every time and that brings complexity. So we can't be sure
> that we have actual data of a file in a cache.

Surely it is a serious bug if a server doesn't update the mtime by the
time the handle they used is closed.   If a client 1 does open/write/cl=
ose,
then client 2 does open/write/close, client 1 reopening the file should
see the updated mtime.   If client 2 had not closed the file yet - it
is not clear whether its write and mtime update will be processed
first - but we shouldn't be using cached data in that case - client 1 s=
hould
do an invalidate_mapping when it can't get an oplock (we do that alread=
y
in seek and mmap via revalidate e.g.).  In any case writes won't be cac=
hed
in that case - and the simplest change may be to invalidate the inode
cached pages in this reopen path - when the mtime/size matches but we
failed to get a read oplock.   Allowing us to turn off the 1 second tim=
eout
on metadata/data caching is already possible.

>> have two opens of the same file from different clients we won't be
>> caching anyway.

With no oplock we won't be caching writes - we do cache reads
in some cases (the intent originally was to do this for about 1 second)
but as you note we can cache longer


--=20
Thanks,

Steve
