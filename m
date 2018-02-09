From: Colin Ian King <colin.king@canonical.com>
Subject: NAK: [PATCH] CIFS: SMBD: fix spelling mistake: "faield" -> "failed"
Date: Fri, 9 Feb 2018 12:13:41 +0000
Message-ID: <280fa85a-a5f8-bc89-447b-c97886f3bc23@canonical.com>
References: <20180209115936.32569-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180209115936.32569-1-colin.king@canonical.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 09/02/18 11:59, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in log_rdma_mr message text.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/smbdirect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 91710eb571fb..5405856a4c8e 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2295,7 +2295,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
>  				rc = ib_dereg_mr(smbdirect_mr->mr);
>  				if (rc) {
>  					log_rdma_mr(ERR,
> -						"ib_dereg_mr faield rc=%x\n",
> +						"ib_dereg_mr failed rc=%x\n",
>  						rc);
>  					smbd_disconnect_rdma_connection(info);
>  				}
> 

Ignore this, I found another typo in the source, will re-send a V2.
