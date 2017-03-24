From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Reset TreeId to zero on SMB2 TREE_CONNECT
Date: Thu, 23 Mar 2017 23:30:00 -0500
Message-ID: <CAH2r5mu7+fr4Pr3TD=i6qJT1pMV5hs+HdvHWf_f=gmpu6_k29A@mail.gmail.com>
References: <1487589958-20489-1-git-send-email-glogow@fbihome.de> <efd254dc-ecd6-5ea7-7850-b287c64071c2@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <efd254dc-ecd6-5ea7-7850-b287c64071c2-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I plan to merge this

On Thu, Mar 23, 2017 at 1:17 PM, Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> wrote:
> Hi everyone,
>
> just replying to my own patch mail.
>
> The patch is now pending for a month. I saw other stuff picked up for
> linux-next and wondered, if it was missing something?
>
> The patch was developed with the help of Aurelien Aptel, originally in
> the "Fix SMB2_TREE_CONNECT requests with the wrong TreeId" thread
> starting 2017-02-10.
>
> There is a bug report with an attached trace and my debug scripts at
> https://bugzilla.samba.org/show_bug.cgi?id=12584
>
> Best regards,
>
> Jan-Marek Glogowski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
