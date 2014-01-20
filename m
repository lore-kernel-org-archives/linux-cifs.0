From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] Cleanup open codepath
Date: Mon, 20 Jan 2014 10:00:13 -0600
Message-ID: <CAH2r5mvGSmR7QNt7KeXGCR0rxZHQQJvrd=pSZkT0iBXZdMJP7Q@mail.gmail.com>
References: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
 <CAH2r5muANBSSsG_adMzpwZcbn2-wWJK34xrY+5iRyMrdeGJv+A@mail.gmail.com> <CAKywueRQMAhs-on41eLB7ju8L1fz3R7U=Bdi4mHcXcQ3GJOJOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRQMAhs-on41eLB7ju8L1fz3R7U=Bdi4mHcXcQ3GJOJOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Those four that you just sent checkpatch clean.

Merged into cifs-2.6.git

Any additional Reviewed-by would be appreciated for those 4.

On Mon, Jan 20, 2014 at 4:24 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 2014/1/20 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> looks reasonable but am getting various minor whitespace errors
>> scanning the patch series
>>
>> Can you fixup and make sure it is checkpatch clean?
>>
>> e.g.
>>
>> ERROR: trailing whitespace
>> #123: FILE: fs/cifs/dir.c:650:
>> +^I/*^M$
>>
>> ERROR: trailing whitespace
>> #124: FILE: fs/cifs/dir.c:651:
>> +^I * BB Do not bother to decode buf since no local inode yet to put^M$
>>
>> ERROR: trailing whitespace
>> #125: FILE: fs/cifs/dir.c:652:
>> +^I * timestamps in, but we can reuse it safely.^M$
>>
>
> Steve, are you sure you got right variants? I tested my patches with
> checkpatch.pl and everything was ok. I applied them on top of your
> current for-next branch and attached.
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve
