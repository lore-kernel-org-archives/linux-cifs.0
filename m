From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Mon, 2 May 2011 19:25:39 +0400
Message-ID: <BANLkTimC=649Mj42NBa+p0zQZL13YJM1Vg@mail.gmail.com>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
	<loom.20110502T163337-799@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kai Blin <kai-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110502T163337-799-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/2 Kai Blin <kai-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Pavel Shilovsky <piastry@...> writes:
>
> Hi Pavel,
>
>>
>> Add rwpidforward mount option that switches on a mode when we forward
>> pid of a process who opened a file to any read and write operation.
>>
>> This can prevent applications like WINE from failing on read or write
>> operation on a previously locked file region from the same netfd from
>> another process if we use mandatory brlock style.
>> It is actual for WINE because during a run of WINE program two processes
>> work on the same netfd - share the same file struct between several VFS
>> fds:
>> 1) WINE-server does open and lock;
>> 2) WINE-application does read and write.
>
> I'm not sure I fully understand what problem you're trying to solve here.
> The Wine server should take care of all the locking-related operations and make
> sure the application process should have access to the file. I'm not familiar
> with exactly how this happens, but I'm not sure how this would be any different
> for CIFS-based file systems opposed to local file systems. I'm pretty sure it
> works fine for local file systems.
>
> Can you elaborate what problem you're seeing that your patches fix?
>
> Cheers,
> Kai
>
> PS: I'm not subscribed to this list, so please CC me :)
>

You are right - wineserver takes care about all these things if we
work on local filesystem. But if we work on CIFS share the situation
changes. When we negotiate mandatory locking style CIFS server
compares pid of process who tries to do read/write with file with pid
of byte-range lock (if one exists) on this area of the file. If pids
don't match it fails operation. So, that's why I did this change - to
do read and write operations with the pid of process who sets
byte-range locks (wineserver). As the result, with this patch (I
splited it into two) we do lock, write and read with the same pid and
it works good.

-- 
Best regards,
Pavel Shilovsky.
