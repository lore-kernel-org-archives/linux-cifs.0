From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 11:28:28 -0500
Message-ID: <BANLkTikzfTm00+u5uBo1E7cO_JaRtZkMVQ@mail.gmail.com>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
	<20110422075007.2e9c303b@tlielax.poochiereds.net>
	<BANLkTinMswT8Sur+Kv5JGb3jbObKnSC1mg@mail.gmail.com>
	<20110422101050.1472e618@tlielax.poochiereds.net>
	<BANLkTi=OmEDN-iFv_Tjg96_WshcJTvaXyQ@mail.gmail.com>
	<20110422110724.0846b1b0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422110724.0846b1b0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 22, 2011 at 10:07 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Fri, 22 Apr 2011 09:54:10 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Apr 22, 2011 at 9:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Fri, 22 Apr 2011 09:02:18 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Fri, Apr 22, 2011 at 6:50 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> >> > On Fri, 22 Apr 2011 12:09:20 +0400
>> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >> >
>> >> >> After conversation with Steve, we decided to drop
>> >> >> filemap_write_and_wait from getattr, because we already do it =
in
>> >> >> cifs_file_aio_write. I also think that we should drop it from
>> >> >> cifs_llseek in this case too. I will repost this patch later (=
launder
>> >> >> page operation patch was merged earlier).
>> >> >>
>> >> >
>> >> > I wasn't privy to this discussion, but that makes no sense to m=
e. Just
>> >> > because we initiated writeout in cifs_file_aio_write, does not =
mean
>> >> > that it's complete. If it's not complete then the size returned=
 by the
>> >> > server may be bogus.
>> >>
>> >> What would a local file system do in the case when a write is
>> >> racing with a getattr? =A0In the case of cifs, when we issue
>> >> a write, and don't have oplock, we immediately send the
>> >> write on the network - but AFAIK posix provides no guarantees
>> >> about ordering if they are issued at the same time.
>> >>
>> >
>> > It's not a problem for a local filesystem as there's only one set =
of
>> > metadata to deal with. Even if the writes aren't synced out to dis=
k,
>> > you still know how big the file is.
>> >
>> > With a client/server setup like cifs or nfs, you have to deal with=
 two,
>> > and when there are buffered writes then there will be discrepancie=
s.
>> > The simplest way to deal with discrepancies there is to make sure
>> > that there aren't any by flushing out any buffered writes before
>> > fetching the attributes.
>>
>> it may sound simpler but doesn't prevent a write racing in just
>> before we send the QueryFileInfo on the wire, and it does
>> hurt performance to redundantly invoke filemap_fdatawrite.
>>
>
> IIUC, POSIX says that the st_size must reflect the results of all
> writes done up to the point that the stat() call was issued. If some
> race in after the fact, then that's generally ok, but we don't want a
> situation where someone issues a ton of writes and then the stat() ca=
ll
> doesn't reflect the result of them.

aio_write doesn't return until filemap_fdatawrite completes and it
calls cifs_writepages which is synchronous - so the st_size
on the server will be uptodate if the write has completed.

--=20
Thanks,

Steve
