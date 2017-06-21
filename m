From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Fix some return values in case of error in 'crypt_message'
Date: Wed, 21 Jun 2017 12:01:39 -0500
Message-ID: <CAH2r5muiqTjpty9o9xKM3ai8zzpSwQD49O4oVAz4yTiPfG3jZA@mail.gmail.com>
References: <20170611071247.2038-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170611071247.2038-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Sun, Jun 11, 2017 at 2:12 AM, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
> 'rc' is known to be 0 at this point. So if 'init_sg' or 'kzalloc' fails, we
> should return -ENOMEM instead.
>
> Also remove a useless 'rc' in a debug message as it is meaningless here.
>
> Fixes: 026e93dc0a3ee ("CIFS: Encrypt SMB3 requests before sending")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  fs/cifs/smb2ops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c58691834eb2..cdcb3d95add8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1809,7 +1809,8 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
>
>         sg = init_sg(rqst, sign);
>         if (!sg) {
> -               cifs_dbg(VFS, "%s: Failed to init sg %d", __func__, rc);
> +               cifs_dbg(VFS, "%s: Failed to init sg", __func__);
> +               rc = -ENOMEM;
>                 goto free_req;
>         }
>
> @@ -1817,6 +1818,7 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
>         iv = kzalloc(iv_len, GFP_KERNEL);
>         if (!iv) {
>                 cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
> +               rc = -ENOMEM;
>                 goto free_sg;
>         }
>         iv[0] = 3;
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
