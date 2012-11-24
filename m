From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upgrading security default
Date: Sat, 24 Nov 2012 10:55:53 -0600
Message-ID: <CAH2r5muU+mK13D-u6ca4sWfvpeP1EdMaxoeX0+5g-v6gu4+_Mw@mail.gmail.com>
References: <CAH2r5mtPAwURZxTeRBfn+c=hNyeaDbmKbYXt=w3VkUu5i1cxNQ@mail.gmail.com>
	<20121123204136.5466f0e9@corrin.poochiereds.net>
	<CAH2r5msv_gp8Vpx82zA084awe++kFd5S3X7==6K2g6c7jBhCOg@mail.gmail.com>
	<20121124061135.317ea3e8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121124061135.317ea3e8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Nov 24, 2012 at 5:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 23 Nov 2012 20:48:40 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> it doesn't change security flags - but it seemed the smallest and
>> safest since it basically says:
>> 1) if you pass in "sec=" then use that
>> 2) otherwise use ntlmssp (with ntlmv2)
>>
>> so shouldn't have any unintended consequences (and the sign mount
>> option should work as expected as well)
>>
>
> Umm...I think it would. The story for people who need to mount using
> cleartext passwords has always been "Set SecurityFlags to a magic value
> and mount without a sec= option". With your original patch, that would
> have broken them, AFAICT.

originally it was supposed to be mount with sec=none (after the
administrator configured the system to allow weak passwords via the
global configuration flag).  We clearly do not want to allow plaintext
passwords to be sent over the network unless the user/admin really
knows what they are doing.

>> To be more specific: do you prefer this
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index f5af252..2cd5ea2 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -1362,7 +1362,7 @@ require use of the stronger protocol */
>>  #define   CIFSSEC_MUST_SEAL    0x40040 /* not supported yet */
>>  #define   CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp with ntlmv2 */
>>
>> -#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM |
>> CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
>> +#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMSSP)
>>  #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
>>  #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 |
>> CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_
>>  /*
>>
>
> I think so -- that looks like it won't break existing users who need to
> set SecurityFlags to mount particular servers. You should also have
> this patch remove the now-bogus warning at mount time though.

Yes - that is the same in both patches.

> As non-sensical as the SecurityFlags interface is, we're stuck with it
> for now. For the longer term, I'd like to start deprecating the
> SecurityFlags interface altogether. I'll plan to write up a
> comprehensive proposal for doing that soon.

I don't mind removing security flags - but we need a way for cifs at
module load time (or some after) to read a set of (administrator
configurable) system wide security defaults (similar to registry
configuration, or smb.conf for Samba) - I don't know the best way to
do this (or way consistent with how other modules do it).

-- 
Thanks,

Steve
