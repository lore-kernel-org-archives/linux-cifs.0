From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH] SMB2: Enforce sec= mount option
Date: Tue, 10 Jan 2017 14:23:09 -0600
Message-ID: <CAH2r5mvcuhR+C==5ouB1XUUK-7JEc=SH3tt=96g50eEmuVd24A@mail.gmail.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com> <CAH2r5msW1Z1j3J+c3RF7NAH9ChKxy2GajKNp7AUxF4sfeZPXUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msW1Z1j3J+c3RF7NAH9ChKxy2GajKNp7AUxF4sfeZPXUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, Jan 10, 2017 at 2:21 PM
Subject: Re: [PATCH] SMB2: Enforce sec= mount option
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Thinking about this a little more - the only minor correction I would
suggest is that NTLMv2 might as well continue to map to RawNTLMSSP
(since they have similar meanings, ie ntlmv2 hash) - but we could
error out on the others (other than krb5)

On Thu, Dec 8, 2016 at 12:46 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> If the security type specified using a mount option is not supported,
> the SMB2 session setup code changes the security type to RawNTLMSSP. We
> should instead fail the mount and return an error.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5ca5ea46..e66fad6 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -955,7 +955,8 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
>  static int
>  SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
>  {
> -       if (ses->sectype != Kerberos && ses->sectype != RawNTLMSSP)
> +       /* Default sec type is set to RawNTLMSSP */
> +       if (ses->sectype == Unspecified)
>                 ses->sectype = RawNTLMSSP;
>
>         switch (ses->sectype) {
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




-- 
Thanks,

Steve



-- 
Thanks,

Steve
