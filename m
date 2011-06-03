From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_ECB
Date: Fri, 3 Jun 2011 12:39:41 -0500
Message-ID: <BANLkTimhjwe1Ry8JR+bTixSRmd86gHADTw@mail.gmail.com>
References: <4DE89FFD.6040006@suse.de>
	<20110603091007.7c7b9910@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110603091007.7c7b9910-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged.  This is a strange dependency - it looks like thee real
problem is that the two crypto libs we depend on that depend on this
don't select ECB but it is harmless to add the select.

On Fri, Jun 3, 2011 at 8:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 03 Jun 2011 14:19:01 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> When CONFIG_CRYPTO_ECB is not set, trying to mount a CIFS share with=
 NTLM
>> security resulted in mount failure with the following error:
>> =A0 =A0"CIFS VFS: could not allocate des crypto API"
>>
>> Seems like a leftover from commit 43988d7.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig | =A0 =A01 +
>> =A01 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 1cd4c3a..66c68ab 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -7,6 +7,7 @@ config CIFS
>> =A0 =A0 =A0 select CRYPTO_MD5
>> =A0 =A0 =A0 select CRYPTO_HMAC
>> =A0 =A0 =A0 select CRYPTO_ARC4
>> + =A0 =A0 select CRYPTO_ECB
>> =A0 =A0 =A0 select CRYPTO_DES
>> =A0 =A0 =A0 help
>> =A0 =A0 =A0 =A0 This is the client VFS module for the Common Interne=
t File System
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
