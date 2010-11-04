From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New write logic
Date: Thu, 4 Nov 2010 15:05:23 +0300
Message-ID: <AANLkTi=Y9mG9Dp-pkDqdv2QRnh8yQE+B6ZVXe2AP27V5@mail.gmail.com>
References: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya@mail.gmail.com>
	<20101102114350.59f41db2@tlielax.poochiereds.net>
	<AANLkTi=HMTsqLXoVPkE=0CitmyXTV110KPDNSZ6fOp=w@mail.gmail.com>
	<20101103071456.27ed871b@tlielax.poochiereds.net>
	<20101103073403.04e8fc02@tlielax.poochiereds.net>
	<AANLkTikp5fvgvo+AM-jgqP7q_sfkjdPVKzNdRv5tDpNN@mail.gmail.com>
	<20101104074354.26519de0@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101104074354.26519de0-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> This can make sense only if we don't have oplock for reading. If we
>> have it - why do wee need to read from the server the data that we can
>> store and read from the cache? I don't think it's good for oplock
>> level II situation.
>>
>> So, in this case we can check if we have oplock level II and call
>> generic_file_aio_write only in this case - otherwise simply invalidate
>> the region of the file write call affects. What do you think about
>> this idea?
>>
>
> That's exactly what I meant -- sorry if I wasn't clear...

No problem. I will create a new patch for strict cache semantic for mmap.

>
>> > Also, I still haven't seen a description of what the semantics for mmap
>> > will be in this case. If I'm using strict caching and mmap a file, it
>> > obviously isn't going to read/write through every time userspace
>> > touches the memory. What can I expect to happen when I read or write to
>> > that mmap? How can I ensure that new data will be faulted in or data
>> > that I write will be synced out?
>>
>> Good point about mmap. Thanks!
>>
>> In mmap call we can invalidate inode pages if we don't have an oplock
>> for reading. As for mandatory locks problem - I don't think we can
>> deal with this problem without large code changes. So, I suggest to
>> leave it the same. Do you have any other ideas?
>>
>
> The situation today is already pretty broken, but this is an
> opportunity to try and add some forethought and sanity to how it
> works.
>
> Mixing mmap'ed and "regular" I/O on an inode is probably going to
> be pretty problematic with strict caching. You'll be reading and
> writing through with the regular I/O but the pagecache (and hence the
> mmap) won't see the results of those operations.
>
> What we ought to do though, is make sure that when someone does a
> msync() on a mmapped region, that they can expect to see the latest
> contents of the inode as well as flush out any dirty pages.
>
> I think you should also consider adding a patch to invalidate the cache
> on msync if we don't have an oplock in the strict cache case. It might
> not also hurt to do that in the non-strict case too.

Ok, I will add this to mmap patch mentioned above.

-- 
Best regards,
Pavel Shilovsky.
