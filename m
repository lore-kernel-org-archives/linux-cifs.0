From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH] CIFS: use correct format string for size_t
Date: Mon, 06 Feb 2017 19:27:35 +0530
Message-ID: <1486389455.2576.14.camel@redhat.com>
References: <20170202122117.1404479-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170202122117.1404479-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 2017-02-02 at 13:21 +0100, Arnd Bergmann wrote:
> This warning is harmless as size_t is always as wide as 'unsigned
> long':
> 
> fs/cifs/smb2ops.c:2008:245: error: format '%lu' expects argument of
> type 'long unsigned int', but argument 5 has type 'size_t {aka
> unsigned int}' [-Werror=format=]
> 
> Using %zu however is the correct format string that we don't get a
> warning for.
> 
> Fixes: c9d651a5a2fe ("CIFS: Decrypt and process small encrypted
> packets")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sachin Prabhu <sprabhu@redhat.com>

> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0764c32754b0..ac6e10adf000 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2005,7 +2005,7 @@ handle_read_data(struct TCP_Server_Info
> *server, struct mid_q_entry *mid,
>  	rdata->iov[0].iov_len = 4;
>  	rdata->iov[1].iov_base = buf + 4;
>  	rdata->iov[1].iov_len = server->vals->read_rsp_size - 4;
> -	cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
> +	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
>  		 rdata->iov[0].iov_base, server->vals-
> >read_rsp_size);
>  
>  	length = rdata->copy_into_pages(server, rdata, &iter);
