From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [[PATCH v1] 11/37] [CIFS] SMBD: Post a receive request
Date: Sun, 13 Aug 2017 03:18:31 -0700
Message-ID: <20170813101831.GD17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-12-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-12-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> +	switch(response->type) {
> +	case SMBD_TRANSFER_DATA:
> +		data_transfer = (struct smbd_data_transfer *) response->packet;

Maybe add a little helper for the packet data to hide these cast, e.g.

static inline void *smbd_payload(struct cifs_rdma_response *resp)
{
	return (void *)response->packet;
}


> +		atomic_dec(&info->receive_credits);
> +		atomic_set(&info->receive_credit_target,
> +			le16_to_cpu(data_transfer->credits_requested));
> +		atomic_add(le16_to_cpu(data_transfer->credits_granted),
> +			&info->send_credits);

That's a lot of atomic ops in the fast path handler.  Also remember
that atomic_set isn't really atomic vs other callers.
