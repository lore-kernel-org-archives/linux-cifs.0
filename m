From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Removing endian warning due to mixed endian use by cifs of
 smb_buf_length
Date: Wed, 16 Mar 2011 05:25:27 -0400
Message-ID: <20110316092527.GA13400@infradead.org>
References: <AANLkTikJM39qVWtUa2uU4+zyUSYc0X+56q04vFzV61NN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikJM39qVWtUa2uU4+zyUSYc0X+56q04vFzV61NN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 15, 2011 at 05:58:20PM -0500, Steve French wrote:
> I wanted to make the following trivial change to cifs's smb_sendv to
> allow smb2 (the smb2 code treats the RFC1001 length as always big
> endian, its native form, while cifs only converts it to bigendian at
> the last possible moment) to use cifs's smb_sendv routine to put data
> on the wire:

> +int smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>  {
>  	int rc = 0;
>  	int i = 0;
> @@ -154,7 +153,17 @@ smb_sendv(struct TCP_Server_Info *server, struct
> kvec *iov, int n_vec)
>  	for (i = 0; i < n_vec; i++)
>  		total_len += iov[i].iov_len;
> 
> -	smb_buffer->smb_buf_length = cpu_to_be32(smb_buffer->smb_buf_length);
> +	/* In SMB2 we treat the buffer length in its native form
> +	   (always be32 for RFC1001 length), but in all of the cifs
> +	   callers the equivalent, smb_buf_length, is treated
> +	   as host endian until right before we send it (here) so
> +	   has to be converted to big endian below.  Would be
> +	   too big a change for cifspdu.c to change the many
> +	   dozen places that treat it as host endian for cifs, but
> +	   at least for smb2 we can treat it as host endian */
> +	if (server->is_smb2 == false)
> +		smb_buffer->smb_buf_length = (__force __u32)
> +			cpu_to_be32(smb_buffer->smb_buf_length);

NACK.  You really need to maintain smb_buf_length properly in BE format
for cifs, too.

> Jeff prefers that we change cifs (a much larger change, hits about 100
> places) to make:
> u32 smb_buf_length;
> instead (as it actually is on the wire)
> _be32 smb_buf_length;
> 
> Basically this requires at least 50 changes like:
> pSMB->hdr.smb_buf_length += byte_count;
> to
> pSMB->hdr.smb_buf_length =
> cpu_to_be32(be32_to_cpu(pSMB->hdr.smb_buf_length) + byte_count);
> (or an equivalent macro)
> 
> and about 40 other changes.   This is marginally slower than the
> current cifs approach, but is more accurate and intuitive in some
> ways.

And it's provable correct.  With the proper macro it's not a problem at
all, we have similar fields in XFS, too.  It's also not more cpu
intensive on most architectures that either have special store as big
endian instruction or eat up the byteswap in the pipeline.
