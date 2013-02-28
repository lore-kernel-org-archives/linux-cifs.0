From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FIPS mode in the kernel break CIFS mounts?
Date: Thu, 28 Feb 2013 09:10:28 -0600
Message-ID: <CAH2r5mttfG6o7Nnz+uh7yW6jh8S4TCg2A43DGvgt36cBQ_57dA@mail.gmail.com>
References: <512F027E.2030902@novell.com>
	<20130228070245.6152ab77@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130228070245.6152ab77-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 28, 2013 at 9:02 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 28 Feb 2013 12:38:46 +0530
> Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Hi all,
>>
>> I was told that (haven't checked myself, yet) that booting in FIPS
>> (Federal Information Processing Standard) mode by adding "fips=1" to
>> grub.conf breaks CIFS mounts by returning -ENOENT.
>>
>> I thought I'd ask if this is a known problem before I spend more time on
>> this.
>>
>>
>> Thanks
>>
>
> Yep, known problem. We try to load several crypto routines during the
> mount process, and that fails in FIPS mode since they aren't allowed.
> The fix is to only load those routines once we know that we actually
> need them and only fail in those cases. There are no patches for that
> yet, AFAIK.
>
> Note that enabling FIPS mode will almost certainly break both NTLMv1
> and NTLMv2 auth, since those require md4 and md5. It might be nice to
> update the manpage with what sec= options actually work after enabling
> FIPS mode once the main problem is fixed.

Any good reference to this?  Would be good to track this via a bug report.
Although presumably we would be fine with SMB2/SMB3 and krb5,
it wasn't immediately obvious to me why MD5 would not be allowed since
I see it in various lists of FIPS algorithm certifications but not for
RHEL 6.2 which listed the following:

-FIPS-approved algorithms: AES (Certs. #1968, #1969, #1970, #1971 and
#1972); Triple-DES (Certs. #1278 and #1279); SHS (Certs. #1725 and
#1726); HMAC (Certs. #1187, #1188, #1199 and #1200); RNG (Certs.
#1033, #1034, #1035, #1036 and #1037); DSA (Certs #628, #629, #634 and
#635)


-- 
Thanks,

Steve
