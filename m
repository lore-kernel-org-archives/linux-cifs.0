From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: regression in connectathon test7
Date: Mon, 13 Aug 2012 08:52:29 -0500
Message-ID: <CAH2r5mvv+uP=cC9BYi2YVTXD=_vnPoNHm5rfCSezhGp+vX07jg@mail.gmail.com>
References: <20120807152822.3bbe468f@tlielax.poochiereds.net>
	<CAKywueQfXe7MEmKu+-W09tDwyPvUar3qM+eWLZiNO3z-ngTu6Q@mail.gmail.com>
	<20120813064916.1964e77b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120813064916.1964e77b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 13, 2012 at 5:49 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 13 Aug 2012 14:08:07 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2012/8/7 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> > If I mount up a SMB1 share without unix extensions, I get the following
>> > error when I run connectathon test7 on it now:
>> >
>> > # env NFSTESTDIR=/mnt/cifs/rawhide.test ./basic/test7
>> > ./basic/test7: link and rename
>> >         ./basic/test7: (/mnt/cifs/rawhide.test) file.0 has 2 links after unlink (expect 1) : No such file or directory
>> >
>> > This does not fail on 3.5.0. Pavel, is this something you've noticed in
>> > your testing?
>> >
>> > --
>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>> My Ubuntu machine doesn't boot with v3.6-rc1 kernel due to segfault.
>> It goes fine on 3.5 with smb2-basic branch changes. What kernel do you
>> use?
>>
>
> It was a 3.6.0-rc1 kernel.
>

my test kernel is just before 3.6.0-rc1 but very close to that


-- 
Thanks,

Steve
