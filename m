From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: locking around modifications to i_nlink
Date: Fri, 27 Jul 2012 13:57:45 -0400
Message-ID: <20120727135745.75a95171@tlielax.poochiereds.net>
References: <CAH2r5muYbJrPYXtnAikVt1Sf_O7bdGsH7qLs=vjJ_EALXJDeQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muYbJrPYXtnAikVt1Sf_O7bdGsH7qLs=vjJ_EALXJDeQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Jul 2012 11:48:39 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Presumably to address the cifs equivalent of NFS bug (drop_nlink warning):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=822703
> 
> your patch which wraps drop_nlink in i_lock spinlock (as Jeff noted
> addresses only part of the problem)
> http://git.altlinux.org/people/piastry/public/cifs-2.6.git?p=cifs-2.6.git;a=patch;h=df2d6b1fbf2401c5ee04f2ac143ea0954e3a87a6
> 
> shouldn't it also wrap the three places in fs/cifs/inode.c which do set_nlink?
> 

It might not hurt to serialize all inode attribute updates under the
i_lock. If two updates are racing and the CPU ends up reording things,
you could end up with an inode that has a mix of attrs returned by
calls. The NFS client did this quite some time ago...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
