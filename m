From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: uninitialized variables in the 5.4 release
Date: Fri, 20 Apr 2012 11:06:28 +0530
Message-ID: <4F90F5DC.7070005@suse.com>
References: <20120419175242.GR12994@hip.fritz.box> <20120419140144.7b435b50@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Lars_M=FCller?= <lmuelle-IBi9RG/b67k@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419140144.7b435b50-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/19/2012 11:31 PM, Jeff Layton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On Thu, 19 Apr 2012 19:52:42 +0200
> Lars M=FCller <lmuelle-IBi9RG/b67k@public.gmane.org> wrote:
>=20
>> Hi,
>>
>> older gcc versions (4.3 in the case of SUSE Linux Enterprise 11 SP 1=
 and
>> SP 2) complain about uninitialized variables in the recent 5.4 relea=
se.
>>
>> The attached patch makes the build process a bit quieter.
>>
>> Cheers,
>>
>> Lars
>=20
> Looks reasonable if it silences the compiler warnings on older gcc,
> even if it's not really a bug per-se. I do wonder if there's some
> annotation you can add to silence that warning, but it's probably not
> worth worrying about.

Yes, annotation is perhaps not worth it. This patch and the other build
fixes from Lars looks good to me.

Acked-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>

> I'll commit it in the next few days if no one objects...=20
