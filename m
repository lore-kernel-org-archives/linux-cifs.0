From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2 protocol support for CIFS Linux kernel module
Date: Tue, 25 Oct 2011 10:16:59 +0400
Message-ID: <CAKywueTbj1zy+oKBYj_ncf-zisu3ckZOtajaqKNMhmofAERMbg@mail.gmail.com>
References: <CAKywueQV4QS5FZiSr8zkeH6tpUokuN4a-yKn5mmZ7F8F_V8_mA@mail.gmail.com>
	<20111020112058.185cae5e@barsoom.rdu.redhat.com>
	<CAKywueSJoApMc8RrDO-nfd64FWdNG_Zdw2-Mse01wK3B0h+VzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSJoApMc8RrDO-nfd64FWdNG_Zdw2-Mse01wK3B0h+VzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/20 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/10/20 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> On Fri, 14 Oct 2011 13:31:10 +0400
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Hi all!
>>>
>>> I rebased my cifs-3.2-current branch on top of current
>>> cifs-2.6/master. It includes all patches (lock caching + smb2 patches)
>>> I want to get into 3.2 release.
>>>
>>> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-3.2-current
>>>
>>> Comments are welcome!
>>>
>>> --
>>> Best regards,
>>> Pavel Shilovsky.
>>
>> I started looking over them, but it's hard to comment since almost all
>> of them haven't been sent to the list and there's nothing to reply to.
>>
>> Would it be possible to send this to the list in one or more patchsets
>> so it can be reviewed like any other series?
>>
>> Thanks,
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>
> Thanks! I will split it into several patchset and post to the list in
> this case. The last version of patches is here:
>
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-3.2-aread
>
> --
> Best regards,
> Pavel Shilovsky.
>

I've posted SMB2 patches to linux-cifs@ mail list.

-- 
Best regards,
Pavel Shilovsky.
