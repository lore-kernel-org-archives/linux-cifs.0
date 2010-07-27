From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 10:33:13 -0400
Message-ID: <20100727103313.4b730ea8@tlielax.poochiereds.net>
References: <4C4EE408.7070109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4EE408.7070109-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Jul 2010 19:20:00 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Document the newly added local caching feature using FS-Cache. This patch
> could be queued and considered once the local caching patches gets merged
> upstream.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  doc/mount.cifs.8.xml |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/doc/mount.cifs.8.xml b/doc/mount.cifs.8.xml
> index 4937550..2200746 100644
> --- a/doc/mount.cifs.8.xml
> +++ b/doc/mount.cifs.8.xml
> @@ -534,6 +534,23 @@ permissions in memory that can't be stored on the server. This information can d
>                  maximum wsize currently allowed by CIFS is 57344 (fourteen
>                  4096 byte pages)</para></listitem>
>  	</varlistentry>
> +	<varlistentry>
> +		<term>fsc</term>
> +
> +		<listitem><para>Enable local disk caching using FS-Cache
> +		for cifs. This option could be useful to improve performance
> +		on a slow link, heavily loaded server and/or network
> +		where reading from the disk is faster than reading from the
> +		server (over the network). This could also impact the
> +		scalability positively as the number of calls to the server
> +		are reduced. But, be warned that local caching is not suitable
> +		for all workloads, for e.g., read-once type workloads. So
> +		you need to consider carefully the situation/workload before
> +		using this option.
> +		NOTE: You also need to have cachefilesd daemon installed and
> +		running to make the cache operational.
> +                </para></listitem>
> +	</varlistentry>

You may want to mention somewhere that this is only available in recent
kernels that have been built with fsc turned on.

Other than that, this and the mount.cifs patch look fine and I'll plan
to commit them before the upcoming 4.6 release.

>  	 <varlistentry>
>                  <term>--verbose</term>
>                  <listitem><para>Print additional debugging information for the mount. Note that this parameter must be specified before the -o. For example:</para><para>mount -t cifs //server/share /mnt --verbose -o user=username</para></listitem>

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
