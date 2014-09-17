From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SMB3][PATCHv3 Add mfsymlinks support for SMB2.1/SMB3
Date: Wed, 17 Sep 2014 10:48:06 -0700
Message-ID: <CAH2r5muLEObKLLsEnrE4n2dfpS04Jk8DdVU7xgzJKOuryYNk4g@mail.gmail.com>
References: <CAH2r5mvpBeoOuT59AzVpvHTzX1RxJM0X=3BO7UyCU1p4zarTcQ@mail.gmail.com>
 <CAKywueQBBHgk8Fk+SLsgBkXGk9V5CDcT_7+7RCQzjbSD1HDwvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQBBHgk8Fk+SLsgBkXGk9V5CDcT_7+7RCQzjbSD1HDwvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you want I can add it to SMB2.0.  I was a little worried about
whether the oplock flags were the same for the call to SMB2_open, but
if so I can test it.

On Wed, Sep 17, 2014 at 5:18 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2014-09-17 12:14 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Updated version of the mfsymlinks patches are in cifs-2.6.git for-next
>> branch and have tested out fine at the SMB3 plugfest here this week
>>
>> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>
> What's about SMB2.0 protocol version?
>
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve
