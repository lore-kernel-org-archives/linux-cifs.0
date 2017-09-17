From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: hide unused functions
Date: Sun, 17 Sep 2017 17:03:10 -0500
Message-ID: <CAH2r5mvtUBU9VY0yA32nj5jubgTxxygqQNScjH=w3e6Gz21GmQ@mail.gmail.com>
References: <20170905092440.2172429-1-arnd@arndb.de> <CAMuHMdVjDKE4Gx_GK81SMiZ1ZttWXBVFrMpTbbeH8HFMuU_Ewg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdVjDKE4Gx_GK81SMiZ1ZttWXBVFrMpTbbeH8HFMuU_Ewg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Sun, Sep 10, 2017 at 5:28 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> On Tue, Sep 5, 2017 at 11:24 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>> The newly added SMB2+ attribute support causes unused function
>> warnings when CONFIG_CIFS_XATTR is disabled:
>>
>> fs/cifs/smb2ops.c:563:1: error: 'smb2_set_ea' defined but not used [-Werror=unused-function]
>>  smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>> fs/cifs/smb2ops.c:513:1: error: 'smb2_query_eas' defined but not used [-Werror=unused-function]
>>  smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
>>
>> This adds another #ifdef around the affected functions.
>>
>> Fixes: 5517554e4313 ("cifs: Add support for writing attributes on SMB2+")
>> Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>
> Acked-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
