From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Move buffer allocation to a separate function
Date: Fri, 24 Jun 2011 03:11:59 -0400
Message-ID: <20110624071159.GA11901@infradead.org>
References: <1308898317-7667-1-git-send-email-piastryyy@gmail.com>
 <1308898317-7667-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1308898317-7667-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 24, 2011 at 10:51:53AM +0400, Pavel Shilovsky wrote:
> +static bool
> +allocate_buffers(char **pbigbuf, char **psmallbuf, unsigned int size,
> +		 bool isLargeBuf)

No p-prefixes for pointers, and no camelCase, please.

> +{
> +	char *bigbuf = *pbigbuf, *smallbuf = *psmallbuf;
> +
> +	if (bigbuf == NULL) {
> +		bigbuf = (char *)cifs_buf_get();
> +		if (!bigbuf) {
> +			cERROR(1, "No memory for large SMB response");
> +			msleep(3000);
> +			/* retry will check if exiting */
> +			return false;
> +		}
> +	} else if (isLargeBuf) {
> +		/* we are reusing a dirty large buf, clear its start */
> +		memset(bigbuf, 0, size);
> +	}
> +
> +	if (smallbuf == NULL) {
> +		smallbuf = (char *)cifs_small_buf_get();
> +		if (!smallbuf) {
> +			cERROR(1, "No memory for SMB response");
> +			msleep(1000);
> +			/* retry will check if exiting */
> +			return false;
> +		}
> +		/* beginning of smb buffer is cleared in our buf_get */
> +	} else /* if existing small buf clear beginning */
> +		memset(smallbuf, 0, size);
> +
> +	*pbigbuf = bigbuf;
> +	*psmallbuf = smallbuf;
> +
> +	return true;

But in the end this whole code doesn't make any sense at all.  Just
sleeping when failing to memory is a bad idea, as is all this partial
reuse stuff.

Someone needs to rearchitect this code to actually make sense.
