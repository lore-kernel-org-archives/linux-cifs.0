From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v6 07/22] CIFS: SMBD: Implement function to create a SMB
 Direct connection
Date: Mon, 20 Nov 2017 10:56:11 -0600
Message-ID: <CAH2r5mvuASr7UkjbW6BmiZyccmtgqoHaVA52jpRV-LDOj3JXyQ@mail.gmail.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com> <20171105054404.23886-8-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171105054404.23886-8-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Sun, Nov 5, 2017 at 12:43 AM, Long Li <longli@exchange.microsoft.com> wrote:
> From: Long Li <longli@microsoft.com>
>
> The upper layer calls this function to connect to peer through SMB Direct.
> Each SMB Direct connection is based on a RDMA RC Queue Pair.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smbdirect.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 7af49cd..47d999f 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1652,3 +1652,20 @@ struct smbd_connection *_smbd_get_connection(
>         kfree(info);
>         return NULL;
>  }
> +
> +struct smbd_connection *smbd_get_connection(
> +       struct TCP_Server_Info *server, struct sockaddr *dstaddr)
> +{
> +       struct smbd_connection *ret;
> +       int port = SMBD_PORT;
> +
> +try_again:
> +       ret = _smbd_get_connection(server, dstaddr, port);
> +
> +       /* Try SMB_PORT if SMBD_PORT doesn't work */
> +       if (!ret && port == SMBD_PORT) {
> +               port = SMB_PORT;
> +               goto try_again;
> +       }
> +       return ret;
> +}
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
