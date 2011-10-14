From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Fri, 14 Oct 2011 17:38:59 -0500
Message-ID: <CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw@mail.gmail.com>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
	<20111014211214.GA15319@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111014211214.GA15319-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 14, 2011 at 4:12 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> On Thu, Oct 13, 2011 at 05:23:52PM -0500, Steve French wrote:
>> I like Pavel's lock cleanup (1st patch of series) so far, am
>> continuing to review it, but I also noticed a few things that we nee=
d
>> to do in the future. This line of code:
>>
>> =A0 =A0 =A0 if (flock->fl_flags & FL_LEASE)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Lease on file - not implemented=
 yet");
>>
>> reminded me that we should check if we need to implement this (in ci=
fs
>> we can return yes if we have a lease already (oplock), but in smb2.1
>> and later we can request a lease or an upgrade to an existing one, o=
n
>> the fly).
>
> And you'll also need to make sure you call break_lease() when you fin=
d
> out it's broken.
>
> A description of the smb (1/2/2.1) oplock and lease semantics would b=
e
> useful--I'm curious whether they're really a good fit for the linux
> vfs's lease semantics.

I can probably dig up the exact references in MS-CIFS.pdf and MS-SMB2.p=
df
but basically SMB2 (original dialect) and CIFS have similar semantics (=
and
Samba's need to implement CIFS oplocks drove the original implementatio=
n
of leases in the kernel, although it is requested at open time via a fl=
ag,
not after open as a handle based call).  The problem comes in with smb2=
=2E1
which adds the ability to reaquire leases (which may be ok) and upgrade
leases (from read only to readwrite) and to reuse an existing lease
(so the 2nd open from the same client doesn't have to break oplock)
which helps Linux which has a common cache manager.

smb2.2 adds the ability to do directory leases (to cache directory
entries)


--=20
Thanks,

Steve
