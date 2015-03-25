From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: potential missing check for posix_lock_file_wait
Date: Tue, 24 Mar 2015 21:29:21 -0500
Message-ID: <CAH2r5mvpaoSDYesP7=v9zoVqqNunpqs1k34F8KivoXRVkGHtww@mail.gmail.com>
References: <1427242729-11515-1-git-send-email-csong84@gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, sanidhya-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	Byoungyoung Lee <blee-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
To: Chengyu Song <csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427242729-11515-1-git-send-email-csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 24, 2015 at 7:18 PM, Chengyu Song <csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org> wrote:
> posix_lock_file_wait may fail under certain circumstances, and its result is
> usually checked/returned. But given the complexity of cifs, I'm not sure if
> the result is intentially left unchecked and always expected to succeed.
>
> Signed-off-by: Chengyu Song <csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
> ---
>  fs/cifs/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index a94b3e6..beef67b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1553,8 +1553,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>                 rc = server->ops->mand_unlock_range(cfile, flock, xid);
>
>  out:
> -       if (flock->fl_flags & FL_POSIX)
> -               posix_lock_file_wait(file, flock);
> +       if (flock->fl_flags & FL_POSIX && !rc)
> +               rc = posix_lock_file_wait(file, flock);
>         return rc;
>  }
>

This is interesting.   Useful comparisons include

For network file systems you could
- enforce byte range locks only at the server
- enforce locks only on the client, and don't send to the server
- do both

Since cifs byte range locks are often emulated (except when Unix
Extensions are enabled, e.g. on mounts to Samba), we do the latter by
default, as does fs/9p (although they do it in a different order,
trying to grab the local byte range lock first).

But another interesting comparison point is nfs, where the code for v3
vs. v4 looks different. Take a look at nfsv3 (see fs/nfs/file.c) where
the choice is made to either do the posix_lock_file_wait (if 'local'
locking only) or if sending locks to the server then don't call to set
the local lock. Alternatively nfs4proc.c handles it differently.

There may not be a perfect answer on this one but was wondering if you
have experimented with what happens when you mount with "nobrl" (which
is the cifs mount option which causes locks not to be sent to the
server, and thus only evaulted locally).  My suspicion is that you can
demonstrate a failure if you mount with nobrl (without your patch).



-- 
Thanks,

Steve
