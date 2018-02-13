From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/14] cifs: fix memory leak in SMB2_open()
Date: Tue, 13 Feb 2018 16:10:48 -0600
Message-ID: <CAH2r5muqS3szwdXW054uE5vOCOSKoOOnXBHvptT=SWm+p6_6XQ@mail.gmail.com>
References: <20180213044234.18364-1-lsahlber@redhat.com> <20180213044234.18364-11-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-11-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next and added cc:stable

On Mon, Feb 12, 2018 at 10:42 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ac6b1d8d0c88..511c441c6b4f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1773,8 +1773,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                 rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
>                                                  &name_len,
>                                                  tcon->treeName, path);
> -               if (rc)
> +               if (rc) {
> +                       cifs_small_buf_release(req);
>                         return rc;
> +               }
>                 req->NameLength = cpu_to_le16(name_len * 2);
>                 uni_path_len = copy_size;
>                 path = copy_path;
> @@ -1785,8 +1787,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                 if (uni_path_len % 8 != 0) {
>                         copy_size = roundup(uni_path_len, 8);
>                         copy_path = kzalloc(copy_size, GFP_KERNEL);
> -                       if (!copy_path)
> +                       if (!copy_path) {
> +                               cifs_small_buf_release(req);
>                                 return -ENOMEM;
> +                       }
>                         memcpy((char *)copy_path, (const char *)path,
>                                uni_path_len);
>                         uni_path_len = copy_size;
> --
> 2.13.3
>



-- 
Thanks,

Steve
