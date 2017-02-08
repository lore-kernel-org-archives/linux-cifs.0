From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [patch] CIFS: set *resp_buf_type to NO_BUFFER on error
Date: Tue, 7 Feb 2017 17:00:17 -0800
Message-ID: <CAKywueSLJJWNK2su4ux4ouz0Rz=fw9eY5vHN+iYFAO5Ek1s+=w@mail.gmail.com>
References: <20170207131841.GC31552@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>,
 kernel-janitors@vger.kernel.org,
 samba-technical <samba-technical@lists.samba.org>,
 Pavel Shilovsky <pshilov@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20170207131841.GC31552@mwanda>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

2017-02-07 5:18 GMT-08:00 Dan Carpenter <dan.carpenter@oracle.com>:
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
>         struct kvec *new_iov;
>         int rc;
>
> +       *resp_buf_type = CIFS_NO_BUFFER; /* no response buf yet */
> +
>         new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
>         if (!new_iov)
>                 return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Good catch, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

-- 
Best regards,
Pavel Shilovsky
