From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sun, 12 Sep 2010 20:09:16 -0400
Message-ID: <20100912200916.1df5d752@corrin.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
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
	<AANLkTi=LMy37zVnyKTX_gnf1QAqXja6vuTruVMjfRCdp@mail.gmail.com>
	<20100912125535.60c3c897@tlielax.poochiereds.net>
	<AANLkTi=XT_X27Cuioe_M6zMee0XQAZe+P-TLHbh6n+Yk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=XT_X27Cuioe_M6zMee0XQAZe+P-TLHbh6n+Yk-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 12 Sep 2010 23:14:35 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > write_begin/write_end are called on each page in a write syscall. So if
> > your application is writing in 64k page-aligned chunks, write_end will
> > be called 16 times. When you have no oplock with this patch, for each
> > call to write_end, you're calling cifs_write which will flush each
> > single page synchronously and only that single page to the server. Your
> > 64k write will take 16 round trips to the server to complete.
> >
> > What you probably want to do instead is populate the pagecache with the
> > write contents (as is done today), flush the write and wait on the
> > result. Optionally, you could then invalidate the cache to free up the
> > pagecache pages (though you'll need to take care not to race with other
> > writers).
> 
> Ok, I understand you. What do you think about the following idea?
> 
> 1) if we don't have an exclusive oplock, we write the data to the
> server before do_sync_write but in cifs_write_end we don't mark the
> page as dirty and don't write to the server;
>
> 2) if we have an exclusive oplock, we don't write the data before
> do_sync_write and mark page as dirty in cifs_write_end (again we don't
> write anything to the server in cifs_write_end);
> 

Sorry, I'm not quite following what you mean here. I don't think you
need to mess with cifs_write_end at all.

What I think you basically want to do is replace the filemap_fdatawrite
clause in cifs_file_aio_write with a filemap_write_and_wait. If you
want to get a little more fancy, you could just have it flush the range
of the file actually being written.

After that, you could also consider invalidating the pages in the
mapping (thereby allowing the VM to reclaim them) if you don't have an
oplock.

IOW, you want to write to the pagecache regardless of whether you have
an oplock or not. The oplock only decides whether you flush the data to
the server and wait on the result after writing to the pagecache.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
