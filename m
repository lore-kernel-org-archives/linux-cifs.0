From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: Better dependencies
Date: Wed, 1 Feb 2017 14:01:58 -0600
Message-ID: <CAH2r5mvjSOmfn+eFo8TzuJzttN6zGCUEJcF11pGmynNYtana9A@mail.gmail.com>
References: <20170125160639.255cd58e@endymion> <CAKywueQdAQ004cy2gGQTeDCeHwoT70Wug5LUgenANqGrmi9ziw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQdAQ004cy2gGQTeDCeHwoT70Wug5LUgenANqGrmi9ziw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

Thanks - this is helpful



On Wed, Jan 25, 2017 at 1:26 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2017-01-25 7:06 GMT-08:00 Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>:
>> Hi all,
>>
>> This is my attempt to fix and improve the dependencies of cifs.
>>
>> [PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
>> [PATCH 2/3] cifs: Only select the required crypto modules
>> [PATCH 3/3] cifs: Add soft dependencies
>>
>> I already sent this patch series one year ago, but did not get any
>> reply, so I am trying again.
>>
>> Thanks,
>> --
>> Jean Delvare
>> SUSE L3 Support
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Looks good.
>
> Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> --
> Best regards,
> Pavel Shilovsky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
