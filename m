From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v3] smb2: fix uninitialized variable bug in smb2_ioctl_query_info
Date: Tue, 9 Oct 2018 18:11:55 -0500
Message-ID: <CAH2r5mvMBaC-OMOcVv-ohwFck2fwS7-ZghCtvYithcO54G9uZQ@mail.gmail.com>
References: <20181009220220.GA24569@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009220220.GA24569@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Added Ronnie's reviewed-by and pushed to cifs-2.6.git for-next
On Tue, Oct 9, 2018 at 5:27 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> There is a potential execution path in which variable *resp_buftype*
> is passed as an argument to function free_rsp_buf(), in which it is
> used in a comparison without being properly initialized previously.
>
> Fix this by initializing variable *resp_buftype* to CIFS_NO_BUFFER
> in order to avoid unpredictable or unintended results.
>
> Addresses-Coverity-ID: 1473971 ("Uninitialized scalar variable")
> Fixes: c5d25bdb2967 ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> Changes in v3:
>  - Initialize resp_buftype to CIFS_NO_BUFFER instead of to -1.
>    Thanks to Ronnie Sahlberg for pointing this out.
>
> Changes in v2:
>  - Fix Coverity and Fixes tag.
>  - Update commit log.
>
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c6c6450d..8472cb0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1133,7 +1133,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         struct smb_rqst rqst;
>         struct kvec iov[1];
>         struct kvec rsp_iov;
> -       int resp_buftype;
> +       int resp_buftype = CIFS_NO_BUFFER;
>         struct smb2_query_info_rsp *rsp = NULL;
>         void *buffer;
>
> --
> 2.7.4
>


-- 
Thanks,

Steve
