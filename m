From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: cifsacl cleanup, pile #3
Date: Sat, 20 Oct 2012 07:43:02 -0500
Message-ID: <CADT32eJMigP3HZu=qT7YjnPztFuDGjy7b1sj6qBGjraiykb2hg@mail.gmail.com>
References: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676785-8525-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 19, 2012 at 2:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> A few more fixes for the cifsacl set. Steve, I can roll these into the
> other patches if you'd prefer...
>
> Jeff Layton (3):
>   cifs: extra sanity checking for cifs.idmap keys
>   cifs: fix hardcoded default security descriptor length
>   cifs: deal with id_to_sid embedded sid reply corner case
>
>  fs/cifs/cifsacl.c | 35 ++++++++++++++++++++++++++++++-----
>  fs/cifs/cifsacl.h | 11 ++++++++---
>  2 files changed, 38 insertions(+), 8 deletions(-)
>
> --
> 1.7.11.7
>

All three patches look correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
