From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/13] cifs: convert cifsFileInfo->count to non-atomic counter
Date: Sat, 23 Oct 2010 11:57:52 -0500
Message-ID: <AANLkTimfSq1vrGjcdLRh5+p=t0oF9ouEOzaVsE5vcZBq@mail.gmail.com>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
	<1287171248-464-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged.  Made trivial checkpatch cleanup.

As mentioned earlier, I don't think that this patch helps (atomic_t
type is small
on most arch and the atomic operations are single instructions), but is harmless
and don't won't to create merge conflicts with the next patch so merging this.

On Fri, Oct 15, 2010 at 2:34 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The count for cifsFileInfo is currently an atomic, but that just adds
> complexity for little value. We generally need to hold cifs_file_list_lock
> to traverse the lists anyway so we might as well make this counter
> non-atomic and simply use the cifs_file_list_lock to protect it.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>



-- 
Thanks,

Steve
