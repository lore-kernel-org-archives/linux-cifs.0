From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH linux-next] CIFS: SMBD: _smbd_get_connection() can be static
Date: Wed, 3 Jan 2018 17:15:19 -0600
Message-ID: <CAH2r5mt0a3Qs6fTQP8ZyWxk5_SU4owWQx4=rxKpP9h7sYcFzwA@mail.gmail.com>
References: <201712182136.tWBuroDL%fengguang.wu@intel.com> <20171218133006.GA79761@cairo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218133006.GA79761@cairo>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next thx

On Mon, Dec 18, 2017 at 7:30 AM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Fixes: 07495ff5d9bc ("CIFS: SMBD: Establish SMB Direct connection")
> Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  smbdirect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 2ecd5c1..62a5c3f 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1462,7 +1462,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
>  }
>
>  /* Create a SMBD connection, called by upper layer */
> -struct smbd_connection *_smbd_get_connection(
> +static struct smbd_connection *_smbd_get_connection(
>         struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
>  {
>         int rc;



-- 
Thanks,

Steve
