From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 13/37] [CIFS] SMBD: Implement SMBD protocol
 negotiation
Date: Sun, 13 Aug 2017 03:22:25 -0700
Message-ID: <20170813102225.GF17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-14-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-14-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> +	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
> +	if (!request)
> +		return rc;

Here you do a mempool allocation to guarantee forward progress..

> +	request->sge = kzalloc(sizeof(struct ib_sge), GFP_KERNEL);
> +	if (!request->sge)
> +		goto allocate_sge_failed;

... and here it's a plain malloc in the same path, which renders the
above useless.  Also I would just embedd the sge into the containing
structure to avoid a memory allocation.

> +	request->info = info;
> +
> +	packet = (struct smbd_negotiate_req *) request->packet;
> +	packet->min_version = cpu_to_le16(0x100);
> +	packet->max_version = cpu_to_le16(0x100);

Canyou add a constant for the version code?

> +	packet->reserved = cpu_to_le16(0);

no need to byte swap 0 - you can always assign it directly.
