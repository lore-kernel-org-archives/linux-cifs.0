From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs running amok after being disconnected (timeout?)
Date: Tue, 28 Feb 2017 13:58:46 -0800
Message-ID: <58B5F296.1080408@tlinx.org>
References: <58B48122.5000708@tlinx.org> <mpslgsqfuyx.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpslgsqfuyx.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aurélien Aptel wrote:
> Hi,
>
> L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
>   
>> I tried turning on debug by echoing 1 to /proc/fs/cifs/traceSMB, and that
>> "effectively" stopped the conversation, as it was then saturating my
>> message log with lines like:
>>     
>
> enabling traceSMB just does a hexdump of every packet sent on the
> wire. You probably want this:
>
>     echo 1 > /proc/fs/cifs/cifsFYI
>     echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
>     echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
>
> with CONFIG_CIFS_DEBUG, CONFIG_CIFS_DEBUG2, CONFIG_DYNAMIC_DEBUG enabled.
>   
----
    Have to gen a new kernel -- about time for that w/4.10 being
released...but the last patch and one before don't apply well
for some reason ('git' tag? or index up front?)...

>
>   
>> Any idea what might have been going on?  Anything better tracing
>> options to determine what was going on?
>>     
>
> As you said it seems the server keeps reseting the tcp connexion. A full
> trace starting from the initial mount will help.
>
> You should be able to open a bug on either samba on the kernel
> bugtracker and attach traces there.
>   
----
    kernel seems best for kernel-based stuff.
> Have you tried to mount using a newer protocol (2.1 or 3.0)? (using
> e.g. -o vers=2.1)
>   
----
    I don't specify a protocol on my mount lines, but the
samba server doesn't have a SMB2.1 option that I know of (nor
a 'SMB3').  Should samba allow specifications of 'smb' > 2?

    As for the client -- Win7, it could use 2.1 I believe
(not sure what differences are between 2.1 and 2), but smb3
is unavailable for win7.  That said, though, if I don't
specify a proto, the client is win7sp1, and the server is
the in-kernel CIFS, shouldn't "2.1" be negotiated as
the highest level supported?
