From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] [PATCH] Multidialect protocol negotiation for cifs.ko
Date: Sun, 17 Sep 2017 10:21:25 -0500
Message-ID: <CAH2r5muynrFupxEE+OCcaepwnn7wKA4Ua9rtXZCbgPdbVmnSUQ@mail.gmail.com>
References: <CAH2r5ms2MG+QoS77v_skYCoRod98xEUmCs2osWJBQUZRAVLhgg@mail.gmail.com>
 <CAH2r5mtVG3DDSwurFPBcELeuahiuLvxnNhKy40Ok0jcP5Yks+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtVG3DDSwurFPBcELeuahiuLvxnNhKy40Ok0jcP5Yks+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

updated with more feedback
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=513f5b9040fdb0d1af887da9919be3fc07dcc236

On Sat, Sep 16, 2017 at 4:00 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Updated with feedback from Pavel
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>
> On Fri, Sep 15, 2017 at 10:59 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> SMB2.1 or later dialect (instead of forcing only SMB3) for cifs.ko -
>> makes it easier if server is Windows 7 (last release dialect default
>> was upgraded from smb1/cifs to smb3 - but multidialect negotiation was
>> not supported until now)
>>
>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=0e0f8ad440ac117685aeed4df16f320c7e9ac1c6
>>
>> or see attached
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
