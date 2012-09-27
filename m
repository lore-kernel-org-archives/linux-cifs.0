From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix possible freed pointer dereference in CIFS_SessSetup
Date: Wed, 26 Sep 2012 22:16:29 -0500
Message-ID: <CAH2r5mtosT4Ws0ChJsmxjyoDikvFhoq8ANNg+=AAFDk+UnrRxA@mail.gmail.com>
References: <1348556409-10339-1-git-send-email-piastry@etersoft.ru>
	<1348556409-10339-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348556409-10339-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git (along with the other two in this series)

On Tue, Sep 25, 2012 at 2:00 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/sess.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 382c06d..76809f4 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -876,7 +876,8 @@ ssetup_ntlmssp_authenticate:
>         pSMB = (SESSION_SETUP_ANDX *)iov[0].iov_base;
>         smb_buf = (struct smb_hdr *)iov[0].iov_base;
>
> -       if ((type == RawNTLMSSP) && (smb_buf->Status.CifsError ==
> +       if ((type == RawNTLMSSP) && (resp_buf_type != CIFS_NO_BUFFER) &&
> +           (smb_buf->Status.CifsError ==
>                         cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
>                 if (phase != NtLmNegotiate) {
>                         cERROR(1, "Unexpected more processing error");



-- 
Thanks,

Steve
