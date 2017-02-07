From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [patch] CIFS: set *resp_buf_type to NO_BUFFER on error
Date: Tue, 07 Feb 2017 16:33:21 +0100
Message-ID: <mpsmvdyhv7i.fsf@aaptelpc.suse.de>
References: <20170207131841.GC31552@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170207131841.GC31552@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> We recently shuffled this code around and introduced a new error path
> before *resp_buf_type gets initialized.  It creates uninitialized
> variable bugs in the callers.
>
>     fs/cifs/smb2pdu.c:579 SMB2_negotiate()
>     error: uninitialized symbol 'resp_buftype'.
>
> Fixes: 738f9de5cdb9 ("CIFS: Send RFC1001 length in a separate iov")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 526f0533cb4e..8fa5e058fb15 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -807,6 +807,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
>  	struct kvec *new_iov;
>  	int rc;
>  
> +	*resp_buf_type = CIFS_NO_BUFFER; /* no response buf yet */
> +
>  	new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
>  	if (!new_iov)
>  		return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

LGTM. To be a bit more explicit:

resp_buf_type is an output parameter of the SendReceive2 function and in
case the kmalloc failed the function could return to the caller with
this parameter left uninitialized.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
