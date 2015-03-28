From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] [CIFS] Don't ignore errors on encrypting password in SMBTcon
Date: Sat, 28 Mar 2015 09:26:24 -0500
Message-ID: <CADT32e+_Y35vKDzbXfMZDzx+P7XUUHT5+4mokgCwzqZd4dRY-A@mail.gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-3-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427434082-4299-3-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct, although we could just goto a label at the end of this
function which
does the same.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


On Fri, Mar 27, 2015 at 12:28 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Although unlikely to fail (and tree connect does not commonly send
> a password since SECMODE_USER is the default for most servers)
> do not ignore errors on SMBNTEncrypt in SMB Tree Connect.
>
> Reported by Coverity (CID 1226853)
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4cb8450..cdb1aaf 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3696,6 +3696,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  #endif /* CIFS_WEAK_PW_HASH */
>                 rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
>                                         bcc_ptr, nls_codepage);
> +               if (rc) {
> +                       cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
> +                                __func__, rc);
> +                       cifs_buf_release(smb_buffer);
> +                       return rc;
> +               }
>
>                 bcc_ptr += CIFS_AUTH_RESP_SIZE;
>                 if (ses->capabilities & CAP_UNICODE) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
