From: ROBIN CERNIN <cerninr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS - VFS error question
Date: Thu, 27 Sep 2012 10:59:04 +0200
Message-ID: <CAFdSyFEZG46JM0w5vmFLFm6WWQ_qtK1AtEiM3+sqsy_ULh8S5Q@mail.gmail.com>
References: <CAFdSyFFkcSbBrqH7mgBJxFL+kfZNuMBK+8ZGoarPxQeAS0rXng@mail.gmail.com>
	<1348735029.2633.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348735029.2633.20.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

thank you for great communication with you, I was not hoping that
someone will actually answer me.
This looks to me that we are not yet doomed:)

and anyway where is the network in perfect condition...am I right? :-)
however I am not aware of any outage, depending how much network this
needs. Packets are lost here and there everyday...
This doesn't seems to be a trouble problem as nobody is complaining
but this bothers me because it fills my /var/log/messages and informs
me every time. I first saw these messages and didn't find any
explanation for them. I thought that it would be nice to have a
comments on the errors so if also other people get error they can look
it up in Wiki or somewhere.

I think that in the Internet are plenty of questions but not real answers.
And to be it reliable message I though you guys could make something
because you are the ones who can:)

Steve already explained very nicely "cmd 50 response" which is time
out on listing files, directories and others. Which i know can occur
in network disturbance.

Here are again the errors still getting:
 kernel:  CIFS VFS: Send error in Close = -11.
 kernel:  CIFS VFS: Send error in SessSetup = -5.
 kernel:  CIFS VFS: Unexpected lookup error -6.

I have not checked running CIFS on newer kernel version yet. I ll have
to find some servers first.
I thought this is something that I could ignore or filter from my
messages as this I thought may be let's say access denied or
connection closed by other side but again if I do that I just think if
i m not going to miss some big problem then.

Thank you all,

Best Regards,
Robin Cernin

On Thu, Sep 27, 2012 at 10:37 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2012-09-26 at 09:33 +0200, ROBIN CERNIN wrote:
>> Hello,
>>
>> First of all I wanna say you are doing great job developing cif-utils.
>> Secondly I have question on using following version of cifs:
>>
>> filename:       /lib/modules/2.6.18-308.8.1.
>> el5/kernel/fs/cifs/cifs.ko
>> version:        1.60RH
>> description:    VFS to access servers complying with the SNIA CIFS
>> Specification e.g. Samba and Windows
>> license:        GPL
>> author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> srcversion:     63D9396D38F380652744D7E
>> depends:
>> vermagic:       2.6.18-308.8.1.el5 SMP mod_unload gcc-4.1
>> parm:           CIFSMaxBufSize:Network buffer size (not including
>> header). Default: 16384 Range: 8192 to 130048 (int)
>> parm:           cifs_min_rcv:Network buffers in pool. Default: 4
>> Range: 1 to 64 (int)
>> parm:           cifs_min_small:Small network buffers in pool. Default:
>> 30 Range: 2 to 256 (int)
>> parm:           cifs_max_pending:Simultaneous requests to server.
>> Default: 50 Range: 2 to 256 (int)
>> module_sig:    883f3504fa440f6a462ac2afa8e12f112b2f409f6ea4176acbbe7f2f2c13e944e9a17d507b429c09c8e9ef6118eb3d5c40fcbfa81c96bf86e626c06e
>>
>> on RHEL get following errors in the /var/log/messages:
>>
>> Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39222
>> Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39231
>> Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39236
>> Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Send error in SessSetup = -5
>> Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Unexpected lookup error -5
>> Sep 25 13:08:25 xxxxxxx kernel:  CIFS VFS: No response for cmd 6 mid 47208
>> Sep 25 16:50:27 xxxxxxx kernel:  CIFS VFS: No response for cmd 162 mid 48857
>> Sep 25 20:07:37 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 50442
>>
>>
>> Can you please clarify a bit to me what are these errors related to? I
>> dont hear anyone complaing that this isnt working but I can still see
>> these errors.
> Hi Robin,
>
> Did you have any network outages or network congestion at those times?
> It appears the client for some reason couldn't receive a response from
> the server.
>
> Sachin Prabhu
>
