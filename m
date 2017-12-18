From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [RFC PATCH linux-next] CIFS: SMBD: _smbd_get_connection() can be
 static
Date: Mon, 18 Dec 2017 21:44:02 +0000
Message-ID: <MWHPR21MB084664F6956C939B6EF5459BCE0E0@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <201712182136.tWBuroDL%fengguang.wu@intel.com>
 <20171218133006.GA79761@cairo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218133006.GA79761@cairo>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Fixes: 07495ff5d9bc ("CIFS: SMBD: Establish SMB Direct connection")
> Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Thanks.

> ---
>  smbdirect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c index 2ecd5c1..62a=
5c3f
> 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1462,7 +1462,7 @@ static int allocate_caches_and_workqueue(struct
> smbd_connection *info)  }
>=20
>  /* Create a SMBD connection, called by upper layer */ -struct
> smbd_connection *_smbd_get_connection(
> +static struct smbd_connection *_smbd_get_connection(
>  	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)  {
>  	int rc;
