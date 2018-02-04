From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: silence compiler warnings showing up with gcc-8.0.0
Date: Sat, 3 Feb 2018 19:27:43 -0600
Message-ID: <CAH2r5msFvyukg=QWPQMcR8bPuRWcdys0rdc5P-Tr1KPYLBgwhw@mail.gmail.com>
References: <20180202154902.1626750-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Samuel Cabrero <scabrero-l3A5Bk7waGM@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202154902.1626750-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Fri, Feb 2, 2018 at 9:48 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> This bug was fixed before, but came up again with the latest
> compiler in another function:
>
> fs/cifs/cifssmb.c: In function 'CIFSSMBSetEA':
> fs/cifs/cifssmb.c:6362:3: error: 'strncpy' offset 8 is out of the bounds [0, 4] [-Werror=array-bounds]
>    strncpy(parm_data->list[0].name, ea_name, name_len);
>
> Let's apply the same fix that was used for the other instances.
>
> Fixes: b2a3ad9ca502 ("cifs: silence compiler warnings showing up with gcc-4.7.0")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 72d71703f1e8..78bc86c315ec 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -6343,9 +6343,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
>         pSMB->InformationLevel =
>                 cpu_to_le16(SMB_SET_FILE_EA);
>
> -       parm_data =
> -               (struct fealist *) (((char *) &pSMB->hdr.Protocol) +
> -                                      offset);
> +       parm_data = (void *)pSMB + offsetof(struct smb_hdr, Protocol) + offset;
>         pSMB->ParameterOffset = cpu_to_le16(param_offset);
>         pSMB->DataOffset = cpu_to_le16(offset);
>         pSMB->SetupCount = 1;
> --
> 2.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
