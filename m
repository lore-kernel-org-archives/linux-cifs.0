From: Timothy Davenport <warrickguy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs case insensitivity
Date: Sun, 15 Jun 2014 16:31:06 -0400
Message-ID: <CAPO=4gABJ15KMyDbM68qHEM15O385Yp7P2AMT-qTrt19ABDBzQ@mail.gmail.com>
References: <CAPO=4gDhsduZ24Ah3rGKVEWY6CPHeFPnr+QbSoXkoZCiuvRGUg@mail.gmail.com>
	<CAH2r5muHk5_bQz1jBTaGtEQ8yPBUHN_uD8O0twoEA9Qe0gHo=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muHk5_bQz1jBTaGtEQ8yPBUHN_uD8O0twoEA9Qe0gHo=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve:

The NAS's (servers) run linux but are managed through a web interface
and have no root access.

I added,   unix extensions = yes   to /etc/samba/smb.conf [global] on
my client (debian) machine but it didn't help.

I added it to /usr/share/samba/smb.conf also for good measure even
though I don't think it's used

I retired from IBM in 2010



On Sun, Jun 15, 2014 at 3:31 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Are Unix extensions enabled in the smb.conf on your server?
>
> The default on the server is unix extensions = yes   but I wonder if
> unix extensions are getting turned off somehow on client or server
>
> On Sun, Jun 15, 2014 at 2:23 PM, Timothy Davenport <warrickguy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I've noticed a problem with case insensitivity on my cifs mounts.  I
>> ran into it when upgrading from Linux Mint 13 to 17.  I've since
>> determined that the problem also exists on debian testing.
>> The shares on my NAS boxes (Buffalo and ZyXEL) are case sensitive with
>> Mint 13 and debian stable (wheezy).  They are case insensitive on Mint
>> 17 and debian testing (jessie).  I do a lot of file renaming
>> (upper/lower casing) and the insensitivity poses a real problem.
>>
>> Here is an example from fstab for one of my shares and the mount command used.
>>
>> //10.2.76.31/android    /mnt/ls-pro-android    cifs
>> users,noauto,credentials=/home/trdavenport/sambapw,iocharset=utf8    0
>>    0
>>
>> mount     /mnt/ls-pro-android
>>
>> As a test I first installed a new instance of debian stable (Linux
>> 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3+deb7u2)(cifs.ko v.1.76),
>> installed cifs-utils (2:5.5-1) and configured everything to access my
>> shares.  This resulted in case sensitive access to all my shares.
>>
>> Without making any other changes I installed a backported kernel
>> (Linux 3.12-0.bpo.1-amd64 #1 SMP Debian 3.12.9-1~bpo70+1)(cifs.ko
>> v.2.02) and with that all my shares are case insensitive.  Using grub
>> I can switch back and forth between the two kernels and the results
>> are consistent.
>>
>> Have I missed an option or configuration that would address this?  I
>> think the nocase option is supposed to turn off sensitivity, but can't
>> find anything to turn it on.
>>
>> Could this fix ( http;//article.gmane.org/gmane.linux.kernel.cifs/8832
>> )  from 2013-09-12 have something to do with it?
>>
>> If I use fuse/gvfs, all the shares are case sensitive on debian stable
>> and testing as well as Mint 13 and 17.
>>
>>  --
>> Tim Davenport
>> Gatlinburg, Tennessee  USA
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve



-- 
Tim Davenport
Gatlinburg, Tennessee  USA
