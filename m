From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] [PATCH] cifs: retry kernel_sendmsg only in case of -EAGAIN
Date: Tue, 02 Oct 2012 15:52:34 +0530
Message-ID: <506AC06A.1030009@suse.com>
References: <506948FD.3090602@suse.com> <20121001214017.60f41311@corrin.poochiereds.net> <CAH2r5msunor+xKU5tjgyuD+y3Qfist8kAHze7DwcC0SkAOe5tg@mail.gmail.com> <20121001215030.5487c930@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001215030.5487c930-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/02/2012 07:20 AM, Jeff Layton wrote:
> On Mon, 1 Oct 2012 20:46:01 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> How can we be certain that ENOSPC is no longer returned? When it was

I had traced kernel_sendmsg() and the functions it is calling, but I
couldn't find any of them returning -ENOSPC. Also, I couldn't find any
other callers of kernel_sendmsg() checking for -ENOSPC.

>> returned then the obvious thing was to block briefly and retry.
>>
>> Does it do any harm?

When I tried to analyze what might cause the error reported here
  http://thread.gmane.org/gmane.linux.kernel/1367198/focus=1367498

I bumped into this code. I had a few questions that I couldn't answer like

a) When does kernel_sendmsg return -ENOSPC?
b) Even if we assume it returns -ENOSPC, does it really make sense to retry?
c) Does the error condition that lead to -ENOSPC rectify by the time we
retry?
d) Why do we need to reset -ENOSPC to -EAGAIN before returning the error?

If we can answer these questions reasonably, we may not need this patch.

> 
> Can you explain the situation that caused it to return -ENOSPC in the
> first place? Why that and not -EAGAIN? Or -ENOBUFS?

I too thought -ENOBUFS might represent the condition better.


Thanks
Suresh
> 
>> On Mon, Oct 1, 2012 at 8:40 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On Mon, 01 Oct 2012 13:10:45 +0530
>>> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>>>
>>>> In smb_sendv(), we seem to retry if kernel_sendmsg() returned either
>>>> -ENOSPC or -EAGAIN. In either case after multiple attempts, we set the
>>>> error to -EAGAIN before breaking out of the loop.
>>>>
>>>> First, it is not clear to me when kernel_sendmsg() can return -ENOSPC,
>>>> and what it would mean and why should we retry. It makes me wonder
>>>> whether this check is part of some old code. Also, there seem to be no
>>>> need to set the error back to -EAGAIN before we break out the loop.
>>>> Fix this by making cifs retry only if kernel_sendmsg() returns -EAGAIN.
>>>>
>>>> If the above discussion make sense, here is a patch to fix this.
>>>> ---
>>>>
>>>> Retry kernel_sendmsg() only in case of -EAGAIN and remove redundant
>>>> error assignment.
>>>>
>>>>
>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
>>>> ---
>>>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>>> index d9b639b..a33db4c 100644
>>>> --- a/fs/cifs/transport.c
>>>> +++ b/fs/cifs/transport.c
>>>> @@ -154,7 +154,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>>>>       while (total_len) {
>>>>               rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
>>>>                                   n_vec - first_vec, total_len);
>>>> -             if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
>>>> +             if (rc == -EAGAIN) {
>>>>                       i++;
>>>>                       /*
>>>>                        * If blocking send we try 3 times, since each can block
>>>> @@ -177,7 +177,6 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>>>>                       if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
>>>>                               cERROR(1, "sends on sock %p stuck for 15 seconds",
>>>>                                   ssocket);
>>>> -                             rc = -EAGAIN;
>>>>                               break;
>>>>                       }
>>>>                       msleep(1 << i);
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> That ENOSPC has been there a long time, and I think you're correct that
>>> it's of questionable value.
>>>
>>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>>
>>
> 
> 
