From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] cifs: fix a possible use of uninit variable in SMB2_sess_setup
Date: Wed, 20 Aug 2014 19:14:45 -0500
Message-ID: <CAH2r5muJxcmQbkt2mGhyv3do_PTr6YMHO7Rp-ZdQkdGV5_fcmw@mail.gmail.com>
References: <003901cfbc63$0cb24e70$2616eb50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003901cfbc63$0cb24e70$2616eb50$@samsung.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Aug 20, 2014 at 5:39 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> In case of error, goto ssetup_exit can be hit and we could end up using
> uninitialized value of resp_buftype
>
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index a40f492..ab366e5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -531,7 +531,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>         struct smb2_sess_setup_rsp *rsp = NULL;
>         struct kvec iov[2];
>         int rc = 0;
> -       int resp_buftype;
> +       int resp_buftype = CIFS_NO_BUFFER;
>         __le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
>         struct TCP_Server_Info *server = ses->server;
>         u16 blob_length = 0;
> --
> 1.7.7
>



-- 
Thanks,

Steve
