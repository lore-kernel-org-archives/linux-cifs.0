From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expose cifs module parameters in sysfs
Date: Fri, 30 Sep 2016 21:30:14 -0500
Message-ID: <CAH2r5mt841ZhE9EANjctCvtABw73mWmbr-rsfUomBcg_zZRd=A@mail.gmail.com>
References: <1475266865-19376-1-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475266865-19376-1-git-send-email-germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thx - pushed to cifs-2.6.git for-next

Now all cifs.ko module time load time configuration parameters are visible in
/sys/modules/cifs/parameters

On Fri, Sep 30, 2016 at 3:21 PM, Germano Percossi
<germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index db8a404..7fb17f6 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -64,15 +64,15 @@ unsigned int global_secflags = CIFSSEC_DEF;
>  unsigned int sign_CIFS_PDUs = 1;
>  static const struct super_operations cifs_super_ops;
>  unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
> -module_param(CIFSMaxBufSize, int, 0);
> +module_param(CIFSMaxBufSize, int, 0444);
>  MODULE_PARM_DESC(CIFSMaxBufSize, "Network buffer size (not including header). "
>                                  "Default: 16384 Range: 8192 to 130048");
>  unsigned int cifs_min_rcv = CIFS_MIN_RCV_POOL;
> -module_param(cifs_min_rcv, int, 0);
> +module_param(cifs_min_rcv, int, 0444);
>  MODULE_PARM_DESC(cifs_min_rcv, "Network buffers in pool. Default: 4 Range: "
>                                 "1 to 64");
>  unsigned int cifs_min_small = 30;
> -module_param(cifs_min_small, int, 0);
> +module_param(cifs_min_small, int, 0444);
>  MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
>                                  "Range: 2 to 256");
>  unsigned int cifs_max_pending = CIFS_MAX_REQ;
> --
> 1.9.1
>



-- 
Thanks,

Steve
