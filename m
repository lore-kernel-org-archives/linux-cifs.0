From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] consistently use smb_buf_length as be32 for cifs
Date: Thu, 17 Mar 2011 10:29:25 -0400
Message-ID: <20110317142925.GA3295@infradead.org>
References: <AANLkTimnfO=GnKC6GK6FZ+H-hfchWhW=HzcUS+HcLH+c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimnfO=GnKC6GK6FZ+H-hfchWhW=HzcUS+HcLH+c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -	pSMB->hdr.smb_buf_length += count;
> +	update_rfc1001_len(pSMB, count);

The helper is very confusingly named relatively to the field it updates,
moreover we already have nice helpers to do arithmetics on big endian
fields.  These can just become:

	be32_add_cpu(&pSMB->hdr.smb_buf_length, count);

etc.
