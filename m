From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: checkpatch warnings on your patch series
Date: Wed, 12 Oct 2011 07:54:53 -0400
Message-ID: <20111012075453.20542152@tlielax.poochiereds.net>
References: <CAH2r5msXgCm44tY=wX8Ng0+xDGHRyaq804Qk33XvFOQkbK54ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msXgCm44tY=wX8Ng0+xDGHRyaq804Qk33XvFOQkbK54ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 22:46:31 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Reviewing the patches in your cifs-3.2 branch, I did run into one
> checkpatch warning.
> 
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #231: FILE: fs/cifs/connect.c:2891:
> +#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 *1024)
> 
> 
> otherwise, the patch review is uneventful so far, and first few easy
> ones are merged.
> 

Oops, typo...

Fixed in my git tree. Also added a patch to it to eliminate the
unnecessary setting of "malformed" that Pavel pointed out.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
