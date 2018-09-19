From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Tue, 18 Sep 2018 22:59:50 -0700
Message-ID: <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107085514.12693-22-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Replying to a very old message, but it's something we
discussed today at the IOLab event so to capture it:

On 11/7/2017 12:55 AM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> ---
>   fs/cifs/file.c    | 17 +++++++++++++++--
>   fs/cifs/smb2pdu.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 59 insertions(+), 3 deletions(-)
> ...
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c8afb83..8a5ff90 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2379,7 +2379,40 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>   	req->MinimumCount = 0;
>   	req->Length = cpu_to_le32(io_parms->length);
>   	req->Offset = cpu_to_le64(io_parms->offset);
> +#ifdef CONFIG_CIFS_SMB_DIRECT
> +	/*
> +	 * If we want to do a RDMA write, fill in and append
> +	 * smbd_buffer_descriptor_v1 to the end of read request
> +	 */
> +	if (server->rdma && rdata &&
> +		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
> +
> +		struct smbd_buffer_descriptor_v1 *v1;
> +		bool need_invalidate =
> +			io_parms->tcon->ses->server->dialect == SMB30_PROT_ID;
> +
> +		rdata->mr = smbd_register_mr(
> +				server->smbd_conn, rdata->pages,
> +				rdata->nr_pages, rdata->tailsz,
> +				true, need_invalidate);
> +		if (!rdata->mr)
> +			return -ENOBUFS;
> +
> +		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
> +		if (need_invalidate)
> +			req->Channel = SMB2_CHANNEL_RDMA_V1;
> +		req->ReadChannelInfoOffset =
> +			offsetof(struct smb2_read_plain_req, Buffer);
> +		req->ReadChannelInfoLength =
> +			sizeof(struct smbd_buffer_descriptor_v1);
> +		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
> +		v1->offset = rdata->mr->mr->iova;

It's unnecessary, and possibly leaking kernel information, to use
the IOVA as the offset of a memory region which is registered using
an FRWR. Because such regions are based on the exact bytes targeted
by the memory handle, the offset can be set to any value, typically
zero, but nearly arbitrary. As long as the (offset + length) does
not wrap or otherwise overflow, offset can be set to anything
convenient.

Since SMB reads and writes range up to 8MB, I'd suggest zeroing the
least significant 23 bits, which should guarantee it. The other 41
bits, party on. You could randomize them, pass some clever identifier
such as MID sequence, whatever.

Tom.

> +		v1->token = rdata->mr->mr->rkey;
> +		v1->length = rdata->mr->mr->length;
