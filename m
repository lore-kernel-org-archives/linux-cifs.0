From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 01/13] cifs: fix flags handling in cifs_posix_open
Date: Sun, 17 Oct 2010 20:38:04 +0530
Message-ID: <4CBB1154.1020101@suse.de>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com> <1287171248-464-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/16/2010 01:03 AM, Jeff Layton wrote:
> The way flags are passed and converted for cifs_posix_open is rather
> non-sensical. Some callers call cifs_posix_convert_flags on the flags
> before they pass them to cifs_posix_open, whereas some don't. Two flag
> conversion steps is just confusing though.
> 
> Change the function instead to clearly expect input in f_flags format,
> and fix the callers to pass that in. Then, have cifs_posix_open call
> cifs_convert_posix_flags to do the conversion. Move cifs_posix_open to
> file.c as well so we can keep cifs_convert_posix_flags as a static
> function.
> 
> Fix it also to not ignore O_CREAT, O_EXCL and O_TRUNC, and instead have
> cifs_reopen_file mask those bits off before calling cifs_posix_open.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    2 +-
>  fs/cifs/dir.c       |   99 +++------------------------------------------
>  fs/cifs/file.c      |  113 +++++++++++++++++++++++++++++++++++++++-----------
>  3 files changed, 95 insertions(+), 119 deletions(-)

Nice cleanup. Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
