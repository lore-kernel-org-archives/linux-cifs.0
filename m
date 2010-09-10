From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Fri, 10 Sep 2010 08:15:49 -0400
Message-ID: <20100910081549.41de32d1@corrin.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
	<AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
	<AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR--JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 Sep 2010 11:50:05 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/10 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > Surely it is a serious bug if a server doesn't update the mtime by =
the
> > time the handle they used is closed. =A0 If a client 1 does open/wr=
ite/close,
> > then client 2 does open/write/close, client 1 reopening the file sh=
ould
> > see the updated mtime. =A0 If client 2 had not closed the file yet =
- it
> > is not clear whether its write and mtime update will be processed
> > first - but we shouldn't be using cached data in that case - client=
 1 should
> > do an invalidate_mapping when it can't get an oplock (we do that al=
ready
> > in seek and mmap via revalidate e.g.). =A0In any case writes won't =
be cached
> > in that case - and the simplest change may be to invalidate the ino=
de
> > cached pages in this reopen path - when the mtime/size matches but =
we
>=20
> I mean the situation then we have this file opened by another file ha=
ndle. E.g.:
>=20
> 1) client1 opens file as f1.
> 2) client1 writes 'a' into f1 from the beginning.
> 3) client2 opens file as f2.
> 4) client2 writes 'x' into f2 to the beginning,
> 5) client1 opens file as f3.
> 6) client1 reads from f3 and get 'a'!!! But it must be 'x'!
>=20
> I attached this test 'mtime_problem.py' and the capture
> 'mtime_problem.pcap'. On the capture you can see that client1 gets
> from the server the same mtime for f3 as it was for f1 - so, the
> server didn't apply mtime after client1 and client2 wrote the data to
> the server.
>=20

I think you may be confusing things a bit. The problem isn't so much
that the server is delaying mtime updates but rather that the client is
buffering up the writes. In that situation the server won't be aware of
changes to the file and hence won't update the mtime.

The real question is...should we expect that the above works without
any sort of locking? The answer for NFS has always been "no" --
concurrent accesses to the same file by multiple clients should be
serialized by posix locks or your results will be inconsistent. To this
end, the NFS client flushes all writes on an unlock and revalidates the
file's metadata on a lock operation.

CIFS is a different beast however and we have to deal with interaction
from clients like windows that expect different behavior. So it may
make sense to always write/read through unless we have an oplock (or a
real file lock).

Dealing with mmap this way though is likely to be extra tricky however.

> > failed to get a read oplock. =A0 Allowing us to turn off the 1 seco=
nd timeout
> > on metadata/data caching is already possible.
>=20
> About LookupCacheEnabled, I turned it off when I was running my tests
> cache_problem.py and mtime_problem.py but the results were the same.
>=20

Yeah, I wouldn't expect that to affect much of anything.

> >
> >>> have two opens of the same file from different clients we won't b=
e
> >>> caching anyway.
> >
> > With no oplock we won't be caching writes - we do cache reads
> > in some cases (the intent originally was to do this for about 1 sec=
ond)
> > but as you note we can cache longer
> >
>=20
> About writes:
>            written =3D generic_file_aio_write(iocb, iov, nr_segs, pos=
);
>            if (!CIFS_I(inode)->clientCanCacheAll)
>                    filemap_fdatawrite(inode->i_mapping);
>            return written;
>=20
> If we don't have write oplock, we always return written value (got
> after generic_file_aio_write), but there is no checks if we fails on
> filemap_fdatawrite (e.g. if another client has this file opened and
> obtains mandatory byte-range lock on it). So, a user always think tha=
t
> his write is complete successfully, but it can be wrong!
>=20

filemap_fdatawrite starts up a flush of the writes but doesn't wait for
it to complete. The data is cached however. If there's a problem
writing out the data to the server that gets reported at fsync or
close. That's consistent with POSIX. We're not required to report
errors flushing the data until that time.

> There is another problem with Oplocks: The server sends Oplock break
> notification into only one tcon provided by the client. But now in
> CIFS code architecture we have no connections between several
> connections to the same share - that's why we set Oplock to None only
> on one tcon, but another leaves the same (with Oplock Level II). In
> this case when we try to read by the second tcon from the file we
> think that we have Oplock for reading and read from the cache - it
> wrong!
>=20
> The above situation you can see on the same capture
> 'mtime_problem.pcap': the server sends Oplock break to None Oplock
> only to the FID 0x0002, but no requests for FID 0x0001!
>=20

I see both oplocks being broken:

0x0001: frames 57 and 60
0x0002: frames 65 and 66

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
