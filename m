From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sun, 12 Sep 2010 20:16:21 +0400
Message-ID: <AANLkTi=LMy37zVnyKTX_gnf1QAqXja6vuTruVMjfRCdp@mail.gmail.com>
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
	<20100912114055.55520f0c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100912114055.55520f0c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> This should probably be a set of patches that outlines each change.
> There are 3, AFAICT:

Ok, no problem with this, I will post it soon.

> 1) it bypasses the cache for reads when we have no oplock. Seems
> straightforward.
>
> 2) the cache is invalidated on close. So, no caching of data between
> open and close. Again ugly for performance but good for strict cache
> consistency.
>
> 3) write_end is doing a single page synchronous write when there is no
> oplock. This is going to be really ugly. Anytime you don't have an
> oplock, you'll be doing PAGE_SIZE writes to the server. Why not instead
> simply have cifs_file_aio_write do a filemap_write_and_wait or
> something if it there is no oplock?

I think I didn't understand you in this case. Let's look on the code:

1622 >-------if (!PageUptodate(page) || !CIFS_I(inode)->clientCanCacheAll) {
1623 >------->-------char *page_data;
1624 >------->-------unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
1625 >------->-------int xid;
1626
1627 >------->-------xid = GetXid();
1628 >------->-------/* this is probably better than directly calling
1629 >------->-------   partialpage_write since in this function the
file handle is
1630 >------->-------   known which we might as well>leverage */
1631 >------->-------/* BB check if anything else missing out of ppw
1632 >------->-------   such as updating last write time */
1633 >------->-------page_data = kmap(page);
1634 >------->-------rc = cifs_write(file, page_data + offset, copied, &pos);

We are writing 'copied' bytes from 'offset' of 'page_data'. Why do you
think that we are doing PAGE_SIZE write to the server?

1635 >------->-------/* if (rc < 0) should we set writebehind rc? */
1636 >------->-------kunmap(page);
1637
1638 >------->-------FreeXid(xid);
1639 >-------} else {

-- 
Best regards,
Pavel Shilovsky.
