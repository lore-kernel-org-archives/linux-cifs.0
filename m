From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2.02 dialect support
Date: Wed, 10 Oct 2012 10:36:07 -0500
Message-ID: <CAH2r5mu6fft1Bvb1BB1mBJN6U4R-HQZgphV--Nkd5ukOt32VXA@mail.gmail.com>
References: <CAH2r5mtTeck3n4PF3Wb5XgwzZSHEtYw1skMj1MTY=+VugH1umA@mail.gmail.com>
	<20121010091856.70cef338@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121010091856.70cef338-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 10, 2012 at 8:18 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 9 Oct 2012 23:33:10 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This patch enables optional (via Kconfig, specifying vers=2.0 on
>> mount) support for testing SMB2.02 dialect
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 2075ddf..461e2f5 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -172,6 +172,21 @@ config CIFS_SMB2
>>
>>         Unless you are a developer or tester, say N.
>>
>> +config CIFS_SMB20_DIALECT
>> +       bool "Support for original SMB2.0 dialect (EXPERIMENTAL)"
>> +       depends on CIFS && CIFS_SMB2
>> +
>> +       help
>> +         This enables experimental support for the original SMB2.02 dialect.
>> +         This could be helpful for developers testing against the earliest
>> +            SMB2 capable servers such as Windows Vista, Samba Version 3.6
>> +         and Windows 2008.  Without this selection enabled, only the
>
>                 Might mention that that's win2k8r1 (or r0?). Damn MS
>                 and their confusing marketing... ;)
>
>                 I agree with Pavel though that it would be best to just do
>                 this without a new kconfig option, unless you have real
>                 concerns that this support is badly broken.

OK.  Makes the patch easier.  They can pick the vers=2.0 vs. 2.1 in any case.



-- 
Thanks,

Steve
