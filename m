From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Fri, 1 Jul 2016 11:02:36 -0500
Message-ID: <CAH2r5msY5dA1z+mKoQHLn1gg=V4QyJJS8+C3-jCQ08t0LC1kdw@mail.gmail.com>
References: <20160527194346.08416d79@aaptelpc> <20160609185027.7349f260@aaptelpc>
 <5759C326.5040508@fu-berlin.de> <20160610171649.3e12b95c@aaptelpc> <57768FC3.7020102@fu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57768FC3.7020102-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I will take a look later today.

On Fri, Jul 1, 2016 at 10:44 AM, Marcus Hoffmann
<marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
> On 06/10/2016 05:16 PM, Aur=C3=A9lien Aptel wrote:
>> On Thu, 9 Jun 2016 21:27:34 +0200 Marcus Hoffmann
>> <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
>>> Hey Aur=C3=A9lien,
>>> with your script I can reproduce the bug locally now.
>>
>> Good.
>>
>>> I can mount the share (which is on a Windows 8.1 vm) with a Windows=
 7
>>> PC with the restricted user account. (Even in hard mode.)
>>> I can mount the share from Linux-cifs using the admin user but not =
the
>>> restricted user.
>>
>> I've moved some things around. All of the prefix path components are
>> now checked for accessibility in cifs_do_mount(). This is more
>> robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag earlie=
r.
>>
>> I've updated the cifs_root_iget() to use the prefix path when necess=
ary
>> which should take care of the last case (hard mode).
>>
>> Please test my latest patch (attached).
>>
> I just wanted to ask what can be done to get this merged.
>
>>> (I noticed though that no user has access to the file in the shared
>>> dir. But this doesn't really matter for the test.)
>>
>> Indeed.
>>
>
> Marcus



--=20
Thanks,

Steve
