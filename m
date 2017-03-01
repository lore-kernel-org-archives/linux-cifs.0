From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs running amok after being disconnected (timeout?)
Date: Wed, 01 Mar 2017 10:06:43 -0800
Message-ID: <58B70DB3.6010102@tlinx.org>
References: <58B48122.5000708@tlinx.org> <mpslgsqfuyx.fsf@aaptelpc.suse.de> <58B5F296.1080408@tlinx.org> <mpsefyhfd6b.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsefyhfd6b.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aurélien Aptel wrote:
> L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
>   
>>     Have to gen a new kernel -- about time for that w/4.10 being
>> released...but the last patch and one before don't apply well
>> for some reason ('git' tag? or index up front?)...
>>     
>
> I'm not sure I understand what you mean.
---
    Sorry, I was referring to my normally getting my kernel
source by downloading the patch from the last version from
kernel.org.

    Recently (starting in 4.9), the patch hasn't been able to be
applied with 'patch' (latest version AFAICanTell) but seems or
appears like it might need 'git' -- which defeats the purpose of
creating patches to the released tarballs.

    For now, I just D/L'd the full 4.10.1 tarball, but really need
to get the diff working w/patch again.  Having a git-diff exported
that only will update a git tree is inconvenient, besides being
pointless (i.e. if you have your tree in git, then I don't see
the need for a separate 'diff+patch' that is meant to be applied
to the previous version tarball).

>
> Historically cifs.ko was a samba project. Both have a (neglected :(...)
> cifs section you can use.
>   
----
    Didn't know about samba's cifs section.
> https://bugzilla.samba.org/buglist.cgi?component=kernel%20fs&list_id=11514&product=CifsVFS&resolution=---
> https://bugzilla.kernel.org/buglist.cgi?component=CIFS&product=File%20System&resolution=---
>
>   
>>     I don't specify a protocol on my mount lines, but the
>> samba server doesn't have a SMB2.1 option that I know of (nor
>> a 'SMB3').  Should samba allow specifications of 'smb' > 2?
>>     
>
> The Samba server lets you pick the min and max supported protocols via
> "server min protocol" and "server max protocol" in smb.conf.
====
    Right... my samba version only supports up to SMB2.
>   
>>     As for the client -- Win7, it could use 2.1 I believe
>> (not sure what differences are between 2.1 and 2), but smb3
>> is unavailable for win7.  That said, though, if I don't
>> specify a proto, the client is win7sp1, and the server is
>>     
^^^^^^^^^^^^^^^^^^^^^^^^server
>> the in-kernel CIFS, shouldn't "2.1" be negotiated as
>> the highest level supported?
>>     
>
> (I'm assuming you meant "the server is samba" as there is no in-kernel
> cifs server that I know of)
>   
---
    Sorry, to use the linux-cifs fs on linux, I mean to call
my Win7sp1 a "server". 
> Windows clients will try to negotiate the highest protocol version but
> cifs.ko defaults to 1.0 unless you specify otherwise via -o vers=xyz at
> mount.
>   
----
    *ouch*.  That doesn't sound compatible.  Good to know, I guess.
But if I specify 2.1, and a client can't connect at 2.1, will it fail, or
gracefully fall back to 2.0?  I.e. is the '-o vers=xyz' used to specify
a maximum? 

    you mentioned gettign a trace from when I mount -- but the
reset-loop doesn't start @ mount, but seems to start a few minutes
later (maybe 120 seconds?)...Just checked my settings on the
Win machine (recently "upgraded" (same-to-same) to try to
eliminate some problems on the Win-machine) -- it has a setting
for disconnecting idle clients which had been reset to a
default of 15 minutes, so that's not likely the trigger.  I reset
it back to "don't disconnect" -- useful for my setup.

    Got several things on the plate, so not sure how soon I'll
be able to reboot the lnx server w/new kernel.  Sure would be nice
if it could 'hot boot', but every time I do, the screen doesn't
get reset to default state so can't see any boot messages until
the system runs tty/video setup as services are started (i.e. after
kernel booting has completed).  I really prefer being able to see
what's going on as it boots...*sigh*
