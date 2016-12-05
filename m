From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix a possible memory corruption during reconnect
Date: Mon, 5 Dec 2016 13:39:14 -0800
Message-ID: <CAKywueTggpV8DD6Tbtnf=c+=Bef9mB89zVpB=8GG_F2fOP+bJw@mail.gmail.com>
References: <1478820683-2954-1-git-send-email-pshilov@microsoft.com>
 <1480500055.3937.8.camel@redhat.com> <CAKywueRP6BV3d=--yETisU=8u+jCmeuZyUcvnsrx-RCOqLGphw@mail.gmail.com>
 <1480584953.3937.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480584953.3937.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-12-01 1:35 GMT-08:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 2016-11-30 at 11:24 -0800, Pavel Shilovsky wrote:
>>
>> > Do you need the #ifdef CONFIG_CIFS_SMB2 here considering that there
>> > are
>> > no such macro definitions around the declarations around
>> > delayed_work
>> > reconnect in struct TCP_Server_Info. It would also lead to unused
>> > variable in case the kernel is compiled without CONFIG_CIFS_SMB2.
>>
>> Thank you for reviewing this.
>>
>> I posted the next version of the patch yesterday ([PATCH 4/5] CIFS:
>> Fix a possible memory corruption during reconnect) that addresses
>> this
>> problem by moving fields inside TCP_Server_Info to CONFIG_CIFS_SMB2.
>>
>
> Thanks. I'll review the patch separately.
>
>
>> > > +             /* No need to send echo on newly established
>> > > connections */
>> > > +             mod_delayed_work(cifsiod_wq, &server->reconnect,
>> > > 0);
>> > > +             return rc;
>> >
>> > Shouldn't this be queue_work?
>>
>> It is made it this way because of the following: if someone submitted
>> the work with a delay previously (now the code doesn't do it but it
>> is
>> possible in the future), we want to overwrite this delay to 0 since
>> we
>> need an immediate session/tcon reconnect here.
>>
>
> OK. It should work without any problem but I would have stuck to the
> expected functions and use mod_delayed_work() only when new code which
> queues the work separately has been added. It is strange to see only
> mod_delayed_work() when the work isn't queued anywhere else. Apart from
> that small concern, I am fine with it.
>
> Sachin Prabhu

Ok, it makes sense. I have posted the next version (v2) of the
patchset that addresses your suggestions to the list.

-- 
Best regards,
Pavel Shilovsky
