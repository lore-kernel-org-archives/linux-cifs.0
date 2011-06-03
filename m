From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_ECB
Date: Fri, 03 Jun 2011 23:59:09 +0530
Message-ID: <4DE927F5.9000906@suse.de>
References: <4DE89FFD.6040006@suse.de>	<20110603091007.7c7b9910@corrin.poochiereds.net>	<BANLkTimhjwe1Ry8JR+bTixSRmd86gHADTw@mail.gmail.com> <20110603140218.02d3315e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110603140218.02d3315e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/03/2011 11:32 PM, Jeff Layton wrote:
> On Fri, 3 Jun 2011 12:39:41 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Merged.  This is a strange dependency - it looks like thee real
>> problem is that the two crypto libs we depend on that depend on this
>> don't select ECB but it is harmless to add the select.
>>
> 
> Hmm...then maybe the patch should this dependency there so that other
> kernel subsystems don't get bitten by the same problem?

I looked at a few in-tree examples:

>From drivers/net/Kconfig

config PPP_MPPE
        tristate "PPP MPPE compression (encryption) (EXPERIMENTAL)"
        depends on PPP && EXPERIMENTAL
        select CRYPTO
        select CRYPTO_SHA1
        select CRYPTO_ARC4
        select CRYPTO_ECB
(we seem to have both ARC4 and ECB explicitly)

>From net/sunrpc/Kconfig:

config RPCSEC_GSS_KRB5
        tristate "Secure RPC: Kerberos V mechanism"
        depends on SUNRPC && CRYPTO
        depends on CRYPTO_MD5 && CRYPTO_DES && CRYPTO_CBC && CRYPTO_CTS
        depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1 && CRYPTO_AES
        depends on CRYPTO_ARC4

>From drivers/crypto/Kconfig:

config CRYPTO_DEV_PICOXCELL
        tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
        depends on ARCH_PICOXCELL
        select CRYPTO_AES
        select CRYPTO_AUTHENC
        select CRYPTO_ALGAPI
        select CRYPTO_DES
        select CRYPTO_CBC
        select CRYPTO_ECB
        select CRYPTO_SEQIV

and others in 
 drivers/net/wireless/hostap/Kconfig
 drivers/net/wireless/ipw2x00/Kconfig 

Looks like none of them will be affected as they use explicitly. However,
it is not clear to me why they the crypto lib itself is not marking the
dependency..

>> On Fri, Jun 3, 2011 at 8:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On Fri, 03 Jun 2011 14:19:01 +0530
>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>
>>>> When CONFIG_CRYPTO_ECB is not set, trying to mount a CIFS share with NTLM
>>>> security resulted in mount failure with the following error:
>>>>    "CIFS VFS: could not allocate des crypto API"
>>>>
>>>> Seems like a leftover from commit 43988d7.
>>>>
>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>> ---
>>>>  fs/cifs/Kconfig |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>>>> index 1cd4c3a..66c68ab 100644
>>>> --- a/fs/cifs/Kconfig
>>>> +++ b/fs/cifs/Kconfig
>>>> @@ -7,6 +7,7 @@ config CIFS
>>>>       select CRYPTO_MD5
>>>>       select CRYPTO_HMAC
>>>>       select CRYPTO_ARC4
>>>> +     select CRYPTO_ECB
>>>>       select CRYPTO_DES
>>>>       help
>>>>         This is the client VFS module for the Common Internet File System
>>>
>>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>
>>
>>
>>
> 
> 


-- 
Suresh Jayaraman
