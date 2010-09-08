From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: smb2 configuration
Date: Wed, 08 Sep 2010 11:35:35 -0700
Message-ID: <4C87D777.2080905@candelatech.com>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>	<20100901171418.44685b74@tlielax.poochiereds.net>	<4C7EC614.6020505@candelatech.com>	<20100901203836.2628ce57@tlielax.poochiereds.net>	<4C7F3111.80808@candelatech.com>	<20100902065602.6a62825c@corrin.poochiereds.net>	<AANLkTi=ezVf0b1Cu+HBKRb7Sns5+bDeFwpV649Ub_RAs@mail.gmail.com>	<4C807886.6010908@candelatech.com>	<AANLkTimo-jibAy-D6j1oVy0d5-VwXrtz=Cnxvv6=g5a_@mail.gmail.com>	<4C81724C.9030702@candelatech.com> <AANLkTimGmcSeQEfS_u221RBzR04L_q25kWO31zvouxFM@mail.gmail.com> <4C87C793.3040800@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C87C793.3040800-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/08/2010 10:27 AM, Ben Greear wrote:
> On 09/03/2010 03:21 PM, Steve French wrote:
>> Good point - I need to update the smb2 howto ...
>>
>>
>> If you have Windows 2008, Windows Vista or Windows 7 - smb2 just works
>> (it is the default for current Windows) but for Samba (version 3.5 or
>
> Ok, I found a vista machine to test against for now.
>
>> On the client side, you need smb2.ko from my smb2.git tree (which
>> currently has some changes I need to put in to address some sideeffects
>> of the Google Summer of Code smb2 async write performance improvements)
>> - and if you don't want to use ip addresses (mount -t smb2
>> //127.0.0.1/someshare <http://127.0.0.1/someshare> /mnt .... etc) then
>> you need to recompile mount.cifs.c as mount.smb2 and put mount.smb2 in
>> /sbin
>
> Do I understand correctly that I should be able to use standard mount
> so long as I use IP addresses?
>
> What do you mean about recompile mount.cifs.c? Do you mean rename
> mount.cifs to
> mount.smb2? Or do I need to hack on mount.cifs.c code? If I need to do any
> re-compiling at all, please point me to the proper upstream repository for
> these changes.
>
> It doesn't seem to be working on Fedora 13. I checked that smb2 module
> is loaded.
>
> [root@ct503-10G-09 ]# mount -t smb2 -o
> srcaddr=192.168.100.106,user=lf,passwd=lf //192.168.100.125/pub
> /mnt/lf/smb2
> mount: unknown filesystem type 'smb2'

I tried installing the latest util-linux-ng and cifs-utils,
but still no luck:

[root@ct503-10G-09 mount]# mount -v -t smb2 -o user=lf,pass=lf //192.168.100.125/pub /mnt/lf/smb2
mount.smb2 kernel mount options: ip=192.168.100.125,unc=\\192.168.100.125\pub,,ver=1,user=lf,pass=********
mount error: smb2 filesystem not supported by the system
mount error(19): No such device
Refer to the mount.smb2(8) manual page (e.g. man mount.smb2)

I'm out of ideas on this.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
