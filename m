From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 3/8] vfs: Add O_DENYREAD/WRITE flags support for open syscall
Date: Tue, 5 Feb 2013 15:45:31 +0400
Message-ID: <CAKywueRh++TBazK8_kRN7AUb=EFhGv=Sv2CV0BESkfLFy+g5wA@mail.gmail.com>
References: <1358441584-8783-1-git-send-email-piastry@etersoft.ru>
	<1358441584-8783-3-git-send-email-piastry@etersoft.ru>
	<20130130221602.GC15584@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130130221602.GC15584-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/1/31 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Thu, Jan 17, 2013 at 08:52:59PM +0400, Pavel Shilovsky wrote:
>> If O_DENYMAND flag is specified, O_DENYREAD/WRITE/MAND flags are
>> translated to flock's flags:
>>
>> !O_DENYREAD  -> LOCK_READ
>> !O_DENYWRITE -> LOCK_WRITE
>> O_DENYMAND   -> LOCK_MAND
>>
>> and set through flock_lock_file on a file.
>>
>> This change only affects opens that use O_DENYMAND flag - all other
>> native Linux opens don't care about these flags. It allow us to
>> enable this feature for applications that need it (e.g. NFS and
>> Samba servers that export the same directory for Windows clients,
>> or Wine applications that access the same files simultaneously).
>
> The use of an is_conflict callback seems unnecessarily convoluted.
>
> If we need two different behaviors, let's just use another flag (or an
> extra boolean argument if we need to, or something).

Ok, we can pass "bool is_mand" to flock_lock_file that will pass it
further to flock_locks_conflict.

>
> The only caller for this new deny_lock_file is in the nfs code--I'm a
> little unclear why that is.

deny_lock_file is called not only in the nfs code but also in 2 places
of fs/namei.c -- that enable this logic for VFS.

-- 
Best regards,
Pavel Shilovsky.
