From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: locking around modifications to i_nlink
Date: Fri, 27 Jul 2012 11:48:39 -0500
Message-ID: <CAH2r5muYbJrPYXtnAikVt1Sf_O7bdGsH7qLs=vjJ_EALXJDeQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Presumably to address the cifs equivalent of NFS bug (drop_nlink warning):

https://bugzilla.redhat.com/show_bug.cgi?id=822703

your patch which wraps drop_nlink in i_lock spinlock (as Jeff noted
addresses only part of the problem)
http://git.altlinux.org/people/piastry/public/cifs-2.6.git?p=cifs-2.6.git;a=patch;h=df2d6b1fbf2401c5ee04f2ac143ea0954e3a87a6

shouldn't it also wrap the three places in fs/cifs/inode.c which do set_nlink?

-- 
Thanks,

Steve
