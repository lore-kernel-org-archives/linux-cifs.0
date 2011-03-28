From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
 (try #2)
Date: Mon, 28 Mar 2011 10:50:54 +0530
Message-ID: <4D901AB6.4090504@suse.de>
References: <1301127285-3573-1-git-send-email-piastry@etersoft.ru>	<20110327064857.6fc346f0@tlielax.poochiereds.net>	<AANLkTimOx-P95k-Jvg_ESiYii7bd7RzWYpjxQnkvAf7k@mail.gmail.com>	<AANLkTi=b7k8eCRK0eT9DwDMkGFDkX0hJjPFVjx4se5=x@mail.gmail.com> <AANLkTikX82d36rS99JHyuG6yH0d_qki-Ak0dxuwQ6-x5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikX82d36rS99JHyuG6yH0d_qki-Ak0dxuwQ6-x5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/28/2011 02:12 AM, Steve French wrote:
> On Sun, Mar 27, 2011 at 2:10 PM, Pavel Shilovsky<piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>  wrote:
>> 2011/3/27 Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> As for fsycn logic - as I understand this call - it ought to
>> synchronize data between a cache and storage device. But if we can't
>> free pages, we don't successfully complete this synchronization - so,
>> reporting -EBUSY error here doesn't seem wrong to me (may be we should
>> set -EIO error code - according to the man page). If I am mistaken,
>> please, explain your points.
>
> To me synchronizing means that all data was written to the
> server that was dirty at the time of the call.

Yes, I too think that fsync should make sure that pages that were dirty 
(when fsync started) should be synched to stable storage and need not 
worry about the pages that were redirtied after the fsync call.


-- 
Suresh Jayaraman
