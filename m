From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: blocking write() after disconnecting cifs server
Date: Fri, 10 Jan 2014 20:45:41 -0600
Message-ID: <CADT32e+kXX-b15QDVt2p0LYittdQZts2_S6pnnJtU8mFAyc7Qg@mail.gmail.com>
References: <trinity-9dbe46e3-d6e6-4e61-84cc-98074cd0fea3-1386076567862@3capp-gmx-bs38>
	<20131223054643.4f6c06c9@tlielax.poochiereds.net>
	<trinity-2ffa0afb-c02b-46c6-9e2e-31b209aebd8b-1388678667254@3capp-gmx-bs34>
	<20140102143157.3232068c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: mail654-Mmb7MZpHnFY@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140102143157.3232068c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I think there are two things going on.

The flusher thread for the backing device is blocked trying to
reconnect.  So no dirty pages are getting flushed out.

Meanwhile application thread just keeps writing to the page cache.

So both threads are oblivious to each other.

Should not cifs check, somehow, that an app is dirtying too many
pages and just error out the writes and mark error bits on all dirty
pages of this app?




On Thu, Jan 2, 2014 at 1:31 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 2 Jan 2014 17:04:27 +0100 (CET)
> mail654-Mmb7MZpHnFY@public.gmane.org wrote:
>
>> > > write() from cifs kernel driver blocks when disconnecting the cifs server. The blocking call didn't return after 30 minutes. Client and server are connected via a switch and server's LAN cable is unplugged during the write call. I use kernel 3.11.8 and mounted without "hard" option.
>> > >
>> > > Is there a possibility for an non-blocking write() without using O_SYNC or "directio" mount option?
>> > >
>> > > Way to reproduce the scenario: Below is a sample program which calls write() in a loop. The error messages appear when unplugging the cable during this loop.
>> > >
>> > > Kind regards,
>> > > Hagen
>> > >
>> > > CIFS VFS: sends on sock ffff88003710c280 stuck for 15 seconds
>> > > CIFS VFS: Error -11 sending data on socket to server
>> > >
>> > > #include <fstream>
>> > > #include <iostream>
>> > > int main () {
>> > >   const int size = 100000;
>> > >   char buffer[size];
>> > >   std::ofstream outfile("/mnt/new.bin",std::ofstream::binary);
>> > >   if (!outfile.is_open())
>> > >   {
>> > >     return 1;
>> > >   }
>> > >   for (int idx=0; idx<10000 && outfile.good(); idx++)
>> > >   {
>> > >     outfile.write(buffer,size);
>> > >     std::cout << "written, size=" << size << std::endl;
>> > >   }
>> > >   std::cout << "finished " << outfile.good() << std::endl;
>> > >   outfile.close();
>> > >   return 0;
>> > > }
>> >
>> > A hang of that length is unexpected. If you're able to reproduce this,
>> > can you get the stack from the task issuing the write at the time?
>> >
>> >     $ cat /proc/<pid>/stack
>> >
>> > That might give us a clue as to what it's doing.
>>
>> [<ffffffff8170ab8c>] balance_dirty_pages.isra.19+0x4ac/0x55c
>> [<ffffffff8115455b>] balance_dirty_pages_ratelimited+0xeb/0x110
>> [<ffffffff81148f3a>] generic_perform_write+0x16a/0x210
>> [<ffffffff8114903d>] generic_file_buffered_write+0x5d/0x90
>> [<ffffffff8114aa66>] __generic_file_aio_write+0x1b6/0x3b0
>> [<ffffffff8114acc9>] generic_file_aio_write+0x69/0xd0
>> [<ffffffffa03ef225>] cifs_strict_writev+0xa5/0xd0 [cifs]
>> [<ffffffff811b2b95>] do_sync_readv_writev+0x65/0x90
>> [<ffffffff811b4312>] do_readv_writev+0xd2/0x2b0
>> [<ffffffff811b452c>] vfs_writev+0x3c/0x50
>> [<ffffffff811b46a2>] SyS_writev+0x52/0xc0
>> [<ffffffff8172976f>] tracesys+0xe1/0xe6
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>
> Looks like it's stuck in dirty page throttling.
>
> What's likely happening is that you have a bunch of dirty pages when
> you go to pull the cable. At that point the system is trying to flush
> the pages so that this task can try to dirty more of them.
>
> What *should* happen (at least if this is a soft mount) is that the
> writeback of those pages eventually times out, the pages get their
> error bit set and eventually the write() syscalls go through.
>
> Have you tried stracing this and are able to tell that the write
> syscall never returns in this situation? Is it possible that the
> write() syscalls are returning, albeit slowly?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
