From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: regression in connectathon test7
Date: Mon, 13 Aug 2012 14:08:07 +0400
Message-ID: <CAKywueQfXe7MEmKu+-W09tDwyPvUar3qM+eWLZiNO3z-ngTu6Q@mail.gmail.com>
References: <20120807152822.3bbe468f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120807152822.3bbe468f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/8/7 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> If I mount up a SMB1 share without unix extensions, I get the following
> error when I run connectathon test7 on it now:
>
> # env NFSTESTDIR=/mnt/cifs/rawhide.test ./basic/test7
> ./basic/test7: link and rename
>         ./basic/test7: (/mnt/cifs/rawhide.test) file.0 has 2 links after unlink (expect 1) : No such file or directory
>
> This does not fail on 3.5.0. Pavel, is this something you've noticed in
> your testing?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

My Ubuntu machine doesn't boot with v3.6-rc1 kernel due to segfault.
It goes fine on 3.5 with smb2-basic branch changes. What kernel do you
use?

-- 
Best regards,
Pavel Shilovsky.
