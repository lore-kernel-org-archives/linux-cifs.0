From: ROBIN CERNIN <cerninr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS - VFS error question
Date: Fri, 28 Sep 2012 23:03:16 +0200
Message-ID: <CAFdSyFHYeNbbFV-qiE-8TieHXaJ6uDSe8HVQdS2zunxxouzTnA@mail.gmail.com>
References: <CAFdSyFFkcSbBrqH7mgBJxFL+kfZNuMBK+8ZGoarPxQeAS0rXng@mail.gmail.com>
	<1348735029.2633.20.camel@localhost>
	<20120927090409.3d2febe7@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120927090409.3d2febe7-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

this problem as you said looks like that disturbance in network that
disconnects the CIFS share and server is trying to write to it when
its disconnected. We will see if the automated script that tries to
remount the CIFS share automatically when network disturbance
disconnects it will help...

I am very satisfied with RHEL 5, we dont need case for this as small
script could fix this.
I am not bothered about time outs as these seems not to be problem at
all. Also we have our own apps that runs on RHEL 5 and are written for
it especially.

and thanks Steve for explaining.

Thank you and appreciate your help,
with Best Regards, Robin


On Thu, Sep 27, 2012 at 3:04 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 27 Sep 2012 09:37:09 +0100
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Wed, 2012-09-26 at 09:33 +0200, ROBIN CERNIN wrote:
>> > Hello,
>> >
>> > First of all I wanna say you are doing great job developing cif-utils.
>> > Secondly I have question on using following version of cifs:
>> >
>> > filename:       /lib/modules/2.6.18-308.8.1.
>> > el5/kernel/fs/cifs/cifs.ko
>> > version:        1.60RH
>> > description:    VFS to access servers complying with the SNIA CIFS
>> > Specification e.g. Samba and Windows
>> > license:        GPL
>> > author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> > srcversion:     63D9396D38F380652744D7E
>> > depends:
>> > vermagic:       2.6.18-308.8.1.el5 SMP mod_unload gcc-4.1
>> > parm:           CIFSMaxBufSize:Network buffer size (not including
>> > header). Default: 16384 Range: 8192 to 130048 (int)
>> > parm:           cifs_min_rcv:Network buffers in pool. Default: 4
>> > Range: 1 to 64 (int)
>> > parm:           cifs_min_small:Small network buffers in pool. Default:
>> > 30 Range: 2 to 256 (int)
>> > parm:           cifs_max_pending:Simultaneous requests to server.
>> > Default: 50 Range: 2 to 256 (int)
>> > module_sig:    883f3504fa440f6a462ac2afa8e12f112b2f409f6ea4176acbbe7f2f2c13e944e9a17d507b429c09c8e9ef6118eb3d5c40fcbfa81c96bf86e626c06e
>> >
>> > on RHEL get following errors in the /var/log/messages:
>> >
>> > Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39222
>> > Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39231
>> > Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39236
>> > Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Send error in SessSetup = -5
>> > Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Unexpected lookup error -5
>> > Sep 25 13:08:25 xxxxxxx kernel:  CIFS VFS: No response for cmd 6 mid 47208
>> > Sep 25 16:50:27 xxxxxxx kernel:  CIFS VFS: No response for cmd 162 mid 48857
>> > Sep 25 20:07:37 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 50442
>> >
>
> As Steve pointed out the above indicates a lot of timed-out requests.
> The EIO errors however are somewhat troubling. It's not clear what
> would have caused that...
>
>> >
>> > Can you please clarify a bit to me what are these errors related to? I
>> > dont hear anyone complaing that this isnt working but I can still see
>> > these errors.
>> Hi Robin,
>>
>> Did you have any network outages or network congestion at those times?
>> It appears the client for some reason couldn't receive a response from
>> the server.
>>
>> Sachin Prabhu
>>
>
> It's not uncommon for windows servers to take a long time to respond to
> certain types of requests. For instance, writes that are long past the
> EOF can take *minutes*. NTFS doesn't do sparse files efficiently and
> has to zero-fill the gaps before it replies.
>
> More recent kernels (including RHEL6) implement a different mechanism
> for timing out requests that's more resilient in the face of this sort
> of server behavior. RHEL5 however is approaching its end of life, and
> backporting something that invasive is probably a non-starter.
>
> If you have a RH support contract, you may want to open a case so we
> can help you do some better diagnosis.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
