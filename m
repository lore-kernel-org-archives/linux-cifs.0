From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] [PATCH] Multidialect protocol negotiation for cifs.ko
Date: Sun, 17 Sep 2017 16:15:39 -0500
Message-ID: <CAH2r5mvhBefhgB_T-2GgzXSX=Gh3yBULruVjux7_mjhHnUy3sQ@mail.gmail.com>
References: <CAH2r5ms2MG+QoS77v_skYCoRod98xEUmCs2osWJBQUZRAVLhgg@mail.gmail.com>
 <CAH2r5mtVG3DDSwurFPBcELeuahiuLvxnNhKy40Ok0jcP5Yks+g@mail.gmail.com>
 <CAH2r5muynrFupxEE+OCcaepwnn7wKA4Ua9rtXZCbgPdbVmnSUQ@mail.gmail.com> <CAN05THQ57rmKMGJ6_1ehRF7TSX2avOB0c+ra+nqhSBqT8p=d5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN05THQ57rmKMGJ6_1ehRF7TSX2avOB0c+ra+nqhSBqT8p=d5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ok - renamed to SMBDEFAULT_VERSION (from SMB3DEFAULT_VERSION) and
repushed to cifs-2.6.git for-next (along with additional comment fix
from Pavel)

On Sun, Sep 17, 2017 at 3:27 PM, ronnie sahlberg
<ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>
> Minor nit:
> +       } else if (strcmp(tcon->ses->server->vals->version_string,
> +               SMB3DEFAULT_VERSION_STRING) == 0) {
> +               vneg_inbuf.Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
> +               vneg_inbuf.Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
> +               vneg_inbuf.Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>
> SMB3DEFAULT_VERSION has SMB3 in the name but also offers and supports smb2.1
> I have no suggestion on a better name though :-(
>
>
>
> On Mon, Sep 18, 2017 at 1:21 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> updated with more feedback
>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=513f5b9040fdb0d1af887da9919be3fc07dcc236
>>
>> On Sat, Sep 16, 2017 at 4:00 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Updated with feedback from Pavel
>>>
>>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>>>
>>> On Fri, Sep 15, 2017 at 10:59 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> SMB2.1 or later dialect (instead of forcing only SMB3) for cifs.ko -
>>>> makes it easier if server is Windows 7 (last release dialect default
>>>> was upgraded from smb1/cifs to smb3 - but multidialect negotiation was
>>>> not supported until now)
>>>>
>>>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=0e0f8ad440ac117685aeed4df16f320c7e9ac1c6
>>>>
>>>> or see attached
>>>>
>>>>
>>>>
>>>> --
>>>> Thanks,
>>>>
>>>> Steve
>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
