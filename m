From: Stefan Metzmacher <metze@samba.org>
Subject: Re: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
Date: Tue, 8 Aug 2017 08:58:02 +0200
Message-ID: <9632c208-d6a5-2c47-b583-274d046d97bd@samba.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Li,

thanks for providing this patchset, I guess it will be a huge win to
have SMBDirect support for the kernel client!

> Define a new structure for SMBD transport. This stucture will have all the
> information on the transport, and it will be stored in the current SMB session.
...
> +/*
> + * The context for the SMBDirect transport
> + * Everything related to the transport is here. It has several
logical parts
> + * 1. RDMA related structures
> + * 2. SMBDirect connection parameters
> + * 3. Reassembly queue for data receive path
> + * 4. mempools for allocating packets
> + */
> +struct cifs_rdma_info {
> +	struct TCP_Server_Info *server_info;
> +
> +	// for debug purposes
> +	unsigned int count_receive_buffer;
> +	unsigned int count_get_receive_buffer;
> +	unsigned int count_put_receive_buffer;
> +	unsigned int count_send_empty;
> +};
> +#endif
>

It seems that the new transport is tied to it's caller
regarding structures and naming conventions.

I think it would be better to strictly separate them,
as I'd like to use the SMBDirect transport also from the
userspace for the client side e.g. in Samba's '[lib]smbclient',
but also in Samba's server side code 'smbd'.

Would it be possible to isolate this in
smb_direct.c and smb_direct.h while using
smb_direct_* prefixes for structures and
functions? Also avoiding the usage of other headers
from fs/cifs/*.h, expect for something generic like
nterr.h.

I guess 'struct cifs_rdma_info' would then be
'struct smb_direct_connection'. And it won't
have a reference to struct TCP_Server_Info.

It the strict layering is too much change,
I'd at least like to have the name changes.

This should relatively easy to do by using somthing like

git format-patch --stdout -37 > before

cat before | sed \
-e 's!struct cifs_rdma_info!struct smb_direct_connection!g' \
-e 's!cifsrdma\.h!smb_direct.h!g' \
-e 's!cifsrdma\.c!smb_direct.c!g' \
> after

git reset --hard HEAD~37
git am after

metze
