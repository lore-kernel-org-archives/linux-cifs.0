From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_MD4
Date: Mon, 31 Jan 2011 09:26:16 -0600
Message-ID: <AANLkTi=awRdEWcZd8R7-KE8t+dAQysyfa8tpEsGjq8or@mail.gmail.com>
References: <4D469C99.9050905@suse.de>
	<1296481296-13270-1-git-send-email-jlayton@redhat.com>
	<4D46C02E.6080308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D46C02E.6080308-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Mon, Jan 31, 2011 at 7:59 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> On 01/31/2011 07:11 PM, Jeff Layton wrote:
>> Recently CIFS was changed to use the kernel crypto API for MD4 hashe=
s,
>> but the Kconfig dependencies were not changed to reflect this.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig | =A0 =A01 +
>> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> The patch fixed the problem for me.
>
> Reported-and-Tested-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 27917a5..023d11b 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -3,6 +3,7 @@ config CIFS
>> =A0 =A0 =A0 depends on INET
>> =A0 =A0 =A0 select NLS
>> =A0 =A0 =A0 select CRYPTO
>> + =A0 =A0 select CRYPTO_MD4
>> =A0 =A0 =A0 select CRYPTO_MD5
>> =A0 =A0 =A0 select CRYPTO_HMAC
>> =A0 =A0 =A0 select CRYPTO_ARC4
>
>



--=20
Thanks,

Steve
