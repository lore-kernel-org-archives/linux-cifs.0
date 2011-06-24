From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: Move mid search to a separate function
Date: Fri, 24 Jun 2011 03:14:54 -0400
Message-ID: <20110624071454.GB11901@infradead.org>
References: <1308898317-7667-1-git-send-email-piastryyy@gmail.com>
 <1308898317-7667-5-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1308898317-7667-5-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> +static struct mid_q_entry *
> +	      int *length, bool isLargeBuf, bool *isMultiRsp, char **pbigbuf)
> +{

Same comment for variable naming as for the first patch applies.

> +	struct list_head *tmp, *tmp2;
> +	struct mid_q_entry *mid_entry = NULL;
> +
> +	spin_lock(&GlobalMid_Lock);
> +	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> +		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);

Please use list_for_each_entry_safe.

> +			if (mid_entry->resp_buf) {
> +				/* merge response - fix up 1st*/
> +				*length = coalesce_t2(buf, mid_entry->resp_buf);
> +				if (*length > 0) {
> +					*length = 0;
> +					mid_entry->multiRsp = true;
> +					break;
> +				} else {

No need for and else after you break out of the loop anyway.

> +					/* all parts received or
> +					 * packet is malformed
> +					 */
> +					mid_entry->multiEnd = true;
> +					goto multi_t2_fnd;
> +				}
> +			} else {

Similarly here, the goto avoids the needed for the else, allowing the
cut down the indentation a lot.
