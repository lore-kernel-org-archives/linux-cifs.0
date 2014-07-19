From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Fri, 18 Jul 2014 23:49:04 -0500
Message-ID: <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140718170952.GA27001@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 18, 2014 at 12:09 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, Jul 18, 2014 at 01:15:07AM -0500, Steve French wrote:
>> I created a patch to cifs.ko to add fallocate FALLOC_FL_KEEP_SIZE
>> support and did some tests against a Samba server (Samba 4.1.6 on ext4
>> on Ubuntu) and also a Windows 8.1 server (NTFS file system) and ran
>> into an obvious problem.  How to tell if the allocation size is
>> changed?  Neither stat on the Samba server local file system nor the
>> Windows 8.1 properties show the size on disk changing.
>>
>> I am sending SMB3 SetInfo level 0x13 (set allocation size) and getting
>> success back from the Windows server and from Samba server.
>>
>> If I set the length past the end of file I get no error, but the
>> properties of the file in Windows Explorer still show the same (e.g.
>> zero) as the file size.  If I try setting it to a size smaller than
>> the size of the file, the file shrinks (by the way this is an awkward
>> behavior to work around since on Linux fallocate can't shrink the file
>> - so if you have any ideas short of revalidating the file size before
>> deciding whether to send the fallocate request to Windows ...).
>>
>> Any ideas why Samba shows success but doesn't actually call ext4 to
>> update the allocation size?
>
> smbd does use VFS_FALLOCATE_KEEP_SIZE, which maps
> into fallocate FALLOC_FL_KEEP_SIZE if the underlying
> storage supports it.
>
> You need to set "strict allocate = true" on the
> share in order to get this behavior though.
>
> If you're setting allocation size smaller
> than file size we just use ftruncate, I
> don't see another possibility here. What
> behavior do you expect in the shrink case ?

Windows shrinks the file (unlike Linux) when you do the allocate
before end of file, but when I tried the same call to
Samba it seemed to ignore it, return success and leave
file size alone.


-- 
Thanks,

Steve
