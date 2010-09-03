From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs srcaddr-v4] cifs: Allow binding to local IP address.
Date: Fri, 03 Sep 2010 15:27:42 -0700
Message-ID: <4C81765E.2090605@candelatech.com>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>	<20100901171418.44685b74@tlielax.poochiereds.net>	<4C7EC614.6020505@candelatech.com>	<20100901203836.2628ce57@tlielax.poochiereds.net>	<4C7F3111.80808@candelatech.com>	<20100902065602.6a62825c@corrin.poochiereds.net>	<AANLkTi=ezVf0b1Cu+HBKRb7Sns5+bDeFwpV649Ub_RAs@mail.gmail.com>	<4C807886.6010908@candelatech.com>	<AANLkTimo-jibAy-D6j1oVy0d5-VwXrtz=Cnxvv6=g5a_@mail.gmail.com>	<4C81724C.9030702@candelatech.com>	<AANLkTimGmcSeQEfS_u221RBzR04L_q25kWO31zvouxFM@mail.gmail.com> <AANLkTins-m95_tjyxgQGjzDQ+bMehGpAMinAKap_pPF1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTins-m95_tjyxgQGjzDQ+bMehGpAMinAKap_pPF1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/03/2010 03:21 PM, Steve French wrote:
> On Fri, Sep 3, 2010 at 5:21 PM, Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>>
>> Good point - I need to update the smb2 howto ...
>>
>> If you have Windows 2008, Windows Vista or Windows 7 - smb2 just works (it is the default for current Windows) but for Samba (version 3.5 or later, but current Samba 3.6 server is better and passes Microsoft's (and our) functional tests as a server - the client side in the kernel is farther behind) there is an smb.conf entry to add.   A recent blog entry summarized the server side for Samba:
>>
>> With Windows 7 Microsoft have introduce a new variant of the CIFS protocol, SMB2. Samba is keeping pace, with a sample implementation of SMB2 which will be released for early adopters to test in Samba 3.5.0. A fully finished production version is expected to be available in Samba 3.6.0. Testing SMB2 in Samba 3.5.0 is as simple as setting :
>>
>> max protocol = SMB2
>>
>> in the [global] section of your smb.conf
>>
>> On the client side, you need smb2.ko from my smb2.git tree (which currently has some changes I need to put in to address some sideeffects of the Google Summer of Code smb2 async write performance improvements) - and if you don't want to use ip addresses (mount -t smb2 //127.0.0.1/someshare /mnt .... etc) then you need to recompile mount.cifs.c as mount.smb2 and put mount.smb2 in /sbin
>> The smb2 development tree for the kernel client is at:
>> http://git.kernel.org/?p=linux/kernel/git/sfrench/smb2.git;a=summary
>> I have 3 patches from Pavel to integrate still and a few other fixes (one for unmount in particular) that need to be posted.  I expect it to be more stable usable by next week (I have been out much of this week)
>> On Fri, Sep 3, 2010 at 5:10 PM, Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:

Ok.  Fedora 13 has smbd version 3.5.4, so maybe that will do the trick.
If not, I should be able to dig up a vista system.

I should be able to get hacking on this next week.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
