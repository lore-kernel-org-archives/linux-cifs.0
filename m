From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: US-Cert recommends disabling SMB1
Date: Tue, 17 Jan 2017 13:06:30 -0600
Message-ID: <CAH2r5mvWiDpCKdiz-JL3LQGAwVCbZ37Z1_E6yR75UFtbQnhbWQ@mail.gmail.com>
References: <1484670992.21675.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484670992.21675.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

No surprise that we should disable cifs ... now our challenge

1) make SMB3 (linux kernel implementation clearly) better than cifs including
   - the POSIX/Unix Extensions, which we were close to agreement on ...
   - compounding (open/query/close)
   - some minor feature finishup (xattrs and acls eg)
Although in most ways SMB3 is already better
2) finishup key security features
    - Pavel's encryption patches need more review ASAP (he has a
github branch for these and I plan to merge into for-next fairly soon)
    - SMB3.1.1 secure negotiate and crypto negotiation finishup
3) more testing to make sure we didn't miss anything ...

On Tue, Jan 17, 2017 at 10:36 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The following advisory was released by US-CERT.
>
> https://www.us-cert.gov/ncas/current-activity/2017/01/16/SMB-Security-B
> est-Practices
>
> Sachin Prabhu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
