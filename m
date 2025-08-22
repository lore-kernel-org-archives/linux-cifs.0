Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2142FFDEB
	for <linux-cifs@vger.kernel.org>; Fri, 22 Aug 2025 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755873995; cv=none; b=pJsRT3dR1QgqbrJvXwrNvocv8AWpzOw0sNjii2PlUM+2CCEsmpOss5mn9JSjbzbILYYL/wkrnAbqzQ54uzDPKfXS+2Fy5mzZFo1OKv1rMeOTWe4hhvBHA7MOyR4zqf950j9HmDjXy9RVFPSClm3QhQxP8n+BgoRIRN7jwQnMykc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755873995; c=relaxed/simple;
	bh=XZIGEP7rZ9ZpW/yKPE0zB5/eAxy33eW33ecnTtq2YPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etLBscWOIbiHjNUVgnG9xeNsjX5gg/QZm6JVqfJ8U7PfLItKDidKeioMKKPcdVGEPzaz8WTXpAM4wCxW32PaTh1UytRg5xlbdY42DawF+CMZMcI/ZxfuszURKFAWqLy4ZKUlI89Q9jw6HdzXb38Riyd2wHsKseyGriyMQjoO5ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JHrRW+2b; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JHrRW+2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=VQenL7ZHjbEdAaEfYKYz0lZZm7EbsnWDDXTJwHDoyEA=; b=JHrRW+2bnq5HwXli0iJpKXVKQS
	VOA/mc1wIsUWrzU5eQCzc6omQaRaMGMS/JdAT16NFRfJAbz3r7DYFp37uGn0D9bgNJEX8FI17/548
	1kd/OfmIeLFATKTkIczrb09Xq51Ts1vbjqWQEWGLZw/NInIgl/o31cJ3VS0xWtgV/CVhs9eXI8EJJ
	QBT+TlrQVBy/OLlpBre2gXXWLRsMocxRcWsqA1q0Ts3zsPOGdCYOlTmquThJ7cvsXCIrHAP0H/nBZ
	CTxdfR5P0T0JRzwBqkdyHML3hgupgxIVnftyAiPbSX+8QHRJFyBE3ze3quWMLAl7Io0cO/Y8+Q1iS
	zPicvmRMi7aHmoFORVe9oM6uMbzkQ1JwpteFooJ3On90LvdryIdH7fzfzGqeW/ev+4+UnefPxQZo9
	eFTxnbtNiGvPsirfOLLMzMBw/s+JLL7+QhIgCJuzXEvs9f1Nk2e7aRVkUDbIAFKpF6lmuT0MELbX+
	FgWxthjqVYKAA4ba95NiRNAk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1upT2D-000HLM-2G;
	Fri, 22 Aug 2025 14:46:29 +0000
Message-ID: <74d7ca1e-a8cf-44b3-8c4c-7e9e69eadea5@samba.org>
Date: Fri, 22 Aug 2025 16:46:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: server: fix IRD/ORD negotiation with the client
To: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
References: <20250821092751.35815-1-metze@samba.org>
 <a0ab409a-bb90-4a15-a8aa-a18f9f6a0b0d@talpey.com>
 <f551bf7f-697a-4298-a62c-74da18992204@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <f551bf7f-697a-4298-a62c-74da18992204@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Tom,

based on the u8 limitation in the core rdma code are there
any real problems with this?

I created wireshark fixes in order to look at it in
detail in captures.

And I tested with Windows 2016 using MPA v1, old and new ksmbd with MPA v1 and v2,
Windows 2025 with MPA v2 as servers. And old and new cifs.ko with MPA v1 and v2.

My smbdirect refactoring is based on these patches, so it would be great if we could move
forward with this.

Thanks!
metze

