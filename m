From: Steve French <smfrench@gmail.com>
Subject: Re: [patch] CIFS: remove an unneeded NULL check
Date: Wed, 20 May 2015 11:36:47 -0500
Message-ID: <CAH2r5muFQ_LySLM8bCr1fDqw+NWhT=pSU1Nr8v8e5jxVeULyZA@mail.gmail.com>
References: <20150430143024.GA22086@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150430143024.GA22086@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git

On Thu, Apr 30, 2015 at 9:30 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Smatch complains because we dereference "ses->server" without checking
> some lines earlier inside the call to get_next_mid(ses->server).
>
>         fs/cifs/cifssmb.c:4921 CIFSGetDFSRefer()
>         warn: variable dereferenced before check 'ses->server' (see line 4899)
>
> There is only one caller for this function get_dfs_path() and it always
> passes a non-null "ses->server" pointer so this NULL check can be
> removed.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 1091aff..f26ffbf 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4918,7 +4918,7 @@ getDFSRetry:
>                 strncpy(pSMB->RequestFileName, search_name, name_len);
>         }
>
> -       if (ses->server && ses->server->sign)
> +       if (ses->server->sign)
>                 pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
>
>         pSMB->hdr.Uid = ses->Suid;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
