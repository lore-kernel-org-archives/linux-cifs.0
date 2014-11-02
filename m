From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unable to mount using credentials file
Date: Sun, 2 Nov 2014 12:58:03 -0600
Message-ID: <CAH2r5mvX47aAePRM0-G3hec_ETs7pw3s+MsPf8a=n6mi6c1q2w@mail.gmail.com>
References: <loom.20141101T124621-513@post.gmane.org> <CANzfOVLmYUWPoTD8zF7oDFJ-XR57sPTBH=yJQ4mzPd2zgapFog@mail.gmail.com>
 <00bc01cff5ef$e5361770$afa24650$@ieee.org> <CAH2r5mupp47fyNw7t_EEvdQSzk-oNPNm8C9vfdNSvbMqr6GcPA@mail.gmail.com>
 <000001cff685$0d849630$288dc290$@ieee.org> <CAH2r5mur=q=nJhpYWRRK_6CQgxYF067pxpiCtnHWQ3y9NiXX5A@mail.gmail.com>
 <001501cff6bd$292e5d70$7b8b1850$@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001501cff6bd$292e5d70$7b8b1850$@ieee.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If "mount -t cifs --verbose //server/share /mnt -o ..."  doesn't
display the verbose output then I really doubt that you have
mount.cifs installed in the right place for the distro (mount
automatically looks for a mount helper to match the fstype you specify
after "-t" e.g. for -t cifs it would look for mount.cifs).    You
probably aren't getting to mount.cifs
The output of mount when verbose is enabled looks like
         mount.cifs kernel mount options:
ip=127.0.0.1,unc=\\localhost\share etc.
Also note that you can "echo 7 > /proc/fs/cifs/cifsFYI" before mount
to turn on debugging calls for cifs in the kernel and then after mount
look for the cifs messages in the kernel message log (type "dmesg").
You can see what username for example is being passed in and make sure
that that is correct

What version of mount.cifs do you have ?  Type "/sbin/mount.cifs -V"
to display the mount helper version.  Current is 6.4 but earlier
versions should be fine for your purposes (there are some cifscreds
fixes in 6.4 but not obvious why they should matter for your use
case).


On Sun, Nov 2, 2014 at 10:50 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> wrote:
> Here is the output from mount -t cifs --verbose -o ... for the failing case:
> mount: mounting //<IP address>/<share> on /mnt/<mountpoint>/ failed: Invalid argument
> There is still no output when I add --verbose to the successful case.
> There is no verbose option listed for mount --help.
> Thanks for your help.
>
> -----Original Message-----
> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Sunday, November 2, 2014 5:30 PM
> To: Roger Brooks
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Unable to mount using credentials file
>
> mount with call mount.cifs (if it is present in /sbin) when you specify "mount -t cifs"
>
> You can specify --verbose before the -o (see
> http://linux.die.net/man/8/mount.cifs) and it will show the mount options being passed in to the kernel syscall so it would be useful for debugging to compare the exact parameters being passed in to the kernel in the working vs. failing case by specifying --verbose before the -o
>
> On Sun, Nov 2, 2014 at 4:09 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> wrote:
>> P.S. To answer my own question below, experimentation shows that mount and umount still fulfill their normal functions for volumes mounted directly with mount.cifs.
>> So, much as it irritates me not to know why mount -o credentials doesn't work, I can live with using mount.cifs instead.
>> Thanks to all who responded!
>>
>> Thanks for the tips, Steve!
>>
>> My version of mount:
>> BusyBox v1.16.1 (2014-10-10 08:37:09 CST) multi-call binary.
>> does not appear to have a verbose option. At least:
>> mount --help
>> does not list any such option, and mount does not return any information to the console when it succeeds, regardless of whether or not I specify -v.
>>
>> The failure message is also unchanged with the -v option:
>> mount: mounting //<IP address>/<share> on /mnt/<mountpoint> failed:
>> Invalid argument
>>
>> Also, I have read that mount maintains /etc/mtab.
>> Does that mean that mount will not list volumes which I mounted directly with mount.cifs, and that I cannot use umount to unmount volumes mounted directly with mount.cifs?
>>
>> -----Original Message-----
>> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Saturday, November 1, 2014 5:24 PM
>> To: Roger Brooks
>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: Unable to mount using credentials file
>>
>> using /sbin/mount.cifs directly should be fine.   When you mount with
>> verbose mount option does it show any useful differences between the
>> two cases (working vs. failing)
>>
>> On Sat, Nov 1, 2014 at 11:21 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> wrote:
>>> P.S.
>>> There was a non-printing character in the directory name under /root.
>>> After correcting that, mount.cifs -o credentials=<filename> works.
>>> However, mount -t cifs -o credentials=<filename> still returns "Invalid argument".
>>> Can I just use mount.cifs directly, or does mount perform some additional needed housekeeping?
>>> If mount is needed, how can I get -o credentials to work?
>>> TIA for any tips!
>>>
>>> Hi Benjamin,
>>>
>>> Thanks for responding.
>>>
>>> The credentials file is a simple text file created with vi containing the lines:
>>>>>
>>> username=<user>
>>> password=<password>
>>> <<
>>> I have tried this both with and without trailing newline at the end of the second line.
>>>
>>> I have also tried the variant:
>>>>>
>>> username=<user>
>>> password=<password>
>>> domain=<domain>
>>> <<
>>>
>>> The results are always the same.
>>> If there is a problem with the *content* of the file, why would the error message say that the file could not be opened?
>>>
>>> Thanks for your help!
>>> Best Regards,
>>> Roger
>>>
>>> From: Benjamin Bellec [mailto:b.bellec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>>> Sent: Saturday, November 1, 2014 1:34 PM
>>> To: Roger Brooks
>>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: Re: Unable to mount using credentials file
>>>
>>> Hi,
>>> Does your credential file is correctly formatted ?
>>>
>>> 2014-11-01 13:03 GMT+01:00 Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>:
>>> I am attempting to mount Windows volumes on a Synology DS (running DSM 5.0, a Debian-based distribution).
>>> Command lines of the form:
>>> mount -t cifs -o username=<user>,password=<pass> //<IP address>/share/ /mnt/<mountpoint> succeed.
>>> However, command lines of the form:
>>> mount -t cifs -o credentials=<filename> //<IP address>/share/ /mnt/<mountpoint> fail with the error "Invalid argument".
>>> For diagnostic purposes, I have attempted to mount the volumes directly using mount.cifs (v5.5).
>>> Once again, commands of the form:
>>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o
>>> username=<user>,password=<password>
>>> succeed.
>>> However, commands of the form:
>>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=<file> fail with the error message:
>>> error -1 (Unknown error 4294967295) opening credential file <file>
>>> This is the case regardless of the location of the file (see
>>> http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file-t
>>> d
>>> 2518214.html) or its privileges.  The error persists, even when the
>>> command is executed from a root session and the credentials file has permissions 0777 and is in a subdirectory of /root.
>>> How can I get mount to work using a credentials file?
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
