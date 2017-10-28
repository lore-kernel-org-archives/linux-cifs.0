From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: long name length protection triggering when it shouldn't
Date: Sat, 28 Oct 2017 11:55:34 +1000
Message-ID: <CAN05THQys0eScP3DoUFAxVtDFPKhzdcFpCnXO=0GopF7Tk4kFQ@mail.gmail.com>
References: <alpine.DEB.2.20.1710261653580.1395@Lib-ITS13.lib.duke.edu>
 <355654398.20246337.1509057377124.JavaMail.zimbra@redhat.com> <alpine.DEB.2.20.1710272053520.3868@Lib-ITS13.lib.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jack Hill <jackhill-4+jYJfmkT58@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1710272053520.3868-WLjXm773ss2rwpbwKtlw2QLqUvEzMhQG@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks for testing and confirming the patch fixes the issue.

I will try to figure out why the mount options affect this. But that
is not as urgent.





On Sat, Oct 28, 2017 at 10:58 AM, Jack Hill <jackhill-4+jYJfmkT58@public.gmane.org> wrote:
> On Thu, 26 Oct 2017, Leif Sahlberg wrote:
>
>> Can you try that patch and confirm if it fixes the issue for you too ?
>
>
> I am happy to confirm that the patch fixes the issue for me.
>
> Is it worth trying to figure out why MaxPathNameComponentLength is not being
> set correctly? For me, it seems to be set correctly when I use different
> mount options (either a different sec= option, or when using multiuser).
>
> Do you expect the proposed patch to be the eventual fix that ends up in a
> released kernel?
>
>
> Thanks,
> Jack
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
