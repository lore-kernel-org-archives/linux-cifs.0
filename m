From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 16:13:06 -0600
Message-ID: <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<1299707686-sup-6871@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299707686-sup-6871@think>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 9, 2011 at 3:58 PM, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -0500:
>> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
>> > Have alternative approaches, other than using wait_on_page_writeba=
ck,
>> > been considered for solving the stable page write problem in simil=
ar
>> > cases (since only about 1 out of 5 linux file systems uses this ca=
ll
>> > today).
>>
>> I think that is incorrect. write_cache_pages() does:
>>
>> =A0929 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_page(pag=
e);
>> .....
>> =A0950 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (PageWrite=
back(page)) {
>> =A0951 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 if (wbc->sync_mode !=3D WB_SYNC_NONE)
>> =A0952 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 wait_on_page_writeback(page);
>> =A0953 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 else
>> =A0954 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 goto continue_unlock;
>> =A0955 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0956
>> =A0957 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(PageWr=
iteback(page));
>> =A0958 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!clear_pa=
ge_dirty_for_io(page))
>> =A0959 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 goto continue_unlock;
>> =A0960
>> =A0961 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_wbc_wri=
tepage(wbc, mapping->backing_dev_info);
>> =A0962 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D (*wri=
tepage)(page, wbc, data);
>>
>> so every filesystem using the generic_writepages code already does
>> this check and wait before .writepage is called. Hence only the
>> filesystems that do not use generic_writepages() or
>> mpage_writepages() need a specific check, and that means most
>> filesystems are actually waiting on writeback pages correctly.
>
> But checking here just means we don't start writeback on a page that =
is
> writeback, which is a good idea but not really related to stable page=
s?
>
> stable pages means we don't let mmap'd pages or file_write muck aroun=
d
> with the pages while they are in writeback, so we need to wait in
> file_write and page_mkwrite.

Isn't the file_write case covered by the i_mutex as
Documentation/filesystems/Locking implies (for write_begin/write_end).


--=20
Thanks,

Steve
