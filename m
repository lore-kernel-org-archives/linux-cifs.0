From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Sun, 28 Feb 2016 22:17:09 -0600
Message-ID: <CAH2r5mvPtK7_nyTv5r0ZG1sCLMJbhZ=_B-HFz813N9M02sw2bg@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
 <CAKywueRePEMq7d2bYDZN48_esZrx0P2FofrDDxJ62RtQtX1Xww@mail.gmail.com>
 <CADT32eLG7aNKGqprQPwJdxdDyw__c39sUgX7vdkg=hNNtV63QQ@mail.gmail.com> <CAKywueRcieBmFFjBxzGqQupG1T1Y9aj-viO6q15Dv2w6fHETfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>,
	Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRcieBmFFjBxzGqQupG1T1Y9aj-viO6q15Dv2w6fHETfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

Added Shirish's tested-by and cc: stable

Let me know if any objections to going to stable etc

On Sun, Feb 28, 2016 at 12:22 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2016-02-27 16:50 GMT+03:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Pavel, briefly tested this, it looks good. No error (messages) logged.
>>
>> Tested-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Thanks!
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
