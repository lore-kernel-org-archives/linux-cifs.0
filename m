From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: replaced kmalloc + memset with kzalloc
Date: Sun, 24 Mar 2013 23:17:49 -0500
Message-ID: <CAH2r5ms73QumoAKFazs_=8L9i+7WGFWrNzYAQ3eJXxXDJGsiQA@mail.gmail.com>
References: <1362918544-31796-1-git-send-email-winged.flamespitter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Dia Vasile <kill.elohim-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
To: Dia Vasile <winged.flamespitter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362918544-31796-1-git-send-email-winged.flamespitter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next branch

On Sun, Mar 10, 2013 at 7:29 AM, Dia Vasile
<winged.flamespitter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Dia Vasile <kill.elohim-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
>
> Signed-off-by: Diana Vasile <kill.elohim-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 41d9d07..83ef66e 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -846,12 +846,10 @@ create_lease_buf(u8 *lease_key, u8 oplock)
>  {
>         struct create_lease *buf;
>
> -       buf = kmalloc(sizeof(struct create_lease), GFP_KERNEL);
> +       buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
>         if (!buf)
>                 return NULL;
>
> -       memset(buf, 0, sizeof(struct create_lease));
> -
>         buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
>         buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
>         if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
> --
> 1.7.10.4
>



-- 
Thanks,

Steve
