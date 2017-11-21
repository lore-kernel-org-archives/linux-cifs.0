From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: do not send invalid input buffer on QUERY_INFO requests
Date: Mon, 20 Nov 2017 17:10:30 -0800
Message-ID: <CAKywueTbGHNrABXjdKg1LCgCaK+iOj31p0TnGXUShGcxLW=NRA@mail.gmail.com>
References: <mpsa80ruowd.fsf@aaptelpc.suse.de> <20171017124717.25955-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017124717.25955-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-17 5:47 GMT-07:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> query_info() doesn't use the InputBuffer field of the QUERY_INFO
> request, therefore according to [MS-SMB2] it must:
>
> a) set the InputBufferOffset to 0
> b) send a zero-length InputBuffer
>
> Doing a) is trivial but b) is a bit more tricky.
>
> The packet is allocated according to it's StructureSize, which takes
> into account an extra 1 byte buffer which we don't need
> here. StructureSize fields must have constant values no matter the
> actual length of the whole packet so we can't just edit that constant.
>
> Both the NetBIOS-over-TCP message length ("rfc1002 length") L and the
> iovec length L' have to be updated. Since L' is computed from L we
> just update L by decrementing it by one.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6f0e6343c15e..b927e131f997 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2191,9 +2191,13 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
>         req->PersistentFileId = persistent_fid;
>         req->VolatileFileId = volatile_fid;
>         req->AdditionalInformation = cpu_to_le32(additional_info);
> -       /* 4 for rfc1002 length field and 1 for Buffer */
> -       req->InputBufferOffset =
> -               cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
> +
> +       /*
> +        * We do not use the input buffer (do not send extra byte)
> +        */
> +       req->InputBufferOffset = 0;
> +       inc_rfc1001_len(req, -1);
> +

I was looking at the code and noticed that build_qfs_info_req() uses
the same pattern of initializing InputBufferOffset field. Do we need
to fix it in the same way?

--
Best regards,
Pavel Shilovsky
