From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Sat, 27 Feb 2016 07:50:08 -0600
Message-ID: <CADT32eLG7aNKGqprQPwJdxdDyw__c39sUgX7vdkg=hNNtV63QQ@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
	<CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
	<CAKywueRePEMq7d2bYDZN48_esZrx0P2FofrDDxJ62RtQtX1Xww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>,
	Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRePEMq7d2bYDZN48_esZrx0P2FofrDDxJ62RtQtX1Xww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel, briefly tested this, it looks good. No error (messages) logged.

Tested-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Feb 27, 2016 at 3:31 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2016-02-27 12:11 GMT+03:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> 2016-02-23 15:55 GMT+03:00 Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>:
>>>
>>> If the server sends an interim response, then the real response, the real
>>> response, is handled by standard_receive3() in the kernel, instead of the
>>> proper function, and this causes a disconnect.  If there isn't a
>>> disconnect, I believe the reply will just be discarded if I understand the
>>> code correctly.  (That is a big if here ;) )
>>>
>>> I've written a patch for Samba to stop sending interim replies on
>>> SMB2_READ
>>> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
>>> may want to add SMB2_CREATE to the list of ops we don't send async replies
>>> for non-compounded, but I'm not sold either way, I know we CAN go async
>>> there!  I want some opinions here.
>>>
>>> This is not hidden behind a flag because compatibility issues that don't
>>> impact protocol correctness usually aren't.
>>>
>>> Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
>>> If you have a cleaner approach, I welcome it.
>>>
>>> I request you please ASK me before pushing this one, yes, that means you
>>> jra!
>>>
>>> For those interested in reproduction: I'd suggest using a server that's
>>> rebuilt with a lower timeout set in smb2_read.c, though we've hit it with
>>> vfs_glusterfs straight up, in our testing.
>>>
>>> Thanks,
>>>
>>> -Ira / ira@(samba.org|redhat.com|wakeful.net)
>>
>>
>>
>> Thank you for catching this!
>>
>> It is the issue in the kernel client - a check for interim responses is
>> missed for SMB2_READ command. I created a patch that should fix the problem.
>>
>> Could you please test it?
>>
>> --
>> Best regards,
>> Pavel Shilovsky
>
> CC'ing @samba-technical.
>
> Sorry for the spam.
>
> --
> Best regards,
> Pavel Shilovsky
