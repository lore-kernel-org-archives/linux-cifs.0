From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/9] cifs: extra sanity checking for cifs.idmap keys
Date: Fri, 19 Oct 2012 15:59:28 -0400
Message-ID: <20121019155928.63a5a11e@corrin.poochiereds.net>
References: <1350676695-8444-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350676695-8444-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Oct 2012 15:58:15 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Now that we aren't so rigid about the length of the key being passed
> in, we need to be a bit more rigorous about checking the length of
> the actual data against the claimed length (a'la num_subauths field).
> 
> Check for the case where userspace sends us a seemingly valid key
> with a num_subauths field that goes beyond the end of the array. If
> that happens, return -EIO and invalidate the key.
> 
> Also change the other places where we check for malformed keys in this
> code to invalidate the key as well.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 

Gyah -- sorry. git-send-email misfire...Please ignore this one.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
