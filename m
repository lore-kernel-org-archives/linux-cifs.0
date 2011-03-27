From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: don't allow mmap'ed pages to be dirtied while
 under writeback
Date: Sun, 27 Mar 2011 10:00:12 -0500
Message-ID: <AANLkTin3wa-b188+8FU1coKbnv0WpDNc_XuaYLQ952s3@mail.gmail.com>
References: <1300302931-13830-1-git-send-email-jlayton@redhat.com>
	<1300302931-13830-3-git-send-email-jlayton@redhat.com>
	<20110327073204.3e85ad65@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110327073204.3e85ad65-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I like this patch very much, but had been waiting for any
comments/ack/reviewed-by
one of those more familiar with this part of the mm layer.

Barring any objections, I plan to merge this (and the performance fix)
after some additional review today or tomorrow.

On Sun, Mar 27, 2011 at 6:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 16 Mar 2011 15:15:31 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> If a process has a dirty page mapped into its page tables, then it h=
as
>> the ability to change it while the client is trying to write the dat=
a
>> out to the server. If that happens after the signature has been
>> calculated then that signature will then be wrong, and the server wi=
ll
>> likely reset the TCP connection.
>>
>> This patch adds a page_mkwrite handler for CIFS that simply takes th=
e
>> page lock. Because the page lock is held over the life of writepage =
and
>> writepages, this prevents the page from becoming writeable until
>> the write call has completed.
>>
>> With this, we can also remove the "sign_zero_copy" module option and
>> always inline the pages when writing.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 | =A0 =A04 ---
>> =A0fs/cifs/cifsglob.h | =A0 =A01 -
>> =A0fs/cifs/file.c =A0 =A0 | =A0 62 ++++++++++++++++++++++++++-------=
-------------------
>> =A03 files changed, 31 insertions(+), 36 deletions(-)
>>
>
> Steve, can you let me know where we are with this patch? It's not
> merged and you haven't commented on it.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
