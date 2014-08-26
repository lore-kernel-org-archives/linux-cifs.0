From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cthon failure
Date: Mon, 25 Aug 2014 19:05:53 -0500
Message-ID: <CAH2r5ms5=vV2XD2oP2NoaLavsZCo=x4w=w7vvshzNQRNJ1RkFw@mail.gmail.com>
References: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q@mail.gmail.com>
 <20140821211338.GC17035@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140821211338.GC17035@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I just tried it on recent Samba (from about a week ago) with the same results

Version 4.2.0pre1-GIT-47e7440
and also
Version 4.1.6-Ubuntu

If "store dos attributes = yes" (on by default in Ubuntu) is in smb.conf

then the following fails
mount -t cifs //someserver/someshare /mnt
touch /mnt/newfile1
chmod 0000 /mnt/newfile1
stat /mnt/newfile1   (mode displays as expected)
rm /mnt/newfile1  (fails with access denied)

if the identical scenario is tried with "store dos attributes = no" in
smb.conf then it works
mount -t cifs //someserver/someshare /mnt
touch /mnt/newfile2
chmod 0000 /mnt/newfile2
stat /mnt/newfile2  (mode displays as expected)
rm /mnt/newfile2   (delete works), and also removing the newfile1
created above also works)
rm /mnt/newfile1 (also works)

Details:
posix unlink (set path info) fails with access denied/status cannot
delete, as does subsequent smb delete.   Attempts to clear the
readonly bit also fails with access denied

The chmod 0000 causes Samba server to set the read-only dos attribute
in the failing case

On Thu, Aug 21, 2014 at 4:13 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, Aug 19, 2014 at 09:33:12PM -0500, Steve French wrote:
>> Noticed that even with Unix Extensions on cifs mount that Samba
>> refuses to delete a file in this scenario (locally and presumably over
>> nfs it still works since it is in cthon suite).  This causes
>> connectathon special tests to fail
>>
>> touch newfile
>> chmod 0000 newfile
>> rm newfile
>>
>> (works locally but samba rejects)
>>
>> Samba 4.1 rejects posix unlink (set path info) STATUS_CANNOT_DELETE
>> then client falls back to SMB unlink which fails.  STATUS_CANNOT_DELETE
>> then client falls back to a set path info of file info basic which
>> also fails STATUS_ACCESS_DENIED
>>
>> Will do quick test with Samba master when build completes - but does
>> this server unlink bug look familiar (or am I missing an smb.conf that
>> I have forgotten about)?
>
> Can't reproduce this on current v4-1-test
> git branch.
>
> Can you give me details please ?
>
> Jeremy.



-- 
Thanks,

Steve
