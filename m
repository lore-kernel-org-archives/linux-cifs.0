From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [CIFS][PATCH] set copy chunk defaults
Date: Fri, 15 Nov 2013 19:14:14 +0100
Message-ID: <20131115191414.6e7ad6aa@f163.suse.de>
References: <CAH2r5ms-1ZZxKqCDr+0xOxmDcjNPtmv=v+-Q1FkQ4EnJb=DSOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Christof Schmitt <christof.schmitt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms-1ZZxKqCDr+0xOxmDcjNPtmv=v+-Q1FkQ4EnJb=DSOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 15 Nov 2013 11:34:18 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From e53cf824641ad237e1b7ceb09aefbfbfb1787f47 Mon Sep 17 00:00:00 2001
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, 15 Nov 2013 11:26:24 -0600
> Subject: [PATCH] [CIFS] Set copychunk defaults
> 
> Patch 2 of the copy chunk series (the final patch will
> use these to handle copies of files larger than the chunk size.
> 
> We set the same defaults that Windows and Samba expect for
> CopyChunk.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  3 +++
>  fs/cifs/smb2pdu.c  | 10 +++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 50a6ca1..d9ea7ad 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -858,6 +858,9 @@ struct cifs_tcon {
>   __le64 vol_create_time;
>   __u32 ss_flags; /* sector size flags */
>   __u32 perf_sector_size; /* best sector size for perf */
> + __u32 max_chunks;
> + __u32 max_bytes_chunk;
> + __u32 max_bytes_copy;

Might be worth prefixing or nesting these to make it clear that they're
copy-chunk specific. Anyhow, looks good as is.

Reviewed-by: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Cheers, David
