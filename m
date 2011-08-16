From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS can't read share
Date: Tue, 16 Aug 2011 12:19:59 -0500
Message-ID: <CAH2r5mt85ru7gUXgpk3zn9Kn4PF6YATx18GLL0DR39n+bsD4Eg@mail.gmail.com>
References: <OFF2DA68D6.9F5E142E-ON862578EE.0055727B-862578EE.00558DE9@jci.com>
	<CAH2r5mumWMETXL4M2Dj8cd_Z9e0HU3qJyqrU=YFijJGO526JuA@mail.gmail.com>
	<OF17F3B38E.A7A77DE2-ON862578EE.005CCD63-862578EE.005D5CBB@jci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF17F3B38E.A7A77DE2-ON862578EE.005CCD63-862578EE.005D5CBB-zES+1Ur7hjI@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Interesting - looks like different servers (Windows CE vs. Windows
2008).  An obvious difference between the two is the successful one
uses level 260 (FIND_FILE_BOTH_DIRECTORY_INFO) vs. the failing one
uses the common level 257 (FIND_FILE_DIRECTORY_INFO).   The server
should support this level (so that is likely a bug in the server) -
but we could probably fall back (or actually "up" to a higher info
level) on this particularly error.

Also note that mounting "noserverino" causes us to use a different
info level - if you used the default
(which is normally recommended) - the client would use level
SMB_FIND_FILE_ID_FULL_DIR_INFO
(level 0x106).   Can you try it and see if ls fails when you mount
with the default (serverino) instead of "noserverino" ?

On Tue, Aug 16, 2011 at 11:59 AM,  <Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org> wrot=
e:
> Sure. Here is a trace of my windows desktop mounting the share
> successfully, and a trace of linux (3.6.39.4) successfully mounting b=
ut
> unsuccessfully "ls"ing.
>
>
> Easiest to see if you filter with eth.addr=3D=3D00-10-8D-01-C1-CA in =
both...
>
>
>
> From:
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To:
> Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org
> Cc:
> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date:
> 08/16/2011 11:35 AM
> Subject:
> Re: CIFS can't read share
>
>
>
> Windows server version? (if you don't know it from the wireshark trac=
e
> of sessionsetup - you can view /proc/fs/cifs/DebugData)
>
> Do you have the wireshark trace we could see?
>
> On Tue, Aug 16, 2011 at 10:34 AM, =A0<Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org> =
wrote:
>> I can mount my Windows share with "mount -t cifs //10.2.8.42/myshare
>> /mnt/myshare -o
>> user=3DUSER,password=3Dcat,domain=3DWORKGROUP,sec=3Dntlmssp,noserver=
ino". But
> when
>> I try to access the contents of the directory I get "NT Status:
>> STATUS_INVALID_LEVEL" according to wireshark.
>>
>> Is this a known issue? Is there some configuration I need to add to =
the
>> kernel?
>>
>> Thanks for your help.
>>
>> Bryan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Thanks,
>
> Steve
>
>
>



--=20
Thanks,

Steve