>> On 8/21/2025 5:27 AM, Stefan Metzmacher wrote:
>>> Already do real negotiation in smb_direct_handle_connect_request()
>>> where we see the requested initiator_depth and responder_resources
>>> from the client.
>>>
>>> We should should detect legacy iwarp clients using MPA v1
>>> with the custom IRD/ORD negotiation.
>>>
>>> We need to send the custom IRD/ORD in big endian,
>>> but we need to try to let clients with broken requests
>>> using little endian (older cifs.ko) to work.
>>>
>>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>>> Cc: Steve French <smfrench@gmail.com>
>>> Cc: Tom Talpey <tom@talpey.com>
>>> Cc: linux-cifs@vger.kernel.org
>>> Cc: samba-technical@lists.samba.org
>>> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
>>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>>> ---
>>>   fs/smb/server/transport_rdma.c | 101 ++++++++++++++++++++++++++++-----
>>>   1 file changed, 87 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
>>> index 5466aa8c39b1..20d1f53ca989 100644
>>> --- a/fs/smb/server/transport_rdma.c
>>> +++ b/fs/smb/server/transport_rdma.c
>>> @@ -153,6 +153,10 @@ struct smb_direct_transport {
>>>       struct work_struct    disconnect_work;
>>>       bool            negotiation_requested;
>>> +
>>> +    bool            legacy_iwarp;
>>> +    u8            initiator_depth;
>>> +    u8            responder_resources;
>>
>> Why are these limited to 255? I could foresee peers requesting large
>> numbers, or over (very) high latency links. Also, the MPA
>> protocol extension allows up to 2^14.
> 
> This is because the rdma core also only supports u8, it's
> strange but that's what we have in include/rdma/rdma_cm.h:
> 
> struct rdma_conn_param {
>          const void *private_data;
>          u8 private_data_len;
>          u8 responder_resources;
>          u8 initiator_depth;
>          u8 flow_control;
>          u8 retry_count;         /* ignored when accepting */
>          u8 rnr_retry_count;
>          /* Fields below ignored if a QP is created on the rdma_cm_id. */
>          u8 srq;
>          u32 qp_num;
>          u32 qkey;
> };
> 
> I'll send a mail to linux-rdma@vger.kernel.org to ask why that's the
> case.
> 
>>
>>>   };
>>>   #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
>>> @@ -347,6 +351,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
>>>       t->cm_id = cm_id;
>>>       cm_id->context = t;
>>> +    t->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
>>> +    t->responder_resources = 1;
>>> +
>>>       t->status = SMB_DIRECT_CS_NEW;
>>>       init_waitqueue_head(&t->wait_status);
>>> @@ -1616,21 +1623,21 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
>>>   static int smb_direct_accept_client(struct smb_direct_transport *t)
>>>   {
>>>       struct rdma_conn_param conn_param;
>>> -    struct ib_port_immutable port_immutable;
>>> -    u32 ird_ord_hdr[2];
>>> +    __be32 ird_ord_hdr[2];
>>>       int ret;
>>> +    /*
>>> +     * smb_direct_handle_connect_request()
>>> +     * already negotiated t->initiator_depth
>>> +     * and t->responder_resources
>>> +     */
>>>       memset(&conn_param, 0, sizeof(conn_param));
>>> -    conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
>>> -                       SMB_DIRECT_CM_INITIATOR_DEPTH);
>>> -    conn_param.responder_resources = 0;
>>> -
>>> -    t->cm_id->device->ops.get_port_immutable(t->cm_id->device,
>>> -                         t->cm_id->port_num,
>>> -                         &port_immutable);
>>> -    if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
>>> -        ird_ord_hdr[0] = conn_param.responder_resources;
>>> -        ird_ord_hdr[1] = 1;
>>> +    conn_param.initiator_depth = t->initiator_depth;
>>> +    conn_param.responder_resources = t->responder_resources;
>>> +
>>> +    if (t->legacy_iwarp) {
>>> +        ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
>>> +        ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
>>
>> Ditto previous comment.
> 
> I don't understand this comment there's nothing with u8 here.
> We just change to big endian instead of using host byte order
> (most likely little endian).
> 
>>>           conn_param.private_data = ird_ord_hdr;
>>>           conn_param.private_data_len = sizeof(ird_ord_hdr);
>>>       } else {
>>> @@ -2016,10 +2023,13 @@ static bool rdma_frwr_is_supported(struct ib_device_attr *attrs)
>>>       return true;
>>>   }
>>> -static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
>>> +static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
>>> +                         struct rdma_cm_event *event)
>>>   {
>>>       struct smb_direct_transport *t;
>>>       struct task_struct *handler;
>>> +    u8 peer_initiator_depth;
>>> +    u8 peer_responder_resources;
>>
>> Ditto previous comment.
>>
>>>       int ret;
>>>       if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
>>> @@ -2033,6 +2043,69 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
>>>       if (!t)
>>>           return -ENOMEM;
>>> +    peer_initiator_depth = event->param.conn.initiator_depth;
>>> +    peer_responder_resources = event->param.conn.responder_resources;
>>> +    if (rdma_protocol_iwarp(new_cm_id->device, new_cm_id->port_num) &&
>>> +        event->param.conn.private_data_len == 8)
>>> +    {
>>> +        /*
>>> +         * Legacy clients with only iWarp MPA v1 support
>>> +         * need a private blob in order to negotiate
>>> +         * the IRD/ORD values.
>>> +         */
>>> +        const __be32 *ird_ord_hdr = event->param.conn.private_data;
>>> +        u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
>>> +        u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
>>> +
>>> +        /*
>>> +         * cifs.ko sends the legacy IRD/ORD negotiation
>>> +         * event if iWarp MPA v2 was used.
>>
>> This is very confusing - what "legacy IRD/ORD negotiation"? And, did
>> you really mean MPA _V2_?
> 
> No v1 with [MS-SMBD] 6 Appendix A: RDMA Provider IRD/ORD Negotiation
> 
>>> +         *
>>> +         * Here we check that the values match and only
>>> +         * mark the client as legacy if they don't match.
>>
>>
>> I am troubled by this - if the peer is violating the protocol, we
>> should not perpetuate it. And if the peer truly meant what it said,
>> then we've overridden it.
> 
> There's nobody violating something.
> 
> These values are negotiated and the server should use the
> minimum of the peers and it's own value.
> 
> So if an old cifs.ko sent private data of
> 
> 0x20 0x00 0x00 0x00 0x01 0x00 0x00 0x00
> 
> Then we have IRD = 536870912 (0x20000000)
> and ORD = 16777216 (0x1000000).
> 
> While a fixed cifs.ko would send
> 
> 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x01
> IRD = 32 (0x20) ORD = 1.
> 
> So we better truncate the huge values with min_t
> instead of (ird & 0xff) (or without the rdma core u8 limitation & 0x3fff)
> as using & or a cast to u8 would mean we would result in thinking
> the peer would have send 0.
> 
>>
>>> +         */
>>> +        if ((u32)peer_initiator_depth != ird32 ||
>>> +            (u32)peer_responder_resources != ord32)
> 
> These checks are there in order to handle the case where
> the rdma core iwarp MPA v1 negotiation left
> rdma_conn_param.{initiator_depth,responder_resources} at their
> local default values.
> 
> It lets us detect that MPA v2 was not used.
> 
> Windows servers do not add a
> [MS-SMBD] 6 Appendix A: RDMA Provider IRD/ORD Negotiation
> private data blob even if the client sent it
> together with an MPA v2 exchange.
> 
> And we try to do the same here if we detect the values
> we got via rdma_conn_param and the extra private
> IRD/ORD Negotiation are the same, then we don't set
> t->legacy_iwarp = true and won't use conn_param.private_data
> when calling rdma_accept().
> 
> We also just use u8 for the negotiation because we need to
> fill the u8 values in conn_param for the rdma_accept() call.
> 
>>> +        {
>>> +            /*
>>> +             * There are broken clients (old cifs.ko)
>>> +             * using little endian and also
>>> +             * struct rdma_conn_param only uses u8
>>> +             * for initiator_depth and responder_resources,
>>> +             * so we truncate the value to U8_MAX.
>>
>> We should not do this. I presume any such peer worked previously.
>> Why violate the protocol now???
> 
> It is a limitation in rdma core.
> 
> metze
> 

