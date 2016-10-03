From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Revamp SMB2 authentication code
Date: Mon, 3 Oct 2016 12:45:56 -0500
Message-ID: <CAH2r5msD+zWcZC9C39Y7Bcr1wK_QUsgd3F0b+JBBOCg2f1SE9g@mail.gmail.com>
References: <1474553094-8884-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474553094-8884-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any reviews of this?

On Thu, Sep 22, 2016 at 9:04 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Revamp the authentication code for SMB2 to bring it in line with the code for
> SMB1 authentication.
>
> This also fixes a double free issue caused when we hit an error generating a
> ntlmssp blob. One way to hit this is to enable FIPS mode which prevents the
> module from using md5 for NTLMSSP authentication.
>
> Sachin Prabhu (2):
>   SMB2: Separate Kerberos authentication from SMB2_sess_setup
>   SMB2: Seperate RawNTLMSSP authentication from SMB2_sess_setup
>
>  fs/cifs/smb2pdu.c | 557 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 352 insertions(+), 205 deletions(-)
>
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
