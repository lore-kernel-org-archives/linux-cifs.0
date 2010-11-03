From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Add strictcache mount option
Date: Wed, 03 Nov 2010 11:11:34 +0530
Message-ID: <4CD0F60E.9040901@suse.de>
References: <AANLkTi=04ko7zXRaXvgEBzXFfhhL3QU64gnZOXMPoNOD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=04ko7zXRaXvgEBzXFfhhL3QU64gnZOXMPoNOD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/01/2010 01:12 AM, Pavel Shilovsky wrote:
> Use for switching on strict cache mode. In this mode the
> client read from the cache all the time it has Oplock Level II,
> otherwise - read from the server. All written data are stored
> in the cache, but if the client doesn't have Exclusive Oplock,
> it writes the data to the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/README       |    5 +++++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/connect.c    |    5 +++++
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index ee68d10..8fb6192 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -443,6 +443,11 @@ A partial list of the supported mount options follows:
>  		if oplock (caching token) is granted and held. Note that
>  		direct allows write operations larger than page size
>  		to be sent to the server.
> +  strictcache   Use for switching on strict cache mode. In this mode the
> +		client read from the cache all the time it has Oplock Level II,
> +		otherwise - read from the server. All written data are stored
> +		in the cache, but if the client doesn't have Exclusive Oplock,
> +		it writes the data to the server.

Could you remind me where this will be useful? Also, providing the same
information in README and mount.cifs man page is useful as well.


-- 
Suresh Jayaraman
