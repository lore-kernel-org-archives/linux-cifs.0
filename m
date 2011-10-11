From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: add new module parameter 'enable_oplocks'
Date: Tue, 11 Oct 2011 13:50:46 -0500
Message-ID: <CAH2r5mv=SruLndtjRjPkpF27n5ekokk7SwMgY+4eOpehbJBpHg@mail.gmail.com>
References: <4E946788.3060101@suse.de>
	<20111011124405.37e09487@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011124405.37e09487-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 11:44 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 11 Oct 2011 21:28:00 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> Thus spake Jeff Layton:
>>
>> "Making that a module parm would allow you to set that parameter at =
boot
>> time without needing to add special startup scripts. IMO, all of the
>> procfile "switches" under /proc/fs/cifs should be module parms
>> instead."
>>
>> This patch doesn't alter the default behavior (Oplocks are enabled b=
y
>> default).
>>
>> To disable oplocks when loading the module, use
>>
>> =A0 =A0modprobe cifs enable_oplocks=3D0
>>
>> (any of '0' or 'n' or 'N' conventions can be used).
>>
>> To disable oplocks at runtime using the new interface, use
>>
>> =A0 =A0echo 0 > /sys/module/cifs/parameters/enable_oplocks
>>
>> The older /proc/fs/cifs/OplockEnabled interface will be deprecated
>> after two releases. A subsequent patch will add an warning message
>> about the deprecation.
>>
>> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 | =A0 =A05 +++++
>> =A0fs/cifs/cifsglob.h | =A0 =A03 +++
>> =A0fs/cifs/dir.c =A0 =A0 =A0| =A0 =A02 +-
>> =A0fs/cifs/file.c =A0 =A0 | =A0 =A04 ++--
>> =A04 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 3e29899..675ab40 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -81,6 +81,11 @@ module_param(echo_retries, ushort, 0644);
>> =A0MODULE_PARM_DESC(echo_retries, "Number of echo attempts before gi=
ving up and "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"reconnec=
ting server. Default: 5. 0 means "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"never re=
connect.");
>> +unsigned int enable_oplocks =3D 1;
>> +module_param(enable_oplocks, bool, 0644);
>> +MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool).=
 Default:"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"y/Y/1"=
);
>> +
>> =A0extern mempool_t *cifs_sm_req_poolp;
>> =A0extern mempool_t *cifs_req_poolp;
>> =A0extern mempool_t *cifs_mid_poolp;
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 6255fa8..b3e229c 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -936,6 +936,9 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* =
MAX requests at once to server*/
>> =A0/* reconnect after this many failed echo attempts */
>> =A0GLOBAL_EXTERN unsigned short echo_retries;
>>
>> +/* enable or disable oplocks */
>> +GLOBAL_EXTERN unsigned int enable_oplocks;
>> +
>
> Let's not add an extra variable for this. I'd just rename oplockEnabl=
ed
> to enable_oplocks and fix up all the references to it. It should
> probably also be a bool too...

Right, leave as one variable - as I mentioned in the earlier note, it
also looks like adding
another variable broke the logic in Suresh's patch.


--=20
Thanks,

Steve
