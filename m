From: Rajesh Srinivasan <rajesh.chivas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Request update on Bug 194691 - Unreachable CIFS mount hangs system
Date: Wed, 28 Jun 2017 17:08:42 +0530
Message-ID: <CADg6pLma0nHYFZGSz4SAh4CnNTejtD7CELUXAo+=7rVtErJe=Q@mail.gmail.com>
References: <CADg6pLkLC9BuYDOvwkV86jJq7ZpjV2DrLexGvtsjFzVYu6RZsA@mail.gmail.com>
 <CAKywueQBznxKkXNnCNOuYHLA-J0N59-Je+zt5J1u7YXAyH6KSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQBznxKkXNnCNOuYHLA-J0N59-Je+zt5J1u7YXAyH6KSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

The issue is reproducible on 3.16.42 and 3.16.44.

Thanks,
Rajesh

On Wed, Jun 28, 2017 at 10:37 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2017-06-27 21:25 GMT-07:00 Rajesh Srinivasan <rajesh.chivas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Hi,
>>
>> Could you please review the bug 194691
>> https://bugzilla.kernel.org/show_bug.cgi?id=194691 and let me know if
>> there are any upcoming patches that can fix this issue.
>>
>> This has become a severe issue for our software after upgrading from
>> 3.14 to 3.16 and any pointers on handling it would help.
>>
>> Thanks,
>> Rajesh
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Reconnect fixes were backported to 3.16 kernel starting from v3.16.42
> version. I suggest upgrading the kernel from v3.16.38 (as mentioned in
> the bug) to the newer one.
>
> --
> Best regards,
> Pavel Shilovsky
